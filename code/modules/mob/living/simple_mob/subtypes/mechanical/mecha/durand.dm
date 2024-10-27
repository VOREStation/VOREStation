// Durands are slow, tanky, beefy, and hit really hard.
// They can also root themselves to become even tankier.
// The AI doesn't do this currently.

/datum/category_item/catalogue/technology/durand
	name = "Exosuit - Durand"
	desc = "The Durand is an old combat exosuit, that was once the most durable exosuit ever developed by humans. \
	In modern times, this exosuit has been dethroned from that title, yet it remains one of the more well built and armored \
	exosuits, despite its age.\
	<br><br>\
	During the Hegemony War against the Unathi, there was a need for various new technologies to be developed \
	to counter the Unathi war machine. One of many solutions created was the Durand, which was made to be heavy and \
	well-armored, and be capable of powering the various weapons that could be mounted onto it. Presently, the \
	Durand now generally serves as corporate asset protection hardware, due to modern militaries moving on to newer, \
	more advanced war machines."
	value = CATALOGUER_REWARD_HARD

/mob/living/simple_mob/mechanical/mecha/combat/durand
	name = "durand"
	desc = "An aging combat exosuit utilized by many corporations. It was originally developed to fight in the Hegemony War."
	catalogue_data = list(/datum/category_item/catalogue/technology/durand)
	icon_state = "durand"
	movement_cooldown = 3
	wreckage = /obj/structure/loot_pile/mecha/durand

	maxHealth = 400
	deflect_chance = 20
	armor = list(
				"melee"		= 50,
				"bullet"	= 35,
				"laser"		= 15,
				"energy"	= 10,
				"bomb"		= 20,
				"bio"		= 100,
				"rad"		= 100
				)
	melee_damage_lower = 40
	melee_damage_upper = 40
	base_attack_cooldown = 2 SECONDS
	projectiletype = /obj/item/projectile/beam/heavylaser
	projectile_dispersion = 10
	projectile_accuracy = -30

	var/defense_mode = FALSE
	var/defense_deflect = 35

/mob/living/simple_mob/mechanical/mecha/combat/durand/proc/set_defense_mode(new_mode)
	defense_mode = new_mode
	deflect_chance = defense_mode ? defense_deflect : initial(deflect_chance)
	projectile_accuracy = defense_mode ? -10 : initial(projectile_accuracy)
	to_chat(src, span_notice("You [defense_mode ? "en" : "dis"]able defense mode."))

/mob/living/simple_mob/mechanical/mecha/combat/durand/SelfMove(turf/n, direct)
	if(defense_mode)
		to_chat(src, span_warning("You are in defense mode, you cannot move."))
		return FALSE
	return ..()

// So players can toggle it too.
/mob/living/simple_mob/mechanical/mecha/combat/durand/verb/toggle_defense_mode()
	set name = "Toggle Defense Mode"
	set desc = "Toggles a special mode which makes you immobile and much more resilient."
	set category = "Abilities"

	set_defense_mode(!defense_mode)

// Variant that starts in defense mode, perhaps for PoIs.
/mob/living/simple_mob/mechanical/mecha/combat/durand/defensive/Initialize()
	set_defense_mode(TRUE)
	return ..()

/mob/living/simple_mob/mechanical/mecha/combat/durand/defensive/mercenary
	desc = "An aging combat exosuit utilized by many corporations. It was originally developed to fight in the Hegemony War.\
	This one has been retrofitted into a turret."

	projectiletype = /obj/item/projectile/beam/heavylaser/fakeemitter

	pilot_type = /mob/living/simple_mob/humanoid/merc/ranged
