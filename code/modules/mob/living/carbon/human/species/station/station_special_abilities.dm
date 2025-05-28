


/mob/living/carbon/human/proc/hasnutriment()
	if (bloodstr.has_reagent(REAGENT_ID_NUTRIMENT, 30) || src.bloodstr.has_reagent(REAGENT_ID_PROTEIN, 15)) //protein needs half as much. For reference, a steak contains 9u protein.
		return TRUE
	else if (ingested.has_reagent(REAGENT_ID_NUTRIMENT, 60) || src.ingested.has_reagent(REAGENT_ID_PROTEIN, 30)) //try forcefeeding them, why not. Less effective.
		return TRUE
	else return FALSE

/mob/living/carbon/human/proc/quickcheckuninjured()
	if (getBruteLoss() || getFireLoss() || getHalLoss() || getToxLoss() || getOxyLoss() || getBrainLoss()) //fails if they have any of the main damage types
		return FALSE
	for (var/obj/item/organ/O in organs) //check their organs just in case they're being sneaky and somehow have organ damage but no health damage
		if (O.is_damaged() || O.status)
			return FALSE
	for (var/obj/item/organ/O in internal_organs) //check their organs just in case they're being sneaky and somehow have organ damage but no health damage
		if (O.is_damaged() || O.status)
			return FALSE
	return TRUE

/mob/living/carbon/human/proc/getlightlevel() //easier than having the same code in like three places
	if(isturf(src.loc)) //else, there's considered to be no light
		var/turf/T = src.loc
		return T.get_lumcount() * 5
	else return 0

/mob/living/carbon/human/proc/bloodsuck()
	set name = "Partially Drain prey of blood"
	set desc = "Bites prey and drains them of a significant portion of blood, feeding you in the process. You may only do this once per minute."
	set category = "Abilities.General"


	if(stat || paralysis || stunned || weakened || lying || restrained() || buckled)
		to_chat(src, "You cannot bite anyone in your current state!")
		return

	var/list/choices = list()
	for(var/mob/living/carbon/human/M in view(1,src))
		if(!istype(M,/mob/living/silicon) && Adjacent(M))
			choices += M


	var/mob/living/carbon/human/B = tgui_input_list(src, "Who do you wish to bite? Select yourself to bring up configuration for privacy and bleeding. \
	Beware! Configuration resets on new round!", "Suck Blood", choices)

	if(B == src) //We are using this to minimize the amount of pop-ups or buttons.
		var/control_options = list("always loud", "pop-up", "intents", "always subtle")
		src.species.bloodsucker_controlmode = tgui_input_list(src,"Choose your preferred control of blood sucking. \
		You can only cause bleeding wounds with pop up and intents modes. Choosing intents prints controls to chat.", "Configure Bloodsuck", control_options, "always loud")
		if(src.species.bloodsucker_controlmode == "intents") //We are printing to chat for better readability
			to_chat(src, span_notice("You've chosen to use intents for blood draining. \n \
			HELP - Loud, No Bleeding \n \
			DISARM - Subtle, Causes bleeding \n \
			GRAB - Subtle, No Bleeding \n \
			HARM - Loud, Causes Bleeding"))
		return

	if(last_special > world.time)
		to_chat(src, "You cannot suck blood so quickly in a row!")
		return


	if(!B || !src || src.stat) return

	if(!Adjacent(B)) return

	if(last_special > world.time) return

	if(stat || paralysis || stunned || weakened || lying || restrained() || buckled)
		to_chat(src, "You cannot bite in your current state.")
		return
	if(B.vessel.total_volume <= 0 || B.isSynthetic()) //Do they have any blood in the first place, and are they synthetic?
		to_chat(src, span_red("There appears to be no blood in this prey..."))
		return

	last_special = world.time + 600

	var/control_pref = src.species.bloodsucker_controlmode
	var/noise = TRUE
	var/bleed = FALSE

	switch(control_pref)
		if("always subtle")
			noise = FALSE
		if("pop-up")
			if(tgui_alert(src, "Do you want to be subtle?", "Privacy", list("Yes", "No")) == "Yes")
				noise = FALSE
			if(tgui_alert(src, "Do you want your target to keep bleeding?", "Continue Bleeding", list("Yes", "No")) == "Yes" )
				bleed = TRUE
		if("intents")
			/*
			Logic is, with "Help", we are taking our time but it's pretty obvious..
			With "disarm", we rush the act, letting it keep bleeding
			"HURT" is self-evidently loud and bleedy
			"Grab" is subtle because we keep our prey tight and close.
			*/
			switch(src.a_intent)
				//if(I_HELP) uses default values. Added as a comment for clarity
				if(I_DISARM)
					noise = FALSE
					bleed = TRUE
				if(I_GRAB)
					noise = FALSE
				if(I_HURT)
					bleed =TRUE




	if(noise)
		src.visible_message(span_infoplain(span_red(span_bold("[src] moves their head next to [B]'s neck, seemingly looking for something!"))))
	else
		src.visible_message(span_infoplain(span_red(span_italics("[src] moves their head next to [B]'s neck, seemingly looking for something!"))), range = 1)

	if(bleed) //Due to possibility of missing/misclick and missing the bleeding cues, we are warning the scene members of BLEEDING being on
		to_chat(src, span_warning("This is going to cause [B] to keep bleeding!"))
		to_chat(B, span_danger("You are going to keep bleeding from this bite!"))

	if(do_after(src, 300, B)) //Thrirty seconds.
		if(!Adjacent(B)) return
		if(noise)
			src.visible_message(span_infoplain(span_red(span_bold("[src] suddenly extends their fangs and plunges them down into [B]'s neck!"))))
		else
			src.visible_message(span_infoplain(span_red(span_italics("[src] suddenly extends their fangs and plunges them down into [B]'s neck!"))), range = 1)
		if(bleed)
			B.apply_damage(10, BRUTE, BP_HEAD, blocked = 0, soaked = 0, sharp = TRUE, edge = FALSE)
			var/obj/item/organ/external/E = B.get_organ(BP_HEAD)
			if(!(E.status & ORGAN_BLEEDING))
				E.status |= ORGAN_BLEEDING //If 10 points of piercing didn't make the organ bleed, we are making it bleed.


		else
			B.apply_damage(5, BRUTE, BP_HEAD) //You're getting fangs pushed into your neck. What do you expect????


		if(!noise && !bleed) //If we're quiet and careful, there should be no blood to serve as evidence
			B.remove_blood(82) //Removing in one go since we dont want splatter
			adjust_nutrition(410) //We drink it all, not letting any go to waste!
		else //Otherwise, we're letting blood drop to the floor
			B.drip(80) //Remove enough blood to make them a bit woozy, but not take oxyloss.
			adjust_nutrition(400)
			sleep(50)
			B.drip(1)
			sleep(50)
			B.drip(1)


