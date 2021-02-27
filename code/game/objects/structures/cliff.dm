GLOBAL_LIST_EMPTY(cliff_icon_cache)

/*
Cliffs give a visual illusion of depth by seperating two places while presenting a 'top' and 'bottom' side.

Mobs moving into a cliff from the bottom side will simply bump into it and be denied moving into the tile,
where as mobs moving into a cliff from the top side will 'fall' off the cliff, forcing them to the bottom, causing significant damage and stunning them.

Mobs can climb this while wearing climbing equipment by clickdragging themselves onto a cliff, as if it were a table.

Flying mobs can pass over all cliffs with no risk of falling.

Projectiles and thrown objects can pass, however if moving upwards, there is a chance for it to be stopped by the cliff.
This makes fighting something that is on top of a cliff more challenging.

As a note, dir points upwards, e.g. pointing WEST means the left side is 'up', and the right side is 'down'.

When mapping these in, be sure to give at least a one tile clearance, as NORTH facing cliffs expand to
two tiles on initialization, and which way a cliff is facing may change during maploading.
*/

/obj/structure/cliff
	name = "cliff"
	desc = "A steep rock ledge. You might be able to climb it if you feel bold enough."
	description_info = "Walking off the edge of a cliff while on top will cause you to fall off, causing severe injury.<br>\
	You can climb this cliff if wearing special climbing equipment, by click-dragging yourself onto the cliff.<br>\
	Projectiles traveling up a cliff may hit the cliff instead, making it more difficult to fight something \
	on top."
	icon = 'icons/obj/flora/rocks.dmi'

	anchored = TRUE
	density = TRUE
	opacity = FALSE
	climbable = TRUE
	climb_delay = 10 SECONDS
	block_turf_edges = TRUE // Don't want turf edges popping up from the cliff edge.

	var/icon_variant = null // Used to make cliffs less repeative by having a selection of sprites to display.
	var/corner = FALSE // Used for icon things.
	var/ramp = FALSE // Ditto.
	var/bottom = FALSE // Used for 'bottom' typed cliffs, to avoid infinite cliffs, and for icons.

	var/is_double_cliff = FALSE // Set to true when making the two-tile cliffs, used for projectile checks.
	var/uphill_penalty = 30 // Odds of a projectile not making it up the cliff.

/obj/structure/cliff/Initialize()
	. = ..()
	register_dangerous_to_step()

/obj/structure/cliff/Destroy()
	unregister_dangerous_to_step()
	. = ..()

/obj/structure/cliff/Moved(atom/oldloc)
	. = ..()
	if(.)
		var/turf/old_turf = get_turf(oldloc)
		var/turf/new_turf = get_turf(src)
		if(old_turf != new_turf)
			old_turf.unregister_dangerous_object(src)
			new_turf.register_dangerous_object(src)

// These arrange their sprites at runtime, as opposed to being statically placed in the map file.
/obj/structure/cliff/automatic
	icon_state = "cliffbuilder"
	dir = NORTH

/obj/structure/cliff/automatic/corner
	icon_state = "cliffbuilder-corner"
	dir = NORTHEAST
	corner = TRUE

// Tiny part that doesn't block, used for making 'ramps'.
/obj/structure/cliff/automatic/ramp
	icon_state = "cliffbuilder-ramp"
	dir = NORTHEAST
	density = FALSE
	ramp = TRUE

// Made automatically as needed by automatic cliffs.
/obj/structure/cliff/bottom
	bottom = TRUE

/obj/structure/cliff/automatic/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

// Paranoid about the maploader, direction is very important to cliffs, since they may get bigger if initialized while facing NORTH.
/obj/structure/cliff/automatic/LateInitialize()
	if(dir in GLOB.cardinal)
		icon_variant = pick("a", "b", "c")

	if(dir & NORTH && !bottom) // North-facing cliffs require more cliffs to be made.
		make_bottom()

	update_icon()

/obj/structure/cliff/proc/make_bottom()
	// First, make sure there's room to put the bottom side.
	var/turf/T = locate(x, y - 1, z)
	if(!istype(T))
		return FALSE

	// Now make the bottom cliff have mostly the same variables.
	var/obj/structure/cliff/bottom/bottom = new(T)
	is_double_cliff = TRUE
	climb_delay /= 2 // Since there are two cliffs to climb when going north, both take half the time.

	bottom.dir = dir
	bottom.is_double_cliff = TRUE
	bottom.climb_delay = climb_delay
	bottom.icon_variant = icon_variant
	bottom.corner = corner
	bottom.ramp = ramp
	bottom.layer = layer - 0.1
	bottom.density = density
	bottom.update_icon()

/obj/structure/cliff/set_dir(new_dir)
	..()
	update_icon()

