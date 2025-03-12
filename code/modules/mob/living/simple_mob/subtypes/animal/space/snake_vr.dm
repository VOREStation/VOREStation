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
	Nonvenomous snakes either swallow prey alive or kill them by constriction - this is dependent on the prey. \
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

	movement_cooldown = 3 // SLOW-ASS MUTHAFUCKA, I hope.

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

	icon_state = "python"
	icon_living = "python"
	icon_dead = "python_dead"
	icon = 'icons/mob/snake_vr.dmi'

	vore_active = 1
	vore_capacity = 1
	vore_default_mode = DM_DIGEST
	// vore_icons = SA_ICON_LIVING | SA_ICON_REST // Woul require the downstream sprites
	vore_escape_chance = 20
	swallowTime = 50
	vore_bump_chance = 10
	faction_bump_vore = 1 // Allows snakes to vore people who bump into them even if they are the same "friendly" faction.
	vore_bump_emote = "coils around and unhinges its jaws at"

	can_be_drop_prey = FALSE

// Adds vore belly
/mob/living/simple_mob/animal/passive/snake/init_vore()
	if(!voremob_loaded)
		return
	. = ..()
	var/obj/belly/B = vore_selected
	B.name = "stomach"
	B.desc = "The snake coils its tail around you, pushing you to the ground and pinning you with its weight. It flicks its tongue at you, before pouncing onto your head, engulfing the upper half of your body with ease as it unhinges its jaw. With greedy swallows, it pulls you deeper, and deeper. The tight walls undulate rhythmically as the danger noodle rumbles contentedly at this new meal. The snake sends the last of you down with a deep swallow, hissing softly and closing its eyes as it enjoys its new meal, tucked away nicely under those beautiful, green scales."
	B.item_digest_mode = IM_DIGEST_FOOD
	B.mode_flags = DM_FLAG_THICKBELLY
	B.digestchance = 25
	B.escape_stun = 5

	B.emote_lists[DM_HOLD] = list(
		"A near-constant string of soft, slick noises drift over you as waves of peristalsis slowly drag you further within the possessive serpent.",
		"\the [name]'s stomach suddenly squishes inwards from everywhere at once, wrapping you up in a warm, doughy embrace before easing back again.",
		"A growing sense of relaxed lethargy seeps into your muscles the longer you're massaged over amidst those hot, humid confines.",
		"Slimy, heat-trapping muscles rhythmically ripple over and knead down into your figure, ensuring the snake's new filling was subdued.",
		"\the [name] occasionally hisses out in satisfaction as it feels your twitching, filling weight bulge out its scales before giving you a compressing squeeze.",
		"Hot, viscous ooze clings to and coats your body as time passes, encouraging you to submit and let the snake do all the serpentine, winding slithering.")
	B.emote_lists[DM_DIGEST] = list(
		"A chorus of sordid, slick sounds fill your senses as another wave of peristalsis ripples over you, tugging you a deeper into the serpent's digestive system.",
		"\the [name]'s all-encompassing stomach closes in tight around your figure, soaking acid into your flesh.",
		"You find it harder to breathe as time goes on, your dizziness growing as you lack the space to breathe in enough of that caustic, thinning air.",
		"\the [name]'s ample, kneading muscle gradually squeezes the strength and fight from your body with clench after clench.",
		"A pleased hiss emanates from the well fed serpent, clearly satisfied with the meal it's made out of you.",
		"Your movements grow sluggish as \the [name]'s oozing stomach walls cling to your entire body, drenchning you in corrosive juices.")
	B.struggle_messages_inside = list(
		"You jam your limbs against the tight walls in an effort to get some leverage.",
		"You writhe inside the tube-like gastric chamber in a bid to force yourself to freedom.",
		"You push back at the clenched sphincter at the entrance to \the [name]'s gut.")
	B.struggle_messages_outside = list(
		"\the [name]'s tail jostles around as something inside of it fights to escape.",
		"\the [name]'s tail lurches with the struggles of a live meal.")
	B.examine_messages = list(
		"\the [name]'s tail is swollen fat with a lump of prey it swallowed whole.")

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

	vore_default_mode = DM_HOLD

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
		visible_message(span_notice("[user] feeds \the [O] to [src]."))
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
	nutriment_desc = list(REAGENT_ID_SUGAR = 1)

/obj/item/reagent_containers/food/snacks/snakesnack/Initialize(mapload)
	. = ..()
	if(!snack_colour)
		snack_colour = pick( list("yellow","green","pink","blue") )
	icon_state = "snack_[snack_colour]"
	desc = "A little mouse treat made of coloured sugar. Noodle loves these! This one is [snack_colour]."
	reagents.add_reagent(REAGENT_ID_SUGAR, 2)

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
