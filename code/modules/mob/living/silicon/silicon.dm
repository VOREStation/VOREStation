/mob/living/silicon
	gender = NEUTER
	voice_name = "synthesized voice"
	var/syndicate = 0
	var/const/MAIN_CHANNEL = "Main Frequency"
	var/lawchannel = MAIN_CHANNEL // Default channel on which to state laws
	var/list/stating_laws = list()// Channels laws are currently being stated on
	var/obj/item/radio/common_radio

	has_huds = TRUE
	var/list/speech_synthesizer_langs = list()	//which languages can be vocalized by the speech synthesizer

	//Used in say.dm.
	var/speak_statement = "states"
	var/speak_exclamation = "declares"
	var/speak_query = "queries"
	var/pose //Yes, now AIs can pose too.
	var/obj/item/camera/siliconcam/aiCamera = null //photography
	var/local_transmit //If set, can only speak to others of the same type within a short range.

	var/next_alarm_notice
	var/list/datum/alarm/queued_alarms = new()

	var/list/access_rights
	var/obj/item/card/id/idcard
	var/idcard_type = /obj/item/card/id/synthetic

	var/sensor_type = 0 //VOREStation add - silicon omni "is sensor on or nah"

	var/hudmode = null

/mob/living/silicon/New()
	silicon_mob_list |= src
	..()
	add_language(LANGUAGE_GALCOM)
	set_default_language(GLOB.all_languages[LANGUAGE_GALCOM])
	init_id()
	init_subsystems()

/mob/living/silicon/Destroy()
	silicon_mob_list -= src
	for(var/datum/alarm_handler/AH in SSalarm.all_handlers)
		AH.unregister_alarm(src)
	return ..()

/mob/living/silicon/proc/init_id()
	if(idcard)
		return
	idcard = new idcard_type(src)
	set_id_info(idcard)

/mob/living/silicon/proc/SetName(pickedName as text)
	real_name = pickedName
	name = real_name

/mob/living/silicon/proc/show_laws()
	return

/mob/living/silicon/drop_item()
	return

/mob/living/silicon/emp_act(severity)
	switch(severity)
		if(1)
			src.take_organ_damage(0,20,emp=1)
			Confuse(5)
		if(2)
			src.take_organ_damage(0,15,emp=1)
			Confuse(4)
		if(3)
			src.take_organ_damage(0,10,emp=1)
			Confuse(3)
		if(4)
			src.take_organ_damage(0,5,emp=1)
			Confuse(2)
	flash_eyes(affect_silicon = 1)
	to_chat(src, "<span class='danger'><B>*BZZZT*</B></span>")
	to_chat(src, "<span class='danger'>Warning: Electromagnetic pulse detected.</span>")
	..()

/mob/living/silicon/stun_effect_act(var/stun_amount, var/agony_amount)
	return	//immune

/mob/living/silicon/electrocute_act(var/shock_damage, var/obj/source, var/siemens_coeff = 0.0, var/def_zone = null, var/stun = 1)
	if(shock_damage > 0)
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(5, 1, loc)
		s.start()

		shock_damage *= siemens_coeff	//take reduced damage
		take_overall_damage(0, shock_damage)
		visible_message("<span class='warning'>[src] was shocked by \the [source]!</span>", \
			"<span class='danger'>Energy pulse detected, system damaged!</span>", \
			"<span class='warning'>You hear an electrical crack.</span>")
		if(prob(20))
			Stun(2)
		return

/mob/living/silicon/proc/damage_mob(var/brute = 0, var/fire = 0, var/tox = 0)
	return

/mob/living/silicon/IsAdvancedToolUser()
	return 1

/mob/living/silicon/bullet_act(var/obj/item/projectile/Proj)

	if(!Proj.nodamage)
		switch(Proj.damage_type)
			if(BRUTE)
				adjustBruteLoss(Proj.damage)
			if(BURN)
				adjustFireLoss(Proj.damage)

	Proj.on_hit(src,2)
	updatehealth()
	return 2

/mob/living/silicon/apply_effect(var/effect = 0,var/effecttype = STUN, var/blocked = 0, var/check_protection = 1)
	return 0//The only effect that can hit them atm is flashes and they still directly edit so this works for now


/proc/islinked(var/mob/living/silicon/robot/bot, var/mob/living/silicon/ai/ai)
	if(!istype(bot) || !istype(ai))
		return 0
	if (bot.connected_ai == ai)
		return 1
	return 0


// this function shows the health of the AI in the Status panel
/mob/living/silicon/proc/show_system_integrity()
	if(!src.stat)
		stat(null, text("System integrity: [round((health/getMaxHealth())*100)]%"))
	else
		stat(null, text("Systems nonfunctional"))


// This is a pure virtual function, it should be overwritten by all subclasses
/mob/living/silicon/proc/show_malf_ai()
	return 0

// this function displays the shuttles ETA in the status panel if the shuttle has been called
/mob/living/silicon/proc/show_emergency_shuttle_eta()
	if(emergency_shuttle)
		var/eta_status = emergency_shuttle.get_status_panel_eta()
		if(eta_status)
			stat(null, eta_status)


