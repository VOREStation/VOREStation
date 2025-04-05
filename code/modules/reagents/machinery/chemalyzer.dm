// Detects reagents inside most containers, and acts as an infinite identification system for reagent-based unidentified objects.

/obj/machinery/chemical_analyzer
	name = "chem analyzer PRO"
	desc = "New and improved! Used to precisely scan chemicals and other liquids inside various containers. \
	It can also identify the liquid contents of unknown objects and their chemical breakdowns."
	description_info = "This machine will try to tell you what reagents are inside of something capable of holding reagents. \
	It is also used to 'identify' specific reagent-based objects with their properties obscured from inspection by normal means."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "chem_analyzer"
	density = TRUE
	anchored = TRUE
	use_power = TRUE
	idle_power_usage = 20
	clicksound = "button"
	var/analyzing = FALSE
	var/list/found_reagents = list()

/obj/machinery/chemical_analyzer/update_icon()
	icon_state = "chem_analyzer[analyzing ? "-working":""]"

/obj/machinery/chemical_analyzer/attackby(obj/item/I, mob/living/user)
	if(!istype(I))
		return ..()

	if(default_deconstruction_screwdriver(user, I))
		return
	if(default_deconstruction_crowbar(user, I))
		return
	if(istype(I,/obj/item/reagent_containers))
		analyzing = TRUE
		update_icon()
		to_chat(user, span_notice("Analyzing \the [I], please stand by..."))

		if(!do_after(user, 2 SECONDS, src))
			to_chat(user, span_warning("Sample moved outside of scan range, please try again and remain still."))
			analyzing = FALSE
			update_icon()
			return

		// First, identify it if it isn't already.
		if(!I.is_identified(IDENTITY_FULL))
			var/datum/identification/ID = I.identity
			if(ID.identification_type == IDENTITY_TYPE_CHEMICAL) // This only solves chemical-based mysteries.
				I.identify(IDENTITY_FULL, user)

		// Now tell us everything that is inside.
		if(I.reagents && I.reagents.reagent_list.len)
			found_reagents.Cut()
			for(var/datum/reagent/R in I.reagents.reagent_list)
				if(!R.name)
					continue
				found_reagents[R.id] = R.volume
			tgui_interact(user)
		else
			to_chat(user, span_warning("Nothing detected in [I]"))

		analyzing = FALSE
		update_icon()
		return

/obj/machinery/chemical_analyzer/attack_hand(mob/user)
	if(!found_reagents.len)
		return ..()
	tgui_interact(user) // Show last analysis

/obj/machinery/chemical_analyzer/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ChemAnalyzerPro", name)
		ui.open()

/obj/machinery/chemical_analyzer/tgui_data(mob/user)
	var/list/data = list()

	var/total_vol = 0
	var/list/reagents_sent = list()
	var/obj/item/reagent_containers/glass/beaker/large/beaker_path = /obj/item/reagent_containers/glass/beaker/large
	for(var/ID in found_reagents)
		var/datum/reagent/R = SSchemistry.chemical_reagents[ID]
		if(!R)
			continue
		var/list/subdata = list()
		subdata["title"] = R.name
		SSinternal_wiki.add_icon(subdata, initial(beaker_path.icon), initial(beaker_path.icon_state), R.color)
		// Get internal data
		subdata["description"] = R.description
		subdata["flavor"] = R.taste_description
		subdata["allergen"] = SSinternal_wiki.assemble_allergens(R.allergen_type)
		subdata["beakerAmount"] = found_reagents[ID]
		total_vol += found_reagents[ID]
		SSinternal_wiki.assemble_reaction_data(subdata, R)
		// Send as a big list of lists
		reagents_sent += list(subdata)
	data["scannedReagents"] = reagents_sent
	data["beakerTotal"] = total_vol
	data["beakerMax"] = initial(beaker_path.volume)

	return data
