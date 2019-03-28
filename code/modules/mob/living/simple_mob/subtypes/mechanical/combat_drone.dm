/*
	Combat drones have a rapid ranged attack, and have a projectile shield.
	They are rather slow, but attempt to 'kite' its target.
	A solid hit with an EMP grenade will kill the shield instantly.
*/

/mob/living/simple_mob/mechanical/combat_drone
	name = "combat drone"
	desc = "An automated combat drone armed with state of the art weaponry and shielding."
	icon_state = "drone"
	icon_living = "drone"
	icon_dead = "drone_dead"
	has_eye_glow = TRUE

	faction = "malf_drone"

	maxHealth = 50 // Shield has 150 for total of 200.
	health = 50
	movement_cooldown = 5
	hovering = TRUE

	base_attack_cooldown = 5
	projectiletype = /obj/item/projectile/beam/drone
	projectilesound = 'sound/weapons/laser3.ogg'

	response_help = "pokes"
	response_disarm = "gently pushes aside"
	response_harm = "hits"

	ai_holder_type = /datum/ai_holder/simple_mob/ranged/kiting/threatening
	say_list_type = /datum/say_list/malf_drone

	var/datum/effect/effect/system/ion_trail_follow/ion_trail = null
	var/obj/item/shield_projector/shields = null

/mob/living/simple_mob/mechanical/combat_drone/Initialize()
	ion_trail = new
	ion_trail.set_up(src)
	ion_trail.start()

	shields = new /obj/item/shield_projector/rectangle/automatic/drone(src)
	return ..()

/mob/living/simple_mob/mechanical/combat_drone/Destroy()
	QDEL_NULL(ion_trail)
	QDEL_NULL(shields)
	return ..()

/mob/living/simple_mob/mechanical/combat_drone/death()
	..(null,"suddenly breaks apart.")
	qdel(src)

/mob/living/simple_mob/mechanical/combat_drone/Process_Spacemove(var/check_drift = 0)
	return TRUE

/obj/item/projectile/beam/drone
	damage = 10

/obj/item/shield_projector/rectangle/automatic/drone
	shield_health = 150
	max_shield_health = 150
	shield_regen_delay = 10 SECONDS
	shield_regen_amount = 10
	size_x = 1
	size_y = 1

// A slightly easier drone, for POIs.
// Difference is that it should not be faster than you.
/mob/living/simple_mob/mechanical/combat_drone/lesser
	desc = "An automated combat drone with an aged apperance."
	movement_cooldown = 10


// This one is the type spawned by the random event.
// It won't wander away from its spawn point
/mob/living/simple_mob/mechanical/combat_drone/event
	ai_holder_type = /datum/ai_holder/simple_mob/ranged/kiting/threatening/event
