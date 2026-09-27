/// Creates a cool looking effect on the movable.
/datum/component/unusual_effect
	dupe_mode = COMPONENT_DUPE_HIGHLANDER

	var/obj/effect/abstract/particle_holder/special_effects

	var/color

	COOLDOWN_DECLARE(glow_cooldown)

/datum/component/unusual_effect/Initialize(color, include_particles = FALSE)
	var/atom/movable/parent_movable = parent
	if(!istype(parent_movable))
		return COMPONENT_INCOMPATIBLE

	src.color = color
	parent_movable.add_filter("unusual_effect", 2, list("type" = "outline", "color" = color, "size" = 2))
	if(include_particles)
		var/particles = pick(typesof(/particles/unusual_effect))
		special_effects = new(parent_movable, particles)
	START_PROCESSING(SSobj, src)

/datum/component/unusual_effect/Destroy(force)
	var/atom/movable/parent_movable = parent
	if(istype(parent_movable))
		parent_movable.remove_filter("unusual_effect")
	STOP_PROCESSING(SSobj, src)
	return ..()

/datum/component/unusual_effect/process(seconds_per_tick)
	var/atom/movable/parent_movable = parent
	var/filter = parent_movable.get_filter("unusual_effect")
	if(!filter)
		parent_movable.add_filter("unusual_effect", 2, list("type" = "outline", "color" = color, "size" = 2))
		return
	if(!COOLDOWN_FINISHED(src, glow_cooldown))
		return

	animate(filter, alpha = 110, time = 1.5 SECONDS, loop = -1)
	animate(alpha = 40, time = 2.5 SECONDS)
	COOLDOWN_START(src, glow_cooldown, 4 SECONDS)
