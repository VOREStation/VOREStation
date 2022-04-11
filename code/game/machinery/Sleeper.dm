/obj/machinery/sleep_console
	name = "sleeper console"
	desc = "A control panel to operate a linked sleeper with."
	icon = 'icons/obj/Cryogenic2_vr.dmi' //VOREStation Edit - Better icon.
	icon_state = "sleeperconsole"
	var/obj/machinery/sleeper/sleeper
	anchored = TRUE //About time someone fixed this.
	density = TRUE //VOREStation Edit - Big console
	unacidable = TRUE
	dir = 8
	use_power = USE_POWER_IDLE
	idle_power_usage = 40
	interact_offline = 1
	circuit = /obj/item/weapon/circuitboard/sleeper_console
	clicksound = 'sound/machines/buttonbeep.ogg'
	clickvol = 30

/obj/machinery/sleep_console/Initialize()
	findsleeper()
	return ..()

/obj/machinery/sleep_console/Destroy()
	if(sleeper)
		sleeper.console = null
	return ..()

/obj/machinery/sleep_console/proc/findsleeper()
	var/obj/machinery/sleeper/sleepernew = null
	for(var/direction in GLOB.cardinal) // Loop through every direction
		sleepernew = locate(/obj/machinery/sleeper, get_step(src, direction)) // Try to find a scanner in that direction
		if(sleepernew)
			sleeper = sleepernew
			sleepernew.console = src
			break //VOREStation Edit


/obj/machinery/sleep_console/attack_ai(var/mob/user)
	return attack_hand(user)

/obj/machinery/sleep_console/attack_hand(var/mob/user)
	if(..())
		return 1

	if(!sleeper)
		findsleeper()
		if(!sleeper)
			to_chat(user, "<span class='notice'>Sleeper not found!</span>")
			return

	if(panel_open)
		to_chat(user, "<span class='notice'>Close the maintenance panel first.</span>")
		return

	if(sleeper)
		return tgui_interact(user)

/obj/machinery/sleep_console/attackby(var/obj/item/I, var/mob/user)
	if(computer_deconstruction_screwdriver(user, I))
		return
	else
		return attack_hand(user)

/obj/machinery/sleep_console/power_change()
	..()
	if(stat & (NOPOWER|BROKEN))
		icon_state = "sleeperconsole-p"
	else
		icon_state = initial(icon_state)

/obj/machinery/sleep_console/tgui_interact(mob/user, datum/tgui/ui = null)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Sleeper", "Sleeper")
		ui.open()

/obj/machinery/sleep_console/tgui_data(mob/user)
	if(sleeper)
		return sleeper.tgui_data(user)
	return null

/obj/machinery/sleep_console/tgui_act(action, params, datum/tgui/ui, datum/tgui_state/state)
	if(sleeper)
		return sleeper.tgui_act(action, params, ui, state)
	return ..()

/obj/machinery/sleeper
	name = "sleeper"
	desc = "A stasis pod with built-in injectors, a dialysis machine, and a limited health scanner."
	icon = 'icons/obj/Cryogenic2_vr.dmi' //VOREStation Edit - Better icons
	icon_state = "sleeper_0"
	density = TRUE
	anchored = TRUE
	unacidable = TRUE
	circuit = /obj/item/weapon/circuitboard/sleeper
	var/mob/living/carbon/human/occupant = null
	var/list/available_chemicals = list()
	var/list/base_chemicals = list("inaprovaline" = "Inaprovaline", "paracetamol" = "Paracetamol", "anti_toxin" = "Dylovene", "dexalin" = "Dexalin")
	var/amounts = list(5, 10)
	var/obj/item/weapon/reagent_containers/glass/beaker = null
	var/filtering = 0
	var/pumping = 0
	// Currently never changes. On Paradise, max_chem and min_health are based on the matter bins in the sleeper.
	var/max_chem = 20
	var/initial_bin_rating = 1
	var/min_health = -101
	var/obj/machinery/sleep_console/console
	var/stasis_level = 0 //Every 'this' life ticks are applied to the mob (when life_ticks%stasis_level == 1)
	var/stasis_choices = list("Complete (1%)" = 100, "Deep (10%)" = 10, "Moderate (20%)" = 5, "Light (50%)" = 2, "None (100%)" = 0)
	var/controls_inside = FALSE
	var/auto_eject_dead = FALSE

	use_power = USE_POWER_IDLE
	idle_power_usage = 15
	active_power_usage = 200 //builtin health analyzer, dialysis machine, injectors.

