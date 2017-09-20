/mob/living/simple_animal/hostile/mecha
	name = "syndicate gygax"
	desc = "Well that's forboding."
	icon = 'icons/mecha/mecha.dmi'
	icon_state = "darkgygax"
	icon_living = "darkgygax"
	icon_dead = "darkgygax-broken"
	intelligence_level = SA_HUMANOID // Piloted by a human.

	faction = "syndicate"
	maxHealth = 300
	health = 300
	speed = 7
	move_to_delay = 8

	run_at_them = 0
	cooperative = 1
	investigates = 1
	firing_lines = 1

	turns_per_move = 5
	stop_when_pulled = 0

	response_help = "taps on"
	response_disarm = "knocks on"
	response_harm = "uselessly hits"

	harm_intent_damage = 0
	melee_damage_lower = 35
	melee_damage_upper = 35
	attacktext = "slashed"
	attack_sound = 'sound/weapons/bladeslice.ogg'

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	unsuitable_atoms_damage = 0

	ranged = 1
	rapid = 1
	projectiletype = /obj/item/projectile/beam
	projectilesound = 'sound/weapons/laser.ogg'

	speak_chance = 1
	speak = list("Know what we need? More meatshields.",
				"Glad I finally got a mech.",
				"I'll stomp those NanoTrasen dogs into paste.",
				"Glad I didn't become a line chef.",
				"This anti-fog visor is nice...",
				"Did I refill the air tank?")
	emote_hear = list("humms ominously","whirrs softly","grinds a gear")
	emote_see = list("looks around the area","turns from side to side")
	say_understood = list()
	say_cannot = list()
	say_maybe_target = list("Just my sensors?","Detecting something?","Is that...?","What was that?")
	say_got_target = list("ENGAGING!!!","CONTACT!!!","TARGET SPOTTED!","FOUND ONE!")
	reactions = list()

	var/datum/effect/effect/system/spark_spread/sparks
	var/wreckage = /obj/effect/decal/mecha_wreckage/gygax/dark

/mob/living/simple_animal/hostile/mecha/New()
	..()
	sparks = new (src)
	sparks.set_up(3, 1, src)

/mob/living/simple_animal/hostile/mecha/Destroy()
	qdel(sparks)
	..()

/mob/living/simple_animal/hostile/mecha/Life()
	. = ..()
	if(!.) return
	if((health < getMaxHealth()*0.3) && prob(10))
		sparks.start()

/mob/living/simple_animal/hostile/mecha/bullet_act()
	..()
	sparks.start()

/mob/living/simple_animal/hostile/mecha/death()
	..(0,"is explodes!")
	sparks.start()
	explosion(get_turf(src), 0, 0, 1, 3)
	qdel(src)
	new /obj/effect/decal/mecha_wreckage/gygax/dark(get_turf(src))

/mob/living/simple_animal/hostile/mecha/Move()
	..()
	playsound(src,'sound/mecha/mechstep.ogg',40,1)
