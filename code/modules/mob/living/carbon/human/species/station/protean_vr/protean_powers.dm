//TODO: Replace ventcrawl with morphing. /mob/living/simple_mob/vore/hostile/morph
#define PER_LIMB_STEEL_COST SHEET_MATERIAL_AMOUNT
////
//  One-part Refactor
////
/mob/living/carbon/human/proc/nano_partswap()
	set name = "Ref - Single Limb"
	set desc = "Allows you to replace and reshape your limbs as you see fit."
	//set category = "Abilities.Protean"
	set hidden = 1

	var/mob/living/protie = src
	if(temporary_form)
		protie = temporary_form
	if(nano_dead_check(protie))
		to_chat(protie, span_warning("You need to be repaired first before you can act!"))
		return
	if(stat)
		to_chat(protie,span_warning("You must be awake and standing to perform this action!"))
		return

	if(!isturf(protie.loc))
		to_chat(protie,span_warning("You need more space to perform this action!"))
		return

	var/obj/item/organ/internal/nano/refactory/refactory = nano_get_refactory()
	//Missing the organ that does this
	if(!istype(refactory))
		to_chat(protie,span_warning("You don't have a working refactory module!"))
		return

	var/choice = tgui_input_list(protie,"Pick the bodypart to change:", "Refactor - One Bodypart", species.has_limbs)
	if(!choice)
		return

	//Organ is missing, needs restoring
	if(!organs_by_name[choice] || istype(organs_by_name[choice], /obj/item/organ/external/stump)) //allows limb stumps to regenerate like removed limbs.
		if(refactory.get_stored_material(MAT_STEEL) < PER_LIMB_STEEL_COST)
			to_chat(protie,span_warning("You're missing that limb, and need to store at least [PER_LIMB_STEEL_COST] steel to regenerate it."))
			return
		var/regen = tgui_alert(protie,"That limb is missing, do you want to regenerate it in exchange for [PER_LIMB_STEEL_COST] steel?","Regenerate limb?",list("Yes","No"))
		if(regen != "Yes")
			return
		if(!refactory.use_stored_material(MAT_STEEL,PER_LIMB_STEEL_COST))
			return
		if(organs_by_name[choice])
			var/obj/item/organ/external/oldlimb = organs_by_name[choice]
			oldlimb.removed()
			qdel(oldlimb)
		var/mob/living/simple_mob/protean_blob/blob
		if(!temporary_form)
			blob = nano_intoblob()
		else
			blob = temporary_form
		active_regen = 1
		if(do_after(blob,50,exclusive = TASK_ALL_EXCLUSIVE))
			var/list/limblist = species.has_limbs[choice]
			var/limbpath = limblist["path"]
			var/obj/item/organ/external/new_eo = new limbpath(src)
			organs_by_name[choice] = new_eo
			new_eo.robotize(synthetic ? synthetic.company : null) //Use the base we started with
			new_eo.sync_colour_to_human(src)
			regenerate_icons()
		active_regen = 0
		return

	//Organ exists, let's reshape it
	var/list/usable_manufacturers = list()
	for(var/company in chargen_robolimbs)
		var/datum/robolimb/M = chargen_robolimbs[company]
		if(!(choice in M.parts))
			continue
		if(species?.base_species in M.species_cannot_use)
			continue
		if(M.whitelisted_to && !(ckey in M.whitelisted_to))
			continue
		usable_manufacturers[company] = M
	if(!usable_manufacturers.len)
		return
	var/manu_choice = tgui_input_list(protie, "Which manufacturer do you wish to mimic for this limb?", "Manufacturer for [choice]", usable_manufacturers)

	if(!manu_choice)
		return //Changed mind

	var/obj/item/organ/external/eo = organs_by_name[choice]
	if(!eo)
		return //Lost it meanwhile

	eo.robotize(manu_choice)
	update_icons_body()

