/mob/living/simple_mob/animal/passive/dog
	name = "dog"
	real_name = "dog"
	desc = "It's a dog."
	tt_desc = "E Canis lupus familiaris"
	icon_state = "corgi"
	icon_living = "corgi"
	icon_dead = "corgi_dead"

	health = 20
	maxHealth = 20

	response_help  = "pets"
	response_disarm = "bops"
	response_harm   = "kicks"

	mob_size = MOB_SMALL

	has_langs = list("Dog")

	say_list_type = /datum/say_list/dog

	meat_amount = 3
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat/corgi

	var/obj/item/inventory_head
	var/obj/item/inventory_back


/mob/living/simple_mob/animal/passive/dog/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(istype(O, /obj/item/weapon/newspaper))
		if(!stat)
			for(var/mob/M in viewers(user, null))
				if ((M.client && !( M.blinded )))
					M.show_message("<font color='blue'>[user] baps [name] on the nose with the rolled up [O]</font>")
			spawn(0)
				for(var/i in list(1,2,4,8,4,2,1,2))
					set_dir(i)
					sleep(1)
	else
		..()

/mob/living/simple_mob/animal/passive/dog/regenerate_icons()
	overlays = list()

	if(inventory_head)
		var/head_icon_state = inventory_head.icon_state
		if(health <= 0)
			head_icon_state += "2"

		var/icon/head_icon = image('icons/mob/corgi_head.dmi',head_icon_state)
		if(head_icon)
			overlays += head_icon

	if(inventory_back)
		var/back_icon_state = inventory_back.icon_state
		if(health <= 0)
			back_icon_state += "2"

		var/icon/back_icon = image('icons/mob/corgi_back.dmi',back_icon_state)
		if(back_icon)
			overlays += back_icon

	return




/obj/item/weapon/reagent_containers/food/snacks/meat/corgi
	name = "corgi meat"
	desc = "Tastes like... well, you know..."




/datum/say_list/dog
	speak = list("YAP", "Woof!", "Bark!", "AUUUUUU")
	emote_hear = list("barks", "woofs", "yaps","pants")
	emote_see = list("shakes its head", "shivers")

// This exists so not every type of dog has to be a subtype of corgi, and in case we get more dog sprites
/mob/living/simple_mob/animal/passive/dog/corgi
	name = "corgi"
	real_name = "corgi"
	desc = "It's a corgi."
	tt_desc = "E Canis lupus familiaris"
	icon_state = "corgi"
	icon_living = "corgi"
	icon_dead = "corgi_dead"

/mob/living/simple_mob/animal/passive/dog/corgi/puppy
	name = "corgi puppy"
	real_name = "corgi"
	desc = "It's a corgi puppy."
	icon_state = "puppy"
	icon_living = "puppy"
	icon_dead = "puppy_dead"

//pupplies cannot wear anything.
/mob/living/simple_mob/animal/passive/dog/corgi/puppy/Topic(href, href_list)
	if(href_list["remove_inv"] || href_list["add_inv"])
		to_chat(usr, "<font color='red'>You can't fit this on [src]</font>")
		return
	..()

/mob/living/simple_mob/animal/passive/dog/corgi/puppy/Bockscar
	name = "Bockscar"
	real_name = "Bockscar"

//IAN! SQUEEEEEEEEE~
/mob/living/simple_mob/animal/passive/dog/corgi/Ian
	name = "Ian"
	real_name = "Ian"	//Intended to hold the name without altering it.
	gender = MALE
	desc = "It's a corgi."
	var/turns_since_scan = 0
	var/obj/movement_target
	makes_dirt = FALSE	//VOREStation edit: no more dirt

