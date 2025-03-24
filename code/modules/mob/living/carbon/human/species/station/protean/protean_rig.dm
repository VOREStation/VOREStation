/*
 proteans
*/
/obj/item/rig/protean
	name = "nanosuit control cluster"
	suit_type = "nanomachine"
	icon = 'icons/obj/rig_modules_vr.dmi'
	default_mob_icon = null	//Actually having a forced sprite for Proteans is ugly af. I'm not gonna make this a toggle
	icon_state = "nanomachine_rig"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 100, rad = 100)
	siemens_coefficient= 1
	slowdown = 0
	offline_slowdown = 0
	seal_delay = 0
	var/mob/living/myprotean
	initial_modules = list(/obj/item/rig_module/protean/syphon, /obj/item/rig_module/protean/armor, /obj/item/rig_module/protean/healing)

	helm_type = /obj/item/clothing/head/helmet/space/rig/protean //These are important for sprite pointers
	boot_type = /obj/item/clothing/shoes/magboots/rig/protean
	chest_type = /obj/item/clothing/suit/space/rig/protean
	glove_type = /obj/item/clothing/gloves/gauntlets/rig/protean
	protean = 1
	offline_vision_restriction = 0
	open = 1
	cell_type =  /obj/item/cell/protean
	var/dead = 0
	//interface_path = "RIGSuit_protean"
	//ai_interface_path = "RIGSuit_protean"
	var/sealed = 0
	var/assimilated_rig
	var/can_assimilate_rig = FALSE

/obj/item/rig/protean/relaymove(mob/user, var/direction)
	if(user.stat || user.stunned)
		return
	forced_move(direction, user, 0)

/obj/item/rig/protean/check_suit_access(mob/living/user)
	if(user == myprotean)
		return 1
	return ..()

/obj/item/rig/protean/digest_act(atom/movable/item_storage = null)
	return 0

/obj/item/rig/protean/ex_act(severity)
	return

/obj/item/rig/protean/Initialize(mapload, var/mob/living/carbon/human/P)
	if(P)
		var/datum/species/protean/S = P.species
		S.OurRig = src
		if(P.back)
			addtimer(CALLBACK(src, PROC_REF(AssimilateBag), P, 1, P.back), 3)
			myprotean = P
		else
			to_chat(P, span_notice("You should have spawned with a backpack to assimilate into your RIG. Try clicking it with a backpack."))
	. = ..()

/obj/item/rig/protean/Destroy()
	if(myprotean)
		var/mob/living/carbon/human/P = myprotean
		if(!ishuman(P) && isprotblob(myprotean))
			var/mob/living/simple_mob/protean_blob/blob = myprotean
			P = blob.humanform
		if(ishuman(P))
			var/datum/species/protean/S = P?.species
			S?.OurRig = null
		myprotean = null
	. = ..()


/obj/item/rig/proc/AssimilateBag(var/mob/living/carbon/human/P, var/spawned, var/obj/item/storage/backpack/B)
	if(istype(B,/obj/item/storage/backpack))
		if(spawned)
			B = P.back
			P.unEquip(P.back)
		if(QDELETED(B)) // for mannequins or such
			return
		B.forceMove(src)
		rig_storage = B
		P.drop_item(B)
		to_chat(P, span_notice("[B] has been integrated into the [src]."))
		if(spawned)	//This feels very dumb to have a second if but I'm lazy
			P.equip_to_slot_if_possible(src, slot_back)
		src.Moved()
	else
		to_chat(P,span_warning("Your rigsuit can only assimilate a backpack into itself. If you are seeing this message, and you do not have a rigsuit, tell a coder."))

/obj/item/rig/protean/verb/RemoveBag()
	set name = "Remove Stored Bag"
	set category = "Object"

	if(rig_storage)
		usr.put_in_hands(rig_storage)
		rig_storage = null
	else
		to_chat(usr, "This Rig does not have a bag installed. Use a bag on it to install one.")

/obj/item/rig/protean/attack_hand(mob/user as mob)
	if (src.loc == user)
		if(rig_storage)
			src.rig_storage.open(user)
	else
		..()
		for(var/mob/M in range(1))
			if (M.s_active == src)
				src.rig_storage.close(M)
	src.add_fingerprint(user)
	return

