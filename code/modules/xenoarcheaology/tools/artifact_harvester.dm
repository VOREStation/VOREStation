/obj/machinery/artifact_harvester
	name = "Exotic Particle Harvester"
	icon = 'icons/obj/virology_vr.dmi'
	icon_state = "incubator"	//incubator_on
	anchored = TRUE
	density = TRUE
	idle_power_usage = 50
	active_power_usage = 750
	use_power = USE_POWER_IDLE
	var/harvesting = 0
	var/harvesting_speed = 0
	var/obj/item/anobattery/inserted_battery
	var/obj/cur_artifact
	var/obj/machinery/artifact_scanpad/owned_scanner = null
	var/last_process = 0
	bubble_icon = "science"
	circuit = /obj/item/circuitboard/artifact_harvester

/// If you want it to load smoothly, set it's dir to wherever the scanpad is!
/obj/machinery/artifact_harvester/Initialize(mapload)
	. = ..()
	owned_scanner = locate(/obj/machinery/artifact_scanpad) in get_step(src, dir)
	if(!owned_scanner)
		owned_scanner = locate(/obj/machinery/artifact_scanpad) in orange(1, src)
	default_apply_parts()
	update_icon()

/obj/machinery/artifact_harvester/RefreshParts(var/limited = 0)
	harvesting_speed = 0
	// Rating goes from 1 to 5 and this bad boy has 5 caps. Let's say we want a normal one to charge a battery in 100 seconds.
	// Every machine process happens every 2 seconds. So, we should have it do 5 charge every second. So 10 charge a process.
	// Tier 3 is commonly availabe. Tier 4/5 is much harder to get.
	// Applying a straight rating * X resultes in either being too strong early or too weak late. So we do a switch depending on rating.
	// This means for a base 500 battery: Tier 1 takes 100 seconds, tier 2 takes 40 seconds, tier 3 takes 20 seconds, tier 4 takes 4 seconds, tier 5 takes 1 second.
	// Tier 4 and 5 may seem overkill, but when you get to the REALLY strong batteries, you'll want them.
	for(var/obj/item/stock_parts/P in component_parts)
		if(istype(P, /obj/item/stock_parts/capacitor))
			switch(P.rating)
				if(1)
					harvesting_speed += 2
				if(2)
					harvesting_speed += 5
				if(3)
					harvesting_speed += 10
				if(4)
					harvesting_speed += 50
				if(5)
					harvesting_speed += 100

/obj/machinery/artifact_harvester/attackby(var/obj/I as obj, var/mob/user as mob)
	if(istype(I,/obj/item/anobattery))
		if(!inserted_battery)
			to_chat(user, span_blue("You insert [I] into [src]."))
			user.drop_item()
			I.loc = src
			src.inserted_battery = I
			SStgui.update_uis(src)
		else
			to_chat(user, span_red("There is already a battery in [src]."))
	if(default_part_replacement(user, I))
		return
	if(!inserted_battery)
		if(default_deconstruction_screwdriver(user, I))
			return
		if(default_deconstruction_crowbar(user, I))
			return
	else
		return..()

/obj/machinery/artifact_harvester/attack_hand(var/mob/user as mob)
	if(..())
		return 1
	add_fingerprint(user)
	if(stat & (NOPOWER|BROKEN))
		return
	tgui_interact(user)

/obj/machinery/artifact_harvester/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "XenoarchArtifactHarvester", name)
		ui.open()

/obj/machinery/artifact_harvester/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()

	data["info"] = list(
		"no_scanner" = TRUE,
	)
	if(owned_scanner)
		data["info"] = list(
			"no_scanner" = FALSE,
			"harvesting" = harvesting,
			"inserted_battery" = list(),
		)
		if(inserted_battery)
			data["info"]["inserted_battery"] = list(
				"name" = inserted_battery.name,
				"stored_charge" = inserted_battery.stored_charge,
				"capacity" = inserted_battery.capacity,
				"artifact_id" = null
			)
			if(inserted_battery.battery_effect)
				data["info"]["inserted_battery"]["artifact_id"] = inserted_battery.battery_effect.artifact_id || "???"
			else
				data["info"]["inserted_battery"]["artifact_id"] = "N/A"
	return data

/obj/machinery/artifact_harvester/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	add_fingerprint(ui.user)

	switch(action)
		if("harvest")
			harvest(ui.user)
			return TRUE

		if("stopharvest")
			if(harvesting)
				if(harvesting < 0 && inserted_battery.battery_effect && inserted_battery.battery_effect.activated)
					inserted_battery.battery_effect.ToggleActivate()
				harvesting = 0
				cur_artifact.anchored = FALSE
				cur_artifact.being_used = 0
				cur_artifact = null
				atom_say("Energy harvesting interrupted.")
				icon_state = "incubator"
			return TRUE

		if("ejectbattery")
			if(inserted_battery)
				inserted_battery.forceMove(loc)
				inserted_battery = null
			return TRUE

		if("drainbattery")
			if(inserted_battery)
				if(inserted_battery.battery_effect && inserted_battery.stored_charge > 0)
					if(tgui_alert(ui.user, "This action will dump all charge, safety gear is recommended before proceeding","Warning",list("Continue","Cancel")) == "Continue")
						if(!inserted_battery.battery_effect.activated)
							inserted_battery.battery_effect.ToggleActivate(1)
						harvesting = -1
						update_use_power(USE_POWER_ACTIVE)
						icon_state = "incubator_on"
						atom_say("Warning, battery charge dump commencing.")
				else
					atom_say("Cannot dump energy. Battery is drained of charge already.")
			else
				atom_say("Cannot dump energy. No battery inserted.")
			return TRUE


