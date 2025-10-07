//
/*
- Specific department maintenance doors
- Named doors properly according to type
- Gave them default access levels with the access constants
- Improper'd all of the names in the new()
*/

/obj/machinery/door/airlock
	name = "Airlock"
	description_info = "If you hold left ctrl whilst left-clicking on an airlock, you can ring the doorbell to announce your presence to anyone on the other side! Alternately if you are on HARM intent when doing this, you will bang loudly on the door!<br><br>AIs and Cyborgs can also quickly open/close, bolt/unbolt, and electrify/de-electrify doors at a distance by holding left shift, left control, or left alt respectively whilst left-clicking."
	icon = 'icons/obj/doors/doorint.dmi'
	icon_state = "door_closed"
	power_channel = ENVIRON

	explosion_resistance = 10

	// Doors do their own stuff
	bullet_vulnerability = 0

	blocks_emissive = EMISSIVE_BLOCK_GENERIC // Not quite as nice as /tg/'s custom masks. We should make those sometime

	var/aiControlDisabled = 0 //If 1, AI control is disabled until the AI hacks back in and disables the lock. If 2, the AI has bypassed the lock. If -1, the control is enabled but the AI had bypassed it earlier, so if it is disabled again the AI would have no trouble getting back in.
	var/hackProof = 0 // if 1, this door can't be hacked by the AI
	var/electrified_until = 0			//World time when the door is no longer electrified. -1 if it is permanently electrified until someone fixes it.
	var/main_power_lost_until = 0	 	//World time when main power is restored.
	var/backup_power_lost_until = -1	//World time when backup power is restored.
	var/has_beeped = 0					//If 1, will not beep on failed closing attempt. Resets when door closes.
	var/spawnPowerRestoreRunning = 0
	var/welded = null
	var/locked = FALSE
	var/lights = 1 // bolt lights show by default
	var/aiDisabledIdScanner = 0
	var/aiHacking = FALSE
	var/obj/machinery/door/airlock/closeOther = null
	var/closeOtherId = null
	var/lockdownbyai = 0
	autoclose = 1
	var/assembly_type = /obj/structure/door_assembly
	var/mineral = null
	var/justzap = 0
	var/safe = 1
	normalspeed = 1
	var/obj/item/airlock_electronics/electronics = null
	var/hasShocked = 0 //Prevents multiple shocks from happening
	var/secured_wires = 0
	var/security_level = 1 //Acts as a multiplier on the time required to hack an airlock with a hacktool
	var/datum/wires/airlock/wires = null

	var/open_sound_powered = 'sound/machines/door/covert1o.ogg'
	var/open_sound_unpowered = 'sound/machines/door/airlockforced.ogg'
	var/close_sound_powered = 'sound/machines/door/covert1c.ogg'
	var/legacy_open_powered = 'sound/machines/door/old_airlock.ogg'
	var/legacy_close_powered = 'sound/machines/door/old_airlockclose.ogg'
	var/department_open_powered = null
	var/department_close_powered = null
	var/denied_sound = 'sound/machines/deniedbeep.ogg'
	var/bolt_up_sound = 'sound/machines/door/boltsup.ogg'
	var/bolt_down_sound = 'sound/machines/door/boltsdown.ogg'
	var/knock_sound = 'sound/machines/2beeplow.ogg'
	var/knock_hammer_sound = 'sound/weapons/sonic_jackhammer.ogg'
	var/knock_unpowered_sound = 'sound/machines/door/knock_glass.ogg'
	var/mob/hold_open

/obj/machinery/door/airlock/attack_generic(var/mob/living/user, var/damage)
	if(stat & (BROKEN|NOPOWER))
		if(damage >= STRUCTURE_MIN_DAMAGE_THRESHOLD)
			if(locked || welded)
				visible_message(span_danger("\The [user] begins breaking into \the [src] internals!"))
				user.set_AI_busy(TRUE) // If the mob doesn't have an AI attached, this won't do anything.
				if(do_after(user, 10 SECONDS, target = src))
					locked = FALSE
					welded = FALSE
					update_icon()
					open(TRUE)
					if(prob(25))
						shock(user, 100)
				user.set_AI_busy(FALSE)
			else if(density)
				visible_message(span_danger("\The [user] forces \the [src] open!"))
				open(TRUE)
			else
				visible_message(span_danger("\The [user] forces \the [src] closed!"))
				close(1)
		else
			visible_message(span_notice("\The [user] strains fruitlessly to force \the [src] [density ? "open" : "closed"]."))
		return
	..()

/obj/machinery/door/airlock/attack_alien(var/mob/user) //Familiar, right? Doors. -Mechoid
	if(!ishuman(user))
		return ..()
	var/mob/living/carbon/human/X = user
	if(istype(X.species, /datum/species/xenos))
		if(locked || welded)
			visible_message(span_alium("\The [user] begins tearing into \the [src] internals!"))
			do_animate("deny")
			if(do_after(user, 15 SECONDS, target = src))
				visible_message(span_danger("\The [user] tears \the [src] open, sparks flying from its electronics!"))
				do_animate("spark")
				playsound(src, 'sound/machines/door/airlock_tear_apart.ogg', 100, 1, volume_channel = VOLUME_CHANNEL_DOORS)
				locked = FALSE
				welded = FALSE
				update_icon()
				open(TRUE)
				set_broken() //These aren't emags, these be CLAWS
		else if(density)
			visible_message(span_alium("\The [user] begins forcing \the [src] open!"))
			if(do_after(user, 5 SECONDS, target = src))
				playsound(src, 'sound/machines/door/airlock_creaking.ogg', 100, 1, volume_channel = VOLUME_CHANNEL_DOORS)
				visible_message(span_danger("\The [user] forces \the [src] open!"))
				open(TRUE)
		else
			visible_message(span_danger("\The [user] forces \the [src] closed!"))
			close(1)
	else
		do_animate("deny")
		visible_message(span_notice("\The [user] strains fruitlessly to force \the [src] [density ? "open" : "closed"]."))
		return

