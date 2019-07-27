//
// Abstract Class
//

/mob/living/simple_mob/hostile/mimic
	name = "crate"
	desc = "A rectangular steel crate."
	icon = 'icons/obj/storage.dmi'
	icon_state = "crate"
	icon_living = "crate"

	faction = "mimic"
	intelligence_level = SA_ANIMAL

	maxHealth = 250
	health = 250
	speed = 4
	move_to_delay = 8

	response_help = "touches"
	response_disarm = "pushes"
	response_harm = "hits"

	harm_intent_damage = 5
	melee_damage_lower = 8
	melee_damage_upper = 12
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

	showvoreprefs = 0 //VOREStation Edit - Hides mechanical vore prefs for mimics. You can't see their gaping maws when they're just sitting idle.

/mob/living/simple_mob/hostile/mimic/set_target()
	. = ..()
	if(.)
		audible_emote("growls at [.]")

/mob/living/simple_mob/hostile/mimic/death()
	..()
	qdel(src)

/mob/living/simple_mob/hostile/mimic/will_show_tooltip()
	return FALSE


//
// Crate Mimic
//

// Aggro when you try to open them. Will also pickup loot when spawns and drop it when dies.
/mob/living/simple_mob/hostile/mimic/crate

	attacktext = list("bitten")

	stop_automated_movement = 1
	wander = 0
	var/attempt_open = 0

// Pickup loot
/mob/living/simple_animal/hostile/mimic/crate/Initialize()
	. = ..()
	for(var/obj/item/I in loc)
		I.forceMove(src)

/mob/living/simple_mob/hostile/mimic/crate/DestroySurroundings()
	..()
	if(prob(90))
		icon_state = "[initial(icon_state)]open"
	else
		icon_state = initial(icon_state)

/mob/living/simple_mob/hostile/mimic/crate/ListTargets()
	if(attempt_open)
		return ..()
	else
		return ..(1)

/mob/living/simple_mob/hostile/mimic/crate/set_target()
	. = ..()
	if(.)
		trigger()

/mob/living/simple_mob/hostile/mimic/crate/PunchTarget()
	. = ..()
	if(.)
		icon_state = initial(icon_state)

/mob/living/simple_mob/hostile/mimic/crate/proc/trigger()
	if(!attempt_open)
		visible_message("<b>[src]</b> starts to move!")
		attempt_open = 1

/mob/living/simple_mob/hostile/mimic/crate/adjustBruteLoss(var/damage)
	trigger()
	..(damage)

/mob/living/simple_mob/hostile/mimic/crate/LoseTarget()
	..()
	icon_state = initial(icon_state)

/mob/living/simple_mob/hostile/mimic/crate/LostTarget()
	..()
	icon_state = initial(icon_state)

/mob/living/simple_mob/hostile/mimic/crate/death()
	var/obj/structure/closet/crate/C = new(get_turf(src))
	// Put loot in crate
	for(var/obj/O in src)
		if(isbelly(O)) //VOREStation edit
			continue
		O.forceMove(C)
	..()

/mob/living/simple_mob/hostile/mimic/crate/PunchTarget()
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

/mob/living/simple_mob/hostile/mimic/copy

	health = 100
	maxHealth = 100
	var/mob/living/creator = null // the creator
	var/destroy_objects = 0
	var/knockdown_people = 0

/mob/living/simple_mob/hostile/mimic/copy/New(loc, var/obj/copy, var/mob/living/creator)
	..(loc)
	CopyObject(copy, creator)

/mob/living/simple_mob/hostile/mimic/copy/death()

	for(var/atom/movable/M in src)
		if(isbelly(M)) //VOREStation edit
			continue
		M.forceMove(get_turf(src))
	..()

/mob/living/simple_mob/hostile/mimic/copy/ListTargets()
	// Return a list of targets that isn't the creator
	. = ..()
	return . - creator

/mob/living/simple_mob/hostile/mimic/copy/proc/CopyObject(var/obj/O, var/mob/living/creator)

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

/mob/living/simple_mob/hostile/mimic/copy/DestroySurroundings()
	if(destroy_objects)
		..()

/mob/living/simple_mob/hostile/mimic/copy/PunchTarget()
	. =..()
	if(knockdown_people)
		var/mob/living/L = .
		if(istype(L))
			if(prob(15))
				L.Weaken(1)
				L.visible_message("<span class='danger'>\the [src] knocks down \the [L]!</span>")
