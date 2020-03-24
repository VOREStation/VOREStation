/obj/machinery/shield_diffuser
	name = "shield diffuser"
	desc = "A small underfloor device specifically designed to disrupt energy barriers."
	description_info = "This device disrupts shields on directly adjacent tiles (in a + shaped pattern). They are commonly installed around exterior airlocks to prevent shields from blocking EVA access."
	icon = 'icons/obj/machines/shielding.dmi'
	icon_state = "fdiffuser_on"
	use_power = USE_POWER_ACTIVE
	idle_power_usage = 25		// Previously 100.
	active_power_usage = 500	// Previously 2000
	anchored = 1
	density = 0
	level = 1
	var/alarm = 0
	var/enabled = 1

/obj/machinery/shield_diffuser/New()
	..()
	var/turf/T = get_turf(src)
	hide(!T.is_plating())

//If underfloor, hide the cable
/obj/machinery/shield_diffuser/hide(var/i)
	if(istype(loc, /turf))
		invisibility = i ? 101 : 0
	update_icon()

/obj/machinery/shield_diffuser/hides_under_flooring()
	return 1

/obj/machinery/shield_diffuser/process()
	if(alarm)
		alarm--
		if(!alarm)
			update_icon()
		return

	if(!enabled)
		return
	for(var/direction in cardinal)
		var/turf/simulated/shielded_tile = get_step(get_turf(src), direction)
		for(var/obj/effect/energy_field/S in shielded_tile)
			qdel(S)

/obj/machinery/shield_diffuser/update_icon()
	if(alarm)
		icon_state = "fdiffuser_emergency"
		return
	if((stat & (NOPOWER | BROKEN)) || !enabled)
		icon_state = "fdiffuser_off"
	else
		icon_state = "fdiffuser_on"

/obj/machinery/shield_diffuser/attack_hand()
	if(alarm)
		to_chat(usr, "You press an override button on \the [src], re-enabling it.")
		alarm = 0
		update_icon()
		return
	enabled = !enabled
	update_use_power(enabled ? USE_POWER_ACTIVE : USE_POWER_IDLE)
	update_icon()
	to_chat(usr, "You turn \the [src] [enabled ? "on" : "off"].")

/obj/machinery/shield_diffuser/proc/meteor_alarm(var/duration)
	if(!duration)
		return
	alarm = round(max(alarm, duration))
	update_icon()

/obj/machinery/shield_diffuser/examine(var/mob/user)
	. = ..()
	to_chat(user, "It is [enabled ? "enabled" : "disabled"].")
	if(alarm)
		to_chat(user, "A red LED labeled \"Proximity Alarm\" is blinking on the control panel.")