/obj/machinery/door/airlock/get_material()
	if(mineral)
		return get_material_by_name(mineral)
	return get_material_by_name(MAT_STEEL)

/obj/machinery/door/airlock/process()
	// Deliberate no call to parent.
	if(main_power_lost_until > 0 && world.time >= main_power_lost_until)
		regainMainPower()

	if(backup_power_lost_until > 0 && world.time >= backup_power_lost_until)
		regainBackupPower()

	else if(electrified_until > 0 && world.time >= electrified_until)
		electrify(0)

	if (..() == PROCESS_KILL && !(main_power_lost_until > 0 || backup_power_lost_until > 0 || electrified_until > 0))
		. = PROCESS_KILL

/*
About the new airlock wires panel:
*	An airlock wire dialog can be accessed by the normal way or by using wirecutters or a multitool on the door while the wire-panel is open. This would show the following wires, which you can either wirecut/mend or send a multitool pulse through. There are 9 wires.
*		one wire from the ID scanner. Sending a pulse through this flashes the red light on the door (if the door has power). If you cut this wire, the door will stop recognizing valid IDs. (If the door has 0000 access, it still opens and closes, though)
*		two wires for power. Sending a pulse through either one causes a breaker to trip, disabling the door for 10 seconds if backup power is connected, or 1 minute if not (or until backup power comes back on, whichever is shorter). Cutting either one disables the main door power, but unless backup power is also cut, the backup power re-powers the door in 10 seconds. While unpowered, the door may be open, but bolts-raising will not work. Cutting these wires may electrocute the user.
*		one wire for door bolts. Sending a pulse through this drops door bolts (whether the door is powered or not) or raises them (if it is). Cutting this wire also drops the door bolts, and mending it does not raise them. If the wire is cut, trying to raise the door bolts will not work.
*		two wires for backup power. Sending a pulse through either one causes a breaker to trip, but this does not disable it unless main power is down too (in which case it is disabled for 1 minute or however long it takes main power to come back, whichever is shorter). Cutting either one disables the backup door power (allowing it to be crowbarred open, but disabling bolts-raising), but may electocute the user.
*		one wire for opening the door. Sending a pulse through this while the door has power makes it open the door if no access is required.
*		one wire for AI control. Sending a pulse through this blocks AI control for a second or so (which is enough to see the AI control light on the panel dialog go off and back on again). Cutting this prevents the AI from controlling the door unless it has hacked the door through the power connection (which takes about a minute). If both main and backup power are cut, as well as this wire, then the AI cannot operate or hack the door at all.
*		one wire for electrifying the door. Sending a pulse through this electrifies the door for 30 seconds. Cutting this wire electrifies the door, so that the next person to touch the door without insulated gloves gets electrocuted. (Currently it is also STAYING electrified until someone mends the wire)
*		one wire for controling door safetys.  When active, door does not close on someone.  When cut, door will ruin someone's shit.  When pulsed, door will immedately ruin someone's shit.
*		one wire for controlling door speed.  When active, dor closes at normal rate.  When cut, door does not close manually.  When pulsed, door attempts to close every tick.
*/

/obj/machinery/door/airlock/bumpopen(mob/living/user) //Airlocks now zap you when you 'bump' them open when they're electrified. --NeoFite
	if(!issilicon(user))
		if(isElectrified())
			if(!justzap)
				if(shock(user, 100))
					justzap = 1
					spawn (10)
						justzap = 0
					return
			else /*if(justzap)*/
				return
		else if(user.hallucination > 50 && prob(10) && operating == 0)
			to_chat(user, span_danger("You feel a powerful shock course through your body!"))
			user.playsound_local(get_turf(user), get_sfx("sparks"), vol = 75)
			user.halloss += 10
			user.stunned += 10
			return
	..(user)

/obj/machinery/door/airlock/proc/isElectrified()
	if(electrified_until != 0)
		return TRUE
	return FALSE

/obj/machinery/door/airlock/proc/canAIControl()
	return ((aiControlDisabled!=1) && (!isAllPowerLoss()));

/obj/machinery/door/airlock/proc/canAIHack()
	return ((aiControlDisabled==1) && (!hackProof) && (!isAllPowerLoss()));

/obj/machinery/door/airlock/proc/arePowerSystemsOn()
	if (stat & (NOPOWER|BROKEN))
		return FALSE
	return (main_power_lost_until==0 || backup_power_lost_until==0)

/obj/machinery/door/airlock/requiresID()
	return !(wires.is_cut(WIRE_IDSCAN) || aiDisabledIdScanner)

/obj/machinery/door/airlock/proc/isAllPowerLoss()
	if(stat & (NOPOWER|BROKEN))
		return TRUE
	if(mainPowerCablesCut() && backupPowerCablesCut())
		return TRUE
	return FALSE

