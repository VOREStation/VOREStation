/datum/pai_software
	// Name for the software. This is used as the button text when buying or opening/toggling the software
	var/name = "pAI software module"
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

/datum/pai_software/proc/toggle(mob/living/silicon/pai/user)
	return

/datum/pai_software/proc/is_active(mob/living/silicon/pai/user)
	return 0

/datum/pai_software/tgui_state(mob/user)
	return GLOB.tgui_always_state

/datum/pai_software/tgui_status(mob/user)
	if(!istype(user, /mob/living/silicon/pai))
		return STATUS_CLOSE
	return ..()

/datum/pai_software/directives
	name = "Directives"
	ram_cost = 0
	id = "directives"
	toggle = 0
	default = 1

/datum/pai_software/directives/tgui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "pAIDirectives", name, parent_ui)
		ui.open()

/datum/pai_software/directives/tgui_data(mob/living/silicon/pai/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = list()

	data["master"] = user.master
	data["dna"] = user.master_dna
	data["prime"] = user.pai_law0
	data["supplemental"] = user.pai_laws

	return data

/datum/pai_software/directives/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	var/mob/living/silicon/pai/P = usr
	if(!istype(P))
		return TRUE
	if(..())
		return TRUE

	if(action == "getdna")
		var/mob/living/M = P.loc

		var/count = 0
		// Find the carrier
		while(!istype(M, /mob/living))
			if(!M || !M.loc || count > 6)
				//For a runtime where M ends up in nullspace (similar to bluespace but less colourful)
				to_chat(src, "You are not being carried by anyone!")
				return 0
			M = M.loc
			count++

		// Check the carrier
		var/datum/gender/TM = gender_datums[M.get_visible_gender()]
		var/answer = tgui_alert(M, "[P] is requesting a DNA sample from you. Will you allow it to confirm your identity?", "[P] Check DNA", list("Yes", "No"))
		if(answer == "Yes")
			var/turf/T = get_turf(P.loc)
			for (var/mob/v in viewers(T))
				v.show_message("<span class='notice'>[M] presses [TM.his] thumb against [P].</span>", 3, "<span class='notice'>[P] makes a sharp clicking sound as it extracts DNA material from [M].</span>", 2)
			var/datum/dna/dna = M.dna
			to_chat(P, "<font color = red><h3>[M]'s UE string : [dna.unique_enzymes]</h3></font>")
			if(dna.unique_enzymes == P.master_dna)
				to_chat(P, "<b>DNA is a match to stored Master DNA.</b>")
			else
				to_chat(P, "<b>DNA does not match stored Master DNA.</b>")
		else
			to_chat(P, "[M] does not seem like [TM.he] is going to provide a DNA sample willingly.")
		return TRUE

/datum/pai_software/radio_config
	name = "Radio Configuration"
	ram_cost = 0
	id = "radio"
	toggle = 0
	default = 1

/datum/pai_software/radio_config/tgui_interact(mob/living/silicon/pai/user, datum/tgui/ui, datum/tgui/parent_ui)
	return user.radio.tgui_interact(user, parent_ui = parent_ui)

/datum/pai_software/crew_manifest
	name = "Crew Manifest"
	ram_cost = 0
	id = "manifest"
	toggle = 0
	default = 1		//Comes with the communicator already, also why not

/datum/pai_software/crew_manifest/tgui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CrewManifest", name, parent_ui)
		ui.open()

/datum/pai_software/crew_manifest/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()
	if(data_core)
		data_core.get_manifest_list()
	data["manifest"] = PDA_Manifest
	return data

/datum/pai_software/messenger
	name = "Digital Messenger"
	ram_cost = 0
	id = "messenger"
	toggle = 0
	default = 1		//Can already be accessed through verbs, and also why not

/datum/pai_software/messenger/tgui_interact(mob/living/silicon/pai/user, datum/tgui/ui, datum/tgui/parent_ui)
	return user.pda.tgui_interact(user, parent_ui = parent_ui)

/datum/pai_software/med_records
	name = "Medical Records"
	ram_cost = 15
	id = "med_records"
	toggle = 0

/datum/pai_software/med_records/tgui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "pAIMedrecords", name, parent_ui)
		ui.open()