//Welcome to the adapted changeling absorb code.
/mob/living/carbon/human/proc/succubus_drain()
	set name = "Drain prey of nutrition"
	set desc = "Slowly drain prey of all the nutrition in their body, feeding you in the process. You may only do this to one person at a time."
	set category = "Abilities.Succubus"
	if(!ishuman(src))
		return //If you're not a human you don't have permission to do this.
	var/mob/living/carbon/human/C = src
	var/obj/item/grab/G = src.get_active_hand()
	if(!istype(G))
		to_chat(C, span_warning("You must be grabbing a creature in your active hand to absorb them."))
		return

	var/mob/living/carbon/human/T = G.affecting // I must say, this is a quite ingenious way of doing it. Props to the original coders.
	if(!istype(T) || T.isSynthetic())
		to_chat(src, span_warning("\The [T] is not able to be drained."))
		return

	if(G.state != GRAB_NECK)
		to_chat(C, span_warning("You must have a tighter grip to drain this creature."))
		return

	if(C.absorbing_prey)
		to_chat(C, span_warning("You are already draining someone!"))
		return

	C.absorbing_prey = 1
	for(var/stage = 1, stage<=100, stage++) //100 stages.
		switch(stage)
			if(1)
				to_chat(C, span_notice("You begin to drain [T]..."))
				to_chat(T, span_danger("An odd sensation flows through your body as [C] begins to drain you!"))
				C.nutrition = (C.nutrition + (T.nutrition*0.05)) //Drain a small bit at first. 5% of the prey's nutrition.
				T.nutrition = T.nutrition*0.95
			if(2)
				to_chat(C, span_notice("You feel stronger with every passing moment of draining [T]."))
				src.visible_message(span_danger("[C] seems to be doing something to [T], resulting in [T]'s body looking weaker with every passing moment!"))
				to_chat(T, span_danger("You feel weaker with every passing moment as [C] drains you!"))
				C.nutrition = (C.nutrition + (T.nutrition*0.1))
				T.nutrition = T.nutrition*0.9
			if(3 to 99)
				C.nutrition = (C.nutrition + (T.nutrition*0.1)) //Just keep draining them.
				T.nutrition = T.nutrition*0.9
				T.eye_blurry += 5 //Some eye blurry just to signify to the prey that they are still being drained. This'll stack up over time, leave the prey a bit more "weakened" after the deed is done.
				if(T.nutrition < 100 && stage < 99 && C.drain_finalized == 1)//Did they drop below 100 nutrition? If so, immediately jump to stage 99 so it can advance to 100.
					stage = 99
				if(C.drain_finalized != 1 && stage == 99) //Are they not finalizing and the stage hit 100? If so, go back to stage 3 until they finalize it.
					stage = 3
			if(100)
				C.nutrition = (C.nutrition + T.nutrition)
				T.nutrition = 0 //Completely drained of everything.
				var/damage_to_be_applied = T.species.total_health //Get their max health.
				T.apply_damage(damage_to_be_applied, HALLOSS) //Knock em out.
				C.absorbing_prey = 0
				to_chat(C, span_notice("You have completely drained [T], causing them to pass out."))
				to_chat(T, span_danger("You feel weak, as if you have no control over your body whatsoever as [C] finishes draining you.!"))
				add_attack_logs(C,T,"Succubus drained")
				return

		if(!do_mob(src, T, 50) || G.state != GRAB_NECK) //One drain tick every 5 seconds.
			to_chat(src, span_warning("Your draining of [T] has been interrupted!"))
			C.absorbing_prey = 0
			return

/mob/living/carbon/human/proc/succubus_drain_lethal()
	set name = "Lethally drain prey" //Provide a warning that THIS WILL KILL YOUR PREY.
	set desc = "Slowly drain prey of all the nutrition in their body, feeding you in the process. Once prey run out of nutrition, you will begin to drain them lethally. You may only do this to one person at a time."
	set category = "Abilities.Succubus"
	if(!ishuman(src))
		return //If you're not a human you don't have permission to do this.

	var/obj/item/grab/G = src.get_active_hand()
	if(!istype(G))
		to_chat(src, span_warning("You must be grabbing a creature in your active hand to drain them."))
		return

	var/mob/living/carbon/human/T = G.affecting // I must say, this is a quite ingenious way of doing it. Props to the original coders.
	if(!istype(T) || T.isSynthetic())
		to_chat(src, span_warning("\The [T] is not able to be drained."))
		return

	if(G.state != GRAB_NECK)
		to_chat(src, span_warning("You must have a tighter grip to drain this creature."))
		return

	if(absorbing_prey)
		to_chat(src, span_warning("You are already draining someone!"))
		return

	absorbing_prey = 1
	for(var/stage = 1, stage<=100, stage++) //100 stages.
		switch(stage)
			if(1)
				if(T.stat == DEAD)
					to_chat(src, span_warning("[T] is dead and can not be drained.."))
					return
				to_chat(src, span_notice("You begin to drain [T]..."))
				to_chat(T, span_danger("An odd sensation flows through your body as [src] begins to drain you!"))
				nutrition = (nutrition + (T.nutrition*0.05)) //Drain a small bit at first. 5% of the prey's nutrition.
				T.nutrition = T.nutrition*0.95
			if(2)
				to_chat(src, span_notice("You feel stronger with every passing moment as you drain [T]."))
				visible_message(span_danger("[src] seems to be doing something to [T], resulting in [T]'s body looking weaker with every passing moment!"))
				to_chat(T, span_danger("You feel weaker with every passing moment as [src] drains you!"))
				nutrition = (nutrition + (T.nutrition*0.1))
				T.nutrition = T.nutrition*0.9
			if(3 to 48) //Should be more than enough to get under 100.
				nutrition = (nutrition + (T.nutrition*0.1)) //Just keep draining them.
				T.nutrition = T.nutrition*0.9
				T.eye_blurry += 5 //Some eye blurry just to signify to the prey that they are still being drained. This'll stack up over time, leave the prey a bit more "weakened" after the deed is done.
				if(T.nutrition < 100)//Did they drop below 100 nutrition? If so, do one last check then jump to stage 50 (Lethal!)
					stage = 49
			if(49)
				if(T.nutrition < 100)//Did they somehow not get drained below 100 nutrition yet? If not, go back to stage 3 and repeat until they get drained.
					stage = 3 //Otherwise, advance to stage 50 (Lethal draining.)
			if(50)
				if(!T.digestable)
					to_chat(src, span_danger("You feel invigorated as you completely drain [T] and begin to move onto draining them lethally before realizing they are too strong for you to do so!"))
					to_chat(T, span_danger("You feel completely drained as [src] finishes draining you and begins to move onto draining you lethally, but you are too strong for them to do so!"))
					nutrition = (nutrition + T.nutrition)
					T.nutrition = 0 //Completely drained of everything.
					var/damage_to_be_applied = T.species.total_health //Get their max health.
					T.apply_damage(damage_to_be_applied, HALLOSS) //Knock em out.
					absorbing_prey = 0 //Clean this up before we return
					return
				to_chat(src, span_notice("You begin to drain [T] completely..."))
				to_chat(T, span_danger("An odd sensation flows through your body as you as [src] begins to drain you to dangerous levels!"))
			if(51 to 98)
				if(T.stat == DEAD)
					if(soulgem?.flag_check(SOULGEM_ACTIVE | SOULGEM_CATCHING_DRAIN, TRUE))
						soulgem.catch_mob(T)
					T.apply_damage(500, OXY) //Bit of fluff.
					absorbing_prey = 0
					to_chat(src, span_notice("You have completely drained [T], killing them."))
					to_chat(T, span_danger(span_giant("You feel... So... Weak...")))
					add_attack_logs(src,T,"Succubus drained (almost lethal)")
					return
				if(drain_finalized == 1 || T.getBrainLoss() < 55) //Let's not kill them with this unless the drain is finalized. This will still stack up to 55, since 60 is lethal.
					T.adjustBrainLoss(5) //Will kill them after a short bit!
				T.eye_blurry += 20 //A lot of eye blurry just to signify to the prey that they are still being drained. This'll stack up over time, leave the prey a bit more "weakened" after the deed is done. More than non-lethal due to their lifeforce being sucked out
				nutrition = (nutrition + 25) //Assuming brain damage kills at 60, this gives 300 nutrition.
			if(99)
				if(drain_finalized != 1)
					stage = 51
			if(100) //They shouldn't  survive long enough to get here, but just in case.
				if(soulgem?.flag_check(SOULGEM_ACTIVE | SOULGEM_CATCHING_DRAIN, TRUE))
					soulgem.catch_mob(T)
				T.apply_damage(500, OXY) //Kill them.
				absorbing_prey = 0
				to_chat(src, span_notice("You have completely drained [T], killing them in the process."))
				to_chat(T, span_danger(span_massive("You... Feel... So... Weak...")))
				visible_message(span_danger("[src] seems to finish whatever they were doing to [T]."))
				add_attack_logs(src,T,"Succubus drained (lethal)")
				return

		if(!do_mob(src, T, 50) || G.state != GRAB_NECK) //One drain tick every 5 seconds.
			to_chat(src, span_warning("Your draining of [T] has been interrupted!"))
			absorbing_prey = 0
			return

