/obj/machinery/mecha_part_fabricator/pros
	icon = 'icons/obj/robotics_vr.dmi' //VOREStation Edit - New icon
	icon_state = "prosfab"
	name = "Prosthetics Fabricator"
	desc = "A machine used for the construction of prosthetics."
	density = TRUE
	anchored = TRUE
	unacidable = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 20
	active_power_usage = 5000
	req_access = list(access_robotics)
	circuit = /obj/item/circuitboard/prosthetics

	// Prosfab specific stuff
	var/manufacturer = null
	var/species_types = list("Human")
	var/species = "Human"

	loading_icon_state = null

	materials = list(
		MAT_STEEL = 0,
		MAT_GLASS = 0,
		MAT_PLASTIC = 0,
		MAT_GRAPHITE = 0,
		MAT_PLASTEEL = 0,
		MAT_GLASS = 0,
		MAT_SILVER = 0,
		MAT_LEAD = 0,
		MAT_OSMIUM = 0,
		MAT_DIAMOND = 0,
		MAT_DURASTEEL = 0,
		MAT_PHORON = 0,
		MAT_URANIUM = 0,
		MAT_VERDANTIUM = 0,
		MAT_MORPHIUM = 0)
	res_max_amount = 200000

	valid_buildtype = PROSFAB
	/// A list of categories that valid PROSFAB design datums will broadly categorise themselves under.
	part_sets = list(
					"Cyborg",
					"Ripley",
					"Odysseus",
					"Gygax",
					"Durand",
					"Janus",
					"Vehicle",
					"Rigsuit",
					"Phazon",
					"Gopher", // VOREStation Add
					"Polecat", // VOREStation Add
					"Weasel", // VOREStation Add
					"Exosuit Equipment",
					"Exosuit Internals",
					"Exosuit Ammunition",
					"Cyborg Modules",
					"Prosthetics",
					"Prosthetics, Internal",
					"Cyborg Parts",
					"Cyborg Internals",
					"Cybernetics",
					"pAI Parts", //VOREStation Add
					"Implants",
					"Control Interfaces",
					"Other",
					"Misc",
					)

/obj/machinery/mecha_part_fabricator/pros/Initialize()
	. = ..()
	manufacturer = basic_robolimb.company

/obj/machinery/mecha_part_fabricator/pros/dispense_built_part(datum/design/D)
	var/obj/item/I = ..()
	if(isobj(I) && I.matter && I.matter.len > 0)
		for(var/i in I.matter)
			I.matter[i] = I.matter[i] * component_coeff

/obj/machinery/mecha_part_fabricator/pros/tgui_data(mob/user)
	var/list/data = ..()

	data["species_types"] = species_types
	data["species"] = species

	if(all_robolimbs)
		var/list/T = list()
		for(var/A in all_robolimbs)
			var/datum/robolimb/R = all_robolimbs[A]
			if(R.unavailable_to_build)
				continue
			if(species in R.species_cannot_use)
				continue
			T += list(list("id" = A, "company" = R.company))
		data["manufacturers"] = T

	data["manufacturer"] = manufacturer

	return data

/obj/machinery/mecha_part_fabricator/pros/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	. = TRUE

	add_fingerprint(ui.user)
	ui.user.set_machine(src)

	switch(action)
		if("species")
			var/new_species = tgui_input_list(ui.user, "Select a new species", "Prosfab Species Selection", species_types)
			if(new_species && tgui_status(ui.user, state) == STATUS_INTERACTIVE)
				species = new_species
			return
		if("manufacturer")
			var/list/new_manufacturers = list()
			for(var/A in all_robolimbs)
				var/datum/robolimb/R = all_robolimbs[A]
				if(R.unavailable_to_build)
					continue
				if(species in R.species_cannot_use)
					continue
				new_manufacturers += A

			var/new_manufacturer = tgui_input_list(ui.user, "Select a new manufacturer", "Prosfab Species Selection", new_manufacturers)
			if(new_manufacturer && tgui_status(ui.user, state) == STATUS_INTERACTIVE)
				manufacturer = new_manufacturer
			return
	return FALSE

/obj/machinery/mecha_part_fabricator/pros/attackby(var/obj/item/I, var/mob/user)
	if(..())
		return 1

	if(istype(I,/obj/item/disk/limb))
		var/obj/item/disk/limb/D = I
		if(!D.company || !(D.company in all_robolimbs))
			to_chat(user, span_warning("This disk seems to be corrupted!"))
		else
			to_chat(user, span_notice("Installing blueprint files for [D.company]..."))
			if(do_after(user,50,src))
				var/datum/robolimb/R = all_robolimbs[D.company]
				R.unavailable_to_build = 0
				to_chat(user, span_notice("Installed [D.company] blueprints!"))
				qdel(I)
		return

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
		return
