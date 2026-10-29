/datum/component/leap_trait
	var/mob/living/living_owner

	var/leap_distance = 3
	var/leap_windup = 1 SECOND
	var/leap_cooldown = 5 SECONDS

	var/datum/action/cooldown/mob_cooldown/leap/jump

/datum/component/leap_trait/Initialize(leap_distance = 3, leap_windup = 1 SECOND, leap_cooldown = 5 SECONDS)
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

	living_owner = parent
	src.leap_distance = leap_distance
	src.leap_windup = leap_windup
	src.leap_cooldown = leap_cooldown
	add_leap()

/datum/component/leap_trait/proc/add_leap()
	jump = new()
	jump.Grant(living_owner, leap_distance, leap_windup, leap_cooldown)

/datum/component/leap_trait/Destroy(force)
	if(living_owner)
		jump.Remove(living_owner)
	living_owner = null
	. = ..()
