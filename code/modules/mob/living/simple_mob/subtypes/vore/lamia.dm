/mob/living/simple_mob/vore/lamia
	name = "purple lamia"
	desc = "Combination snake-human. This one is purple."

	icon = 'icons/mob/vore_lamia.dmi'
	icon_state = "ffta"
	icon_living = "ffta"
	icon_rest = "ffta_rest"
	icon_dead = "ffta_dead"

	harm_intent_damage = 5
	melee_damage_lower = 0
	melee_damage_upper = 0

	response_help = "pets"
	response_disarm = "gently baps"
	response_harm = "hits"

	health = 60
	maxHealth = 60

	old_x = -16
	old_y = 0
	default_pixel_x = -16
	pixel_x = -16
	pixel_y = 0
	faction = FACTION_LAMIA

	// Vore tags
	vore_active = 1
	vore_capacity = 1
	vore_bump_emote = "coils their tail around"
	vore_icons = 0
	// Default stomach
	vore_stomach_name = "upper stomach"
	vore_stomach_flavor = "You've ended up inside of the lamia's human stomach. It's pretty much identical to any human stomach, but the valve leading deeper is much bigger."

	// Meaningful stats
	vore_default_mode = DM_HOLD
	vore_digest_chance = 0
	vore_pounce_chance = 65
	vore_bump_chance = 50
	vore_standing_too = TRUE
	vore_escape_chance = 25

	// Special lamia vore tags
	var/vore_upper_transfer_chance = 50
	var/vore_tail_digest_chance = 25
	var/vore_tail_absorb_chance = 0
	var/vore_tail_transfer_chance = 50

	say_list_type = /datum/say_list/lamia
	ai_holder_type = /datum/ai_holder/simple_mob/passive

/mob/living/simple_mob/vore/lamia/update_fullness()
	var/new_fullness = 0
	// We only want to count our upper_stomach towards capacity
	for(var/obj/belly/B as anything in vore_organs)
		if(B.name == "upper stomach")
			for(var/mob/living/M in B)
				new_fullness += M.size_multiplier
	new_fullness /= size_multiplier
	new_fullness = round(new_fullness, 1)
	vore_fullness = min(vore_capacity, new_fullness)

/mob/living/simple_mob/vore/lamia/update_icon()
	. = ..()

	if(vore_active)
		// Icon_state for fullness is as such if they are CONSCIOUS:
		// [icon_living]_vore_[upper_shows]_[tail_shows]
		// So copper_vore_1_1 is a full upper stomach *and* tail stomach
		// And copper_vore_1_0 is full upper stomach, but empty tail stomach
		// For unconscious: [icon_rest]_vore_[upper]_[tail]
		// For dead, it doesn't show.
		var/upper_shows = FALSE
		var/tail_shows = FALSE

		for(var/obj/belly/B as anything in vore_organs)
			if(!(B.name in list("upper stomach", "tail stomach")))
				continue
			var/belly_fullness = 0
			for(var/mob/living/M in B)
				belly_fullness += M.size_multiplier
			belly_fullness /= size_multiplier
			belly_fullness = round(belly_fullness, 1)

			if(belly_fullness)
				if(B.name == "upper stomach")
					upper_shows = TRUE
				else if(B.name == "tail stomach")
					tail_shows = TRUE

		if(upper_shows || tail_shows)
			if((stat == CONSCIOUS) && (!icon_rest || !resting || !incapacitated(INCAPACITATION_DISABLED)))
				icon_state = "[icon_living]_vore_[upper_shows]_[tail_shows]"
			else if(stat >= DEAD)
				icon_state = icon_dead
			else if(((stat == UNCONSCIOUS) || resting || incapacitated(INCAPACITATION_DISABLED) ) && icon_rest)
				icon_state = "[icon_rest]_vore_[upper_shows]_[tail_shows]"