/datum/pai_software/med_records/tgui_data(mob/living/silicon/pai/user, datum/tgui/ui, datum/tgui_state/state)
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

/datum/pai_software/med_records/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	. = ..()
	var/mob/living/silicon/pai/P = usr
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

/datum/pai_software/sec_records
	name = "Security Records"
	ram_cost = 15
	id = "sec_records"
	toggle = 0

/datum/pai_software/sec_records/tgui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "pAISecrecords", name, parent_ui)
		ui.open()

/datum/pai_software/sec_records/tgui_data(mob/living/silicon/pai/user, datum/tgui/ui, datum/tgui_state/state)
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

/datum/pai_software/sec_records/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	. = ..()
	var/mob/living/silicon/pai/P = usr
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

/datum/pai_software/door_jack
	name = "Door Jack"
	ram_cost = 30
	id = "door_jack"
	toggle = 0

/datum/pai_software/door_jack/tgui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "pAIDoorjack", "Door Jack", parent_ui)
		ui.open()

/datum/pai_software/door_jack/tgui_data(mob/living/silicon/pai/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()

	data["cable"] = user.cable != null
	data["machine"] = user.cable && (user.cable.machine != null)
	data["inprogress"] = user.hackdoor != null
	data["progress_a"] = round(user.hackprogress / 10)
	data["progress_b"] = user.hackprogress % 10
	data["aborted"] = user.hack_aborted

	return data

/datum/pai_software/door_jack/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	var/mob/living/silicon/pai/P = usr
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

/mob/living/silicon/pai/proc/hackloop()
	var/turf/T = get_turf(src)
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
	while(hackprogress < 1000)
		if(cable && cable.machine == D && cable.machine == hackdoor && get_dist(src, hackdoor) <= 1)
			hackprogress = min(hackprogress+rand(1, 20), 1000)
		else
			hack_aborted = 1
			hackprogress = 0
			hackdoor = null
			return
		if(hackprogress >= 1000)
			hackprogress = 0
			D.open()
			cable.machine = null
			return
		sleep(10)			// Update every second

/datum/pai_software/atmosphere_sensor
	name = "Atmosphere Sensor"
	ram_cost = 5
	id = "atmos_sense"
	toggle = 0

/datum/pai_software/atmosphere_sensor/tgui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "pAIAtmos", name, parent_ui)
		ui.open()

/datum/pai_software/atmosphere_sensor/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
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

/datum/pai_software/pai_hud
	name = "AR HUD"
	ram_cost = 30
	id = "ar_hud"

/datum/pai_software/pai_hud/toggle(mob/living/silicon/pai/user)
	user.paiHUD = !user.paiHUD
	user.plane_holder.set_vis(VIS_CH_ID,user.paiHUD)
	user.plane_holder.set_vis(VIS_CH_WANTED,user.paiHUD)
	user.plane_holder.set_vis(VIS_CH_IMPTRACK,user.paiHUD)
	user.plane_holder.set_vis(VIS_CH_IMPCHEM,user.paiHUD)
	user.plane_holder.set_vis(VIS_CH_STATUS_R,user.paiHUD)
	user.plane_holder.set_vis(VIS_CH_HEALTH_VR,user.paiHUD)
	user.plane_holder.set_vis(VIS_CH_BACKUP,user.paiHUD) //backup stuff from silicon_vr is here now
	user.plane_holder.set_vis(VIS_AUGMENTED,user.paiHUD)

/datum/pai_software/pai_hud/is_active(mob/living/silicon/pai/user)
	return user.paiHUD

/datum/pai_software/translator
	name = "Universal Translator"
	ram_cost = 35
	id = "translator"

