// Simple animal nanogoopeyness
/mob/living/simple_mob/protean_blob
	name = "protean blob"
	desc = "Some sort of big viscous pool of jelly."
	tt_desc = "Animated nanogoop"
	icon = 'icons/mob/species/protean/protean.dmi'
	icon_state = "to_puddle"
	icon_living = "puddle2"
	icon_rest = "rest"
	icon_dead = "puddle"

	faction = "neutral"
	maxHealth = 200
	health = 200
	say_list_type = /datum/say_list/protean_blob

	show_stat_health = FALSE //We will do it ourselves

	response_help = "pets"
	response_disarm = "gently pushes aside"
	response_harm = "hits"

	harm_intent_damage = 2
	melee_damage_lower = 5
	melee_damage_upper = 5
	attacktext = list("slashed")

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	maxbodytemp = 900
	movement_cooldown = 2

	var/mob/living/carbon/human/humanform
	var/obj/item/organ/internal/nano/refactory/refactory
	var/datum/modifier/healing

	var/obj/prev_left_hand
	var/obj/prev_right_hand

	var/human_brute = 0
	var/human_burn = 0

	player_msg = "In this form, you can move a little faster, your health will regenerate as long as you have metal in you, and you can ventcrawl!"

	can_buckle = TRUE //Blobsurfing

/datum/say_list/protean_blob
	speak = list("Blrb?","Sqrsh.","Glrsh!")
	emote_hear = list("squishes softly","spluts quietly","makes wet noises")
	emote_see = list("shifts wetly","undulates placidly")

//Constructor allows passing the human to sync damages
/mob/living/simple_mob/protean_blob/New(var/newloc, var/mob/living/carbon/human/H)
	..()
	if(H)
		humanform = H
		updatehealth()
		refactory = locate() in humanform.internal_organs
		verbs |= /mob/living/proc/ventcrawl
		verbs |= /mob/living/proc/hide
	else
		update_icon()

/mob/living/simple_mob/protean_blob/Login()
	. = ..()
	copy_from_prefs_vr(bellies = FALSE) //Load vore prefs

/mob/living/simple_mob/protean_blob/Destroy()
	humanform = null
	refactory = null
	vore_organs = null
	vore_selected = null
	if(healing)
		healing.expire()
	return ..()

/mob/living/simple_mob/protean_blob/say_understands(var/mob/other, var/datum/language/speaking = null)
	// The parent of this proc and its parent are SHAMS and should be rewritten, but I'm not up to it right now.
	if(!speaking)
		return TRUE // can understand common, they're like, a normal person thing
	return ..()

/mob/living/simple_mob/protean_blob/speech_bubble_appearance()
	return "synthetic"

/mob/living/simple_mob/protean_blob/get_available_emotes()
	return global._robot_default_emotes

/mob/living/simple_mob/protean_blob/init_vore()
	return //Don't make a random belly, don't waste your time

/mob/living/simple_mob/protean_blob/isSynthetic()
	return TRUE // yup

/mob/living/simple_mob/protean_blob/Stat()
	..()
	if(humanform)
		humanform.species.Stat(humanform)

/mob/living/simple_mob/protean_blob/update_icon()
	if(humanform)
		//Still have a refactory
		if(istype(refactory))
			icon_living = "puddle2"

		//Else missing one
		else
			icon_living = "puddle1"

	//Not human-based
	else
		icon_living = "puddle0"

	..()

/mob/living/simple_mob/protean_blob/updatehealth()
	if(!humanform)
		return ..()

	//Set the max
	maxHealth = humanform.getMaxHealth()*2 //HUMANS, and their 'double health', bleh.
	//Set us to their health, but, human health ignores robolimbs so we do it 'the hard way'
	human_brute = humanform.getActualBruteLoss()
	human_burn = humanform.getActualFireLoss()
	health = maxHealth - humanform.getOxyLoss() - humanform.getToxLoss() - humanform.getCloneLoss() - human_brute - human_burn

	//Alive, becoming dead
	if((stat < DEAD) && (health <= 0))
		death()

	//Overhealth
	if(health > getMaxHealth())
		health = getMaxHealth()

	//Grab any other interesting values
	confused = humanform.confused
	radiation = humanform.radiation
	paralysis = humanform.paralysis

	//Update our hud if we have one
	if(healths)
		if(stat != DEAD)
			var/heal_per = (health / getMaxHealth()) * 100
			switch(heal_per)
				if(100 to INFINITY)
					healths.icon_state = "health0"
				if(80 to 100)
					healths.icon_state = "health1"
				if(60 to 80)
					healths.icon_state = "health2"
				if(40 to 60)
					healths.icon_state = "health3"
				if(20 to 40)
					healths.icon_state = "health4"
				if(0 to 20)
					healths.icon_state = "health5"
				else
					healths.icon_state = "health6"
		else
			healths.icon_state = "health7"

