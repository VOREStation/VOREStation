////////////////////NOTHOLOSIGN///////////////////////////////////////
/obj/machinery/neonsign
	name = "neon sign"
	desc = "Small wall-mounted electronic sign"
	icon = 'icons/obj/neonsigns.dmi'
	icon_state = "sign_off"
	plane = MOB_PLANE
	use_power = 1
	idle_power_usage = 2
	active_power_usage = 4
	anchored = 1
	var/lit = 0
	var/id = null
	var/on_icon = "sign_on"
	var/off_icon = "sign_off"
	var/signlight = "#E9E4AF"

/obj/machinery/neonsign/proc/toggle()
	if(stat & (BROKEN|NOPOWER))
		return
	lit = !lit
	use_power = lit ? 2 : 1
	update_icon()

/obj/machinery/neonsign/update_icon()
	if(!lit)
		icon_state = off_icon
		set_light(0)
	else
		icon_state = on_icon
		set_light(2, 0.25, signlight)

/obj/machinery/neonsign/power_change()
	..()
	if(stat & NOPOWER)
		lit = 0
		use_power = 0

	update_icon()

/obj/machinery/neonsign/cafe
	name = "cafe neon sign"
	desc = "Small wall-mounted electronic sign. This one reads CAFE."
	icon_state = "cafesign_off"
	on_icon = "cafesign_on"
	off_icon = "cafesign_off"
	signlight = "#DFA571"

////////////////////SWITCH///////////////////////////////////////

/obj/machinery/button/neonsign
	name = "sign switch"
	desc = "A remote control switch for neon sign."
	icon = 'icons/obj/power.dmi'
	icon_state = "crema_switch"

/obj/machinery/button/neonsign/attack_hand(mob/user as mob)
	if(..())
		return
	add_fingerprint(user)

	use_power(5)

	active = !active
	icon_state = "light[active]"

	for(var/obj/machinery/neonsign/M in machines)
		if(M.id == id)
			spawn(0)
				M.toggle()
				return

	return