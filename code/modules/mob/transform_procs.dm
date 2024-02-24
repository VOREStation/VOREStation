/mob/living/carbon/human/proc/monkeyize()
	if (transforming)
		return
	for(var/obj/item/W in src)
		if (W==w_uniform) // will be torn
			continue
		drop_from_inventory(W)
	regenerate_icons()
	transforming = 1
	canmove = 0
	stunned = 1
	icon = null
	invisibility = 101
	for(var/t in organs)
		qdel(t)
	var/atom/movable/overlay/animation = new /atom/movable/overlay( loc )
	animation.icon_state = "blank"
	animation.icon = 'icons/mob/mob.dmi'
	animation.master = src
	flick("h2monkey", animation)
	sleep(48)
	//animation = null

	transforming = 0
	stunned = 0
	update_canmove()
	invisibility = initial(invisibility)

	if(!species.primitive_form) //If the creature in question has no primitive set, this is going to be messy.
		gib()
		return

	for(var/obj/item/W in src)
		drop_from_inventory(W)
	set_species(species.primitive_form)
	dna.SetSEState(MONKEYBLOCK,1)
	dna.SetSEValueRange(MONKEYBLOCK,0xDAC, 0xFFF)

	to_chat(src, "<B>You are now [species.name]. </B>")
	qdel(animation)

	return src

/mob/new_player/AIize(var/move = TRUE)
	spawning = 1
	return ..()

/mob/living/carbon/human/AIize(var/move = TRUE) // 'move' argument needs defining here too because BYOND is dumb
	if (transforming)
		return
	for(var/t in organs)
		qdel(t)

	//VOREStation Edit Start - Hologram examine flavor
	var/mob/living/silicon/ai/O = ..(move)
	if(O)
		O.flavor_text = O.client?.prefs?.flavor_texts["general"]
		return O
	//VOREStation Edit End

	return ..(move)

/mob/living/carbon/AIize(var/move = TRUE)
	if (transforming)
		return
	for(var/obj/item/W in src)
		drop_from_inventory(W)
	transforming = 1
	canmove = 0
	icon = null
	invisibility = 101
	return ..()

/mob/proc/AIize(var/move = TRUE)
	if(client)
		src << sound(null, repeat = 0, wait = 0, volume = 85, channel = 1) // stop the jams for AIs

	var/newloc = loc
	if(move)
		var/obj/loc_landmark
		for(var/obj/effect/landmark/start/sloc in landmarks_list)
			if (sloc.name != "AI")
				continue
			if ((locate(/mob/living) in sloc.loc) || (locate(/obj/structure/AIcore) in sloc.loc))
				continue
			loc_landmark = sloc
		if (!loc_landmark)
			for(var/obj/effect/landmark/tripai in landmarks_list)
				if (tripai.name == "tripai")
					if((locate(/mob/living) in tripai.loc) || (locate(/obj/structure/AIcore) in tripai.loc))
						continue
					loc_landmark = tripai
		if (!loc_landmark)
			to_chat(src, "Oh god sorry we can't find an unoccupied AI spawn location, so we're spawning you on top of someone.")
			for(var/obj/effect/landmark/start/sloc in landmarks_list)
				if (sloc.name == "AI")
					loc_landmark = sloc

		newloc = loc_landmark.loc

	var/mob/living/silicon/ai/O = new (newloc, using_map.default_law_type,,1)//No MMI but safety is in effect.
	O.invisibility = 0
	O.aiRestorePowerRoutine = 0

	if(mind)
		mind.transfer_to(O)
		O.mind.original = O
	else
		O.key = key

	//Languages
	add_language("Robot Talk", 1)
	add_language(LANGUAGE_GALCOM, 1)
	add_language(LANGUAGE_SOL_COMMON, 1)
	add_language(LANGUAGE_UNATHI, 1)
	add_language(LANGUAGE_SIIK, 1)
	add_language(LANGUAGE_AKHANI, 1)
	add_language(LANGUAGE_SKRELLIAN, 1)
	add_language(LANGUAGE_TRADEBAND, 1)
	add_language(LANGUAGE_GUTTER, 1)
	add_language(LANGUAGE_EAL, 1)
	add_language(LANGUAGE_SCHECHI, 1)
	add_language(LANGUAGE_SIGN, 1)
	add_language(LANGUAGE_TERMINUS, 1)
	add_language(LANGUAGE_ZADDAT, 0)

	// Lorefolks say it may be so.
	if(O.client && O.client.prefs)
		var/datum/preferences/B = O.client.prefs
		if(LANGUAGE_ROOTGLOBAL in B.alternate_languages)
			O.add_language(LANGUAGE_ROOTGLOBAL, 1)
		if(LANGUAGE_ROOTLOCAL in B.alternate_languages)
			O.add_language(LANGUAGE_ROOTLOCAL, 1)

	O.on_mob_init()

	O.add_ai_verbs()

	O.rename_self("ai",1)
	spawn(0)	// Mobs still instantly del themselves, thus we need to spawn or O will never be returned
		qdel(src)
	return O