/obj/machinery/artifact_harvester/proc/harvest(mob/user)
	if(!inserted_battery)
		atom_say("Cannot harvest. No battery inserted.")
		return
	if(inserted_battery.stored_charge >= inserted_battery.capacity)
		atom_say("Cannot harvest. Battery is full.")
		return

	//locate artifact on analysis pad
	cur_artifact = null
	var/articount = 0
	var/obj/analysed
	for(var/obj/A in get_turf(owned_scanner))
		analysed = A
		if(A.is_anomalous())
			articount++

	if(articount <= 0)
		atom_say("Cannot harvest. No noteworthy energy signature isolated.")
		return

	if(analysed && analysed.being_used)
		atom_say("Cannot harvest. Source already being harvested.")
		return

	if(articount > 1)
		atom_say("Cannot harvest. Too many artifacts on the pad.")
		return

	if(analysed)
		cur_artifact = analysed

		var/list/active_effects //This will be populated when we see if it has the artifact component or the artifact_master var

		var/datum/component/artifact_master/ScannedMaster = analysed.GetComponent(/datum/component/artifact_master)
		if(istype(ScannedMaster))
			active_effects = ScannedMaster.get_all_effects()
		else
			atom_say("Cannot harvest. No energy emitting from source.")
			return
		var/effects_to_show = active_effects
		for(var/datum/artifact_effect/selected_effect in effects_to_show) //We check to see if we're harvestable. If not, remove it from the list.
			if(selected_effect.harvestable == FALSE)
				effects_to_show -= selected_effect

		if(!active_effects.len)
			atom_say("Cannot harvest. No harvestable energy emitting from source.")
			return

		var/artifact_selection = tgui_input_list(user, "Which effect do you wish to harvest?", "Effect Selection", effects_to_show)
		var/datum/artifact_effect/selected_effect
		if(artifact_selection && (artifact_selection in effects_to_show))
			selected_effect = artifact_selection
		else
			atom_say("No selection made. Shutting down harvester.")
			return

		//see if we can clear out an old effect
		//delete it when the ids match to account for duplicate ids having different effects
		if(inserted_battery.battery_effect && inserted_battery.stored_charge <= 0)
			qdel(inserted_battery.battery_effect)
			inserted_battery.battery_effect = null

		//
		var/datum/artifact_effect/source_effect

		//if we already have charge in the battery, we can only recharge it from the source artifact
		if(inserted_battery.stored_charge > 0)
			var/battery_matches_primary_id = 0
			if(inserted_battery.battery_effect && inserted_battery.battery_effect.artifact_id == ScannedMaster.artifact_id)
				battery_matches_primary_id = 1
			if(battery_matches_primary_id && selected_effect)
				//we're good to recharge the primary effect!
				source_effect = selected_effect

			if(!source_effect)
				atom_say("Cannot harvest. Battery is charged with a different energy signature.")
		else
			source_effect = selected_effect

		if(source_effect)
			harvesting = 1
			update_use_power(USE_POWER_ACTIVE)
			cur_artifact.anchored = TRUE
			cur_artifact.being_used = 1
			icon_state = "incubator_on"
			atom_say("Beginning energy harvesting.")

			//duplicate the artifact's effect datum
			if(!inserted_battery.battery_effect)
				var/effecttype = source_effect.type
				var/datum/artifact_effect/E = new effecttype(inserted_battery)

				//duplicate it's unique settings
				for(var/varname in list("chargelevelmax","artifact_id","effect","effectrange","trigger"))
					E.vars[varname] = source_effect.vars[varname]

				//copy the new datum into the battery
				inserted_battery.battery_effect = E
				inserted_battery.stored_charge = 0

/obj/machinery/artifact_harvester/process()
	if(harvesting == 0)
		return
	if(stat & (NOPOWER|BROKEN))
		return

	if(harvesting > 0)
		//charge at 33% consumption rate
		inserted_battery.stored_charge += harvesting_speed

		//check if we've finished
		if(inserted_battery.stored_charge >= inserted_battery.capacity)
			update_use_power(USE_POWER_IDLE)
			harvesting = 0
			cur_artifact.anchored = FALSE
			cur_artifact.being_used = 0
			cur_artifact = null
			src.visible_message(span_bold("[name]") + " states, \"Battery is full.\"")
			icon_state = "incubator"

	else if(harvesting < 0)
		//dump some charge
		inserted_battery.stored_charge -= harvesting_speed

		//do the effect
		if(inserted_battery.battery_effect)
			inserted_battery.battery_effect.process()

			//if the effect works by touch, activate it on anyone viewing the console
			if(inserted_battery.battery_effect.effect == EFFECT_TOUCH)
				var/list/nearby = viewers(1, src)
				for(var/mob/M in nearby)
					if(M.machine == src)
						inserted_battery.battery_effect.DoEffectTouch(M)

		//if there's no charge left, finish
		if(inserted_battery.stored_charge <= 0)
			update_use_power(USE_POWER_IDLE)
			inserted_battery.stored_charge = 0
			harvesting = 0
			if(inserted_battery.battery_effect && inserted_battery.battery_effect.activated)
				inserted_battery.battery_effect.ToggleActivate()
			src.visible_message(span_bold("[name]") + " states, \"Battery dump completed.\"")
			icon_state = "incubator"