/mob/living/simple_mob/vore/lamia/init_vore()
	. = ..()
	var/obj/belly/B = vore_selected

	B.transferchance = vore_upper_transfer_chance
	B.transferlocation = "tail stomach"

	var/obj/belly/tail = new /obj/belly(src)
	tail.immutable = TRUE
	tail.name = "tail stomach"
	tail.desc = "You slide out into the narrow, constricting tube of flesh that is the lamia's snake half, heated walls and strong muscles all around clinging to your form with every slither."
	tail.digest_mode = vore_default_mode
	tail.mode_flags = vore_default_flags
	tail.item_digest_mode = vore_default_item_mode
	tail.contaminates = vore_default_contaminates
	tail.contamination_flavor = vore_default_contamination_flavor
	tail.contamination_color = vore_default_contamination_color
	tail.escapable = TRUE // needed for transferchance
	tail.escapechance = 0 // No directly escaping a tail, gotta squirm back out.
	tail.digestchance = vore_tail_digest_chance
	tail.absorbchance = vore_tail_absorb_chance
	tail.transferchance = vore_tail_transfer_chance
	tail.transferlocation = "upper stomach"
	tail.human_prey_swallow_time = swallowTime
	tail.nonhuman_prey_swallow_time = swallowTime
	tail.vore_verb = "stuff"
	tail.emote_lists[DM_HOLD] = B.emote_lists[DM_HOLD].Copy()
	tail.emote_lists[DM_DIGEST] = B.emote_lists[DM_DIGEST].Copy()

// FFTA Bra
/mob/living/simple_mob/vore/lamia/bra
	desc = "Combination snake-human. This one is purple. They're wearing a bra."
	icon_state = "ffta_bra"
	icon_living = "ffta_bra"
	icon_rest = "ffta_bra_rest"
	icon_dead = "ffta_bra_dead"

// Albino
/mob/living/simple_mob/vore/lamia/albino
	name = "albino lamia"
	desc = "Combination snake-human. This one is albino."
	icon_state = "albino"
	icon_living = "albino"
	icon_rest = "albino_rest"
	icon_dead = "albino_dead"

/mob/living/simple_mob/vore/lamia/albino/bra
	desc = "Combination snake-human. This one is albino. They're wearing a bra."
	icon_state = "albino_bra"
	icon_living = "albino_bra"
	icon_rest = "albino_bra_rest"
	icon_dead = "albino_bra_dead"

/mob/living/simple_mob/vore/lamia/albino/shirt
	desc = "Combination snake-human. This one is albino. They're wearing a shirt."
	icon_state = "albino_shirt"
	icon_living = "albino_shirt"
	icon_rest = "albino_shirt_rest"
	icon_dead = "albino_shirt_dead"

// Cobra
/mob/living/simple_mob/vore/lamia/cobra
	name = "cobra lamia"
	desc = "Combination snake-human. This one looks like a cobra."
	icon_state = "cobra"
	icon_living = "cobra"
	icon_rest = "cobra_rest"
	icon_dead = "cobra_dead"

/mob/living/simple_mob/vore/lamia/cobra/bra
	desc = "Combination snake-human. This one looks like a cobra. They're wearing a bra."
	icon_state = "cobra_bra"
	icon_living = "cobra_bra"
	icon_rest = "cobra_bra_rest"
	icon_dead = "cobra_bra_dead"

/mob/living/simple_mob/vore/lamia/cobra/shirt
	desc = "Combination snake-human. This one looks like a cobra. They're wearing a shirt."
	icon_state = "cobra_shirt"
	icon_living = "cobra_shirt"
	icon_rest = "cobra_shirt_rest"
	icon_dead = "cobra_shirt_dead"

// Copper
/mob/living/simple_mob/vore/lamia/copper
	name = "copper lamia"
	desc = "Combination snake-human. This one is copper."
	icon_state = "copper"
	icon_living = "copper"
	icon_rest = "copper_rest"
	icon_dead = "copper_dead"

/mob/living/simple_mob/vore/lamia/copper/bra
	desc = "Combination snake-human. This one is copper. They're wearing a bra."
	icon_state = "copper_bra"
	icon_living = "copper_bra"
	icon_rest = "copper_bra_rest"
	icon_dead = "copper_bra_dead"

/mob/living/simple_mob/vore/lamia/copper/shirt
	desc = "Combination snake-human. This one is copper. They're wearing a shirt."
	icon_state = "copper_shirt"
	icon_living = "copper_shirt"
	icon_rest = "copper_shirt_rest"
	icon_dead = "copper_shirt_dead"

// Green
/mob/living/simple_mob/vore/lamia/green
	name = "green lamia"
	desc = "Combination snake-human. This one is green."
	icon_state = "green"
	icon_living = "green"
	icon_rest = "green_rest"
	icon_dead = "green_dead"

