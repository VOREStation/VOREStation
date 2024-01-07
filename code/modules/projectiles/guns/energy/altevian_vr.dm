/obj/item/weapon/gun/energy/altevian
	name = "Magneto-Electric Energy Projector"
	desc = "A hand-held version of an energy weapon for the Altevian Hegemony. This one is the civilian grade version that has a reduced charge capacity. However, it is a lot easier to use."
	icon_state = "meep"
	item_state = "meep"
	fire_delay = 8
	slot_flags = SLOT_BELT
	w_class = ITEMSIZE_NORMAL
	force = 5
	origin_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 2)
	matter = list(MAT_STEEL = 1000)
	projectile_type = /obj/item/projectile/beam/meeplaser
	charge_cost = 400

/obj/item/weapon/gun/energy/altevian/large
	name = "Proto-Reactive Beam Thruster"
	desc = "The main energy rifle that the Altevian Hegemony uses for its military operations."
	icon_state = "altevian-pdw"
	item_state = "altevian-pdw"
	slot_flags = SLOT_BELT
	w_class = ITEMSIZE_LARGE
	force = 10
	origin_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 4)
	matter = list(MAT_STEEL = 2000)
	projectile_type = /obj/item/projectile/beam/meeplaser/strong
	charge_cost = 200

/obj/item/projectile/beam/meeplaser
	name = "meep beam"
	icon_state = "meep"
	damage = 25
	light_color = "#77A6E1"
	hud_state = "laser_disabler"

	muzzle_type = /obj/effect/projectile/muzzle/meeplaser
	tracer_type = /obj/effect/projectile/tracer/meeplaser
	impact_type = /obj/effect/projectile/impact/meeplaser

/obj/item/projectile/beam/meeplaser/strong
	name = "repeater beam"
	damage = 40

/obj/effect/projectile/muzzle/meeplaser
	icon_state = "muzzle_meep"
	light_range = 2
	light_power = 0.5
	light_color = "#77A6E1"

/obj/effect/projectile/tracer/meeplaser
	icon_state = "meep"
	light_range = 2
	light_power = 0.5
	light_color = "#77A6E1"

/obj/effect/projectile/impact/meeplaser
	icon_state = "impact_meep"
	light_range = 2
	light_power = 0.5
	light_color = "#77A6E1"

/obj/item/weapon/gun/energy/ratminer
	name = "Altevian Repulsion Mineral Slicer"
	desc = "An advanced piece of mining focused technology from the Altevian Hegemony. \
			This model appears to be their standard asteroid clearing laser with a tailored system to work with an ore-bag, \
			or similar, linked to the device. It has extra crystals for the focus that seem to split the beam, \
			but also removes the pin-point accuracy other mining devices typically have."
	icon_state = "altevian-miner"
	item_state = "altevian-miner"
	fire_delay = 12
	slot_flags = SLOT_BACK
	w_class = ITEMSIZE_HUGE
	force = 10
	origin_tech = list(TECH_COMBAT = 2, TECH_MAGNET = 4)
	matter = list(MAT_STEEL = 2000)
	projectile_type = /obj/item/projectile/scatter/ratminer
	charge_cost = 400

/obj/item/projectile/scatter/ratminer
	spread_submunition_damage = FALSE
	damage = 20
	range = 0

	submunition_spread_max = 300
	force_max_submunition_spread = TRUE

	submunitions = list(
		/obj/item/projectile/beam/ratminer = 3
		)

/obj/item/projectile/beam/ratminer
	name = "slicer beam"
	icon_state = "ratmining"
	damage = 20
	light_color = "#77A6E1"
	hud_state = "laser_disabler"

	muzzle_type = /obj/effect/projectile/muzzle/ratminer
	tracer_type = /obj/effect/projectile/tracer/ratminer
	impact_type = /obj/effect/projectile/impact/ratminer

/obj/item/projectile/beam/ratminer/on_range()
	strike_thing()
	..()

/obj/item/projectile/beam/ratminer/on_hit(atom/target)
	strike_thing(target)
	. = ..()

/obj/item/projectile/beam/ratminer/on_impact(atom/A)
	. = ..()
	strike_thing(A)

/obj/item/projectile/beam/ratminer/proc/strike_thing(var/atom/A)
	var/turf/target_turf = get_turf(A)
	if(!target_turf)
		target_turf = get_turf(src)
	if(ismineralturf(target_turf))
		var/turf/simulated/mineral/M = target_turf
		M.GetDrilled(TRUE)
	for(var/T in RANGE_TURFS(2, target_turf) - target_turf)
		if(ismineralturf(T))
			var/turf/simulated/mineral/M = T
			M.GetDrilled(TRUE)
	if(firer)
		var/obj/item/weapon/storage/bag/ore/orebag = locate(/obj/item/weapon/storage/bag/ore) in firer
		if(orebag)
			for(var/turf/T in RANGE_TURFS(2, target_turf))
				orebag.gather_all(T, firer, TRUE)


/obj/effect/projectile/muzzle/ratminer
	icon_state = "muzzle_ratmining"
	light_range = 2
	light_power = 0.5
	light_color = "#77A6E1"

/obj/effect/projectile/tracer/ratminer
	icon_state = "ratmining"
	light_range = 2
	light_power = 0.5
	light_color = "#77A6E1"

/obj/effect/projectile/impact/ratminer
	icon_state = "impact_ratmining"
	light_range = 2
	light_power = 0.5
	light_color = "#77A6E1"