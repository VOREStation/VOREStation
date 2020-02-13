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

	proc/on_ui_interact(mob/living/silicon/infomorph/user, datum/nanoui/ui=null, force_open=1)
		return

	proc/toggle(mob/living/silicon/infomorph/user)
		return

	proc/is_active(mob/living/silicon/infomorph/user)
		return 0

/datum/infomorph_software/crew_manifest
	name = "Crew Manifest"
	ram_cost = 15
	id = "manifest"
	toggle = 0

	on_ui_interact(mob/living/silicon/infomorph/user, datum/nanoui/ui=null, force_open=1)
		data_core.get_manifest_list()

		var/data[0]
		// This is dumb, but NanoUI breaks if it has no data to send
		data["manifest"] = PDA_Manifest

		ui = SSnanoui.try_update_ui(user, user, id, ui, data, force_open)
		if(!ui)
			// Don't copy-paste this unless you're making a pAI software module!
			ui = new(user, user, id, "pai_manifest.tmpl", "Crew Manifest", 450, 600)
			ui.set_initial_data(data)
			ui.open()
			ui.set_auto_update(1)

/datum/infomorph_software/med_records
	name = "Medical Records"
	ram_cost = 15
	id = "med_records"
	toggle = 0

	on_ui_interact(mob/living/silicon/infomorph/user, datum/nanoui/ui=null, force_open=1)
		var/data[0]

		var/records[0]
		for(var/datum/data/record/general in sortRecord(data_core.general))
			var/record[0]
			record["name"] = general.fields["name"]
			record["ref"] = "\ref[general]"
			records[++records.len] = record

		data["records"] = records

		var/datum/data/record/G = user.medicalActive1
		var/datum/data/record/M = user.medicalActive2
		data["general"] = G ? G.fields : null
		data["medical"] = M ? M.fields : null
		data["could_not_find"] = user.medical_cannotfind

		ui = SSnanoui.try_update_ui(user, user, id, ui, data, force_open)
		if(!ui)
			// Don't copy-paste this unless you're making a pAI software module!
			ui = new(user, user, id, "pai_medrecords.tmpl", "Medical Records", 450, 600)
			ui.set_initial_data(data)
			ui.open()
			ui.set_auto_update(1)

	Topic(href, href_list)
		var/mob/living/silicon/infomorph/P = usr
		if(!istype(P)) return

		if(href_list["select"])
			var/datum/data/record/record = locate(href_list["select"])
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

	on_ui_interact(mob/living/silicon/infomorph/user, datum/nanoui/ui=null, force_open=1)
		var/data[0]

		var/records[0]
		for(var/datum/data/record/general in sortRecord(data_core.general))
			var/record[0]
			record["name"] = general.fields["name"]
			record["ref"] = "\ref[general]"
			records[++records.len] = record

		data["records"] = records

		var/datum/data/record/G = user.securityActive1
		var/datum/data/record/S = user.securityActive2
		data["general"] = G ? G.fields : null
		data["security"] = S ? S.fields : null
		data["could_not_find"] = user.security_cannotfind

		ui = SSnanoui.try_update_ui(user, user, id, ui, data, force_open)
		if(!ui)
			// Don't copy-paste this unless you're making a pAI software module!
			ui = new(user, user, id, "pai_secrecords.tmpl", "Security Records", 450, 600)
			ui.set_initial_data(data)
			ui.open()
			ui.set_auto_update(1)

	Topic(href, href_list)
		var/mob/living/silicon/infomorph/P = usr
		if(!istype(P)) return

		if(href_list["select"])
			var/datum/data/record/record = locate(href_list["select"])
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
			return 1

