/mob/living/simple_mob/vore/demonAI
	name = "Rift Walker"
	desc = "A large bipedal creature, its body has a mixture of dark fur and scales. Marks on the creature's body pulse slowly with red light."

	icon_state = "boxfox"
	icon_living = "boxfox"
	icon_dead = "dead"
	icon_rest = "boxfox_rest"
	icon = 'icons/mob/demon_vr.dmi'
	vis_height = 47
	ai_holder_type = /datum/ai_holder/simple_mob/melee/hit_and_run
	var/cloaked_alpha = 60			// Lower = Harder to see.
	var/cloaked_bonus_damage = 30	// This is added on top of the normal melee damage.
	var/cloaked_weaken_amount = 3	// How long to stun for.
	var/cloak_cooldown = 10 SECONDS	// Amount of time needed to re-cloak after losing it.
	var/last_uncloak = 0			// world.time

	faction = "demon"
	maxHealth = 200
	health = 200
	movement_cooldown = 0

	see_in_dark = 10
	has_hands = TRUE
	seedarkness = FALSE
	attack_sound = 'sound/misc/demonattack.ogg'
	has_langs = list(LANGUAGE_GALCOM,LANGUAGE_SHADEKIN,LANGUAGE_CULT)

	melee_damage_lower = 10
	melee_damage_upper = 5
	var/poison_chance = 50
	var/poison_type = REAGENT_ID_MINDBREAKER
	var/poison_per_bite = 3

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	maxbodytemp = 96669

	response_help = "touches"
	response_disarm = "pushes"
	response_harm = "hits"

	attacktext = list("mauled","slashed","clawed")
	friendly = list("pokes", "scratches", "rurrs softly at", "sniffs on")

	vore_active = 1
	swallowTime = 2 SECOND
	vore_pounce_chance = 15
	vore_icons = SA_ICON_LIVING
	vore_escape_chance = 25

	var/shifted_out = FALSE
	var/shift_state = AB_SHIFT_NONE
	var/last_shift = 0
	var/blood_spawn = 0
	var/is_shifting = FALSE

	can_pain_emote = FALSE
	injury_enrages = TRUE

/mob/living/simple_mob/vore/demonAI/load_default_bellies()
	. = ..()
	var/obj/belly/B = vore_selected
	B.name = "Stomach"
	B.desc = "You slide down the slick, slippery gullet of the creature. It's warm, and the air is thick. You can feel the doughy walls of the creatures gut push and knead into your form! Slimy juices coat your form stinging against your flesh as they waste no time to start digesting you. The creature's heartbeat and the gurgling of their stomach are all you can hear as your jostled about, treated like nothing but food."

/mob/living/simple_mob/vore/demonAI/UnarmedAttack()
	if(shifted_out)
		return FALSE

	. = ..()

/mob/living/simple_mob/vore/demonAI/can_fall()
	if(shifted_out)
		return FALSE

	return ..()

/mob/living/simple_mob/vore/demonAI/zMove(direction)
	if(shifted_out)
		var/turf/destination = (direction == UP) ? GetAbove(src) : GetBelow(src)
		if(destination)
			forceMove(destination)
		return TRUE

	return ..()

/mob/living/simple_mob/vore/demonAI/Life()
	. = ..()
	if(shifted_out)
		density = FALSE

/mob/living/simple_mob/vore/demonAI/handle_atmos()
	if(shifted_out)
		return
	else
		return .=..()

/mob/living/simple_mob/vore/demonAI/update_canmove()
	if(is_shifting)
		canmove = FALSE
		return canmove
	else
		return ..()

/mob/living/simple_mob/vore/demonAI/cloak()
	if(cloaked)
		return
	animate(src, alpha = cloaked_alpha, time = 1 SECOND)
	cloaked = TRUE


/mob/living/simple_mob/vore/demonAI/uncloak()
	last_uncloak = world.time // This is assigned even if it isn't cloaked already, to 'reset' the timer if the spider is continously getting attacked.
	if(!cloaked)
		return
	animate(src, alpha = initial(alpha), time = 1 SECOND)
	cloaked = FALSE

// Check if cloaking if possible.
/mob/living/simple_mob/vore/demonAI/proc/can_cloak()
	if(stat)
		return FALSE
	if(last_uncloak + cloak_cooldown > world.time)
		return FALSE

	return TRUE

// Called by things that break cloaks, like Technomancer wards.
/mob/living/simple_mob/vore/demonAI/break_cloak()
	uncloak()

/mob/living/simple_mob/vore/demonAI/is_cloaked()
	return cloaked

// Cloaks the spider automatically, if possible.
/mob/living/simple_mob/vore/demonAI/handle_special()
	if(!cloaked && can_cloak())
		cloak()

// Applies bonus base damage if cloaked.
/mob/living/simple_mob/vore/demonAI/apply_bonus_melee_damage(atom/A, damage_amount)
	if(cloaked)
		playsound(src.loc, 'sound/effects/blobattack.ogg', 50, 1)
		uncloak()
		return damage_amount + cloaked_bonus_damage
	return ..()

// Force uncloaking if attacked.
/mob/living/simple_mob/vore/demonAI/bullet_act(obj/item/projectile/P)
	. = ..()
	break_cloak()

/mob/living/simple_mob/vore/demonAI/hit_with_weapon(obj/item/O, mob/living/user, effective_force, hit_zone)
	. = ..()
	break_cloak()

/mob/living/simple_mob/vore/demonAI/apply_melee_effects(var/atom/A)
	if(isliving(A))
		var/mob/living/L = A
		if(L.reagents)
			var/target_zone = pick(BP_TORSO,BP_TORSO,BP_TORSO,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_HEAD)
			if(L.can_inject(src, null, target_zone))
				inject_poison(L, target_zone)

/mob/living/simple_mob/vore/demonAI/proc/inject_poison(mob/living/L, target_zone)
	if(prob(poison_chance))
		to_chat(L, span_warning("You feel a tiny prick."))
		L.reagents.add_reagent(poison_type, poison_per_bite)


/mob/living/simple_mob/vore/demonAI/death()
	playsound(src, 'sound/misc/demondeath.ogg', 50, 1)
	..()

/mob/living/simple_mob/vore/demonAI/bullet_act()
	playsound(src, 'sound/misc/demonlaugh.ogg', 50, 1)
	..()

/mob/living/simple_mob/vore/demonAI/attack_hand()
	playsound(src, 'sound/misc/demonlaugh.ogg', 50, 1)
	..()

/mob/living/simple_mob/vore/demonAI/hitby()
	playsound(src, 'sound/misc/demonlaugh.ogg', 50, 1)
	..()

/mob/living/simple_mob/vore/demonAI/attackby()
	playsound(src, 'sound/misc/demonlaugh.ogg', 50, 1)
	..()

/mob/living/simple_mob/vore/demonAI/gibspam

/mob/living/simple_mob/vore/demonAI/gibspam/apply_bonus_melee_damage(atom/A, damage_amount)
	var/turf/T = get_turf(src)
	if(cloaked)
		new /obj/effect/gibspawner/generic(T)
	return ..()
