// Ranged, and capable of flight.

/datum/category_item/catalogue/technology/hoverpod
	name = "Voidcraft - Hoverpod"
	desc = "This is a small space-capable craft that has a round design. Can hold up to one pilot, \
	and sometimes one or two passengers, with the right modifications made. \
	Hoverpods have existed for a very long time, and the design has remained more or less consistant over its life. \
	They carved out a niche in short ranged transportation of cargo or crew while in space, \
	as they were more efficient compared to using a shuttle, and required less infrastructure to use due to being compact enough \
	to use airlocks. As such, they acted as a sort of bridge between being EVA in a spacesuit, and being inside a 'real' spacecraft.\
	<br><br>\
	In recent times, the Hoverpod is seen as outdated by some, as newer solutions to that niche now exist, however it remains an ancient favorite."
	value = CATALOGUER_REWARD_EASY

/mob/living/simple_mob/mechanical/mecha/hoverpod
	name = "hover pod"
	desc = "Stubby and round, this space-capable craft is an ancient favorite. It has a jury-rigged welder-laser."
	catalogue_data = list(/datum/category_item/catalogue/technology/hoverpod)
	icon_state = "engineering_pod"
	movement_sound = 'sound/machines/hiss.ogg'
	wreckage = /obj/structure/loot_pile/mecha/hoverpod

	maxHealth = 150
	hovering = TRUE // Can fly.

	projectile_dispersion = 10
	projectile_accuracy = -30
	projectiletype = /obj/item/projectile/beam
	base_attack_cooldown = 2 SECONDS

	organ_names = /decl/mob_organ_names/hoverpod

	var/datum/effect/effect/system/ion_trail_follow/ion_trail

/mob/living/simple_mob/mechanical/mecha/hoverpod/manned
	pilot_type = /mob/living/simple_mob/humanoid/merc/ranged

/mob/living/simple_mob/mechanical/mecha/hoverpod/Initialize(mapload)
	ion_trail = new /datum/effect/effect/system/ion_trail_follow()
	ion_trail.set_up(src)
	ion_trail.start()
	return ..()

/mob/living/simple_mob/mechanical/mecha/hoverpod/Process_Spacemove(var/check_drift = 0)
	return TRUE

/decl/mob_organ_names/hoverpod
	hit_zones = list("central chassis", "control module", "hydraulics", "left manipulator", "right manipulator", "left landing strut", "right landing strut", "maneuvering thruster", "sensor suite", "radiator", "power supply")