/datum/pai_software/translator/toggle(mob/living/silicon/pai/user)
	// 	Sol Common, Tradeband, Terminus and Gutter are added with New() and are therefore the current default, always active languages
	user.translator_on = !user.translator_on
	if(user.translator_on)
		user.add_language(LANGUAGE_UNATHI)
		user.add_language(LANGUAGE_SIIK)
		user.add_language(LANGUAGE_AKHANI)
		user.add_language(LANGUAGE_SKRELLIAN)
		user.add_language(LANGUAGE_ZADDAT)
		user.add_language(LANGUAGE_SCHECHI)
		user.add_language(LANGUAGE_DRUDAKAR)
		user.add_language(LANGUAGE_BIRDSONG)
		user.add_language(LANGUAGE_SAGARU)
		user.add_language(LANGUAGE_CANILUNZT)
		user.add_language(LANGUAGE_ECUREUILIAN)
		user.add_language(LANGUAGE_DAEMON)
		user.add_language(LANGUAGE_ENOCHIAN)
		user.add_language(LANGUAGE_VESPINAE)
		user.add_language(LANGUAGE_SPACER)
		user.add_language(LANGUAGE_TAVAN)
		user.add_language(LANGUAGE_ECHOSONG)
		user.add_language(LANGUAGE_ROOTLOCAL)
		user.add_language(LANGUAGE_VOX)
		user.add_language(LANGUAGE_MINBUS)
		user.add_language(LANGUAGE_ALAI)
		user.add_language(LANGUAGE_PROMETHEAN)
		user.add_language(LANGUAGE_GIBBERISH)
		user.add_language("Mouse")
		user.add_language("Animal")
		user.add_language("Teppi")
	else
		user.remove_language(LANGUAGE_UNATHI)
		user.remove_language(LANGUAGE_SIIK)
		user.remove_language(LANGUAGE_AKHANI)
		user.remove_language(LANGUAGE_SKRELLIAN)
		user.remove_language(LANGUAGE_ZADDAT)
		user.remove_language(LANGUAGE_SCHECHI)
		user.remove_language(LANGUAGE_DRUDAKAR)
		user.remove_language(LANGUAGE_BIRDSONG)
		user.remove_language(LANGUAGE_SAGARU)
		user.remove_language(LANGUAGE_CANILUNZT)
		user.remove_language(LANGUAGE_ECUREUILIAN)
		user.remove_language(LANGUAGE_DAEMON)
		user.remove_language(LANGUAGE_ENOCHIAN)
		user.remove_language(LANGUAGE_VESPINAE)
		user.remove_language(LANGUAGE_SPACER)
		user.remove_language(LANGUAGE_TAVAN)
		user.remove_language(LANGUAGE_ECHOSONG)
		user.remove_language(LANGUAGE_ROOTLOCAL)
		user.remove_language(LANGUAGE_VOX)
		user.remove_language(LANGUAGE_MINBUS)
		user.remove_language(LANGUAGE_ALAI)
		user.remove_language(LANGUAGE_PROMETHEAN)
		user.remove_language(LANGUAGE_GIBBERISH)
		user.remove_language("Mouse")
		user.remove_language("Animal")
		user.remove_language("Teppi")

/datum/pai_software/translator/is_active(mob/living/silicon/pai/user)
	return user.translator_on

/datum/pai_software/signaller
	name = "Remote Signaler"
	ram_cost = 5
	id = "signaller"
	toggle = 0

/datum/pai_software/signaller/tgui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Signaler", "Signaler", parent_ui)
		ui.open()

/datum/pai_software/signaller/tgui_data(mob/living/silicon/pai/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()

	var/obj/item/radio/integrated/signal/R = user.sradio

	data["frequency"] = R.frequency
	data["minFrequency"] = RADIO_LOW_FREQ
	data["maxFrequency"] = RADIO_HIGH_FREQ
	data["code"] = R.code

	return data

/datum/pai_software/signaller/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	var/mob/living/silicon/pai/user = usr
	if(istype(user))
		var/obj/item/radio/integrated/signal/R = user.sradio

		switch(action)
			if("signal")
				spawn(0)
					R.send_signal("ACTIVATE")
				for(var/mob/O in hearers(1, R.loc))
					O.show_message("\icon[R][bicon(R)] *beep* *beep*", 3, "*beep* *beep*", 2)
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
