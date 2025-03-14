/obj/machinery/computer/gyrotron_control
	name = "gyrotron control console"
	desc = "Used to control the R-UST stability beams."
	light_color = COLOR_BLUE
	circuit = /obj/item/circuitboard/gyrotron_control

	icon_keyboard = "generic_key"
	icon_screen = "mass_driver"

	var/id_tag
	var/scan_range = 25
	var/datum/tgui_module/gyrotron_control/monitor

/obj/machinery/computer/gyrotron_control/Initialize(mapload)
	. = ..()
	monitor = new(src)
	monitor.gyro_tag = id_tag
	monitor.scan_range = scan_range

/obj/machinery/computer/gyrotron_control/Destroy()
	QDEL_NULL(monitor)
	..()

/obj/machinery/computer/gyrotron_control/attack_ai(var/mob/user)
	attack_hand(user)

/obj/machinery/computer/gyrotron_control/attack_hand(var/mob/user as mob)
	..()
	if(stat & (BROKEN|NOPOWER))
		return

	monitor.tgui_interact(user)

/*
/obj/machinery/computer/gyrotron_control/attack_hand(var/mob/user)
	add_fingerprint(user)
	interact(user)

/obj/machinery/computer/gyrotron_control/interact(var/mob/user)

	if(stat & (BROKEN|NOPOWER))
		user.unset_machine()
		user << browse(null, "window=gyrotron_controller_[id_tag]")
		return

	if(!id_tag)
		to_chat(user, span_warning("This console has not been assigned an ident tag. Please contact your system administrator or conduct a manual update with a standard multitool."))
		return

	var/dat = "<td>" + span_bold("Gyrotron controller #[id_tag]")

	dat = "<table><tr>"
	dat += "<td>" + span_bold("Mode") + "</td>"
	dat += "<td>" + span_bold("Fire Delay") + "</td>"
	dat += "<td>" + span_bold("Power") + "</td>"
	dat += "</tr>"

	for(var/obj/machinery/power/emitter/gyrotron/G in gyrotrons)
		if(!G || G.id_tag != id_tag || get_dist(src, G) > scan_range)
			continue

		dat += "<tr>"
		if(G.state != 2 || (G.stat & (NOPOWER | BROKEN))) //Error data not found.
			dat += "<td>" + span_red("ERROR") + "</td>"
			dat += "<td>" + span_red("ERROR") + "</td>"
			dat += "<td>" + span_red("ERROR") + "</td>"
		else
			dat += "<td><a href='byond://?src=\ref[src];machine=\ref[G];toggle=1'>[G.active  ? "Emitting" : "Standing By"]</a></td>"
			dat += "<td><a href='byond://?src=\ref[src];machine=\ref[G];modifyrate=1'>[G.rate]</a></td>"
			dat += "<td><a href='byond://?src=\ref[src];machine=\ref[G];modifypower=1'>[G.mega_energy]</a></td>"

	dat += "</tr></table>"

	var/datum/browser/popup = new(user, "gyrotron_controller_[id_tag]", "Gyrotron Remote Control Console", 500, 400, src)
	popup.set_content(dat)
	popup.open()
	add_fingerprint(user)
	user.set_machine(src)

/obj/machinery/computer/gyrotron_control/Topic(var/href, var/list/href_list)
	. = ..()
	if(.)
		return

	if(stat & (NOPOWER | BROKEN))
		return

	var/obj/machinery/power/emitter/gyrotron/G = locate(href_list["machine"])
	if(!G || G.id_tag != id_tag || get_dist(src, G) > scan_range)
		return

	if(href_list["modifypower"])
		var/new_val = tgui_input_number(usr, "Enter new emission power level (1 - 50)", "Modifying power level", G.mega_energy, 50, 1)
		if(!new_val)
			to_chat(usr, span_warning("That's not a valid number."))
			return 1
		G.mega_energy = CLAMP(new_val, 1, 50)
		G.update_active_power_usage(G.mega_energy * 1500)
		updateUsrDialog(usr)
		return 1

	if(href_list["modifyrate"])
		var/new_val = tgui_input_number(usr, "Enter new emission delay between 1 and 10 seconds.", "Modifying emission rate", G.rate, 10, 1)
		if(!new_val)
			to_chat(usr, span_warning("That's not a valid number."))
			return 1
		G.rate = CLAMP(new_val, 1, 10)
		updateUsrDialog(usr)
		return 1

	if(href_list["toggle"])
		G.activate(usr)
		updateUsrDialog(usr)
		return 1

	return 0
*/

/obj/machinery/computer/gyrotron_control/attackby(var/obj/item/W, var/mob/user)
	..()
	if(istype(W, /obj/item/multitool))
		var/new_ident = tgui_input_text(user, "Enter a new ident tag.", "Gyrotron Control", monitor.gyro_tag, MAX_NAME_LEN)
		new_ident = sanitize(new_ident,MAX_NAME_LEN)
		if(new_ident && user.Adjacent(src))
			monitor.gyro_tag = new_ident
		return
/*
/obj/machinery/computer/gyrotron_control/update_icon()
	if(stat & (BROKEN))
		icon = 'icons/obj/computer.dmi'
		icon_state = "broken"
		set_light(0)

	if(stat & (NOPOWER))
		icon = 'icons/obj/computer.dmi'
		icon_state = "computer"
		set_light(0)

	if(!stat & (BROKEN|NOPOWER))
		icon = initial(icon)
		icon_state = initial(icon_state)
		set_light(light_range_on, light_power_on)
*/
