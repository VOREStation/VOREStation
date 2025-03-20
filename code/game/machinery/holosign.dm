////////////////////HOLOSIGN///////////////////////////////////////
/obj/machinery/holosign
	name = "holosign"
	desc = "Small wall-mounted holographic projector"
	icon = 'icons/obj/holosign.dmi'
	icon_state = "sign_off"
	plane = MOB_PLANE
	use_power = USE_POWER_IDLE
	idle_power_usage = 2
	active_power_usage = 4
	anchored = TRUE
	var/lit = 0
	var/id = null
	var/on_icon = "sign_on"
	var/off_icon = "sign_off"
	var/signlight = "#E9E4AF"

/obj/machinery/holosign/proc/toggle()
	if(stat & (BROKEN|NOPOWER))
		return
	lit = !lit
	update_use_power(lit ? USE_POWER_ACTIVE : USE_POWER_IDLE)
	update_icon()

/obj/machinery/holosign/update_icon()
	if(!lit)
		icon_state = off_icon
		set_light(0)
	else
		icon_state = on_icon
		set_light(2, 0.25, signlight)

/obj/machinery/holosign/power_change()
	..()
	if(stat & NOPOWER)
		lit = 0
		update_use_power(USE_POWER_OFF)

	update_icon()

/obj/machinery/holosign/surgery
	name = "surgery holosign"
	desc = "Small wall-mounted holographic projector. This one reads SURGERY."
	on_icon = "surgery"

/obj/machinery/holosign/exit
	name = "exit holosign"
	desc = "Small wall-mounted holographic projector. This one reads EXIT."
	on_icon = "emergencyexit"

/obj/machinery/holosign/bar
	name = "bar holosign"
	desc = "Small wall-mounted holographic projector. This one reads OPEN."
	icon_state = "barclosed"
	on_icon = "baropen"
	off_icon = "barclosed"
	signlight = "#b1edf9"

////////////////////SWITCH///////////////////////////////////////

/obj/machinery/button/holosign
	name = "holosign switch"
	desc = "A remote control switch for holosign."
	icon = 'icons/obj/power.dmi'
	icon_state = "crema_switch"

/obj/machinery/button/holosign/attack_hand(mob/user as mob)
	if(..())
		return
	add_fingerprint(user)

	use_power(5)

	active = !active
	icon_state = "light[active]"

	for(var/obj/machinery/holosign/M in machines)
		if(M.id == id)
			spawn(0)
				M.toggle()
				return

	return