/datum/infomorph_software/door_jack
	name = "Door Jack"
	ram_cost = 30
	id = "door_jack"
	toggle = 0

	on_ui_interact(mob/living/silicon/infomorph/user, datum/nanoui/ui=null, force_open=1)
		var/data[0]

		data["cable"] = user.cable != null
		data["machine"] = user.cable && (user.cable.machine != null)
		data["inprogress"] = user.hackdoor != null
		data["progress_a"] = round(user.hackprogress)
		data["progress_b"] = user.hackprogress % 10
		data["aborted"] = user.hack_aborted

		ui = SSnanoui.try_update_ui(user, user, id, ui, data, force_open)
		if(!ui)
			// Don't copy-paste this unless you're making a pAI software module!
			ui = new(user, user, id, "pai_doorjack.tmpl", "Door Jack", 300, 150)
			ui.set_initial_data(data)
			ui.open()
			ui.set_auto_update(1)

	Topic(href, href_list)
		var/mob/living/silicon/infomorph/P = usr
		if(!istype(P)) return

		if(href_list["jack"])
			if(P.cable && P.cable.machine)
				P.hackdoor = P.cable.machine
				P.hackloop()
			return 1
		else if(href_list["cancel"])
			P.hackdoor = null
			return 1
		else if(href_list["cable"])
			var/turf/T = get_turf(P)
			P.hack_aborted = 0
			P.cable = new /obj/item/weapon/pai_cable(T)
			if(ishuman(P.card.loc))
				var/mob/living/carbon/human/H = P.card.loc
				H.put_in_any_hand_if_possible(P.cable)
			T.visible_message("<span class='warning'>A port on \the [P] opens to reveal \the [P.cable].</span>")
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
	ram_cost = 15
	id = "atmos_sense"
	toggle = 0

	on_ui_interact(mob/living/silicon/infomorph/user, datum/nanoui/ui=null, force_open=1)
		var/data[0]

		var/turf/T = get_turf_or_move(user.loc)
		if(!T)
			data["reading"] = 0
			data["pressure"] = 0
			data["temperature"] = 0
			data["temperatureC"] = 0
			data["gas"] = list()
		else
			var/datum/gas_mixture/env = T.return_air()
			data["reading"] = 1
			var/pres = env.return_pressure() * 10
			data["pressure"] = "[round(pres/10)].[pres%10]"
			data["temperature"] = round(env.temperature)
			data["temperatureC"] = round(env.temperature-T0C)

			var/t_moles = env.total_moles
			var/gases[0]
			for(var/g in env.gas)
				var/gas[0]
				gas["name"] = gas_data.name[g]
				gas["percent"] = round((env.gas[g] / t_moles) * 100)
				gases[++gases.len] = gas
			data["gas"] = gases

		ui = SSnanoui.try_update_ui(user, user, id, ui, data, force_open)
		if(!ui)
			// Don't copy-paste this unless you're making a pAI software module!
			ui = new(user, user, id, "pai_atmosphere.tmpl", "Atmosphere Sensor", 350, 300)
			ui.set_initial_data(data)
			ui.open()

/datum/infomorph_software/ar_hud
	name = "AR HUD"
	ram_cost = 15
	id = "ar_hud"

	toggle(mob/living/silicon/infomorph/user)
		user.arHUD = !user.arHUD
		if(user.plane_holder)
			user.plane_holder.set_vis(VIS_CH_ID,user.arHUD)
			user.plane_holder.set_vis(VIS_CH_HEALTH_VR,user.arHUD)

	is_active(mob/living/silicon/infomorph/user)
		return user.arHUD

/datum/infomorph_software/translator
	name = "Universal Translator"
	ram_cost = 15
	id = "translator"

	toggle(mob/living/silicon/infomorph/user)
		user.translator.attack_self(user)

	is_active(mob/living/silicon/infomorph/user)
		return user.translator.listening

/datum/infomorph_software/signaller
	name = "Remote Signaller"
	ram_cost = 15
	id = "signaller"
	toggle = 0

	on_ui_interact(mob/living/silicon/infomorph/user, datum/nanoui/ui=null, force_open=1)
		var/data[0]

		data["frequency"] = format_frequency(user.sradio.frequency)
		data["code"] = user.sradio.code

		ui = SSnanoui.try_update_ui(user, user, id, ui, data, force_open)
		if(!ui)
			// Don't copy-paste this unless you're making a pAI software module!
			ui = new(user, user, id, "pai_signaller.tmpl", "Signaller", 320, 150)
			ui.set_initial_data(data)
			ui.open()

	Topic(href, href_list)
		var/mob/living/silicon/infomorph/P = usr
		if(!istype(P)) return

		if(href_list["send"])
			P.sradio.send_signal("ACTIVATE")
			for(var/mob/O in hearers(1, P.loc))
				O.show_message("[bicon(P)] *beep* *beep*", 3, "*beep* *beep*", 2)
			return 1

		else if(href_list["freq"])
			var/new_frequency = (P.sradio.frequency + text2num(href_list["freq"]))
			if(new_frequency < PUBLIC_LOW_FREQ || new_frequency > PUBLIC_HIGH_FREQ)
				new_frequency = sanitize_frequency(new_frequency)
			P.sradio.set_frequency(new_frequency)
			return 1

		else if(href_list["code"])
			P.sradio.code += text2num(href_list["code"])
			P.sradio.code = round(P.sradio.code)
			P.sradio.code = min(100, P.sradio.code)
			P.sradio.code = max(1, P.sradio.code)
			return 1