/mob/living/carbon/human/proc/slime_feed()
	set name = "Feed prey with self"
	set desc = "Slowly feed prey with your body, draining you in the process. You may only do this to one person at a time."
	set category = "Abilities.Vore"
	if(!ishuman(src))
		return //If you're not a human you don't have permission to do this.
	var/mob/living/carbon/human/C = src
	var/obj/item/grab/G = src.get_active_hand()
	if(!istype(G))
		to_chat(C, span_warning("You must be grabbing a creature in your active hand to feed them."))
		return

	var/mob/living/carbon/human/T = G.affecting // I must say, this is a quite ingenious way of doing it. Props to the original coders.
	if(!istype(T))
		to_chat(src, span_warning("\The [T] is not able to be fed."))
		return

	if(!G.state) //This should never occur. But alright
		return

	if(C.absorbing_prey)
		to_chat(C, span_warning("You are already feeding someone!"))
		return

	C.absorbing_prey = 1
	for(var/stage = 1, stage<=100, stage++) //100 stages.
		switch(stage)
			if(1)
				to_chat(C, span_notice("You begin to feed [T]..."))
				to_chat(T, span_notice("An odd sensation flows through your body as [C] begins to feed you!"))
				T.nutrition = (T.nutrition + (C.nutrition*0.05)) //Drain a small bit at first. 5% of the prey's nutrition.
				C.nutrition = C.nutrition*0.95
			if(2)
				to_chat(C, span_notice("You feel weaker with every passing moment of feeding [T]."))
				src.visible_message(span_notice("[C] seems to be doing something to [T], resulting in [T]'s body looking stronger with every passing moment!"))
				to_chat(T, span_notice("You feel stronger with every passing moment as [C] feeds you!"))
				T.nutrition = (T.nutrition + (C.nutrition*0.1))
				C.nutrition = C.nutrition*0.90
			if(3 to 99)
				T.nutrition = (T.nutrition + (C.nutrition*0.1)) //Just keep draining them.
				C.nutrition = C.nutrition*0.9
				T.eye_blurry += 1 //Eating a slime's body is odd and will make your vision a bit blurry!
				if(C.nutrition < 100 && stage < 99 && C.drain_finalized == 1)//Did they drop below 100 nutrition? If so, immediately jump to stage 99 so it can advance to 100.
					stage = 99
				if(C.drain_finalized != 1 && stage == 99) //Are they not finalizing and the stage hit 100? If so, go back to stage 3 until they finalize it.
					stage = 3
			if(100)
				T.nutrition = (T.nutrition + C.nutrition)
				C.nutrition = 0 //Completely drained of everything.
				C.absorbing_prey = 0
				to_chat(C, span_danger("You have completely fed [T] every part of your body!"))
				to_chat(T, span_notice("You feel quite strong and well fed, as [C] finishes feeding \himself to you!"))
				add_attack_logs(C,T,"Slime fed")
				C.feed_grabbed_to_self_falling_nom(T,C) //Reused this proc instead of making a new one to cut down on code usage.
				return

		if(!do_mob(src, T, 50) || !G.state) //One drain tick every 5 seconds.
			to_chat(src, span_warning("Your feeding of [T] has been interrupted!"))
			C.absorbing_prey = 0
			return

/mob/living/carbon/human/proc/succubus_drain_finalize()
	set name = "Drain/Feed Finalization"
	set desc = "Toggle to allow for draining to be prolonged. Turn this on to make it so prey will be knocked out/die while being drained, or you will feed yourself to the prey's selected stomach if you're feeding them. Can be toggled at any time."
	set category = "Abilities.Succubus"

	var/mob/living/carbon/human/C = src
	C.drain_finalized = !C.drain_finalized
	to_chat(C, span_notice("You will [C.drain_finalized?"now":"not"] finalize draining/feeding."))


//Test to see if we can shred a mob. Some child override needs to pass us a target. We'll return it if you can.
/mob/living/var/vore_shred_time = 45 SECONDS
/mob/living/proc/can_shred(var/mob/living/carbon/human/target)
	//Needs to have organs to be able to shred them.
	if(!istype(target))
		to_chat(src,span_warning("You can't shred that type of creature."))
		return FALSE
	//Needs to be capable (replace with incapacitated call?)
	if(stat || paralysis || stunned || weakened || lying || restrained() || buckled)
		to_chat(src,span_warning("You cannot do that in your current state!"))
		return FALSE
	//Needs to be adjacent, at the very least.
	if(!Adjacent(target))
		to_chat(src,span_warning("You must be next to your target."))
		return FALSE
	//Cooldown on abilities
	if(last_special > world.time)
		to_chat(src,span_warning("You can't perform an ability again so soon!"))
		return FALSE

	return target

