// Kururaks, large pack-hunting felinids that reside in coastal regions. Less slowdown in water, speed on rocky turf.

/datum/category_item/catalogue/fauna/kururak
	name = "Sivian Fauna - Kururak"
	desc = "Classification: S Felidae fluctursora \
	<br><br>\
	An uncommon sight to many Sivian residents, these creatures are hypercarnivores, with\
	their diets almost exclusively consisting of other fauna. This is achieved in the frozen \
	environments of Sif via the means of fishing, even going to the lengths of evolving a \
	third, dense lung only inflated for long dives. \
	<br>\
	One of the most distinguishing features of these animals are their four tails, capped in \
	reflective 'mirrors'. These mirrors are used for tricking fish and other prey into ambushes,\
	or distract would-be rivals. \
	<br>\
	Kururak packs are incredibly dangerous if faced alone, and should only be approached if prepared \
	for a fight."
	value = CATALOGUER_REWARD_HARD

/mob/living/simple_mob/animal/sif/kururak
	name = "kururak"
	desc = "A large animal with sleek fur."
	tt_desc = "S Felidae fluctursora"
	catalogue_data = list(/datum/category_item/catalogue/fauna/kururak)

	faction = FACTION_KURUAK

	icon_state = "bigcat"
	icon_living = "bigcat"
	icon_dead = "bigcat_dead"
	icon_rest = "bigcat_sleep"
	icon = 'icons/mob/64x64.dmi'

	default_pixel_x = -16
	pixel_x = -16

	maxHealth = 200
	health = 200

	universal_understand = 1

	movement_cooldown = -1

	melee_damage_lower = 15
	melee_damage_upper = 20
	attack_armor_pen = 40
	base_attack_cooldown = 2 SECONDS
	attacktext = list("gouged", "bit", "cut", "clawed", "whipped")

	organ_names = /decl/mob_organ_names/kururak
	meat_amount = 5

	armor = list(
		"melee" = 30,
		"bullet" = 15,
		"laser" = 5,
		"energy" = 0,
		"bomb" = 10,
		"bio" = 100,
		"rad" = 100
		)

	armor_soak = list(
		"melee" = 5,
		"bullet" = 5,
		"laser" = 5,
		"energy" = 0,
		"bomb" = 0,
		"bio" = 0,
		"rad" = 0
		)

	say_list_type = /datum/say_list/kururak
	ai_holder_type = /datum/ai_holder/simple_mob/intentional/kururak

	special_attack_min_range = 0
	special_attack_max_range = 4
	special_attack_cooldown = 1 MINUTE

	// Players have 2 seperate cooldowns for these, while the AI must choose one. Both respect special_attack_cooldown
	var/last_strike_time = 0
	var/last_flash_time = 0

	var/instinct	// The points used by Kururaks to decide Who Is The Boss
	var/obey_pack_rule = TRUE	// Decides if the Kururak will automatically assign itself to follow the one with the highest instinct.

/datum/say_list/kururak
	speak = list("Kurr?","|R|rrh..", "Ksss...")
	emote_see = list("scratches its ear","flutters its tails", "flicks an ear", "shakes out its hair")
	emote_hear = list("chirps", "clicks", "grumbles", "chitters")

/mob/living/simple_mob/animal/sif/kururak/leader	// Going to be the starting leader. Has some base buffs to make it more likely to stay the leader.
	maxHealth = 250
	health = 250
	instinct = 50

/mob/living/simple_mob/animal/sif/kururak/Initialize()
	. = ..()
	if(!instinct)
		if(prob(20))
			instinct = rand(6, 10)
			return
		instinct = rand(0, 5)

/mob/living/simple_mob/animal/sif/kururak/IIsAlly(mob/living/L)
	. = ..()
	if(!.)
		if(issilicon(L))	// Metal things are usually reflective, or in general aggrivating.
			return FALSE
		if(ishuman(L))	// Might be metal, but they're humanoid shaped.
			var/mob/living/carbon/human/H = L
			if(H.get_active_hand())
				var/obj/item/I = H.get_active_hand()
				if(I.force <= 1.25 * melee_damage_upper)
					return TRUE
		else if(istype(L, /mob/living/simple_mob))
			var/mob/living/simple_mob/S = L
			if(S.melee_damage_upper > 1.5 * melee_damage_upper)
				return TRUE

/mob/living/simple_mob/animal/sif/kururak/handle_special()
	..()
	if(client)
		pack_gauge()

/mob/living/simple_mob/animal/sif/kururak/apply_melee_effects(atom/A)	// Only gains instinct.
	instinct += rand(1, 2)
	return ..()

/mob/living/simple_mob/animal/sif/kururak/should_special_attack(atom/A)
	return has_modifier_of_type(/datum/modifier/ace)

/mob/living/simple_mob/animal/sif/kururak/do_special_attack(atom/A)
	. = TRUE
	switch(a_intent)
		if(I_DISARM) // Ranged mob flash, will also confuse borgs rather than stun.
			tail_flash(A)
		if(I_GRAB) // Armor-ignoring hit, causes agonizing wounds.
			set_AI_busy(TRUE)
			rending_strike(A)
			set_AI_busy(FALSE)
	a_intent = I_HURT
	return ..()

