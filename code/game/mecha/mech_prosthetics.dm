/obj/machinery/mecha_part_fabricator/pros
	icon = 'icons/obj/robotics.dmi'
	icon_state = "prosfab"
	name = "Prosthetics Fabricator"
	desc = "A machine used for construction of prosthetics."
	density = 1
	anchored = 1
	use_power = USE_POWER_IDLE
	idle_power_usage = 20
	active_power_usage = 5000
	req_access = list(access_robotics)
	circuit = /obj/item/weapon/circuitboard/prosthetics

	// Prosfab specific stuff
	var/manufacturer = null
	var/species_types = list("Human")
	var/species = "Human"

	loading_icon_state = "prosfab_loading"

	materials = list(
		DEFAULT_WALL_MATERIAL = 0,
		"glass" = 0,
		"plastic" = 0,
		MAT_GRAPHITE = 0,
		MAT_PLASTEEL = 0,
		"gold" = 0,
		"silver" = 0,
		MAT_LEAD = 0,
		"osmium" = 0,
		"diamond" = 0,
		MAT_DURASTEEL = 0,
		"phoron" = 0,
		"uranium" = 0,
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

	add_fingerprint(usr)
	usr.set_machine(src)

	switch(action)
		if("species")
			var/new_species = input(usr, "Select a new species", "Prosfab Species Selection", "Human") as null|anything in species_types
			if(new_species && tgui_status(usr, state) == STATUS_INTERACTIVE)
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

			var/new_manufacturer = input(usr, "Select a new manufacturer", "Prosfab Species Selection", "Unbranded") as null|anything in new_manufacturers
			if(new_manufacturer && tgui_status(usr, state) == STATUS_INTERACTIVE)
				manufacturer = new_manufacturer
			return
	return FALSE

/obj/machinery/mecha_part_fabricator/pros/attackby(var/obj/item/I, var/mob/user)
	if(..())
		return 1

	if(istype(I,/obj/item/weapon/disk/limb))
		var/obj/item/weapon/disk/limb/D = I
		if(!D.company || !(D.company in all_robolimbs))
			to_chat(user, "<span class='warning'>This disk seems to be corrupted!</span>")
		else
			to_chat(user, "<span class='notice'>Installing blueprint files for [D.company]...</span>")
			if(do_after(user,50,src))
				var/datum/robolimb/R = all_robolimbs[D.company]
				R.unavailable_to_build = 0
				to_chat(user, "<span class='notice'>Installed [D.company] blueprints!</span>")
				qdel(I)
		return

	if(istype(I,/obj/item/weapon/disk/species))
		var/obj/item/weapon/disk/species/D = I
		if(!D.species || !(D.species in GLOB.all_species))
			to_chat(user, "<span class='warning'>This disk seems to be corrupted!</span>")
		else
			to_chat(user, "<span class='notice'>Uploading modification files for [D.species]...</span>")
			if(do_after(user,50,src))
				species_types |= D.species
				to_chat(user, "<span class='notice'>Uploaded [D.species] files!</span>")
				qdel(I)
		return