/obj/item/clothing/head/helmet/space/rig/protean
	name = "mass"
	desc = "A helmet-shaped clump of nanomachines."
	light_overlay = "should not use a light overlay"
	species_restricted = list(SPECIES_PROTEAN, SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_TAJARAN, SPECIES_UNATHI, SPECIES_NEVREAN, SPECIES_AKULA, SPECIES_SERGAL, SPECIES_ZORREN_HIGH, SPECIES_VULPKANIN, SPECIES_PROMETHEAN, SPECIES_XENOHYBRID, SPECIES_VOX, SPECIES_TESHARI, SPECIES_VASILISSAN, SPECIES_XENOMORPH_HYBRID)
	sprite_sheets = list(
		SPECIES_PROTEAN			 = 'icons/mob/head.dmi',
		SPECIES_HUMAN			 = 'icons/mob/head.dmi',
		SPECIES_TAJARAN 		 = 'icons/mob/species/tajaran/helmet.dmi',
		SPECIES_SKRELL 			 = 'icons/mob/species/skrell/helmet.dmi',
		SPECIES_UNATHI 			 = 'icons/mob/species/unathi/helmet.dmi',
		SPECIES_XENOHYBRID		 = 'icons/mob/species/unathi/helmet.dmi',
		SPECIES_AKULA 			 = 'icons/mob/species/akula/helmet.dmi',
		SPECIES_SERGAL			 = 'icons/mob/species/sergal/helmet.dmi',
		SPECIES_NEVREAN			 = 'icons/mob/species/sergal/helmet.dmi',
		SPECIES_VULPKANIN 		 = 'icons/mob/species/vulpkanin/helmet.dmi',
		SPECIES_ZORREN_HIGH 	 = 'icons/mob/species/fox/helmet.dmi',
		SPECIES_FENNEC 			 = 'icons/mob/species/vulpkanin/helmet.dmi',
		SPECIES_PROMETHEAN		 = 'icons/mob/species/skrell/helmet.dmi',
		SPECIES_TESHARI 		 = 'icons/mob/species/teshari/helmet.dmi',
		SPECIES_VASILISSAN		 = 'icons/mob/species/skrell/helmet.dmi',
		SPECIES_VOX				 = 'icons/mob/species/vox/head.dmi',
		SPECIES_XENOMORPH_HYBRID = 'icons/mob/species/xenomorph_hybrid/helmet.dmi'
		)

	sprite_sheets_obj = list(
		SPECIES_PROTEAN			 = 'icons/mob/head.dmi',
		SPECIES_HUMAN			 = 'icons/mob/head.dmi',
		SPECIES_TAJARAN 		 = 'icons/mob/head.dmi',
		SPECIES_SKRELL 			 = 'icons/mob/head.dmi',
		SPECIES_UNATHI 			 = 'icons/mob/head.dmi',
		SPECIES_XENOHYBRID		 = 'icons/mob/head.dmi',
		SPECIES_AKULA 			 = 'icons/mob/head.dmi',
		SPECIES_SERGAL			 = 'icons/mob/head.dmi',
		SPECIES_NEVREAN			 = 'icons/mob/head.dmi',
		SPECIES_VULPKANIN 		 = 'icons/mob/head.dmi',
		SPECIES_ZORREN_HIGH 	 = 'icons/mob/head.dmi',
		SPECIES_FENNEC 			 = 'icons/mob/head.dmi',
		SPECIES_PROMETHEAN		 = 'icons/mob/head.dmi',
		SPECIES_TESHARI 		 = 'icons/mob/head.dmi',
		SPECIES_VASILISSAN		 = 'icons/mob/head.dmi',
		SPECIES_VOX				 = 'icons/mob/head.dmi',
		SPECIES_XENOMORPH_HYBRID = 'icons/mob/head.dmi'
		)
	icon = 'icons/inventory/head/item.dmi'
	default_worn_icon = 'icons/mob/head.dmi'
	icon_state = "nanomachine_rig"
	//item_state = "nanomachine_rig"

