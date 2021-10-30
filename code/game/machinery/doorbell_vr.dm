////////////////////DOORBELL CHIME///////////////////////////////////////
/obj/machinery/doorbell_chime
	name = "doorbell chime"
	desc = "Small wall-mounted chime triggered by a doorbell"
	icon = 'icons/obj/machines/doorbell_vr.dmi'
	icon_state = "dbchime-standby"
	use_power = USE_POWER_IDLE
	idle_power_usage = 10
	active_power_usage = 200
	anchored = TRUE
	var/id_tag = null
	var/chime_sound = 'sound/machines/doorbell.ogg'

/obj/machinery/doorbell_chime/Initialize()
	. = ..()
	update_icon()

/obj/machinery/doorbell_chime/proc/chime()
	set waitfor = FALSE
	if(inoperable())
		return
	use_power(active_power_usage)
	playsound(src, chime_sound, 75)
	icon_state = "dbchime-active"
	set_light(2, 0.5, "#33FF33")
	visible_message("\The [src]'s light flashes.")
	sleep(30)
	set_light(0)
	update_icon()

/obj/machinery/doorbell_chime/power_change()
	..()
	update_icon()

/obj/machinery/doorbell_chime/update_icon()
	cut_overlays()
	if(panel_open)
		add_overlay("dbchime-open")
	if(inoperable())
		icon_state = "dbchime-off"
	if(!id_tag)
		icon_state = "dbchime-red"
	else
		icon_state = "dbchime-standby"

/obj/machinery/doorbell_chime/attackby(obj/item/W as obj, mob/user as mob)
	src.add_fingerprint(user)
	if(default_deconstruction_screwdriver(user, W))
		return
//	else if(default_deconstruction_crowbar(user, W))
//		return
	else if(default_part_replacement(user, W))
		return
	else if(panel_open && istype(W, /obj/item/device/multitool))
		var/obj/item/device/multitool/M = W
		if(M.connectable && istype(M.connectable, /obj/machinery/button/doorbell))
			var/obj/machinery/button/doorbell/B = M.connectable
			id_tag = B.id
			to_chat(user, "<span class='notice'>You upload the data from \the [W]'s buffer.</span>")
		return
	..()

////////////////////DOORBELL CHIME CONSTRUCTION///////////////////////////////////////
// We want these to be constructable so more chimes can be added in departments.
/datum/frame/frame_types/doorbell_chime
	name = "Doorbell Chime"
	frame_class = "alarm"  // It isn't an alarm, but thats the construction flow we want.
	frame_size = 3
	frame_style = "wall"
	circuit = /obj/item/weapon/circuitboard/doorbell_chime
	icon_override = 'icons/obj/machines/doorbell_vr.dmi'
	x_offset = 32
	y_offset = 32

// Annoyingly we need to provide a circuit board even if never seen by players.
// Makes some sense, its how the frame code knows what to actually build. Alternative
// is to make building it a single-step process which is too quick I say.
// This links up the frame_type to the acutal machine to build. Never seen by players.
/obj/item/weapon/circuitboard/doorbell_chime
	build_path = /obj/machinery/doorbell_chime
	board_type = new /datum/frame/frame_types/doorbell_chime
	req_components = list()

////////////////////DOORBELL SWITCH///////////////////////////////////////

/obj/machinery/button/doorbell
	name = "doorbell switch"
	desc = "A doorbell, press to chime."
	icon = 'icons/obj/machines/doorbell_vr.dmi'
	icon_state = "doorbell-standby"
	use_power = USE_POWER_OFF

/obj/machinery/button/doorbell/New(var/loc, var/dir, var/building = 0)
	..()
	if(building)
		pixel_x = (dir & 3)? 0 : (dir == 4 ? -32 : 32)
		pixel_y = (dir & 3)? (dir ==1 ? -27 : 27) : 0
	if (!id)
		assign_uid()
		id = num2text(uid)

/obj/machinery/button/doorbell/Initialize()
	. = ..()
	update_icon()

/obj/machinery/button/doorbell/power_change()
	..()
	update_icon()

/obj/machinery/button/doorbell/update_icon()
	if(stat & (NOPOWER|BROKEN))
		icon_state = "doorbell-off"
	else
		icon_state = "doorbell-standby"

/obj/machinery/button/doorbell/attack_hand(mob/user as mob)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(..())
		return
	use_power(5)
	flick("doorbell-active", src)

	for(var/obj/machinery/doorbell_chime/M in machines)
		if(M.id_tag == id)
			M.chime()

/obj/machinery/button/doorbell/attackby(obj/item/W as obj, mob/user as mob)
	src.add_fingerprint(user)
	if(default_deconstruction_screwdriver(user, W))
		return
	else if(panel_open && istype(W, /obj/item/weapon/pen))
		var/t = sanitizeSafe(input(user, "Enter the name for \the [src].", src.name, initial(src.name)), MAX_NAME_LEN)
		if(t && in_range(src, user))
			name = t
	else if(panel_open && istype(W, /obj/item/device/multitool))
		var/obj/item/device/multitool/M = W
		M.connectable = src
		to_chat(user, "<span class='caution'>You save the data in \the [M]'s buffer.</span>")
	else if(W.is_wrench())
		to_chat(user, "<span class='notice'>You start to unwrench \the [src].</span>")
		playsound(src, 'sound/items/Ratchet.ogg', 50, 1)
		if(do_after(user, 15) && !QDELETED(src))
			to_chat(user, "<span class='notice'>You unwrench \the [src].</span>")
			new /obj/item/frame/doorbell(src.loc)
			qdel(src)
		return

////////////////////DOORBELL SWITCH CONSTRUCTION///////////////////////////////////////
// Right now they are very simple to construct, just throw them up on the wall

/obj/item/frame/doorbell
	name = "doorbell switch frame"
	desc = "Used for building doorbell switches."
	icon = 'icons/obj/machines/doorbell_vr.dmi'
	icon_state = "doorbell-off"
	refund_amt = 4
	refund_type = /obj/item/stack/material/wood
	build_machine_type = /obj/machinery/button/doorbell