/obj/machinery/sleeper/Initialize()
	. = ..()
	beaker = new /obj/item/weapon/reagent_containers/glass/beaker/large(src)
	default_apply_parts()
	update_icon()

/obj/machinery/sleeper/Destroy()
	if(console)
		console.sleeper = null
	return ..()

/obj/machinery/sleeper/RefreshParts(var/limited = 0)
	var/man_rating = 0
	var/cap_rating = 0

	available_chemicals.Cut()
	available_chemicals = base_chemicals.Copy()

	for(var/obj/item/weapon/stock_parts/P in component_parts)
		if(istype(P, /obj/item/weapon/stock_parts/capacitor))
			cap_rating += P.rating

	cap_rating = max(1, round(cap_rating / 2))

	update_idle_power_usage(initial(idle_power_usage) / cap_rating)
	update_active_power_usage(initial(active_power_usage) / cap_rating)

	if(!limited)
		for(var/obj/item/weapon/stock_parts/P in component_parts)
			if(istype(P, /obj/item/weapon/stock_parts/manipulator))
				man_rating += P.rating - 1

		var/list/new_chemicals = list()

		if(man_rating >= 4) // Alien tech.
			var/reag_ID = pickweight(list(
				"healing_nanites" = 10,
				"shredding_nanites" = 5,
				"irradiated_nanites" = 5,
				"neurophage_nanites" = 2)
				)
			new_chemicals[reag_ID] = "Nanite"
		if(man_rating >= 3) // Anomalous tech.
			new_chemicals["immunosuprizine"] = "Immunosuprizine"
		if(man_rating >= 2) // Tier 3.
			new_chemicals["spaceacillin"] = "Spaceacillin"
		if(man_rating >= 1) // Tier 2.
			new_chemicals["leporazine"] = "Leporazine"

		if(new_chemicals.len)
			available_chemicals += new_chemicals
		return

/obj/machinery/sleeper/attack_hand(var/mob/user)
	if(!controls_inside)
		return FALSE
	
	if(user == occupant)
		tgui_interact(user)

/obj/machinery/sleeper/tgui_interact(mob/user, datum/tgui/ui = null)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Sleeper", "Sleeper")
		ui.open()