/mob/living/simple_mob/vore/lamia/green/bra
	desc = "Combination snake-human. This one is green. They're wearing a bra."
	icon_state = "green_bra"
	icon_living = "green_bra"
	icon_rest = "green_bra_rest"
	icon_dead = "green_bra_dead"

/mob/living/simple_mob/vore/lamia/green/shirt
	desc = "Combination snake-human. This one is green. They're wearing a shirt."
	icon_state = "green_shirt"
	icon_living = "green_shirt"
	icon_rest = "green_shirt_rest"
	icon_dead = "green_shirt_dead"

// Zebra
/mob/living/simple_mob/vore/lamia/zebra
	name = "zebra lamia"
	desc = "Combination snake-human. This one has a zebra pattern."
	icon_state = "zebra"
	icon_living = "zebra"
	icon_rest = "zebra_rest"
	icon_dead = "zebra_dead"

/mob/living/simple_mob/vore/lamia/zebra/bra
	desc = "Combination snake-human. This one has a zebra pattern. They're wearing a bra."
	icon_state = "zebra_bra"
	icon_living = "zebra_bra"
	icon_rest = "zebra_bra_rest"
	icon_dead = "zebra_bra_dead"

/mob/living/simple_mob/vore/lamia/zebra/shirt
	desc = "Combination snake-human. This one has a zebra pattern. They're wearing a shirt."
	icon_state = "zebra_shirt"
	icon_living = "zebra_shirt"
	icon_rest = "zebra_shirt_rest"
	icon_dead = "zebra_shirt_dead"

GLOBAL_LIST_INIT(valid_random_lamias, list(
	/mob/living/simple_mob/vore/lamia,
	/mob/living/simple_mob/vore/lamia/bra,
	/mob/living/simple_mob/vore/lamia/albino,
	/mob/living/simple_mob/vore/lamia/albino/bra,
	/mob/living/simple_mob/vore/lamia/albino/shirt,
	/mob/living/simple_mob/vore/lamia/cobra,
	/mob/living/simple_mob/vore/lamia/cobra/bra,
	/mob/living/simple_mob/vore/lamia/cobra/shirt,
	/mob/living/simple_mob/vore/lamia/copper,
	/mob/living/simple_mob/vore/lamia/copper/bra,
	/mob/living/simple_mob/vore/lamia/copper/shirt,
	/mob/living/simple_mob/vore/lamia/green,
	/mob/living/simple_mob/vore/lamia/green/bra,
	/mob/living/simple_mob/vore/lamia/green/shirt,
	/mob/living/simple_mob/vore/lamia/zebra,
	/mob/living/simple_mob/vore/lamia/zebra/bra,
	/mob/living/simple_mob/vore/lamia/zebra/shirt,
))

/mob/living/simple_mob/vore/lamia/random
/mob/living/simple_mob/vore/lamia/random/New()
	var/mob/living/simple_mob/vore/lamia/new_attrs = pick(GLOB.valid_random_lamias)

	name = initial(new_attrs.name)
	desc = initial(new_attrs.desc)

	icon_state = initial(new_attrs.icon_state)
	icon_living = initial(new_attrs.icon_living)
	icon_rest = initial(new_attrs.icon_rest)
	icon_dead = initial(new_attrs.icon_dead)

	vore_default_mode = initial(new_attrs.vore_default_mode)
	vore_digest_chance = initial(new_attrs.vore_digest_chance)
	vore_pounce_chance = initial(new_attrs.vore_pounce_chance)
	vore_bump_chance = initial(new_attrs.vore_bump_chance)
	vore_standing_too = initial(new_attrs.vore_standing_too)
	vore_escape_chance = initial(new_attrs.vore_escape_chance)

	vore_upper_transfer_chance = initial(new_attrs.vore_upper_transfer_chance)
	vore_tail_digest_chance = initial(new_attrs.vore_tail_digest_chance)
	vore_tail_absorb_chance = initial(new_attrs.vore_tail_absorb_chance)
	vore_tail_transfer_chance = initial(new_attrs.vore_tail_transfer_chance)

	. = ..()

/datum/say_list/lamia
	speak = list("Sss...","Sss!","Hiss!","HSSSSS")
	emote_hear = list("hisses","slithers")
	emote_see = list("shakes her head","coils","stretches","slithers")