/obj/machinery/door/airlock/proc/mainPowerCablesCut()
	return wires.is_cut(WIRE_MAIN_POWER1) || wires.is_cut(WIRE_MAIN_POWER2)

/obj/machinery/door/airlock/proc/backupPowerCablesCut()
	return wires.is_cut(WIRE_BACKUP_POWER1) || wires.is_cut(WIRE_BACKUP_POWER2)

/obj/machinery/door/airlock/proc/loseMainPower()
	main_power_lost_until = mainPowerCablesCut() ? -1 : world.time + (1 MINUTE)

	// If backup power is permanently disabled then activate in 10 seconds if possible, otherwise it's already enabled or a timer is already running
	if(backup_power_lost_until == -1 && !backupPowerCablesCut())
		backup_power_lost_until = world.time + (10 SECONDS)

	if(main_power_lost_until > 0 || backup_power_lost_until > 0)
		START_MACHINE_PROCESSING(src)

	// Disable electricity if required
	if(electrified_until && isAllPowerLoss())
		electrify(0)

	update_icon()

/obj/machinery/door/airlock/proc/loseBackupPower()
	backup_power_lost_until = backupPowerCablesCut() ? -1 : world.time + (1 MINUTE)

	if(backup_power_lost_until > 0)
		START_MACHINE_PROCESSING(src)

	// Disable electricity if required
	if(electrified_until && isAllPowerLoss())
		electrify(0)

	update_icon()

/obj/machinery/door/airlock/proc/regainMainPower()
	if(!mainPowerCablesCut())
		main_power_lost_until = 0
		// If backup power is currently active then disable, otherwise let it count down and disable itself later
		if(!backup_power_lost_until)
			backup_power_lost_until = -1

	update_icon()

/obj/machinery/door/airlock/proc/regainBackupPower()
	if(!backupPowerCablesCut())
		// Restore backup power only if main power is offline, otherwise permanently disable
		backup_power_lost_until = main_power_lost_until == 0 ? -1 : 0

	update_icon()

/obj/machinery/door/airlock/proc/electrify(var/duration, var/feedback = 0)
	var/message = ""
	if(wires.is_cut(WIRE_ELECTRIFY) && arePowerSystemsOn())
		message = text("The electrification wire is cut - Door permanently electrified.")
		electrified_until = -1
	else if(duration && !arePowerSystemsOn())
		message = text("The door is unpowered - Cannot electrify the door.")
		electrified_until = 0
	else if(!duration && electrified_until != 0)
		message = "The door is now un-electrified."
		electrified_until = 0
	else if(duration)	//electrify door for the given duration seconds
		if(usr)
			shockedby += text("\[[time_stamp()]\] - [usr](ckey:[usr.ckey])")
			add_attack_logs(usr,src,"Electrified a door")
		else
			shockedby += text("\[[time_stamp()]\] - EMP)")
		message = "The door is now electrified [duration == -1 ? "permanently" : "for [duration] second\s"]."
		electrified_until = duration == -1 ? -1 : world.time + (duration SECONDS)

	if(electrified_until > 0)
		START_MACHINE_PROCESSING(src)

	if(feedback && message)
		to_chat(usr,message)

/obj/machinery/door/airlock/proc/set_idscan(var/activate, var/feedback = 0)
	var/message = ""
	if(wires.is_cut(WIRE_IDSCAN))
		message = "The IdScan wire is cut - IdScan feature permanently disabled."
	else if(activate && aiDisabledIdScanner)
		aiDisabledIdScanner = 0
		message = "IdScan feature has been enabled."
	else if(!activate && !aiDisabledIdScanner)
		aiDisabledIdScanner = 1
		message = "IdScan feature has been disabled."

	if(feedback && message)
		to_chat(usr,message)

/obj/machinery/door/airlock/proc/set_safeties(var/activate, var/feedback = 0)
	var/message = ""
	// Safeties!  We don't need no stinking safeties!
	if (wires.is_cut(WIRE_SAFETY))
		message = text("The safety wire is cut - Cannot enable safeties.")
	else if (!activate && safe)
		safe = 0
	else if (activate && !safe)
		safe = 1

	if(feedback && message)
		to_chat(usr,message)

// shock user with probability prb (if all connections & power are working)
// returns 1 if shocked, 0 otherwise
// The preceding comment was borrowed from the grille's shock script
/obj/machinery/door/airlock/shock(mob/user, prb)
	if(!arePowerSystemsOn())
		return FALSE
	if(hasShocked)
		return FALSE	//Already shocked someone recently?
	if(..())
		hasShocked = 1
		VARSET_IN(src, hasShocked, FALSE, 1 SECOND)
		return TRUE
	else
		return FALSE


/obj/machinery/door/airlock/update_icon()
	cut_overlays()
	if(density)
		if(locked && lights && arePowerSystemsOn())
			icon_state = "door_locked"
		else
			icon_state = "door_closed"
		if(p_open || welded)
			if(p_open)
				add_overlay("panel_open")
			if (!(stat & NOPOWER))
				if(stat & BROKEN)
					add_overlay("sparks_broken")
				else if (health < maxhealth * 3/4)
					add_overlay("sparks_damaged")
			if(welded)
				add_overlay("welded")
		else if (health < maxhealth * 3/4 && !(stat & NOPOWER))
			add_overlay("sparks_damaged")
	else
		icon_state = "door_open"
		if((stat & BROKEN) && !(stat & NOPOWER))
			add_overlay("sparks_open")
	return

