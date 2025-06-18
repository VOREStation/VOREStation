#define RPM_FRICTION 15
#define IDEAL_RPM 600
#define RPM_OKAY_RANGE 200
#define RPM_MAX_DELTA RPM_FRICTION * 4
#define RPM_MIN 0
#define RPM_MAX 1200
#define COMPLETION_DELTA_MODIFIER 4 // Make it go faster, 25 ticks at peak efficiency
#define RADIATION_INJECTION_AMT 5
#define RADIATION_MAX 50
#define TARGET_RADIATION 20
#define RADIATION_OK_RANGE 7.5
#define RADIATION_LOSS 1
#define HEAT_GAIN 0.5
#define HEAT_FAILURE_THRESHOLD 10
#define HEAT_MAX 12
#define COOLANT_USAGE 2
#define COOLANT_MAX 100

/obj/machinery/radiocarbon_spectrometer
	name = "radiocarbon spectrometer"
	desc = "A specialised, complex scanner for gleaning information on all manner of small things."
	anchored = TRUE
	density = TRUE
	icon = 'icons/obj/virology_vr.dmi' //VOREStation Edit
	icon_state = "analyser"

	use_power = USE_POWER_IDLE
	idle_power_usage = 20
	active_power_usage = 300

	flags = OPENCONTAINER

	var/scanning = 0
	var/report_num = 0
	var/obj/item/scanned_item
	var/last_scan_data = "No scans on record."
	var/scan_progress = 0

	// Mechanics:tm:
	var/scanner_rpm = 0
	var/scanner_rpm_delta = 0

	var/radiation = 0

	var/heat = 0

/obj/machinery/radiocarbon_spectrometer/Initialize(mapload)
	. = ..()
	create_reagents(COOLANT_MAX)

/obj/machinery/radiocarbon_spectrometer/attackby(obj/I, mob/user)
	if(scanning)
		to_chat(user, span_warning("You can't do that while [src] is scanning!"))
		return

	if(istype(I, /obj/item/reagent_containers/glass))
		var/obj/item/reagent_containers/glass/G = I
		if(!G.is_open_container())
			return
		var/choice = tgui_alert(user, "What do you want to do with the container?","Radiometric Scanner",list("Add water","Empty water","Scan container"))
		if(!choice)
			return
		if(choice == "Add water")
			if(!G.reagents.has_reagent(REAGENT_ID_WATER))
				to_chat(user, span_danger("No water found in beaker."))
				return
			var/trans = G.reagents.trans_id_to(src, REAGENT_ID_WATER, G.amount_per_transfer_from_this)
			to_chat(user, span_info("You transfer [trans ? trans : 0]u of water into [src]."))
			return
		else if(choice == "Empty water")
			var/amount_transferred = min(G.reagents.maximum_volume - G.reagents.total_volume, reagents.total_volume)
			var/trans = reagents.trans_to(G, amount_transferred)
			to_chat(user, span_info("You remove [trans ? trans : 0]u of water from [src]."))
			return
		// fall through

	if(scanned_item)
		to_chat(user, span_warning("[src] already has \a [scanned_item] inside!"))
		return

	if(!user.unEquip(I, target = src))
		return

	scanned_item = I
	to_chat(user, span_notice("You put [I] into [src]."))

/obj/machinery/radiocarbon_spectrometer/attack_hand(mob/user)
	tgui_interact(user)

/obj/machinery/radiocarbon_spectrometer/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "XenoarchSpectrometer", name)
		ui.open()

/obj/machinery/radiocarbon_spectrometer/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()

	// this is the data which will be sent to the ui
	data["scanned_item"] = (scanned_item ? scanned_item.name : "")
	data["scanned_item_desc"] = (scanned_item ? (scanned_item.desc ? scanned_item.desc : "No information on record.") : "")
	data["last_scan_data"] = last_scan_data
	data["scanning"] = scanning
	data["scan_progress"] = scan_progress

	// Mechanics
	data["scanner_rpm"] = scanner_rpm
	data["scanner_rpm_delta"] = scanner_rpm_delta
	data["radiation"] = radiation
	data["heat"] = heat
	data["coolant"] = reagents.total_volume

	return data