/mob/living/simple_mob/animal/passive/dog/corgi/Ian/Life()
	..()

	//Not replacing with SA FollowTarget mechanics because Ian behaves... very... specifically.

	//Feeding, chasing food, FOOOOODDDD
	if(!stat && !resting && !buckled)
		turns_since_scan++
		if(turns_since_scan > 5)
			turns_since_scan = 0
			if((movement_target) && !(isturf(movement_target.loc) || ishuman(movement_target.loc) ))
				movement_target = null
			if( !movement_target || !(movement_target.loc in oview(src, 3)) )
				movement_target = null
				for(var/obj/item/weapon/reagent_containers/food/snacks/S in oview(src,3))
					if(isturf(S.loc) || ishuman(S.loc))
						movement_target = S
						break
			if(movement_target)
				step_to(src,movement_target,1)
				sleep(3)
				step_to(src,movement_target,1)
				sleep(3)
				step_to(src,movement_target,1)

				if(movement_target)		//Not redundant due to sleeps, Item can be gone in 6 decisecomds
					if (movement_target.loc.x < src.x)
						set_dir(WEST)
					else if (movement_target.loc.x > src.x)
						set_dir(EAST)
					else if (movement_target.loc.y < src.y)
						set_dir(SOUTH)
					else if (movement_target.loc.y > src.y)
						set_dir(NORTH)
					else
						set_dir(SOUTH)

					if(isturf(movement_target.loc) )
						UnarmedAttack(movement_target)
					else if(ishuman(movement_target.loc) && prob(20))
						visible_emote("stares at the [movement_target] that [movement_target.loc] has with sad puppy eyes.")

		if(prob(1))
			visible_emote(pick("dances around","chases their tail"))
			spawn(0)
				for(var/i in list(1,2,4,8,4,2,1,2,4,8,4,2,1,2,4,8,4,2))
					set_dir(i)
					sleep(1)

//LISA! SQUEEEEEEEEE~
/mob/living/simple_mob/animal/passive/dog/corgi/Lisa
	name = "Lisa"
	real_name = "Lisa"
	gender = FEMALE
	desc = "It's a corgi with a cute pink bow."
	icon_state = "lisa"
	icon_living = "lisa"
	icon_dead = "lisa_dead"
	response_help  = "pets"
	response_disarm = "bops"
	response_harm   = "kicks"
	var/turns_since_scan = 0
	var/puppies = 0

//Lisa already has a cute bow!
/mob/living/simple_mob/animal/passive/dog/corgi/Lisa/Topic(href, href_list)
	if(href_list["remove_inv"] || href_list["add_inv"])
		to_chat(usr, "<font color='red'>[src] already has a cute bow!</font>")
		return
	..()

/mob/living/simple_mob/animal/passive/dog/corgi/Lisa/Life()
	..()

	if(!stat && !resting && !buckled)
		turns_since_scan++
		if(turns_since_scan > 15)
			turns_since_scan = 0
			var/alone = TRUE
			var/ian = FALSE
			for(var/mob/M in oviewers(7, src))
				if(istype(M, /mob/living/simple_mob/animal/passive/dog/corgi/Ian))
					if(M.client)
						alone = FALSE
						break
					else
						ian = M
				else
					alone = FALSE
					break
			if(alone && ian && puppies < 4)
				if(near_camera(src) || near_camera(ian))
					return
				new /mob/living/simple_mob/animal/passive/dog/corgi/puppy(loc)

		if(prob(1))
			visible_emote(pick("dances around","chases her tail"))
			spawn(0)
				for(var/i in list(1,2,4,8,4,2,1,2,4,8,4,2,1,2,4,8,4,2))
					set_dir(i)
					sleep(1)

// Tamaskans
/mob/living/simple_mob/animal/passive/dog/tamaskan
	name = "tamaskan"
	real_name = "tamaskan"
	desc = "It's a tamaskan."
	icon_state = "tamaskan"
	icon_living = "tamaskan"
	icon_dead = "tamaskan_dead"

/mob/living/simple_mob/animal/passive/dog/tamaskan/Spice
	name = "Spice"
	real_name = "Spice"	//Intended to hold the name without altering it.
	gender = FEMALE
	desc = "It's a tamaskan, the name Spice can be found on its collar."