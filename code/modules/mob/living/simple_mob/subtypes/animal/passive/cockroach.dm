//Base cockroach
/mob/living/simple_mob/animal/passive/cockroach
	name = "cockroach"
	real_name = "cockroach"
	desc = "This station is just crawling with bugs."
	tt_desc = "E Blattella germanica"
	icon = 'icons/mob/animal_vr.dmi'
	icon_state = "cockroach"
	item_state = "cockroach"
	icon_living = "cockroach"
	icon_dead = "cockroach_rest" //No real 'dead' sprite
	icon_rest = "cockroach_rest"

	maxHealth = 1
	health = 1

	movement_cooldown = -1

	mob_size = MOB_MINISCULE
	pass_flags = PASSTABLE
	can_pull_mobs = MOB_PULL_NONE
	layer = MOB_LAYER
	density = FALSE

	response_help  = "pokes"
	response_disarm = "shoos"
	response_harm   = "splats"

	speak_emote = list("chitters")

	//Cockroaches are enviromentally superior
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	maxbodytemp = 999999

	var/squish_chance = 25

//Deletes the body upon death
/mob/living/simple_mob/animal/passive/cockroach/death()
	new /obj/effect/decal/cleanable/bug_remains(src.loc)
	qdel(src)

//Squish code
/mob/living/simple_mob/animal/passive/cockroach/Crossed(var/atom/movable/AM)
	if(ismob(AM))
		if(isliving(AM))
			var/mob/living/A = AM
			if(A.is_incorporeal()) // Bad kin, no squishing the roach
				return
			if(A.mob_size > MOB_SMALL)
				if(prob(squish_chance))
					A.visible_message(span_notice("[A] squashed [src]."), span_notice("You squashed [src]."))
					adjustBruteLoss(1) //kills a normal cockroach
				else
					visible_message(span_notice("[src] avoids getting crushed."))
	else
		if(isstructure(AM))
			if(prob(squish_chance))
				AM.visible_message(span_notice("[src] was crushed under [AM]."))
				adjustBruteLoss(1)
			else
				visible_message(span_notice("[src] avoids getting crushed."))

/mob/living/simple_mob/animal/passive/cockroach/ex_act() //Explosions are a terrible way to handle a cockroach.
	return

//Custom stain so it's not "spiderling remains"
/obj/effect/decal/cleanable/bug_remains
	name = "bug remains"
	desc = "Green squishy mess."
	icon = 'icons/effects/effects.dmi'
	icon_state = "greenshatter"
