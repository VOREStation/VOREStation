
GLOBAL_LIST_EMPTY(gravity_generators)

//
// Gravity Generator
//

#define POWER_IDLE 0
#define POWER_UP 1
#define POWER_DOWN 2

#define GRAV_NEEDS_SCREWDRIVER 0
#define GRAV_NEEDS_WELDING 1
#define GRAV_NEEDS_PLASTEEL 2
#define GRAV_NEEDS_WRENCH 3

//
// Abstract Generator
//

/obj/machinery/gravity_generator
	name = "gravitational generator"
	desc = "A device which produces a graviton field when set up."
	icon = 'icons/obj/machines/gravity_generator.dmi'
	anchored = TRUE
	density = TRUE
	unacidable = TRUE
	use_power = USE_POWER_OFF
	var/sprite_number = 0

	pixel_y = 16

/obj/machinery/gravity_generator/ex_act(severity, target)
	if(severity == 1) // Very sturdy.
		set_broken()

/obj/machinery/gravity_generator/blob_act(obj/structure/blob/B)
	if(prob(20))
		set_broken()

/obj/machinery/gravity_generator/tesla_act(power, tesla_flags)
	..()
	qdel(src)//like the singulo, tesla deletes it. stops it from exploding over and over

/obj/machinery/gravity_generator/update_icon()
	icon_state = "[get_status()]_[sprite_number]"

/obj/machinery/gravity_generator/proc/get_status()
	return "off"

// You aren't allowed to move.
/obj/machinery/gravity_generator/Moved(atom/old_loc, direction, forced = FALSE)
	. = ..()
	qdel(src)

/obj/machinery/gravity_generator/proc/set_broken()
	stat |= BROKEN

/obj/machinery/gravity_generator/proc/set_fix()
	stat &= ~BROKEN

/obj/machinery/gravity_generator/part/Destroy()
	if(main_part)
		qdel(main_part)
	set_broken()
	return ..()

//
// Part generator which is mostly there for looks
//

/obj/machinery/gravity_generator/part
	var/obj/machinery/gravity_generator/main/main_part = null

/obj/machinery/gravity_generator/part/attackby(obj/item/I, mob/user, params)
	return main_part.attackby(I, user)

/obj/machinery/gravity_generator/part/get_status()
	return main_part?.get_status()

/obj/machinery/gravity_generator/part/attack_hand(mob/user)
	return main_part.attack_hand(user)

/obj/machinery/gravity_generator/part/set_broken()
	..()
	if(main_part && !(main_part.stat & BROKEN))
		main_part.set_broken()

//
// Generator which spawns with the station.
//
/obj/machinery/gravity_generator/main/station
	use_power = USE_POWER_ACTIVE
	current_overlay = "activated"

/obj/machinery/gravity_generator/main/station/Initialize(mapload)
	. = ..()
	setup_parts()
	middle.add_overlay("activated")

//
// Generator an admin can spawn
//
/obj/machinery/gravity_generator/main/station/admin
	use_power = USE_POWER_OFF

//
// Main Generator with the main code
//

/obj/machinery/gravity_generator/main
	icon_state = "on_8"
	idle_power_usage = 0
	active_power_usage = 3000
	power_channel = ENVIRON
	sprite_number = 8
	use_power = USE_POWER_IDLE

	var/on = TRUE
	var/breaker = TRUE
	var/list/parts = list()
	var/obj/middle = null
	var/charging_state = POWER_IDLE
	var/charge_count = 100
	var/current_overlay = null
	var/broken_state = 0
	var/list/levels = list()
	var/list/areas = list()

/obj/machinery/gravity_generator/main/Initialize(mapload)
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/gravity_generator/main/LateInitialize() //Needs to happen after overmap sectors are initialized so we can figure out where we are
	update_list()
	update_areas()

/obj/machinery/gravity_generator/main/set_fix()
	. = ..()
	update_list()
	update_areas()

