/mob/living/carbon/Initialize()
	. = ..()
	//setup reagent holders
	bloodstr = new/datum/reagents/metabolism/bloodstream(500, src)
	ingested = new/datum/reagents/metabolism/ingested(500, src)
	touching = new/datum/reagents/metabolism/touch(500, src)
	reagents = bloodstr
	if (!default_language && species_language)
		default_language = GLOB.all_languages[species_language]

/mob/living/carbon/Life()
	..()

	handle_viruses()

	// Increase germ_level regularly
	if(germ_level < GERM_LEVEL_AMBIENT && prob(30))	//if you're just standing there, you shouldn't get more germs beyond an ambient level
		germ_level++

/mob/living/carbon/Destroy()
	qdel(ingested)
	qdel(touching)
	// We don't qdel(bloodstr) because it's the same as qdel(reagents)
	for(var/guts in internal_organs)
		qdel(guts)
	for(var/food in stomach_contents)
		qdel(food)
	return ..()

/mob/living/carbon/rejuvenate()
	bloodstr.clear_reagents()
	ingested.clear_reagents()
	touching.clear_reagents()
	..()
/* VOREStation Edit - Duplicated in our code
/mob/living/carbon/Moved(atom/old_loc, direction, forced = FALSE)
	. = ..()
	if(src.nutrition && src.stat != 2)
		adjust_nutrition(-DEFAULT_HUNGER_FACTOR / 10)
		if(src.m_intent == "run")
			adjust_nutrition(-DEFAULT_HUNGER_FACTOR / 10)

	if((FAT in src.mutations) && src.m_intent == "run" && src.bodytemperature <= 360)
		src.bodytemperature += 2

	// Moving around increases germ_level faster
	if(germ_level < GERM_LEVEL_MOVE_CAP && prob(8))
		germ_level++

/mob/living/carbon/relaymove(var/mob/living/user, direction)
	if((user in src.stomach_contents) && istype(user))
		if(user.last_special <= world.time)
			user.last_special = world.time + 50
			src.visible_message("<span class='danger'>You hear something rumbling inside [src]'s stomach...</span>")
			var/obj/item/I = user.get_active_hand()
			if(I && I.force)
				var/d = rand(round(I.force / 4), I.force)
				if(istype(src, /mob/living/carbon/human))
					var/mob/living/carbon/human/H = src
					var/obj/item/organ/external/organ = H.get_organ(BP_TORSO)
					if (istype(organ))
						if(organ.take_damage(d, 0))
							H.UpdateDamageIcon()
					H.updatehealth()
				else
					src.take_organ_damage(d)
				user.visible_message("<span class='danger'>[user] attacks [src]'s stomach wall with the [I.name]!</span>")
				playsound(user, 'sound/effects/attackblob.ogg', 50, 1)

				if(prob(src.getBruteLoss() - 50))
					for(var/atom/movable/A in stomach_contents)
						A.loc = loc
						stomach_contents.Remove(A)
					src.gib()
*/
/mob/living/carbon/gib()
	for(var/mob/M in src)
		if(M in src.stomach_contents)
			src.stomach_contents.Remove(M)
		M.loc = src.loc
		for(var/mob/N in viewers(src, null))
			if(N.client)
				N.show_message(text("<font color='red'><B>[M] bursts out of [src]!</B></font>"), 2)
	..()

