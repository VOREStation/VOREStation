/datum/category_item/catalogue/fauna/snake
	name = "Wildlife - Snake"
	desc = "Classification: Reptilia Serpentes\
	<br><br>\
	Snakes are elongated, limbless, carnivorous reptiles of the suborder Serpentes \
	Like all other squamates, pythons are ectothermic, amniote vertebrates covered in overlapping scales. \
	Many species of snake have skulls with several more joints than their lizard ancestors, \
	enabling them to swallow prey much larger than their heads with their highly mobile jaws. \
	<br>\
	This type of snake is nonvenomous and use their slender bodies to primarily subdue their prey. \
	Nonvenomous snakes either swallow prey alive or kill them by constriction - this is dependant on the prey. \
	<br>\
	Snakes are mostly passive - however they will attack if threatened - it is recommended that \
	persons keep their distance as to not provoke these animals."
	value = CATALOGUER_REWARD_TRIVIAL

/*
 * Green Snake
 */
/mob/living/simple_mob/animal/passive/snake
	name = "snake"
	desc = "A cute little, green snake. Wiggle wiggle."
	tt_desc = "E Reptilia Serpentes"
	catalogue_data = list(/datum/category_item/catalogue/fauna/snake)

	icon_state = "green"
	icon_living = "green"
	icon_dead = "green_dead"
	icon = 'icons/mob/snake_vr.dmi'

	maxHealth = 15
	health = 15

	movement_cooldown = 8 // SLOW-ASS MUTHAFUCKA, I hope.

	response_help  = "pets"
	response_disarm = "shoos"
	response_harm   = "kicks"

	meat_amount = 2
	meat_type = /obj/item/reagent_containers/food/snacks/meat

	melee_damage_lower = 2
	melee_damage_upper = 3
	attacktext = list("bitten")

	say_list_type = /datum/say_list/snake
	ai_holder_type = /datum/ai_holder/simple_mob/passive

/datum/say_list/snake
	emote_hear = list("hisses")

/*
 * Red Snake
 */
/mob/living/simple_mob/animal/passive/snake/red
	desc = "A cute little, red snake. Wiggle wiggle."

	icon_state = "red"
	icon_living = "red"
	icon_dead = "red_dead"
	icon = 'icons/mob/snake_vr.dmi'

/*
 * Python
 */
/mob/living/simple_mob/animal/passive/snake/python
	name = "python"
	desc = "A big, thick snake."
	tt_desc = "E Reptilia Pythonidae"

	icon_state = "python"
	icon_living = "python"
	icon_dead = "python_dead"
	icon = 'icons/mob/snake_vr.dmi'

/*
 * NOODLE IS HERE! SQUEEEEEEEE~
 */
/mob/living/simple_mob/animal/passive/snake/python/noodle
	name = "Noodle"
	desc = "This snake is particularly chubby and demands nothing but the finest of treats."

	maxHealth = 20
	health = 20

	makes_dirt = FALSE

	var/turns_since_scan = 0
	var/obj/movement_target

/mob/living/simple_mob/animal/passive/snake/python/noodle/Life()
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
				for(var/obj/item/reagent_containers/food/snacks/snakesnack/S in oview(src,3))
					if(isturf(S.loc) || ishuman(S.loc))
						movement_target = S
						visible_emote("turns towards \the [movement_target] and slithers towards it.")
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
						visible_emote("stares at the [movement_target] that [movement_target.loc] has with an unknowable reptilian gaze.")

/mob/living/simple_mob/animal/passive/snake/python/noodle/apply_melee_effects(var/atom/A)
	if(ismouse(A))
		var/mob/living/simple_mob/animal/passive/mouse/mouse = A
		if(mouse.getMaxHealth() < 20) // In case a badmin makes giant mice or something.
			mouse.splat()
			visible_emote(pick("swallows \the [mouse] whole!"))
	else
		..()

/mob/living/simple_mob/animal/passive/snake/python/noodle/attackby(var/obj/item/O, var/mob/user)
	if(istype(O, /obj/item/reagent_containers/food/snacks/snakesnack))
		visible_message("<span class='notice'>[user] feeds \the [O] to [src].</span>")
		qdel(O)
	else
		return ..()

/*
 * Special snek-snax for Noodle!
 */
/obj/item/reagent_containers/food/snacks/snakesnack
	name = "sugar mouse"
	desc = "A little mouse treat made of coloured sugar. Noodle loves these!"
	var/snack_colour
	icon = 'icons/mob/snake_vr.dmi'
	icon_state = "snack_yellow"
	nutriment_amt = 1
	nutriment_desc = list("sugar" = 1)

/obj/item/reagent_containers/food/snacks/snakesnack/Initialize()
	. = ..()
	if(!snack_colour)
		snack_colour = pick( list("yellow","green","pink","blue") )
	icon_state = "snack_[snack_colour]"
	desc = "A little mouse treat made of coloured sugar. Noodle loves these! This one is [snack_colour]."
	reagents.add_reagent("sugar", 2)

/obj/item/storage/box/snakesnackbox
	name = "box of Snake Snax"
	desc = "A box containing Noodle's special sugermouse treats."
	icon = 'icons/mob/snake_vr.dmi'
	icon_state = "sneksnakbox"
	storage_slots = 7

/obj/item/storage/box/snakesnackbox/New()
	new /obj/item/reagent_containers/food/snacks/snakesnack(src)
	new /obj/item/reagent_containers/food/snacks/snakesnack(src)
	new /obj/item/reagent_containers/food/snacks/snakesnack(src)
	new /obj/item/reagent_containers/food/snacks/snakesnack(src)
	new /obj/item/reagent_containers/food/snacks/snakesnack(src)
	new /obj/item/reagent_containers/food/snacks/snakesnack(src)
	new /obj/item/reagent_containers/food/snacks/snakesnack(src)
	..()
