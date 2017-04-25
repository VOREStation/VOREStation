/datum/technomancer/spell/summon_creature
	name = "Summon Creature"
	desc = "Teleports a specific creature from their current location in the universe to the targeted tile, \
	after a delay. The creature summoned can be chosen by using the ability in your hand. \
	Available creatures are; mice, crabs, parrots, bats, goats, cats, corgis, spiders, and space carp. \
	The creatures take a few moments to be teleported to the targeted tile. Note that the creatures summoned are \
	not inherently loyal to the technomancer, and that the creatures will be hurt slightly from being teleported to you."
	enhancement_desc = "Summoned entities will never harm their summoner."
	spell_power_desc = "The strength and endurance of the summoned creature will be greater."
	cost = 100
	obj_path = /obj/item/weapon/spell/summon/summon_creature
	category = UTILITY_SPELLS

/obj/item/weapon/spell/summon/summon_creature
	name = "summon creature"
	desc = "Chitter chitter."
	summoned_mob_type = null
	summon_options = list(
		"Mouse"			=	/mob/living/simple_animal/mouse,
		"Lizard"		=	/mob/living/simple_animal/lizard,
		"Chicken"		=	/mob/living/simple_animal/chicken,
		"Chick"			=	/mob/living/simple_animal/chick,
		"Crab"			=	/mob/living/simple_animal/crab,
		"Parrot"		=	/mob/living/simple_animal/parrot,
		"Goat"			=	/mob/living/simple_animal/retaliate/goat,
		"Cat"			=	/mob/living/simple_animal/cat,
		"Kitten"		=	/mob/living/simple_animal/cat/kitten,
		"Corgi"			=	/mob/living/simple_animal/corgi,
		"Corgi Pup"		=	/mob/living/simple_animal/corgi/puppy,
		"BAT"			=	/mob/living/simple_animal/hostile/scarybat,
		"SPIDER"		=	/mob/living/simple_animal/hostile/giant_spider,
		"SPIDER HUNTER"	=	/mob/living/simple_animal/hostile/giant_spider/hunter,
		"SPIDER NURSE"	=	/mob/living/simple_animal/hostile/giant_spider/nurse,
		"CARP"			=	/mob/living/simple_animal/hostile/carp,
		"BEAR"			=	/mob/living/simple_animal/hostile/bear
		) // Vorestation edits to add vore versions.
	cooldown = 30
	instability_cost = 10
	energy_cost = 1000

/obj/item/weapon/spell/summon/summon_creature/on_summon(var/mob/living/simple_animal/summoned)
	if(check_for_scepter())
//		summoned.faction = "technomancer"
		if(istype(summoned, /mob/living/simple_animal/hostile))
			var/mob/living/simple_animal/SA = summoned
			SA.friends.Add(owner)

	// Makes their new pal big and strong, if they have spell power.
	summoned.maxHealth = calculate_spell_power(summoned.maxHealth)
	summoned.health = calculate_spell_power(summoned.health)
	summoned.melee_damage_lower = calculate_spell_power(summoned.melee_damage_lower)
	summoned.melee_damage_upper = calculate_spell_power(summoned.melee_damage_upper)
	// This makes the summon slower, so the crew has a chance to flee from massive monsters.
	summoned.move_to_delay = calculate_spell_power(round(summoned.move_to_delay))

	var/new_size = calculate_spell_power(1)
	if(new_size != 1)
		var/matrix/M = matrix()
		M.Scale(new_size)
		M.Translate(0, 16*(new_size-1))
		summoned.transform = M


	// Now we hurt their new pal, because being forcefully abducted by teleportation can't be healthy.
	summoned.health = round(summoned.getMaxHealth() * 0.7)