/obj/structure/cliff/update_icon()
	icon_state = "cliff-[dir][icon_variant][bottom ? "-bottom" : ""][corner ? "-corner" : ""][ramp ? "-ramp" : ""]"

	// Now for making the top-side look like a different turf.
	var/turf/T = get_step(src, dir)
	if(!istype(T))
		return

	var/subtraction_icon_state = "[icon_state]-subtract"
	var/cache_string = "[icon_state]_[T.icon]_[T.icon_state]"
	if(T && subtraction_icon_state in cached_icon_states(icon))
		cut_overlays()
		// If we've made the same icon before, just recycle it.
		if(cache_string in GLOB.cliff_icon_cache)
			add_overlay(GLOB.cliff_icon_cache[cache_string])

		else // Otherwise make a new one, but only once.
			var/icon/underlying_ground = icon(T.icon, T.icon_state, T.dir)
			var/icon/subtract = icon(icon, subtraction_icon_state)
			underlying_ground.Blend(subtract, ICON_SUBTRACT)
			var/image/final = image(underlying_ground)
			final.layer = src.layer - 0.2
			GLOB.cliff_icon_cache[cache_string] = final
			add_overlay(final)


// Movement-related code.

/obj/structure/cliff/CanPass(atom/movable/mover, turf/target)
	if(isliving(mover))
		var/mob/living/L = mover
		if(L.hovering) // Flying mobs can always pass.
			return TRUE
		return ..()

	// Projectiles and objects flying 'upward' have a chance to hit the cliff instead, wasting the shot.
	else if(istype(mover, /obj))
		var/obj/O = mover
		if(check_shield_arc(src, dir, O)) // This is actually for mobs but it will work for our purposes as well.
			if(prob(uphill_penalty / (1 + is_double_cliff) )) // Firing upwards facing NORTH means it will likely have to pass through two cliffs, so the chance is halved.
				return FALSE
		return TRUE

/obj/structure/cliff/Bumped(atom/A)
	if(isliving(A))
		var/mob/living/L = A
		if(should_fall(L))
			fall_off_cliff(L)
			return
	..()

/obj/structure/cliff/proc/should_fall(mob/living/L)
	if(L.hovering)
		return FALSE

	var/turf/T = get_turf(L)
	if(T && get_dir(T, loc) & reverse_dir[dir]) // dir points 'up' the cliff, e.g. cliff pointing NORTH will cause someone to fall if moving SOUTH into it.
		return TRUE
	return FALSE

/obj/structure/cliff/proc/fall_off_cliff(mob/living/L)
	if(!istype(L))
		return FALSE
	var/turf/T = get_step(src, reverse_dir[dir])
	var/displaced = FALSE

	if(dir in list(EAST, WEST)) // Apply an offset if flying sideways, to help maintain the illusion of depth.
		for(var/i = 1 to 2)
			var/turf/new_T = locate(T.x, T.y - i, T.z)
			if(!new_T || locate(/obj/structure/cliff) in new_T)
				break
			T = new_T
			displaced = TRUE

	if(istype(T))
		visible_message(span("danger", "\The [L] falls off \the [src]!"))
		L.forceMove(T)

		// Do the actual hurting. Double cliffs do halved damage due to them most likely hitting twice.
		var/harm = !is_double_cliff ? 1 : 0.5
		if(istype(L.buckled, /obj/vehicle)) // People falling off in vehicles will take less damage, but will damage the vehicle severely.
			var/obj/vehicle/vehicle = L.buckled
			vehicle.adjust_health(40 * harm)
			to_chat(L, span("warning", "\The [vehicle] absorbs some of the impact, damaging it."))
			harm /= 2

		playsound(L, 'sound/effects/break_stone.ogg', 70, 1)
		L.Weaken(5 * harm)
		var/fall_time = 3
		if(displaced) // Make the fall look more natural when falling sideways.
			L.pixel_z = 32 * 2
			animate(L, pixel_z = 0, time = fall_time)
		sleep(fall_time) // A brief delay inbetween the two sounds helps sell the 'ouch' effect.
		playsound(L, "punch", 70, 1)
		shake_camera(L, 1, 1)
		visible_message(span("danger", "\The [L] hits the ground!"))

		// The bigger they are, the harder they fall.
		// They will take at least 20 damage at the minimum, and tries to scale up to 40% of their max health.
		// This scaling is capped at 100 total damage, which occurs if the thing that fell has more than 250 health.
		var/damage = between(20, L.getMaxHealth() * 0.4, 100)
		var/target_zone = ran_zone()
		var/blocked = L.run_armor_check(target_zone, "melee") * harm
		var/soaked = L.get_armor_soak(target_zone, "melee") * harm

		L.apply_damage(damage * harm, BRUTE, target_zone, blocked, soaked, used_weapon=src)

		// Now fall off more cliffs below this one if they exist.
		var/obj/structure/cliff/bottom_cliff = locate() in T
		if(bottom_cliff)
			visible_message(span("danger", "\The [L] rolls down towards \the [bottom_cliff]!"))
			sleep(5)
			bottom_cliff.fall_off_cliff(L)

/obj/structure/cliff/can_climb(mob/living/user, post_climb_check = FALSE)
	// Cliff climbing requires climbing gear.
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/clothing/shoes/shoes = H.shoes
		if(shoes && shoes.rock_climbing)
			return ..() // Do the other checks too.

	to_chat(user, span("warning", "\The [src] is too steep to climb unassisted."))
	return FALSE

// This tells AI mobs to not be dumb and step off cliffs willingly.
/obj/structure/cliff/is_safe_to_step(mob/living/L)
	if(should_fall(L))
		return FALSE
	return ..()