/obj/item/clothing/gloves/gauntlets/rig/protean
	name = "mass"
	desc = "Glove-shaped clusters of nanomachines."
	siemens_coefficient= 0
	species_restricted = list(SPECIES_PROTEAN, SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_TAJARAN, SPECIES_UNATHI, SPECIES_NEVREAN, SPECIES_AKULA, SPECIES_SERGAL, SPECIES_ZORREN_HIGH, SPECIES_VULPKANIN, SPECIES_PROMETHEAN, SPECIES_XENOHYBRID, SPECIES_VOX, SPECIES_TESHARI, SPECIES_VASILISSAN, SPECIES_XENOMORPH_HYBRID)
	sprite_sheets = list(
		SPECIES_PROTEAN			 = 'icons/mob/hands.dmi',
		SPECIES_HUMAN			 = 'icons/mob/hands.dmi',
		SPECIES_TAJARAN 		 = 'icons/mob/hands.dmi',
		SPECIES_SKRELL 			 = 'icons/mob/hands.dmi',
		SPECIES_UNATHI 			 = 'icons/mob/hands.dmi',
		SPECIES_XENOHYBRID		 = 'icons/mob/hands.dmi',
		SPECIES_AKULA 			 = 'icons/mob/hands.dmi',
		SPECIES_SERGAL			 = 'icons/mob/hands.dmi',
		SPECIES_NEVREAN			 = 'icons/mob/hands.dmi',
		SPECIES_VULPKANIN		 = 'icons/mob/hands.dmi',
		SPECIES_ZORREN_HIGH 	 = 'icons/mob/hands.dmi',
		SPECIES_FENNEC			 = 'icons/mob/hands.dmi',
		SPECIES_PROMETHEAN		 = 'icons/mob/hands.dmi',
		SPECIES_TESHARI 		 = 'icons/mob/species/teshari/hands.dmi',
		SPECIES_VASILISSAN		 = 'icons/mob/hands.dmi',
		SPECIES_VOX				 = 'icons/mob/species/vox/gloves.dmi',
		SPECIES_XENOMORPH_HYBRID = 'icons/mob/species/xenomorph_hybrid/gloves.dmi'
		)

	sprite_sheets_obj = list(
		SPECIES_HUMAN			 = 'icons/mob/hands.dmi',
		SPECIES_TAJARAN 		 = 'icons/mob/hands.dmi',
		SPECIES_SKRELL 			 = 'icons/mob/hands.dmi',
		SPECIES_UNATHI 			 = 'icons/mob/hands.dmi',
		SPECIES_XENOHYBRID		 = 'icons/mob/hands.dmi',
		SPECIES_AKULA 			 = 'icons/mob/hands.dmi',
		SPECIES_SERGAL			 = 'icons/mob/hands.dmi',
		SPECIES_NEVREAN			 = 'icons/mob/hands.dmi',
		SPECIES_VULPKANIN 		 = 'icons/mob/hands.dmi',
		SPECIES_ZORREN_HIGH 	 = 'icons/mob/hands.dmi',
		SPECIES_FENNEC 			 = 'icons/mob/hands.dmi',
		SPECIES_PROMETHEAN		 = 'icons/mob/hands.dmi',
		SPECIES_TESHARI 		 = 'icons/mob/hands.dmi',
		SPECIES_VASILISSAN		 = 'icons/mob/hands.dmi',
		SPECIES_VOX				 = 'icons/mob/hands.dmi',
		SPECIES_XENOMORPH_HYBRID = 'icons/mob/hands.dmi'
		)
	icon = 'icons/inventory/hands/item.dmi'
	default_worn_icon = 'icons/mob/hands.dmi'
	icon_state = "nanomachine_rig"
	//item_state = "nanomachine_rig"

/obj/item/clothing/shoes/magboots/rig/protean
	name = "mass"
	desc = "Boot-shaped clusters of nanomachines."
	species_restricted = list(SPECIES_PROTEAN, SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_TAJARAN, SPECIES_UNATHI, SPECIES_NEVREAN, SPECIES_AKULA, SPECIES_SERGAL, SPECIES_ZORREN_HIGH, SPECIES_VULPKANIN, SPECIES_PROMETHEAN, SPECIES_XENOHYBRID, SPECIES_VOX, SPECIES_TESHARI, SPECIES_VASILISSAN, SPECIES_XENOMORPH_HYBRID)
	sprite_sheets = list(
		SPECIES_TESHARI 		 = 'icons/mob/species/teshari/feet.dmi',
		SPECIES_VOX				 = 'icons/mob/species/vox/shoes.dmi',
		SPECIES_XENOMORPH_HYBRID = 'icons/mob/species/xenomorph_hybrid/shoes.dmi'
		)
	sprite_sheets_obj = list()
	icon = 'icons/inventory/feet/item.dmi'
	default_worn_icon = 'icons/mob/feet.dmi'
	icon_state = "nanomachine_rig"
	//item_state = "nanomachine_rig"