//Human test for shreddability, returns the mob if they can be shredded.
/mob/living/carbon/human/vore_shred_time = 10 SECONDS
/mob/living/carbon/human/can_shred()
	//Humans need a grab
	var/obj/item/grab/G = get_active_hand()
	if(!istype(G))
		to_chat(src,span_warning("You have to have a very strong grip on someone first!"))
		return FALSE
	if(G.state != GRAB_NECK)
		to_chat(src,span_warning("You must have a tighter grip to severely damage this creature!"))
		return FALSE

	return ..(G.affecting)

//PAIs, borgs, and animals don't need a grab or anything
/mob/living/silicon/pai/can_shred(var/mob/living/carbon/human/target)
	if(!target)
		var/list/choices = list()
		for(var/mob/living/carbon/human/M in oviewers(1))
			choices += M

		if(!choices.len)
			to_chat(src,span_warning("There's nobody nearby to use this on."))

		target = tgui_input_list(src,"Who do you wish to target?","Damage/Remove Prey's Organ", choices)
	if(!istype(target))
		return FALSE

	return ..(target)

/mob/living/silicon/robot/can_shred(var/mob/living/carbon/human/target)
	if(!target)
		var/list/choices = list()
		for(var/mob/living/carbon/human/M in oviewers(1))
			choices += M

		if(!choices.len)
			to_chat(src,span_warning("There's nobody nearby to use this on."))

		target = tgui_input_list(src,"Who do you wish to target?","Damage/Remove Prey's Organ", choices)
	if(!istype(target))
		return FALSE

	return ..(target)

/mob/living/simple_mob/can_shred(var/mob/living/carbon/human/target)
	if(!target)
		var/list/choices = list()
		for(var/mob/living/carbon/human/M in oviewers(1))
			choices += M

		if(!choices.len)
			to_chat(src,span_warning("There's nobody nearby to use this on."))

		target = tgui_input_list(src,"Who do you wish to target?","Damage/Remove Prey's Organ", choices)
	if(!istype(target))
		return FALSE

	return ..(target)

/mob/living/proc/shred_limb()
	set name = "Damage/Remove Prey's Organ"
	set desc = "Severely damages prey's organ. If the limb is already severely damaged, it will be torn off."
	set category = "Abilities.Vore"

	//can_shred() will return a mob we can shred, if we can shred any.
	var/mob/living/carbon/human/T = can_shred()
	if(!istype(T))
		return //Silent, because can_shred does messages.

	//Let them pick any of the target's external organs
	var/obj/item/organ/external/T_ext = tgui_input_list(src, "What do you wish to severely damage?", "Organ Choice", T.organs) //D for destroy.
	if(!T_ext) //Picking something here is critical.
		return
	if(T_ext.vital)
		if(tgui_alert(src, "Are you sure you wish to severely damage their [T_ext]? It will likely kill [T]...","Shred Limb",list("Yes", "No")) != "Yes")
			return //If they reconsider, don't continue.

	//Any internal organ, if there are any
	var/obj/item/organ/internal/T_int = tgui_input_list(src,"Do you wish to severely damage an internal organ, as well? If not, click 'cancel'", "Organ Choice", T_ext.internal_organs)
	if(T_int && T_int.vital)
		if(tgui_alert(src, "Are you sure you wish to severely damage their [T_int]? It will likely kill [T]...","Shred Limb",list("Yes", "No")) != "Yes")
			return //If they reconsider, don't continue.

	//And a belly, if they want
	var/obj/belly/B = tgui_input_list(src,"To where do you wish to swallow the organ if you tear if out? If not at all, click 'cancel'", "Organ Choice", vore_organs)

	if(can_shred(T) != T)
		to_chat(src,span_warning("Looks like you lost your chance..."))
		return

	last_special = world.time + vore_shred_time
	visible_message(span_danger("[src] appears to be preparing to do something to [T]!")) //Let everyone know that bad times are ahead

	if(do_after(src, vore_shred_time, T)) //Ten seconds. You have to be in a neckgrab for this, so you're already in a bad position.
		if(can_shred(T) != T)
			to_chat(src,span_warning("Looks like you lost your chance..."))
			return

		T.add_modifier(/datum/modifier/gory_devourment, 10 SECONDS)

		//Removing an internal organ
		if(T_int && T_int.damage >= 25) //Internal organ and it's been severely damaged
			T.apply_damage(15, BRUTE, T_ext) //Damage the external organ they're going through.
			T_int.removed()
			if(B)
				T_int.forceMove(B) //Move to pred's gut
				visible_message(span_danger("[src] severely damages [T_int.name] of [T]!"))
			else
				T_int.forceMove(T.loc)
				visible_message(span_danger("[src] severely damages [T_ext.name] of [T], resulting in their [T_int.name] coming out!"),span_warning("You tear out [T]'s [T_int.name]!"))

		//Removing an external organ
		else if(!T_int && (T_ext.damage >= 25 || T_ext.brute_dam >= 25))
			T_ext.droplimb(1,DROPLIMB_EDGE) //Clean cut so it doesn't kill the prey completely.

			//Is it groin/chest? You can't remove those.
			if(T_ext.cannot_amputate)
				T.apply_damage(25, BRUTE, T_ext)
				visible_message(span_danger("[src] severely damages [T]'s [T_ext.name]!"))
			else if(B)
				T_ext.forceMove(B)
				visible_message(span_warning("[src] swallows [T]'s [T_ext.name] into their [lowertext(B.name)]!"))
			else
				T_ext.forceMove(T.loc)
				visible_message(span_warning("[src] tears off [T]'s [T_ext.name]!"),span_warning("You tear off [T]'s [T_ext.name]!"))

		//Not targeting an internal organ w/ > 25 damage , and the limb doesn't have < 25 damage.
		else
			if(T_int)
				T_int.damage = 25 //Internal organs can only take damage, not brute damage.
			T.apply_damage(25, BRUTE, T_ext)
			visible_message(span_danger("[src] severely damages [T]'s [T_ext.name]!"))

		add_attack_logs(src,T,"Shredded (hardvore)")

/mob/living/proc/shred_limb_temp()
	set name = "Damage/Remove Prey's Organ (beartrap)"
	set desc = "Severely damages prey's organ. If the limb is already severely damaged, it will be torn off."
	set category = "Abilities.Vore"
	shred_limb()