/mob/living/simple_mob/animal/sif/kururak/verb/do_flash()
	set category = "Abilities"
	set name = "Tail Blind"
	set desc = "Disorient a creature within range."

	if(world.time < last_flash_time + special_attack_cooldown)
		to_chat(src, span("warning", "You do not have the focus to do this so soon.."))
		return

	last_flash_time = world.time
	tail_flash()

/mob/living/simple_mob/animal/sif/kururak/proc/tail_flash(atom/A)
	set waitfor = FALSE

	if(stat)
		to_chat(src, span("warning","You cannot move your tails in this state.."))
		return

	if(!A && src.client)
		var/list/choices = list()
		for(var/mob/living/carbon/C in view(1,src))
			if(src.Adjacent(C))
				choices += C

		for(var/obj/mecha/M in view(1,src))
			if(src.Adjacent(M))
				choices += M

		if(!choices.len)
			choices["radial"] = get_turf(src)

		A = tgui_input_list(src, "What do we wish to flash?", "Target Choice", choices)


	visible_message(span("alien","\The [src] flares its tails!"))
	if(isliving(A))
		var/mob/living/L = A
		if(iscarbon(L))
			var/mob/living/carbon/C = L
			if(C.stat != DEAD)
				var/safety = C.eyecheck()
				if(safety <= 0)
					var/flash_strength = 5
					if(ishuman(C))
						var/mob/living/carbon/human/H = C
						flash_strength *= H.species.flash_mod
						if(flash_strength > 0)
							to_chat(H, span("alien","You are disoriented by \the [src]!"))
							H.eye_blurry = max(H.eye_blurry, flash_strength + 5)
							H.flash_eyes()
							H.apply_damage(flash_strength * H.species.flash_burn/5, BURN, BP_HEAD, 0, 0, "Photon burns")

		else if(issilicon(L))
			if(isrobot(L))
				var/flashfail = FALSE
				var/mob/living/silicon/robot/R = L
				if(R.has_active_type(/obj/item/borg/combat/shield))
					var/obj/item/borg/combat/shield/shield = locate() in R
					if(shield)
						if(shield.active)
							shield.adjust_flash_count(R, 1)
							flashfail = TRUE
				if(!flashfail)
					to_chat(R, span("alien","Your optics are scrambled by \the [src]!"))
					R.Confuse(10)
					R.flash_eyes()

		else
			L.Confuse(10)
			L.flash_eyes()

	else
		for(var/mob/living/carbon/C in oviewers(special_attack_max_range, null))
			var/safety = C.eyecheck()
			if(!safety)
				if(!C.blinded)
					C.flash_eyes()
		for(var/mob/living/silicon/robot/R in oviewers(special_attack_max_range, null))
			if(R.has_active_type(/obj/item/borg/combat/shield))
				var/obj/item/borg/combat/shield/shield = locate() in R
				if(shield)
					if(shield.active)
						continue
			R.flash_eyes()

/mob/living/simple_mob/animal/sif/kururak/verb/do_strike()
	set category = "Abilities"
	set name = "Rending Strike"
	set desc = "Strike viciously at an entity within range."

	if(world.time < last_strike_time + special_attack_cooldown)
		to_chat(src, span("warning", "Your claws cannot take that much stress in so short a time.."))
		return

	last_strike_time = world.time
	rending_strike()

/mob/living/simple_mob/animal/sif/kururak/proc/rending_strike(atom/A)
	if(stat)
		to_chat(src, span("warning","You cannot strike in this state.."))
		return

	if(!A && src.client)
		var/list/choices = list()
		for(var/mob/living/carbon/C in view(1,src))
			if(src.Adjacent(C))
				choices += C

		for(var/obj/mecha/M in view(1,src))
			if(src.Adjacent(M))
				choices += M

		if(!choices.len)
			to_chat(src, span("warning","There are no viable targets within range..."))
			return

		A = tgui_input_list(src, "What do we wish to strike?", "Target Choice", choices)

	if(!A || !src) return

	if(!(src.Adjacent(A))) return

	var/damage_to_apply = rand(melee_damage_lower, melee_damage_upper) + 10
	if(isliving(A))
		visible_message(span("danger","\The [src] rakes its claws across [A]."))
		var/mob/living/L = A
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			H.apply_damage(damage_to_apply, BRUTE, BP_TORSO, 0, 0, "Animal claws")

		else
			L.adjustBruteLoss(damage_to_apply)

		L.add_modifier(/datum/modifier/grievous_wounds, 60 SECONDS)

	else if(istype(A, /obj/mecha))
		visible_message(span("danger","\The [src] rakes its claws against \the [A]."))
		var/obj/mecha/M = A
		M.take_damage(damage_to_apply)
		if(prob(3))
			visible_message(span("critical","\The [src] begins digging its claws into \the [M]'s hatch!"))
			if(do_after(src, 1 SECOND))
				visible_message(span("critical","\The [src] rips \the [M]'s access hatch open, dragging [M.occupant] out!"))
				M.go_out()

	else
		A.attack_generic(src, damage_to_apply, "rakes its claws against")	// Well it's not a mob, and it's not a mech.

