// Wires for airlocks

/datum/wires/airlock/secure
	randomize = 1
	wire_count = 14

/datum/wires/airlock
	holder_type = /obj/machinery/door/airlock
	wire_count = 12
	proper_name = "Airlock"
	tgui_template = "WiresAirlock"

/datum/wires/airlock/interactable(mob/user)
	var/obj/machinery/door/airlock/A = holder
	if(!issilicon(user))
		if(A.isElectrified())
			if(A.shock(user, 100))
				return FALSE
	if(A.p_open)
		return TRUE
	return FALSE

/datum/wires/airlock/New(atom/_holder)
	wires = list(
		WIRE_IDSCAN, WIRE_MAIN_POWER1, WIRE_MAIN_POWER2, WIRE_DOOR_BOLTS,
		WIRE_BACKUP_POWER1, WIRE_BACKUP_POWER2, WIRE_OPEN_DOOR, WIRE_AI_CONTROL,
		WIRE_ELECTRIFY, WIRE_SAFETY, WIRE_SPEED, WIRE_BOLT_LIGHT
	)
	return ..()

/datum/wires/airlock/get_status()
	. = ..()
	var/obj/machinery/door/airlock/A = holder
	var/haspower = A.arePowerSystemsOn() //If there's no power, then no lights will be on.

	. += "The door bolts [A.locked ? "have fallen!" : "look up."]"
	. += "The door bolt lights are [(A.lights && haspower) ? "on." : "off!"]"
	. += "The test light is [haspower ? "on." : "off!"]"
	. += "The backup power light is [A.backup_power_lost_until ? "off!" : "on."]"
	. += "The 'AI control allowed' light is [(A.aiControlDisabled == 0 && !A.emagged && haspower) ? "on" : "off"]."
	. += "The 'Check Wiring' light is [(A.safe == 0 && haspower) ? "on" : "off"]."
	. += "The 'Check Timing Mechanism' light is [(A.normalspeed == 0 && haspower) ? "on" : "off"]."
	. += "The IDScan light is [(A.aiDisabledIdScanner == 0 && haspower) ? "on" : "off."]"

/datum/wires/airlock/tgui_data(mob/user)
	var/list/data = ..()

	var/obj/machinery/door/airlock/A = holder
	data["id_tag"] = A.id_tag
	data["frequency"] = A.radio_connection ? A.frequency : null
	data["min_freq"] = RADIO_LOW_FREQ
	data["max_freq"] = RADIO_HIGH_FREQ

	return data

/datum/wires/airlock/tgui_act(action, list/params)
	. = ..()
	if(.)
		return

	var/obj/machinery/door/airlock/A = holder

	switch(action)
		if("set_id_tag")
			var/new_id = tgui_input_text(usr, "Enter a new ID tag for [A]", "[A] ID Tag", A.id_tag, 30, FALSE, TRUE)
			if(new_id)
				A.id_tag = new_id
				return TRUE

		if("set_frequency")
			A.set_frequency(sanitize_frequency(text2num(params["freq"]), RADIO_LOW_FREQ, RADIO_HIGH_FREQ))
			return TRUE

		if("clear_frequency")
			A.set_frequency(null)
			return TRUE

