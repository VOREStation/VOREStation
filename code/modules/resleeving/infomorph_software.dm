/datum/infomorph_software
	// Name for the software. This is used as the button text when buying or opening/toggling the software
	var/name = "infomorph software module"
	// RAM cost; pAIs start with 100 RAM, spending it on programs
	var/ram_cost = 0
	// ID for the software. This must be unique
	var/id = ""
	// Whether this software is a toggle or not
	// Toggled software should override toggle() and is_active()
	// Non-toggled software should override on_ui_interact() and Topic()
	var/toggle = 1
	// Whether pAIs should automatically receive this module at no cost
	var/default = 0

/datum/infomorph_software/tgui_state(mob/user)
	return GLOB.tgui_always_state

/datum/infomorph_software/tgui_status(mob/user)
	if(!istype(user, /mob/living/silicon/infomorph))
		return STATUS_CLOSE
	return ..()

/datum/infomorph_software/proc/toggle(mob/living/silicon/infomorph/user)
	return

/datum/infomorph_software/proc/is_active(mob/living/silicon/infomorph/user)
	return 0

/datum/infomorph_software/crew_manifest
	name = "Crew Manifest"
	ram_cost = 5
	id = "manifest"
	toggle = 0

/datum/infomorph_software/crew_manifest/tgui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CrewManifest", name, parent_ui)
		ui.open()

/datum/infomorph_software/crew_manifest/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()
	if(data_core)
		data_core.get_manifest_list()
	data["manifest"] = PDA_Manifest
	return data

/datum/infomorph_software/med_records
	name = "Medical Records"
	ram_cost = 15
	id = "med_records"
	toggle = 0

/datum/infomorph_software/med_records/tgui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "pAIMedrecords", name, parent_ui)
		ui.open()

/datum/infomorph_software/med_records/tgui_data(mob/living/silicon/infomorph/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()
	
	var/list/records = list()
	for(var/datum/data/record/general in sortRecord(data_core.general))
		var/list/record = list()
		record["name"] = general.fields["name"]
		record["ref"] = "\ref[general]"
		records.Add(list(record))

	data["records"] = records

	var/datum/data/record/G = user.medicalActive1
	var/datum/data/record/M = user.medicalActive2
	data["general"] = G ? G.fields : null
	data["medical"] = M ? M.fields : null
	data["could_not_find"] = user.medical_cannotfind

	return data

/datum/infomorph_software/med_records/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	. = ..()
	var/mob/living/silicon/infomorph/P = usr
	if(!istype(P))
		return

	if(action == "select")
		var/datum/data/record/record = locate(params["select"])
		if(record)
			var/datum/data/record/R = record
			var/datum/data/record/M = null
			if (!( data_core.general.Find(R) ))
				P.medical_cannotfind = 1
			else
				P.medical_cannotfind = 0
				for(var/datum/data/record/E in data_core.medical)
					if ((E.fields["name"] == R.fields["name"] || E.fields["id"] == R.fields["id"]))
						M = E
				P.medicalActive1 = R
				P.medicalActive2 = M
		else
			P.medical_cannotfind = 1
		return 1

/datum/infomorph_software/sec_records
	name = "Security Records"
	ram_cost = 15
	id = "sec_records"
	toggle = 0

/datum/infomorph_software/sec_records/tgui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "pAISecrecords", name, parent_ui)
		ui.open()

/datum/infomorph_software/sec_records/tgui_data(mob/living/silicon/infomorph/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()
	
	var/list/records = list()
	for(var/datum/data/record/general in sortRecord(data_core.general))
		var/list/record = list()
		record["name"] = general.fields["name"]
		record["ref"] = "\ref[general]"
		records.Add(list(record))

	data["records"] = records

	var/datum/data/record/G = user.securityActive1
	var/datum/data/record/S = user.securityActive2
	data["general"] = G ? G.fields : null
	data["security"] = S ? S.fields : null
	data["could_not_find"] = user.security_cannotfind

	return data

/datum/infomorph_software/sec_records/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	. = ..()
	var/mob/living/silicon/infomorph/P = usr
	if(!istype(P))
		return

	if(action == "select")
		var/datum/data/record/record = locate(params["select"])
		if(record)
			var/datum/data/record/R = record
			var/datum/data/record/S = null
			if (!( data_core.general.Find(R) ))
				P.securityActive1 = null
				P.securityActive2 = null
				P.security_cannotfind = 1
			else
				P.security_cannotfind = 0
				for(var/datum/data/record/E in data_core.security)
					if ((E.fields["name"] == R.fields["name"] || E.fields["id"] == R.fields["id"]))
						S = E
				P.securityActive1 = R
				P.securityActive2 = S
		else
			P.securityActive1 = null
			P.securityActive2 = null
			P.security_cannotfind = 1
		return TRUE

/datum/infomorph_software/door_jack
	name = "Door Jack"
	ram_cost = 30
	id = "door_jack"
	toggle = 0

/datum/infomorph_software/door_jack/tgui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "pAIDoorjack", "Door Jack", parent_ui)
		ui.open()

