/obj/item/mecha_parts/mecha_equipment/weapon/energy/laser
	equip_cooldown = 8
	name = "\improper CH-PS \"Immolator\" laser"
	desc = "A laser carbine's firing system mounted on a high-powered exosuit weapon socket."
	icon_state = "mecha_laser"
	energy_drain = 30
	projectile = /obj/item/projectile/beam
	fire_sound = 'sound/weapons/Laser.ogg'

	origin_tech = list(TECH_MATERIAL = 2, TECH_COMBAT = 3, TECH_MAGNET = 3)

/obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/xray
	equip_cooldown = 6
	name = "\improper CH-XS \"Penetrator\" laser"
	desc = "A large, mounted variant of the anti-armor xray rifle."
	icon_state = "mecha_xray"
	energy_drain = 150
	projectile = /obj/item/projectile/beam/xray
	fire_sound = 'sound/weapons/eluger.ogg'

	origin_tech = list(TECH_MATERIAL = 3, TECH_COMBAT = 3, TECH_PHORON = 3, TECH_POWER = 3)

/obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/xray/rigged
	equip_cooldown = 12
	name = "jury-rigged xray rifle"
	desc = "A modified wormhole modulation array and meson-scanning control system allow this abomination to produce concentrated blasts of xrays."
	energy_drain = 175
	icon_state = "mecha_xray-rig"

	equip_type = EQUIP_UTILITY

/obj/item/mecha_parts/mecha_equipment/weapon/energy/riggedlaser
	equip_cooldown = 15
	name = "jury-rigged welder-laser"
	desc = "While not regulation, this inefficient weapon can be attached to working exo-suits in desperate, or malicious, times."
	icon_state = "mecha_laser-rig"
	energy_drain = 60
	projectile = /obj/item/projectile/beam
	fire_sound = 'sound/weapons/Laser.ogg'
	required_type = list(/obj/mecha/combat, /obj/mecha/working)

	equip_type = EQUIP_UTILITY

	origin_tech = list(TECH_MATERIAL = 2, TECH_COMBAT = 2, TECH_MAGNET = 2)

/obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/heavy
	equip_cooldown = 15
	name = "\improper CH-LC \"Solaris\" laser cannon"
	desc = "In the Solaris, the lasing medium is enclosed in a tube lined with plutonium-239 and subjected to extreme neutron flux in a nuclear reactor core. This incredible technology may help YOU achieve high excitation rates with massive laser volumes!"
	icon_state = "mecha_laser"
	energy_drain = 60
	projectile = /obj/item/projectile/beam/heavylaser
	fire_sound = 'sound/weapons/lasercannonfire.ogg'

	step_delay = 1

	origin_tech = list(TECH_MATERIAL = 3, TECH_COMBAT = 4, TECH_MAGNET = 4)

/obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/heavy/rigged
	equip_cooldown = 25
	name = "jury-rigged emitter cannon"
	desc = "While not regulation, this mining tool can be used as an inefficient weapon on working exo-suits in desperate, or malicious, times."
	icon_state = "mecha_emitter"
	energy_drain = 80
	projectile = /obj/item/projectile/beam/heavylaser/fakeemitter
	fire_sound = 'sound/weapons/emitter.ogg'

	equip_type = EQUIP_UTILITY

	origin_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 4, TECH_PHORON = 3, TECH_ILLEGAL = 1)

/obj/item/mecha_parts/mecha_equipment/weapon/energy/laser/gamma
	equip_cooldown = 5
	name = "\improper GA-X \"Render\" Experimental Gamma Laser"
	desc = "A experimental suppression laser that fires rapid blasts of radiation charged photons, extremely effective against infantry."
	icon_state = "mecha_coil"
	energy_drain = 80
	projectile = /obj/item/projectile/beam/gamma
	fire_sound = 'sound/weapons/emitter.ogg'

	origin_tech = list(TECH_MATERIAL = 4, TECH_COMBAT = 4, TECH_PHORON = 4, TECH_POWER = 4, TECH_ILLEGAL = 3)