/obj/machinery/radiocarbon_spectrometer/tgui_static_data(mob/user)
	var/list/data = ..()

	data["IDEAL_RPM"] = IDEAL_RPM
	data["RPM_MAX_DELTA"] = RPM_MAX_DELTA
	data["RPM_MAX"] = RPM_MAX

	data["TARGET_RADIATION"] = TARGET_RADIATION
	data["RADIATION_MAX"] = RADIATION_MAX

	data["HEAT_FAILURE_THRESHOLD"] = HEAT_FAILURE_THRESHOLD
	data["HEAT_MAX"] = HEAT_MAX
	data["COOLANT_MAX"] = COOLANT_MAX

	return data

/obj/machinery/radiocarbon_spectrometer/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	add_fingerprint(ui.user)
	switch(action)
		if("scanItem")
			if(scanning)
				stop_scanning()
				return
			if(!scanned_item)
				to_chat(ui.user, span_warning("Insert an item to scan."))
				return
			start_scanning()
			to_chat(ui.user, span_notice("Scan initiated."))
			return TRUE

		if("ejectItem")
			if(scanned_item)
				scanned_item.forceMove(loc)
				scanned_item = null
			return TRUE

		if("set_scanner_rpm_delta")
			scanner_rpm_delta = CLAMP(params["delta"], -RPM_MAX_DELTA, RPM_MAX_DELTA)
			return TRUE

		if("inject_radiation")
			if(!scanning)
				radiation = 0
				return
			radiation = CLAMP(radiation + RADIATION_INJECTION_AMT, 0, RADIATION_MAX)
			return TRUE

/obj/machinery/radiocarbon_spectrometer/process()
	if(!scanning)
		return

	if(!scanned_item || scanned_item.loc != src)
		scanned_item = null
		stop_scanning()
		return

	if(scan_progress >= 100)
		complete_scan()
		return

	// Mechanics time
	/************** HEAT *************/
	if(heat > HEAT_FAILURE_THRESHOLD)
		visible_message(span_danger("[icon2html(src, viewers(src))] buzzes unhappily. It has failed mid-scan!"), range = 2)
		stop_scanning()
		return
	var/heat_gain = reagents.remove_reagent(REAGENT_ID_WATER, COOLANT_USAGE) ? -1 : HEAT_GAIN
	heat += heat_gain
	heat = CLAMP(heat, 0, HEAT_MAX)

	/************** RPM **************/
	// Scanner slows down over time
	scanner_rpm -= RPM_FRICTION + rand(0, RPM_FRICTION) // randomly add more friction
	// Motor speeds it up
	scanner_rpm += scanner_rpm_delta
	// Cap
	scanner_rpm = CLAMP(scanner_rpm, RPM_MIN, RPM_MAX)

	// Factor RPM into completion
	var/diff_from_ideal_rpm = abs(scanner_rpm - IDEAL_RPM)
	var/rpm_factor = CLAMP01(1 - (diff_from_ideal_rpm / RPM_OKAY_RANGE))

	/************** RADIATION *************/
	radiation -= RADIATION_LOSS
	radiation = CLAMP(radiation, 0, RADIATION_MAX)
	var/diff_from_ideal_radiation = abs(radiation - TARGET_RADIATION)
	var/radiation_factor = CLAMP01(1 - (diff_from_ideal_radiation / RADIATION_OK_RANGE))

	/************** COMPLETION *************/
	var/completion_delta = rpm_factor + radiation_factor
	scan_progress = CLAMP(scan_progress + (completion_delta * COMPLETION_DELTA_MODIFIER), 0, 100)

