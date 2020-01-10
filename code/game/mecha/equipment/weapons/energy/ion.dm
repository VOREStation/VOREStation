/obj/item/mecha_parts/mecha_equipment/weapon/energy/ion
	equip_cooldown = 40
	name = "mkIV ion heavy cannon"
	desc = "An upscaled variant of anti-mechanical weaponry constructed by NT, such as the EW Halicon."
	icon_state = "mecha_ion"
	energy_drain = 120
	projectile = /obj/item/projectile/ion
	fire_sound = 'sound/weapons/Laser.ogg'

	origin_tech = list(TECH_MATERIAL = 3, TECH_COMBAT = 4, TECH_MAGNET = 4)

/obj/item/mecha_parts/mecha_equipment/weapon/energy/ion/rigged
	equip_cooldown = 30
	name = "jury-rigged ion cannon"
	desc = "A tesla coil modified to amplify an ionic wave, and use it as a projectile."
	icon_state = "mecha_ion-rig"
	energy_drain = 100
	projectile = /obj/item/projectile/ion/pistol

	equip_type = EQUIP_UTILITY