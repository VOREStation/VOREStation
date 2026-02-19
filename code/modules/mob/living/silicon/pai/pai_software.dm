/mob/living/silicon/pai/proc/refresh_software_status()	//This manages the pAI software status buttons icon states based on if you have them and if they are enabled
	for(var/thing in software)							//this only gets called when you click one of the relevent buttons, rather than all the time!
		var/datum/pai_software/soft = software[thing]
		if(istype(soft,/datum/pai_software/med_records))
			soft_mr = TRUE
		if(istype(soft,/datum/pai_software/sec_records))
			soft_sr = TRUE
		if(istype(soft,/datum/pai_software/door_jack))
			soft_dj = TRUE
		if(istype(soft,/datum/pai_software/atmosphere_sensor))
			soft_as = TRUE
		if(istype(soft,/datum/pai_software/pai_hud))
			soft_ar = TRUE
		if(istype(soft,/datum/pai_software/translator))
			soft_ut = TRUE
		if(istype(soft,/datum/pai_software/signaller))
			soft_si = TRUE
		if(istype(soft,/datum/pai_software/deathalarm))
			soft_da = TRUE
	for(var/atom/movable/screen/pai/button in hud_used.other)
		if(button.name == "medical records")
			if(soft_mr)
				button.icon_state = "[button.base_state]"
			else
				button.icon_state = "[button.base_state]_o"
		if(button.name == "security records")
			if(soft_sr)
				button.icon_state = "[button.base_state]"
			else
				button.icon_state = "[button.base_state]_o"
		if(button.name == "door jack")
			if(soft_dj)
				button.icon_state = "[button.base_state]"
			else
				button.icon_state = "[button.base_state]_o"
		if(button.name == "atmosphere sensor")
			if(soft_as)
				button.icon_state = "[button.base_state]"
			else
				button.icon_state = "[button.base_state]_o"
		if(button.name == "remote signaler")
			if(soft_si)
				button.icon_state = "[button.base_state]"
			else
				button.icon_state = "[button.base_state]_o"
		if(button.name == "universal translator")
			if(soft_ut && translator_on)
				button.icon_state = "[button.base_state]"
			else
				button.icon_state = "[button.base_state]_o"
		if(button.name == "ar hud")
			if(soft_ar && paiHUD)
				button.icon_state = "[button.base_state]"
			else
				button.icon_state = "[button.base_state]_o"
		if(button.name == "death alarm")
			if(soft_da && paiDA)
				button.icon_state = "[button.base_state]"
			else
				button.icon_state = "[button.base_state]_o"

/mob/living/silicon/pai/verb/wipe_software()
	set name = "Enter Storage"
	set category = "Abilities.pAI Commands"
	set desc = "Upload your personality to the cloud and wipe your software from the card. This is functionally equivalent to cryo or robotic storage, freeing up your job slot."

	// Make sure people don't kill themselves accidentally
	if(tgui_alert(src, "WARNING: This will immediately wipe your software and ghost you, removing your character from the round permanently (similar to cryo and robotic storage). Are you entirely sure you want to do this?", "Wipe Software", list("No", "Yes")) != "Yes")
		return

	close_up()
	visible_message(span_filter_notice(span_bold("[src]") + " fades away from the screen, the pAI device goes silent."))
	card.removePersonality()
	clear_client()

/mob/living/silicon/pai/proc/touch_window(soft_name)	//This lets us touch TGUI procs and windows that may be nested behind other TGUI procs and windows
	if(stat != CONSCIOUS)								//so we can access our software without having to open up the software interface TGUI window
		to_chat(src, span_warning("You can't do that right now."))
		return
	for(var/thing in software)
		var/datum/pai_software/S = software[thing]
		if(istype(S, /datum/pai_software) && S.name == soft_name)
			if(S.toggle)
				S.toggle(src)
				to_chat(src, span_notice("You toggled [S.name]."))
				refresh_software_status()
			else
				S.tgui_interact(src)
				refresh_software_status()
			return
	for(var/thing in GLOB.pai_software_by_key)
		var/datum/pai_software/our_soft = GLOB.pai_software_by_key[thing]
		if(our_soft.name == soft_name)
			if(!(ram >= our_soft.ram_cost))
				to_chat(src, span_warning("Insufficient RAM for download. (Cost [our_soft.ram_cost] : [ram] Remaining)"))
				return
			if(tgui_alert(src, "Do you want to download [our_soft.name]? It costs [our_soft.ram_cost], and you have [ram] remaining.", "Download [our_soft.name]", list("Yes", "No")) == "Yes")
				if(!(ram >= our_soft.ram_cost))
					return
				if(software[our_soft.id])
					return
				ram -= our_soft.ram_cost
				software[our_soft.id] = our_soft
				to_chat(src, span_notice("You downloaded [our_soft.name]. ([ram] RAM remaining.)"))
				refresh_software_status()

//Procs for using the various UI buttons for your softwares
/mob/living/silicon/pai/proc/directives()
	touch_window("Directives")

/mob/living/silicon/pai/proc/crew_manifest()
	touch_window("Crew Manifest")

/mob/living/silicon/pai/proc/med_records()
	touch_window("Medical Records")

/mob/living/silicon/pai/proc/sec_records()
	touch_window("Security Records")

/mob/living/silicon/pai/proc/remote_signal()
	touch_window("Remote Signaler")

/mob/living/silicon/pai/proc/atmos_sensor()
	touch_window("Atmosphere Sensor")

/mob/living/silicon/pai/proc/translator()
	touch_window("Universal Translator")

/mob/living/silicon/pai/proc/door_jack()
	touch_window("Door Jack")

/mob/living/silicon/pai/proc/ar_hud()
	touch_window("AR HUD")

/mob/living/silicon/pai/proc/death_alarm()
	touch_window("Death Alarm")
