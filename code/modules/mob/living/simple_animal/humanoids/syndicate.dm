/mob/living/simple_animal/hostile/syndicate
	name = "mercenary"
	desc = "Death to the Company."
	tt_desc = "E Homo sapiens"
	icon_state = "syndicate"
	icon_living = "syndicate"
	icon_dead = "syndicate_dead"
	icon_gib = "syndicate_gib"
	intelligence_level = SA_HUMANOID

	faction = "syndicate"
	maxHealth = 100
	health = 100
	speed = 4

	run_at_them = 0
	cooperative = 1
	investigates = 1
	firing_lines = 1
	returns_home = 1
	reacts = 1

	turns_per_move = 5
	stop_when_pulled = 0
	status_flags = CANPUSH

	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "hits"

	harm_intent_damage = 5
	melee_damage_lower = 15		//Tac Knife damage
	melee_damage_upper = 15
	environment_smash = 1
	attack_sharp = 1
	attack_edge = 1
	attacktext = list("slashed", "stabbed")

	armor = list(melee = 40, bullet = 30, laser = 30, energy = 10, bomb = 10, bio = 100, rad = 100)	// Same armor values as the vest they drop, plus simple mob immunities

	min_oxy = 5
	max_oxy = 0
	min_tox = 0
	max_tox = 1
	min_co2 = 0
	max_co2 = 5
	min_n2 = 0
	max_n2 = 0
	unsuitable_atoms_damage = 15

	speak_chance = 1
	speak = list("Fuckin' NT, man.",
				"When are we gonna get out of this chicken-shit outfit?",
				"Wish I had better equipment...",
				"I knew I should have been a line chef...",
				"Fuckin' helmet keeps fogging up.",
				"Anyone else smell that?")
	emote_hear = list("sniffs","coughs","taps his foot")
	emote_see = list("looks around","checks his equipment")
	say_understood = list()
	say_cannot = list()
	say_maybe_target = list("What's that?","Is someone there?","Is that...?","Hmm?")
	say_got_target = list("ENGAGING!!!","CONTACT!!!","TARGET SPOTTED!","FOUND ONE!")
	reactions = list("Hey guys, you ready?" = "Fuck yeah!")

	var/corpse = /obj/effect/landmark/mobcorpse/syndicatesoldier

/mob/living/simple_animal/hostile/syndicate/death()
	if(corpse)
		..()
		new corpse (src.loc)
	else
		..(0,"explodes!")
		new /obj/effect/gibspawner/human(src.loc)
		explosion(get_turf(src), -1, 0, 1, 3)
	qdel(src)
	return

///////////////Sword and shield////////////

/mob/living/simple_animal/hostile/syndicate/melee
	icon_state = "syndicatemelee"
	icon_living = "syndicatemelee"

	melee_damage_lower = 30
	melee_damage_upper = 30
	attack_armor_pen = 50
	attack_sharp = 1
	attack_edge = 1
	attacktext = list("slashed")

	status_flags = 0

	loot_list = list(/obj/item/weapon/melee/energy/sword/red = 100, /obj/item/weapon/shield/energy = 100)

/mob/living/simple_animal/hostile/syndicate/melee/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(O.force)
		if(prob(20))
			visible_message("<span class='danger'>\The [src] blocks \the [O] with its shield!</span>")
			if(user)
				react_to_attack(user)
			return
		else
			..()
	else
		usr << "<span class='warning'>This weapon is ineffective, it does no damage.</span>"
		visible_message("<span class='warning'>\The [user] gently taps [src] with \the [O].</span>")

/mob/living/simple_animal/hostile/syndicate/melee/bullet_act(var/obj/item/projectile/Proj)
	if(!Proj)	return
	if(prob(35))
		visible_message("<font color='red'><B>[src] blocks [Proj] with its shield!</B></font>")
		if(Proj.firer)
			react_to_attack(Proj.firer)
		return
	else
		..()

