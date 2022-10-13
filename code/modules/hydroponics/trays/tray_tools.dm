//Analyzer, pestkillers, weedkillers, nutrients, hatchets, cutters.

/obj/item/weapon/tool/wirecutters/clippers
	name = "plant clippers"
	desc = "A tool used to take samples from plants."

<<<<<<< HEAD
/obj/item/weapon/tool/wirecutters/clippers/trimmers
    name = "hedgetrimmers"
    desc = "An old pair of trimmers with a pretty dull blade. You would probably have a hard time cutting anything but plants with it."
    icon_state = "hedget"
    item_state = "hedget"
    force = 7 //One point extra than standard wire cutters.
=======
/obj/item/tool/wirecutters/clippers/trimmers
	name = "hedgetrimmers"
	desc = "An old pair of trimmers with a pretty dull blade. You would probably have a hard time cutting anything but plants with it."
	icon_state = "hedget"
	item_state = "hedget"
	random_color = FALSE
	force = 7 //One point extra than standard wire cutters.
>>>>>>> 39cebe388e1... Merge pull request #8741 from Cerebulon/sprite_tweaks_oct

/obj/item/device/analyzer/plant_analyzer
	name = "plant analyzer"
	icon = 'icons/obj/device.dmi'
	icon_state = "hydro"
	item_state = "analyzer"
	var/datum/seed/last_seed
	var/list/last_reagents

/obj/item/device/analyzer/plant_analyzer/Destroy()
	. = ..()
	QDEL_NULL(last_seed)

/obj/item/device/analyzer/plant_analyzer/attack_self(mob/user)
	tgui_interact(user)

/obj/item/device/analyzer/plant_analyzer/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "PlantAnalyzer", name)
		ui.open()
	
/obj/item/device/analyzer/plant_analyzer/tgui_state(mob/user)
	return GLOB.tgui_inventory_state

/obj/item/device/analyzer/plant_analyzer/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()

	var/datum/seed/grown_seed = last_seed
	if(!istype(grown_seed))
		return list("no_seed" = TRUE)

	data["no_seed"] = FALSE
	data["seed"] = grown_seed.get_tgui_analyzer_data(user)
	data["reagents"] = last_reagents

	return data

/obj/item/device/analyzer/plant_analyzer/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE
	
	switch(action)
		if("print")
			print_report(usr)
			return TRUE
		if("close")
			last_seed = null
			last_reagents = null
			return TRUE

/obj/item/device/analyzer/plant_analyzer/afterattack(obj/target, mob/user, flag)
	if(!flag)
		return

	var/datum/seed/grown_seed
	var/datum/reagents/grown_reagents
	if(istype(target,/obj/structure/table))
		return ..()
	else if(istype(target,/obj/item/weapon/reagent_containers/food/snacks/grown))

		var/obj/item/weapon/reagent_containers/food/snacks/grown/G = target
		grown_seed = SSplants.seeds[G.plantname]
		grown_reagents = G.reagents

	else if(istype(target,/obj/item/weapon/grown))

		var/obj/item/weapon/grown/G = target
		grown_seed = SSplants.seeds[G.plantname]
		grown_reagents = G.reagents

	else if(istype(target,/obj/item/seeds))

		var/obj/item/seeds/S = target
		grown_seed = S.seed

	else if(istype(target,/obj/machinery/portable_atmospherics/hydroponics))

		var/obj/machinery/portable_atmospherics/hydroponics/H = target
		if(H.frozen == 1)
			to_chat(user, "<span class='warning'>Disable the cryogenic freezing first!</span>")
			return
		grown_seed = H.seed
		grown_reagents = H.reagents

	if(!grown_seed)
		to_chat(user, "<span class='danger'>[src] can tell you nothing about \the [target].</span>")
		return

	last_seed = grown_seed.diverge()
	if(!istype(last_seed))
		last_seed = grown_seed // TRAIT_IMMUTABLE makes diverge() return null

	user.visible_message("<span class='notice'>[user] runs the scanner over \the [target].</span>")

	last_reagents = list()
	if(grown_reagents && grown_reagents.reagent_list && grown_reagents.reagent_list.len)
		for(var/datum/reagent/R in grown_reagents.reagent_list)
			last_reagents.Add(list(list(
				"name" = R.name,
				"volume" = grown_reagents.get_reagent_amount(R.id),
			)))

	tgui_interact(user)

/obj/item/device/analyzer/plant_analyzer/proc/print_report_verb()
	set name = "Print Plant Report"
	set category = "Object"
	set src = usr

	if(usr.stat || usr.restrained() || usr.lying)
		return
	print_report(usr)

