/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/mortar
	name = "\improper HEP RC 4 \"Skyfall\""
	desc = "A Hephaestus exosuit-mounted mortar for use on planetary-or-similar bodies."
	description_info = "This weapon cannot be fired indoors, underground, or on-station."
	icon_state = "mecha_mortar"
	equip_cooldown = 30
	fire_sound = 'sound/weapons/Gunshot_cannon.ogg'
	fire_volume = 100
	projectiles = 3
	deviation = 0.6
	projectile = /obj/item/projectile/arc/fragmentation/mortar
	projectile_energy_cost = 600

	step_delay = 2

	origin_tech = list(TECH_MATERIAL = 4, TECH_COMBAT = 5, TECH_ILLEGAL = 3)

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/mortar/action_checks(atom/target)
	var/turf/MT = get_turf(chassis)
	var/turf/TT = get_turf(target)
	if(!MT.is_outdoors() || !TT.is_outdoors())
		to_chat(chassis.occupant, "<span class='notice'>\The [src]'s control system prevents you from firing due to a blocked firing arc.</span>")
		return 0
	return ..()