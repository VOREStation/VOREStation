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

/mob/living/simple_animal/snake/Noodle/Life() //stolen from Ian in corgi.dm
	if(!..())
		return 0

	if(!stat && !resting && !buckled && !ai_inactive)
		turns_since_scan++
		if(turns_since_scan > 5)
			turns_since_scan = 0
			if(movement_target && !(isturf(movement_target.loc) || ishuman(movement_target.loc)))
				movement_target = null
				stop_automated_movement = 0
			if(!movement_target || !(movement_target.loc in oview(src, 5)) )
				movement_target = null
				stop_automated_movement = 0
				walk(src,0)
				for(var/obj/item/weapon/reagent_containers/food/snacks/snakesnack/S in oview(src,3))
					if(isturf(S.loc))
						movement_target = S
						visible_emote("turns towards \the [movement_target] and slithers towards it.")
						break

		if(movement_target)
			stop_automated_movement = 1
			walk_to(src, movement_target, 0, 5)
			spawn(10)
				if(Adjacent(movement_target))
					visible_message("<span class='notice'>[src] swallows the [movement_target] whole!</span>")
					qdel(movement_target)
					walk(src,0)
				else if(ishuman(movement_target.loc) && prob(20))
					visible_emote("stares at the [movement_target] that [movement_target.loc] has with an unknowable reptilian gaze.")

/mob/living/simple_animal/snake/Noodle/attackby(var/obj/item/O, var/mob/user)
	if(istype(O, /obj/item/weapon/reagent_containers/food/snacks/snakesnack))
		visible_message("<span class='notice'>[user] feeds \the [O] to [src].</span>")
		qdel(O)
	else
		return ..()

//Special snek-snax for Noodle!
/obj/item/weapon/reagent_containers/food/snacks/snakesnack
	name = "sugar mouse"
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

/obj/item/weapon/storage/box/snakesnackbox
	name = "box of Snake Snax"
	desc = "A box containing Noodle's special sugermouse treats."
	icon = 'icons/mob/snake_vr.dmi'
	icon_state = "sneksnakbox"
	storage_slots = 7

/obj/item/weapon/storage/box/snakesnackbox/New()
	new /obj/item/weapon/reagent_containers/food/snacks/snakesnack(src)
	new /obj/item/weapon/reagent_containers/food/snacks/snakesnack(src)
	new /obj/item/weapon/reagent_containers/food/snacks/snakesnack(src)
	new /obj/item/weapon/reagent_containers/food/snacks/snakesnack(src)
	new /obj/item/weapon/reagent_containers/food/snacks/snakesnack(src)
	new /obj/item/weapon/reagent_containers/food/snacks/snakesnack(src)
	new /obj/item/weapon/reagent_containers/food/snacks/snakesnack(src)
	..()