/obj/machinery/radiocarbon_spectrometer/proc/start_scanning()
	icon_state = "analyser_processing"
	scanning = TRUE
	scan_progress = 0
	scanner_rpm_delta = 0
	scanner_rpm = 0
	radiation = 0
	heat = 0

/obj/machinery/radiocarbon_spectrometer/proc/stop_scanning()
	icon_state = "analyser"
	scanning = FALSE
	scan_progress = 0
	scanner_rpm_delta = 0
	scanner_rpm = 0
	radiation = 0
	heat = 0

/obj/machinery/radiocarbon_spectrometer/proc/complete_scan()
	stop_scanning()
	visible_message(span_notice("[icon2html(src, viewers(src))] makes an insistent chime."), range = 2)

	if(!scanned_item)
		return

		//create report
	var/obj/item/paper/P = new(src)
	P.name = "[src] report #[++report_num]: [scanned_item.name]"
	P.stamped = list(/obj/item/stamp)
	P.add_overlay("paper_stamped")

	//work out data
	var/data = " - Mundane object: [scanned_item.desc ? scanned_item.desc : "No information on record."]<br>"
	var/datum/geosample/G
	switch(scanned_item.type)
		if(/obj/item/ore)
			var/obj/item/ore/O = scanned_item
			if(O.geologic_data)
				G = O.geologic_data

		if(/obj/item/rocksliver)
			var/obj/item/rocksliver/O = scanned_item
			if(O.geological_data)
				G = O.geological_data

		if(/obj/item/archaeological_find)
			data = " - Mundane object (archaic xenos origins)<br>"

			var/obj/item/archaeological_find/A = scanned_item
			if(A.talking_atom)
				data = " - Exhibits properties consistent with sonic reproduction and audio capture technologies.<br>"

	var/anom_found = 0
	if(G)
		data = " - Spectometric analysis on mineral sample has determined type [finds_as_strings[responsive_carriers.Find(G.source_mineral)]]<br>"
		if(G.age_billion > 0)
			data += " - Radiometric dating shows age of [G.age_billion].[G.age_million] billion years<br>"
		else if(G.age_million > 0)
			data += " - Radiometric dating shows age of [G.age_million].[G.age_thousand] million years<br>"
		else
			data += " - Radiometric dating shows age of [G.age_thousand * 1000 + G.age] years<br>"
		data += " - Chromatographic analysis shows the following materials present:<br>"
		for(var/carrier in G.find_presence)
			if(G.find_presence[carrier])
				var/index = responsive_carriers.Find(carrier)
				if(index > 0 && index <= finds_as_strings.len)
					data += "	> [100 * G.find_presence[carrier]]% [finds_as_strings[index]]<br>"

		if(G.artifact_id && G.artifact_distance >= 0)
			anom_found = 1
			data += " - Hyperspectral imaging reveals exotic energy wavelength detected with ID: [G.artifact_id]<br>"
			data += " - Fourier transform analysis on anomalous energy absorption indicates energy source located inside emission radius of [G.artifact_distance]m<br>"

	if(!anom_found)
		data += " - No anomalous data<br>"

	P.info = span_bold("[src] analysis report #[report_num]") + "<br>"
	P.info += span_bold("Scanned item:") + " [scanned_item.name]<br><br>" + data
	last_scan_data = P.info

	P.forceMove(loc)
	scanned_item.forceMove(loc)
	scanned_item = null

#undef RPM_FRICTION
#undef IDEAL_RPM
#undef RPM_OKAY_RANGE
#undef RPM_MAX_DELTA
#undef RPM_MIN
#undef RPM_MAX
#undef COMPLETION_DELTA_MODIFIER
#undef RADIATION_INJECTION_AMT
#undef RADIATION_MAX
#undef TARGET_RADIATION
#undef RADIATION_OK_RANGE
#undef RADIATION_LOSS
#undef HEAT_GAIN
#undef HEAT_FAILURE_THRESHOLD
#undef HEAT_MAX
#undef COOLANT_USAGE
#undef COOLANT_MAX
