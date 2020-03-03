/obj/item/mecha_parts/mecha_equipment/weapon/energy/flamer
	equip_cooldown = 30
	name = "\improper CR-3 Mark 8"
	desc = "An imposing device, this weapon hurls balls of fire."
	description_fluff = "A weapon designed by Hephaestus for anti-infantry combat, the CR-3 is capable of outputting a large volume of synthesized fuel. Initially designed by a small company, later purchased by Aether, on Earth as a device made for clearing underbrush and co-operating with firefighting operations. Obviously, Hephaestus has found an 'improved' use for the Aether designs."
	icon_state = "mecha_cremate"

	energy_drain = 30

	projectile = /obj/item/projectile/bullet/incendiary/flamethrower/large
	fire_sound = 'sound/weapons/towelwipe.ogg'

	origin_tech = list(TECH_MATERIAL = 4, TECH_COMBAT = 6, TECH_PHORON = 4, TECH_ILLEGAL = 4)

/obj/item/mecha_parts/mecha_equipment/weapon/energy/flamer/rigged
	name = "\improper AA-CR-1 Mark 4"
	description_fluff = "A firefighting tool maintained by Aether Atmospherics, whose initial design originated from a small Earth company. This one seems to have been jury rigged."
	icon_state = "mecha_cremate-rig"

	energy_drain = 50
	required_type = list(/obj/mecha/combat, /obj/mecha/working)

	projectile = /obj/item/projectile/bullet/incendiary/flamethrower

	origin_tech = list(TECH_MATERIAL = 3, TECH_COMBAT = 3, TECH_PHORON = 3, TECH_ILLEGAL = 2)

	equip_type = EQUIP_UTILITY
