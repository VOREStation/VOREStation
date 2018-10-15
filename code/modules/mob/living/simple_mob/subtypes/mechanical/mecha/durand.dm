// Durands are slow, tanky, beefy, and hit really hard.
// They can also root themselves to become even tankier.
// The AI doesn't do this currently.

/mob/living/simple_mob/mechanical/mecha/combat/durand
	name = "durand"
	desc = "An aging combat exosuit utilized by many corporations. It was originally developed to fight in the First Contact War."
	icon_state = "durand"
	movement_cooldown = 10
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

	var/defense_mode = FALSE
	var/defense_deflect = 35

/mob/living/simple_mob/mechanical/mecha/combat/durand/proc/set_defense_mode(new_mode)
	defense_mode = new_mode
	deflect_chance = defense_mode ? defense_deflect : initial(deflect_chance)
	to_chat(src, span("notice", "You [defense_mode ? "en" : "dis"]able defense mode."))

/mob/living/simple_mob/mechanical/mecha/combat/durand/SelfMove(turf/n, direct)
	if(defense_mode)
		to_chat(src, span("warning", "You are in defense mode, you cannot move."))
		return FALSE
	return ..()

// So players can toggle it too.
/mob/living/simple_mob/mechanical/mecha/combat/durand/verb/toggle_defense_mode()
	set name = "Toggle Defense Mode"
	set desc = "Toggles a special mode which makes you unable to move but become more resilient."
	set category = "Abilities"

	set_defense_mode(!defense_mode)

// Variant that starts in defense mode, perhaps for PoIs.
/mob/living/simple_mob/mechanical/mecha/combat/durand/defensive/initialize()
	set_defense_mode(TRUE)
	return ..()
