/datum/category_item/catalogue/fauna/succlet
	name = "Alien Wildlife - Succlet"
	desc = "The Catslug is an omnivorous terrestrial creature.\
	Exhibiting properties of both a cat and a slug (hence its name)\
	it moves somewhat awkwardly. However, the unique qualities of\
	its body make it exceedingly flexible and smooth, allowing it to\
	wiggle into and move effectively in even extremely tight spaces.\
	Additionally, it has surprisingly capable hands, and moves quite\
	well on two legs or four. Caution is advised when interacting\
	with these creatures, they are quite intelligent, and proficient\
	tool users."
	value = CATALOGUER_REWARD_MEDIUM


/mob/living/simple_mob/vore/alienanimals/succlet
	name = "succlet"
	desc = "A soft, fuzzy, innocent looking star shaped creature."

	icon_state = "succlet"
	icon_living = "succlet"
	icon_dead = "succlet"
	icon_rest = "succlet"
	icon = 'icons/mob/alienanimals_x32.dmi'

	maxHealth = 10
	health = 10
	movement_cooldown = 1000
	meat_amount = 2
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat

	response_help = "hugs"
	response_disarm = "rudely paps"
	response_harm = "punches"

	harm_intent_damage = 1
	melee_damage_lower = 1
	melee_damage_upper = 1

	mob_size = MOB_SMALL
	friendly = list("hugs")

	catalogue_data = list(/datum/category_item/catalogue/fauna/succlet)
	ai_holder_type = null
	say_list_type = /datum/say_list/succlet
	player_msg = "You are a succlet."
	has_langs = list(LANGUAGE_ANIMAL)

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	maxbodytemp = 9999
	unsuitable_atoms_damage = 0

	vore_active = 1
	vore_capacity = 1
	vore_bump_chance = 1
	vore_ignores_undigestable = 0
	vore_default_mode = DM_SELECT
	vore_icons = SA_ICON_LIVING
	vore_stomach_name = "stummy"
	vore_default_item_mode = IM_DIGEST

	var/succlet_move_chance = 1

/datum/say_list/succlet
	speak = list()
	emote_hear = list()
	emote_see = list()
	say_maybe_target = list()
	say_got_target = list()

/mob/living/simple_mob/vore/alienanimals/succlet/init_vore()
	..()
	var/obj/belly/B = vore_selected
	B.name = "stummy"
	B.desc = "It's a star shaped stomach. A stummy, if you will. It's warm and soft, not unlike plush, but it's tight!"
	B.mode_flags = DM_FLAG_THICKBELLY | DM_FLAG_NUMBING
	B.belly_fullscreen = "yet_another_tumby"
	B.digest_brute = 0
	B.digest_burn = 0
	B.digest_oxy = 12
	B.digestchance = 0
	B.absorbchance = 0
	B.escapechance = 10
	B.selective_preference = DM_ABSORB

/mob/living/simple_mob/vore/alienanimals/succlet/Move(atom/newloc, direct, movetime)
	if(pulledby)
		. = ..()
	else return

/mob/living/simple_mob/vore/alienanimals/succlet/AltClickOn(atom/A)
	if(get_dist(get_turf(src),get_turf(A)) > 1)
		succlet_move(A)
	else
		. = ..()

/mob/living/simple_mob/vore/alienanimals/succlet/Life()
	. = ..()
	if(stat)
		return
	if(client)
		return
	if(prob(succlet_move_chance))
		var/list/mylist = list()
		for(var/mob/M in view(world.view, get_turf(src)))
			if(istype(M, /mob/living/simple_mob/vore/alienanimals/succlet))
				continue
			if(isobserver(M))
				continue
			if(ismob(M))
				mylist |= M
		if(mylist.len > 0)
			succlet_move(pick(mylist))
		else
			for(var/turf/T in view(world.view, get_turf(src)))
				if(isturf(T))
					mylist |= T
			succlet_move(pick(mylist))


/mob/living/simple_mob/vore/alienanimals/succlet/proc/succlet_move(var/target)
	if(!target)
		return

	var/turf/target_turf
	var/mob/living/l

	if(isliving(target))
		l = target
		if(l.devourable && l.allowmobvore && l.can_be_drop_prey)
			target_turf = get_turf(l)
		else
			to_chat(src, "<span class='warning'>You can't move on to [l], they are watching...</span>")
			return
	else if(isturf(target))
		target_turf = target

	if(target_turf)

		if(target_turf.density)
			return
		for(var/atom/A in target_turf)
			if(ismob(A))
				continue
			else if(A.density && !(A.flags & ON_BORDER))
				to_chat(src, "<span class='warning'>You can't move there...</span>")
				return
	else
		return

	var/my_turf = get_turf(src)
	for(var/atom/M in view(world.view, my_turf))	//Is anyone who is not us or our target around where we are?
		if(isliving(M) && M != src && M != target && !istype(M, /mob/observer) && !M.invisibility)
			var/mob/living/check = M
			if(check.stat)
				to_chat(src, "<span class='warning'>You can't move, [check] is watching...</span>")
				return
			else if (!check.eye_blind)
				to_chat(src, "<span class='warning'>You can't move, [check] is watching...</span>")
				return
	for(var/atom/T in view(world.view, target_turf))	//Is anyone at our target?
		if(isliving(T) && T != src && T != target && !istype(T, /mob/observer) && !T.invisibility)
			var/mob/living/check = T
			if(check.stat)
				to_chat(src, "<span class='warning'>You can't move, [check] is watching...</span>")
				return
			else if (!check.eye_blind)
				to_chat(src, "<span class='warning'>You can't move, [check] is watching...</span>")
				return
	forceMove(target_turf)
	if(l)
		l.Weaken(5)
		animal_nom(l)
		l.stop_pulling()


/mob/living/simple_mob/vore/alienanimals/succlet/big
	icon_state = "big_succlet"
	icon_living = "big_succlet"
	icon_dead = "big_succlet"
	icon_rest = "big_succlet"

/mob/living/simple_mob/vore/alienanimals/succlet/dark
	color = "#333333"

/mob/living/simple_mob/vore/alienanimals/succlet/poison
	color = "#573b75"

/mob/living/simple_mob/vore/alienanimals/succlet/moss
	color = "#1a6b27"
