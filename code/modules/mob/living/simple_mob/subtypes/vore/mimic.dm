/obj/structure/closet/crate/mimic
















/mob/living/simple_mob/vore/aggressive/mimic
	name = "crate"
	desc = "A rectangular steel crate."

	icon_state = "crate"
	icon_living = "crate"
	icon = 'icons/obj/storage.dmi'

	faction = "mimic"

	maxHealth = 250
	health = 250
	movement_cooldown = 5

	response_help = "touches"
	response_disarm = "pushes"
	response_harm = "hits"

	harm_intent_damage = 5
	melee_damage_lower = 4
	melee_damage_upper = 6
	attacktext = list("attacked")
	attack_sound = 'sound/weapons/bite.ogg'

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

	say_list_type = /datum/say_list/mimic
	ai_holder_type = /datum/ai_holder/mimic

	var/obj/structure/closet/crate/real_crate

	var/knockdown_chance = 15 //Stubbing your toe on furniture hurts.

	showvoreprefs = 0 //Hides mechanical vore prefs for mimics. You can't see their gaping maws when they're just sitting idle.

/datum/say_list/mimic
	say_got_target = list("Grrowl!")

/datum/ai_holder/mimic
	wander = FALSE
	hostile = TRUE
	threaten = TRUE
	threaten_timeout = 5 SECONDS
	threaten_delay = 1 SECONDS //not a threat, more of a delay.

/mob/living/simple_mob/vore/aggressive/mimic/apply_melee_effects(var/atom/A)
	if(isliving(A))
		var/mob/living/L = A
		if(prob(knockdown_chance))
			L.Weaken(3)
			L.visible_message(span("danger", "\The [src] knocks down \the [L]!"))

/mob/living/simple_mob/vore/aggressive/mimic/will_show_tooltip()
	return FALSE

/mob/living/simple_mob/vore/aggressive/mimic/death()
	..()
	real_crate.forceMove(loc)
	real_crate = null
	qdel(src)