// All the damage and such to the blob translates to the human
/mob/living/simple_mob/protean_blob/apply_effect(var/effect = 0, var/effecttype = STUN, var/blocked = 0, var/check_protection = 1)
	if(humanform)
		return humanform.apply_effect(effect, effecttype, blocked, check_protection)
	else
		return ..()

/mob/living/simple_mob/protean_blob/adjustBruteLoss(var/amount,var/include_robo)
	amount *= 1.5
	if(humanform)
		return humanform.adjustBruteLoss(amount)
	else
		return ..()

/mob/living/simple_mob/protean_blob/adjustFireLoss(var/amount,var/include_robo)
	amount *= 1.5
	if(humanform)
		return humanform.adjustFireLoss(amount)
	else
		return ..()

/mob/living/simple_mob/protean_blob/adjustToxLoss(amount)
	if(humanform)
		return humanform.adjustToxLoss(amount)
	else
		return ..()

/mob/living/simple_mob/protean_blob/adjustOxyLoss(amount)
	if(humanform)
		return humanform.adjustOxyLoss(amount)
	else
		return ..()

/mob/living/simple_mob/protean_blob/adjustHalLoss(amount)
	if(humanform)
		return humanform.adjustHalLoss(amount)
	else
		return ..()

/mob/living/simple_mob/protean_blob/adjustCloneLoss(amount)
	if(humanform)
		return humanform.adjustCloneLoss(amount)
	else
		return ..()

/mob/living/simple_mob/protean_blob/emp_act(severity)
	if(humanform)
		return humanform.emp_act(severity)
	else
		return ..()

/mob/living/simple_mob/protean_blob/ex_act(severity)
	if(humanform)
		return humanform.ex_act(severity)
	else
		return ..()

/mob/living/simple_mob/protean_blob/rad_act(severity)
	if(humanform)
		return humanform.ex_act(severity)
	else
		return ..()

/mob/living/simple_mob/protean_blob/bullet_act(obj/item/projectile/P)
	if(humanform)
		return humanform.bullet_act(P)
	else
		return ..()

/mob/living/simple_mob/protean_blob/death(gibbed, deathmessage = "dissolves away, leaving only a few spare parts!")
	if(humanform)
		humanform.death(gibbed, deathmessage)
	else
		animate(src, alpha = 0, time = 2 SECONDS)
		sleep(2 SECONDS)

	if(!QDELETED(src)) // Human's handle death should have taken us, but maybe we were adminspawned or something without a human counterpart
		qdel(src)

/mob/living/simple_mob/protean_blob/Life()
	. = ..()
	if(. && istype(refactory) && humanform)
		if(!healing && (human_brute || human_burn) && refactory.get_stored_material(MAT_STEEL) >= 100)
			healing = humanform.add_modifier(/datum/modifier/protean/steel, origin = refactory)
		else if(healing && !(human_brute || human_burn))
			healing.expire()
			healing = null

/mob/living/simple_mob/protean_blob/lay_down()
	..()
	if(resting)
		animate(src,alpha = 40,time = 1 SECOND)
		mouse_opacity = 0
		plane = ABOVE_OBJ_PLANE
	else
		mouse_opacity = 1
		icon_state = "wake"
		animate(src,alpha = 255,time = 1 SECOND)
		plane = MOB_PLANE
		spawn(7)
			update_icon()
			//Potential glob noms
			if(can_be_drop_pred) //Toggleable in vore panel
				var/list/potentials = living_mobs(0)
				if(potentials.len)
					var/mob/living/target = pick(potentials)
					if(istype(target) && target.devourable && target.can_be_drop_prey && vore_selected)
						if(target.buckled)
							target.buckled.unbuckle_mob(target, force = TRUE)
						target.forceMove(vore_selected)
						to_chat(target,"<span class='warning'>\The [src] quickly engulfs you, [vore_selected.vore_verb]ing you into their [vore_selected.name]!</span>")

