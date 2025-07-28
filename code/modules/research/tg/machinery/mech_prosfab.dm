/obj/machinery/mecha_part_fabricator_tg/prosthetics
	icon = 'icons/obj/robotics_vr.dmi'
	icon_state = "prosfab"
	name = "Prosthetics Fabricator"
	desc = "A machine used for the construction of prosthetics."

	fab_type = PROSFAB
	circuit = /obj/item/circuitboard/prosthetics

	// Prosfab specific stuff
	var/manufacturer = null
	var/species_types = list("Human")
	var/species = "Human"

/obj/machinery/mecha_part_fabricator_tg/prosthetics/AfterMaterialInsert()
	return // no call parent

/obj/machinery/mecha_part_fabricator_tg/prosthetics/update_icon()
	if(panel_open)
		icon_state = "prosfab-o"
	else
		icon_state = "prosfab[use_power == USE_POWER_ACTIVE ? "-active" : ""]"

/obj/machinery/mecha_part_fabricator_tg/prosthetics/on_start_printing()
	// Don't call parent
	update_icon()
	update_use_power(USE_POWER_ACTIVE)
	print_sound.start()

/obj/machinery/mecha_part_fabricator_tg/prosthetics/on_finish_printing()
	// Don't call parent
	update_use_power(USE_POWER_IDLE)
	desc = initial(desc)
	process_queue = FALSE
	print_sound.stop()
	update_icon()

/obj/machinery/mecha_part_fabricator_tg/prosthetics/tgui_data(mob/user)
	var/list/data = ..()

	data["species_types"] = species_types
	data["species"] = species
	data["manufacturer"] = manufacturer

	if(GLOB.all_robolimbs)
		var/list/T = list()
		for(var/A in GLOB.all_robolimbs)
			var/datum/robolimb/R = GLOB.all_robolimbs[A]
			if(R.unavailable_to_build)
				continue
			if(species in R.species_cannot_use)
				continue
			T += list(list("id" = A, "company" = R.company))
		data["all_manufacturers"] = T

	return data

/obj/machinery/mecha_part_fabricator_tg/prosthetics/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("species")
			var/new_species = tgui_input_list(ui.user, "Select a new species", "Prosfab Species Selection", species_types)
			if(new_species && tgui_status(ui.user, state) == STATUS_INTERACTIVE)
				species = new_species
			return TRUE
		if("manufacturer")
			var/list/new_manufacturers = list()
			for(var/A in GLOB.all_robolimbs)
				var/datum/robolimb/R = GLOB.all_robolimbs[A]
				if(R.unavailable_to_build)
					continue
				if(species in R.species_cannot_use)
					continue
				new_manufacturers += A

			var/new_manufacturer = tgui_input_list(ui.user, "Select a new manufacturer", "Prosfab Species Selection", new_manufacturers)
			if(new_manufacturer && tgui_status(ui.user, state) == STATUS_INTERACTIVE)
				manufacturer = new_manufacturer
			return TRUE

/obj/machinery/mecha_part_fabricator_tg/prosthetics/attackby(obj/item/I, mob/user, attack_modifier, click_parameters)
	add_fingerprint(user)

	if(istype(I,/obj/item/disk/limb))
		var/obj/item/disk/limb/D = I
		if(!D.company || !(D.company in GLOB.all_robolimbs))
			to_chat(user, span_warning("This disk seems to be corrupted!"))
		else
			to_chat(user, span_notice("Installing blueprint files for [D.company]..."))
			if(do_after(user,50,src))
				var/datum/robolimb/R = GLOB.all_robolimbs[D.company]
				R.unavailable_to_build = 0
				to_chat(user, span_notice("Installed [D.company] blueprints!"))
				qdel(I)
		return TRUE

	if(istype(I,/obj/item/disk/species))
		var/obj/item/disk/species/D = I
		if(!D.species || !(D.species in GLOB.all_species))
			to_chat(user, span_warning("This disk seems to be corrupted!"))
		else
			to_chat(user, span_notice("Uploading modification files for [D.species]..."))
			if(do_after(user,50,src))
				species_types |= D.species
				to_chat(user, span_notice("Uploaded [D.species] files!"))
				qdel(I)
		return TRUE

	return ..()

/obj/machinery/mecha_part_fabricator_tg/prosthetics/create_new_part(datum/design_techweb/dispensed_design)
	if(istype(dispensed_design, /datum/design_techweb/prosfab/pros/torso))
		var/newspecies = "Human"

		var/datum/robolimb/manf = GLOB.all_robolimbs[manufacturer]

		if(manf)
			if(species in manf.species_alternates)	// If the prosthetics fab is set to say, Unbranded, and species set to 'Tajaran', it will make the Taj variant of Unbranded, if it exists.
				manf = manf.species_alternates[species]
			if(!species || (species in manf.species_cannot_use))
				newspecies = manf.suggested_species
			else
				newspecies = species

		var/mob/living/carbon/human/H = new(src, newspecies)
		H.set_stat(DEAD)
		H.gender = gender
		for(var/obj/item/organ/external/EO in H.organs)
			if(EO.organ_tag == BP_TORSO || EO.organ_tag == BP_GROIN)
				continue //Roboticizing a torso does all the children and wastes time, do it later
			else
				EO.remove_rejuv()

		for(var/obj/item/organ/external/O in H.organs)
			O.data.setup_from_species(GLOB.all_species[newspecies])

			if(!(O.organ_tag in manf.parts))	// Make sure we're using an actually present icon.
				manf = GLOB.all_robolimbs["Unbranded"]

			O.robotize(manf.company)
			O.data.setup_from_dna()

			// Skincolor weirdness.
			O.s_col[1] = 0
			O.s_col[2] = 0
			O.s_col[3] = 0

		// Resetting the UI does strange things for the skin of a non-human robot, which should be controlled by a whole different thing.
		H.r_skin = 0
		H.g_skin = 0
		H.b_skin = 0
		H.dna.ResetUIFrom(H)

		H.allow_spontaneous_tf = TRUE // Allows vore customization of synthmorphs
		H.real_name = "Synthmorph #[rand(100,999)]"
		H.name = H.real_name
		H.dir = 2
		H.add_language(LANGUAGE_EAL)
		return H
	else if(istype(dispensed_design, /datum/design_techweb/prosfab/pros))
		var/obj/item/organ/O = new dispensed_design.build_path(src)
		if(manufacturer)
			var/datum/robolimb/manf = GLOB.all_robolimbs[manufacturer]

			if(!(O.organ_tag in manf.parts))	// Make sure we're using an actually present icon.
				manf = GLOB.all_robolimbs["Unbranded"]

			if(species in manf.species_alternates)	// If the prosthetics fab is set to say, Unbranded, and species set to 'Tajaran', it will make the Taj variant of Unbranded, if it exists.
				manf = manf.species_alternates[species]

			if(!species || (species in manf.species_cannot_use))	// Fabricator ensures the manufacturer can make parts for the species we're set to.
				O.data.setup_from_species(GLOB.all_species["[manf.suggested_species]"])
			else
				O.data.setup_from_species(GLOB.all_species[species])
		else
			O.data.setup_from_species(GLOB.all_species["Human"])
		O.robotize(manufacturer)
		return O
	else
		return new dispensed_design.build_path(src)