/obj/item/clothing/suit/space/rig/protean
	name = "mass"
	desc = "A body-hugging mass of nanomachines."
	can_breach = 0
	species_restricted = list(SPECIES_PROTEAN, SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_TAJARAN, SPECIES_UNATHI, SPECIES_NEVREAN, SPECIES_AKULA, SPECIES_SERGAL, SPECIES_ZORREN_HIGH, SPECIES_VULPKANIN, SPECIES_PROMETHEAN, SPECIES_XENOHYBRID, SPECIES_VOX, SPECIES_TESHARI, SPECIES_VASILISSAN, SPECIES_XENOMORPH_HYBRID)
	allowed = list(POCKET_GENERIC, POCKET_EMERGENCY, POCKET_ALL_TANKS, POCKET_SUIT_REGULATORS, POCKET_EXPLO, /obj/item/storage/backpack)
	sprite_sheets = list(
		SPECIES_TESHARI 		 = 'icons/mob/species/teshari/suit.dmi',
		SPECIES_VOX				 = 'icons/mob/species/vox/suit.dmi',
		SPECIES_XENOMORPH_HYBRID = 'icons/mob/species/xenomorph_hybrid/suit.dmi'
		)

	sprite_sheets_obj = list()
	icon = 'icons/inventory/suit/item.dmi'
	default_worn_icon = 'icons/mob/spacesuit.dmi'
	icon_state = "nanomachine_rig"
	//item_state = "nanomachine_rig"

