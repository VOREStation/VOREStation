/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/lmg
	name = "\improper Ultra AC 2"
	desc = "A superior version of the standard Solgov Autocannon MK2 design."
	icon_state = "mecha_uac2"
	equip_cooldown = 10
	projectile = /obj/item/projectile/bullet/pistol/medium
	fire_sound = 'sound/weapons/Gunshot_machinegun.ogg'
	projectiles = 30 //10 bursts, matching the Scattershot's 10. Also, conveniently, doesn't eat your powercell when reloading like 300 bullets does.
	projectiles_per_shot = 3
	deviation = 0.3
	projectile_energy_cost = 20
	fire_cooldown = 2

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/lmg/rigged
	name = "jury-rigged machinegun"
	desc = "The cross between a jackhammer and a whole lot of zipguns."
	icon_state = "mecha_uac2-rig"
	equip_cooldown = 12
	projectile = /obj/item/projectile/bullet/pistol
	deviation = 0.5

	equip_type = EQUIP_UTILITY