/mob/living/proc/flying_toggle()
	set name = "Toggle Flight"
	set desc = "While flying over open spaces, you will use up some nutrition. If you run out nutrition, you will fall."
	set category = "Abilities.General"

	var/mob/living/carbon/human/C = src
	if(!C.wing_style) //The species var isn't taken into account here, as it's only purpose is to give this proc to a person.
		to_chat(src, "You cannot fly without wings!!")
		return
	if(C.incapacitated(INCAPACITATION_ALL))
		to_chat(src, "You cannot fly in this state!")
		return
	if(C.nutrition < 25 && !C.flying) //Don't have any food in you?" You can't fly.
		to_chat(C, span_notice("You lack the nutrition to fly."))
		return

	C.flying = !C.flying
	update_floating()
	to_chat(C, span_notice("You have [C.flying?"started":"stopped"] flying."))

/mob/living/
	var/flight_vore = FALSE

/mob/living/proc/flying_vore_toggle()
	set name = "Toggle Flight Vore"
	set desc = "Allows you to engage in voracious misadventures while flying."
	set category = "Abilities.Vore"

	flight_vore = !flight_vore
	if(flight_vore)
		to_chat(src, "You have allowed for flight vore! Bumping into characters while flying will now trigger dropnoms! Unless prefs don't match.. then you will take a tumble!")
	else
		to_chat(src, "Flight vore disabled! You will no longer engage dropnoms while in flight.")

//Proc to stop inertial_drift. Exchange nutrition in order to stop gliding around.
/mob/living/proc/start_wings_hovering()
	set name = "Hover"
	set desc = "Allows you to stop gliding and hover. This will take a fair amount of nutrition to perform."
	set category = "Abilities.General"

	var/mob/living/carbon/human/C = src
	if(!C.wing_style) //The species var isn't taken into account here, as it's only purpose is to give this proc to a person.
		to_chat(src, "You don't have wings!")
		return
	if(!C.flying)
		to_chat(src, "You must be flying to hover!")
		return
	if(C.incapacitated(INCAPACITATION_ALL))
		to_chat(src, "You cannot hover in your current state!")
		return
	if(C.nutrition < 50 && !C.flying) //Don't have any food in you?" You can't hover, since it takes up 25 nutrition. And it's not 25 since we don't want them to immediately fall.
		to_chat(C, span_notice("You lack the nutrition to fly."))
		return
	if(C.anchored)
		to_chat(C, span_notice("You are already hovering and/or anchored in place!"))
		return

	if(!C.anchored && !C.pulledby) //Not currently anchored, and not pulled by anyone.
		C.anchored = TRUE //This is the only way to stop the inertial_drift.
		C.adjust_nutrition(-25)
		update_floating()
		to_chat(C, span_notice("You hover in place."))
		spawn(6) //.6 seconds.
			C.anchored = FALSE
	else
		return

/mob/living/proc/toggle_pass_table()
	set name = "Toggle Agility" //Dunno a better name for this. You have to be pretty agile to hop over stuff!!!
	set desc = "Allows you to start/stop hopping over things such as hydroponics trays, tables, and railings."
	set category = "Abilities.General"
	pass_flags ^= PASSTABLE //I dunno what this fancy ^= is but Aronai gave it to me.
	to_chat(src, "You [pass_flags&PASSTABLE ? "will" : "will NOT"] move over tables/railings/trays!")

/mob/living/carbon/human/proc/toggle_eye_glow()
	set name = "Toggle Eye Glowing"
	set category = "Abilities.General"

	species.has_glowing_eyes = !species.has_glowing_eyes
	update_eyes()
	to_chat(src, "Your eyes [species.has_glowing_eyes ? "are now" : "are no longer"] glowing.")

/mob/living/carbon/human/proc/enter_cocoon()
	set name = "Spin Cocoon"
	set category = "Abilities.Weaver"
	if(!isturf(loc))
		to_chat(src, "You don't have enough space to spin a cocoon!")
		return

	if(buckled ||stat || paralysis || weakened || stunned || world.time < last_special) //No tongue flicking while stunned.
		to_chat(src, span_warning("You can't do that in your current state."))
		return

	if(do_after(src, 25, exclusive = TASK_USER_EXCLUSIVE))
		var/obj/item/storage/vore_egg/bugcocoon/C = new(loc)
		forceMove(C)

		var/mob_holder_type = src.holder_type || /obj/item/holder
		C.w_class = src.size_multiplier * 4 //Egg size and weight scaled to match occupant.
		var/obj/item/holder/H = new mob_holder_type(C, src)
		C.max_storage_space = H.w_class
		C.icon_scale_x = 0.25 * C.w_class
		C.icon_scale_y = 0.25 * C.w_class
		C.update_transform()
		//egg_contents -= src
		C.contents -= src
		var/datum/tgui_module/appearance_changer/cocoon/V = new(src, src)
		V.tgui_interact(src)

/mob/living/carbon/human/proc/water_stealth()
	set name = "Dive under water / Resurface"
	set desc = "Dive under water, allowing for you to be stealthy and move faster."
	set category = "Abilities.General"

	if(last_special > world.time)
		return
	last_special = world.time + 50 //No spamming!

	if(has_modifier_of_type(/datum/modifier/underwater_stealth))
		to_chat(src, "You resurface!")
		remove_modifiers_of_type(/datum/modifier/underwater_stealth)
		return

	if(!isturf(loc)) //We have no turf.
		to_chat(src, "There is no water for you to dive into!")
		return

	if(istype(src.loc, /turf/simulated/floor/water))
		var/turf/simulated/floor/water/water_floor = src.loc
		if(water_floor.depth >= 1) //Is it deep enough?
			add_modifier(/datum/modifier/underwater_stealth) //No duration. It'll remove itself when they exit the water!
			to_chat(src, "You dive into the water!")
			visible_message("[src] dives into the water!")
		else
			to_chat(src, "The water here is not deep enough to dive into!")
			return

	else
		to_chat(src, "There is no water for you to dive into!")
		return

