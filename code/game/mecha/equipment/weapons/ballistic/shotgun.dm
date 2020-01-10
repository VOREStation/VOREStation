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