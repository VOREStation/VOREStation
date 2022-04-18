/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack
	var/missile_speed = 2
	var/missile_range = 30

	step_delay = 0.5

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/flare
	name = "\improper BNI Flare Launcher"
	desc = "A flare-gun, but bigger."
	icon_state = "mecha_flaregun"
	projectile = /obj/item/flashlight/flare
	fire_sound = 'sound/weapons/tablehit1.ogg'
	auto_rearm = 1
	fire_cooldown = 20
	projectiles_per_shot = 1
	projectile_energy_cost = 20
	missile_speed = 1
	missile_range = 15
	required_type = /obj/mecha  //Why restrict it to just mining or combat mechs?

	step_delay = 0

	equip_type = EQUIP_UTILITY

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/flare/Fire(atom/movable/AM, atom/target, turf/aimloc)
	var/obj/item/flashlight/flare/fired = AM
	fired.ignite()
	..()

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/explosive
	name = "\improper SRM-8 missile rack"
	desc = "A missile battery that holds eight missiles."
	icon_state = "mecha_missilerack"
	projectile = /obj/item/projectile/bullet/srmrocket
	fire_sound = 'sound/weapons/rpg.ogg'
	projectiles = 8
	projectile_energy_cost = 1000
	equip_cooldown = 60


/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/explosive/rigged
	name = "jury-rigged rocket pod"
	desc = "A series of pipes, tubes, and cables that resembles a rocket pod."
	icon_state = "mecha_missilerack-rig"
	projectile = /obj/item/projectile/bullet/srmrocket/weak
	projectiles = 3
	projectile_energy_cost = 800

	equip_type = EQUIP_UTILITY
