/mob/living/simple_animal/hostile/syndicate
	name = "syndicate operative"
	desc = "Death to the Company."
	icon_state = "syndicate"
	icon_living = "syndicate"
	icon_dead = "syndicate_dead"
	icon_gib = "syndicate_gib"

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
	melee_damage_lower = 10
	melee_damage_upper = 15
	environment_smash = 1
	attacktext = "punched"

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
	..()
	if(corpse)
		new corpse (src.loc)
	qdel(src)
	return

///////////////Sword and shield////////////

/mob/living/simple_animal/hostile/syndicate/melee
	icon_state = "syndicatemelee"
	icon_living = "syndicatemelee"

	melee_damage_lower = 20
	melee_damage_upper = 25
	attacktext = "slashed"

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
	casingtype = /obj/item/ammo_casing/spent
	projectilesound = 'sound/weapons/Gunshot_light.ogg'

	loot_list = list(/obj/item/weapon/gun/projectile/automatic/c20r = 100)

/mob/living/simple_animal/hostile/syndicate/ranged/space
	name = "syndicate sommando"
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

	corpse = /obj/effect/landmark/mobcorpse/syndicatecommando

/mob/living/simple_animal/hostile/syndicate/ranged/space/Process_Spacemove(var/check_drift = 0)
	return

/mob/living/simple_animal/hostile/viscerator
	name = "viscerator"
	desc = "A small, twin-bladed machine capable of inflicting very deadly lacerations."
	icon = 'icons/mob/critter.dmi'
	icon_state = "viscerator_attack"
	icon_living = "viscerator_attack"

	faction = "syndicate"
	maxHealth = 15
	health = 15

	pass_flags = PASSTABLE

	melee_damage_lower = 15
	melee_damage_upper = 15
	attack_sound = 'sound/weapons/bladeslice.ogg'
	attacktext = "cut"

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