/obj/machinery/door/airlock/do_animate(animation)
	switch(animation)
		if("opening")
			cut_overlay()
			if(p_open)
				flick("o_door_opening", src)  //can not use flick due to BYOND bug updating overlays right before flicking
				update_icon()
			else
				flick("door_opening", src)//[stat ? "_stat":]
				update_icon()
		if("closing")
			cut_overlay()
			if(p_open)
				flick("o_door_closing", src)
				update_icon()
			else
				flick("door_closing", src)
				update_icon()
		if("spark")
			if(density)
				flick("door_spark", src)
		if("deny")
			if(density && arePowerSystemsOn())
				flick("door_deny", src)
				playsound(src, denied_sound, 50, 0, 3)
	return

/obj/machinery/door/airlock/attack_ai(mob/user)
	tgui_interact(user)

/obj/machinery/door/airlock/attack_ghost(mob/user)
	tgui_interact(user)

/obj/machinery/door/airlock/tgui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui, datum/tgui_state/custom_state)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "AiAirlock", name)
		ui.open()
	if(custom_state)
		ui.set_state(custom_state)
	return TRUE

/obj/machinery/door/airlock/tgui_data(mob/user)
	var/list/data = list()

	var/list/power = list()
	power["main"] = main_power_lost_until > 0 ? 0 : 2
	power["main_timeleft"] = round(main_power_lost_until > 0 ? max(main_power_lost_until - world.time,	0) / 10 : main_power_lost_until, 1)
	power["backup"] = backup_power_lost_until > 0 ? 0 : 2
	power["backup_timeleft"] = round(backup_power_lost_until > 0 ? max(backup_power_lost_until - world.time, 0) / 10 : backup_power_lost_until, 1)
	data["power"] = power

	data["shock"] = (electrified_until == 0) ? 2 : 0
	data["shock_timeleft"] = round(electrified_until > 0 ? max(electrified_until - world.time, 	0) / 10 : electrified_until, 1)
	data["id_scanner"] = !aiDisabledIdScanner
	data["locked"] = locked // bolted
	data["lights"] = lights // bolt lights
	data["safe"] = safe // safeties
	data["speed"] = normalspeed // safe speed
	data["welded"] = welded // welded
	data["opened"] = !density // opened

	var/list/wire = list()
	wire["main_1"] = !wires.is_cut(WIRE_MAIN_POWER1)
	wire["main_2"] = !wires.is_cut(WIRE_MAIN_POWER2)
	wire["backup_1"] = !wires.is_cut(WIRE_BACKUP_POWER1)
	wire["backup_2"] = !wires.is_cut(WIRE_BACKUP_POWER2)
	wire["shock"] = !wires.is_cut(WIRE_ELECTRIFY)
	wire["id_scanner"] = !wires.is_cut(WIRE_IDSCAN)
	wire["bolts"] = !wires.is_cut(WIRE_DOOR_BOLTS)
	wire["lights"] = !wires.is_cut(WIRE_BOLT_LIGHT)
	wire["safe"] = !wires.is_cut(WIRE_SAFETY)
	wire["timing"] = !wires.is_cut(WIRE_SPEED)

	data["wires"] = wire
	return data

/obj/machinery/door/airlock/proc/hack(mob/user as mob)
	if(aiHacking)
		return
	aiHacking = TRUE
	spawn(20)
		//TODO: Make this take a minute
		to_chat(user, "Airlock AI control has been blocked. Beginning fault-detection.")
		sleep(50)
		if(canAIControl())
			to_chat(user, "Alert cancelled. Airlock control has been restored without our assistance.")
			aiHacking = FALSE
			return
		else if(!canAIHack(user))
			to_chat(user, "We've lost our connection! Unable to hack airlock.")
			aiHacking = FALSE
			return
		to_chat(user, "Fault confirmed: airlock control wire disabled or cut.")
		sleep(20)
		to_chat(user, "Attempting to hack into airlock. This may take some time.")
		sleep(200)
		if(canAIControl())
			to_chat(user, "Alert cancelled. Airlock control has been restored without our assistance.")
			aiHacking = FALSE
			return
		else if(!canAIHack(user))
			to_chat(user, "We've lost our connection! Unable to hack airlock.")
			aiHacking = FALSE
			return
		to_chat(user, "Upload access confirmed. Loading control program into airlock software.")
		sleep(170)
		if(canAIControl())
			to_chat(user, "Alert cancelled. Airlock control has been restored without our assistance.")
			aiHacking = FALSE
			return
		else if(!canAIHack(user))
			to_chat(user, "We've lost our connection! Unable to hack airlock.")
			aiHacking = FALSE
			return
		to_chat(user, "Transfer complete. Forcing airlock to execute program.")
		sleep(50)
		//disable blocked control
		aiControlDisabled = 2
		to_chat(user, "Receiving control information from airlock.")
		sleep(10)
		//bring up airlock dialog
		aiHacking = 0
		if (user)
			attack_ai(user)

/obj/machinery/door/airlock/CanPass(atom/movable/mover, turf/target)
	if (isElectrified())
		if (istype(mover, /obj/item))
			var/obj/item/i = mover
			if (i.matter && (MAT_STEEL in i.matter) && i.matter[MAT_STEEL] > 0)
				var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
				s.set_up(5, 1, src)
				s.start()
	. = ..()