/datum/infomorph_software/door_jack/tgui_data(mob/living/silicon/infomorph/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()

	data["cable"] = user.cable != null
	data["machine"] = user.cable && (user.cable.machine != null)
	data["inprogress"] = user.hackdoor != null
	data["progress_a"] = round(user.hackprogress / 10)
	data["progress_b"] = user.hackprogress % 10
	data["aborted"] = user.hack_aborted

	return data

/datum/infomorph_software/door_jack/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	var/mob/living/silicon/infomorph/P = usr
	if(!istype(P) || ..())
		return TRUE

	switch(action)
		if("jack")
			if(P.cable && P.cable.machine)
				P.hackdoor = P.cable.machine
				P.hackloop()
			return 1
		if("cancel")
			P.hackdoor = null
			return 1
		if("cable")
			var/turf/T = get_turf(P)
			P.hack_aborted = 0
			P.cable = new /obj/item/weapon/pai_cable(T)
			for(var/mob/M in viewers(T))
				M.show_message("<span class='warning'>A port on [P] opens to reveal [P.cable], which promptly falls to the floor.</span>", 3,
								"<span class='warning'>You hear the soft click of something light and hard falling to the ground.</span>", 2)
			return 1

/mob/living/silicon/infomorph/proc/hackloop()
	var/turf/T = get_turf(src)
	if(prob(20))
		for(var/mob/living/silicon/ai/AI in player_list)
			if(T.loc)
				to_chat(AI, "<font color = red><b>Network Alert: Brute-force encryption crack in progress in [T.loc].</b></font>")
			else
				to_chat(AI, "<font color = red><b>Network Alert: Brute-force encryption crack in progress. Unable to pinpoint location.</b></font>")

	var/obj/machinery/door/D = cable.machine
	if(!istype(D))
		hack_aborted = 1
		hackprogress = 0
		cable.machine = null
		hackdoor = null
		return
	while(hackprogress < 100)

		//Still working
		if(cable && cable.machine == D && cable.machine == hackdoor && get_dist(src, hackdoor) <= 1)
			hackprogress = min(hackprogress+rand(1, 3), 100)

		//Something went wrong!
		else
			hack_aborted = 1
			hackprogress = 0

		//Success!
		if(hackprogress >= 100)
			hackprogress = 0
			D.open()
		sleep(10)			// Update every second

	T.visible_message("<span class='warning'>\The [cable] whips back into \the [src] from \the [hackdoor].</span>")
	qdel(cable)
	hackdoor = null

/datum/infomorph_software/atmosphere_sensor
	name = "Atmosphere Sensor"
	ram_cost = 5
	id = "atmos_sense"
	toggle = 0

/datum/infomorph_software/atmosphere_sensor/tgui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "pAIAtmos", name, parent_ui)
		ui.open()

