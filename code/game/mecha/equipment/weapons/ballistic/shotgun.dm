/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/scattershot
	name = "\improper LBX AC 10 \"Scattershot\""
	desc = "A massive shotgun designed to fill a large area with pellets."
	icon_state = "mecha_scatter"
	equip_cooldown = 20
	projectile = /obj/item/projectile/bullet/pellet/shotgun/flak
	fire_sound = 'sound/weapons/Gunshot_shotgun.ogg'
	fire_volume = 80
	projectiles = 40
	projectiles_per_shot = 4
	deviation = 0.7
	projectile_energy_cost = 25

	step_delay = 0.5

	origin_tech = list(TECH_MATERIAL = 3, TECH_COMBAT = 4)

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/scattershot/rigged
	name = "jury-rigged shrapnel cannon"
	desc = "The remains of some unfortunate RCD now doomed to kill, rather than construct."
	icon_state = "mecha_scatter-rig"
	equip_cooldown = 30
	fire_volume = 100
	projectiles = 20
	deviation = 1

	equip_type = EQUIP_UTILITY

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/boomstick
	name = "\improper Remington C-12 \"Boomstick\""
	desc = "A mounted combat shotgun with a integrated ammo-lathe."
	icon = 'icons/mecha/mecha_equipment_vr.dmi'
	icon_state = "mecha_boomstick"
	equip_cooldown = 15
	var/mode = 0 //0 - buckshot, 1 - beanbag, 2 - slug.
	projectile = /obj/item/projectile/scatter/shotgun
	fire_sound = 'sound/weapons/Gunshot_shotgun.ogg'
	fire_volume = 80
	projectiles = 6
	projectiles_per_shot = 1
	deviation = 0.7
	projectile_energy_cost = 100
	equip_type = EQUIP_WEAPON
	required_type = list(/obj/mecha/combat)

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/boomstick/Topic(href,href_list)
	..()
	if(href_list["mode"])
		mode = text2num(href_list["mode"])
		switch(mode)
			if(0)
				occupant_message("Now firing buckshot.")
				projectile = /obj/item/projectile/scatter/shotgun // Use scatter/shotgun over bullet/pellet/shotgun for multiple projectiles
			if(1)
				occupant_message("Now firing beanbags.")
				projectile = /obj/item/projectile/bullet/shotgun/beanbag
			if(2)
				occupant_message("Now firing slugs.")
				projectile = /obj/item/projectile/bullet/shotgun

	return

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/boomstick/get_equip_info()
	return "[..()] \[<a href='?src=\ref[src];mode=0'>BS</a>|<a href='?src=\ref[src];mode=1'>BB</a>|<a href='?src=\ref[src];mode=2'>S</a>\]"
