/datum/nifsoft/crewmonitor
	name = "Crew Monitor"
	desc = "A link to the local crew monitor sensors. Useful for finding people in trouble."
	list_pos = NIF_MEDMONITOR
	access = access_medical
	cost = 625
	p_drain = 0.025
	var/datum/tgui_module/crew_monitor/nif/arscreen

	New()
		..()
		arscreen = new(nif)

	Destroy()
		QDEL_NULL(arscreen)
		return ..()

	activate()
		if((. = ..()))
			arscreen.tgui_interact(nif.human)
			return TRUE

	deactivate()
		if((. = ..()))
			return TRUE

	stat_text()
		return "Show Monitor"

/datum/nifsoft/alarmmonitor
	name = "Alarm Monitor"
	desc = "A link to the local alarm monitors. Useful for detecting alarms in a pinch."
	list_pos = NIF_ENGMONITOR
	access = access_engine
	cost = 625
	p_drain = 0.025
	var/datum/tgui_module/alarm_monitor/engineering/nif/tgarscreen

	New()
		..()
		tgarscreen = new(nif)

	Destroy()
		QDEL_NULL(tgarscreen)
		return ..()

	activate()
		if((. = ..()))
			tgarscreen.tgui_interact(nif.human)
			return TRUE

	deactivate()
		if((. = ..()))
			return TRUE

	stat_text()
		return "Show Monitor"
