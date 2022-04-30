<<<<<<< HEAD
/obj/structure/closet/secure_closet/guncabinet
	name = "gun cabinet"
	icon = 'icons/obj/guncabinet.dmi'
	icon_state = "base"
	req_one_access = list(access_armory)
	closet_appearance = null

/obj/structure/closet/secure_closet/guncabinet/Initialize()
	. = ..()
	update_icon()

/obj/structure/closet/secure_closet/guncabinet/toggle()
	..()
	update_icon()

/obj/structure/closet/secure_closet/guncabinet/update_icon()
	cut_overlays()
	if(opened)
		add_overlay("door_open")
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
					gun.icon_state = "laser"
				else if (shottas)
					shottas--
					gun.icon_state = "projectile"
				gun.pixel_x = i*4
				add_overlay(gun)

		add_overlay("door")

		if(sealed)
			add_overlay("sealed")

		if(broken)
			add_overlay("broken")
		else if (locked)
			add_overlay("locked")
		else
			add_overlay("open")

//VOREStation Add Start
/obj/structure/closet/secure_closet/guncabinet/excursion
	name = "expedition weaponry cabinet"
	req_one_access = list(access_explorer,access_armory)

/obj/structure/closet/secure_closet/guncabinet/excursion/New()
	..()
	for(var/i = 1 to 2)
		new /obj/item/weapon/gun/energy/locked/frontier(src)
	for(var/i = 1 to 2)
		new /obj/item/weapon/gun/energy/locked/frontier/holdout(src)
//VOREStation Add End
=======
/obj/structure/closet/secure_closet/guncabinet
	name = "gun cabinet"
	icon = 'icons/obj/guncabinet.dmi'
	icon_state = "base"
	req_one_access = list(access_armory)
	closet_appearance = null

/obj/structure/closet/secure_closet/guncabinet/Initialize()
	. = ..()
	update_icon()

/obj/structure/closet/secure_closet/guncabinet/toggle()
	..()
	update_icon()

/obj/structure/closet/secure_closet/guncabinet/update_icon()
	cut_overlays()
	var/list/add = list()
	if (!opened)
		var/energy_count = 0
		var/projectile_count = 0
		for (var/obj/item/gun/gun in contents)
			if (istype(gun, /obj/item/gun/energy))
				++energy_count
			else if(istype(gun, /obj/item/gun/projectile))
				++projectile_count
		for (var/i = 0 to 2)
			if (!energy_count && !projectile_count)
				break
			var/image/image = new (icon)
			image.pixel_x = i * 4
			if (energy_count > projectile_count)
				image.icon_state = "laser"
				--energy_count
			else if (projectile_count)
				image.icon_state = "projectile"
				--projectile_count
			add += image
		add += "door"
		if (sealed)
			add += "sealed"
		if (broken)
			add += "broken"
		else if (locked)
			add += "locked"
		else
			add += "open"
	else
		add += "door_open"
	add_overlay(add)
>>>>>>> 58284cca9fd... Merge pull request #8590 from Spookerton/spkrtn/fix/lingering-overlay-odds
