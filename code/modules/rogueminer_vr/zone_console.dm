//////////////////////////////
// The zone control console, fluffed ingame as
// a scanner console for the asteroid belt
//////////////////////////////

/obj/machinery/computer/roguezones
	name = "asteroid belt scanning computer"
	desc = "Used to monitor the nearby asteroid belt and detect new areas."
	icon_keyboard = "tech_key"
	icon_screen = "request"
	light_color = "#315ab4"
	use_power = USE_POWER_IDLE
	idle_power_usage = 250
	active_power_usage = 500
	circuit = /obj/item/circuitboard/roguezones

	var/debug = 0
	var/debug_scans = 0
	var/scanning = 0
	var/legacy_zone = 0 //Disable scanning and whatnot.
	var/obj/machinery/computer/shuttle_control/belter/shuttle_control

/obj/machinery/computer/roguezones/Initialize()
	. = ..()
	shuttle_control = locate(/obj/machinery/computer/shuttle_control/belter)
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/computer/roguezones/LateInitialize()
	if(!rm_controller)
		rm_controller = new /datum/controller/rogue()

/obj/machinery/computer/roguezones/attack_ai(mob/user as mob)
	return attack_hand(user)

/obj/machinery/computer/roguezones/attack_hand(mob/user as mob)
	add_fingerprint(user)
	if(stat & (BROKEN|NOPOWER))
		return
	tgui_interact(user)

/obj/machinery/computer/roguezones/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "RogueZones", name)
		ui.open()

/obj/machinery/computer/roguezones/tgui_data(mob/user)
	var/chargePercent = min(100, ((((world.time - rm_controller.last_scan) / 10) / 60) / rm_controller.scan_wait) * 100)
	var/curZoneOccupied = rm_controller.current_zone ? rm_controller.current_zone.is_occupied() : 0

	var/list/data = ..()
	data["timeout_percent"] = chargePercent
	data["diffstep"] = rm_controller.diffstep
	data["difficulty"] = rm_controller.diffstep_strs[rm_controller.diffstep]
	data["occupied"] = curZoneOccupied
	data["scanning"] = scanning
	data["updated"] = world.time - rm_controller.last_scan < 200 //Very recently scanned (20 seconds)
	data["debug"] = debug

	if(!shuttle_control)
		data["shuttle_location"] = "Unknown"
		data["shuttle_at_station"] = 0
	else if(shuttle_control.z in using_map.belter_docked_z)
		data["shuttle_location"] = "Landed"
		data["shuttle_at_station"] = 1
	else if(shuttle_control.z == using_map.belter_transit_z)
		data["shuttle_location"] = "In-transit"
		data["shuttle_at_station"] = 0
	else if(shuttle_control.z == using_map.belter_belt_z)
		data["shuttle_location"] = "Belt"
		data["shuttle_at_station"] = 0

	var/can_scan = 0
	if(chargePercent >= 100) //Keep having weird problems with these in one 'if' statement
		if(shuttle_control && (shuttle_control.z in using_map.belter_docked_z)) //Even though I put them all in parens to avoid OoO problems...
			if(!curZoneOccupied) //Not sure why.
				if(!scanning)
					can_scan = 1

	if(debug_scans) can_scan = 1
	data["scan_ready"] = can_scan

	// Permit emergency recall of the shuttle if its stranded in a zone with just dead people.
	data["can_recall_shuttle"] = (shuttle_control && (shuttle_control.z in using_map.belter_belt_z) && !curZoneOccupied)
	return data

/obj/machinery/computer/roguezones/tgui_act(action, list/params, datum/tgui/ui)
	if(..())
		return TRUE
	switch(action)
		if("scan_for_new")
			scan_for_new_zone()
			. = TRUE
		if("recall_shuttle")
			failsafe_shuttle_recall(ui.user)
			. = TRUE

	add_fingerprint(ui.user)

/obj/machinery/computer/roguezones/proc/scan_for_new_zone()
	if(scanning)
		return

	//Set some kinda scanning var to pause UI input on console
	rm_controller.last_scan = world.time
	scanning = 1
	sleep(60)

	//Break the shuttle temporarily.
	shuttle_control.shuttle_tag = null

	//Build and get a new zone.
	var/datum/rogue/zonemaster/ZM_target = rm_controller.prepare_new_zone()

	//Update shuttle destination.
	var/datum/shuttle/autodock/ferry/S = SSshuttles.shuttles["Belter"]
	S.landmark_offsite = ZM_target.myshuttle_landmark
	S.next_location = S.get_location_waypoint(!S.location)

	//Re-enable shuttle.
	shuttle_control.shuttle_tag = "Belter"

	//Update rm_previous
	rm_controller.previous_zone = rm_controller.current_zone

	//Update rm_current
	rm_controller.current_zone = ZM_target

	//Unset scanning
	scanning = 0

	return


/obj/machinery/computer/roguezones/proc/failsafe_shuttle_recall(mob/user)
	if(!shuttle_control)
		return // Shuttle computer has been destroyed
	if (!(shuttle_control.z in using_map.belter_belt_z))
		return // Usable only when shuttle is away
	if(rm_controller.current_zone && rm_controller.current_zone.is_occupied())
		return // Not usable if shuttle is in occupied zone
	// Okay do it
	var/datum/shuttle/autodock/ferry/S = SSshuttles.shuttles["Belter"]
	S.launch(user)

/obj/item/circuitboard/roguezones
	name = T_BOARD("asteroid belt scanning computer")
	build_path = /obj/machinery/computer/roguezones
	origin_tech = list(TECH_DATA = 3, TECH_BLUESPACE = 1)

/obj/item/paper/rogueminer
	name = "R-38 Scanner Console Guide"
	info = {"<h4>Getting Started</h4>
	Congratulations, your station has purchased the R-38 industrial asteroid belt scanner!<br>
	Using the R-38 is almost as simple as brain surgery! Simply press the scan button to scan for a new mineral-rich asteroid belt location!<br>
	<b>That's all there is to it!</b><br>
	Notice, scan may cause extreme brain damage to those present in asteroid belt, so scanning will be disabled in that case.<br>
	Existing minerals and living creatures interfere with the scans, so the more minerals extracted and creatures 'removed'/made-not-living in the belt, the more accurate future scans will be.<br>
	<h4>Traveling to the belt</h4>
	When a new zone has been scanned, your station's shuttle destination will be updated to direct it to the newly discovered area automatically.<br>
	You can then travel to the new area to mine in that location.<br>
	<br> "} + span_small("This technology produced under license from Thinktronic Systems, LTD.")