/obj/item/device/analyzer/plant_analyzer/proc/print_report(var/mob/living/user)
	var/datum/seed/grown_seed = last_seed
	if(!istype(grown_seed))
		to_chat(user, "<span class='warning'>There is no scan data to print.</span>")
		return

	var/form_title = "[grown_seed.seed_name] (#[grown_seed.uid])"
	var/dat = "<h3>Plant data for [form_title]</h3>"
	dat += "<h2>General Data</h2>"
	dat += "<table>"
	dat += "<tr><td><b>Endurance</b></td><td>[grown_seed.get_trait(TRAIT_ENDURANCE)]</td></tr>"
	dat += "<tr><td><b>Yield</b></td><td>[grown_seed.get_trait(TRAIT_YIELD)]</td></tr>"
	dat += "<tr><td><b>Maturation time</b></td><td>[grown_seed.get_trait(TRAIT_MATURATION)]</td></tr>"
	dat += "<tr><td><b>Production time</b></td><td>[grown_seed.get_trait(TRAIT_PRODUCTION)]</td></tr>"
	dat += "<tr><td><b>Potency</b></td><td>[grown_seed.get_trait(TRAIT_POTENCY)]</td></tr>"
	dat += "</table>"

	if(LAZYLEN(last_reagents))
		dat += "<h2>Reagent Data</h2>"
		dat += "<br>This sample contains: "
		for(var/i in 1 to LAZYLEN(last_reagents))
			dat += "<br>- [last_reagents[i]["name"]], [last_reagents[i]["volume"]] unit(s)"

	dat += "<h2>Other Data</h2>"

	var/list/tgui_data = grown_seed.get_tgui_analyzer_data()

	dat += jointext(tgui_data["trait_info"], "<br>\n")

	var/obj/item/weapon/paper/P = new /obj/item/weapon/paper(get_turf(src))
	P.name = "paper - [form_title]"
	P.info = "[dat]"
	if(istype(user,/mob/living/carbon/human))
		user.put_in_hands(P)
	user.visible_message("\The [src] spits out a piece of paper.")
	return

/datum/seed/proc/get_tgui_analyzer_data(mob/user)
	var/list/data = list()

	data["name"] = seed_name
	data["uid"] = uid
	data["endurance"] = get_trait(TRAIT_ENDURANCE)
	data["yield"] = get_trait(TRAIT_YIELD)
	data["maturation_time"] = get_trait(TRAIT_MATURATION)
	data["production_time"] = get_trait(TRAIT_PRODUCTION)
	data["potency"] = get_trait(TRAIT_POTENCY)

	data["trait_info"] = list()
	if(get_trait(TRAIT_HARVEST_REPEAT))
		data["trait_info"] += "This plant can be harvested repeatedly."

	if(get_trait(TRAIT_IMMUTABLE) == -1)
		data["trait_info"] += "This plant is highly mutable."
	else if(get_trait(TRAIT_IMMUTABLE) > 0)
		data["trait_info"] += "This plant does not possess genetics that are alterable."

	if(get_trait(TRAIT_REQUIRES_NUTRIENTS))
		if(get_trait(TRAIT_NUTRIENT_CONSUMPTION) < 0.05)
			data["trait_info"] += "It consumes a small amount of nutrient fluid."
		else if(get_trait(TRAIT_NUTRIENT_CONSUMPTION) > 0.2)
			data["trait_info"] += "It requires a heavy supply of nutrient fluid."
		else
			data["trait_info"] += "It requires a supply of nutrient fluid."

	if(get_trait(TRAIT_REQUIRES_WATER))
		if(get_trait(TRAIT_WATER_CONSUMPTION) < 1)
			data["trait_info"] += "It requires very little water."
		else if(get_trait(TRAIT_WATER_CONSUMPTION) > 5)
			data["trait_info"] += "It requires a large amount of water."
		else
			data["trait_info"] += "It requires a stable supply of water."

	if(mutants && mutants.len)
		data["trait_info"] += "It exhibits a high degree of potential subspecies shift."

	data["trait_info"] += "It thrives in a temperature of [get_trait(TRAIT_IDEAL_HEAT)] Kelvin."

	if(get_trait(TRAIT_LOWKPA_TOLERANCE) < 20)
		data["trait_info"] += "It is well adapted to low pressure levels."
	if(get_trait(TRAIT_HIGHKPA_TOLERANCE) > 220)
		data["trait_info"] += "It is well adapted to high pressure levels."

	if(get_trait(TRAIT_HEAT_TOLERANCE) > 30)
		data["trait_info"] += "It is well adapted to a range of temperatures."
	else if(get_trait(TRAIT_HEAT_TOLERANCE) < 10)
		data["trait_info"] += "It is very sensitive to temperature shifts."

	data["trait_info"] += "It thrives in a light level of [get_trait(TRAIT_IDEAL_LIGHT)] lumen[get_trait(TRAIT_IDEAL_LIGHT) == 1 ? "" : "s"]."

	if(get_trait(TRAIT_LIGHT_TOLERANCE) > 10)
		data["trait_info"] += "It is well adapted to a range of light levels."
	else if(get_trait(TRAIT_LIGHT_TOLERANCE) < 3)
		data["trait_info"] += "It is very sensitive to light level shifts."

	if(get_trait(TRAIT_TOXINS_TOLERANCE) < 3)
		data["trait_info"] += "It is highly sensitive to toxins."
	else if(get_trait(TRAIT_TOXINS_TOLERANCE) > 6)
		data["trait_info"] += "It is remarkably resistant to toxins."

	if(get_trait(TRAIT_PEST_TOLERANCE) < 3)
		data["trait_info"] += "It is highly sensitive to pests."
	else if(get_trait(TRAIT_PEST_TOLERANCE) > 6)
		data["trait_info"] += "It is remarkably resistant to pests."

	if(get_trait(TRAIT_WEED_TOLERANCE) < 3)
		data["trait_info"] += "It is highly sensitive to weeds."
	else if(get_trait(TRAIT_WEED_TOLERANCE) > 6)
		data["trait_info"] += "It is remarkably resistant to weeds."

	switch(get_trait(TRAIT_SPREAD))
		if(1)
			data["trait_info"] += "It is able to be planted outside of a tray."
		if(2)
			data["trait_info"] += "It is a robust and vigorous vine that will spread rapidly."

	switch(get_trait(TRAIT_CARNIVOROUS))
		if(1)
			data["trait_info"] += "It is carnivorous and will eat tray pests for sustenance."
		if(2)
			data["trait_info"] += "It is carnivorous and poses a significant threat to living things around it."

	if(get_trait(TRAIT_PARASITE))
		data["trait_info"] += "It is capable of parisitizing and gaining sustenance from tray weeds."

