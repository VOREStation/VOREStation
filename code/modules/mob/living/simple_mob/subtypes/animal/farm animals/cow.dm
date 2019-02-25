/mob/living/simple_mob/animal/passive/cow
	name = "cow"
	desc = "Known for their milk, just don't tip them over."
	tt_desc = "E Bos taurus"
	icon_state = "cow"
	icon_living = "cow"
	icon_dead = "cow_dead"
	icon_gib = "cow_gib"

	health = 50
	maxHealth = 50

	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "kicks"
	attacktext = list("kicked")

	say_list_type = /datum/say_list/cow

	meat_amount = 6
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat

	var/datum/reagents/udder = null

/mob/living/simple_mob/animal/passive/cow/New()
	udder = new(50)
	udder.my_atom = src
	..()

/mob/living/simple_mob/animal/passive/cow/attackby(var/obj/item/O as obj, var/mob/user as mob)
	var/obj/item/weapon/reagent_containers/glass/G = O
	if(stat == CONSCIOUS && istype(G) && G.is_open_container())
		user.visible_message("<span class='notice'>[user] milks [src] using \the [O].</span>")
		var/transfered = udder.trans_id_to(G, "milk", rand(5,10))
		if(G.reagents.total_volume >= G.volume)
			to_chat(user, "<font color='red'>The [O] is full.</font>")
		if(!transfered)
			to_chat(user, "<font color='red'>The udder is dry. Wait a bit longer...</font>")
	else
		..()

/mob/living/simple_mob/animal/passive/cow/Life()
	. = ..()
	if(stat == CONSCIOUS)
		if(udder && prob(5))
			udder.add_reagent("milk", rand(5, 10))

/mob/living/simple_mob/animal/passive/cow/attack_hand(mob/living/carbon/M as mob)
	if(!stat && M.a_intent == I_DISARM && icon_state != icon_dead)
		M.visible_message("<span class='warning'>[M] tips over [src].</span>","<span class='notice'>You tip over [src].</span>")
		Weaken(30)
		icon_state = icon_dead
		spawn(rand(20,50))
			if(!stat && M)
				icon_state = icon_living
				var/list/responses = list(	"[src] looks at you imploringly.",
											"[src] looks at you pleadingly",
											"[src] looks at you with a resigned expression.",
											"[src] seems resigned to its fate.")
				to_chat(M, pick(responses))
	else
		..()

/datum/say_list/cow
	speak = list("moo?","moo","MOOOOOO")
	emote_hear = list("brays", "moos","moos hauntingly")
	emote_see = list("shakes its head")