/obj/machinery/gravity_generator/main/Destroy() // If we somehow get deleted, remove all of our other parts.
	investigate_log("was destroyed!", "gravity")
	on = FALSE
	update_list()
	if(!gravity_in_level())
		update_gravity(FALSE)
	for(var/obj/machinery/gravity_generator/part/O in parts)
		O.main_part = null
		if(!QDESTROYING(O))
			qdel(O)
	return ..()

/obj/machinery/gravity_generator/main/proc/setup_parts()
	var/turf/our_turf = get_turf(src)
	// 9x9 block obtained from the bottom middle of the block
	var/list/spawn_turfs = block(locate(our_turf.x - 1, our_turf.y + 2, our_turf.z), locate(our_turf.x + 1, our_turf.y, our_turf.z))
	var/count = 10
	for(var/turf/T in spawn_turfs)
		count--
		if(T == our_turf) // Skip our turf.
			continue
		var/obj/machinery/gravity_generator/part/part = new(T)
		if(count == 5) // Middle
			middle = part
		if(count <= 3) // Their sprite is the top part of the generator
			part.density = FALSE
			part.plane = MOB_PLANE
			part.layer = ABOVE_MOB_LAYER
		part.sprite_number = count
		part.main_part = src
		parts += part
		part.update_icon()

/obj/machinery/gravity_generator/main/proc/connected_parts()
	return parts.len == 8

/obj/machinery/gravity_generator/main/set_broken()
	..()
	for(var/obj/machinery/gravity_generator/M in parts)
		if(!(M.stat & BROKEN))
			M.set_broken()
	middle.cut_overlays()
	charge_count = 0
	breaker = FALSE
	set_power()
	set_state(0)
	investigate_log("has broken down.", "gravity")

/obj/machinery/gravity_generator/main/set_fix()
	..()
	for(var/obj/machinery/gravity_generator/M in parts)
		if(M.stat & BROKEN)
			M.set_fix()
	broken_state = FALSE
	update_icon()
	set_power()

// Interaction

// Fixing the gravity generator.
/obj/machinery/gravity_generator/main/attackby(obj/item/I, mob/user, params)
	switch(broken_state)
		if(GRAV_NEEDS_SCREWDRIVER)
			if(I.has_tool_quality(TOOL_SCREWDRIVER))
				to_chat(user, span_notice("You secure the screws of the framework."))
				playsound(src, I.usesound, 75, 1)
				broken_state++
				update_icon()
				return
		if(GRAV_NEEDS_WELDING)
			if(I.has_tool_quality(TOOL_WELDER))
				var/obj/item/weldingtool/W = I.get_welder()
				if(W.remove_fuel(0,user))
					to_chat(user, span_notice("You mend the damaged framework."))
					broken_state++
					update_icon()
				return
		if(GRAV_NEEDS_PLASTEEL)
			if(istype(I, /obj/item/stack/material/plasteel))
				var/obj/item/stack/material/plasteel/PS = I
				if(PS.get_amount() >= 10)
					PS.use(10)
					to_chat(user, span_notice("You add the plating to the framework."))
					playsound(src, 'sound/machines/click.ogg', 75, 1)
					broken_state++
					update_icon()
				else
					to_chat(user, span_warning("You need 10 sheets of plasteel!"))
				return
		if(GRAV_NEEDS_WRENCH)
			if(I.has_tool_quality(TOOL_WRENCH))
				to_chat(user, span_notice("You secure the plating to the framework."))
				playsound(src, I.usesound, 75, 1)
				set_fix()
				return
	return ..()

/obj/machinery/gravity_generator/main/attack_hand(mob/user)
	if((. = ..()))
		return
	tgui_interact(user)
	return TRUE

/obj/machinery/gravity_generator/main/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "GravityGenerator", name)
		ui.open()

