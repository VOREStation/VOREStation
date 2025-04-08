////////////////////////
//Turret Control Panel//
////////////////////////

/area
	// Turrets use this list to see if individual power/lethal settings are allowed
	var/list/turret_controls = list()

/obj/machinery/turretid
	name = "turret control panel"
	desc = "Used to control a room's automated defenses."
	icon = 'icons/obj/machines/turret_control.dmi'
	icon_state = "control_standby"
	anchored = TRUE
	density = FALSE
	unacidable = TRUE
	var/enabled = FALSE
	var/lethal = FALSE
	var/lethal_is_configurable = TRUE
	var/locked = TRUE
	var/area/control_area //can be area name, path or nothing.

	var/targetting_is_configurable = TRUE // if false, you cannot change who this turret attacks via its UI
	var/check_arrest = TRUE	//checks if the perp is set to arrest
	var/check_records = TRUE	//checks if a security record exists at all
	var/check_weapons = FALSE	//checks if it can shoot people that have a weapon they aren't authorized to have
	var/check_access = TRUE	//if this is active, the turret shoots everything that does not meet the access requirements
	var/check_anomalies = TRUE	//checks if it can shoot at unidentified lifeforms (ie xenos)
	var/check_synth = FALSE 	//if active, will shoot at anything not an AI or cyborg
	var/check_all = FALSE		//If active, will shoot at anything.
	var/check_down = TRUE		//If active, won't shoot laying targets.
	var/stay_up = FALSE			//If active, the turret will not pop-down unless it loses power or is disabled.
	var/fire_at_movement = FALSE	//If active, the turret will prioritize objects or creatures that move in its range.
	var/ailock = FALSE 	//Silicons cannot use this

	var/syndicate = FALSE

	req_access = list(access_ai_upload)

/obj/machinery/turretid/stun
	enabled = TRUE
	icon_state = "control_stun"

/obj/machinery/turretid/lethal
	enabled = TRUE
	lethal = TRUE
	icon_state = "control_kill"

/obj/machinery/turretid/Destroy()
	if(control_area)
		var/area/A = control_area
		if(A && istype(A))
			A.turret_controls -= src
	. = ..()

/obj/machinery/turretid/Initialize(mapload)
	if(!control_area)
		control_area = get_area(src)
	else if(ispath(control_area))
		control_area = locate(control_area)
	else if(istext(control_area))
		for(var/area/A in world)
			if(A.name && A.name==control_area)
				control_area = A
				break

	if(control_area)
		var/area/A = control_area
		if(istype(A))
			A.turret_controls += src
		else
			control_area = null

	power_change() //Checks power and initial settings
	. = ..()

/obj/machinery/turretid/proc/isLocked(mob/user)
	if(isrobot(user) || isAI(user))
		if(ailock)
			to_chat(user, span_notice("There seems to be a firewall preventing you from accessing this device."))
			return TRUE
		else
			return FALSE

	if(isobserver(user))
		var/mob/observer/dead/D = user
		if(D.can_admin_interact())
			return FALSE
		else
			return TRUE

	if(locked)
		return TRUE

	return FALSE

/obj/machinery/turretid/attackby(obj/item/W, mob/user)
	if(stat & BROKEN)
		return

	if(istype(W, /obj/item/card/id)||istype(W, /obj/item/pda))
		if(allowed(user))
			if(emagged)
				to_chat(user, span_notice("The turret control is unresponsive."))
			else
				locked = !locked
				to_chat(user, span_notice("You [ locked ? "lock" : "unlock"] the panel."))
		return
	return ..()

/obj/machinery/turretid/emag_act(var/remaining_charges, var/mob/user)
	if(!emagged)
		to_chat(user, span_danger("You short out the turret controls' access analysis module."))
		emagged = TRUE
		locked = FALSE
		ailock = FALSE
		return TRUE

/obj/machinery/turretid/attack_ai(mob/user as mob)
	tgui_interact(user)

/obj/machinery/turretid/attack_ghost(mob/user as mob)
	tgui_interact(user)

/obj/machinery/turretid/attack_hand(mob/user as mob)
	tgui_interact(user)

/obj/machinery/turretid/tgui_interact(mob/user, datum/tgui/ui = null)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "PortableTurret", name, ui_x = 500, ui_y = 400) // 500, 400
		ui.open()

/obj/machinery/turretid/tgui_data(mob/user)
	var/list/data = list(
		"locked" = isLocked(user), // does the current user have access?
		"on" = enabled,
		"targetting_is_configurable" = targetting_is_configurable,
		"lethal" = lethal,
		"lethal_is_configurable" = lethal_is_configurable,
		"check_weapons" = check_weapons,
		"neutralize_noaccess" = check_access,
		"one_access" = FALSE,
		"selectedAccess" = list(),
		"access_is_configurable" = FALSE,
		"neutralize_norecord" = check_records,
		"neutralize_criminals" = check_arrest,
		"neutralize_nonsynth" = check_synth,
		"neutralize_all" = check_all,
		"neutralize_unidentified" = check_anomalies,
		"neutralize_down" = check_down,
	)
	return data

/obj/machinery/turretid/tgui_act(action, params, datum/tgui/ui)
	if(..())
		return
	if(isLocked(ui.user))
		return

	. = TRUE
	switch(action)
		if("power")
			enabled = !enabled
		if("lethal")
			if(lethal_is_configurable)
				lethal = !lethal
	if(targetting_is_configurable)
		switch(action)
			if("authweapon")
				check_weapons = !check_weapons
			if("authaccess")
				check_access = !check_access
			if("authnorecord")
				check_records = !check_records
			if("autharrest")
				check_arrest = !check_arrest
			if("authxeno")
				check_anomalies = !check_anomalies
			if("authsynth")
				check_synth = !check_synth
			if("authall")
				check_all = !check_all
			if("authdown")
				check_down = !check_down

	updateTurrets()

/obj/machinery/turretid/proc/updateTurrets()
	var/datum/turret_checks/TC = new
	TC.enabled = enabled
	TC.lethal = lethal
	TC.check_synth = check_synth
	TC.check_access = check_access
	TC.check_records = check_records
	TC.check_arrest = check_arrest
	TC.check_weapons = check_weapons
	TC.check_anomalies = check_anomalies
	TC.check_all = check_all
	TC.ailock = ailock

	if(istype(control_area))
		for(var/obj/machinery/porta_turret/aTurret in control_area)
			aTurret.setState(TC)

	update_icon()

/obj/machinery/turretid/power_change()
	..()
	updateTurrets()
	update_icon()

/obj/machinery/turretid/update_icon()
	..()
	if(stat & NOPOWER)
		icon_state = "control_off"
		set_light(0)
	else if(enabled)
		if(lethal)
			icon_state = "control_kill"
			set_light(1.5, 1,"#990000")
		else
			icon_state = "control_stun"
			set_light(1.5, 1,"#FF9900")
	else
		icon_state = "control_standby"
		set_light(1.5, 1,"#003300")

/obj/machinery/turretid/emp_act(severity)
	if(enabled)
		//if the turret is on, the EMP no matter how severe disables the turret for a while
		//and scrambles its settings, with a slight chance of having an emag effect

		check_arrest = pick(0, 1)
		check_records = pick(0, 1)
		check_weapons = pick(0, 1)
		check_access = pick(0, 0, 0, 0, 1)	// check_access is a pretty big deal, so it's least likely to get turned on
		check_anomalies = pick(0, 1)

		enabled=0
		updateTurrets()

		spawn(rand(60,600))
			if(!enabled)
				enabled=1
				updateTurrets()

	..()
