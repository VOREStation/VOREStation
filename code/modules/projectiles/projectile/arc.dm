// These projectiles are somewhat different from the other projectiles in the code.
// First, these have an 'arcing' visual, that is accomplished by having the projectile icon rotate as its flying, and
// moving up, then down as it approaches the target. There is also a small shadow effect that follows the projectile
// as its flying.

// Besides the visuals, arcing projectiles do not collide with anything until they reach the target, as they fly over them.
// For best effect, use this only when it makes sense to do so, IE on the Surface. The projectiles don't care about ceilings or gravity.

/obj/item/projectile/arc
	name = "arcing shot"
	icon_state = "fireball" // WIP
	speed = 2 // Travel a bit slower, to really sell the arc visuals.
	movement_type = UNSTOPPABLE
	plane = ABOVE_PLANE // Since projectiles are 'in the air', they might visually overlap mobs while in flight, so the projectile needs to be above their plane.
	var/target_distance = null	// How many tiles the impact site is.
	var/fired_dir = null		// Which direction was the projectile fired towards. Needed to invert the projectile turning based on if facing left or right.
	var/obj/effect/projectile_shadow/shadow = null // Visual indicator for the projectile's 'true' position. Needed due to being bound to two dimensions in reality.

/obj/item/projectile/arc/Bump()
	return

/obj/item/projectile/arc/Initialize()
	shadow = new(get_turf(src))
	return ..()

/obj/item/projectile/arc/Destroy()
	QDEL_NULL(shadow)
	return ..()

// This is a test projectile in the sense that its testing the code to make sure it works,
// as opposed to a 'can I hit this thing' projectile.
/obj/item/projectile/arc/test/on_impact(turf/T)
	new /obj/effect/explosion(T)
	return ..()

/obj/item/projectile/arc/old_style_target(target, source)
	var/source_loc = get_turf(source) || get_turf(src)
	var/expected_distance = get_dist(target, source_loc)
	range = expected_distance // So the projectile "hits the ground."
	target_distance = expected_distance
	fired_dir = get_dir(source_loc, target)
	..()
	if(fired_dir & EAST)
		transform = turn(transform, -45)
	else if(fired_dir & WEST)
		transform = turn(transform, 45)

/obj/item/projectile/arc/on_range()
	on_impact(loc)
	return ..()

// Visuals.
/obj/item/projectile/arc/after_move()
	if(QDELETED(src))
		return
	// Handle projectile turning in flight.
	// This won't turn if fired north/south, as it looks weird.
	var/turn_per_step = 90 / target_distance
	if(fired_dir & EAST)
		transform = turn(transform, turn_per_step)
	else if(fired_dir & WEST)
		transform = turn(transform, -turn_per_step)

	// Now for the fake height.
	// We need to know how far along our "arc" we are.
	var/arc_progress = get_dist(src, original)
	var/arc_max_height = (target_distance * world.icon_size) / 2 // TODO: Real math.
//	var/arc_center = target_distance / 2
//	var/projectile_position = abs(arc_progress - arc_center)
//	var/height_multiplier = projectile_position / arc_center
//	height_multiplier = abs(height_multiplier - 1)
//	height_multiplier = height_multiplier ** 2


//	animate(src, pixel_z = arc_max_height * height_multiplier, time = step_delay)
	var/projectile_position = arc_progress / target_distance
	var/sine_position = projectile_position * 180
	var/pixel_z_position = arc_max_height * sin(sine_position)
	animate(src, pixel_z = pixel_z_position, time = speed)

	// Update our shadow.
	shadow.forceMove(loc)

/obj/effect/projectile_shadow
	name = "shadow"
	desc = "You better avoid the thing coming down!"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "arc_shadow"
	anchored = TRUE

//////////////
//	Subtypes
//////////////

// Generic, Hivebot related
/obj/item/projectile/arc/blue_energy
	name = "energy missile"
	icon_state = "force_missile"
	damage = 15
	damage_type = BURN

// Fragmentation arc shot
/obj/item/projectile/arc/fragmentation
	name = "fragmentation shot"
	icon_state = "shell"
	var/list/fragment_types = list(
		/obj/item/projectile/bullet/pellet/fragment, /obj/item/projectile/bullet/pellet/fragment, \
		/obj/item/projectile/bullet/pellet/fragment, /obj/item/projectile/bullet/pellet/fragment/strong
		)
	var/fragment_amount = 63 // Same as a grenade.
	var/spread_range = 7

/obj/item/projectile/arc/fragmentation/on_impact(turf/T)
	fragmentate(T, fragment_amount, spread_range, fragment_types)

/obj/item/projectile/arc/fragmentation/mortar
	icon_state = "mortar"
	fragment_amount = 10
	spread_range = 3

// EMP arc shot
/obj/item/projectile/arc/emp_blast
	name = "emp blast"
	icon_state = "bluespace"

/obj/item/projectile/arc/emp_blast/on_impact(turf/T)
	empulse(T, 2, 4, 7, 10) // Normal EMP grenade.
	return ..()

/obj/item/projectile/arc/emp_blast/weak/on_impact(turf/T)
	empulse(T, 1, 2, 3, 4) // Sec EMP grenade.
	return ..()

// Radiation arc shot
/obj/item/projectile/arc/radioactive
	name = "radiation blast"
	icon_state = "green_pellet"
	icon_scale = 2
	var/rad_power = 50

/obj/item/projectile/arc/radioactive/on_impact(turf/T)
	radiation_repository.radiate(T, rad_power)