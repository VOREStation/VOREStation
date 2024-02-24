// Base type for the 'combat' mechas like gygax/durand/maulers/etc.
// They generally are walking tanks, and their melee attack knocks back and stuns, like the real deal.

/mob/living/simple_mob/mechanical/mecha/combat
	name = "combat mecha"
	desc = "An even bigger stompy mech!!"

	movement_cooldown = 3
	melee_damage_lower = 30
	melee_damage_upper = 30
	melee_attack_delay = 1 SECOND
	attacktext = list("punched", "slammed", "uppercutted", "pummeled")

	armor = list(
				"melee"		= 30,
				"bullet"	= 30,
				"laser"		= 15,
				"energy"	= 0,
				"bomb"		= 20,
				"bio"		= 100,
				"rad"		= 100
				)

	var/weaken_amount = 2 // Be careful with this number. High values can equal a permastun.

// Melee hits knock back by one tile (or more if already stunned to help prevent permastuns).
/mob/living/simple_mob/mechanical/mecha/combat/apply_melee_effects(atom/A)
	if(isliving(A))
		var/mob/living/L = A
		if(L.mob_size <= MOB_MEDIUM)
			visible_message(span("danger", "\The [src] sends \the [L] flying with their mechanized fist!"))
			playsound(src, "punch", 50, 1)
			L.Weaken(weaken_amount)
			var/throw_dir = get_dir(src, L)
			var/throw_dist = L.incapacitated(INCAPACITATION_DISABLED) ? 4 : 1
			L.throw_at(get_edge_target_turf(L, throw_dir), throw_dist, 1, src)
		else
			to_chat(L, span("warning", "\The [src] punches you with incredible force, but you remain in place."))
