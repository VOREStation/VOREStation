/datum/category_item/catalogue/fauna/succlet
	name = "Alien Wildlife - Succlet"
	desc = "Succlet is a friend to fungus. It finds pleasure in absorbing the nutrients of treats, and decomposing other organisms.\
	It is unclear how it manages to move, but succlet can be found seemingly randomly about any environment it has been invited to.\
	Succlets are known to attempt to convince people to obtain additional succlets, and should not be listened to, as once one invites a succlet into their home\
	it will never leave, and will eat their treats forever. It should be noted that despite being a worthless treat stealing creature succlet has not been to prison."
	value = CATALOGUER_REWARD_TRIVIAL

/mob/living/simple_mob/vore/alienanimals/succlet
	name = "succlet"
	desc = "A soft, fuzzy, innocent looking star shaped creature."

	icon_state = "succlet"
	icon_living = "succlet"
	icon_dead = "succlet_dead"
	icon_rest = "succlet"
	icon = 'icons/mob/alienanimals_x32.dmi'

	maxHealth = 10
	health = 10
	movement_cooldown = 1000

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
	player_msg = "You can move with ALT+click. You can only move when no one will see you, unless you are targetting someone. If no one else will see you move, and you can eat the target, then you will be able to move to them. Use your power to responsibly, and move confusingly right to left as if to distract them."
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
	vore_bump_chance = 0
	vore_default_mode = DM_SELECT
	vore_icons = SA_ICON_LIVING
	vore_stomach_name = "stummy"
	vore_default_item_mode = IM_DIGEST

	vore_taste = "some kind of snack from a distant unseen universe"
	vore_smell = "some kind of snack from a distant unseen universe"

	var/succlet_move_chance = 2
	var/succlet_eat_chance = 50
	var/succlet_weaken_rate = 2
	var/succlet_last_health = 10

/datum/say_list/succlet
	speak = list("...")
	emote_hear = list("...")
	emote_see = list("...")
	say_maybe_target = list("...")
	say_got_target = list("...")

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
	B.escapechance = 35
	B.selective_preference = DM_ABSORB

/mob/living/simple_mob/vore/alienanimals/succlet/checkMoveCooldown()
	return FALSE

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
	if(isbelly(loc))	//No teleporting out of bellies
		return
	if(prob(succlet_move_chance) || health < succlet_last_health)	//This chance can be adjusted, but moving is probably pretty resource expensive on the server, so the chance should stay low
		var/list/mylist = list()	//Look I'm just saying, you can make it higher if you want but don't cry to me if the server lags, I made this as a joke
		for(var/mob/M in view(world.view, get_turf(src)))	//Is there anyone nearby to target?
			if(istype(M, /mob/living/simple_mob/vore/alienanimals/succlet))
				continue
			if(isobserver(M))
				continue
			if(M.stat)
				continue
			if(ismob(M))
				mylist |= M
		if(mylist.len > 0)
			succlet_move(pick(mylist))
		else
			for(var/turf/T in view(world.view, get_turf(src)))	//No, so let's pick a turf to travel to
				if(isturf(T))
					mylist |= T
			if(mylist.len)
				succlet_move(pick(mylist))
	succlet_last_health = health	//The succlet will try to move if it has taken damage

/mob/living/simple_mob/vore/alienanimals/succlet/death(gibbed, deathmessage = "shrieks in agony as it is eradicated from reality.")
	. = ..()
	if(isbelly(loc))
		return
	playsound(src,'sound/voice/succlet_shriek.ogg', 100, 1)
	spawn(25)
	qdel(src)

/mob/living/simple_mob/vore/alienanimals/succlet/attackby(var/obj/item/O, var/mob/user)
	if(istype(O, /obj/item/newspaper) && !ckey && isturf(user.loc))
		user.visible_message(span_info("[user] swats [src] with [O]!"))
		release_vore_contents()
	else
		..()

/mob/living/simple_mob/vore/alienanimals/succlet/proc/succlet_move(var/target)
	if(!target)
		return
	if(isbelly(loc))	//No teleporting out of bellies
		return
	var/turf/target_turf
	var/mob/living/l

	if(isliving(target))
		l = target
		if(l.devourable && l.allowmobvore && l.can_be_drop_prey)
			target_turf = get_turf(l)
		else
			to_chat(src, span_warning("You can't move on to [l], they are watching..."))
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
				to_chat(src, span_warning("You can't move there..."))
				return
	else
		return

	var/my_turf = get_turf(src)
	for(var/atom/M in view(world.view, my_turf))	//Is anyone who is not us or our target around where we are?
		if(isliving(M) && M != src && M != target && !istype(M, /mob/observer) && !M.invisibility && !istype(M,/mob/living/simple_mob/vore/alienanimals/succlet))
			var/mob/living/check = M
			if(check.stat == CONSCIOUS)
				to_chat(src, span_warning("You can't move, [check] is watching..."))
				return
			else if (!check.eye_blind)
				to_chat(src, span_warning("You can't move, [check] is watching..."))
				return
	for(var/atom/T in view(world.view, target_turf))	//Is anyone at our target?
		if(isliving(T) && T != src && T != target && !istype(T, /mob/observer) && !T.invisibility && !istype(T,/mob/living/simple_mob/vore/alienanimals/succlet))
			var/mob/living/check = T
			if(check.stat == CONSCIOUS)
				to_chat(src, span_warning("You can't move, [check] is watching..."))
				return
			else if (!check.eye_blind)
				to_chat(src, span_warning("You can't move, [check] is watching..."))
				return
	forceMove(target_turf)
	if(l)
		l.Weaken(succlet_weaken_rate)
		if(client || prob(succlet_eat_chance))
			animal_nom(l)
			l.stop_pulling()


/mob/living/simple_mob/vore/alienanimals/succlet/big
	desc = "A big soft, fuzzy, innocent looking star shaped creature."
	icon_state = "big_succlet"
	icon_living = "big_succlet"
	icon_rest = "big_succlet"
	succlet_weaken_rate = 30	//Big

/mob/living/simple_mob/vore/alienanimals/succlet/dark
	icon_state = "dark_succlet"
	icon_living = "dark_succlet"
	icon_rest = "dark_succlet"

/mob/living/simple_mob/vore/alienanimals/succlet/poison
	desc = "A soft, fuzzy, innocent looking star shaped creature. It looks like it could be poisonous."
	icon_state = "poison_succlet"
	icon_living = "poison_succlet"
	icon_rest = "poison_succlet"

/mob/living/simple_mob/vore/alienanimals/succlet/poison/attack_hand(mob/user)
	. = ..()
	if(user.a_intent != I_HELP)
		if(isliving(user))
			var/mob/living/l = user
			to_chat(l, span_warning("You feel \the [src]'s sting!!!"))
			l.hallucination += 25
			l.adjustHalLoss(200)
			l.adjustToxLoss(10)

/mob/living/simple_mob/vore/alienanimals/succlet/moss
	icon_state = "moss_succlet"
	icon_living = "moss_succlet"
	icon_rest = "moss_succlet"
	vore_taste = "moss"
	vore_smell = "moss"

/mob/living/simple_mob/vore/alienanimals/succlet/king
	desc = "A big soft, fuzzy, innocent looking star shaped creature. It looks regal with its crown!"
	icon_state = "king_succlet"
	icon_living = "king_succlet"
	icon_rest = "king_succlet"
	succlet_weaken_rate = 60	//The weight of authority is heavy!
	vore_taste = "the king of snacks from a distant unseen universe"
	vore_smell = "the king of snacks from a distant unseen universe"

	maxHealth = 10000
	health = 10000