//Copy pasted most of this proc from base because I don't feel like rewriting the base proc with a shit load of exceptions
/obj/item/rig/protean/attackby(obj/item/W, mob/living/user)
	if(!istype(user))
		return 0
	if(dead)
		switch(dead)
			if(1)
				if(W.has_tool_quality(TOOL_SCREWDRIVER))
					playsound(src, W.usesound, 50, 1)
					if(do_after(user,50,src,exclusive = TASK_ALL_EXCLUSIVE))
						to_chat(user, span_notice("You unscrew the maintenace panel on the [src]."))
						dead +=1
				return
			if(2)
				if(istype(W, /obj/item/protean_reboot))//placeholder
					if(do_after(user,50,src,exclusive = TASK_ALL_EXCLUSIVE))
						playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)
						to_chat(user, span_notice("You carefully slot [W] in the [src]."))
						dead +=1
						qdel(W)
				return
			if(3)
				if(istype(W, /obj/item/stack/nanopaste))
					if(do_after(user,50,src,exclusive = TASK_ALL_EXCLUSIVE))
						playsound(src, 'sound/effects/ointment.ogg', 50, 1)
						to_chat(user, span_notice("You slather the interior confines of the [src] with the [W]."))
						dead +=1
						W?:use(1)
				return
			if(4)
				if(istype(W, /obj/item/shockpaddles))
					if(W?:can_use(user))
						to_chat(user, span_notice("You hook up the [W] to the contact points in the maintenance assembly"))
						if(do_after(user,50,src,exclusive = TASK_ALL_EXCLUSIVE))
							playsound(src, 'sound/machines/defib_charge.ogg', 50, 0)
							if(do_after(user,10,src))
								playsound(src, 'sound/machines/defib_zap.ogg', 50, 1, -1)
								playsound(src, 'sound/machines/defib_success.ogg', 50, 0)
								new /obj/effect/gibspawner/robot(src.loc)
								src.atom_say("Contact received! Reassembly nanites calibrated. Estimated time to resucitation: 1 minute 30 seconds")
								addtimer(CALLBACK(src, PROC_REF(make_alive), myprotean?:humanform), 900)
				return
	if(istype(W,/obj/item/rig))
		if(!assimilated_rig)
			AssimilateRig(user,W)
	if(istype(W,/obj/item/tank)) //Todo, some kind of check for suits without integrated air supplies.
		if(air_supply)
			to_chat(user, "\The [src] already has a tank installed.")
			return

		if(!user.unEquip(W))
			return

		air_supply = W
		W.forceMove(src)
		to_chat(user, "You slot [W] into [src] and tighten the connecting valve.")
		return

		// Check if this is a hardsuit upgrade or a modification.
	else if(istype(W,/obj/item/rig_module))
		if(!installed_modules)
			installed_modules = list()
		if(installed_modules.len)
			for(var/obj/item/rig_module/installed_mod in installed_modules)
				if(!installed_mod.redundant && istype(installed_mod,W))
					to_chat(user, "The hardsuit already has a module of that class installed.")
					return 1

		var/obj/item/rig_module/mod = W
		to_chat(user, "You begin installing \the [mod] into \the [src].")
		if(!do_after(user,40))
			return
		if(!user || !W)
			return
		if(!user.unEquip(mod))
			return
		to_chat(user, "You install \the [mod] into \the [src].")
		installed_modules |= mod
		mod.forceMove(src)
		mod.installed(src)
		update_icon()
		return 1
	else if(W.has_tool_quality(TOOL_WRENCH))
		if(!air_supply)
			to_chat(user, "There is no tank to remove.")
			return

		if(user.r_hand && user.l_hand)
			air_supply.forceMove(get_turf(user))
		else
			user.put_in_hands(air_supply)
		to_chat(user, "You detach and remove \the [air_supply].")
		air_supply = null
		return
	else if(W.has_tool_quality(TOOL_SCREWDRIVER))
		var/list/possible_removals = list()
		for(var/obj/item/rig_module/module in installed_modules)
			if(module.permanent)
				continue
			possible_removals[module.name] = module

		if(!possible_removals.len)
			to_chat(user, "There are no installed modules to remove.")
			return

		var/removal_choice = tgui_input_list(user, "Which module would you like to remove?", "Removal Choice", possible_removals)
		if(!removal_choice)
			return

		var/obj/item/rig_module/removed = possible_removals[removal_choice]
		to_chat(user, "You detach \the [removed] from \the [src].")
		removed.forceMove(get_turf(src))
		removed.removed()
		installed_modules -= removed
		update_icon()
		return
	for(var/obj/item/rig_module/module in installed_modules)
		if(module.accepts_item(W,user)) //Item is handled in this proc
			return
	if(rig_storage)
		var/obj/item/storage/backpack = rig_storage
		if(backpack.can_be_inserted(W, 1))
			backpack.handle_item_insertion(W)
	else
		if(istype(W,/obj/item/storage/backpack))
			AssimilateBag(user,0,W)

/obj/item/rig/protean/proc/make_alive(var/mob/living/carbon/human/H, var/partial)
	if(H)
		H.setToxLoss(0)
		H.setOxyLoss(0)
		H.setCloneLoss(0)
		H.setBrainLoss(0)
		H.SetParalysis(0)
		H.SetStunned(0)
		H.SetWeakened(0)
		H.blinded = 0
		H.SetBlinded(0)
		H.eye_blurry = 0
		H.ear_deaf = 0
		H.ear_damage = 0
		H.heal_overall_damage(H.getActualBruteLoss(), H.getActualFireLoss(), 1)
		for(var/I in H.organs_by_name)
			if(!H.organs_by_name[I] || istype(H.organs_by_name[I], /obj/item/organ/external/stump))
				if(H.organs_by_name[I])
					var/obj/item/organ/external/oldlimb = H.organs_by_name[I]
					oldlimb.removed()
					qdel(oldlimb)
				var/list/organ_data = H.species.has_limbs[I]
				var/limb_path = organ_data["path"]
				var/obj/item/organ/external/new_eo = new limb_path(H)
				new_eo.robotize(H.synthetic ? H.synthetic.company : null)
				new_eo.sync_colour_to_human(H)
		if(!partial)
			dead_mob_list.Remove(H)
			living_mob_list += H
			H.tod = null
			H.timeofdeath = 0
			H.set_stat(CONSCIOUS)
			if(istype(H.species, /datum/species/protean))
				var/datum/species/protean/S
				S = H.species
				S.pseudodead = 0
				to_chat(myprotean, span_notice("You have finished reconstituting."))
				playsound(src.loc, 'sound/machines/ding.ogg', 50, 1)
		dead = 0

