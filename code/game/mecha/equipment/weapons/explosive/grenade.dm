/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/grenade
	name = "\improper SGL-6 grenade launcher"
	desc = "A grenade launcher produced for SWAT use; fires flashbangs."
	icon_state = "mecha_grenadelnchr"
	projectile = /obj/item/weapon/grenade/flashbang
	fire_sound = 'sound/effects/bang.ogg'
	projectiles = 6
	missile_speed = 1.5
	projectile_energy_cost = 800
	equip_cooldown = 60
	var/det_time = 20

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/grenade/rigged
	name = "jury-rigged pneumatic flashlauncher"
	desc = "A grenade launcher constructed out of estranged blueprints; fires flashbangs."
	icon_state = "mecha_grenadelnchr-rig"
	projectiles = 3
	missile_speed = 1
	det_time = 25

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/grenade/Fire(atom/movable/AM, atom/target, turf/aimloc)
	var/obj/item/weapon/grenade/G = AM
	if(istype(G))
		G.det_time = det_time
		G.activate(chassis.occupant) //Grenades actually look primed and dangerous, handle their own stuff.
	AM.throw_at(target,missile_range, missile_speed, chassis)

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/grenade/clusterbang//Because I am a heartless bastard -Sieve
	name = "\improper SOP-6 grenade launcher"
	desc = "A grenade launcher produced for use by government uprising subjugation forces, or that's what you might guess; fires matryoshka flashbangs."
	projectile = /obj/item/weapon/grenade/flashbang/clusterbang

	origin_tech = list(TECH_COMBAT= 5, TECH_MATERIAL = 5, TECH_ILLEGAL = 3)

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/grenade/clusterbang/limited/get_equip_info()//Limited version of the clusterbang launcher that can't reload
	return "<span style=\"color:[equip_ready?"#0f0":"#f00"];\">*</span>&nbsp;[chassis.selected==src?"<b>":"<a href='?src=\ref[chassis];select_equip=\ref[src]'>"][src.name][chassis.selected==src?"</b>":"</a>"]\[[src.projectiles]\]"

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/grenade/clusterbang/limited/rearm()
	return//Extra bit of security

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/grenade/concussion
	name = "\improper SGL-9 grenade launcher"
	desc = "A military-grade grenade launcher that fires disorienting concussion grenades."
	icon_state = "mecha_grenadelnchr"
	projectile = /obj/item/weapon/grenade/concussion
	missile_speed = 1
	projectile_energy_cost = 900
	equip_cooldown = 50
	det_time = 25

	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 4, TECH_ILLEGAL = 1)

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/grenade/frag
	name = "\improper HEP-I 5 grenade launcher"
	desc = "A military-grade grenade launcher that fires anti-personnel fragmentation grenades."
	icon_state = "mecha_fraglnchr"
	projectile = /obj/item/weapon/grenade/explosive
	projectiles = 4
	missile_speed = 1

	origin_tech = list(TECH_COMBAT = 5, TECH_ENGINEERING = 5, TECH_MATERIAL = 5, TECH_ILLEGAL = 3)

/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/grenade/frag/mini
	name = "\improper HEP-MI 6 grenade launcher"
	desc = "A military-grade grenade launcher that fires miniaturized anti-personnel fragmentation grenades."
	projectile = /obj/item/weapon/grenade/explosive/mini
	projectile_energy_cost = 500
	equip_cooldown = 25

	origin_tech = list(TECH_COMBAT = 4, TECH_ENGINEERING = 2, TECH_MATERIAL = 3, TECH_ILLEGAL = 2)
