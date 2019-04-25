//
// Abstract Class
//

/mob/living/simple_mob/animal/space/mimic
	name = "crate"
	desc = "A rectangular steel crate."

	icon_state = "crate"
	icon_living = "crate"
	icon = 'icons/obj/storage.dmi'

	faction = "mimic"

	maxHealth = 250
	health = 250
	//speed = 4 no idea what this is, conflicts with new AI update.
	movement_cooldown = 10 //slow crate.

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

	meat_type = /obj/item/weapon/reagent_containers/food/snacks/carpmeat

	say_list_type = /datum/say_list/mimic
	ai_holder_type = /datum/ai_holder/mimic

	var/knockdown_chance = 15 //Stubbing your toe on furniture hurts.

	showvoreprefs = 0 //VOREStation Edit - Hides mechanical vore prefs for mimics. You can't see their gaping maws when they're just sitting idle.

/datum/say_list/mimic
	say_got_target = list("growls")

/datum/ai_holder/mimic
	wander = FALSE
	hostile = TRUE
	threaten = TRUE
	threaten_timeout = 5 SECONDS
	threaten_delay = 1 SECONDS //not a threat, more of a delay.

/mob/living/simple_mob/animal/space/carp/apply_melee_effects(var/atom/A)
	if(isliving(A))
		var/mob/living/L = A
		if(prob(knockdown_chance))
			L.Weaken(3)
			L.visible_message(span("danger", "\The [src] knocks down \the [L]!"))

/* should be covered by my "growls" say thing, but keeping it just in case.
/mob/living/simple_mob/animal/space/mimic/set_target()
	. = ..()
	if(.)
		audible_emote("growls at [.]")
*/
/mob/living/simple_mob/animal/space/mimic/death()
	..()
	qdel(src)

/mob/living/simple_mob/animal/space/mimic/will_show_tooltip()
	return FALSE

/mob/living/simple_mob/animal/space/mimic/death()
	var/obj/structure/closet/crate/C = new(get_turf(src))
	// Put loot in crate
	for(var/obj/O in src)
		if(isbelly(O)) //VOREStation edit
			continue
		O.forceMove(C)
	..()

/mob/living/simple_mob/animal/space/mimic/Initialize()
	. = ..()
	for(var/obj/item/I in loc)
		I.forceMove(src)
/* I honestly have no idea what's happening down there so I'm just taking the essentials and yeeting.
//
// Crate Mimic
//

// Aggro when you try to open them. Will also pickup loot when spawns and drop it when dies.
/mob/living/simple_mob/animal/space/mimic/crate

	attacktext = list("bitten")

//	stop_automated_movement = 1 we don't need these
//	wander = 0
	var/attempt_open = 0

// Pickup loot
/mob/living/simple_mob/animal/space/mimic/crate/Initialize()
	. = ..()
	for(var/obj/item/I in loc)
		I.forceMove(src)
/* I can't find an equivilant to this, don't know why we really have it even so...
/mob/living/simple_mob/animal/space/mimic/crate/DestroySurroundings()
	..()
	if(prob(90))
		icon_state = "[initial(icon_state)]open"
	else
		icon_state = initial(icon_state)
*/
/mob/living/simple_mob/animal/space/mimic/crate/ListTargets()
	if(attempt_open)
		return ..()
	else
		return ..(1)

/mob/living/simple_mob/animal/space/mimic/crate/set_target()
	. = ..()
	if(.)
		trigger()

/mob/living/simple_mob/animal/space/mimic/crate/PunchTarget()
	. = ..()
	if(.)
		icon_state = initial(icon_state)

/mob/living/simple_mob/animal/space/mimic/crate/proc/trigger()
	if(!attempt_open)
		visible_message("<b>[src]</b> starts to move!")
		attempt_open = 1

/mob/living/simple_mob/animal/space/mimic/crate/adjustBruteLoss(var/damage)
	trigger()
	..(damage)

/mob/living/simple_mob/animal/space/mimic/crate/LoseTarget()
	..()
	icon_state = initial(icon_state)

/mob/living/simple_mob/animal/space/mimic/crate/LostTarget()
	..()
	icon_state = initial(icon_state)

/mob/living/simple_mob/animal/space/mimic/crate/death()
	var/obj/structure/closet/crate/C = new(get_turf(src))
	// Put loot in crate
	for(var/obj/O in src)
		if(isbelly(O)) //VOREStation edit
			continue
		O.forceMove(C)
	..()

/mob/living/simple_mob/animal/space/mimic/crate/PunchTarget()
	. =..()
	var/mob/living/L = .
	if(istype(L))
		if(prob(15))
			L.Weaken(2)
			L.visible_message("<span class='danger'>\the [src] knocks down \the [L]!</span>")

//
// Copy Mimic
//

var/global/list/protected_objects = list(/obj/structure/table, /obj/structure/cable, /obj/structure/window, /obj/item/projectile/animate)

/mob/living/simple_mob/animal/space/mimic/copy

	health = 100
	maxHealth = 100
	var/mob/living/creator = null // the creator
	var/destroy_objects = 0
	var/knockdown_people = 0

/mob/living/simple_mob/animal/space/mimic/copy/New(loc, var/obj/copy, var/mob/living/creator)
	..(loc)
	CopyObject(copy, creator)

/mob/living/simple_mob/animal/space/mimic/copy/death()

	for(var/atom/movable/M in src)
		if(isbelly(M)) //VOREStation edit
			continue
		M.forceMove(get_turf(src))
	..()

/mob/living/simple_mob/animal/space/mimic/copy/ListTargets()
	// Return a list of targets that isn't the creator
	. = ..()
	return . - creator

/mob/living/simple_mob/animal/space/mimic/copy/proc/CopyObject(var/obj/O, var/mob/living/creator)

	if((istype(O, /obj/item) || istype(O, /obj/structure)) && !is_type_in_list(O, protected_objects))

		O.forceMove(src)
		name = O.name
		desc = O.desc
		icon = O.icon
		icon_state = O.icon_state
		icon_living = icon_state

		if(istype(O, /obj/structure))
			health = (anchored * 50) + 50
			destroy_objects = 1
			if(O.density && O.anchored)
				knockdown_people = 1
				melee_damage_lower *= 2
				melee_damage_upper *= 2
		else if(istype(O, /obj/item))
			var/obj/item/I = O
			health = 15 * I.w_class
			melee_damage_lower = 2 + I.force
			melee_damage_upper = 2 + I.force
			move_to_delay = 2 * I.w_class

		maxHealth = health
		if(creator)
			src.creator = creator
			faction = "\ref[creator]" // very unique
		return 1
	return

/mob/living/simple_mob/animal/space/mimic/copy/DestroySurroundings()
	if(destroy_objects)
		..()

/mob/living/simple_mob/animal/space/mimic/copy/PunchTarget()
	. =..()
	if(knockdown_people)
		var/mob/living/L = .
		if(istype(L))
			if(prob(15))
				L.Weaken(1)
				L.visible_message("<span class='danger'>\the [src] knocks down \the [L]!</span>")
*/