/obj/machinery/sleeper/tgui_data(mob/user)
	var/data[0]
	data["amounts"] = amounts
	data["hasOccupant"] = occupant ? 1 : 0
	var/occupantData[0]
	// var/crisis = 0
	if(occupant)
		occupantData["name"] = occupant.name
		occupantData["stat"] = occupant.stat
		occupantData["health"] = occupant.health
		occupantData["maxHealth"] = occupant.maxHealth
		occupantData["minHealth"] = config.health_threshold_dead
		occupantData["bruteLoss"] = occupant.getBruteLoss()
		occupantData["oxyLoss"] = occupant.getOxyLoss()
		occupantData["toxLoss"] = occupant.getToxLoss()
		occupantData["fireLoss"] = occupant.getFireLoss()
		occupantData["paralysis"] = occupant.paralysis
		occupantData["hasBlood"] = 0
		occupantData["bodyTemperature"] = occupant.bodytemperature
		occupantData["maxTemp"] = 1000 // If you get a burning vox armalis into the sleeper, congratulations
		// Because we can put simple_animals in here, we need to do something tricky to get things working nice
		occupantData["temperatureSuitability"] = 0 // 0 is the baseline
		if(ishuman(occupant) && occupant.species)
			// I wanna do something where the bar gets bluer as the temperature gets lower
			// For now, I'll just use the standard format for the temperature status
			var/datum/species/sp = occupant.species
			if(occupant.bodytemperature < sp.cold_level_3)
				occupantData["temperatureSuitability"] = -3
			else if(occupant.bodytemperature < sp.cold_level_2)
				occupantData["temperatureSuitability"] = -2
			else if(occupant.bodytemperature < sp.cold_level_1)
				occupantData["temperatureSuitability"] = -1
			else if(occupant.bodytemperature > sp.heat_level_3)
				occupantData["temperatureSuitability"] = 3
			else if(occupant.bodytemperature > sp.heat_level_2)
				occupantData["temperatureSuitability"] = 2
			else if(occupant.bodytemperature > sp.heat_level_1)
				occupantData["temperatureSuitability"] = 1
		else if(isanimal(occupant))
			var/mob/living/simple_mob/silly = occupant
			if(silly.bodytemperature < silly.minbodytemp)
				occupantData["temperatureSuitability"] = -3
			else if(silly.bodytemperature > silly.maxbodytemp)
				occupantData["temperatureSuitability"] = 3
		// Blast you, imperial measurement system
		occupantData["btCelsius"] = occupant.bodytemperature - T0C
		occupantData["btFaren"] = ((occupant.bodytemperature - T0C) * (9.0/5.0))+ 32


		// crisis = (occupant.health < min_health)
		// I'm not sure WHY you'd want to put a simple_animal in a sleeper, but precedent is precedent
		// Runtime is aptly named, isn't she?
		if(ishuman(occupant) && !(NO_BLOOD in occupant.species.flags) && occupant.vessel)
			occupantData["pulse"] = occupant.get_pulse(GETPULSE_TOOL)
			occupantData["hasBlood"] = 1
			var/blood_volume = round(occupant.vessel.get_reagent_amount("blood"))
			occupantData["bloodLevel"] = blood_volume
			occupantData["bloodMax"] = occupant.species.blood_volume
			occupantData["bloodPercent"] = round(100*(blood_volume/occupant.species.blood_volume), 0.01) //copy pasta ends here

			occupantData["bloodType"] = occupant.dna.b_type

	data["occupant"] = occupantData
	data["maxchem"] = max_chem
	data["minhealth"] = min_health
	data["dialysis"] = filtering
	data["stomachpumping"] = pumping
	data["auto_eject_dead"] = auto_eject_dead
	if(beaker)
		data["isBeakerLoaded"] = 1
		if(beaker.reagents)
			data["beakerMaxSpace"] = beaker.reagents.maximum_volume
			data["beakerFreeSpace"] = beaker.reagents.get_free_space()
		else
			data["beakerMaxSpace"] = 0
			data["beakerFreeSpace"] = 0
	else
		data["isBeakerLoaded"] = FALSE


	var/stasis_level_name = "Error!"
	for(var/N in stasis_choices)
		if(stasis_choices[N] == stasis_level)
			stasis_level_name = N
			break
	data["stasis"] = stasis_level_name

	var/chemicals[0]
	for(var/re in available_chemicals)
		var/datum/reagent/temp = SSchemistry.chemical_reagents[re]
		if(temp)
			var/reagent_amount = 0
			var/pretty_amount
			var/injectable = occupant ? 1 : 0
			var/overdosing = 0
			var/caution = 0 // To make things clear that you're coming close to an overdose
			// if(crisis && !(temp.id in emergency_chems))
				// injectable = 0

			if(occupant && occupant.reagents)
				reagent_amount = occupant.reagents.get_reagent_amount(temp.id)
				// If they're mashing the highest concentration, they get one warning
				if(temp.overdose && reagent_amount + 10 > (temp.overdose * occupant?.species.chemOD_threshold))
					caution = 1
				if(temp.overdose && reagent_amount > (temp.overdose * occupant?.species.chemOD_threshold))
					overdosing = 1

			pretty_amount = round(reagent_amount, 0.05)

			chemicals.Add(list(list("title" = temp.name, "id" = temp.id, "commands" = list("chemical" = temp.id), "occ_amount" = reagent_amount, "pretty_amount" = pretty_amount, "injectable" = injectable, "overdosing" = overdosing, "od_warning" = caution)))
	data["chemicals"] = chemicals
	return data


