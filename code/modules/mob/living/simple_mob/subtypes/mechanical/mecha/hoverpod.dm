// Ranged, and capable of flight.
/mob/living/simple_mob/mechanical/mecha/hoverpod
	name = "hover pod"
	desc = "Stubby and round, this space-capable craft is an ancient favorite. It has a jury-rigged welder-laser."
	icon_state = "engineering_pod"
	movement_sound = 'sound/machines/hiss.ogg'
	wreckage = /obj/structure/loot_pile/mecha/hoverpod

	maxHealth = 150
	hovering = TRUE // Can fly.

	projectiletype = /obj/item/projectile/beam
	base_attack_cooldown = 2 SECONDS

	var/datum/effect/effect/system/ion_trail_follow/ion_trail

/mob/living/simple_mob/mechanical/mecha/hoverpod/manned
	pilot_type = /mob/living/simple_mob/humanoid/merc/ranged

/mob/living/simple_mob/mechanical/mecha/hoverpod/initialize()
	ion_trail = new /datum/effect/effect/system/ion_trail_follow()
	ion_trail.set_up(src)
	ion_trail.start()
	return ..()

/mob/living/simple_mob/mechanical/mecha/hoverpod/Process_Spacemove(var/check_drift = 0)
	return TRUE