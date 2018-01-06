/mob/living/simple_animal/snake
	name = "snake"
	desc = "A big thick snake."
	icon = 'icons/mob/snake_vr.dmi'
	icon_state = "snake"
	icon_living = "snake"
	icon_dead = "snake_dead"

	maxHealth = 20
	health = 20

	turns_per_move = 8 // SLOW-ASS MUTHAFUCKA

	response_help  = "pets"
	response_disarm = "shoos"
	response_harm   = "kicks"

	melee_damage_lower = 3
	melee_damage_upper = 5
	attacktext = "bitten"

	speak_chance = 1
	speak_emote = list("hisses")

//NOODLE IS HERE! SQUEEEEEEEE~
/mob/living/simple_animal/snake/Noodle
	name = "Noodle"
	desc = "This snake is particularly chubby and demands nothing but the finest of treats."
	var/turns_since_scan = 0
	var/obj/movement_target

/mob/living/simple_animal/snake/Noodle/Life() //All taken directly from Ian in corgi.dm
	if(!..())
		return 0

	if(!stat && !resting && !buckled && !ai_inactive)
		turns_since_scan++
		if(turns_since_scan > 5)
			turns_since_scan = 0
			if((movement_target) && !(isturf(movement_target.loc) || ishuman(movement_target.loc) ))
				movement_target = null
				stop_automated_movement = 0
			if(!movement_target || !(movement_target.loc in oview(src, 5)) )
				movement_target = null
				stop_automated_movement = 0
				for(var/obj/item/weapon/reagent_containers/food/snacks/snakesnack/S in oview(src,3))
					if(isturf(S.loc))
						movement_target = S
						break
			if(movement_target)
				stop_automated_movement = 1
				step_to(src,movement_target,1)
				sleep(5)
				step_to(src,movement_target,1)
				sleep(5)
				step_to(src,movement_target,1)

				if(movement_target)		//Not redundant due to sleeps, Item can be gone in 10 decisecomds
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
						visible_message("<span class='notice'>[src] swallows the [movement_target] whole!</span>")
						qdel(movement_target)
					else if(ishuman(movement_target.loc) && prob(20))
						visible_emote("stares at the [movement_target] that [movement_target.loc] with an unknowable reptilian gaze.")

//Special snek-snax for Noodle!
/obj/item/weapon/reagent_containers/food/snacks/snakesnack
	name = "Sugar mouse"
	desc = "A little mouse treat made of coloured sugar. Noodle loves these!"
	var/snack_colour
	icon = 'icons/mob/snake_vr.dmi'
	icon_state = "snack_yellow"
	nutriment_amt = 1
	nutriment_desc = list("sugar" = 1)

/obj/item/weapon/reagent_containers/food/snacks/snakesnack/New()
	..()
	if(!snack_colour)
		snack_colour = pick( list("yellow","green","pink","blue") )
	icon_state = "snack_[snack_colour]"
	desc = "A little mouse treat made of coloured sugar. Noodle loves these! This one is [snack_colour]."
	reagents.add_reagent("sugar", 2)

/obj/item/weapon/storage/box/fluff/snakesnackbox
	name = "Box of Snake Snax"
	desc = "A box containing Noodle's special sugermouse treats."
	icon = 'icons/mob/snake_vr.dmi'
	icon_state = "sneksnakbox"
	storage_slots = 7

/obj/item/weapon/storage/box/fluff/snakesnackbox/New()
		new /obj/item/weapon/reagent_containers/food/snacks/snakesnack(src)
		new /obj/item/weapon/reagent_containers/food/snacks/snakesnack(src)
		new /obj/item/weapon/reagent_containers/food/snacks/snakesnack(src)
		new /obj/item/weapon/reagent_containers/food/snacks/snakesnack(src)
		new /obj/item/weapon/reagent_containers/food/snacks/snakesnack(src)
		new /obj/item/weapon/reagent_containers/food/snacks/snakesnack(src)
		new /obj/item/weapon/reagent_containers/food/snacks/snakesnack(src)
		..()
