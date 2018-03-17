// Hivebots are tuned towards how many default lasers are needed to kill them.
// As such, if laser damage is ever changed, you should change this define.
#define LASERS_TO_KILL *30

// Default hivebot is melee, and a bit more meaty, so it can meatshield for their ranged friends.
/mob/living/simple_animal/hostile/hivebot
	name = "hivebot"
	desc = "A robot. It appears to be somewhat resilient, but lacks a true weapon."
	icon = 'icons/mob/hivebot.dmi'
	icon_state = "basic"
	icon_living = "basic"
	icon_dead = "basic"

	faction = "hivebot"
	intelligence_level = SA_ROBOTIC
	maxHealth = 3 LASERS_TO_KILL
	health = 3 LASERS_TO_KILL
	speed = 4

	melee_damage_lower = 15
	melee_damage_upper = 15

	attacktext = list("clawed")
	projectilesound = 'sound/weapons/Gunshot.ogg'
	projectiletype = /obj/item/projectile/bullet/hivebot

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

	cooperative = TRUE
	firing_lines = TRUE
	investigates = TRUE
	run_at_them = FALSE //VOREStation Edit

	speak_chance = 1
	speak = list(
		"Resuming task: Protect area.",
		"No threats found.",
		"Error: No targets found."
		)
	emote_hear = list("hums ominously", "whirrs softly", "grinds a gear")
	emote_see = list("looks around the area", "turns from side to side")
	say_understood = list("Affirmative.", "Positive.")
	say_cannot = list("Denied.", "Negative.")
	say_maybe_target = list("Possible threat detected.  Investigating.", "Motion detected.", "Investigating.")
	say_got_target = list("Threat detected.", "New task: Remove threat.", "Threat removal engaged.", "Engaging target.")

/mob/living/simple_animal/hostile/hivebot/isSynthetic()
	return TRUE

// Subtypes.

// Melee like the base type, but more fragile.
/mob/living/simple_animal/hostile/hivebot/swarm
	name = "swarm hivebot"
	desc = "A robot. It looks fragile and weak"
	maxHealth = 1 LASERS_TO_KILL
	health = 1 LASERS_TO_KILL
	melee_damage_lower = 8
	melee_damage_upper = 8

// This one has a semi-weak ranged attack.
/mob/living/simple_animal/hostile/hivebot/range
	name = "ranged hivebot"
	desc = "A robot.  It has a simple ballistic weapon."
	ranged = 1
	maxHealth = 2 LASERS_TO_KILL
	health = 2 LASERS_TO_KILL

// This one shoots a burst of three, and is considerably more dangerous.
/mob/living/simple_animal/hostile/hivebot/range/rapid
	name = "rapid hivebot"
	desc = "A robot.  It has a fast firing ballistic rifle."
	icon_living = "strong"
	rapid = 1
	maxHealth = 2 LASERS_TO_KILL
	health = 2 LASERS_TO_KILL

// Shoots EMPs, to screw over other robots.
/mob/living/simple_animal/hostile/hivebot/range/ion
	name = "engineering hivebot"
	desc = "A robot. It has a tool which emits focused electromagnetic pulses, which are deadly to synthetic adverseries."
	projectiletype = /obj/item/projectile/ion/small //VOREStation Edit
	projectilesound = 'sound/weapons/Laser.ogg'
	icon_living = "engi"
	ranged = TRUE
	maxHealth = 2 LASERS_TO_KILL
	health = 2 LASERS_TO_KILL

// Shoots deadly lasers.
/mob/living/simple_animal/hostile/hivebot/range/laser
	name = "laser hivebot"
	desc = "A robot. It has an energy weapon."
	projectiletype = /obj/item/projectile/beam/blue
	projectilesound = 'sound/weapons/Laser.ogg'
	maxHealth = 2 LASERS_TO_KILL
	health = 2 LASERS_TO_KILL

// Beefy and ranged.
/mob/living/simple_animal/hostile/hivebot/range/strong
	name = "strong hivebot"
	desc = "A robot.  This one has reinforced plating, and looks tougher."
	icon_living = "strong"
	maxHealth = 4 LASERS_TO_KILL
	health = 4 LASERS_TO_KILL
	melee_damage_lower = 15
	melee_damage_upper = 15

