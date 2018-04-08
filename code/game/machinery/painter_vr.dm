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
		/*
		/obj/item/clothing/under/bathrobe,
		/obj/item/clothing/under/cheongsam,
		/obj/item/clothing/under/color/white,
		/obj/item/clothing/under/dress/white,
		/obj/item/clothing/under/dress/white2,
		/obj/item/clothing/under/dress/white3,
		/obj/item/clothing/under/dress/white4,
		/obj/item/clothing/under/medigown,
		/obj/item/clothing/under/pants/white,
		/obj/item/clothing/under/pants/track/white,
		/obj/item/clothing/under/pants/baggy/white,
		/obj/item/clothing/under/pants/yogapants,
		/obj/item/clothing/under/seromi/smock/white,
		/obj/item/clothing/under/seromi/undercoat/white_grey,
		/obj/item/clothing/under/shorts/white,
		/obj/item/clothing/under/swimsuit/white,
		/obj/item/clothing/under/wedding/bride_white,
		/obj/item/clothing/suit/chef,
		/obj/item/clothing/suit/holidaypriest,
		/obj/item/clothing/suit/kimono,
		/obj/item/clothing/suit/storage/duster,
		/obj/item/clothing/suit/storage/hazardvest/white,
		/obj/item/clothing/suit/storage/hooded/chaplain_hoodie/whiteout,
		/obj/item/clothing/suit/storage/seromi/cloak/white_grey,
		/obj/item/clothing/suit/storage/snowsuit,
		/obj/item/clothing/suit/storage/toggle/dress,
		/obj/item/clothing/suit/storage/toggle/labcoat,
		/obj/item/clothing/suit/storage/toggle/med_dep_jacket,
		/obj/item/clothing/suit/storage/toggle/peacoat,
		/obj/item/clothing/suit/storage/toggle/track/white,
		/obj/item/clothing/suit/straight_jacket,
		/obj/item/clothing/suit/whitedress,
		/obj/item/clothing/shoes/athletic,
		/obj/item/clothing/shoes/flipflop,
		/obj/item/clothing/shoes/footwraps,
		/obj/item/clothing/shoes/hitops,
		/obj/item/clothing/shoes/skater,
		/obj/item/clothing/shoes/slippers,
		/obj/item/clothing/shoes/slippers_worn,
		/obj/item/clothing/shoes/white,
		/obj/item/clothing/head/beretg,
		/obj/item/clothing/head/chefhat,
		/obj/item/clothing/head/flatcap/grey,
		/obj/item/clothing/head/collectable/chef,
		/obj/item/clothing/head/collectable/rabbitears,
		/obj/item/clothing/head/collectable/paper,
		/obj/item/clothing/head/chaplain_hood/whiteout,
		/obj/item/clothing/head/fluff/headbando,
		/obj/item/clothing/head/hardhat/white,
		/obj/item/clothing/head/headband/maid,
		/obj/item/clothing/head/hijab,
		/obj/item/clothing/head/kippa,
		/obj/item/clothing/head/nursehat,
		/obj/item/clothing/head/philosopher_wig,
		/obj/item/clothing/head/pin/bow,
		/obj/item/clothing/head/pin/flower/white,
		/obj/item/clothing/head/powdered_wig,
		/obj/item/clothing/head/rabbitears,
		/obj/item/clothing/head/soft/mime,
		/obj/item/clothing/head/turban,
		/obj/item/clothing/gloves/color,
		/obj/item/clothing/gloves/evening,
		/obj/item/clothing/gloves/sterile/latex,
		/obj/item/clothing/gloves/white,
		/obj/item/clothing/accessory/armband/med/color,
		/obj/item/clothing/accessory/flops,
		/obj/item/clothing/accessory/scarf/white,
		/obj/item/clothing/accessory/storage/white_drop_pouches,
		/obj/item/clothing/accessory/storage/white_vest,
		/obj/item/clothing/accessory/tie/white
		*/
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
		O.loc = src.loc
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
		user.drop_item()
		W.loc = src
		processing |= W
	else
		..()
	update_icon()

/obj/machinery/gear_painter/attack_hand(mob/user as mob)
	if(!inoperable())
		interact(user)
	update_icon()

/obj/machinery/gear_painter/interact(mob/user as mob)
	if(stat & BROKEN)
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
		dat += "<A href='?src=\ref[src];eject=1'>Eject item.</A><BR><BR>"

	user << browse(dat, "window=colormate")
	onclose(user, "colormate")
	return

/obj/machinery/gear_painter/Topic(href, href_list)
	if(..())
		return

	usr.set_machine(src)
	add_fingerprint(usr)

	if(href_list["select"])
		var/newcolor = input(usr, "Choose a color.", "", activecolor) as color|null
		if(newcolor)
			activecolor = newcolor

	if(href_list["paint"])
		for(var/atom/movable/O in processing)
			O.color = activecolor
		playsound(src.loc, 'sound/effects/spray3.ogg', 50, 1)

	if(href_list["eject"])
		for(var/atom/movable/O in processing)
			O.loc = src.loc
		processing.Cut()

	update_icon()
	updateUsrDialog()