/obj/machinery/sleeper/tgui_act(action, params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE
	if(!controls_inside && usr == occupant)
		return
	if(panel_open)
		to_chat(usr, "<span class='notice'>Close the maintenance panel first.</span>")
		return

	. = TRUE
	switch(action)
		if("chemical")
			if(!occupant)
				return
			if(occupant.stat == DEAD)
				var/datum/gender/G = gender_datums[occupant.get_visible_gender()]
				to_chat(usr, "<span class='danger'>This person has no life to preserve anymore. Take [G.him] to a department capable of reanimating [G.him].</span>")
				return
			var/chemical = params["chemid"]
			var/amount = text2num(params["amount"])
			if(!length(chemical) || amount <= 0)
				return
			if(occupant.health > min_health) //|| (chemical in emergency_chems))
				inject_chemical(usr, chemical, amount)
			else
				to_chat(usr, "<span class='danger'>This person is not in good enough condition for sleepers to be effective! Use another means of treatment, such as cryogenics!</span>")
		if("removebeaker")
			remove_beaker()
		if("togglefilter")
			toggle_filter()
		if("togglepump")
			toggle_pump()
		if("ejectify")
			go_out()
		if("changestasis")
			var/new_stasis = tgui_input_list(usr, "Levels deeper than 50% stasis level will render the patient unconscious.","Stasis Level", stasis_choices)
			if(new_stasis)
				stasis_level = stasis_choices[new_stasis]
		if("auto_eject_dead_on")
			auto_eject_dead = TRUE
		if("auto_eject_dead_off")
			auto_eject_dead = FALSE
		else
			return FALSE
	add_fingerprint(usr)

/obj/machinery/sleeper/process()
	if(stat & (NOPOWER|BROKEN))
		return
	if(occupant)
		if(auto_eject_dead && occupant.stat == DEAD)
			playsound(loc, 'sound/machines/buzz-sigh.ogg', 40)
			go_out()
			return
		occupant.Stasis(stasis_level)

		if(filtering > 0)
			if(beaker)
				if(beaker.reagents.total_volume < beaker.reagents.maximum_volume)
					var/pumped = 0
					for(var/datum/reagent/x in occupant.reagents.reagent_list)
						occupant.reagents.trans_to_obj(beaker, 3)
						pumped++
					if(ishuman(occupant))
						occupant.vessel.trans_to_obj(beaker, pumped + 1)
			else
				toggle_filter()

		if(pumping > 0)
			if(beaker)
				if(beaker.reagents.total_volume < beaker.reagents.maximum_volume)
					for(var/datum/reagent/x in occupant.ingested.reagent_list)
						occupant.ingested.trans_to_obj(beaker, 3)
			else
				toggle_pump()

/obj/machinery/sleeper/update_icon()
	icon_state = "sleeper_[occupant ? "1" : "0"]"

/obj/machinery/sleeper/attackby(var/obj/item/I, var/mob/user)
	add_fingerprint(user)
	if(istype(I, /obj/item/weapon/grab))
		var/obj/item/weapon/grab/G = I
		if(G.affecting)
			go_in(G.affecting, user)
		return
	if(istype(I, /obj/item/weapon/reagent_containers/glass))
		if(!beaker)
			beaker = I
			user.drop_item()
			I.loc = src
			user.visible_message("<b>\The [user]</b> adds \a [I] to \the [src].", "<span class='notice'>You add \a [I] to \the [src].</span>")
		else
			to_chat(user, "<span class='warning'>\The [src] has a beaker already.</span>")
		return
	if(!occupant)
		if(default_deconstruction_screwdriver(user, I))
			return
		if(default_deconstruction_crowbar(user, I))
			return
		if(default_part_replacement(user, I))
			return

/obj/machinery/sleeper/verb/move_eject()
	set name = "Eject occupant"
	set category = "Object"
	set src in oview(1)
	if(usr == occupant)
		switch(usr.stat)
			if(DEAD)
				return
			if(UNCONSCIOUS)
				to_chat(usr, "<span class='notice'>You struggle through the haze to hit the eject button. This will take a couple of minutes...</span>")
				if(do_after(usr, 2 MINUTES, src))
					go_out()
			if(CONSCIOUS)
				go_out()
	else
		if(usr.stat != CONSCIOUS)
			return
		go_out()
	add_fingerprint(usr)

/obj/machinery/sleeper/MouseDrop_T(var/mob/target, var/mob/user)
	if(user.stat || user.lying || !Adjacent(user) || !target.Adjacent(user) || !ishuman(target))
		return
	go_in(target, user)

/obj/machinery/sleeper/relaymove(var/mob/user)
	..()
	go_out()

/obj/machinery/sleeper/emp_act(var/severity)
	if(filtering)
		toggle_filter()

	if(pumping)
		toggle_pump()

	if(stat & (BROKEN|NOPOWER))
		..(severity)
		return

	if(occupant)
		go_out()

	..(severity)
/obj/machinery/sleeper/proc/toggle_filter()
	if(!occupant || !beaker)
		filtering = 0
		return
	filtering = !filtering

/obj/machinery/sleeper/proc/toggle_pump()
	if(!occupant || !beaker)
		pumping = 0
		return
	pumping = !pumping

/obj/machinery/sleeper/proc/go_in(var/mob/M, var/mob/user)
	if(!M)
		return
	if(stat & (BROKEN|NOPOWER))
		return
	if(occupant)
		to_chat(user, "<span class='warning'>\The [src] is already occupied.</span>")
		return
	if(!ishuman(M))
		to_chat(user, "<span class='warning'>\The [src] is not designed for that organism!</span>")
		return
	if(M == user)
		visible_message("\The [user] starts climbing into \the [src].")
	else
		visible_message("\The [user] starts putting [M] into \the [src].")

	if(do_after(user, 20))
		if(occupant)
			to_chat(user, "<span class='warning'>\The [src] is already occupied.</span>")
			return
		M.stop_pulling()
		if(M.client)
			M.client.perspective = EYE_PERSPECTIVE
			M.client.eye = src
		M.loc = src
		update_use_power(USE_POWER_ACTIVE)
		occupant = M
		update_icon()

/obj/machinery/sleeper/proc/go_out()
	if(!occupant || occupant.loc != src)
		occupant = null // JUST IN CASE
		return
	if(occupant.client)
		occupant.client.eye = occupant.client.mob
		occupant.client.perspective = MOB_PERSPECTIVE
	occupant.Stasis(0)
	occupant.loc = src.loc
	occupant = null
	for(var/atom/movable/A in src) // In case an object was dropped inside or something
		if(A == beaker || A == circuit)
			continue
		if(A in component_parts)
			continue
		A.loc = src.loc
	update_use_power(USE_POWER_IDLE)
	update_icon()
	toggle_filter()
	toggle_pump()

/obj/machinery/sleeper/proc/remove_beaker()
	if(beaker)
		beaker.loc = src.loc
		beaker = null
		toggle_filter()

/obj/machinery/sleeper/proc/inject_chemical(var/mob/living/user, var/chemical, var/amount)
	if(stat & (BROKEN|NOPOWER))
		return
	if(!(amount in amounts))
		return

	if(occupant && occupant.reagents)
		if(occupant.reagents.get_reagent_amount(chemical) + amount <= max_chem)
			use_power(amount * CHEM_SYNTH_ENERGY)
			occupant.reagents.add_reagent(chemical, amount)
			to_chat(user, "Occupant now has [occupant.reagents.get_reagent_amount(chemical)] units of [available_chemicals[chemical]] in their bloodstream.")
		else
			to_chat(user, "The subject has too many chemicals in their bloodstream.")
	else
		to_chat(user, "There's no suitable occupant in \the [src].")

//Survival/Stasis sleepers
/obj/machinery/sleeper/survival_pod
	desc = "A limited functionality sleeper, all it can do is put patients into stasis. It lacks the medication and configuration of the larger units."
	icon_state = "sleeper"
	stasis_level = 100 //Just one setting

/obj/machinery/sleeper/survival_pod/Initialize()
	. = ..()
	RefreshParts(1)
