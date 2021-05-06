/obj/structure/closet/secure_closet/guncabinet
	name = "gun cabinet"
	icon = 'icons/obj/guncabinet.dmi'
	icon_state = "baseold"
	req_one_access = list(access_armory)
	closet_appearance = null

/obj/structure/closet/secure_closet/guncabinet/Initialize()
	. = ..()
	update_icon()

/obj/structure/closet/secure_closet/guncabinet/toggle()
	..()
	update_icon()

/obj/structure/closet/secure_closet/guncabinet/update_icon()
	overlays.Cut()
	if(opened)
		overlays += icon(icon,"door_openold")
	else
		var/lazors = 0
		var/shottas = 0
		for (var/obj/item/weapon/gun/G in contents)
			if (istype(G, /obj/item/weapon/gun/energy))
				lazors++
			if (istype(G, /obj/item/weapon/gun/projectile))
				shottas++
		for (var/i = 0 to 2)
			if(lazors || shottas) // only make icons if we have one of the two types.
				var/image/gun = image(icon(src.icon))
				if (lazors > shottas)
					lazors--
					gun.icon_state = "laserold"
				else if (shottas)
					shottas--
					gun.icon_state = "projectileold"
				gun.pixel_x = i*4
				overlays += gun

		overlays += icon(src.icon, "doorold")

		if(sealed)
			overlays += icon(src.icon,"sealedold")

		if(broken)
			overlays += icon(src.icon,"brokenold")
		else if (locked)
			overlays += icon(src.icon,"lockedold")
		else
			overlays += icon(src.icon,"openold")


/obj/structure/closet/secure_closet/guncabinet/fancy
	name = "arms locker"
	icon_state = "shotguncase"
	var/case_type = GUN_LONGARM
	var/gun_category = /obj/item/weapon/gun
	var/capacity = 5
	var/welded = FALSE

/obj/structure/closet/secure_closet/guncabinet/fancy/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(issilicon(user) || isalien(user))
		return

	if(istype(W, /obj/item/weapon/gun) && opened)
		var/obj/item/weapon/gun/G = W
		if(G.locker_class == case_type)
			if(LAZYLEN(contents) < capacity)
				G.forceMove(src)
				to_chat(user, "<span class='notice'>You place [G] in [src].</span>")
				update_icon()
			else
				to_chat(user, "<span class='warning'>[src] is full.</span>")
			return
		else
			to_chat(user, "<span class='notice'>You can't seem to fit [G] in [src] properly.</span>")
		return

	else if(user.a_intent != I_HURT && !locked)
		opened = !opened
		update_icon()

	else if(istype(W, /obj/item/weapon/weldingtool) && !opened && locked)
		var/obj/item/weapon/weldingtool/WT = W
		if (WT.remove_fuel(0, user))
			playsound(src, WT.usesound, 50, 1)
			user.visible_message("<span class='danger'>[user] begins cutting through [src]'s lock.</span>", "You start cutting through the lock.", "<span class='notice'>You hear a welder in use.</span>")
			if(do_after(user, 40 * WT.toolspeed))
				welded = TRUE
				opened = TRUE

	else if(istype(W, /obj/item/weapon/melee/energy/blade) && !opened && locked)
		if(emag_act(INFINITY, user, "<span class='danger'>\The [src] has been sliced open by [user] with \an [W]</span>!", "<span class='danger'>You hear metal being sliced and sparks flying.</span>"))
			var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
			spark_system.set_up(5, 0, loc)
			spark_system.start()
			playsound(src, 'sound/weapons/blade1.ogg', 50, 1)
			playsound(src, "sparks", 50, 1)
	else
		togglelock(user)

/obj/structure/closet/secure_closet/guncabinet/fancy/attack_hand(mob/user as mob)
	. = ..()
	if(.)
		return
	if(issilicon(user) || isalien(user) || !Adjacent(usr))
		return
	if(contents.len && opened)
		ShowWindow(user)
	else
		togglelock(user)
		update_icon()