/mob/living/simple_animal/hostile/syndicate/melee/space
	name = "syndicate commando"
	icon_state = "syndicatemeleespace"
	icon_living = "syndicatemeleespace"

	speed = 0

	armor = list(melee = 60, bullet = 50, laser = 30, energy = 15, bomb = 35, bio = 100, rad = 100)	// Same armor as their voidsuit

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

	corpse = /obj/effect/landmark/mobcorpse/syndicatecommando

/mob/living/simple_animal/hostile/syndicate/melee/space/Process_Spacemove(var/check_drift = 0)
	return

/mob/living/simple_animal/hostile/syndicate/ranged
	icon_state = "syndicateranged"
	icon_living = "syndicateranged"

	ranged = 1
	rapid = 1
	projectiletype = /obj/item/projectile/bullet/pistol/medium
//	casingtype = /obj/item/ammo_casing/spent	//Makes infinite stacks of bullets when put in PoIs.
	projectilesound = 'sound/weapons/Gunshot_light.ogg'

	loot_list = list(/obj/item/weapon/gun/projectile/automatic/c20r = 100)

/mob/living/simple_animal/hostile/syndicate/ranged/laser
	icon_state = "syndicateranged_laser"
	icon_living = "syndicateranged_laser"
	rapid = 0
	projectiletype = /obj/item/projectile/beam/midlaser
	projectilesound = 'sound/weapons/Laser.ogg'

	loot_list = list(/obj/item/weapon/gun/energy/laser = 100)

/mob/living/simple_animal/hostile/syndicate/ranged/ionrifle
	icon_state = "syndicateranged_ionrifle"
	icon_living = "syndicateranged_ionrifle"
	rapid = 0
	projectiletype = /obj/item/projectile/ion
	projectilesound = 'sound/weapons/Laser.ogg'

	loot_list = list(/obj/item/weapon/gun/energy/ionrifle = 100)

/mob/living/simple_animal/hostile/syndicate/ranged/space
	name = "space mercenary" //VOREStation Edit
	icon_state = "syndicaterangedpsace"
	icon_living = "syndicaterangedpsace"

	speed = 0

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	maxbodytemp = 900 //VOREStation edit - We'll pretend they have good suits

	corpse = /obj/effect/landmark/mobcorpse/syndicatecommando

/mob/living/simple_animal/hostile/syndicate/ranged/space/Process_Spacemove(var/check_drift = 0)
	return

///////////////////////////////////////////////
//	POI Mobs
//	Don't leave corpses, to help balance loot.
///////////////////////////////////////////////

/mob/living/simple_animal/hostile/syndicate/poi
	loot_list = list()
	corpse = null

/mob/living/simple_animal/hostile/syndicate/melee/poi
	loot_list = list()
	corpse = null

/mob/living/simple_animal/hostile/syndicate/melee/space/poi
	loot_list = list()
	corpse = null

/mob/living/simple_animal/hostile/syndicate/ranged/poi
	loot_list = list()
	corpse = null

/mob/living/simple_animal/hostile/syndicate/ranged/laser/poi
	loot_list = list()
	corpse = null

/mob/living/simple_animal/hostile/syndicate/ranged/ionrifle/poi
	loot_list = list()
	corpse = null

/mob/living/simple_animal/hostile/syndicate/ranged/space/poi
	loot_list = list()
	corpse = null


//Viscerators

/mob/living/simple_animal/hostile/viscerator
	name = "viscerator"
	desc = "A small, twin-bladed machine capable of inflicting very deadly lacerations."
	icon = 'icons/mob/critter.dmi'
	icon_state = "viscerator_attack"
	icon_living = "viscerator_attack"
	intelligence_level = SA_ROBOTIC
	hovering = TRUE

	faction = "syndicate"
	maxHealth = 15
	health = 15

	pass_flags = PASSTABLE

	melee_damage_lower = 15
	melee_damage_upper = 15
	attack_sharp = 1
	attack_edge = 1
	attack_sound = 'sound/weapons/bladeslice.ogg'
	attacktext = list("cut")

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

/mob/living/simple_animal/hostile/viscerator/death()
	..(null,"is smashed into pieces!")
	qdel(src)