/obj/machinery/door/airlock/attack_hand(mob/user)
	if(!issilicon(user))
		if(isElectrified())
			if(shock(user, 100))
				return

	if(!Adjacent(hold_open))
		hold_open = null

	if(hold_open && !density)
		if(hold_open == user)
			hold_open = null
		else
			to_chat(user, span_warning("[hold_open] is holding \the [src] open!"))

	if(ishuman(user))
		var/mob/living/carbon/human/X = user
		if(istype(X.species, /datum/species/xenos))
			attack_alien(user)
			return

	if(p_open)
		user.set_machine(src)
		wires.Interact(user)
		return

	. = ..()

/obj/machinery/door/airlock/CtrlClick(mob/user) //Hold door open
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(user.is_incorporeal())
		return

	if(!Adjacent(user))
		return

	if(user.a_intent == I_HURT)
		visible_message(span_warning("[user] hammers on \the [src]!"), span_warning("Someone hammers loudly on \the [src]!"))
		add_fingerprint(user)
		if(icon_state == "door_closed" && arePowerSystemsOn())
			flick("door_deny", src)
		playsound(src, knock_hammer_sound, 50, 0, 3)
		return

	if(user.a_intent == I_GRAB) //Hold door open
		hold_open = user
		visible_message(span_info("[user] begins holding \the [src] open."), span_info("Someone has started holding \the [src] open."))
		attack_hand(user)
		return

	if(arePowerSystemsOn())
		if(isElectrified())
			visible_message(span_warning("[user] presses the door bell on \the [src], making it violently spark!"), span_warning("\The [src] sparks!"))
			add_fingerprint(user)
			var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
			s.set_up(5, 1, src)
			s.start()
		else
			visible_message(span_info("[user] presses the door bell on \the [src]."), span_info("\The [src]'s bell rings."))
			add_fingerprint(user)
		if(icon_state == "door_closed")
			flick("door_deny", src)
		playsound(src, knock_sound, 50, 0, 3)
		return

	visible_message(span_info("[user] knocks on \the [src]."), span_info("Someone knocks on \the [src]."))
	add_fingerprint(user)
	playsound(src, knock_unpowered_sound, 50, 0, 3)

/obj/machinery/door/airlock/tgui_act(action, params, datum/tgui/ui)
	if(..())
		return TRUE
	if(!user_allowed(ui.user))
		return TRUE

	switch(action)
		if("disrupt-main")
			if(!main_power_lost_until)
				loseMainPower()
				update_icon()
			else
				to_chat(ui.user, span_warning("Main power is already offline."))
			. = TRUE
		if("disrupt-backup")
			if(!backup_power_lost_until)
				loseBackupPower()
				update_icon()
			else
				to_chat(ui.user, span_warning("Backup power is already offline."))
			. = TRUE
		if("shock-restore")
			electrify(0, 1)
			. = TRUE
		if("shock-temp")
			electrify(30, 1)
			. = TRUE
		if("shock-perm")
			electrify(-1, 1)
			. = TRUE
		if("idscan-toggle")
			set_idscan(aiDisabledIdScanner, 1)
			. = TRUE
		// if("emergency-toggle")
		// 	toggle_emergency(ui.user)
		// 	. = TRUE
		if("bolt-toggle")
			toggle_bolt(ui.user)
			. = TRUE
		if("light-toggle")
			if(wires.is_cut(WIRE_BOLT_LIGHT))
				to_chat(ui.user, "The bolt lights wire is cut - The door bolt lights are permanently disabled.")
				return
			lights = !lights
			update_icon()
			. = TRUE
		if("safe-toggle")
			set_safeties(!safe, 1)
			. = TRUE
		if("speed-toggle")
			if(wires.is_cut(WIRE_SPEED))
				to_chat(ui.user, "The timing wire is cut - Cannot alter timing.")
				return
			normalspeed = !normalspeed
			. = TRUE
		if("open-close")
			user_toggle_open(ui.user)
			. = TRUE

	update_icon()
	return TRUE

/obj/machinery/door/airlock/proc/user_allowed(mob/user)
	var/allowed = (issilicon(user) && canAIControl(user))
	if(!allowed && isobserver(user))
		var/mob/observer/dead/D = user
		if(D.can_admin_interact())
			allowed = TRUE
	return allowed

/obj/machinery/door/airlock/proc/toggle_bolt(mob/user)
	if(!user_allowed(user))
		return
	if(wires.is_cut(WIRE_DOOR_BOLTS))
		to_chat(user, span_warning("The door bolt drop wire is cut - you can't toggle the door bolts."))
		return
	if(locked)
		if(!arePowerSystemsOn())
			to_chat(user, span_warning("The door has no power - you can't raise the door bolts."))
		else
			unlock()
			to_chat(user, span_notice("The door bolts have been raised."))
			// log_combat(user, src, "unbolted")
	else
		lock()
		to_chat(user, span_warning("The door bolts have been dropped."))
		// log_combat(user, src, "bolted")

/obj/machinery/door/airlock/proc/user_toggle_open(mob/user)
	if(!user_allowed(user))
		return
	if(welded)
		to_chat(user, span_warning("The airlock has been welded shut!"))
	else if(locked)
		to_chat(user, span_warning("The door bolts are down!"))
	else if(!density)
		if(hold_open)
			if(hold_open == user)
				hold_open = null
				close()
			else
				to_chat(user, span_warning("[hold_open] is holding \the [src] open!"))
				return
		close()
	else
		open()