/mob/living/carbon/human/proc/underwater_devour()
	set name = "Devour From Water"
	set desc = "Grab something in the water with you and devour them with your selected stomach."
	set category = "Abilities.Vore"

	if(last_special > world.time)
		return
	last_special = world.time + 50 //No spamming!

	if(stat == DEAD || paralysis || weakened || stunned)
		to_chat(src, span_notice("You cannot do that while in your current state."))
		return

	if(!(src.vore_selected))
		to_chat(src, span_notice("No selected belly found."))
		return


	if(!has_modifier_of_type(/datum/modifier/underwater_stealth))
		to_chat(src, "You must be underwater to do this!!")
		return

	var/list/targets = list() //Shameless copy and paste. If it ain't broke don't fix it!

	for(var/turf/T in range(1, src))
		if(istype(T, /turf/simulated/floor/water))
			for(var/mob/living/L in T)
				if(L == src) //no eating yourself. 1984.
					continue
				if(L.devourable && L.can_be_drop_prey)
					targets += L

	if(!(targets.len))
		to_chat(src, span_notice("No eligible targets found."))
		return

	var/mob/living/target = tgui_input_list(src, "Please select a target.", "Victim", targets)

	if(!target)
		return

	to_chat(target, span_critical("Something begins to circle around you in the water!")) //Dun dun...
	var/starting_loc = target.loc

	if(do_after(src, 50))
		if(target.loc != starting_loc)
			to_chat(target, span_warning("You got away from whatever that was..."))
			to_chat(src, span_notice("They got away."))
			return
		if(target.buckled) //how are you buckled in the water?!
			target.buckled.unbuckle_mob()
		target.visible_message(span_vwarning("\The [target] suddenly disappears, being dragged into the water!"),\
			span_vdanger("You are dragged below the water and feel yourself slipping directly into \the [src]'s [vore_selected]!"))
		to_chat(src, span_vnotice("You successfully drag \the [target] into the water, slipping them into your [vore_selected]."))
		target.forceMove(src.vore_selected)

/mob/living/carbon/human/proc/toggle_pain_module()
	set name = "Toggle pain simulation."
	set desc = "Turn on your pain simulation for that organic experience! Or turn it off for repairs, or if it's too much."
	set category = "Abilities.General"

	if(synth_cosmetic_pain)
		to_chat(src, span_notice(" You turn off your pain simulators."))
	else
		to_chat(src, span_danger(" You turn on your pain simulators "))

	synth_cosmetic_pain = !synth_cosmetic_pain

//This is the 'long vore' ability. Also known as "Grab Prey with appendage" or "Long Predatorial Reach". Or simply "Tongue Vore"
//It involves projectiles (which means it can be VV'd onto a gun for shenanigans)
//It can also be recolored via the proc, which persists between rounds.

/mob/living/proc/long_vore() // Allows the user to tongue grab a creature in range. Made a /living proc so frogs can frog you.
	set name = "Grab Prey With Appendage"
	set category = "Abilities.Vore"
	set desc = "Grab a target with any of your appendages!"

	if(stat || paralysis || weakened || stunned || world.time < last_special || is_incorporeal()) //No tongue flicking while stunned.
		to_chat(src, span_warning("You can't do that in your current state."))
		return

	last_special = world.time + 10 //Anti-spam.

	if (!isliving(src))
		to_chat(src, span_warning("It doesn't work that way."))
		return

	var/choice = tgui_alert(src, "Do you wish to change the color of your appendage, use it, or change its functionality?", "Selection List", list("Use it", "Color", "Functionality"))
	if(!choice)
		return

	if(choice == "Color") //Easy way to set color so we don't bloat up the menu with even more buttons.
		var/new_color = tgui_color_picker(src, "Choose a color to set your appendage to!", "", appendage_color)
		if(new_color)
			appendage_color = new_color
	if(choice == "Functionality") //Easy way to set color so we don't bloat up the menu with even more buttons.
		var/choice2 = tgui_alert(src, "Choose if you want to be pulled to the target or pull them to you!", "Functionality Setting", list("Pull target to self", "Pull self to target"))
		if(!choice2)
			return
		if(choice2 == "Pull target to self")
			appendage_alt_setting = 0
		else
			appendage_alt_setting = 1
	else
		var/list/targets = list() //IF IT IS NOT BROKEN. DO NOT FIX IT.

		for(var/mob/living/L in range(5, src))
			if(!isliving(L)) //Don't eat anything that isn't mob/living. Failsafe.
				continue
			if(L == src) //no eating yourself. 1984.
				continue
			if(L.devourable && L.throw_vore && (L.can_be_drop_pred || L.can_be_drop_prey))
				targets += L

		if(!(targets.len))
			to_chat(src, span_notice("No eligible targets found."))
			return

		var/mob/living/target = tgui_input_list(src, "Please select a target.", "Victim", targets)

		if(!target)
			return

		if(!isliving(target)) //Safety.
			to_chat(src, span_warning("You need to select a living target!"))
			return

		if (get_dist(src,target) >= 6)
			to_chat(src, span_warning("You need to be closer to do that."))
			return

		visible_message(span_vnotice("\The [src] attempts to snatch up [target]!"), \
						span_vnotice("You attempt to snatch up [target]!") )
		playsound(src, 'sound/vore/sunesound/pred/schlorp.ogg', 25)

		//Code to shoot the beam here.
		var/obj/item/projectile/beam/appendage/appendage_attack = new /obj/item/projectile/beam/appendage(get_turf(loc))
		appendage_attack.launch_projectile(target, BP_TORSO, src) //Send it.
		last_special = world.time + 100 //Cooldown for successful strike.




/obj/item/projectile/beam/appendage //The tongue projecitle.
	name = "appendage"
	icon_state = "laser"
	nodamage = 1
	damage = 0
	eyeblur = 0
	check_armour = "bullet" //Not really needed, but whatever.
	can_miss = FALSE //Let's not miss our tongue!
	fire_sound = 'sound/effects/slime_squish.ogg'
	hitsound = 'sound/vore/sunesound/pred/schlorp.ogg'
	hitsound_wall = 'sound/vore/sunesound/pred/schlorp.ogg'
	excavation_amount = 0
	hitscan_light_intensity = 0
	hitscan_light_range = 0
	muzzle_flash_intensity = 0
	muzzle_flash_range = 0
	impact_light_intensity = 0
	impact_light_range  = 0
	light_range = 0 //No your tongue can not glow...For now.
	light_power = 0
	light_on = 0 //NO LIGHT
	combustion = FALSE //No, your tongue can't set the room on fire.
	pass_flags = PASSTABLE

	muzzle_type = /obj/effect/projectile/muzzle/appendage
	tracer_type = /obj/effect/projectile/tracer/appendage
	impact_type = /obj/effect/projectile/impact/appendage

/obj/item/projectile/beam/appendage/generate_hitscan_tracers()
	if(firer) //This neat little code block allows for C O L O R A B L E tongues! Correction: 'Appendages'
		if(isliving(firer))
			var/mob/living/originator = firer
			color = originator.appendage_color
	..()

