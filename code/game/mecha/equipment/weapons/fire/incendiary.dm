//////////////
//Fire-based//
//////////////

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/incendiary
	name = "\improper DR-AC 3"
	desc = "Dual-barrel rotary machinegun that fires small, incendiary rounds. Ages ten and up."
	description_fluff = "A weapon designed by Hephaestus Industries, the DR-AC 3's design was plagued by prototype faults including but not limited to: Spontaneous combustion, spontaneous detonation, and excessive collateral conflagration."
	icon_state = "mecha_drac3"
	equip_cooldown = 20
	projectile = /obj/item/projectile/bullet/incendiary
	fire_sound = 'sound/weapons/Gunshot_machinegun.ogg'
	projectiles = 30
	projectiles_per_shot = 2
	deviation = 0.4
	projectile_energy_cost = 40
	fire_cooldown = 3
	origin_tech = list(TECH_MATERIAL = 4, TECH_COMBAT = 5, TECH_PHORON = 2, TECH_ILLEGAL = 1)
