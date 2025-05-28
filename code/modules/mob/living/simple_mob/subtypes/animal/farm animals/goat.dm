/mob/living/simple_mob/animal/goat
	name = "goat"
	desc = "Not known for their pleasant disposition."
	tt_desc = "E Oreamnos americanus"
	icon_state = "goat"
	icon_living = "goat"
	icon_dead = "goat_dead"

	faction = FACTION_GOAT

	health = 40
	maxHealth = 40

	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "kicks"

	melee_damage_lower = 1
	melee_damage_upper = 5
	attacktext = list("kicked")

	say_list_type = /datum/say_list/goat
	ai_holder_type = /datum/ai_holder/simple_mob/retaliate

	meat_amount = 6
	meat_type = /obj/item/reagent_containers/food/snacks/meat

	var/datum/reagents/udder = null

/mob/living/simple_mob/animal/goat/Initialize(mapload)
	. = ..()
	udder = new(50)
	udder.my_atom = src

/mob/living/simple_mob/animal/goat/Life()
	. = ..()
	if(.)
		if(stat == CONSCIOUS)
			if(udder && prob(5))
				udder.add_reagent(REAGENT_ID_MILK, rand(5, 10))

		if(locate(/obj/effect/plant) in loc)
			var/obj/effect/plant/SV = locate() in loc
			SV.die_off(1)

		if(locate(/obj/machinery/portable_atmospherics/hydroponics/soil/invisible) in loc)
			var/obj/machinery/portable_atmospherics/hydroponics/soil/invisible/SP = locate() in loc
			qdel(SP)

		if(!pulledby)
			var/obj/effect/plant/food
			food = locate(/obj/effect/plant) in oview(5,loc)
			if(food)
				var/step = get_step_to(src, food, 0)
				Move(step)

/mob/living/simple_mob/animal/goat/Moved(atom/old_loc, direction, forced = FALSE)
	. = ..()
	if(!stat)
		for(var/obj/effect/plant/SV in loc)
			SV.die_off(1)

/mob/living/simple_mob/animal/goat/attackby(var/obj/item/O as obj, var/mob/user as mob)
	var/obj/item/reagent_containers/glass/G = O
	if(stat == CONSCIOUS && istype(G) && G.is_open_container())
		user.visible_message(span_notice("[user] milks [src] using \the [O]."))
		var/transfered = udder.trans_id_to(G, REAGENT_ID_MILK, rand(5,10))
		if(G.reagents.total_volume >= G.volume)
			to_chat(user, span_red("The [O] is full."))
		if(!transfered)
			to_chat(user, span_red("The udder is dry. Wait a bit longer..."))
	else
		..()

/datum/say_list/goat
	speak = list("EHEHEHEHEH","eh?")
	emote_hear = list("brays")
	emote_see = list("shakes its head", "stamps a foot", "glares around")

	// say_got_target doesn't seem to handle emotes, but keeping this here in case someone wants to make it work
//	say_got_target = list(span_warning("[src] gets an evil-looking gleam in their eye."))