/obj/item/projectile/beam/appendage/on_hit(var/atom/target)
	if(target == firer) //NO EATING YOURSELF
		return
	if(isliving(target))
		var/mob/living/M = target
		var/throw_range = get_dist(firer,M)
		if(isliving(firer)) //Let's check for any alt settings. Such as: User selected to be thrown at target.
			var/mob/living/F = firer
			if(F.appendage_alt_setting == 1)
				F.throw_at(M, throw_range, firer.throw_speed, F) //Firer thrown at target.
				F.update_icon()
				return
		if(istype(M))
			M.throw_at(firer, throw_range, M.throw_speed, firer) //Fun fact: living things have a throw_speed of 2.
			M.update_icon()
			return
		else //Anything that isn't a /living
			return
	if(istype(target, /obj/item/)) //We hit an object? Pull it. This can only happen via admin shenanigans such as a gun being VV'd with this projectile.
		var/obj/item/hit_object = target
		if(hit_object.density || hit_object.anchored)
			if(isliving(firer))
				var/mob/living/originator = firer
				originator.Weaken(2) //If you hit something dense or anchored, fall flat on your face.
				originator.visible_message(span_warning("\The [originator] trips over their self and falls flat on their face!"), \
								span_warning("You trip over yourself and fall flat on your face!") )
				playsound(originator, "punch", 25, 1, -1)
			return
		else
			hit_object.throw_at(firer, throw_range, hit_object.throw_speed, firer)
	if(istype(target, /turf/simulated/wall) || istype(target, /obj/machinery/door) || istype(target, /obj/structure/window)) //This can happen normally due to odd terrain. For some reason, it seems to not actually interact with walls.
		if(isliving(firer))
			var/mob/living/originator = firer
			originator.Weaken(2) //Hit a wall? Whoops!
			originator.visible_message(span_warning("\The [originator] trips over their self and falls flat on their face!"), \
							span_warning("You trip over yourself and fall flat on your face!") )
			playsound(originator, "punch", 25, 1, -1)
			return
		else
			return



/obj/effect/projectile/muzzle/appendage
	icon = 'icons/obj/projectiles_vr.dmi'
	icon_state = "muzzle_appendage"
	light_range = 0
	light_power = 0
	light_color = "#FF0D00"

/obj/effect/projectile/tracer/appendage
	icon = 'icons/obj/projectiles_vr.dmi'
	icon_state = "appendage_beam"
	light_range = 0
	light_power = 0
	light_color = "#FF0D00" //Doesn't matter. Not used.

/obj/effect/projectile/impact/appendage
	icon = 'icons/obj/projectiles_vr.dmi'
	icon_state = "impact_appendage_combined"
	light_range = 0
	light_power = 0
	light_color = "#FF0D00"
//LONG VORE ABILITY END

/obj/item/gun/energy/gun/tongue //This is the 'tongue' gun for admin memery.
	name = "tongue"
	desc = "A tongue that can be used to grab things."
	icon = 'icons/mob/dogborg_vr.dmi'
	icon_state = "synthtongue"
	item_state = "gun"
	fire_delay = null
	force = 0
	fire_delay = 1 //Adminspawn. No delay.
	charge_cost = 0 //This is an adminspawn gun...No reason to force it to have a charge state.

	projectile_type = /obj/item/projectile/beam/appendage
	cell_type = /obj/item/cell/device/weapon/recharge
	battery_lock = 1
	modifystate = null


	firemodes = list(
		list(mode_name="vore", projectile_type=/obj/item/projectile/beam/appendage, modifystate=null, fire_sound='sound/vore/sunesound/pred/schlorp.ogg', charge_cost = 0),)

/obj/item/gun/energy/gun/tongue/update_icon() //No updating the icon.
	icon_state = "synthtongue"
	return

/obj/item/gun/energy/bfgtaser/tongue
	name = "9000-series Ball Tongue Taser"
	desc = "A banned riot control device."
	slot_flags = SLOT_BELT|SLOT_BACK
	projectile_type = /obj/item/projectile/bullet/BFGtaser/tongue
	fire_delay = 20
	w_class = ITEMSIZE_LARGE
	one_handed_penalty = 90 // The thing's heavy and huge.
	accuracy = 45
	charge_cost = 2400 //yes, this bad boy empties an entire weapon cell in one shot. What of it?

/obj/item/projectile/bullet/BFGtaser/tongue
	name = "tongue ball"
	hitsound = 'sound/vore/sunesound/pred/schlorp.ogg'
	hitsound_wall = 'sound/vore/sunesound/pred/schlorp.ogg'
	zaptype = /obj/item/projectile/beam/appendage

/mob/living/proc/target_lunge() //The leaper leap, but usable as an ability
	set name = "Lunge At Prey"
	set category = "Abilities.Vore"
	set desc = "Dive atop your prey and gobble them up!"

	var/leap_warmup = 1 SECOND //Easy to modify
	var/leap_sound = 'sound/weapons/spiderlunge.ogg'

	if(stat || paralysis || weakened || stunned || world.time < last_special) //No tongue flicking while stunned.
		to_chat(src, span_warning("You can't do that in your current state."))
		return

	last_special = world.time + 10 //Anti-spam.

	if (!isliving(src))
		to_chat(src, span_warning("It doesn't work that way."))
		return

	else
		var/list/targets = list() //IF IT IS NOT BROKEN. DO NOT FIX IT.

		for(var/mob/living/L in range(5, src))
			if(!isliving(L)) //Don't eat anything that isn't mob/living. Failsafe.
				continue
			if(L == src) //no eating yourself. 1984.
				continue
			if(L.devourable && L.throw_vore && (L.can_be_drop_pred || L.can_be_drop_prey))
				targets += L

		if(!(targets.len))
			to_chat(src, span_notice("No eligible targets found."))
			return

		var/mob/living/target = tgui_input_list(src, "Please select a target.", "Victim", targets)

		if(!target)
			return

		if(!isliving(target)) //Safety.
			to_chat(src, span_warning("You need to select a living target!"))
			return

		if (get_dist(src,target) >= 6)
			to_chat(src, span_warning("You need to be closer to do that."))
			return

		visible_message(span_warning("\The [src] rears back, ready to lunge!"))
		to_chat(target, span_danger("\The [src] focuses on you!"))
		// Telegraph, since getting stunned suddenly feels bad.
		do_windup_animation(target, leap_warmup)
		sleep(leap_warmup) // For the telegraphing.

		if(target.z != z)	//Make sure you haven't disappeared to somewhere we can't go
			return FALSE

		// Do the actual leap.
		status_flags |= LEAPING // Lets us pass over everything.
		visible_message(span_critical("\The [src] leaps at \the [target]!"))
		throw_at(get_step(target, get_turf(src)), 7, 1, src)
		playsound(src, leap_sound, 75, 1)

		sleep(5) // For the throw to complete.

		if(status_flags & LEAPING)
			status_flags &= ~LEAPING // Revert special passage ability.

		if(Adjacent(target))	//We leapt at them but we didn't manage to hit them, let's see if we're next to them
			target.Weaken(2)	//get knocked down, idiot


