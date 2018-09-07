/*
	Hooligan Crabs are called so because they are rather curious and tend to follow people,
	whether the people want them to or not, and sometimes causing vandalism by accident.
	They're pretty strong and have strong melee armor, but won't attack first.
	They unknowingly play a role in keeping the shoreline fairly safe, by killing whatever would attack other people.

	They also have a slow, but very strong attack that is telegraphed. If it hits, it will briefly stun whatever got hit
	and inflict a very large chunk of damage. If the thing was already stunned, the crab will 'throw' them away, to
	hopefully prevent chainstuns forever.
*/

/mob/living/simple_mob/animal/sif/hooligan_crab
	name = "hooligan crab"
	desc = "A large, hard-shelled crustacean. This one is mostly grey. \
	You probably shouldn't mess with it."
	icon_state = "sif_crab"
	icon_living = "sif_crab"
	icon_dead = "sif_crab_dead"
	icon_scale = 1.5

	faction = "crabs"

	maxHealth = 200
	health = 200
	movement_cooldown = 10
	movement_sound = 'sound/weapons/heavysmash.ogg'
	taser_kill = FALSE
	armor = list(
				"melee" = 40,
				"bullet" = 20,
				"laser" = 10,
				"energy" = 0,
				"bomb" = 0,
				"bio" = 0,
				"rad" = 0
				)
	armor_soak = list(
				"melee" = 10,
				"bullet" = 5,
				"laser" = 0,
				"energy" = 0,
				"bomb" = 0,
				"bio" = 0,
				"rad" = 0
				)

	mob_size = MOB_LARGE

	melee_damage_lower = 22
	melee_damage_upper = 35
	attack_armor_pen = 35
	attack_sharp = 1
	attack_edge = 1
	attack_delay = 1 SECOND

	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat

	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "kicks"
	friendly = "pinches"
	attacktext = list("clawed", "pinched", "crushed")
	speak_emote = list("clicks")

	ai_holder_type = /datum/ai_holder/simple_mob/melee/hooligan
	say_list_type = /datum/say_list/crab

	var/weaken_amount = 2 // Be careful with this number. High values will equal a permastun.

// Stuns the thing that got hit briefly.
/mob/living/simple_mob/animal/sif/hooligan_crab/apply_melee_effects(atom/A)
	if(isliving(A))
		var/mob/living/L = A
		var/was_stunned = L.incapacitated(INCAPACITATION_DISABLED)
		L.Weaken(weaken_amount)

		playsound(L, 'sound/effects/break_stone.ogg', 75, 1)
		if(was_stunned) // Try to prevent chain-stuns by having them thrown.
			var/throwdir = get_dir(src, L)
			L.throw_at(get_edge_target_turf(L, throwdir), 5, 1, src)
			visible_message(span("danger", "\The [src] hurls \the [L] away!"))
		else
			visible_message(span("danger", "\The [src] crushes \the [L]!"))