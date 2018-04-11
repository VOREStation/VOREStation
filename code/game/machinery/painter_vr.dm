/obj/machinery/gear_painter
	name = "Color Mate"
	desc = "A machine to give your apparel a fresh new color! Recommended to use with white items for best results."
	icon = 'icons/obj/vending_vr.dmi'
	icon_state = "colormate"
	density = 1
	anchored = 1
	var/list/processing = list()
	var/activecolor = "#FFFFFF"
	var/list/allowed_types = list(
			/obj/item/clothing,
			/obj/item/weapon/storage/backpack,
			/obj/item/weapon/storage/belt
			)

/obj/machinery/gear_painter/update_icon()
	if(panel_open)
		icon_state = "colormate_open"
	else if(inoperable())
		icon_state = "colormate_off"
	else if(processing.len)
		icon_state = "colormate_active"
	else
		icon_state = "colormate"

/obj/machinery/gear_painter/Destroy()
	for(var/atom/movable/O in processing)
		O.forceMove(drop_location())
	processing.Cut()
	return ..()

/obj/machinery/gear_painter/attackby(obj/item/W as obj, mob/user as mob)
	if(processing.len)
		to_chat(user, "<span class='warning'>The machine is already loaded.</span>")
		return
	if(default_deconstruction_screwdriver(user, W))
		return
	if(default_deconstruction_crowbar(user, W))
		return
	if(default_unfasten_wrench(user, W, 40))
		return

	if(is_type_in_list(W, allowed_types) && !inoperable())
		user.visible_message("<span class='notice'>[user] inserts \the [W] into the Color Mate receptable.</span>")
		user.drop_from_inventory(W)
		W.forceMove(src)
		processing |= W
	else
		..()
	update_icon()

/obj/machinery/gear_painter/attack_hand(mob/user as mob)
	if(..())
		return
	interact(user)

/obj/machinery/gear_painter/interact(mob/user as mob)
	if(inoperable())
		return
	user.set_machine(src)
	var/dat = "<TITLE>Color Mate Control Panel</TITLE><BR>"
	if(!processing.len)
		dat += "No item inserted."
	else
		for(var/atom/movable/O in processing)
			dat += "Item inserted: [O]<HR>"
		dat += "<A href='?src=\ref[src];select=1'>Select new color.</A><BR>"
		dat += "Color: <font color='[activecolor]'>&#9899;</font>"
		dat += "<A href='?src=\ref[src];paint=1'>Apply new color.</A><BR><BR>"
		dat += "<A href='?src=\ref[src];clear=1'>Remove paintjob.</A><BR><BR>"
		dat += "<A href='?src=\ref[src];eject=1'>Eject item.</A><BR><BR>"

	var/datum/browser/menu = new(user, "colormate","Color Mate Control Panel", 400, 600, src)
	menu.set_content(dat)
	menu.open()
	return

/obj/machinery/gear_painter/Topic(href, href_list)
	if(..())
		return

	usr.set_machine(src)
	add_fingerprint(usr)

	if(href_list["close"])
		return

	if(href_list["select"])
		var/newcolor = input(usr, "Choose a color.", "", activecolor) as color|null
		if(newcolor)
			activecolor = newcolor

	if(href_list["paint"])
		for(var/atom/movable/O in processing)
			O.color = activecolor
		playsound(src.loc, 'sound/effects/spray3.ogg', 50, 1)

	if(href_list["clear"])
		for(var/atom/movable/O in processing)
			O.color = initial(O.color)
		playsound(src.loc, 'sound/effects/spray3.ogg', 50, 1)

	if(href_list["eject"])
		for(var/atom/movable/O in processing)
			O.forceMove(drop_location())
		processing.Cut()

	update_icon()
	updateUsrDialog()
