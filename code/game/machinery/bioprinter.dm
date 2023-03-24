<<<<<<< HEAD
// GENERIC PRINTER - DO NOT USE THIS OBJECT.
// Flesh and robot printers are defined below this object.

/obj/machinery/organ_printer
	name = "organ printer"
	desc = "It's a machine that prints organs."
	icon = 'icons/obj/surgery_vr.dmi' //VOREStation Edit
=======
/// Prints organs by consuming biomass from an inserted container.
/obj/machinery/bioprinter
	name = "bioprinter"
	desc = "This is a growth chamber capable of quickly producing fresh body parts to fuel your inner mad scientist (or to perform transplants with, if you're boring like that.) Blood samples and biomass go in, kidneys come out."
	description_info = "Consumes specialized biomass from an inserted container. More can be made through chemistry, but it requires a lot of phoron."
	description_fluff = "Bioprinting new body parts can take days or even weeks, depending on the thing in question. However, some printers - like this one - can be built to run on a specialized phoron-based feedstock, allowing surrogate organs and appendages to be assembled in a matter of seconds. Printing in this way is insanely expensive, though, which prevents it from enjoying the ubiquity that slower machines do."
	icon = 'icons/obj/surgery.dmi'
>>>>>>> 8ede4b4c79c... Bioprinter refactor and nanoUI-ification (#9021)
	icon_state = "bioprinter"

	anchored = TRUE
	density = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 40
	active_power_usage = 300
	circuit = /obj/item/circuitboard/bioprinter

<<<<<<< HEAD
	var/obj/item/weapon/reagent_containers/container = null		// This is the beaker that holds all of the biomass

	var/print_delay = 100
	var/base_print_delay = 100	// For Adminbus reasons
	var/printing
	var/loaded_dna //Blood sample for DNA hashing.
	var/malfunctioning = FALSE	// May cause rejection, or the printing of some alien limb instead!

	var/complex_organs = FALSE	// Can it print more 'complex' organs?

	var/anomalous_organs = FALSE	// Can it print anomalous organs?

	// These should be subtypes of /obj/item/organ
	// Costs roughly 20u Phoron (1 sheet) per internal organ, limbs are 60u for limb and extremity
=======
	/// The reagent used by this bioprinter as fuel to produce things.
	var/biomass_id = "biomass"
	/// The container that biomass will be drawn from; without one, the machine cannot function.
	var/obj/item/reagent_containers/container = null

	/// How long in deciseconds it takes to print an organ. This is updated dynamically by parts.
	var/print_delay = 10 SECONDS
	/// The base time it takes for an organ to be printed. Should be type-specific, can be varedited for adminbus.
	var/base_print_delay = 10 SECONDS
	/// Printing an organ uses a stoppable timer; this variable references that timer's ID.
	/// Checking if this variable is null or not is used to determine whether or not the printer is actually printing.
	var/print_timer
	/// Data from a loaded blood sample, copied directly from the `data` list of `/datum/reagent/blood`.
	var/loaded_dna

	/// Organs printed by this machine might be from a different species, or cause rejection.
	/// Caused by using very high-rating parts (i.e. precursor tech.)
	var/malfunctioning = FALSE
	/// Allows the printer to create "complex" organs, like the brain and larynx.
	/// Granted by using high-quality parts.
	var/complex_organs = FALSE
	/// Allows the printer to create "anomalous" organs that it shouldn't usually be able to.
	/// Granted by using very high-rating parts, like `malfunctioning` is.
	var/anomalous_organs = FALSE

	/// A list of all the products that this bioprinter can produce by default.
	/// 1 unit of biomass (the default fuel) costs 1 unit of phoron,
	/// so each organ costs roughly 20u of phoron (1 sheet) and each limb costs 40u of phoron (2 sheets).
>>>>>>> 8ede4b4c79c... Bioprinter refactor and nanoUI-ification (#9021)
	var/list/products = list(
		"Heart"   = list(/obj/item/organ/internal/heart,  20),
		"Lungs"   = list(/obj/item/organ/internal/lungs,  20),
		"Kidneys" = list(/obj/item/organ/internal/kidneys,20),
		"Eyes"    = list(/obj/item/organ/internal/eyes,   20),
		"Liver"   = list(/obj/item/organ/internal/liver,  20),
		"Spleen"  = list(/obj/item/organ/internal/spleen, 20),
		"Stomach"  = list(/obj/item/organ/internal/stomach, 20),
		"Arm, Left"   = list(/obj/item/organ/external/arm,  40),
		"Arm, Right"   = list(/obj/item/organ/external/arm/right,  40),
		"Leg, Left"   = list(/obj/item/organ/external/leg,  40),
		"Leg, Right"   = list(/obj/item/organ/external/leg/right,  40),
		"Foot, Left"   = list(/obj/item/organ/external/foot,  20),
		"Foot, Right"   = list(/obj/item/organ/external/foot/right,  20),
		"Hand, Left"   = list(/obj/item/organ/external/hand,  20),
		"Hand, Right"   = list(/obj/item/organ/external/hand/right,  20)
		)

	/// Dynamically included with `products` if `complex_organs` is true.
	var/list/complex_products = list(
		"Brain" = list(/obj/item/organ/internal/brain, 60),
		"Larynx" = list(/obj/item/organ/internal/voicebox, 20),
		"Head" = list(/obj/item/organ/external/head, 40)
		)

	/// Dynamically included with `products` if `anomalous_organs` is true.
	/// Anything in this list will appear with a purple name in the UI, instead of the default blue.
	var/list/anomalous_products = list(
		"Lymphatic Complex" = list(/obj/item/organ/internal/immunehub, 120),
		"Respiration Nexus" = list(/obj/item/organ/internal/lungs/replicant/mending, 80),
		"Adrenal Valve Cluster" = list(/obj/item/organ/internal/heart/replicant/rage, 80)
		)

/obj/machinery/bioprinter/Initialize()
	. = ..()
	default_apply_parts()

/obj/machinery/bioprinter/full/Initialize()
	. = ..()
	container = new /obj/item/reagent_containers/glass/bottle/biomass(src)

/obj/machinery/bioprinter/dismantle()
	var/turf/T = get_turf(src)
	if (T && container)
		container.forceMove(T)
		container = null
	return ..()

/obj/machinery/bioprinter/attackby(obj/item/I, mob/user)
	if (default_deconstruction_screwdriver(user, I))
		updateUsrDialog()
		return
	if (default_deconstruction_crowbar(user, I))
		return
	if (default_part_replacement(user, I))
		return
	if (default_unfasten_wrench(user, I, 20))
		return
	if (istype(I, /obj/item/reagent_containers/syringe))
		var/obj/item/reagent_containers/syringe/S = I
		var/datum/reagent/blood/sample = S.reagents.get_reagent("blood")
		if (!sample?.data)
			to_chat(user, SPAN_WARNING("\The [I] doesn't contain a valid blood sample."))
			return
		loaded_dna = sample.data
		S.reagents.clear_reagents()
		S.mode = SYRINGE_DRAW
		S.update_icon()
		user.visible_message(
			SPAN_NOTICE("\The [user] fills \the [src] with a blood sample."),
			SPAN_NOTICE("You inject \the [src] with a blood sample from \the [I].")
		)
		SSnanoui.update_uis(src)
		return
	if (istype(I, /obj/item/reagent_containers/glass))
		if (container)
			to_chat(user, SPAN_WARNING("\The [src] already has a container loaded."))
			return
		var/obj/item/reagent_containers/glass/G = I
		if (!do_after(user, 1 SECOND))
			return
		user.visible_message(
			SPAN_NOTICE("\The [user] loads \the [G] into \the [src]."),
			SPAN_NOTICE("You load \the [G] into \the [src].")
		)
		user.drop_from_inventory(G)
		G.forceMove(src)
		container = G
		SSnanoui.update_uis(src)
		return
	return ..()

<<<<<<< HEAD
/obj/machinery/organ_printer/update_icon()
	//VOREStation Edit
=======
/obj/machinery/bioprinter/update_icon()
>>>>>>> 8ede4b4c79c... Bioprinter refactor and nanoUI-ification (#9021)
	cut_overlays()
	if (panel_open)
		add_overlay("bioprinter_panel_open")
	if (print_timer != null)
		add_overlay("bioprinter_working")
	//VOREStation Edit End

<<<<<<< HEAD
/obj/machinery/organ_printer/Initialize()
	. = ..()
	default_apply_parts()

/obj/machinery/organ_printer/examine(var/mob/user)
	. = ..()
	var/biomass = get_biomass_volume()
	if(biomass)
		. += "<span class='notice'>It is loaded with [biomass] units of biomass.</span>"
	else
		. += "<span class='notice'>It is not loaded with any biomass.</span>"

/obj/machinery/organ_printer/RefreshParts()
	// Print Delay updating
	print_delay = base_print_delay
	var/manip_rating = 0
	for(var/obj/item/weapon/stock_parts/manipulator/manip in component_parts)
		manip_rating += manip.rating
		print_delay -= (manip.rating-1)*10
	print_delay = max(0,print_delay)

=======
/obj/machinery/bioprinter/RefreshParts()
	print_delay = base_print_delay
	var/manip_rating = 0
	for(var/obj/item/stock_parts/manipulator/M in component_parts)
		manip_rating += M.rating
		print_delay -= (M.rating - 1) * 1 SECOND
	print_delay = max(0, print_delay)

	// Update the capabilities of the bioprinter based on its rating divided by half.
	// 3 = can print complex organs
	// 4 = can print anomalous organs
	// 5 = 30% chance to malfunction when printing
>>>>>>> 8ede4b4c79c... Bioprinter refactor and nanoUI-ification (#9021)
	manip_rating = round(manip_rating / 2)
	complex_organs = manip_rating >= 3
	anomalous_organs = manip_rating >= 4
	malfunctioning = manip_rating >= 5

	. = ..()

/obj/machinery/bioprinter/attack_hand(mob/user)
	if (stat & (BROKEN|NOPOWER))
		return
<<<<<<< HEAD

	if(container)
		var/response = tgui_alert(user, "What do you want to do?", "Bioprinter Menu", list("Print Limbs", "Cancel"))
		if(response == "Print Limbs")
			printing_menu(user)
	else
		to_chat(user, "<span class='warning'>\The [src] can't operate without a reagent reservoir!</span>")

/obj/machinery/organ_printer/proc/printing_menu(mob/user)
	var/list/possible_list = list()

	possible_list |= products

	if(complex_organs)
		possible_list |= complex_products

	if(anomalous_organs)
		possible_list |= anomalous_products

	var/choice = tgui_input_list(usr, "What would you like to print?", "Print Choice", possible_list)

	if(!choice || printing || (stat & (BROKEN|NOPOWER)))
=======
	else if (panel_open)
		to_chat(user, SPAN_WARNING("Close the panel first!"))
>>>>>>> 8ede4b4c79c... Bioprinter refactor and nanoUI-ification (#9021)
		return
	ui_interact(user)

/obj/machinery/bioprinter/ui_interact(mob/user, ui_key, datum/nanoui/ui, force_open, master_ui, datum/topic_state/state)
	var/list/data = build_ui_data()
	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open = force_open)
	if (!ui)
		ui = new(user, src, ui_key, "bioprinter.tmpl", capitalize(name), 500, 650)
		ui.set_initial_data(data)
		ui.open()

/obj/machinery/bioprinter/proc/build_ui_data()
	var/data[0]

	data["biomassContainer"] = container
	data["biomassVolume"] = get_biomass_volume()
	data["biomassMax"] = container?.reagents.maximum_volume

	data["printTime"] = print_delay
	data["isPrinting"] = print_timer != null

	data["dna"] = loaded_dna
	data["dnaHash"] = loaded_dna?["blood_DNA"]
	// This is pretty hacky, but it seems like the blood sample doesn't otherwise keep its species data handy
	var/mob/living/carbon/human/donor = loaded_dna?["donor"]
	data["dnaSpecies"] = donor?.species ? donor.species.name : "N/A"

	var/list/valid_products = list()
	valid_products |= products
	if (complex_organs)
		valid_products |= complex_products
	if (anomalous_organs)
		valid_products |= anomalous_products

	var/products_data[0]
	for (var/O in valid_products)
		products_data[++products_data.len] = list(
			"name" = O,
			"cost" = valid_products[O][2],
			"canPrint" = (get_biomass_volume() >= valid_products[O][2]) && loaded_dna,
			"anomalous" = anomalous_products.Find(O)
		)
	data["products"] = products_data

	return data

/obj/machinery/bioprinter/Topic(href, href_list, datum/topic_state/state)
	if (..())
		return TRUE
	if (href_list["ejectBeaker"])
		if (container)
			container.forceMove(get_turf(src))
			if (usr.Adjacent(src))
				usr.put_in_active_hand(container)
			container = null
	if (href_list["flushDNA"])
		if (loaded_dna)
			loaded_dna = null
			visible_message(SPAN_NOTICE("\The [src] whirrs and discards its most recent DNA sample."))
	if (href_list["printOrgan"])
		var/organ_name = href_list["printOrgan"]
		var/list/all_products = products + complex_products + anomalous_products
		var/product_entry = all_products[organ_name]
		var/atom/product_path = product_entry?[1]
		if (product_entry && product_path && get_biomass_volume() >= product_entry[2])
			container.reagents.remove_reagent(biomass_id, product_entry[2])
			playsound(src, "switch", 30)
			visible_message(SPAN_NOTICE("\The [src] fills with fluid and begins to print \a [initial(product_path.name)]."))
			print_timer = addtimer(CALLBACK(src, .proc/print_organ, product_entry[1]), print_delay, TIMER_STOPPABLE)
			set_active(TRUE)
	if (href_list["cancelPrint"])
		if (print_timer)
			playsound(src, "switch", 30)
			playsound(src, 'sound/effects/squelch1.ogg', 40, TRUE)
			visible_message(SPAN_WARNING("\The [src] gurgles as it cancels its current task and discards the pulpy biomass."))
			deltimer(print_timer)
			print_timer = null
			set_active(FALSE)
	SSnanoui.update_uis(src)
	update_icon()

<<<<<<< HEAD
	visible_message("<b>\The [src]</b> begins churning.")

	sleep(print_delay)

	update_use_power(USE_POWER_IDLE)
	printing = 0
=======
/// Updates power usage in accordance with `active` and forces an icon update.
/obj/machinery/bioprinter/proc/set_active(active)
	update_use_power(active ? USE_POWER_ACTIVE : USE_POWER_IDLE)
>>>>>>> 8ede4b4c79c... Bioprinter refactor and nanoUI-ification (#9021)
	update_icon()

/// Returns the amount of usable biomass that this printer has.
/// 0 will be returned if no container is loaded.
/obj/machinery/bioprinter/proc/get_biomass_volume()
	var/biomass_count = 0
	if (container?.reagents)
		biomass_count += container.reagents.get_reagent_amount(biomass_id)
	return biomass_count

<<<<<<< HEAD
/obj/machinery/organ_printer/proc/can_print(var/choice, var/masscount = 0)
	var/biomass = get_biomass_volume()
	if(biomass < masscount)
		visible_message("<b>\The [src]</b> displays a warning: 'Not enough biomass. [biomass] stored and [masscount] needed.'")
		return 0

	if(!loaded_dna || !loaded_dna["donor"])
		visible_message("<span class='info'>\The [src] displays a warning: 'No DNA saved. Insert a blood sample.'</span>")
		return 0

	return 1

/obj/machinery/organ_printer/proc/print_organ(var/choice)
	var/new_organ = choice
	var/obj/item/organ/O = new new_organ(get_turf(src))
	O.status |= ORGAN_CUT_AWAY
=======
/// Prints an organ of typepath `choice`, with DNA and species set to that of `loaded_dna["donor"]`.
/// If `malfunctioning` is true, has a 30% chance to mess it up as well.
/// Returns a reference to the new organ.
/obj/machinery/bioprinter/proc/print_organ(atom/choice)
>>>>>>> 8ede4b4c79c... Bioprinter refactor and nanoUI-ification (#9021)
	var/mob/living/carbon/human/C = loaded_dna["donor"]
	var/obj/item/organ/O = new choice(get_turf(src))
	O.status |= ORGAN_CUT_AWAY
	O.set_dna(C.dna)
	O.species = C.species

	var/malfunctioned = FALSE
	if (malfunctioning && prob(30)) // Alien Tech is a hell of a drug.
		malfunctioned = TRUE
		var/possible_species = list(SPECIES_HUMAN, SPECIES_VOX, SPECIES_SKRELL, SPECIES_ZADDAT, SPECIES_UNATHI, SPECIES_GOLEM, SPECIES_SHADOW)
		var/new_species = pick(possible_species)
		if (!GLOB.all_species[new_species])
			new_species = SPECIES_HUMAN
		O.species = GLOB.all_species[new_species]

	if (istype(O, /obj/item/organ/external) && !malfunctioned)
		var/obj/item/organ/external/E = O
		E.sync_colour_to_human(C)

	if (O.species)
		// This is a very hacky way of doing of what organ/Initialize() does if it has an owner
		O.w_class = max(O.w_class + mob_size_difference(O.species.mob_size, MOB_MEDIUM), 1)

	print_timer = null
	playsound(src, 'sound/machines/kitchen/microwave/microwave-end.ogg', 50, TRUE)
	visible_message(SPAN_NOTICE("\The [src] dings and spits out \a [O.name]."))
	set_active(FALSE)
	SSnanoui.update_uis(src)
	return O

<<<<<<< HEAD
// CIRCUITS
/obj/item/weapon/circuitboard/bioprinter
=======
/obj/item/circuitboard/bioprinter
>>>>>>> 8ede4b4c79c... Bioprinter refactor and nanoUI-ification (#9021)
	name = "bioprinter circuit"
	build_path = /obj/machinery/bioprinter
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	req_components = list(
							/obj/item/stack/cable_coil = 2,
<<<<<<< HEAD
							/obj/item/weapon/stock_parts/matter_bin = 2,
							/obj/item/weapon/stock_parts/manipulator = 2)

// FLESH ORGAN PRINTER
/obj/machinery/organ_printer/flesh
	name = "bioprinter"
	desc = "It's a machine that prints replacement organs."
	icon_state = "bioprinter"
	circuit = /obj/item/weapon/circuitboard/bioprinter

/obj/machinery/organ_printer/flesh/full/Initialize()
	. = ..()
	container = new /obj/item/weapon/reagent_containers/glass/bottle/biomass(src)

/obj/machinery/organ_printer/flesh/dismantle()
	var/turf/T = get_turf(src)
	if(T)
		if(container)
			container.forceMove(T)
			container = null
	return ..()

/obj/machinery/organ_printer/flesh/print_organ(var/choice)
	var/obj/item/organ/O = ..()

	playsound(src, 'sound/machines/ding.ogg', 50, 1)
	visible_message("<span class='info'>\The [src] dings, then spits out \a [O].</span>")
	return O

/obj/machinery/organ_printer/flesh/attackby(obj/item/weapon/W, mob/user)
	// DNA sample from syringe.
	if(istype(W,/obj/item/weapon/reagent_containers/syringe))	//TODO: Make this actually empty the syringe
		var/obj/item/weapon/reagent_containers/syringe/S = W
		var/datum/reagent/blood/injected = locate() in S.reagents.reagent_list //Grab some blood
		if(injected && injected.data)
			loaded_dna = injected.data
			S.reagents.remove_reagent("blood", injected.volume)
			to_chat(user, "<span class='info'>You scan the blood sample into the bioprinter.</span>")
		return
	else if(istype(W,/obj/item/weapon/reagent_containers/glass))
		var/obj/item/weapon/reagent_containers/glass/G = W
		if(container)
			to_chat(user, "<span class='warning'>\The [src] already has a container loaded!</span>")
			return
		else if(do_after(user, 1 SECOND))
			user.visible_message("[user] has loaded \the [G] into \the [src].", "You load \the [G] into \the [src].")
			container = G
			user.drop_item()
			G.forceMove(src)
		return

	return ..()
// END FLESH ORGAN PRINTER


/* Roboprinter is made obsolete by the system already in place and mapped into Robotics
/obj/item/weapon/circuitboard/roboprinter
	name = "roboprinter circuit"
	build_path = /obj/machinery/organ_printer/robot
	board_type = new /datum/frame/frame_types/machine
	origin_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	req_components = list(
							/obj/item/stack/cable_coil = 2,
							/obj/item/weapon/stock_parts/matter_bin = 2,
							/obj/item/weapon/stock_parts/manipulator = 2)

// ROBOT ORGAN PRINTER
// Still Requires DNA, /obj/machinery/pros_fab is better for limbs
/obj/machinery/organ_printer/robot
	name = "prosthetic organ fabricator"
	desc = "It's a machine that prints prosthetic organs."
	icon_state = "roboprinter"
	circuit = /obj/item/weapon/circuitboard/roboprinter

	var/matter_amount_per_sheet = 10
	var/matter_type = MAT_STEEL

/obj/machinery/organ_printer/robot/full/New()
	. = ..()
	stored_matter = max_stored_matter

/obj/machinery/organ_printer/robot/dismantle()
	if(stored_matter >= matter_amount_per_sheet)
		new /obj/item/stack/material/steel(get_turf(src), FLOOR(stored_matter/matter_amount_per_sheet, 1))
	return ..()

/obj/machinery/organ_printer/robot/print_organ(var/choice)
	var/obj/item/organ/O = ..()
	O.robotize()
	O.status |= ORGAN_CUT_AWAY  // robotize() resets status to 0
	playsound(src, 'sound/machines/ding.ogg', 50, 1)
	audible_message("<span class='info'>\The [src] dings, then spits out \a [O].</span>")
	return O

/obj/machinery/organ_printer/robot/attackby(var/obj/item/weapon/W, var/mob/user)
	if(istype(W, /obj/item/stack/material) && W.get_material_name() == matter_type)
		if((max_stored_matter-stored_matter) < matter_amount_per_sheet)
			to_chat(user, "<span class='warning'>\The [src] is too full.</span>")
			return
		var/obj/item/stack/S = W
		var/space_left = max_stored_matter - stored_matter
		var/sheets_to_take = min(S.amount, FLOOR(space_left/matter_amount_per_sheet, 1))
		if(sheets_to_take <= 0)
			to_chat(user, "<span class='warning'>\The [src] is too full.</span>")
			return
		stored_matter = min(max_stored_matter, stored_matter + (sheets_to_take*matter_amount_per_sheet))
		to_chat(user, "<span class='info'>\The [src] processes \the [W]. Levels of stored matter now: [stored_matter]</span>")
		S.use(sheets_to_take)
		return
	else if(istype(W,/obj/item/weapon/reagent_containers/syringe))	//TODO: Make this actuall empty the syringe
		var/obj/item/weapon/reagent_containers/syringe/S = W
		var/datum/reagent/blood/injected = locate() in S.reagents.reagent_list //Grab some blood
		if(injected && injected.data)
			loaded_dna = injected.data
			to_chat(user, "<span class='info'>You scan the blood sample into the bioprinter.</span>")
		return
	return ..()
// END ROBOT ORGAN PRINTER
*/
=======
							/obj/item/stock_parts/matter_bin = 2,
							/obj/item/stock_parts/manipulator = 2)
>>>>>>> 8ede4b4c79c... Bioprinter refactor and nanoUI-ification (#9021)