/mob/living/simple_mob/protean_blob/attack_target(var/atom/A)
	if(refactory && istype(A,/obj/item/stack/material))
		var/obj/item/stack/material/S = A
		var/substance = S.material.name
		var allowed = FALSE
		for(var/material in PROTEAN_EDIBLE_MATERIALS)
			if(material == substance) allowed = TRUE
		if(!allowed)
			return
		if(refactory.add_stored_material(S.material.name,1*S.perunit) && S.use(1))
			visible_message("<b>[name]</b> gloms over some of \the [S], absorbing it.")
	else
		return ..()

/mob/living/simple_mob/protean_blob/attackby(var/obj/item/O, var/mob/user)
	if(refactory && istype(O,/obj/item/stack/material))
		var/obj/item/stack/material/S = O
		var/substance = S.material.name
		var allowed = FALSE
		for(var/material in PROTEAN_EDIBLE_MATERIALS)
			if(material == substance) allowed = TRUE
		if(!allowed)
			return
		if(refactory.add_stored_material(S.material.name,1*S.perunit) && S.use(1))
			visible_message("<b>[name]</b> gloms over some of \the [S], absorbing it.")
	else
		return ..()

/mob/living/simple_mob/protean_blob/MouseEntered(location,control,params)
	if(resting)
		return
	..()

var/global/list/disallowed_protean_accessories = list(
	/obj/item/clothing/accessory/holster,
	/obj/item/clothing/accessory/storage,
	/obj/item/clothing/accessory/armor
	)

// Helpers - Unsafe, WILL perform change.
/mob/living/carbon/human/proc/nano_intoblob(force)
	if(!force && !isturf(loc))
		to_chat(src,"<span class='warning'>You can't change forms while inside something.</span>")
		return

	var/panel_was_up = FALSE
	if(client?.statpanel == "Protean")
		panel_was_up = TRUE

	handle_grasp() //It's possible to blob out before some key parts of the life loop. This results in things getting dropped at null. TODO: Fix the code so this can be done better.
	remove_micros(src, src) //Living things don't fare well in roblobs.
	if(buckled)
		buckled.unbuckle_mob()
	if(LAZYLEN(buckled_mobs))
		for(var/buckledmob in buckled_mobs)
			riding_datum.force_dismount(buckledmob)
	if(pulledby)
		pulledby.stop_pulling()
	stop_pulling()

	//Record where they should go
	var/atom/creation_spot = drop_location()

	//Create our new blob
	var/mob/living/simple_mob/protean_blob/blob = new(creation_spot,src)

	//Drop all our things
	var/list/things_to_drop = contents.Copy()
	var/list/things_to_not_drop = list(w_uniform,nif,l_store,r_store,wear_id,l_ear,r_ear) //And whatever else we decide for balancing.

	/* No for now, because insta-pepperspray or flash on unblob
	if(l_hand && l_hand.w_class <= ITEMSIZE_SMALL) //Hands but only if small or smaller
		things_to_not_drop += l_hand
	if(r_hand && r_hand.w_class <= ITEMSIZE_SMALL)
		things_to_not_drop += r_hand
	*/

	things_to_drop -= things_to_not_drop //Crunch the lists
	things_to_drop -= organs //Mah armbs
	things_to_drop -= internal_organs //Mah sqeedily spooch

	for(var/obj/item/I in things_to_drop) //rip hoarders
		drop_from_inventory(I)

	if(w_uniform && istype(w_uniform,/obj/item/clothing)) //No webbings tho. We do this after in case a suit was in the way
		var/obj/item/clothing/uniform = w_uniform
		if(LAZYLEN(uniform.accessories))
			for(var/obj/item/clothing/accessory/A in uniform.accessories)
				if(is_type_in_list(A, disallowed_protean_accessories))
					uniform.remove_accessory(null,A) //First param is user, but adds fingerprints and messages

	//Size update
	blob.transform = matrix()*size_multiplier
	blob.size_multiplier = size_multiplier

	if(l_hand) blob.prev_left_hand = l_hand //Won't save them if dropped above, but necessary if handdrop is disabled.
	if(r_hand) blob.prev_right_hand = r_hand

	//Put our owner in it (don't transfer var/mind)
	blob.ckey = ckey
	blob.ooc_notes = ooc_notes
	temporary_form = blob

	//Mail them to nullspace
	moveToNullspace()

	//Message
	blob.visible_message("<b>[src.name]</b> collapses into a gooey blob!")

	//Duration of the to_puddle iconstate that the blob starts with
	sleep(13)
	blob.update_icon() //Will remove the collapse anim

	//Transfer vore organs
	blob.vore_organs = vore_organs
	blob.vore_selected = vore_selected
	for(var/obj/belly/B as anything in vore_organs)
		B.forceMove(blob)
		B.owner = blob

	//We can still speak our languages!
	blob.languages = languages.Copy()

	//Flip them to the protean panel
	if(panel_was_up)
		client?.statpanel = "Protean"

	//Return our blob in case someone wants it
	return blob