/obj/structure/closet/secure_closet/guncabinet/fancy/proc/ShowWindow(mob/user)
	var/dat = {"<div class='block'>
				<h3>Stored Guns</h3>
				<table align='center'>"}
	if(LAZYLEN(contents))
		for(var/i in 1 to contents.len)
			var/obj/item/I = contents[i]
			dat += "<tr><A href='?src=[REF(src)];retrieve=[REF(I)]'>[I.name]</A><br>"
	dat += "</table></div>"

	var/datum/browser/popup = new(user, "gunlocker", "<div align='center'>[name]</div>", 350, 300)
	popup.set_content(dat)
	popup.open(0)

/obj/structure/closet/secure_closet/guncabinet/fancy/Topic(href, href_list)
	if(href_list["retrieve"])
		var/obj/item/O = locate(href_list["retrieve"]) in contents
		if(!O || !istype(O))
			return
		if((!CanUseTopic(usr, GLOB.tgui_default_state)) || !opened)
			return
		if(ishuman(usr))
			usr.visible_message("<span class='notice'>[usr] pulls [O] out of [src]!</span>", "<span class='notice'>You retrieve [O] from the locker.</span>")
			if(!usr.put_in_hands(O))
				O.forceMove(get_turf(src))
			update_icon()

/obj/structure/closet/secure_closet/guncabinet/fancy/update_icon()
	cut_overlays()
	if(LAZYLEN(contents))
		for(var/i in 1 to contents.len)
			var/obj/item/I = contents[i]	//we've already made sure there's only guns
			var/mutable_appearance/gun_overlay = mutable_appearance(icon, I.icon_state)
			gun_overlay.pixel_x = 3 * (i - 1)
			add_overlay(gun_overlay)
	if(welded)
		add_overlay("[icon_state]_cut")
		layer = OBJ_LAYER
		return
	else if(opened)
		add_overlay("[icon_state]_open")
		layer = OBJ_LAYER
		return
	else
		add_overlay("[icon_state]_door")
		if(broken)
			add_overlay("[icon_state]_off")
			add_overlay("[icon_state]_sparking")
		else if(locked)
			add_overlay("[icon_state]_locked")
		else
			add_overlay("[icon_state]_unlocked")

/obj/structure/closet/secure_closet/guncabinet/fancy/shotgun
	name = "long arms locker"
	icon_state = "shotguncase"

/obj/structure/closet/secure_closet/guncabinet/fancy/rifle
	name = "long arms locker"
	icon_state = "riflecase"


/obj/structure/closet/secure_closet/guncabinet/fancy/rifle/wood
	icon_state = "riflefancy"


/obj/structure/closet/secure_closet/guncabinet/fancy/pistol
	name = "small arms locker"
	icon_state = "pistolcase"
	case_type = GUN_SIDEARM
	capacity = 10

/obj/structure/closet/secure_closet/guncabinet/fancy/pistol/update_icon()
	cut_overlays()
	var/gunrow = 0
	var/gunmax = 5
	var/racked = FALSE
	if(LAZYLEN(contents))
		for(var/i in 1 to contents.len)
			gunrow++
			if(contents.len <=5) //hopefully avoids layering issues + infinite rows
				racked = FALSE
			if(gunrow >= gunmax && !racked) // start the next row of sprites atop of the previous row
				racked = TRUE
				gunrow = 0
			var/obj/item/I = contents[i]	//we've already made sure there's only guns
			var/mutable_appearance/gun_overlay = mutable_appearance(icon, I.icon_state)
			gun_overlay.pixel_x = 3 * (gunrow - 1)
			if(racked)
				gun_overlay.pixel_y = -1
			else
				gun_overlay.pixel_y = 1
			add_overlay(gun_overlay)
	if(welded)
		add_overlay("[icon_state]_cut")
		layer = OBJ_LAYER
		return
	else if(opened)
		add_overlay("[icon_state]_open")
		layer = OBJ_LAYER
		return
	else
		add_overlay("[icon_state]_door")
		if(broken)
			add_overlay("[icon_state]_off")
			add_overlay("[icon_state]_sparking")
		else if(locked)
			add_overlay("[icon_state]_locked")
		else
			add_overlay("[icon_state]_unlocked")

/obj/structure/closet/secure_closet/guncabinet/fancy/pistol/wood
	icon_state = "fancypistol"
