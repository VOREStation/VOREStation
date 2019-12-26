/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack
	var/missile_speed = 2
	var/missile_range = 30

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/Fire(atom/movable/AM, atom/target, turf/aimloc)
	AM.throw_at(target,missile_range, missile_speed, chassis)

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/flare
	name = "\improper BNI Flare Launcher"
	desc = "A flare-gun, but bigger."
	icon_state = "mecha_flaregun"
	projectile = /obj/item/device/flashlight/flare
	fire_sound = 'sound/weapons/tablehit1.ogg'
	auto_rearm = 1
	fire_cooldown = 20
	projectiles_per_shot = 1
	projectile_energy_cost = 20
	missile_speed = 1
	missile_range = 15
	required_type = /obj/mecha  //Why restrict it to just mining or combat mechs?

	equip_type = EQUIP_UTILITY

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/flare/Fire(atom/movable/AM, atom/target, turf/aimloc)
	var/obj/item/device/flashlight/flare/fired = AM
	fired.ignite()
	..()

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/explosive
	name = "\improper SRM-8 missile rack"
	desc = "A missile battery that holds eight missiles."
	icon_state = "mecha_missilerack"
	projectile = /obj/item/missile
	fire_sound = 'sound/weapons/rpg.ogg'
	projectiles = 8
	projectile_energy_cost = 1000
	equip_cooldown = 60

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/explosive/Fire(atom/movable/AM, atom/target)
	var/obj/item/missile/M = AM
	M.primed = 1
	..()

/obj/item/missile
	icon = 'icons/obj/grenade.dmi'
	icon_state = "missile"
	var/primed = null
	throwforce = 15
	catchable = 0
	var/devastation = 0
	var/heavy_blast = 1
	var/light_blast = 2
	var/flash_blast = 4
	does_spin = FALSE	// No fun corkscrew missiles.

/obj/item/missile/proc/warhead_special(var/target)
	explosion(target, devastation, heavy_blast, light_blast, flash_blast)
	return

/obj/item/missile/throw_impact(atom/hit_atom)
	if(primed)
		warhead_special(hit_atom)
		qdel(src)
	else
		..()
	return

/obj/item/missile/light
	throwforce = 10
	heavy_blast = 0

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/explosive/rigged
	name = "jury-rigged rocket pod"
	desc = "A series of pipes, tubes, and cables that resembles a rocket pod."
	icon_state = "mecha_missilerack-rig"
	projectile = /obj/item/missile/light
	projectiles = 3
	projectile_energy_cost = 800

	equip_type = EQUIP_UTILITY