/obj/item/rig/protean/take_hit(damage, source, is_emp=0)
	return	//We don't do that here

/obj/item/rig/protean/emp_act(severity_class)
	return	//Same here

/obj/item/rig/protean/cut_suit()
	return	//nope

/obj/item/rig/protean/force_rest(var/mob/user)
	wearer.lay_down()
	to_chat(user, span_notice("\The [wearer] is now [wearer.resting ? "resting" : "getting up"]."))

/obj/item/cell/protean
	name = "Protean power cell"
	desc = "Something terrible must have happened if you're managing to see this."
	maxcharge = 10000
	charge_amount = 100
	var/mob/living/carbon/human/charger

/obj/item/cell/protean/Initialize(mapload)
	. = ..()
	charge = maxcharge
	update_icon()
	addtimer(CALLBACK(src, PROC_REF(search_for_protean)), 60)

/obj/item/cell/protean/proc/search_for_protean()
	if(istype(src.loc, /obj/item/rig/protean))
		var/obj/item/rig/protean/prig = src.loc
		charger = prig.wearer
	if(charger)
		START_PROCESSING(SSobj, src)

/obj/item/cell/protean/process()
	var/C = charge
	if(charger)
		if((world.time >= last_use + charge_delay) && charger.nutrition > 100)
			give(charge_amount)
			charger.nutrition -= ((1/200)*(charge - C))	//Take nutrition relative to charge. Change the 1/200 if you want to alter the nutrition to charge ratio
	else
		return PROCESS_KILL


/obj/item/rig/protean/equipped(mob/living/carbon/human/M)
	..()
	if(dead)
		canremove = 1
	else
		canremove = 0

/obj/item/rig/protean/ai_can_move_suit(mob/user, check_user_module = 0, check_for_ai = 0)
	if(check_for_ai)
		return 0	//We don't do that here.
	if(offline || !cell || !cell.charge || locked_down)
		if(user)
			to_chat(user, span_warning("Your host rig is unpowered and unresponsive."))
		return 0
	if(!wearer || (wearer.back != src && wearer.belt != src))
		if(user)
			to_chat(user, span_warning("Your host rig is not being worn."))
		return 0
	return 1

/obj/item/rig/protean/toggle_seals(mob/living/carbon/human/M, instant = TRUE)
	M = src.wearer
	..()

/obj/item/rig/protean/toggle_cooling(mob/user)
	user = src.wearer
	..()

/obj/item/rig/protean/toggle_piece(piece, mob/living/carbon/human/H, deploy_mode, forced)
	H = src.wearer
	..()

/obj/item/rig/protean/get_description_interaction()
	if(dead)
		var/list/results = list()
		switch(dead)
			if(1)
				results += "Use a screwdriver to start repairs."
			if(2)
				results += "Insert a Protean Reboot Programmer, printed from a protolathe."
			if(3)
				results += "Use some Nanopaste."
			if(4)
				results += "Use either a defib or jumper cables to start the reboot sequence."
		return results

