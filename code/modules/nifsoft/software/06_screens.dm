/datum/nifsoft/crewmonitor
	name = "Crew Monitor"
	desc = "A link to the local crew monitor sensors. Useful for finding people in trouble."
	list_pos = NIF_MEDMONITOR
	access = access_medical
	cost = 1250
	p_drain = 0.025
	var/datum/nano_module/crew_monitor/arscreen

	New()
		..()
		arscreen = new(nif)

	Destroy()
		QDEL_NULL(arscreen)
		return ..()

	activate()
		if((. = ..()))
			arscreen.ui_interact(nif.human,"main",null,1,nif_state)
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
	cost = 1250
	p_drain = 0.025
	var/datum/nano_module/alarm_monitor/engineering/arscreen

	New()
		..()
		arscreen = new(nif)

	Destroy()
		QDEL_NULL(arscreen)
		return ..()

	activate()
		if((. = ..()))
			arscreen.ui_interact(nif.human,"main",null,1,nif_state)
			return TRUE

	deactivate()
		if((. = ..()))
			return TRUE

	stat_text()
		return "Show Monitor"

/datum/nifsoft/cameramonitor
	name = "Security Monitor"
	desc = "A link to the local camera alarm monitors. Useful for knowing where the trouble is."
	list_pos = NIF_SECMONITOR
	access = access_security
	cost = 1250
	p_drain = 0.025
	var/datum/nano_module/alarm_monitor/security/arscreen

	New()
		..()
		arscreen = new(nif)

	Destroy()
		QDEL_NULL(arscreen)
		return ..()

	activate()
		if((. = ..()))
			arscreen.ui_interact(nif.human,"main",null,1,nif_state)
			return TRUE

	deactivate()
		if((. = ..()))
			return TRUE

	stat_text()
		return "Show Monitor"
