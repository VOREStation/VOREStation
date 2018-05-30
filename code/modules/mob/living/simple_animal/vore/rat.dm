/mob/living/simple_animal/hostile/rat
	name = "giant rat"
	desc = "In what passes for a hierarchy among verminous rodents, this one is king."
	tt_desc = "Mus muscular"
	icon = 'icons/mob/vore64x32.dmi'
	icon_state = "rous"
	icon_living = "rous"
	icon_dead = "rous-dead"
	icon_rest = "rous_rest"
	faction = "mouse"

	maxHealth = 150
	health = 150

	investigates = TRUE
	melee_damage_lower = 5
	melee_damage_upper = 15
	grab_resist = 100

	speak_chance = 4
	speak = list("Squeek!","SQUEEK!","Squeek?")
	speak_emote = list("squeeks","squeeks","squiks")
	emote_hear = list("squeeks","squeaks","squiks")
	emote_see = list("runs in a circle", "shakes", "scritches at something")
	say_maybe_target = list("Squeek?")
	say_got_target = list("SQUEEK!")
	response_help = "pets the"
	response_disarm = "bops the"
	response_harm = "hits the"
	attacktext = list("ravaged")
	friendly = list("nuzzles", "licks", "noses softly at", "noseboops", "headbumps against", "leans on", "nibbles affectionately on")

	old_x = -16
	old_y = 0
	default_pixel_x = -16
	pixel_x = -16
	pixel_y = 0

	vore_active = TRUE
	vore_capacity = 1
	vore_pounce_chance = 45
	vore_icons = SA_ICON_LIVING | SA_ICON_REST

	var/life_since_foodscan = 0

/mob/living/simple_animal/hostile/rat/passive
	name = "curious giant rat"
	desc = "In what passes for a hierarchy among verminous rodents, this one is king. It seems to be more interested on scavenging."
	follow_dist = 1
	var/mob/living/carbon/human/food
	var/hunger = 0

/mob/living/simple_animal/hostile/rat/passive/Life()
	. = ..()
	if(!. || ai_inactive)
		return

	if(hunger > 0 && life_since_foodscan++ > 5) //Only look for floor food when hungry.
		life_since_foodscan = 0
		for(var/obj/item/weapon/reagent_containers/food/snacks/S in oview(src,3)) //Accept thrown offerings and scavenge surroundings.
			if(get_dist(src,S) <=1)
				visible_emote("hungrily devours \the [S].")
				playsound(src.loc,'sound/items/eatfood.ogg', rand(10,50), 1)
				qdel(S)
				hunger = 0
				food = null
			else
				WanderTowards(S.loc)
			break

	if(!food)
		return

	var/food_dist = get_dist(src,food)

	if(food_dist > world.view) //Lose interest on this person.
		food = null
		hunger = Clamp(hunger+5, 0, 25)

	if(food_dist > 1)
		if(stance == STANCE_IDLE)
			if(set_follow(food,10 SECONDS))
				handle_stance(STANCE_FOLLOW)
				if(resting)
					lay_down()

	if(food_dist <= 1)
		if(hunger < 15)
			if(prob(25))
				visible_emote(pick("sniffs curiously at [food].",
								   "stares at [food], seeming to want something.",
								   "sniffs at [food]'s hands.",
								   "sniffs curiously at [food]'s pockets.",
								   "sits down for a moment, reaching towards [food] with its paws."))
				hunger += 5
		else if(hunger < 30)
			if(prob(25))
				visible_emote(pick("sniffs intently against [food], especially their pockets and gear.",
								   "stands up to beg [food] for snacks.",
								   "attempts to burrow into [food]'s pockets.",
								   "leans against [food], licking its chops.",
								   "hungrily nibbles onto [food]."))
				hunger += 5
		else if(hunger < 45)
			if(prob(25))
				visible_emote(pick("growls at [food], sounding rather hangry!",
								   "aggressively bumps and nudges against [food], trying to make something fall out.",
								   "salivates at [food] in an unsettling manner.",
								   "pushes hard against [food], licking its chops.",
								   "almost sinks its teeth into [food], just stopping to give them another chance."))
				hunger += 5
		else if(hunger < 50)
			visible_emote("appears to have had enough and prepares to strike!")
		else
			food.Weaken(5)
			food.visible_message("<span class='danger'>\the [src] pounces on \the [food]!</span>!")
			target_mob = food
			EatTarget()
			hunger = 0
			food = null

/mob/living/simple_animal/hostile/rat/passive/attackby(var/obj/item/O, var/mob/user) // Feed the rat your food to satisfy it.
	if(istype(O, /obj/item/weapon/reagent_containers/food/snacks))
		qdel(O)
		playsound(src.loc,'sound/items/eatfood.ogg', rand(10,50), 1)
		hunger = 0
		food = null
		return
	. = ..()

/mob/living/simple_animal/hostile/rat/passive/Found(var/atom/found_atom)
	if(!SA_attackable(found_atom))
		return null
	else if(ishuman(found_atom) && will_eat(found_atom))
		var/mob/living/carbon/human/H = found_atom
		for(var/obj/item/weapon/reagent_containers/food/snacks/S in H)
			if(!food)
				visible_emote("sniffs around the air intently, seeming to have caught a whiff of food!")
			if(resting)
				lay_down()
			food = H
			return found_atom
			break
	return null

/mob/living/simple_animal/hostile/rat/passive/FindTarget()
	var/atom/T = null
	for(var/atom/A in ListTargets(view_range))
		if(A == src)
			continue
		var/atom/F = Found(A)
		if(F)
			T = F
			break
	return T

/mob/living/simple_animal/hostile/rat/death()
	playsound(src, 'sound/effects/mouse_squeak_loud.ogg', 50, 1)
	..()