/mob/living/proc/injection() // Allows the user to inject reagents into others somehow, like stinging, or biting.
	set name = "Injection"
	set category = "Abilities.General"
	set desc = "Inject another being with something!"

	if(stat || paralysis || weakened || stunned || world.time < last_special) //Epic copypasta from tongue grabbing.
		to_chat(src, span_warning("You can't do that in your current state."))
		return

	last_special = world.time + 10 //Anti-spam.

	var/list/choices = list("Inject")

	if(trait_injection_reagents.len > 1) //Should never happen, but who knows!
		choices += "Change reagent"
	else if(!trait_injection_selected)
		trait_injection_selected = trait_injection_reagents[1]

	choices += "Change amount"
	choices += "Change verb"
	choices += "Chemical Refresher"

	var/choice = tgui_alert(src, "Do you wish to inject somebody, or adjust settings?", "Selection List", choices)

	if(!choice)
		return

	if(choice == "Change reagent")
		var/reagent_choice = tgui_input_list(src, "Choose which reagent to inject!", "Select reagent", trait_injection_reagents)
		if(reagent_choice)
			trait_injection_selected = reagent_choice
		to_chat(src, span_notice("You prepare to inject [trait_injection_amount] units of [trait_injection_selected ? "[trait_injection_selected]" : "...nothing. Select a reagent before trying to inject anything."]"))
		return
	if(choice == "Change amount")
		var/amount_choice = tgui_input_number(src, "How much of the reagent do you want to inject? (Up to 5 units) (Can select 0 for a bite that doesn't inject venom!)", "How much?", trait_injection_amount, 5, 0, round_value = FALSE)
		if(amount_choice >= 0)
			trait_injection_amount = amount_choice
		to_chat(src, span_notice("You prepare to inject [trait_injection_amount] units of [trait_injection_selected ? "[trait_injection_selected]" : "...nothing. Select a reagent before trying to inject anything."]"))
		return
	if(choice == "Change verb")
		var/verb_choice = tgui_input_text(src, "Choose the percieved manner of injection, such as 'bite' or 'sting', don't be misleading or abusive. This will show up in game as ('X' manages to 'Verb' 'Y'. Example: X manages to bite Y.)", "How are you injecting?", trait_injection_verb, max_length = 60) //Whoaa there cowboy don't put a novel in there.
		if(verb_choice)
			trait_injection_verb = verb_choice
		to_chat(src, span_notice("You will [trait_injection_verb] your targets."))
		return
	if(choice == "Chemical Refresher")
		var/output = {""} + span_bold("Chemical Refresher!") + {"<HR>
					"} + span_bold("Options for venoms") + {"<BR>
					<BR>
					"} + span_bold("Size Chemicals") + {"<BR>
					Microcillin: Will make someone shrink. <br>
					Macrocillin: Will make someone grow. <br>
					Normalcillin: Will make someone normal size. <br>
					Note: 1 unit = 100% size diff. 0.01 unit = 1% size diff. <br>
					Note: Normacillin stops at 100%  size. <br>
					<br>
					"} + span_bold("Gender Chemicals") + {"<BR>
					Androrovir: Will transform someone's sex to male. <br>
					Gynorovir: Will transform someone's sex to female. <br>
					Androgynorovir: Will transform someone's sex to plural. <br>
					<br>
					"} + span_bold("Special Chemicals") + {"<BR>
					Stoxin: Will make someone drowsy. <br>
					Rainbow Toxin: Will make someone see rainbows. <br>
					Paralysis Toxin: Will make someone paralyzed. <br>
					Numbing Enzyme: Will make someone unable to feel pain. <br>
					Pain Enzyme: Will make someone feel amplified pain. <br>
					<br>
					"} + span_bold("Side Notes") + {"<BR>
					You can select a value of 0 to inject nothing! <br>
					Overdose threshold for most chemicals is 30 units. <br>
					Exceptions to OD is: (Numbing Enzyme:20)<br>
					You can also bite synthetics, but due to how synths work, they won't have anything injected into them.
					<br>
					"}
		src << browse("<html>[output]</html>","window=chemicalrefresher")
		return
	else
		var/list/targets = list() //IF IT IS NOT BROKEN. DO NOT FIX IT. AND KEEP COPYPASTING IT  (Pointing Rick Dalton: "That's my code!" ~CL)

		for(var/mob/living/carbon/L in living_mobs(1, TRUE)) //Noncarbons don't even process reagents so don't bother listing others.
			if(!istype(L, /mob/living/carbon))
				continue
			if(L == src) //no getting high off your own supply, get a nif or something, nerd.
				continue
			if(!L.resizable && (trait_injection_selected == REAGENT_ID_MACROCILLIN || trait_injection_selected == REAGENT_ID_MICROCILLIN || trait_injection_selected == REAGENT_ID_NORMALCILLIN)) // If you're using a size reagent, ignore those with pref conflicts.
				continue
			if(!L.allow_spontaneous_tf && (trait_injection_selected == REAGENT_ID_ANDROROVIR || trait_injection_selected == REAGENT_ID_GYNOROVIR || trait_injection_selected == REAGENT_ID_ANDROGYNOROVIR)) // If you're using a TF reagent, ignore those with pref conflicts.
				continue
			targets += L

		if(!(targets.len))
			to_chat(src, span_notice("No eligible targets found."))
			return

		var/mob/living/target = tgui_input_list(src, "Please select a target.", "Victim", targets)

		if(!target)
			return

		if(!istype(target, /mob/living/carbon)) //Safety.
			to_chat(src, span_warning("That won't work on that kind of creature! (Only works on crew/monkeys)"))
			return


		var/synth = 0
		if(target.isSynthetic())
			synth = 1

		if(!trait_injection_selected)
			to_chat(src, span_notice("You need to select a reagent."))
			return

		if(!trait_injection_verb)
			to_chat(src, span_notice("Somehow, you forgot your means of injecting. (Select a verb!)"))
			return


		visible_message(span_warning("[src] is preparing to [trait_injection_verb] [target]!"))
		if(do_after(src, 50, target)) //A decent enough timer.
			add_attack_logs(src,target,"Injection trait ([trait_injection_selected], [trait_injection_amount])")
			if(target.reagents && (trait_injection_amount > 0) && !synth)
				target.reagents.add_reagent(trait_injection_selected, trait_injection_amount)
			var/ourmsg = "[src] manages to [trait_injection_verb] [target] "
			switch(zone_sel.selecting)
				if(BP_HEAD)
					ourmsg += "on the head!"
				if(BP_TORSO)
					ourmsg += "on the chest!"
				if(BP_GROIN)
					ourmsg += "on the groin!"
				if(BP_R_ARM, BP_L_ARM)
					ourmsg += "on the arm!"
				if(BP_R_HAND, BP_L_HAND)
					ourmsg += "on the hand!"
				if(BP_R_LEG, BP_L_LEG)
					ourmsg += "on the leg!"
				if(BP_R_FOOT, BP_L_FOOT)
					ourmsg += "on the foot!"
				if("mouth")
					ourmsg += "on the mouth!"
				if("eyes")
					ourmsg += "on the eyes!"
			visible_message(span_warning(ourmsg))