/datum/wires/airlock/on_cut(wire, mend)
	var/obj/machinery/door/airlock/A = holder
	switch(wire)
		if(WIRE_IDSCAN)
			A.aiDisabledIdScanner = !mend
		if(WIRE_MAIN_POWER1, WIRE_MAIN_POWER2)
			if(!mend)
				//Cutting either one disables the main door power, but unless backup power is also cut, the backup power re-powers the door in 10 seconds. While unpowered, the door may be crowbarred open, but bolts-raising will not work. Cutting these wires may electocute the user.
				A.loseMainPower()
				A.shock(usr, 50)
			else
				A.regainMainPower()
				A.shock(usr, 50)

		if(WIRE_BACKUP_POWER1, WIRE_BACKUP_POWER2)
			if(!mend)
				//Cutting either one disables the backup door power (allowing it to be crowbarred open, but disabling bolts-raising), but may electocute the user.
				A.loseBackupPower()
				A.shock(usr, 50)
			else
				A.regainBackupPower()
				A.shock(usr, 50)

		if(WIRE_DOOR_BOLTS)
			if(!mend)
				//Cutting this wire also drops the door bolts, and mending it does not raise them. (This is what happens now, except there are a lot more wires going to door bolts at present)
				A.lock(1)
				A.update_icon()

		if(WIRE_AI_CONTROL)
			if(!mend)
				//one wire for AI control. Cutting this prevents the AI from controlling the door unless it has hacked the door through the power connection (which takes about a minute). If both main and backup power are cut, as well as this wire, then the AI cannot operate or hack the door at all.
				//aiControlDisabled: If 1, AI control is disabled until the AI hacks back in and disables the lock. If 2, the AI has bypassed the lock. If -1, the control is enabled but the AI had bypassed it earlier, so if it is disabled again the AI would have no trouble getting back in.
				if(A.aiControlDisabled == 0)
					A.aiControlDisabled = 1
				else if(A.aiControlDisabled == -1)
					A.aiControlDisabled = 2
			else
				if(A.aiControlDisabled == 1)
					A.aiControlDisabled = 0
				else if(A.aiControlDisabled == 2)
					A.aiControlDisabled = -1

		if(WIRE_ELECTRIFY)
			if(!mend)
				//Cutting this wire electrifies the door, so that the next person to touch the door without insulated gloves gets electrocuted.
				A.electrify(-1)
			else
				A.electrify(0)
			return // Don't update the dialog.

		if (WIRE_SAFETY)
			A.safe = mend

		if(WIRE_SPEED)
			A.autoclose = mend
			if(mend)
				if(!A.density)
					A.close()

		if(WIRE_BOLT_LIGHT)
			A.lights = mend
			A.update_icon()


/datum/wires/airlock/on_pulse(wire)
	var/obj/machinery/door/airlock/A = holder
	switch(wire)
		if(WIRE_IDSCAN)
			//Sending a pulse through flashes the red light on the door (if the door has power).
			if(A.arePowerSystemsOn() && A.density)
				A.do_animate("deny")

		if(WIRE_MAIN_POWER1, WIRE_MAIN_POWER2)
			//Sending a pulse through either one causes a breaker to trip, disabling the door for 10 seconds if backup power is connected, or 1 minute if not (or until backup power comes back on, whichever is shorter).
			A.loseMainPower()

		if(WIRE_DOOR_BOLTS)
			//one wire for door bolts. Sending a pulse through this drops door bolts if they're not down (whether power's on or not),
			//raises them if they are down (only if power's on)
			if(!A.locked)
				A.lock()
			else
				A.unlock()

		if(WIRE_BACKUP_POWER1, WIRE_BACKUP_POWER2)
			//two wires for backup power. Sending a pulse through either one causes a breaker to trip, but this does not disable it unless main power is down too (in which case it is disabled for 1 minute or however long it takes main power to come back, whichever is shorter).
			A.loseBackupPower()

		if(WIRE_AI_CONTROL)
			if(A.aiControlDisabled == 0)
				A.aiControlDisabled = 1
			else if(A.aiControlDisabled == -1)
				A.aiControlDisabled = 2

			spawn(10)
				if(A)
					if(A.aiControlDisabled == 1)
						A.aiControlDisabled = 0
					else if(A.aiControlDisabled == 2)
						A.aiControlDisabled = -1

		if(WIRE_ELECTRIFY)
			//one wire for electrifying the door. Sending a pulse through this electrifies the door for 30 seconds.
			A.electrify(30)

		if(WIRE_OPEN_DOOR)
			//tries to open the door without ID
			//will succeed only if the ID wire is cut or the door requires no access and it's not emagged
			if(A.emagged)	return
			if(!A.requiresID() || A.check_access(null))
				if(A.density)	A.open()
				else			A.close()

		if(WIRE_SAFETY)
			A.safe = !A.safe
			if(!A.density)
				A.close()

		if(WIRE_SPEED)
			A.normalspeed = !A.normalspeed

		if(WIRE_BOLT_LIGHT)
			A.lights = !A.lights
			A.update_icon()