/mob/living/simple_mob/animal/sif/kururak/verb/rally_pack()	// Mostly for telling other players to follow you. AI Kururaks will auto-follow, if set to.
	set name = "Rally Pack"
	set desc = "Tries to command your fellow pack members to follow you."
	set category = "Abilities"

	if(has_modifier_of_type(/datum/modifier/ace))
		for(var/mob/living/simple_mob/animal/sif/kururak/K in hearers(7, src))
			if(K == src)
				continue
			if(!K.ai_holder)
				continue
			if(K.faction != src.faction)
				continue
			var/datum/ai_holder/AI = K.ai_holder
			to_chat(K, span("notice","The pack leader wishes for you to follow them."))
			AI.set_follow(src)

/mob/living/simple_mob/animal/sif/kururak/proc/detect_instinct()	// Will return the Kururak within 10 tiles that has the highest instinct.
	var/mob/living/simple_mob/animal/sif/kururak/A

	var/pack_count = 0

	for(var/mob/living/simple_mob/animal/sif/kururak/K in hearers(10, src))
		if(K == src)
			continue
		if(K.stat != DEAD)
			pack_count++
			if(K.instinct > src.instinct)
				A = K

	if(!A && pack_count)
		A = src

	return A

/mob/living/simple_mob/animal/sif/kururak/proc/pack_gauge()	// Check incase we have a client.
	var/mob/living/simple_mob/animal/sif/kururak/highest_instinct = detect_instinct()
	if(highest_instinct == src)
		add_modifier(/datum/modifier/ace, 60 SECONDS)
	else
		remove_modifiers_of_type(/datum/modifier/ace)

/mob/living/simple_mob/animal/sif/kururak/hibernate/Initialize()
	. = ..()
	lay_down()
	instinct = 0

/*
 * Kururak AI
 */

/datum/ai_holder/simple_mob/intentional/kururak
	hostile = FALSE
	retaliate = TRUE
	cooperative = TRUE
	can_flee = TRUE
	flee_when_dying = TRUE

/datum/ai_holder/simple_mob/intentional/kururak/handle_special_strategical()
	follow_distance = rand(initial(follow_distance), initial(follow_distance) + 2)
	var/mob/living/simple_mob/animal/sif/kururak/K = holder

	if(istype(K))
		var/mob/living/simple_mob/animal/sif/kururak/highest_instinct = K.detect_instinct()
		if(highest_instinct == K)
			K.add_modifier(/datum/modifier/ace, 60 SECONDS)
		else
			K.remove_modifiers_of_type(/datum/modifier/ace)

		if(holder.has_modifier_of_type(/datum/modifier/ace))
			if(leader && istype(leader, /mob/living/simple_mob/animal/sif/kururak))	// Kururaks will not follow another kururak if they're the pack leader.
				lose_follow()

		else if(highest_instinct)
			set_follow(highest_instinct)

	if(holder.has_modifier_of_type(/datum/modifier/ace))
		hostile = TRUE
	else
		hostile = initial(hostile)

	return ..()

/datum/ai_holder/simple_mob/intentional/kururak/pre_special_attack(atom/A)
	holder.a_intent = I_HURT
	if(isliving(A))
		var/mob/living/L = A
		if(holder.Adjacent(L))
			holder.a_intent = I_GRAB

		if(iscarbon(L))
			var/mob/living/carbon/C = L
			if(!C.eyecheck())
				if(holder.a_intent != I_GRAB)
					holder.a_intent = I_DISARM

		if(issilicon(L) && holder.a_intent != I_GRAB)
			holder.a_intent = I_DISARM

	else if(istype(A, /obj/mecha))
		holder.a_intent = I_GRAB

	return ..()

/datum/ai_holder/simple_mob/intentional/kururak/post_special_attack(atom/A)
	holder.a_intent = I_HURT
	return ..()

/datum/ai_holder/simple_mob/intentional/kururak/post_melee_attack()
	if(holder.has_modifier_of_type(/datum/modifier/ace))
		request_help()
	return ..()

// Kururak Ace modifier, given to the one with the highest Instinct.

/datum/modifier/ace
	name = "Ace"
	desc = "You are universally superior, in terms of physical prowess."
	on_created_text = "You feel superior."
	on_expired_text = "You feel your superiority lessen..."
	stacks = MODIFIER_STACK_EXTEND

	mob_overlay_state = "ace"

	max_health_flat = 25
	max_health_percent = 1.2
	disable_duration_percent = 0.8
	incoming_damage_percent = 0.7
	incoming_healing_percent = 1.5
	outgoing_melee_damage_percent = 1.5
	evasion = 20
	bleeding_rate_percent = 0.7
	attack_speed_percent = 0.8

/decl/mob_organ_names/kururak
	hit_zones = list("head", "chest", "left foreleg", "right foreleg", "left hind leg", "right hind leg", "far left tail", "far right tail", "left middle tail", "right middle tail")
