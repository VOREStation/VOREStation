//DO NOT ADD MECHA PARTS TO THE GAME WITH THE DEFAULT "SPRITE ME" SPRITE!
//I'm annoyed I even have to tell you this! SPRITE FIRST, then commit.

/obj/item/mecha_parts/mecha_equipment/weapon/energy/microlaser
	desc = "A mounted laser-carbine for light exosuits."
	equip_cooldown = 10 // same as the laser carbine
	name = "\improper WS-19 \"Torch\" laser carbine"
	icon = 'icons/mecha/mecha_equipment_vr.dmi'
	icon_state = "micromech_laser"
	energy_drain = 50
	projectile = /obj/item/projectile/beam
	fire_sound = 'sound/weapons/Laser.ogg'
	required_type = list(/obj/mecha/micro)

/obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/microheavy
	desc = "A mounted laser cannon for light exosuits."
	equip_cooldown = 30 // same as portable
	name = "\improper PC-20 \"Lance\" light laser cannon"
	icon = 'icons/mecha/mecha_equipment_vr.dmi'
	icon_state = "micromech_lasercannon"
	energy_drain = 120
	projectile = /obj/item/projectile/beam/heavylaser
	fire_sound = 'sound/weapons/lasercannonfire.ogg'
	required_type = list(/obj/mecha/micro)

/obj/item/mecha_parts/mecha_equipment/weapon/energy/microtaser
	desc = "A mounted taser for light exosuits."
	name = "\improper TS-12 \"Suppressor\" integrated taser"
	icon = 'icons/mecha/mecha_equipment_vr.dmi'
	icon_state = "micromech_taser"
	energy_drain = 40
	equip_cooldown = 10
	projectile = /obj/item/projectile/beam/stun
	fire_sound = 'sound/weapons/Taser.ogg'
	required_type = list(/obj/mecha/micro)

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/microshotgun
	desc = "A mounted combat shotgun with integrated ammo-lathe."
	name = "\improper Remington C-12 \"Boomstick\""
	icon = 'icons/mecha/mecha_equipment_vr.dmi'
	icon_state = "micromech_shotgun"
	equip_cooldown = 15
	var/mode = 0 //0 - buckshot, 1 - beanbag, 2 - slug.
	projectile = /obj/item/projectile/bullet/pellet/shotgun
	fire_sound = 'sound/weapons/shotgun.ogg'
	fire_volume = 80
	projectiles = 6
	projectiles_per_shot = 1
	deviation = 0.7
	projectile_energy_cost = 25
	required_type = list(/obj/mecha/micro)

	Topic(href,href_list)
		..()
		if(href_list["mode"])
			mode = text2num(href_list["mode"])
			switch(mode)
				if(0)
					occupant_message("Now firing buckshot.")
					projectile = /obj/item/projectile/bullet/pellet/shotgun
				if(1)
					occupant_message("Now firing beanbags.")
					projectile = /obj/item/projectile/bullet/shotgun/beanbag
				if(2)
					occupant_message("Now firing slugs.")
					projectile = /obj/item/projectile/bullet/shotgun

		return

	get_equip_info()
		return "[..()] \[<a href='?src=\ref[src];mode=0'>BS</a>|<a href='?src=\ref[src];mode=1'>BB</a>|<a href='?src=\ref[src];mode=2'>S</a>\]"


/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/flashbang/microflashbang
	desc = "A mounted grenade launcher for smaller mechs."
	name = "\improper FP-20 mounted grenade launcher"
	icon = 'icons/mecha/mecha_equipment_vr.dmi'
	icon_state = "micromech_launcher"
	projectiles = 1
	missile_speed = 1.5
	projectile_energy_cost = 800
	equip_cooldown = 30
	det_time = 15
	required_type = list(/obj/mecha/micro)