/obj/machinery/door/airlock/proc/can_remove_electronics()
	return p_open && (operating < 0 || (!operating && welded && !arePowerSystemsOn() && density && (!locked || (stat & BROKEN))))

/obj/machinery/door/airlock/attackby(obj/item/C, mob/user)
	if(!issilicon(user))
		if(isElectrified() && shock(user, 75))
			return

	if(istype(C, /obj/item/taperoll))
		return

	add_fingerprint(user)

	if(!reinforcing && C.has_tool_quality(TOOL_WELDER) && !(operating > 0) && density && (health >= maxhealth || user.a_intent != I_HELP))
		var/obj/item/weldingtool/W = C.get_welder()
		if(W.remove_fuel(0,user))
			if(!welded)
				welded = TRUE
			else
				welded = null
			playsound(src, C.usesound, 75, 1)
			update_icon()
		return

	if(C.has_tool_quality(TOOL_SCREWDRIVER))
		if(!p_open)
			p_open = TRUE
			playsound(src, C.usesound, 50, 1)
			update_icon()
			return attack_hand(user)
		if(stat & BROKEN)
			to_chat(user, span_warning("The panel is broken and cannot be closed."))
			return
		p_open = FALSE
		playsound(src, C.usesound, 50, 1)
		update_icon()
		return

	if(C.has_tool_quality(TOOL_WIRECUTTER))
		return attack_hand(user)

	if(istype(C, /obj/item/multitool))
		return attack_hand(user)

	if(istype(C, /obj/item/assembly/signaler))
		return attack_hand(user)

	if(istype(C, /obj/item/pai_cable))	// -- TLE
		var/obj/item/pai_cable/cable = C
		cable.plugin(src, user)
		return

	if(!reinforcing && C.has_tool_quality(TOOL_CROWBAR) && user.a_intent != I_HURT) // So harm intent can smash airlocks
		if(can_remove_electronics())
			playsound(src, C.usesound, 75, 1)
			user.visible_message("[user] removes the electronics from the airlock assembly.", "You start to remove electronics from the airlock assembly.")
			if(do_after(user, 4 SECONDS * C.toolspeed, target = src))
				to_chat(user, span_notice("You removed the airlock electronics!"))

				var/obj/structure/door_assembly/da = new assembly_type(get_turf(src))
				if (istype(da, /obj/structure/door_assembly/multi_tile))
					da.set_dir(dir)
				da.anchored = TRUE
				if(mineral)
					da.glass = mineral
				//else if(glass)
				else if(glass && !da.glass)
					da.glass = 1
				da.state = 1
				da.created_name = name
				da.update_state()

				if(operating == -1 || (stat & BROKEN))
					new /obj/item/circuitboard/broken(get_turf(src))
					operating = 0
				else
					if (!electronics) create_electronics()

					electronics.forceMove(get_turf(src))
					electronics = null
				qdel(src)
			return

		if(arePowerSystemsOn())
			to_chat(user, span_notice("The airlock's motors resist your efforts to force it."))
			return
		if(locked)
			to_chat(user, span_notice("The airlock's bolts prevent it from being forced."))
			return

		// Force doors open/closed
		if(density)
			open(TRUE)
		else
			close(1)
		return

	// Check if we're using a crowbar or armblade, and if the airlock's unpowered for whatever reason (off, broken, etc).
	if(istype(C, /obj/item))
		var/obj/item/W = C
		if(W.pry && !arePowerSystemsOn())
			if(locked)
				to_chat(user, span_notice("The airlock's bolts prevent it from being forced."))
				return

			if(!welded && !operating)
				if(istype(C, /obj/item/material/twohanded/fireaxe)) // If this is a fireaxe, make sure it's held in two hands.
					var/obj/item/material/twohanded/fireaxe/F = C
					if(!F.wielded)
						to_chat(user, span_warning("You need to be wielding \the [F] to do that."))
						return
				// At this point, it's an armblade or a fireaxe that passed the wielded test, let's try to open it.
				if(density)
					open(TRUE)
				else
					close(1)
				return
	. = ..()

/obj/machinery/door/airlock/set_broken()
	p_open = TRUE
	stat |= BROKEN
	if (secured_wires)
		lock()
	for (var/mob/O in viewers(src, null))
		if ((O.client && !( O.blinded )))
			O.show_message("[name]'s control panel bursts open, sparks spewing out!")

	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(5, 1, src)
	s.start()

	update_icon()
	return