/obj/machinery/gravity_generator/main/tgui_data(mob/user)
	var/data[0]

	data["breaker"] = breaker
	data["charge_count"] = charge_count
	data["charging_state"] = charging_state
	data["on"] = on
	data["operational"] = (stat & BROKEN) ? FALSE : TRUE

	return data

/obj/machinery/gravity_generator/main/tgui_act(action, params, datum/tgui/ui)
	if((..()))
		return TRUE

	switch(action)
		if("gentoggle")
			breaker = !breaker
			investigate_log("was toggled [breaker ? span_green("ON") : span_red("OFF")] by [key_name(ui.user)].", "gravity")
			set_power()
			return TOPIC_REFRESH

// Power and Icon States

/obj/machinery/gravity_generator/main/power_change()
	..()
	investigate_log("has [stat & NOPOWER ? "lost" : "regained"] power.", "gravity")
	set_power()

/obj/machinery/gravity_generator/main/get_status()
	if(stat & BROKEN)
		return "fix[min(broken_state, 3)]"
	return on || charging_state != POWER_IDLE ? "on" : "off"

// Set the charging state based on power/breaker.
/obj/machinery/gravity_generator/main/proc/set_power()
	var/new_state = FALSE
	if(stat & (NOPOWER|BROKEN) || !breaker)
		new_state = FALSE
	else if(breaker)
		new_state = TRUE

	// Charging state FSM
	switch(charging_state)
		if(POWER_UP)
			if(!new_state) // Can start spin down during spin up
				charging_state = POWER_DOWN
		if(POWER_DOWN)
			if(new_state) // Can start spin up during spin down
				charging_state = POWER_UP
		if(POWER_IDLE)
			if(!new_state && use_power == USE_POWER_ACTIVE) // Can start spin down during running
				charging_state = POWER_DOWN
			else if(new_state && use_power == USE_POWER_IDLE) // Can start spin up during stopped
				charging_state = POWER_UP

	investigate_log("is now [charging_state == POWER_UP ? "charging" : "discharging"].", "gravity")
	update_icon()

// Set the state of the gravity.
/obj/machinery/gravity_generator/main/proc/set_state(new_state)
	charging_state = POWER_IDLE
	update_use_power(new_state ? USE_POWER_ACTIVE : USE_POWER_IDLE)

	// Sound the alert if gravity was just enabled or disabled.
	var/alert = FALSE
	if(SSticker.IsRoundInProgress())
		if(new_state) // If we turned on and the game is live.
			if(gravity_in_level() == FALSE)
				alert = TRUE
				investigate_log("was brought online and is now producing gravity for this level.", "gravity")
				message_admins("The gravity generator was brought online [ADMIN_JMP(src)]")
		else
			if(gravity_in_level() == TRUE)
				alert = TRUE
				investigate_log("was brought offline and there is now no gravity for this level.", "gravity")
				message_admins("The gravity generator was brought offline with no backup generator. [ADMIN_JMP(src)]")

	update_list()
	update_gravity(new_state)
	update_icon()
	src.updateUsrDialog()

	if(alert)
		shake_everyone()

// Charge/Discharge and turn on/off gravity when you reach 0/100 percent.
// Also emit radiation and handle the overlays.
/obj/machinery/gravity_generator/main/process()
	if(stat & BROKEN)
		return
	if(charging_state != POWER_IDLE)
		if(charging_state == POWER_UP && charge_count >= 100)
			set_state(1)
		else if(charging_state == POWER_DOWN && charge_count <= 0)
			set_state(0)
		else
			if(charging_state == POWER_UP)
				charge_count += 2
			else if(charging_state == POWER_DOWN)
				charge_count -= 2

			if(charge_count % 4 == 0 && prob(75)) // Let them know it is charging/discharging.
				playsound(src, 'sound/effects/empulse.ogg', 100, 1)

			updateDialog()
			if(prob(25)) // To help stop "Your clothes feel warm." spam.
				pulse_radiation()

			var/overlay_state = null
			switch(charge_count)
				if(0 to 20)
					overlay_state = null
				if(21 to 40)
					overlay_state = "startup"
				if(41 to 60)
					overlay_state = "idle"
				if(61 to 80)
					overlay_state = "activating"
				if(81 to 100)
					overlay_state = "activated"

			if(overlay_state != current_overlay)
				if(middle)
					middle.cut_overlays()
					if(overlay_state)
						middle.add_overlay(overlay_state)
					current_overlay = overlay_state