// Also beefy, but tries to stay at their 'home', ideal for base defense.
/mob/living/simple_animal/hostile/hivebot/range/guard
	name = "guard hivebot"
	desc = "A robot.  It seems to be guarding something."
	returns_home = TRUE
	maxHealth = 4 LASERS_TO_KILL
	health = 4 LASERS_TO_KILL

// This one is intended for players to use.  Well rounded and can make other hivebots follow them with verbs.
/mob/living/simple_animal/hostile/hivebot/range/player
	name = "commander hivebot"
	desc = "A robot.  This one seems to direct the others, and it has a laser weapon."
	icon_living = "commander"
	maxHealth = 5 LASERS_TO_KILL
	health = 5 LASERS_TO_KILL
	projectiletype = /obj/item/projectile/beam/blue
	projectilesound = 'sound/weapons/Laser.ogg'
	melee_damage_lower = 15 // Needed to force open airlocks.
	melee_damage_upper = 15

// Procs.

/mob/living/simple_animal/hostile/hivebot/death()
	..()
	visible_message("<b>[src]</b> blows apart!")
	new /obj/effect/decal/cleanable/blood/gibs/robot(src.loc)
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(3, 1, src)
	s.start()
	qdel(src)

/mob/living/simple_animal/hostile/hivebot/speech_bubble_appearance()
	return "synthetic_evil"

/mob/living/simple_animal/hostile/hivebot/verb/command_follow()
	set name = "Command - Follow"
	set category = "Hivebot"
	set desc = "This will ask other hivebots to follow you."

	say("Delegating new task: Follow.")

	for(var/mob/living/simple_animal/hostile/hivebot/buddy in hearers(src))
		if(buddy.faction != faction)
			continue
		if(buddy == src)
			continue
		buddy.set_follow(src)
		buddy.FollowTarget()
		spawn(rand(5, 10))
			buddy.say( pick(buddy.say_understood) )

/mob/living/simple_animal/hostile/hivebot/verb/command_stop()
	set name = "Command - Stop Following"
	set category = "Hivebot"
	set desc = "This will ask other hivebots to cease following you."

	say("Delegating new task: Stop following.")

	for(var/mob/living/simple_animal/hostile/hivebot/buddy in hearers(src))
		if(buddy.faction != faction)
			continue
		if(buddy == src)
			continue
		buddy.LoseFollow()
		spawn(rand(5, 10))
			buddy.say( pick(buddy.say_understood) )

/mob/living/simple_animal/hostile/hivebot/tele//this still needs work
	name = "Beacon"
	desc = "Some odd beacon thing"
	icon = 'icons/mob/hivebot.dmi'
	icon_state = "def_radar-off"
	icon_living = "def_radar-off"

	health = 200
	maxHealth = 200
	status_flags = 0

	anchored = 1
	wander = 0
	stop_automated_movement = 1

	var/bot_type = "norm"
	var/bot_amt = 10
	var/spawn_delay = 600
	var/turn_on = 0
	var/auto_spawn = 1
	proc
		warpbots()


	New()
		..()
		var/datum/effect/effect/system/smoke_spread/smoke = new /datum/effect/effect/system/smoke_spread()
		smoke.set_up(5, 0, src.loc)
		smoke.start()
		visible_message("<font color='red'><B>The [src] warps in!</font></B>")
		playsound(src.loc, 'sound/effects/EMPulse.ogg', 25, 1)

	warpbots()
		icon_state = "def_radar"
		visible_message("<font color='red'>The [src] turns on!</font>")
		while(bot_amt > 0)
			bot_amt--
			switch(bot_type)
				if("norm")
					new /mob/living/simple_animal/hostile/hivebot(get_turf(src))
				if("range")
					new /mob/living/simple_animal/hostile/hivebot/range(get_turf(src))
				if("rapid")
					new /mob/living/simple_animal/hostile/hivebot/range/rapid(get_turf(src))
		spawn(100)
			qdel(src)
		return


	Life()
		..()
		if(stat == 0)
			if(prob(2))//Might be a bit low, will mess with it likely
				warpbots()

/obj/item/projectile/bullet/hivebot
	damage = 10
	damage_type = BRUTE