/obj/machinery/door/airlock/open(var/forced=0)
	if(!can_open(forced))
		return FALSE
	use_power(360)	//360 W seems much more appropriate for an actuator moving an industrial door capable of crushing people

	if(hold_open)
		visible_message("[hold_open] holds \the [src] open.")

	//if the door is unpowered then it doesn't make sense to hear the woosh of a pneumatic actuator
	for(var/mob/M as anything in GLOB.player_list)
		if(!M || !M.client)
			continue
		var/old_sounds = M.read_preference(/datum/preference/toggle/old_door_sounds)
		var/department_door_sounds = M.read_preference(/datum/preference/toggle/department_door_sounds)
		var/sound
		var/volume
		if(old_sounds) // Do we have old sounds enabled? Play these even if we have department door sounds enabled.
			if(arePowerSystemsOn())
				sound = legacy_open_powered
				volume = 50
			else
				sound = open_sound_unpowered
				volume = 75
		else if(!old_sounds && department_door_sounds && department_open_powered) // Else, we have old sounds disabled, the door has per-department door sounds, and we have chosen to play department door sounds, use these.
			if(arePowerSystemsOn())
				sound = department_open_powered
				volume = 50
			else
				sound = open_sound_unpowered
				volume = 75
		else // Else, play these.
			if(arePowerSystemsOn())
				sound = open_sound_powered
				volume = 50
			else
				sound = open_sound_unpowered
				volume = 75

		var/turf/T = get_turf(M)
		var/distance = get_dist(T, get_turf(src))
		if(distance <= world.view * 2)
			if(T && T.z == get_z(src))
				M.playsound_local(get_turf(src), sound, volume, 1, null, 0, TRUE, sound(sound), volume_channel = VOLUME_CHANNEL_DOORS)

	SSmotiontracker.ping(src,100)

	if(closeOther != null && istype(closeOther, /obj/machinery/door/airlock/) && !closeOther.density)
		closeOther.close()
	. = ..()

/obj/machinery/door/airlock/can_open(var/forced=0)
	if(!forced)
		if(!arePowerSystemsOn() || wires.is_cut(WIRE_OPEN_DOOR))
			return FALSE

	if(locked || welded)
		return FALSE
	. = ..()

/obj/machinery/door/airlock/can_close(var/forced=0)
	if(locked || welded)
		return FALSE
	if(!forced)
		//despite the name, this wire is for general door control.
		if(hold_open)
			if(Adjacent(hold_open) && !hold_open.incapacitated())
				return FALSE
			else
				hold_open = null
		if(!arePowerSystemsOn() || wires.is_cut(WIRE_OPEN_DOOR))
			return	0
	. = ..()

/atom/movable/proc/blocks_airlock()
	return density

/obj/machinery/door/blocks_airlock()
	return FALSE

/obj/machinery/mech_sensor/blocks_airlock()
	return FALSE

/mob/living/blocks_airlock()
	return !is_incorporeal()

/atom/movable/proc/airlock_crush(var/crush_damage)
	return FALSE

/obj/machinery/portable_atmospherics/canister/airlock_crush(var/crush_damage)
	. = ..()
	health -= crush_damage
	healthcheck()

/obj/effect/energy_field/airlock_crush(var/crush_damage)
	adjust_strength(crush_damage)

/obj/structure/closet/airlock_crush(var/crush_damage)
	..()
	damage(crush_damage)
	for(var/atom/movable/AM in src)
		AM.airlock_crush()
	return TRUE

/mob/living/airlock_crush(var/crush_damage)
	if(is_incorporeal())
		return FALSE
	. = ..()
	var/turf/T = get_turf(src)
	adjustBruteLoss(crush_damage)
	SetStunned(5)
	SetWeakened(5)
	if(T)
		T.add_blood(src)
	return TRUE

/mob/living/carbon/airlock_crush(var/crush_damage)
	. = ..()
	if(. && can_feel_pain()) // Only scream if actually crushed!
		emote("scream")

/mob/living/silicon/robot/airlock_crush(var/crush_damage)
	adjustBruteLoss(crush_damage)
	return FALSE

/obj/machinery/door/airlock/close(var/forced= FALSE, var/ignore_safties = FALSE, var/crush_damage = DOOR_CRUSH_DAMAGE)
	if(!can_close(forced))
		return FALSE

	hold_open = null //if it passes the can close check, always make sure to clear hold open

	if(safe && !ignore_safties)
		for(var/turf/turf in locs)
			for(var/atom/movable/AM in turf)
				if(AM.blocks_airlock())
					if(!has_beeped)
						playsound(src, 'sound/machines/buzz-two.ogg', 50, 0)
						has_beeped = 1
					autoclose_in(6)
					return

	for(var/turf/turf in locs)
		for(var/atom/movable/AM in turf)
			if(AM.airlock_crush(crush_damage))
				take_damage(crush_damage)

	use_power(360)	//360 W seems much more appropriate for an actuator moving an industrial door capable of crushing people
	has_beeped = 0
	for(var/mob/M as anything in GLOB.player_list)
		if(!M || !M.client)
			continue
		var/old_sounds = M.read_preference(/datum/preference/toggle/old_door_sounds)
		var/department_door_sounds = M.read_preference(/datum/preference/toggle/department_door_sounds)
		var/sound
		var/volume
		if(old_sounds)
			if(arePowerSystemsOn())
				sound = legacy_close_powered
				volume = 50
			else
				sound = open_sound_unpowered
				volume = 75
		else if(!old_sounds && department_door_sounds && department_close_powered) // Else, we have old sounds disabled, the door has per-department door sounds, and we have chosen to play department door sounds, use these.
			if(arePowerSystemsOn())
				sound = department_close_powered
				volume = 50
			else
				sound = open_sound_unpowered
				volume = 75
		else
			if(arePowerSystemsOn())
				sound = close_sound_powered
				volume = 50
			else
				sound = open_sound_unpowered
				volume = 75

		var/turf/T = get_turf(M)
		var/distance = get_dist(T, get_turf(src))
		if(distance <= world.view * 2)
			if(T && T.z == get_z(src))
				M.playsound_local(get_turf(src), sound, volume, 1, null, 0, TRUE, sound(sound), volume_channel = VOLUME_CHANNEL_DOORS)

	SSmotiontracker.ping(src,100)

	for(var/turf/turf in locs)
		var/obj/structure/window/killthis = (locate(/obj/structure/window) in turf)
		if(killthis)
			killthis.ex_act(2)//Smashin windows
	. = ..()

