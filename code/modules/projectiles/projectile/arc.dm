// These projectiles are somewhat different from the other projectiles in the code.
// First, these have an 'arcing' visual, that is accomplished by having the projectile icon rotate as its flying, and
// moving up, then down as it approaches the target. There is also a small shadow effect that follows the projectile
// as its flying.

// Besides the visuals, arcing projectiles do not collide with anything until they reach the target, as they fly over them.
// For best effect, use this only when it makes sense to do so, IE on the Surface. The projectiles don't care about ceilings or gravity.

/obj/item/projectile/arc
	name = "arcing shot"
	icon_state = "fireball" // WIP
	movement_type = UNSTOPPABLE
	plane = ABOVE_PLANE // Since projectiles are 'in the air', they might visually overlap mobs while in flight, so the projectile needs to be above their plane.
	var/fired_dir = null		// Which direction was the projectile fired towards. Needed to invert the projectile turning based on if facing left or right.
	var/distance_to_fly = null // How far, in pixels, to fly for. Will call on_range() when this is passed.
	var/visual_y_offset = -16 // Adjusts how high the projectile and its shadow start, visually. This is so the projectile and shadow align with the center of the tile.
	var/projectile_speed_modifier = 0.5 // Slows it down to make the arcing more noticable, and improve pixel calculation accuracy.
	var/obj/effect/projectile_shadow/shadow = null // Visual indicator for the projectile's 'true' position. Needed due to being bound to two dimensions in reality.

/obj/item/projectile/arc/Bump()
	return

/obj/item/projectile/arc/Initialize()
	shadow = new(get_turf(src))
	return ..()

/obj/item/projectile/arc/Destroy()
	QDEL_NULL(shadow)
	return ..()

<<<<<<< HEAD
/obj/item/projectile/arc/Bump(atom/A, forced=0)
	return 0
//	if(get_turf(src) != original)
//		return 0
//	else
//		return ..()

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
=======

/obj/item/projectile/arc/proc/calculate_initial_pixel_distance(atom/user, atom/target)
	var/datum/point/A = new(user)
	var/datum/point/B = new(target)

	// Set the pixel offsets if they exist.
	A.x += (p_x - 16)
	A.y += (p_y - 16)

	return pixel_length_between_points(A, B)

/obj/item/projectile/arc/proc/distance_flown()
	var/datum/point/current_point = new(src)
	var/datum/point/starting_point = new(starting)
	return pixel_length_between_points(current_point, starting_point)

/obj/item/projectile/arc/on_range()
	if(loc)
		on_impact(loc)
	return ..()


/obj/item/projectile/arc/launch_projectile(atom/target, target_zone, mob/user, params, angle_override, forced_spread = 0)
	fired_dir = get_dir(user, target) // Used to determine if the projectile should turn in the air.
	distance_to_fly = calculate_initial_pixel_distance(user, target) // Calculates how many pixels to travel before hitting the ground.
	..() // Does the actual launching. The projectile will be out after this.

// For legacy.
/obj/item/projectile/arc/old_style_target(atom/target, atom/source)
	..()
	fired_dir = get_dir(source, target)
	distance_to_fly = calculate_initial_pixel_distance(source, target)


/obj/item/projectile/arc/fire(angle, atom/direct_target)
	..() // The trajectory must exist for set_pixel_speed() to work.
	set_pixel_speed(projectile_speed_modifier) // Slows it down and makes the distance checking more accurate.

/obj/item/projectile/arc/pixel_move(trajectory_multiplier, hitscanning = FALSE)
	// Do the other important stuff first.
	..(trajectory_multiplier, hitscanning)

	// Test to see if its time to 'hit the ground'.
	var/pixels_flown = distance_flown()

	if(pixels_flown >= distance_to_fly)
		on_range() // This will also cause the projectile to be deleted.

	else
		// Handle visual projectile turning in flight.
		var/arc_progress = between(0, pixels_flown / distance_to_fly, 1)
		var/new_visual_degree = LERP(45, 135, arc_progress)

		if(fired_dir & EAST)
			adjust_rotation(new_visual_degree)
		else if(fired_dir & WEST)
			adjust_rotation(-new_visual_degree)

		// Now for the fake height.
		var/arc_max_pixel_height = distance_to_fly / 2
		var/sine_position = arc_progress * 180
		var/pixel_z_position = (arc_max_pixel_height * sin(sine_position)) + visual_y_offset
		animate(src, pixel_z = pixel_z_position, time = 1, flags = ANIMATION_END_NOW)

		// Update our shadow.
		if(shadow)
			shadow.forceMove(loc)
			shadow.pixel_x = pixel_x
			shadow.pixel_y = pixel_y + visual_y_offset

>>>>>>> f083fba... Merge pull request #5977 from Neerti/btw_i_use_fixed_arc

/obj/effect/projectile_shadow
	name = "shadow"
	desc = "You better avoid the thing coming down!"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "arc_shadow"
	anchored = TRUE
	animate_movement = 0 // Just like the projectile it's following.

//////////////
//	Subtypes
//////////////

// This is a test projectile in the sense that its testing the code to make sure it works,
// as opposed to a 'can I hit this thing' projectile.
/obj/item/projectile/arc/test/on_impact(turf/T)
	new /obj/effect/explosion(T)
	T.color = "#FF0000"

// Generic, Hivebot related
/obj/item/projectile/arc/blue_energy
	name = "energy missile"
	icon_state = "force_missile"
	damage = 15
	damage_type = BURN

/obj/item/projectile/arc/blue_energy/on_impact(turf/T)
	for(var/mob/living/L in T)
		attack_mob(L) // Everything on the turf it lands gets hit.

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

/obj/item/projectile/arc/emp_blast/weak/on_impact(turf/T)
	empulse(T, 1, 2, 3, 4) // Sec EMP grenade.

// Radiation arc shot
/obj/item/projectile/arc/radioactive
	name = "radiation blast"
	icon_state = "green_pellet"
	icon_scale = 2
	var/rad_power = 50

/obj/item/projectile/arc/radioactive/on_impact(turf/T)
	radiation_repository.radiate(T, rad_power)