/mob/living/carbon/attack_hand(mob/M as mob)
	if(!istype(M, /mob/living/carbon)) return
	if (ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/external/temp = H.organs_by_name["r_hand"]
		if (H.hand)
			temp = H.organs_by_name["l_hand"]
		if(temp && !temp.is_usable())
			to_chat(H, "<font color='red'>You can't use your [temp.name]</font>")
			return

	return

//EMP vulnerability for non-synth carbons. could be useful for diona, vox, or others
//the species' emp_sensitivity var needs to be greater than 0 for this to proc, and it defaults to 0 - shouldn't stack with prosthetics/fbps in most cases
//higher sensitivity values incur additional effects, starting with confusion/blinding/knockdown and ending with increasing amounts of damage
//the degree of damage and duration of effects can be tweaked up or down based on the species emp_dmg_mod and emp_stun_mod vars (default 1) on top of tuning the random ranges
/mob/living/carbon/emp_act(severity)
	//pregen our stunning stuff, had to do this seperately or else byond complained. remember that severity falls off with distance based on the source, so we don't need to do any extra distance calcs here.
	var/agony_str = ((rand(4,6)*15)-(15*severity))*species.emp_stun_mod //big ouchies at high severity, causes 0-75 halloss/agony; shotgun beanbags and revolver rubbers do 60
	var/deafen_dur = (rand(9,16)-severity)*species.emp_stun_mod //5-15 deafen, on par with a flashbang
	var/confuse_dur = (rand(4,11)-severity)*species.emp_stun_mod //0-10 wobbliness, on par with a flashbang
	var/weaken_dur = (rand(2,4)-severity)*species.emp_stun_mod //0-3 knockdown, on par with.. you get the idea
	var/blind_dur = (rand(3,6)-severity)*species.emp_stun_mod //0-5 blind
	if(species.emp_sensitivity) //receive warning message and basic effects
		to_chat(src, "<span class='danger'><B>*BZZZT*</B></span>")
		switch(severity)
			if(1)
				to_chat(src, "<span class='danger'>DANGER: Extreme EM flux detected!</span>")
			if(2)
				to_chat(src, "<span class='danger'>Danger: High EM flux detected!</span>")
			if(3)
				to_chat(src, "<span class='danger'>Warning: Moderate EM flux detected!</span>")
			if(4)
				to_chat(src, "<span class='danger'>Warning: Minor EM flux detected!</span>")
		if(prob(90-(10*severity))) //50-80% chance to fire an emote. most are harmless, but vomit might reduce your nutrition level which could suck (so the whole thing is padded out with extras)
			src.emote(pick("twitch", "twitch_v", "choke", "pale", "blink", "blink_r", "shiver", "sneeze", "vomit", "gasp", "cough", "drool"))
		//stun effects block, effects vary wildly
		if(species.emp_sensitivity & EMP_PAIN)
			to_chat(src, "<span class='danger'>A wave of intense pain washes over you.</span>")
			src.adjustHalLoss(agony_str)
		if(species.emp_sensitivity & EMP_BLIND)
			if(blind_dur >= 1) //don't flash them unless they actually roll a positive blind duration
				src.flash_eyes(3)	//3 allows it to bypass any tier of eye protection, necessary or else sec sunglasses/etc. protect you from this
			Blind(max(0,blind_dur))
		if(species.emp_sensitivity & EMP_DEAFEN)
			src.ear_damage += rand(0,deafen_dur) //this will heal pretty quickly, but spamming them at someone could cause serious damage
			src.ear_deaf = max(src.ear_deaf,deafen_dur)
		if(species.emp_sensitivity & EMP_CONFUSE)
			if(confuse_dur >= 1)
				to_chat(src, "<span class='danger'>Oh god, everything's spinning!</span>")
			Confuse(max(0,confuse_dur))
		if(species.emp_sensitivity & EMP_WEAKEN)
			if(weaken_dur >= 1)
				to_chat(src, "<span class='danger'>Your limbs go slack!</span>")
			Weaken(max(0,weaken_dur))
		//physical damage block, deals (minor-4) 5-15, 10-20, 15-25, 20-30 (extreme-1) of *each* type
		if(species.emp_sensitivity & EMP_BRUTE_DMG)
			src.adjustBruteLoss(rand(25-(severity*5),35-(severity*5)) * species.emp_dmg_mod)
		if(species.emp_sensitivity & EMP_BURN_DMG)
			src.adjustFireLoss(rand(25-(severity*5),35-(severity*5)) * species.emp_dmg_mod)
		if(species.emp_sensitivity & EMP_TOX_DMG)
			src.adjustToxLoss(rand(25-(severity*5),35-(severity*5)) * species.emp_dmg_mod)
		if(species.emp_sensitivity & EMP_OXY_DMG)
			src.adjustOxyLoss(rand(25-(severity*5),35-(severity*5)) * species.emp_dmg_mod)
	..()

/mob/living/carbon/electrocute_act(var/shock_damage, var/obj/source, var/siemens_coeff = 1.0, var/def_zone = null, var/stun = 1)
	if(status_flags & GODMODE)	return 0	//godmode
	if(def_zone == "l_hand" || def_zone == "r_hand") //Diona (And any other potential plant people) hands don't get shocked.
		if(species.flags & IS_PLANT)
			return 0
	shock_damage *= siemens_coeff
	if (shock_damage<1)
		return 0

	src.apply_damage(0.2 * shock_damage, BURN, def_zone, used_weapon="Electrocution") //shock the target organ
	src.apply_damage(0.4 * shock_damage, BURN, BP_TORSO, used_weapon="Electrocution") //shock the torso more
	src.apply_damage(0.2 * shock_damage, BURN, null, used_weapon="Electrocution") //shock a random part!
	src.apply_damage(0.2 * shock_damage, BURN, null, used_weapon="Electrocution") //shock a random part!

	playsound(src, "sparks", 50, 1, -1)
	if (shock_damage > 15)
		src.visible_message(
			"<span class='warning'>[src] was electrocuted[source ? " by the [source]" : ""]!</span>", \
			"<span class='danger'>You feel a powerful shock course through your body!</span>", \
			"<span class='warning'>You hear a heavy electrical crack.</span>" \
		)
	else
		src.visible_message(
			"<span class='warning'>[src] was shocked[source ? " by the [source]" : ""].</span>", \
			"<span class='warning'>You feel a shock course through your body.</span>", \
			"<span class='warning'>You hear a zapping sound.</span>" \
		)

	if(stun)
		switch(shock_damage)
			if(16 to 20)
				Stun(2)
			if(21 to 25)
				Weaken(2)
			if(26 to 30)
				Weaken(5)
			if(31 to INFINITY)
				Weaken(10) //This should work for now, more is really silly and makes you lay there forever

	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(5, 1, loc)
	s.start()

	return shock_damage

/mob/living/carbon/proc/help_shake_act(mob/living/carbon/M)
	if (src.health >= config.health_threshold_crit)
		if(src == M && istype(src, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = src
			var/datum/gender/T = gender_datums[H.get_visible_gender()]
			src.visible_message( \
				"<span class='notice'>[src] examines [T.himself].</span>", \
				"<span class='notice'>You check yourself for injuries.</span>" \
				)

			for(var/obj/item/organ/external/org in H.organs)
				var/list/status = list()
				var/brutedamage = org.brute_dam
				var/burndamage = org.burn_dam
				/*
				if(halloss > 0) //Makes halloss show up as actual wounds on self examine.
					if(prob(30))
						brutedamage += halloss
					if(prob(30))
						burndamage += halloss
				*/
				switch(brutedamage)
					if(1 to 20)
						status += "bruised"
					if(20 to 40)
						status += "wounded"
					if(40 to INFINITY)
						status += "mangled"

				switch(burndamage)
					if(1 to 10)
						status += "numb"
					if(10 to 40)
						status += "blistered"
					if(40 to INFINITY)
						status += "peeling away"

				if(org.is_stump())
					status += "MISSING"
				if(org.status & ORGAN_MUTATED)
					status += "weirdly shapen"
				if(org.dislocated == 1) //VOREStation Edit Bugfix
					status += "dislocated"
				if(org.status & ORGAN_BROKEN)
					status += "hurts when touched"
				if(org.status & ORGAN_DEAD)
					status += "is bruised and necrotic"
				if(!org.is_usable() || org.is_dislocated())
					status += "dangling uselessly"
				if(status.len)
					src.show_message("My [org.name] is <span class='warning'> [english_list(status)].</span>",1)
				else
					src.show_message("My [org.name] is <span class='notice'> OK.</span>",1)

			if((SKELETON in H.mutations) && (!H.w_uniform) && (!H.wear_suit))
				H.play_xylophone()
		else if (on_fire)
			playsound(src, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
			if (M.on_fire)
				M.visible_message("<span class='warning'>[M] tries to pat out [src]'s flames, but to no avail!</span>",
				"<span class='warning'>You try to pat out [src]'s flames, but to no avail! Put yourself out first!</span>")
			else
				M.visible_message("<span class='warning'>[M] tries to pat out [src]'s flames!</span>",
				"<span class='warning'>You try to pat out [src]'s flames! Hot!</span>")
				if(do_mob(M, src, 15))
					src.adjust_fire_stacks(-0.5)
					if (prob(10) && (M.fire_stacks <= 0))
						M.adjust_fire_stacks(1)
					M.IgniteMob()
					if (M.on_fire)
						M.visible_message("<span class='danger'>The fire spreads from [src] to [M]!</span>",
						"<span class='danger'>The fire spreads to you as well!</span>")
					else
						src.adjust_fire_stacks(-0.5) //Less effective than stop, drop, and roll - also accounting for the fact that it takes half as long.
						if (src.fire_stacks <= 0)
							M.visible_message("<span class='warning'>[M] successfully pats out [src]'s flames.</span>",
							"<span class='warning'>You successfully pat out [src]'s flames.</span>")
							src.ExtinguishMob()
							src.fire_stacks = 0
		else
			if (istype(src,/mob/living/carbon/human) && src:w_uniform)
				var/mob/living/carbon/human/H = src
				H.w_uniform.add_fingerprint(M)

			var/show_ssd
			var/mob/living/carbon/human/H = src
			var/datum/gender/T = gender_datums[H.get_visible_gender()] // make sure to cast to human before using get_gender() or get_visible_gender()!
			if(istype(H)) show_ssd = H.species.show_ssd
			if(show_ssd && !client && !teleop)
				M.visible_message("<span class='notice'>[M] shakes [src] trying to wake [T.him] up!</span>", \
				"<span class='notice'>You shake [src], but [T.he] [T.does] not respond... Maybe [T.he] [T.has] S.S.D?</span>")
			else if(lying || src.sleeping)
				AdjustSleeping(-5)
				if(src.sleeping == 0)
					src.resting = 0
				if(H) H.in_stasis = 0 //VOREStation Add - Just In Case
				M.visible_message("<span class='notice'>[M] shakes [src] trying to wake [T.him] up!</span>", \
									"<span class='notice'>You shake [src] trying to wake [T.him] up!</span>")
			else
				var/mob/living/carbon/human/hugger = M
				var/datum/gender/TM = gender_datums[M.get_visible_gender()]
				if(M.resting == 1) //Are they resting on the ground?
					M.visible_message("<span class='notice'>[M] grabs onto [src] and pulls [TM.himself] up</span>", \
							"<span class='notice'>You grip onto [src] and pull yourself up off the ground!</span>")
					if(M.fire_stacks >= (src.fire_stacks + 3)) //Fire checks.
						src.adjust_fire_stacks(1)
						M.adjust_fire_stacks(-1)
					if(M.on_fire)
						src.IgniteMob()
					if(do_after(M, 0.5 SECONDS)) //.5 second delay. Makes it a bit stronger than just typing rest.
						M.resting = 0 //Hoist yourself up up off the ground. No para/stunned/weakened removal.
				else if(istype(hugger))
					hugger.species.hug(hugger,src)
				else
					M.visible_message("<span class='notice'>[M] hugs [src] to make [T.him] feel better!</span>", \
								"<span class='notice'>You hug [src] to make [T.him] feel better!</span>")
				if(M.fire_stacks >= (src.fire_stacks + 3))
					src.adjust_fire_stacks(1)
					M.adjust_fire_stacks(-1)
				if(M.on_fire)
					src.IgniteMob()
			AdjustParalysis(-3)
			AdjustStunned(-3)
			AdjustWeakened(-3)

			playsound(src, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)

/mob/living/carbon/proc/eyecheck()
	return 0

/mob/living/carbon/flash_eyes(intensity = FLASH_PROTECTION_MODERATE, override_blindness_check = FALSE, affect_silicon = FALSE, visual = FALSE, type = /obj/screen/fullscreen/flash)
	if(eyecheck() < intensity || override_blindness_check)
		return ..()

// ++++ROCKDTBEN++++ MOB PROCS -- Ask me before touching.
// Stop! ... Hammertime! ~Carn

/mob/living/carbon/proc/getDNA()
	return dna

/mob/living/carbon/proc/setDNA(var/datum/dna/newDNA)
	dna = newDNA

// ++++ROCKDTBEN++++ MOB PROCS //END

/mob/living/carbon/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	..()
	var/temp_inc = max(min(BODYTEMP_HEATING_MAX*(1-get_heat_protection()), exposed_temperature - bodytemperature), 0)
	bodytemperature += temp_inc

/mob/living/carbon/can_use_hands()
	if(handcuffed)
		return 0
	if(buckled && istype(buckled, /obj/structure/bed/nest)) // buckling does not restrict hands
		return 0
	return 1

/mob/living/carbon/restrained()
	if (handcuffed)
		return 1
	return

/mob/living/carbon/u_equip(obj/item/W as obj)
	if(!W)	return 0

	else if (W == handcuffed)
		handcuffed = null
		update_handcuffed()
		if(buckled && buckled.buckle_require_restraints)
			buckled.unbuckle_mob()

	else if (W == legcuffed)
		legcuffed = null
		update_inv_legcuffed()
	else
		..()


//generates realistic-ish pulse output based on preset levels
/mob/living/carbon/proc/get_pulse(var/method)	//method 0 is for hands, 1 is for machines, more accurate
	var/temp = 0								//see setup.dm:694
	switch(src.pulse)
		if(PULSE_NONE)
			return "0"
		if(PULSE_SLOW)
			temp = rand(40, 60)
			return num2text(method ? temp : temp + rand(-10, 10))
		if(PULSE_NORM)
			temp = rand(60, 90)
			return num2text(method ? temp : temp + rand(-10, 10))
		if(PULSE_FAST)
			temp = rand(90, 120)
			return num2text(method ? temp : temp + rand(-10, 10))
		if(PULSE_2FAST)
			temp = rand(120, 160)
			return num2text(method ? temp : temp + rand(-10, 10))
		if(PULSE_THREADY)
			return method ? ">250" : "extremely weak and fast, patient's artery feels like a thread"
//			output for machines^	^^^^^^^output for people^^^^^^^^^

/mob/living/carbon/verb/mob_sleep()
	set name = "Sleep"
	set category = "IC"

	if(usr.sleeping)
		to_chat(usr, "<font color='red'>You are already sleeping</font>")
		return
	if(tgui_alert(src,"You sure you want to sleep for a while?","Sleep",list("Yes","No")) == "Yes")
		usr.AdjustSleeping(20)

/mob/living/carbon/Bump(atom/A)
	if(now_pushing)
		return
	..()
	if(istype(A, /mob/living/carbon) && prob(10))
		spread_disease_to(A, "Contact")

/mob/living/carbon/cannot_use_vents()
	return

/mob/living/carbon/slip(var/slipped_on,stun_duration=8)
	if(buckled)
		return 0
	stop_pulling()
	to_chat(src, "<span class='warning'>You slipped on [slipped_on]!</span>")
	playsound(src, 'sound/misc/slip.ogg', 50, 1, -3)
	Weaken(FLOOR(stun_duration/2, 1))
	return 1

/mob/living/carbon/proc/add_chemical_effect(var/effect, var/magnitude = 1)
	if(effect in chem_effects)
		chem_effects[effect] += magnitude
	else
		chem_effects[effect] = magnitude

/mob/living/carbon/proc/remove_chemical_effect(var/effect, var/magnitude)
	if(effect in chem_effects)
		chem_effects[effect] = magnitude ? max(0,chem_effects[effect]-magnitude) : 0

/mob/living/carbon/get_default_language()
	if(default_language)
		if(can_speak(default_language))
			return default_language
		else
			return GLOB.all_languages[LANGUAGE_GIBBERISH]

	if(!species)
		return GLOB.all_languages[LANGUAGE_GIBBERISH]

	return species.default_language ? GLOB.all_languages[species.default_language] : GLOB.all_languages[LANGUAGE_GIBBERISH]

/mob/living/carbon/proc/should_have_organ(var/organ_check)
	return 0

/mob/living/carbon/can_feel_pain(var/check_organ)
	if(isSynthetic())
		return 0
	return !(species.flags & NO_PAIN)

/mob/living/carbon/needs_to_breathe()
	if(does_not_breathe)
		return FALSE
	return ..()

/mob/living/carbon/proc/update_handcuffed()
	if(handcuffed)
		drop_l_hand()
		drop_r_hand()
		stop_pulling()
		throw_alert("handcuffed", /obj/screen/alert/restrained/handcuffed, new_master = handcuffed)
	else
		clear_alert("handcuffed")
	update_action_buttons() //some of our action buttons might be unusable when we're handcuffed.
	update_inv_handcuffed()

// Clears blood overlays
/mob/living/carbon/clean_blood()
	. = ..()
	if(src.r_hand)
		src.r_hand.clean_blood()
	if(src.l_hand)
		src.l_hand.clean_blood()
	if(src.back)
		if(src.back.clean_blood())
			src.update_inv_back(0)

	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		var/washgloves = 1
		var/washshoes = 1
		var/washmask = 1
		var/washears = 1
		var/washglasses = 1

		if(H.wear_suit)
			washgloves = !(H.wear_suit.flags_inv & HIDEGLOVES)
			washshoes = !(H.wear_suit.flags_inv & HIDESHOES)

		if(H.head)
			washmask = !(H.head.flags_inv & HIDEMASK)
			washglasses = !(H.head.flags_inv & HIDEEYES)
			washears = !(H.head.flags_inv & HIDEEARS)

		if(H.wear_mask)
			if (washears)
				washears = !(H.wear_mask.flags_inv & HIDEEARS)
			if (washglasses)
				washglasses = !(H.wear_mask.flags_inv & HIDEEYES)

		if(H.head)
			if(H.head.clean_blood())
				H.update_inv_head()

		if(H.wear_suit)
			if(H.wear_suit.clean_blood())
				H.update_inv_wear_suit()

		else if(H.w_uniform)
			if(H.w_uniform.clean_blood())
				H.update_inv_w_uniform()

		if(H.gloves && washgloves)
			if(H.gloves.clean_blood())
				H.update_inv_gloves(0)

		if(H.shoes && washshoes)
			if(H.shoes.clean_blood())
				H.update_inv_shoes(0)

		if(H.wear_mask && washmask)
			if(H.wear_mask.clean_blood())
				H.update_inv_wear_mask(0)

		if(H.glasses && washglasses)
			if(H.glasses.clean_blood())
				H.update_inv_glasses(0)

		if(H.l_ear && washears)
			if(H.l_ear.clean_blood())
				H.update_inv_ears(0)

		if(H.r_ear && washears)
			if(H.r_ear.clean_blood())
				H.update_inv_ears(0)

		if(H.belt)
			if(H.belt.clean_blood())
				H.update_inv_belt(0)

	else
		if(src.wear_mask)						//if the mob is not human, it cleans the mask without asking for bitflags
			if(src.wear_mask.clean_blood())
				src.update_inv_wear_mask(0)
<<<<<<< HEAD
=======

/mob/living/carbon/handle_reagent_transfer(var/datum/reagents/holder, var/amount = 1, var/chem_type = CHEM_BLOOD, var/multiplier = 1, var/copy = 0)
	if(chem_type == CHEM_BLOOD)
		return holder.trans_to_holder(reagents, amount, multiplier, copy)
	if(chem_type == CHEM_INGEST)
		return ingest(holder, ingested, amount, multiplier, copy)
	if(chem_type == CHEM_TOUCH)
		return holder.trans_to_holder(touching, amount, multiplier, copy)
>>>>>>> 8ce2659f02a... Merge pull request #8693 from MistakeNot4892/doggo