/obj/machinery/door/airlock/proc/lock(var/forced=0)
	if(locked)
		return FALSE

	if (operating && !forced) return FALSE

	locked = TRUE
	SEND_SIGNAL(src, COMSIG_AIRLOCK_SET_BOLT, locked)
	playsound(src, bolt_down_sound, 30, 0, 3, volume_channel = VOLUME_CHANNEL_DOORS)
	for(var/mob/M in range(1,src))
		M.show_message("You hear a click from the bottom of the door.", 2)
	update_icon()
	return TRUE

/obj/machinery/door/airlock/proc/unlock(var/forced=0)
	if(!locked)
		return

	if (!forced)
		if(operating || !arePowerSystemsOn() || wires.is_cut(WIRE_DOOR_BOLTS)) return

	locked = FALSE
	SEND_SIGNAL(src, COMSIG_AIRLOCK_SET_BOLT, locked)
	playsound(src, bolt_up_sound, 30, 0, 3, volume_channel = VOLUME_CHANNEL_DOORS)
	for(var/mob/M in range(1,src))
		M.show_message("You hear a click from the bottom of the door.", 2)
	update_icon()
	return TRUE

/obj/machinery/door/airlock/allowed(mob/M)
	if(locked)
		return FALSE
	. = ..()

/obj/machinery/door/airlock/Initialize(mapload, var/obj/structure/door_assembly/assembly=null)
	//if assembly is given, create the new door from the assembly
	if (assembly && istype(assembly))
		assembly_type = assembly.type

		electronics = assembly.electronics
		electronics.loc = src

		//update the door's access to match the electronics'
		secured_wires = electronics.secure
		if(electronics.one_access)
			LAZYCLEARLIST(req_access)
			req_one_access = electronics.conf_access
		else
			LAZYCLEARLIST(req_one_access)
			req_access = electronics.conf_access

		//get the name from the assembly
		if(assembly.created_name)
			name = assembly.created_name
		else
			name = "[istext(assembly.glass) ? "[assembly.glass] airlock" : assembly.base_name]"

		//get the dir from the assembly
		set_dir(assembly.dir)

	//wires
	var/turf/T = get_turf(src)
	if(T && (T.z in using_map.admin_levels))
		secured_wires = 1
	if (secured_wires)
		wires = new/datum/wires/airlock/secure(src)
	else
		wires = new/datum/wires/airlock(src)

	. = ..()

	if(closeOtherId != null)
		for (var/obj/machinery/door/airlock/A in GLOB.machines)
			if(A.closeOtherId == closeOtherId && A != src)
				closeOther = A
				break
	name = "\improper [name]"
	if(frequency)
		set_frequency(frequency)
	update_icon()

/obj/machinery/door/airlock/Destroy()
	qdel(wires)
	wires = null
	. = ..()

// Most doors will never be deconstructed over the course of a round,
// so as an optimization defer the creation of electronics until
// the airlock is deconstructed
/obj/machinery/door/airlock/proc/create_electronics()
	//create new electronics
	if (secured_wires)
		electronics = new/obj/item/airlock_electronics/secure(get_turf(src))
	else
		electronics = new/obj/item/airlock_electronics(get_turf(src))

	//update the electronics to match the door's access
	if(LAZYLEN(req_access))
		electronics.conf_access = req_access
	else if (LAZYLEN(req_one_access))
		electronics.conf_access = req_one_access
		electronics.one_access = 1

/obj/machinery/door/airlock/emp_act(var/severity)
	if(prob(40/severity))
		var/duration = world.time + ((30 / severity) SECONDS)
		if(duration > electrified_until)
			electrify(duration)
	..()

/obj/machinery/door/airlock/power_change() //putting this is obj/machinery/door itself makes non-airlock doors turn invisible for some reason
	..()
	if(stat & NOPOWER)
		// If we lost power, disable electrification
		// Keeping door lights on, runs on internal battery or something.
		electrified_until = 0
	update_icon()

/obj/machinery/door/airlock/proc/prison_open()
	if(arePowerSystemsOn())
		unlock()
		open()
		lock()
	return

/obj/machinery/door/airlock/rcd_values(mob/living/user, obj/item/rcd/the_rcd, passed_mode)
	switch(passed_mode)
		if(RCD_DECONSTRUCT)
			// Old RCD code made it cost 10 units to decon an airlock.
			// Now the new one costs ten "sheets".
			return list(
				RCD_VALUE_MODE = RCD_DECONSTRUCT,
				RCD_VALUE_DELAY = 5 SECONDS,
				RCD_VALUE_COST = RCD_SHEETS_PER_MATTER_UNIT * 10
			)
	return FALSE

/obj/machinery/door/airlock/rcd_act(mob/living/user, obj/item/rcd/the_rcd, passed_mode)
	switch(passed_mode)
		if(RCD_DECONSTRUCT)
			to_chat(user, span_notice("You deconstruct \the [src]."))
			qdel(src)
			return TRUE
	return FALSE