/obj/machinery/gravity_generator/main/proc/pulse_radiation()
	SSradiation.radiate(src, 200)

/obj/machinery/gravity_generator/main/proc/update_gravity(var/on)
	for(var/area/A in src.areas)
		A.gravitychange(on)

// Shake everyone on the z level to let them know that gravity was enagaged/disenagaged.
/obj/machinery/gravity_generator/main/proc/shake_everyone()
	var/sound/alert_sound = sound('sound/effects/alert.ogg')
	for(var/mob/M as anything in player_list)
		if(!(M.z in levels))
			continue
		M.update_gravity(M.mob_get_gravity())
		shake_camera(M, 15, 1)
		M.playsound_local(src, null, 50, 1, 0.5, S = alert_sound)

/obj/machinery/gravity_generator/main/proc/gravity_in_level()
	var/my_z = get_z(src)
	if(!my_z)
		return FALSE
	if(GLOB.gravity_generators["[my_z]"])
		return length(GLOB.gravity_generators["[my_z]"])
	return FALSE

/obj/machinery/gravity_generator/main/proc/update_list()
	levels.Cut()
	var/my_z = get_z(src)

	//Actually doing it special this time instead of letting using_map decide
	if(using_map.use_overmap)
		var/obj/effect/overmap/visitable/S = get_overmap_sector(my_z)
		if(S)
			levels = S.get_space_zlevels() //Just the spacey ones
		else
			levels = GetConnectedZlevels(my_z)
	else
		levels = GetConnectedZlevels(my_z)

	for(var/z in levels)
		if(!GLOB.gravity_generators["[z]"])
			GLOB.gravity_generators["[z]"] = list()
		if(use_power == USE_POWER_ACTIVE)
			GLOB.gravity_generators["[z]"] |= src
		else
			GLOB.gravity_generators["[z]"] -= src

/obj/machinery/gravity_generator/main/proc/update_areas()
	areas.Cut()
	for(var/area/A)
		if(istype(A, /area/shuttle))
			continue //Skip shuttle areas
		if(A.z in levels)
			areas += A

// Misc
/*
/obj/item/paper/guides/jobs/engi/gravity_gen
	name = "paper- 'Generate your own gravity!'"
	info = {"<h1>Gravity Generator Instructions For Dummies</h1>
	<p>Surprisingly, gravity isn't that hard to make! All you have to do is inject deadly radioactive minerals into a ball of
	energy and you have yourself gravity! You can turn the machine on or off when required but you must remember that the generator
	will EMIT RADIATION when charging or discharging, you can tell it is charging or discharging by the noise it makes, so please WEAR PROTECTIVE CLOTHING.</p>
	<br>
	<h3>It blew up!</h3>
	<p>Don't panic! The gravity generator was designed to be easily repaired. If, somehow, the sturdy framework did not survive then
	please proceed to panic; otherwise follow these steps.</p><ol>
	<li>Secure the screws of the framework with a screwdriver.</li>
	<li>Mend the damaged framework with a welding tool.</li>
	<li>Add additional plasteel plating.</li>
	<li>Secure the additional plating with a wrench.</li></ol>"}
*/
#undef POWER_IDLE
#undef POWER_UP
#undef POWER_DOWN

#undef GRAV_NEEDS_SCREWDRIVER
#undef GRAV_NEEDS_WELDING
#undef GRAV_NEEDS_PLASTEEL
#undef GRAV_NEEDS_WRENCH