/mob/living/carbon/human/proc/nano_regenerate()
	set name = "Total Reassembly"
	set desc = "Fully repair yourself or reload your appearance from whatever character slot you have loaded."
	//set category = "Abilities.Protean"
	set hidden = 1
	var/mob/living/protie = src
	if(temporary_form)
		protie = temporary_form
	var/input = tgui_alert(protie,{"Do you want to rebuild or reassemble yourself?
	Rebuilding will cost 10,000 steel and will rebuild all of your limbs as well as repair all damage over a 40s period.
	Reassembling costs no steel and will copy the appearance data of your currently loaded save slot."},"Reassembly",list("Rebuild","Reassemble","Cancel"))
	if(input == "Cancel" || !input)
		return
	if(input == "Rebuild")
		var/obj/item/organ/internal/nano/refactory/refactory = nano_get_refactory()
		if(refactory.get_stored_material(MAT_STEEL) >= 10000)
			to_chat(protie, span_notify("You begin to rebuild. You will need to remain still."))
			if(do_after(protie, 400,exclusive = TASK_ALL_EXCLUSIVE))
				if(species?:OurRig)	//Unsafe, but we should only ever be using this with a Protean
					species?:OurRig?:make_alive(src,1)	//Re-using this proc
					refactory.use_stored_material(MAT_STEEL,refactory.get_stored_material(MAT_STEEL))	//Use all of our steel
				else
					to_chat(protie, span_userdanger("Somehow, you are missing your protean rig. You are unable to rebuild without one."))
		else
			to_chat(protie, span_warning("You do not have enough steel stored for this operation."))
	else
		input = tgui_alert(protie,{"Include Flavourtext?"},"Reassembly",list("Yes","No","Cancel"))
		if(input == "Cancel" || !input)
			return
		var/flavour = 0
		if(input == "Yes")
			flavour = 1
		input = tgui_alert(protie,{"Include OOC notes?"},"Reassembly",list("Yes","No","Cancel"))
		if(input == "Cancel" || !input)
			return
		var/oocnotes = 0
		if(input == "Yes")
			oocnotes = 1
		to_chat(protie, span_notify("You begin to reassemble. You will need to remain still."))
		protie.visible_message(span_notify("[protie] rapidly contorts and shifts!"), span_danger("You begin to reassemble."))
		if(do_after(protie, 40,exclusive = TASK_ALL_EXCLUSIVE))
			if(protie.client.prefs)	//Make sure we didn't d/c
				var/obj/item/rig/protean/Rig = species?:OurRig
				protie.client.prefs.vanity_copy_to(src, FALSE, flavour, oocnotes, TRUE)
				species?:OurRig = Rig	//Get a reference to our Rig and put it back after reassembling
				protie.visible_message(span_notify("[protie] adopts a new form!"), span_danger("You have reassembled."))


/mob/living/carbon/human/proc/nano_copy_body()
	set name = "Copy Form"
	set desc = "If you are aggressively grabbing someone, with their consent, you can turn into a copy of them. (Without their name)."
	//set category = "Abilities.Protean"
	set hidden = 1
	var/mob/living/protie = src
	if(temporary_form)
		protie = temporary_form

	var/grabbing_but_not_enough
	var/mob/living/carbon/human/victim = null
	for(var/obj/item/grab/G in protie)
		if(G.state < GRAB_AGGRESSIVE)
			grabbing_but_not_enough = TRUE
			return
		else
			victim = G.affecting
	if (!victim)
		if (grabbing_but_not_enough)
			to_chat(protie, span_warning("You need a better grip to do that!"))
		else
			to_chat(protie, span_notice("You need to be aggressively grabbing someone before you can copy their form."))
		return
	if (!istype(victim))
		to_chat(protie, span_warning("You can only perform this on human mobs!"))
		return
	if (!victim.client)
		to_chat(protie, span_notice("The person you try this on must have a client!"))
		return


	to_chat(protie, span_notice("Waiting for other person's consent."))
	var/consent = tgui_alert(victim, "Allow [src] to copy what you look like?", "Consent", list("Yes", "No"))
	if (consent != "Yes")
		to_chat(protie, span_notice("They declined your request."))
		return

	var/input = tgui_alert(protie,{"Copy [victim]'s flavourtext?"},"Copy Form",list("Yes","No","Cancel"))
	if(input == "Cancel" || !input)
		return
	var/flavour = 0
	if(input == "Yes")
		flavour = 1

	var/checking = FALSE
	for(var/obj/item/grab/G in protie)
		if(G.affecting == victim && G.state >= GRAB_AGGRESSIVE)
			checking = TRUE
	if (!checking)
		to_chat(protie, span_warning("You lost your grip on [victim]!"))
		return

	to_chat(protie, span_notify("You begin to reassemble into [victim]. You will need to remain still."))
	protie.visible_message(span_notify("[protie] rapidly contorts and shifts!"), span_danger("You begin to reassemble into [victim]."))
	if(do_after(protie, 40,exclusive = TASK_ALL_EXCLUSIVE))
		checking = FALSE
		for(var/obj/item/grab/G in protie)
			if(G.affecting == victim && G.state >= GRAB_AGGRESSIVE)
				checking = TRUE
		if (!checking)
			to_chat(protie, span_warning("You lost your grip on [victim]!"))
			return
		if(protie.client)	//Make sure we didn't d/c
			var/obj/item/rig/protean/Rig = species?:OurRig
			transform_into_other_human(victim, FALSE, flavour, TRUE)
			species?:OurRig = Rig	//Get a reference to our Rig and put it back after reassembling
			protie.visible_message(span_notify("[protie] adopts the form of [victim]!"), span_danger("You have reassembled into [victim]."))

////
//  Storing metal
////
/mob/living/carbon/human/proc/nano_metalnom()
	set name = "Ref - Store Metals"
	set desc = "If you're holding a stack of material, you can consume some and store it for later."
	//set category = "Abilities.Protean"
	set hidden = 1

	var/mob/living/protie = src
	if(temporary_form)
		protie = temporary_form
	if(nano_dead_check(protie))
		to_chat(protie, span_warning("You need to be repaired first before you can act!"))
		return

	var/obj/item/organ/internal/nano/refactory/refactory = nano_get_refactory()
	//Missing the organ that does this
	if(!istype(refactory))
		to_chat(protie,span_warning("You don't have a working refactory module!"))
		return

	var/held = protie.get_active_hand()
	if(!istype(held,/obj/item/stack/material))
		to_chat(protie,span_warning("You aren't holding a stack of materials in your active hand!"))
		return

	var/obj/item/stack/material/matstack = held
	var/substance = matstack.material.name
	var allowed = 0
	for(var/material in PROTEAN_EDIBLE_MATERIALS)
		if(material == substance) allowed = 1
	if(!allowed)
		to_chat(protie,span_warning("You can't process [substance]!"))
		return

	var/howmuch = tgui_input_number(protie,"How much do you want to store? (0-[matstack.get_amount()])","Select amount",null,matstack.get_amount())
	if(!howmuch || matstack != protie.get_active_hand() || howmuch > matstack.get_amount())
		return //Quietly fail

	var/actually_added = refactory.add_stored_material(substance,howmuch*matstack.perunit)
	matstack.use(CEILING((actually_added/matstack.perunit), 1))
	if(actually_added && actually_added < howmuch)
		to_chat(protie,span_warning("Your refactory module is now full, so only [actually_added] units were stored."))
		visible_message(span_notice("[protie] nibbles some of the [substance] right off the stack!"))
	else if(actually_added)
		to_chat(protie,span_notice("You store [actually_added] units of [substance]."))
		visible_message(span_notice("[protie] devours some of the [substance] right off the stack!"))
	else
		to_chat(protie,span_notice("You're completely capped out on [substance]!"))

////
//  Blob Form
////
/mob/living/carbon/human/proc/nano_blobform(var/forced)
	set name = "Toggle Blobform"
	set desc = "Switch between amorphous and humanoid forms."
	//set category = "Abilities.Protean"
	set hidden = 1

	if(nano_dead_check(src))
		return
	if(forced)
		if(temporary_form)
			nano_outofblob(temporary_form, forced)
		else
			nano_intoblob(forced)
		return
	var/atom/movable/to_locate = temporary_form || src
	if(!isturf(to_locate.loc) && !forced)
		to_chat(to_locate,span_warning("You need more space to perform this action!"))
		return
	//Blob form
	if(temporary_form)
		if(temporary_form.stat)
			to_chat(temporary_form,span_warning("You can only do this while not stunned."))
		else
			nano_outofblob(temporary_form)

	//Human form
	else if(stat)
		to_chat(src,span_warning("You can only do this while not stunned."))
		return
	else if(handcuffed)
		to_chat(src, span_warning("You can't do this while handcuffed!"))
		return
	else
		nano_intoblob()

////
//  Change fitting
////
/mob/living/carbon/human/proc/nano_change_fitting()
	set name = "Change Species Fit"
	set desc = "Tweak your shape to change what suits you fit into (and their sprites!)."
	set category = "Abilities.Protean"

	if(stat)
		to_chat(src,span_warning("You must be awake and standing to perform this action!"))
		return

	var/new_species = tgui_input_list(src, "Please select a species to emulate.", "Shapeshifter Body", list(species?.vanity_base_fit)|species?.get_valid_shapeshifter_forms())
	if(new_species)
		species?.base_species = new_species // Really though you better have a species
		regenerate_icons() //Expensive, but we need to recrunch all the icons we're wearing

////
//	Rig Transform
////
/mob/living/carbon/human/proc/nano_rig_transform(var/forced, var/devour = FALSE)
	set name = "Modify Form - Hardsuit"
	set desc = "Allows a protean to retract its mass into its hardsuit module at will."
	//set category = "Abilities.Protean"
	set hidden = 1

	var/mob/living/protie = src
	if(temporary_form)
		protie = temporary_form
	if(nano_dead_check(src))
		to_chat(protie, span_warning("You need to be repaired first before you can act!"))
		return
	to_chat(protie, span_notice("You rapidly condense into your module."))
	if(forced || do_after(protie,20,exclusive = TASK_ALL_EXCLUSIVE))
		if(!temporary_form)	//If you're human, force you into blob form before rig'ing
			nano_blobform(forced)
		spawn(2)

		if(istype(src.species, /datum/species/protean))
			var/datum/species/protean/S = src.species
			var/mob/living/simple_mob/protean_blob/P = temporary_form
			if(S.OurRig) //Do we even have a RIG?
				if(P.loc == S.OurRig)	//we're inside our own RIG
					var/mob/wearer = S.OurRig.wearer
					if(ismob(S.OurRig.loc))
						var/mob/m = S.OurRig.loc
						m.drop_from_inventory(S.OurRig)
					if(wearer && devour) //We're being worn. Engulf em', if prefs align.. otherwise just drop off.
						if(P.can_be_drop_pred && wearer.devourable && wearer.can_be_drop_prey && P.vore_selected)
							perform_the_nom(P,wearer,P,P.vore_selected,1)
						else
							to_chat(P, span_vwarning("You can't assimilate your current host."))
					P.forceMove(get_turf(S.OurRig))
					S.OurRig.forceMove(src)
					S.OurRig.myprotean = src
					src.equip_to_slot_if_possible(S.OurRig, slot_back)
					S.OurRig.Moved()
					P.has_hands = 1
				else	//We're not in our own RIG
					if(P.stat || P.resting && !forced)
						to_chat(P,span_warning("You can only do this while not stunned."))
					else
						if(P.l_hand)
							P.drop_l_hand()
						if(P.r_hand)
							P.drop_r_hand()
						P.has_hands = 0
						S.OurRig.myprotean = P
						src.drop_from_inventory(S.OurRig)
						P.forceMove(S.OurRig)
						S.OurRig.canremove = 1
				P.reset_view()
			else	//Make one if not
				to_chat(temporary_form, span_warning("Somehow, your RIG got disconnected from your species. This may have been caused by an admin heal. A new one has been created for you, contact a coder."))
				new /obj/item/rig/protean(src,src)
	else
		to_chat(protie, span_warning("You must remain still to condense!"))

/mob/living/carbon/human/proc/appearance_switch()
	set name = "Switch Blob Appearance"
	set desc = "Allows a protean blob to switch its outwards appearance."
	//set category = "Abilities.Protean"
	set hidden = 1
	var/datum/species/protean/S = src.species
	var/mob/living/protie = src
	if(temporary_form)
		protie = temporary_form
	var/list/icon_choices = list(
			"Primary" = image(icon = 'icons/mob/species/protean/protean.dmi', icon_state = "primary"),
			"Highlight" = image(icon = 'icons/mob/species/protean/protean.dmi', icon_state = "highlight"),
			"puddle1" = image(icon = 'icons/mob/species/protean/protean_powers.dmi', icon_state = "blob"),
			"puddle0" = image(icon = 'icons/mob/species/protean/protean.dmi', icon_state = "puddle"),
			"shadow" = image(icon = 'icons/mob/species/protean/protean.dmi', icon_state = "shadow"),
			"clean" = image(icon = 'icons/mob/species/protean/protean.dmi', icon_state = "clean"),
			"swarm" = image(icon = 'icons/mob/species/protean/protean.dmi', icon_state = "swarm"),
			"slime" = image(icon = 'icons/mob/species/protean/protean.dmi', icon_state = "slime"),
			"chaos" = image(icon = 'icons/mob/species/protean/protean.dmi', icon_state = "chaos"),
			"cloud" = image(icon = 'icons/mob/species/protean/protean.dmi', icon_state = "cloud"),
			/*"catslug" = image(icon = 'icons/mob/species/protean/protean.dmi', icon_state = "catslug"),
			"cat" = image(icon = 'icons/mob/species/protean/protean.dmi', icon_state = "cat"),
			"mouse" = image(icon = 'icons/mob/species/protean/protean.dmi', icon_state = "mouse"),
			"rabbit" = image(icon = 'icons/mob/species/protean/protean.dmi', icon_state = "rabbit"),
			"bear" = image(icon = 'icons/mob/species/protean/protean.dmi', icon_state = "bear"),
			"fen" = image(icon = 'icons/mob/species/protean/protean.dmi', icon_state = "fen"),
			"fox" = image(icon = 'icons/mob/species/protean/protean.dmi', icon_state = "fox"),
			"raptor" = image(icon = 'icons/mob/species/protean/protean.dmi', icon_state = "raptor"),
			"rat" = image(icon = 'icons/mob/species/protean/protean64x32.dmi', icon_state = "rat", pixel_x = -16),
			"lizard" = image(icon = 'icons/mob/species/protean/protean64x32.dmi', icon_state = "lizard", pixel_x = -16),
			"wolf" = image(icon = 'icons/mob/species/protean/protean64x32.dmi', icon_state = "wolf", pixel_x = -16),
			//"drake" = image(icon = 'modular_chomp/icons/mob/species/protean/protean64x64.dmi', icon_state = "drake", pixel_x = -16),
			"teppi" = image(icon = 'icons/mob/species/protean/protean64x64.dmi', icon_state = "teppi", pixel_x = -16),
			"panther" = image(icon = 'icons/mob/species/protean/protean64x64.dmi', icon_state = "panther", pixel_x = -16),
			"robodrgn" = image(icon = 'icons/mob/species/protean/protean128x64.dmi', icon_state = "robodrgn", pixel_x = -48),
			"Dragon" = image(icon = 'icons/mob/bigdragon_small.dmi', icon_state = "dragon_small")*/
			)
	var/blobstyle = show_radial_menu(protie, protie, icon_choices, require_near = TRUE, tooltips = FALSE)
	if(!blobstyle || QDELETED(protie) || protie.incapacitated())
		return FALSE
	switch(blobstyle)
		if("Dragon")	//Fuck it, we ball
			var/list/options = list("Underbelly","Body","Ears","Mane","Horns","Eyes")
			for(var/option in options)
				LAZYSET(options, option, image('icons/effects/bigdragon_labels.dmi', option))
			var/choice = show_radial_menu(protie, protie, options, radius = 60)
			if(!choice || QDELETED(protie) || protie.incapacitated())
				return FALSE
			. = TRUE
			var/list/underbelly_styles = list(
				"dragon_underSmooth",
				"dragon_underPlated"
			)
			var/list/body_styles = list(
				"dragon_bodySmooth",
				"dragon_bodyScaled"
			)
			var/list/ear_styles = list(
				"dragon_earsNormal"
			)
			var/list/mane_styles = list(
				"dragon_maneNone",
				"dragon_maneShaggy",
				"dragon_maneDorsalfin"
			)
			var/list/horn_styles = list(
				"dragon_hornsPointy",
				"dragon_hornsCurved",
				"dragon_hornsCurved2",
				"dragon_hornsJagged",
				"dragon_hornsCrown",
				"dragon_hornsSkull"
			)
			var/list/eye_styles = list(
				"dragon_eyesNormal"
			)
			switch(choice)
				if("Underbelly")
					options = underbelly_styles
					for(var/option in options)
						var/image/I = image('icons/mob/vore128x64.dmi', option, dir = 4, pixel_x = -48)
						LAZYSET(options, option, I)
					choice = show_radial_menu(protie, protie, options, radius = 90)
					if(!choice || QDELETED(protie) || protie.incapacitated())
						return 0
					var/new_color = input("Pick underbelly color:","Underbelly Color", S.dragon_overlays[1]) as null|color
					if(!new_color)
						return 0
					S.dragon_overlays[1] = choice
					S.dragon_overlays[S.dragon_overlays[1]] = new_color
				if("Body")
					options = body_styles
					for(var/option in options)
						var/image/I = image('icons/mob/vore128x64.dmi', option, dir = 4, pixel_x = -48)
						LAZYSET(options, option, I)
					choice = show_radial_menu(protie, protie, options, radius = 90)
					if(!choice || QDELETED(protie) || protie.incapacitated())
						return 0
					var/new_color = input("Pick body color:","Body Color", S.dragon_overlays[2]) as null|color
					if(!new_color)
						return 0
					S.dragon_overlays[2] = choice
					S.dragon_overlays[S.dragon_overlays[2]] = new_color
				if("Ears")
					options = ear_styles
					for(var/option in options)
						var/image/I = image('icons/mob/vore128x64.dmi', option, dir = 4, pixel_x = -76, pixel_y = -50)
						LAZYSET(options, option, I)
					choice = show_radial_menu(protie, protie, options, radius = 90)
					if(!choice || QDELETED(protie) || protie.incapacitated())
						return 0
					var/new_color = input("Pick ear color:","Ear Color", S.dragon_overlays[3]) as null|color
					if(!new_color)
						return 0
					S.dragon_overlays[3] = choice
					S.dragon_overlays[S.dragon_overlays[3]] = new_color
				if("Mane")
					options = mane_styles
					for(var/option in options)
						var/image/I = image('icons/mob/vore128x64.dmi', option, dir = 4, pixel_x = -76, pixel_y = -50)
						LAZYSET(options, option, I)
					choice = show_radial_menu(protie, protie, options, radius = 90)
					if(!choice || QDELETED(protie) || protie.incapacitated())
						return 0
					var/new_color = input("Pick mane color:","Mane Color", S.dragon_overlays[4]) as null|color
					if(!new_color)
						return 0
					S.dragon_overlays[4] = choice
					S.dragon_overlays[S.dragon_overlays[4]] = new_color
				if("Horns")
					options = horn_styles
					for(var/option in options)
						var/image/I = image('icons/mob/vore128x64.dmi', option, dir = 4, pixel_x = -86, pixel_y = -50)
						LAZYSET(options, option, I)
					choice = show_radial_menu(protie, protie, options, radius = 90)
					if(!choice || QDELETED(protie) || protie.incapacitated())
						return 0
					var/new_color = input("Pick horn color:","Horn Color", S.dragon_overlays[5]) as null|color
					if(!new_color)
						return 0
					S.dragon_overlays[5] = choice
					S.dragon_overlays[S.dragon_overlays[5]] = new_color
				if("Eyes")
					options = eye_styles
					for(var/option in options)
						var/image/I = image('icons/mob/vore128x64.dmi', option, dir = 2, pixel_x = -48, pixel_y = -50)
						LAZYSET(options, option, I)
					choice = show_radial_menu(protie, protie, options, radius = 90)
					if(!choice || QDELETED(protie) || protie.incapacitated())
						return 0
					var/new_color = input("Pick eye color:","Eye Color", S.dragon_overlays[6]) as null|color
					if(!new_color)
						return 0
					S.dragon_overlays[6] = choice
					S.dragon_overlays[S.dragon_overlays[6]] = new_color
			S.blob_appearance = "dragon"
		if("Primary")
			var/new_color = input("Pick primary color:","Protean Primary", "#FF0000") as null|color
			if(!new_color)
				return
			S.blob_color_1 = new_color
		if("Highlight")
			var/new_color = input("Pick highlight color:","Protean Highlight", "#FF0000") as null|color
			if(!new_color)
				return
			S.blob_color_2 = new_color
		else
			S.blob_appearance = blobstyle
	if(temporary_form)
		if(blobstyle)
			temporary_form.update_icon()
			if(istype(temporary_form.loc, /obj/item/holder/protoblob))
				var/obj/item/holder/protoblob/PB = temporary_form.loc
				PB.item_state = S.blob_appearance

/mob/living/carbon/human/proc/nano_latch()
	set name = "Latch/Unlatch host"
	set desc = "Allows a protean to forcibly latch or unlatch from a host."
	//set category = "Abilities.Protean"
	set hidden = 1
	var/mob/living/protie = src
	var/mob/living/carbon/human/target
	var/datum/species/protean/S = src.species
	if(nano_dead_check(src))
		return
	if(temporary_form)
		protie = temporary_form
		if(protie.loc == S.OurRig)
			target = S.OurRig.wearer
			if(target)
				target.drop_from_inventory(S.OurRig)
				to_chat(protie, span_notice("You detach from your host."))
			else
				to_chat(protie, span_warning("You aren't being worn, dummy."))
			return
	var/obj/held_item = protie.get_active_hand()
	if(istype(held_item,/obj/item/grab))
		var/obj/item/grab/G = held_item
		if(istype(G.affecting, /mob/living/carbon/human))
			target = G.affecting
			if(istype(target.species, /datum/species/protean))
				to_chat(protie, span_danger("You can't latch onto a fellow Protean!"))
				return
			if(G.loc == protie && G.state >= GRAB_AGGRESSIVE)
				protie.visible_message(span_warning("[protie] is attempting to latch onto [target]!"), span_danger("You attempt to latch onto [target]!"))
				if(do_after(protie, 50, target,exclusive = TASK_ALL_EXCLUSIVE))
					if(G.loc == protie && G.state >= GRAB_AGGRESSIVE)
						target.drop_from_inventory(target.back)
						protie.visible_message(span_danger("[protie] latched onto [target]!"), span_danger("You latch yourself onto [target]!"))
						target.Weaken(3)
						nano_rig_transform(1)
						spawn(5)	//Have to give time for the above proc to resolve
						//S.OurRig.forceMove(target)
						target.equip_to_slot(S.OurRig, slot_back)
						S.OurRig.Moved()
						spawn(1)	//Same here :(
						S.OurRig.wearer = target
			else
				to_chat(protie, span_warning("You need a more aggressive grab to do this!"))
		else
			to_chat(protie, span_warning("You can only latch onto humanoid mobs!"))
	else
		to_chat(protie, span_warning("You need to be grabbing a humanoid mob aggressively to latch onto them."))

/mob/living/carbon/human/proc/nano_assimilate()
	set name = "Assimilate Host"
	set desc = "Allows a protean to assimilate a latched host, allowing them to devour them right away."
	set hidden = 1

	var/mob/living/protie = src
	var/mob/living/carbon/human/target
	var/datum/species/protean/S = src.species
	if(nano_dead_check(src))
		return
	if(temporary_form)
		protie = temporary_form
		if(protie.loc == S.OurRig)
			target = S.OurRig.wearer
			if(!target)
				to_chat(protie, span_vwarning("You need a host to assimilate."))
				return
			nano_rig_transform(TRUE, TRUE)

/// /// /// A helper to reuse
/mob/living/proc/nano_get_refactory(obj/item/organ/internal/nano/refactory/R)
	if(istype(R))
		if(!(R.status & ORGAN_DEAD))
			return R
	return

/mob/living/simple_mob/protean_blob/nano_get_refactory()
	if(refactory)
		return ..(refactory)
	if(humanform)
		return humanform.nano_get_refactory()

/mob/living/carbon/human/nano_get_refactory()
	return ..(locate(/obj/item/organ/internal/nano/refactory) in internal_organs)

//I hate this whole bit but I want proteans to be able to "die" and still be "alive" in their blob as a suit
/mob/living/carbon/human/proc/nano_dead_check(var/mob/living/protie)
	if(istype(src.species, /datum/species/protean))
		var/datum/species/protean/S = src.species
		if(S.pseudodead)
			return 1
	return 0

/mob/living/carbon/human/proc/nano_set_dead(var/num)
	if(istype(src.species, /datum/species/protean))
		var/datum/species/protean/S = src.species
		S.pseudodead = num

/// /// /// Ability objects for stat panel
/obj/effect/protean_ability
	name = "Activate"
	desc = ""
	icon = 'icons/mob/species/protean/protean_powers.dmi'
	var/ability_name
	var/to_call

/obj/effect/protean_ability/proc/atom_button_text()
	return src

/obj/effect/protean_ability/Click(var/location, var/control, var/params)
	var/list/clickprops = params2list(params)
	var/opts = clickprops["shift"]

	if(opts)
		to_chat(usr,span_notice(span_bold("[ability_name]") + " - [desc]"))
	else
		//Humanform using it
		if(ishuman(usr))
			do_ability(usr)
		//Blobform using it
		else
			var/mob/living/simple_mob/protean_blob/blob = usr
			do_ability(blob.humanform)

/obj/effect/protean_ability/proc/do_ability(var/mob/living/L)
	if(istype(L))
		call(L,to_call)()
	return 0

/// The actual abilities
/obj/effect/protean_ability/into_blob
	ability_name = "Toggle Blobform"
	desc = "Discard your shape entirely, changing to a low-energy blob. You'll consume steel to repair yourself in this form."
	icon_state = "blob"
	to_call = /mob/living/carbon/human/proc/nano_blobform

/obj/effect/protean_ability/change_volume
	ability_name = "Change Volume"
	desc = "Alter your size between 25% and 200%."
	icon_state = "volume"
	to_call = /mob/living/proc/set_size

/obj/effect/protean_ability/reform_limb
	ability_name = "Ref - Single Limb"
	desc = "Rebuild or replace a single limb, assuming you have 2000 steel."
	icon_state = "limb"
	to_call = /mob/living/carbon/human/proc/nano_partswap

/obj/effect/protean_ability/reform_body
	ability_name = "Total Reassembly"
	desc = "Fully repair yourself or reload your appearance from whatever character slot you have loaded."
	icon_state = "body"
	to_call = /mob/living/carbon/human/proc/nano_regenerate

/obj/effect/protean_ability/metal_nom
	ability_name = "Ref - Store Metals"
	desc = "Store the metal you're holding. Your refactory can only store steel."
	icon_state = "metal"
	to_call = /mob/living/carbon/human/proc/nano_metalnom

/obj/effect/protean_ability/hardsuit
	ability_name = "Hardsuit Transform"
	desc = "Coalesce your nanite swarm into their control module, allowing others to wear you."
	icon_state = "rig"
	to_call = /mob/living/carbon/human/proc/nano_rig_transform

/obj/effect/protean_ability/appearance_switch
	ability_name = "Blob Appearance"
	desc = "Toggle your blob appearance. Also affects your worn appearance."
	icon_state = "switch"
	to_call = /mob/living/carbon/human/proc/appearance_switch

/obj/effect/protean_ability/latch_host
	ability_name = "Latch Host"
	desc = "Forcibly latch or unlatch your RIG from a host mob."
	icon_state = "latch"
	to_call = /mob/living/carbon/human/proc/nano_latch

/obj/effect/protean_ability/assimilate_host
	ability_name = "Assimilate Host"
	desc = "Allows a protean to assimilate a latched host, allowing them to devour them right away."
	icon_state = "assimilate"
	to_call = /mob/living/carbon/human/proc/nano_assimilate

/obj/effect/protean_ability/copy_form
	ability_name = "Copy Form"
	desc = "If you are aggressively grabbing someone, with their consent, you can turn into a copy of them. (Without their name)."
	icon_state = "copy_form"
	to_call = /mob/living/carbon/human/proc/nano_copy_body

#undef PER_LIMB_STEEL_COST

/mob/living/carbon/human/proc/chest_transparency_toggle()
	set name = "transparency toggle (chest only)"
	set category = "Abilities.Protean"
	if(stat || world.time < last_special)
		return
	last_special = world.time + 50
	for(var/obj/item/organ/external/proteanlimbs as anything in src.organs)
		if(proteanlimbs.organ_tag == BP_HEAD)
			continue
		proteanlimbs.transparent = !proteanlimbs.transparent
	visible_message(span_notice("\The [src]'s internal composition seems to change."))
	update_icons_body()
	update_hair()

/obj/effect/protean_ability/chest_transparency
	ability_name = "body transparency toggle (All but head)"
	desc = "Makes everything but your head transparent!"
	icon = 'icons/obj/slimeborg/slimecore.dmi'
	icon_state = "core"
	to_call = /mob/living/carbon/human/proc/chest_transparency_toggle

/mob/living/carbon/human/proc/transparency_toggle()
	set name = "Toggle Transparency"
	set category = "Abilities.Protean"
	if(stat || world.time < last_special)
		return
	last_special = world.time + 50
	for(var/obj/item/organ/external/proteanlimbs as anything in src.organs)
		proteanlimbs.transparent = !proteanlimbs.transparent

	visible_message(span_notice("\The [src]'s internal composition seems to change."))
	update_icons_body()
	update_hair()

/obj/effect/protean_ability/transparency_for_entire_body
	ability_name = "Toggle Transparency"
	desc = "transparency toggle for your entire body"
	icon = 'icons/obj/slimeborg/slimecore.dmi'
	icon_state = "core"
	to_call = /mob/living/carbon/human/proc/transparency_toggle