/*
	There's currently no code that actually changes the temperature of the local environment, so let's not show it until there is.
	if(get_trait(TRAIT_ALTER_TEMP))
		data["trait_info"] += "It will periodically alter the local temperature by [get_trait(TRAIT_ALTER_TEMP)] degrees Kelvin."
*/

	if(get_trait(TRAIT_BIOLUM))
		data["trait_info"] += "It is [get_trait(TRAIT_BIOLUM_COLOUR)  ? "<font color='[get_trait(TRAIT_BIOLUM_COLOUR)]'>bio-luminescent</font>" : "bio-luminescent"]."

	if(get_trait(TRAIT_PRODUCES_POWER))
		data["trait_info"] += "The fruit will function as a battery if prepared appropriately."

	if(get_trait(TRAIT_STINGS))
		data["trait_info"] += "The fruit is covered in stinging spines."

	if(get_trait(TRAIT_JUICY) == 1)
		data["trait_info"] += "The fruit is soft-skinned and juicy."
	else if(get_trait(TRAIT_JUICY) == 2)
		data["trait_info"] += "The fruit is excessively juicy."

	if(get_trait(TRAIT_EXPLOSIVE))
		data["trait_info"] += "The fruit is internally unstable."

	if(get_trait(TRAIT_TELEPORTING))
		data["trait_info"] += "The fruit is temporal/spatially unstable."

	if(get_trait(TRAIT_SPORING))
		data["trait_info"] += "It occasionally releases reagent carrying spores into the atmosphere."
	
	if(exude_gasses && exude_gasses.len)
		for(var/gas in exude_gasses)
			var/amount = ""
			if (exude_gasses[gas] > 7)
				amount = "large amounts of "
			else if (exude_gasses[gas] < 5)
				amount = "small amounts of "
			data["trait_info"] += "It will release [amount][gas_data.name[gas]] into the environment."

	if(consume_gasses && consume_gasses.len)
		for(var/gas in consume_gasses)
			var/amount = ""
			if (consume_gasses[gas] > 7)
				amount = "large amounts of "
			else if (consume_gasses[gas] < 5)
				amount = "small amounts of "
			data["trait_info"] += "It will consume [amount][gas_data.name[gas]] from the environment."

	return data
