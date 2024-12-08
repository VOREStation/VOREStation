/mob/living/simple_mob/animal/giant_spider/broodmother
	name = "giant spider broodmother"
	desc = "Absolutely gigantic, this creature is horror itself. This one seems to have weaponized childbirth!"
	tt_desc = "X Atrax robustus gigantus maximus"
	icon = 'icons/mob/64x64.dmi'
	vis_height = 64
	icon_state = "spider_queen"
	icon_living = "spider_queen"
	icon_dead = "spider_queen_dead"

	maxHealth = 800
	health = 800

	melee_damage_lower = 25
	melee_damage_upper = 40
	attack_armor_pen = 15

	pixel_x = -16
	pixel_y = 0
	default_pixel_x = -16
	old_x = -16
	old_y = 0

	meat_amount = 20

	projectiletype = /obj/item/projectile/energy/spidertoxin
	projectilesound = 'sound/weapons/pierce.ogg'

	var/list/possible_brood_types = list(
		/mob/living/simple_mob/animal/giant_spider/frost/broodling,
		/mob/living/simple_mob/animal/giant_spider/electric/broodling,
		/mob/living/simple_mob/animal/giant_spider/hunter/broodling,
		/mob/living/simple_mob/animal/giant_spider/lurker/broodling,
		/mob/living/simple_mob/animal/giant_spider/nurse/broodling,
		/mob/living/simple_mob/animal/giant_spider/pepper/broodling,
		/mob/living/simple_mob/animal/giant_spider/thermic/broodling,
		/mob/living/simple_mob/animal/giant_spider/tunneler/broodling,
		/mob/living/simple_mob/animal/giant_spider/webslinger/broodling,
		/mob/living/simple_mob/animal/giant_spider/broodling)

	var/list/possible_death_brood_types = list(
		/mob/living/simple_mob/animal/giant_spider/frost,
		/mob/living/simple_mob/animal/giant_spider/electric,
		/mob/living/simple_mob/animal/giant_spider/hunter,
		/mob/living/simple_mob/animal/giant_spider/lurker,
		/mob/living/simple_mob/animal/giant_spider/pepper,
		/mob/living/simple_mob/animal/giant_spider/thermic,
		/mob/living/simple_mob/animal/giant_spider/tunneler,
		/mob/living/simple_mob/animal/giant_spider/webslinger,
		/mob/living/simple_mob/animal/giant_spider/phorogenic,
		/mob/living/simple_mob/animal/giant_spider/carrier,
		/mob/living/simple_mob/animal/giant_spider)
	var/max_brood = 8
	var/death_brood = 8
	var/brood_per_spawn = 4
	var/brood_per_launch = 2
	special_attack_min_range = 0
	special_attack_max_range = 10
	special_attack_cooldown = 6 SECONDS
	ai_holder_type = /datum/ai_holder/simple_mob/intentional/giant_spider_broodmother
	poison_per_bite = 2
	poison_type = REAGENT_ID_CYANIDE

	loot_list = list(/obj/item/royal_spider_egg = 100)

/obj/item/projectile/energy/spidertoxin
	name = "concentrated spidertoxin"
	icon_state = "neurotoxin"
	damage = 35
	damage_type = BIOACID
	agony = 15
	check_armour = "bio"
	armor_penetration = 40

	combustion = FALSE

/mob/living/simple_mob/animal/giant_spider/broodmother/death(gibbed, deathmessage="falls over and makes its last twitches as its birthing sack bursts!")
	var/count = 0
	while(count < death_brood)
		var/broodling_type = pick(possible_death_brood_types)
		var/mob/living/simple_mob/animal/giant_spider/broodling = new broodling_type(src.loc)
		broodling.faction = faction
		step_away(broodling, src)
		count++

	return ..()

/mob/living/simple_mob/animal/giant_spider/broodmother/proc/spawn_brood(atom/A)
	set waitfor = FALSE

	var/count = 0
	while(count < brood_per_spawn)
		var/broodling_type = pick(possible_brood_types)
		var/mob/living/simple_mob/animal/giant_spider/broodling = new broodling_type(src.loc)
		broodling.faction = faction
		step_away(broodling, src)
		count++

	visible_message(span_danger("\The [src] releases brood from its birthing sack!"))

/mob/living/simple_mob/animal/giant_spider/broodmother/proc/launch_brood(atom/A)
	set waitfor = FALSE

	var/count = 0
	while(count < brood_per_launch)
		var/broodling_type = pick(possible_brood_types)
		var/mob/living/simple_mob/animal/giant_spider/broodling = new broodling_type(src.loc)
		broodling.faction = faction
		step_away(broodling, src)
		broodling.throw_at(A, 10)
		count++

	visible_message(span_danger("\The [src] launches brood from the distance!"))

/mob/living/simple_mob/animal/giant_spider/broodmother/proc/can_spawn_brood()
	var/brood_amount = 0
	for(var/mob/living/simple_mob/mob in view(7, src))
		if(mob.type in possible_brood_types)
			brood_amount++
	if(brood_amount >= max_brood)
		return FALSE
	return TRUE

/mob/living/simple_mob/animal/giant_spider/broodmother/should_special_attack(atom/A)
	if(!can_spawn_brood())
		return FALSE
	return TRUE

/mob/living/simple_mob/animal/giant_spider/broodmother/do_special_attack(atom/A)
	. = TRUE
	switch(a_intent)
		if(I_DISARM)
			spawn_brood(A)
		if(I_HURT)
			launch_brood(A)

/datum/ai_holder/simple_mob/intentional/giant_spider_broodmother
	wander = TRUE
	intelligence_level = AI_SMART
	pointblank = FALSE
	firing_lanes = TRUE
	vision_range = 8

/datum/ai_holder/simple_mob/intentional/giant_spider_broodmother/pre_special_attack(atom/A)
	if(isliving(A))
		var/mob/living/target = A

		var/tally = 0
		var/list/potential_targets = list_targets() // Returns list of mobs and certain objects like mechs and turrets.
		for(var/atom/movable/AM in potential_targets)
			if(get_dist(holder, AM) > 4)
				continue
			if(!can_attack(AM))
				continue
			tally++
		if(tally > 1)
			holder.a_intent = I_DISARM
		else if(get_dist(holder, target) > 4)
			holder.a_intent = I_HURT
		else
			holder.a_intent = I_DISARM

	else
		holder.a_intent = I_DISARM


/obj/item/royal_spider_egg
	name = "royal spider egg"
	desc = "This one is yet to be imprinted!"
	icon = 'icons/obj/egg_new_vr.dmi'	//VOREStation Edit
	icon_state = "egg_slimeglob"

	origin_tech = list(TECH_BIO = 10)

/obj/item/royal_spider_egg/attack_self(mob/user as mob)
	var/response = tgui_alert(user, "Are you sure you want to release the royal spiderling right now? It appears ready to imprint the moment its born.", "Royal Spider Egg", list("Yes", "No"))

	if(response == "Yes")

		var/turf/drop_loc = user.loc
		if(istype(drop_loc))
			var/obj/effect/spider/spiderling/princess/royalty = new(drop_loc)
			royalty.faction = user.faction

			qdel(src)

		else
			to_chat(user, "You need more space to release the egg!")