// This adds the basic clock, shuttle recall timer, and malf_ai info to all silicon lifeforms
/mob/living/silicon/Stat()
	if(statpanel("Status"))
		show_emergency_shuttle_eta()
		show_system_integrity()
		show_malf_ai()
	..()

/* VOREStation Removal
// this function displays the stations manifest in a separate window
/mob/living/silicon/proc/show_station_manifest()
	var/dat = "<div align='center'>"
	if(!data_core)
		to_chat(src, "<span class='notice'>There is no data to form a manifest with. Contact your Nanotrasen administrator.</span>")
		return
	dat += data_core.get_manifest(1) //The 1 makes it monochrome.

	var/datum/browser/popup = new(src, "Crew Manifest", "Crew Manifest", 370, 420, src)
	popup.set_content(dat)
	popup.open()
*/

//can't inject synths
/mob/living/silicon/can_inject(var/mob/user, var/error_msg, var/target_zone, var/ignore_thickness = FALSE)
	if(error_msg)
		to_chat(user, "<span class='alert'>The armoured plating is too tough.</span>")
	return 0


//Silicon mob language procs

/mob/living/silicon/can_speak(datum/language/speaking)
	if(universal_speak)
		return TRUE
	//need speech synthesizer support to vocalize a language
	if(speaking in speech_synthesizer_langs)
		return TRUE
	if(speaking && speaking.flags & INNATE)
		return TRUE
	return FALSE

/mob/living/silicon/add_language(var/language, var/can_speak=1)
	var/datum/language/added_language = GLOB.all_languages[language]
	if(!added_language)
		return

	. = ..(language)
	if (can_speak && (added_language in languages) && !(added_language in speech_synthesizer_langs))
		speech_synthesizer_langs += added_language
		return 1

/mob/living/silicon/remove_language(var/rem_language)
	var/datum/language/removed_language = GLOB.all_languages[rem_language]
	if(!removed_language)
		return

	..(rem_language)
	speech_synthesizer_langs -= removed_language

/mob/living/silicon/check_lang_data()
	. = ""

	if(default_language)
		. += "Current default language: [default_language] - <a href='byond://?src=\ref[src];default_lang=reset'>reset</a><br><br>"

	for(var/datum/language/L in languages)
		if(!(L.flags & NONGLOBAL))
			var/default_str
			if(L == default_language)
				default_str = " - default - <a href='byond://?src=\ref[src];default_lang=reset'>reset</a>"
			else
				default_str = " - <a href='byond://?src=\ref[src];default_lang=\ref[L]'>set default</a>"

			var/synth = (L in speech_synthesizer_langs)
			. += "<b>[L.name] ([get_language_prefix()][L.key])</b>[synth ? default_str : null]<br>Speech Synthesizer: <i>[synth ? "YES" : "NOT SUPPORTED"]</i><br>[L.desc]<br><br>"

/mob/living/silicon/proc/toggle_sensor_mode() //VOREStation Add to make borgs use omni starts here - Tank, clueless bird
	if(sensor_type)
		if(plane_holder)
			//Enable the planes, its basically just AR-Bs
			plane_holder.set_vis(VIS_CH_ID,TRUE)
			plane_holder.set_vis(VIS_CH_WANTED,TRUE)
			plane_holder.set_vis(VIS_CH_IMPLOYAL,TRUE) //antag related so prob not useful but leaving them in
			plane_holder.set_vis(VIS_CH_IMPTRACK,TRUE)
			plane_holder.set_vis(VIS_CH_IMPCHEM,TRUE)
			plane_holder.set_vis(VIS_CH_STATUS_R,TRUE)
			plane_holder.set_vis(VIS_CH_HEALTH_VR,TRUE)
			plane_holder.set_vis(VIS_CH_BACKUP,TRUE) //backup stuff from silicon_vr is here now
			return TRUE

	else
		if(plane_holder)
			//Disable the planes
			plane_holder.set_vis(VIS_CH_ID,FALSE)
			plane_holder.set_vis(VIS_CH_WANTED,FALSE)
			plane_holder.set_vis(VIS_CH_IMPLOYAL,FALSE)
			plane_holder.set_vis(VIS_CH_IMPTRACK,FALSE)
			plane_holder.set_vis(VIS_CH_IMPCHEM,FALSE)
			plane_holder.set_vis(VIS_CH_STATUS_R,FALSE)
			plane_holder.set_vis(VIS_CH_HEALTH_VR,FALSE)
			plane_holder.set_vis(VIS_CH_BACKUP,FALSE)
			return FALSE

//hudmode = sensor_type //This is checked in examine.dm on humans, so they can see medical/security records depending on mode
//I made it work like omnis with records by adding stuff to examine.dm
//VOREStation Add ends here

/mob/living/silicon/verb/pose()
	set name = "Set Pose"
	set desc = "Sets a description which will be shown when someone examines you."
	set category = "IC"

	pose =  sanitize(tgui_input_text(usr, "This is [src]. It is...", "Pose", null))