//Effectively a round about way of letting a Protean wear other rigs.
/obj/item/rig/protean/proc/AssimilateRig(mob/user, var/obj/item/rig/R)
	if(!can_assimilate_rig)
		to_chat(user, span_warning("You can not place a rig into \the [src]"))
		return
	if(!R || assimilated_rig)
		return
	if(istype(R, /obj/item/rig/protean))
		to_chat(user, span_warning("The world is not ready for such a technological singularity."))
		return
	to_chat(user, span_notice("You assimilate the [R] into the [src]. Mimicking its stats and appearance."))
	for(var/obj/item/piece in list(gloves,helmet,boots,chest))
		piece.armor = R.armor.Copy()
		piece.max_pressure_protection = R.max_pressure_protection
		piece.max_heat_protection_temperature = R.max_heat_protection_temperature
	//I dislike this piece of code, but not every rig has the full set of parts
	if(R.gloves)
		gloves.sprite_sheets = R.gloves.sprite_sheets.Copy()
		gloves.sprite_sheets_obj = R.gloves.sprite_sheets.Copy()
		gloves.icon = R.gloves.icon
		gloves.icon_state = R.gloves.icon_state
		gloves.default_worn_icon = R.gloves.default_worn_icon
	if(R.helmet)
		helmet.sprite_sheets = R.helmet.sprite_sheets.Copy()
		helmet.sprite_sheets_obj = R.helmet.sprite_sheets.Copy()
		helmet.icon = R.helmet.icon
		helmet.icon_state = R.helmet.icon_state
		helmet.default_worn_icon = R.helmet.default_worn_icon
	if(R.boots)
		boots.sprite_sheets = R.boots.sprite_sheets.Copy()
		boots.sprite_sheets_obj = R.boots.sprite_sheets.Copy()
		boots.icon = R.boots.icon
		boots.icon_state = R.boots.icon_state
		boots.default_worn_icon = R.boots.default_worn_icon
	if(R.chest)
		chest.sprite_sheets = R.chest.sprite_sheets.Copy()
		chest.sprite_sheets_obj = R.chest.sprite_sheets.Copy()
		chest.icon = R.chest.icon
		chest.icon_state = R.chest.icon_state
		chest.default_worn_icon = R.chest.default_worn_icon

	suit_state = R.suit_state
	name = R.name
	icon = R.icon
	icon_state = R.icon_state
	user.drop_item(R)
	contents += R
	assimilated_rig = R
	slowdown = (initial(R.slowdown) *0.5)
	offline_slowdown = slowdown

/obj/item/rig/protean/verb/RemoveRig()
	set name = "Remove Assimilated Rig"
	set category = "Object"

	if(assimilated_rig)
		for(var/obj/item/piece in list(gloves,helmet,boots,chest))
			piece.armor = armor.Copy()
			piece.max_pressure_protection = initial(piece.max_pressure_protection)
			piece.max_heat_protection_temperature = initial(piece.max_heat_protection_temperature)
			piece.icon_state = src.icon_state
			piece.icon = initial(piece.icon)
			piece.default_worn_icon = initial(piece.default_worn_icon)

		//Byond at this time does not support initial() on lists
		//So we have to create a new rig, just so we can copy the lists we're after
		//If someone figures out a smarter way to do this, please tell me
		var/obj/item/rig/tempRig = new /obj/item/rig/protean()
		gloves.sprite_sheets = tempRig.gloves.sprite_sheets.Copy()
		gloves.sprite_sheets_obj = tempRig.gloves.sprite_sheets.Copy()
		helmet.sprite_sheets = tempRig.helmet.sprite_sheets.Copy()
		helmet.sprite_sheets_obj = tempRig.helmet.sprite_sheets.Copy()
		boots.sprite_sheets = tempRig.boots.sprite_sheets.Copy()
		boots.sprite_sheets_obj = tempRig.boots.sprite_sheets.Copy()
		chest.sprite_sheets = tempRig.chest.sprite_sheets.Copy()
		chest.sprite_sheets_obj = tempRig.chest.sprite_sheets.Copy()
		slowdown = initial(slowdown)
		name = tempRig.name
		icon = tempRig.icon // Reset the icon back to its original
		icon_state = tempRig.icon_state
		suit_state = icon_state
		offline_slowdown = initial(offline_slowdown)
		usr.put_in_hands(assimilated_rig)
		assimilated_rig = null
		qdel(tempRig)
	else
		to_chat(usr, "[src] has not assimilated a RIG. Use one on it to assimilate.")

/obj/item/rig/protean/MouseDrop(obj/over_object as obj)
	if(!canremove)
		return

	if (isliving(usr) || isobserver(usr))

		if (istype(usr.loc,/obj/mecha)) // stops inventory actions in a mech. why?
			return

		if (!( istype(over_object, /obj/screen) ))
			return ..()

		if (!(src.loc == usr) || (src.loc && src.loc.loc == usr))
			return

		if (( usr.restrained() ) || ( usr.stat ))
			return

		if ((src.loc == usr) && !(istype(over_object, /obj/screen)) && !usr.unEquip(src))
			return

		switch(over_object.name)
			if("r_hand")
				usr.unEquip(src)
				usr.put_in_r_hand(src)
			if("l_hand")
				usr.unEquip(src)
				usr.put_in_l_hand(src)
		src.add_fingerprint(usr)