/datum/infomorph_software/atmosphere_sensor/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()

	var/list/results = list()
	var/turf/T = get_turf(user)
	if(!isnull(T))
		var/datum/gas_mixture/environment = T.return_air()
		var/pressure = environment.return_pressure()
		var/total_moles = environment.total_moles
		if (total_moles)
			var/o2_level = environment.gas["oxygen"]/total_moles
			var/n2_level = environment.gas["nitrogen"]/total_moles
			var/co2_level = environment.gas["carbon_dioxide"]/total_moles
			var/phoron_level = environment.gas["phoron"]/total_moles
			var/unknown_level =  1-(o2_level+n2_level+co2_level+phoron_level)

			// entry is what the element is describing
			// Type identifies which unit or other special characters to use
			// Val is the information reported
			// Bad_high/_low are the values outside of which the entry reports as dangerous
			// Poor_high/_low are the values outside of which the entry reports as unideal
			// Values were extracted from the template itself
			results = list(
						list("entry" = "Pressure", "units" = "kPa", "val" = "[round(pressure,0.1)]", "bad_high" = 120, "poor_high" = 110, "poor_low" = 95, "bad_low" = 80),
						list("entry" = "Temperature", "units" = "&deg;C", "val" = "[round(environment.temperature-T0C,0.1)]", "bad_high" = 35, "poor_high" = 25, "poor_low" = 15, "bad_low" = 5),
						list("entry" = "Oxygen", "units" = "kPa", "val" = "[round(o2_level*100,0.1)]", "bad_high" = 140, "poor_high" = 135, "poor_low" = 19, "bad_low" = 17),
						list("entry" = "Nitrogen", "units" = "kPa", "val" = "[round(n2_level*100,0.1)]", "bad_high" = 105, "poor_high" = 85, "poor_low" = 50, "bad_low" = 40),
						list("entry" = "Carbon Dioxide", "units" = "kPa", "val" = "[round(co2_level*100,0.1)]", "bad_high" = 10, "poor_high" = 5, "poor_low" = 0, "bad_low" = 0),
						list("entry" = "Phoron", "units" = "kPa", "val" = "[round(phoron_level*100,0.01)]", "bad_high" = 0.5, "poor_high" = 0, "poor_low" = 0, "bad_low" = 0),
						list("entry" = "Other", "units" = "kPa", "val" = "[round(unknown_level, 0.01)]", "bad_high" = 1, "poor_high" = 0.5, "poor_low" = 0, "bad_low" = 0)
						)

	if(isnull(results))
		results = list(list("entry" = "pressure", "units" = "kPa", "val" = "0", "bad_high" = 120, "poor_high" = 110, "poor_low" = 95, "bad_low" = 80))

	data["aircontents"] = results

	return data

/datum/infomorph_software/ar_hud
	name = "AR HUD"
	ram_cost = 15
	id = "ar_hud"

/datum/infomorph_software/ar_hud/toggle(mob/living/silicon/infomorph/user)
	user.arHUD = !user.arHUD
	if(user.plane_holder)
		user.plane_holder.set_vis(VIS_CH_ID,user.arHUD)
		user.plane_holder.set_vis(VIS_CH_HEALTH_VR,user.arHUD)

/datum/infomorph_software/ar_hud/is_active(mob/living/silicon/infomorph/user)
	return user.arHUD

/datum/infomorph_software/translator
	name = "Universal Translator"
	ram_cost = 15
	id = "translator"

/datum/infomorph_software/translator/toggle(mob/living/silicon/infomorph/user)
	user.translator.attack_self(user)

/datum/infomorph_software/translator/is_active(mob/living/silicon/infomorph/user)
	return user.translator.listening


/datum/infomorph_software/signaller
	name = "Remote Signaler"
	ram_cost = 5
	id = "signaller"
	toggle = 0

/datum/infomorph_software/signaller/tgui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Signaler", "Signaler", parent_ui)
		ui.open()

/datum/infomorph_software/signaller/tgui_data(mob/living/silicon/infomorph/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()
	
	var/obj/item/radio/integrated/signal/R = user.sradio

	data["frequency"] = R.frequency
	data["minFrequency"] = RADIO_LOW_FREQ
	data["maxFrequency"] = RADIO_HIGH_FREQ
	data["code"] = R.code

	return data

/datum/infomorph_software/signaller/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	var/mob/living/silicon/infomorph/user = usr
	if(istype(user))
		var/obj/item/radio/integrated/signal/R = user.sradio

		switch(action)
			if("signal")
				spawn(0)
					R.send_signal("ACTIVATE")
				for(var/mob/O in hearers(1, R.loc))
					O.show_message("[bicon(R)] *beep* *beep*", 3, "*beep* *beep*", 2)
			if("freq")
				var/frequency = unformat_frequency(params["freq"])
				frequency = sanitize_frequency(frequency, RADIO_LOW_FREQ, RADIO_HIGH_FREQ)
				R.set_frequency(frequency)
				. = TRUE
			if("code")
				R.code = clamp(round(text2num(params["code"])), 1, 100)
				. = TRUE
			if("reset")
				if(params["reset"] == "freq")
					R.set_frequency(initial(R.frequency))
				else
					R.code = initial(R.code)
				. = TRUE