/mob/living/silicon/verb/set_flavor()
	set name = "Set Flavour Text"
	set desc = "Sets an extended description of your character's features."
	set category = "IC"

	flavor_text =  sanitize(tgui_input_text(usr, "Please enter your new flavour text.", "Flavour text", null))

/mob/living/silicon/binarycheck()
	return 1

/mob/living/silicon/ex_act(severity)
	if(!blinded)
		flash_eyes()

	for(var/datum/modifier/M in modifiers)
		if(!isnull(M.explosion_modifier))
			severity = CLAMP(severity + M.explosion_modifier, 1, 4)

	severity = round(severity)

	if(severity > 3)
		return

	switch(severity)
		if(1.0)
			if (stat != 2)
				adjustBruteLoss(100)
				adjustFireLoss(100)
				if(!anchored)
					gib()
		if(2.0)
			if (stat != 2)
				adjustBruteLoss(60)
				adjustFireLoss(60)
		if(3.0)
			if (stat != 2)
				adjustBruteLoss(30)

	updatehealth()

/mob/living/silicon/proc/receive_alarm(var/datum/alarm_handler/alarm_handler, var/datum/alarm/alarm, was_raised)
	if(!next_alarm_notice)
		next_alarm_notice = world.time + SecondsToTicks(10)
	if(alarm.hidden)
		return
	if(alarm.origin && !(get_z(alarm.origin) in using_map.get_map_levels(get_z(src), TRUE, om_range = DEFAULT_OVERMAP_RANGE)))
		return

	var/list/alarms = queued_alarms[alarm_handler]
	if(was_raised)
		// Raised alarms are always set
		alarms[alarm] = 1
	else
		// Alarms that were raised but then cleared before the next notice are instead removed
		if(alarm in alarms)
			alarms -= alarm
		// And alarms that have only been cleared thus far are set as such
		else
			alarms[alarm] = -1

/mob/living/silicon/proc/process_queued_alarms()
	if(next_alarm_notice && (world.time > next_alarm_notice))
		next_alarm_notice = 0

		var/alarm_raised = 0
		for(var/datum/alarm_handler/AH in queued_alarms)
			var/list/alarms = queued_alarms[AH]
			var/reported = 0
			for(var/datum/alarm/A in alarms)
				if(alarms[A] == 1)
					alarm_raised = 1
					if(!reported)
						reported = 1
						to_chat(src, "<span class='warning'>--- [AH.category] Detected ---</span>")
					raised_alarm(A)

		for(var/datum/alarm_handler/AH in queued_alarms)
			var/list/alarms = queued_alarms[AH]
			var/reported = 0
			for(var/datum/alarm/A in alarms)
				if(alarms[A] == -1)
					if(!reported)
						reported = 1
						to_chat(src, "<span class='notice'>--- [AH.category] Cleared ---</span>")
					to_chat(src, "\The [A.alarm_name()].")

		if(alarm_raised)
			to_chat(src, "<A HREF=?src=\ref[src];showalerts=1>\[Show Alerts\]</A>")

		for(var/datum/alarm_handler/AH in queued_alarms)
			var/list/alarms = queued_alarms[AH]
			alarms.Cut()

/mob/living/silicon/proc/raised_alarm(var/datum/alarm/A)
	to_chat(src, "[A.alarm_name()]!")

/mob/living/silicon/ai/raised_alarm(var/datum/alarm/A)
	var/cameratext = ""
	for(var/obj/machinery/camera/C in A.cameras())
		cameratext += "[(cameratext == "")? "" : "|"]<A HREF=?src=\ref[src];switchcamera=\ref[C]>[C.c_tag]</A>"
	to_chat(src, "[A.alarm_name()]! ([(cameratext)? cameratext : "No Camera"])")


/mob/living/silicon/proc/is_traitor()
	return mind && (mind in traitors.current_antagonists)

/mob/living/silicon/proc/is_malf()
	return mind && (mind in malf.current_antagonists)

/mob/living/silicon/proc/is_malf_or_traitor()
	return is_traitor() || is_malf()

/mob/living/silicon/adjustEarDamage()
	return

/mob/living/silicon/setEarDamage()
	return

/mob/living/silicon/reset_view()
	. = ..()
	if(cameraFollow)
		cameraFollow = null

/mob/living/silicon/flash_eyes(intensity = FLASH_PROTECTION_MODERATE, override_blindness_check = FALSE, affect_silicon = FALSE, visual = FALSE, type = /obj/screen/fullscreen/flash)
	if(affect_silicon)
		return ..()

/mob/living/silicon/proc/clear_client()
	//Handle job slot/tater cleanup.
	var/job = mind.assigned_role

	job_master.FreeRole(job)

	if(mind.objectives.len)
		qdel(mind.objectives)
		mind.special_role = null

	clear_antag_roles(mind)

	ghostize(0)
	qdel(src)

/mob/living/silicon/has_vision()
	return 0 //NOT REAL EYES

/mob/living/silicon/can_feed()
	return FALSE