//For some reason, there's no way to force drop all the mobs grabbed. This ought to fix that. And be moved elsewhere. Call with caution, doesn't handle cycles.
/proc/remove_micros(var/src, var/mob/root)
	for(var/obj/item/I in src)
		remove_micros(I, root) //Recursion. I'm honestly depending on there being no containment loop, but at the cost of performance that can be fixed too.
		if(istype(I, /obj/item/weapon/holder))
			root.remove_from_mob(I)

/mob/living/carbon/human/proc/nano_outofblob(var/mob/living/simple_mob/protean_blob/blob, force)
	if(!istype(blob))
		return

	if(!force && !isturf(blob.loc))
		to_chat(blob,"<span class='warning'>You can't change forms while inside something.</span>")
		return

	var/panel_was_up = FALSE
	if(client?.statpanel == "Protean")
		panel_was_up = TRUE

	if(buckled)
		buckled.unbuckle_mob()
	if(LAZYLEN(buckled_mobs))
		for(var/buckledmob in buckled_mobs)
			riding_datum.force_dismount(buckledmob)
	if(pulledby)
		pulledby.stop_pulling()
	stop_pulling()

	//Stop healing if we are
	if(blob.healing)
		blob.healing.expire()

	//Play the animation
	blob.icon_state = "from_puddle"

	//Message
	blob.visible_message("<b>[src.name]</b> reshapes into a humanoid appearance!")

	//Duration of above animation
	sleep(8)

	//Record where they should go
	var/atom/reform_spot = blob.drop_location()

	//Size update
	resize(blob.size_multiplier, FALSE, ignore_prefs = TRUE)

	//Move them back where the blob was
	forceMove(reform_spot)

	//Put our owner in it (don't transfer var/mind)
	ckey = blob.ckey
	ooc_notes = blob.ooc_notes // Lets give the protean any updated notes from blob form.
	temporary_form = null

	//Transfer vore organs
	vore_selected = blob.vore_selected
	for(var/obj/belly/B as anything in blob.vore_organs)
		B.forceMove(src)
		B.owner = src

	if(blob.prev_left_hand) put_in_l_hand(blob.prev_left_hand) //The restore for when reforming.
	if(blob.prev_right_hand) put_in_r_hand(blob.prev_right_hand)

	Life(1) //Fix my blindness right meow //Has to be moved up here, there exists a circumstance where blob could be deleted without vore organs moving right.

	//Get rid of friend blob
	qdel(blob)

	//Flip them to the protean panel
	if(panel_was_up)
		client?.statpanel = "Protean"

	//Return ourselves in case someone wants it
	return src

/mob/living/simple_mob/protean_blob/CanStumbleVore(mob/living/target)
	if(target == humanform)
		return FALSE
	return ..()

/mob/living/simple_mob/protean_blob/CanStumbleVore(mob/living/target)
	if(target == humanform)
		return FALSE
	return ..()

/mob/living/carbon/human/CanStumbleVore(mob/living/target)
	if(istype(target, /mob/living/simple_mob/protean_blob))
		var/mob/living/simple_mob/protean_blob/PB = target
		if(PB.humanform == src)
			return FALSE
	return ..()