//human -> robot
/mob/living/carbon/human/proc/Robotize()
	if (transforming)
		return
	for(var/obj/item/W in src)
		drop_from_inventory(W)
	regenerate_icons()
	transforming = 1
	canmove = 0
	icon = null
	invisibility = 101
	for(var/t in organs)
		qdel(t)

	var/mob/living/silicon/robot/O = new /mob/living/silicon/robot( loc )

	O.gender = gender
	O.invisibility = 0

	if(mind)		//TODO
		mind.transfer_to(O)
		if(O.mind.assigned_role == "Cyborg")
			O.mind.original = O
		else if(mind && mind.special_role)
			O.mind.store_memory("In case you look at this after being borged, the objectives are only here until I find a way to make them not show up for you, as I can't simply delete them without screwing up round-end reporting. --NeoFite")
	else
		O.key = key

	O.loc = loc
	O.job = "Cyborg"
	if(O.mind.assigned_role == "Cyborg")
		if(O.mind.role_alt_title == "Robot")
			O.mmi = new /obj/item/device/mmi/digital/posibrain(O)
		else if(O.mind.role_alt_title == "Drone")
			O.mmi = new /obj/item/device/mmi/digital/robot(O)
		else
			O.mmi = new /obj/item/device/mmi(O)

		O.mmi.transfer_identity(src)

	if(O.client && O.client.prefs)
		var/datum/preferences/B = O.client.prefs
		for(var/language in B.alternate_languages)
			O.add_language(language)
		O.resize(B.size_multiplier, animate = TRUE, ignore_prefs = TRUE)
		O.fuzzy = B.fuzzy
		O.custom_speech_bubble = B.custom_speech_bubble

	callHook("borgify", list(O))
	O.namepick()

	spawn(0)	// Mobs still instantly del themselves, thus we need to spawn or O will never be returned
		qdel(src)
	return O

//human -> alien
/mob/living/carbon/human/proc/Alienize()
	if (transforming)
		return
	for(var/obj/item/W in src)
		drop_from_inventory(W)
	regenerate_icons()
	transforming = 1
	canmove = 0
	icon = null
	invisibility = 101
	for(var/t in organs)
		qdel(t)

	var/alien_caste = pick("Hunter","Sentinel","Drone")
	var/mob/living/carbon/human/new_xeno = create_new_xenomorph(alien_caste,loc)

	new_xeno.a_intent = I_HURT
	new_xeno.key = key

	to_chat(new_xeno, "<B>You are now an alien.</B>")
	qdel(src)
	return


/mob/living/carbon/human/proc/corgize()
	if (transforming)
		return
	for(var/obj/item/W in src)
		drop_from_inventory(W)
	regenerate_icons()
	transforming = 1
	canmove = 0
	icon = null
	invisibility = 101
	for(var/t in organs)	//this really should not be necessary
		qdel(t)

	var/mob/living/simple_mob/animal/passive/dog/corgi/new_corgi = new /mob/living/simple_mob/animal/passive/dog/corgi (loc)
	new_corgi.a_intent = I_HURT
	new_corgi.key = key

	to_chat(new_corgi, "<B>You are now a Corgi. Yap Yap!</B>")
	qdel(src)
	return

/mob/living/carbon/human/Animalize()

	var/list/mobtypes = typesof(/mob/living/simple_mob)
	var/mobpath = tgui_input_list(usr, "Which type of mob should [src] turn into?", "Choose a type", mobtypes)

	if(!safe_animal(mobpath))
		to_chat(usr, span_red("Sorry but this mob type is currently unavailable."))
		return

	if(transforming)
		return
	for(var/obj/item/W in src)
		drop_from_inventory(W)

	regenerate_icons()
	transforming = 1
	canmove = 0
	icon = null
	invisibility = 101

	for(var/t in organs)
		qdel(t)

	var/mob/new_mob = new mobpath(src.loc)

	new_mob.key = key
	new_mob.a_intent = I_HURT


	to_chat(new_mob, "You suddenly feel more... animalistic.")
	spawn()
		qdel(src)
	return

/mob/proc/Animalize()

	var/list/mobtypes = typesof(/mob/living/simple_mob)
	var/mobpath = tgui_input_list(usr, "Which type of mob should [src] turn into?", "Choose a type", mobtypes)

	if(!safe_animal(mobpath))
		to_chat(usr, span_red("Sorry but this mob type is currently unavailable."))
		return

	var/mob/new_mob = new mobpath(src.loc)

	new_mob.key = key
	new_mob.a_intent = I_HURT
	to_chat(new_mob, "You feel more... animalistic")

	qdel(src)

/* Certain mob types have problems and should not be allowed to be controlled by players.
 *
 * This proc is here to force coders to manually place their mob in this list, hopefully tested.
 * This also gives a place to explain -why- players shouldnt be turn into certain mobs and hopefully someone can fix them.
 */
/mob/proc/safe_animal(var/MP)

//Bad mobs! - Remember to add a comment explaining what's wrong with the mob
	if(!MP)
		return 0	//Sanity, this should never happen.

/*
	if(ispath(MP, /mob/living/simple_mob/space_worm))
		return 0 //Unfinished. Very buggy, they seem to just spawn additional space worms everywhere and eating your own tail results in new worms spawning.
*/

//Good mobs!
	if(ispath(MP, /mob/living/simple_mob/animal/passive/cat))
		return 1
	if(ispath(MP, /mob/living/simple_mob/animal/passive/dog))
		return 1
	if(ispath(MP, /mob/living/simple_mob/animal/passive/crab))
		return 1
	if(ispath(MP, /mob/living/simple_mob/animal/space/carp))
		return 1
	if(ispath(MP, /mob/living/simple_mob/construct))
		return 1
	if(ispath(MP, /mob/living/simple_mob/tomato))
		return 1
	if(ispath(MP, /mob/living/simple_mob/animal/passive/mouse))
		return 1 //It is impossible to pull up the player panel for mice (Fixed! - Nodrak)
	if(ispath(MP, /mob/living/simple_mob/animal/space/bear))
		return 1 //Bears will auto-attack mobs, even if they're player controlled (Fixed! - Nodrak)
	if(ispath(MP, /mob/living/simple_mob/animal/passive/bird/parrot))
		return 1 //Parrots are no longer unfinished! -Nodrak

	//Not in here? Must be untested!
	return 0
