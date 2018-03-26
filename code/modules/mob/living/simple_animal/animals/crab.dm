//Look Sir, free crabs!
/mob/living/simple_animal/crab
	name = "crab"
	desc = "A hard-shelled crustacean. Seems quite content to lounge around all the time."
	tt_desc = "Ranina ranina"
	icon_state = "crab"
	icon_living = "crab"
	icon_dead = "crab_dead"
	faction = "crabs"
	intelligence_level = SA_ANIMAL

	wander = 0
	stop_automated_movement = 1
	turns_per_move = 5
	mob_size = MOB_SMALL

	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "stomps"
	friendly = "pinches"

	speak_chance = 1
	speak_emote = list("clicks")
	emote_hear = list("clicks")
	emote_see = list("clacks")

	var/obj/item/inventory_head
	var/obj/item/inventory_mask

/mob/living/simple_animal/crab/Life()
	..()
	//CRAB movement, I'm not porting this up to SA because... "sideways-only movement" var nothanks
	if(!ckey && !stat)
		if(isturf(src.loc) && !resting && !buckled)		//This is so it only moves if it's not inside a closet, gentics machine, etc.
			lifes_since_move++
			if(lifes_since_move >= turns_per_move)
				Move(get_step(src,pick(4,8)))
				lifes_since_move = 0
	regenerate_icons()

//COFFEE! SQUEEEEEEEEE!
/mob/living/simple_animal/crab/Coffee
	name = "Coffee"
	real_name = "Coffee"
	desc = "It's Coffee, the other pet!"
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "stomps"

//Sif Crabs
/mob/living/simple_animal/giant_crab
	name = "giant crab"
	desc = "A large, hard-shelled crustacean. This one is mostly grey."
	icon_state = "sif_crab"
	icon_living = "sif_crab"
	icon_dead = "sif_crab_dead"
	faction = "crabs"
	intelligence_level = SA_ANIMAL

	maxHealth = 200
	health = 200

	mob_size = MOB_LARGE
	cooperative = 1
	retaliate = 1
	turns_per_move = 3

	minbodytemp = 175

	melee_damage_lower = 22
	melee_damage_upper = 35
	attack_armor_pen = 35
	attack_sharp = 1
	attack_edge = 1

	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "stomps"
	friendly = "pinches"

	speak_chance = 1
	speak_emote = list("clicks")
	emote_hear = list("clicks")
	emote_see = list("clacks")
