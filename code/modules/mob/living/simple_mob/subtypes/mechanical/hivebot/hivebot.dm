// Hivebots are tuned towards how many default lasers are needed to kill them.
// As such, if laser damage is ever changed, you should change this define.
#define LASERS_TO_KILL * 40

/mob/living/simple_mob/mechanical/hivebot
	name = "hivebot"
	desc = "A robot. It appears to be somewhat resilient, but lacks a true weapon."
	icon = 'icons/mob/hivebot.dmi'
	icon_state = "basic"
	icon_living = "basic"

	faction = "hivebot"

	maxHealth = 3 LASERS_TO_KILL
	health = 3 LASERS_TO_KILL
	water_resist = 0.5
	movement_sound = 'sound/effects/servostep.ogg'

	attacktext = list("clawed")
	projectilesound = 'sound/weapons/Gunshot_old.ogg'

	ai_holder_type = /datum/ai_holder/simple_mob/hivebot
	say_list_type = /datum/say_list/hivebot


/mob/living/simple_mob/mechanical/hivebot/death()
	..()
	visible_message(span("warning","\The [src] blows apart!"))
	new /obj/effect/decal/cleanable/blood/gibs/robot(src.loc)
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(3, 1, src)
	s.start()
	qdel(src)

// The hivebot's default projectile.
/obj/item/projectile/bullet/hivebot
	damage = 10
	damage_type = BRUTE
	sharp = FALSE
	edge = FALSE

/mob/living/simple_mob/mechanical/hivebot/swarm
	name = "swarm hivebot"
	desc = "A robot. It looks fragile and weak."
	maxHealth = 1 LASERS_TO_KILL
	health = 1 LASERS_TO_KILL
	melee_damage_lower = 8
	melee_damage_upper = 8
	attack_armor_pen = 5

/datum/ai_holder/simple_mob/hivebot
	pointblank = TRUE
	conserve_ammo = TRUE
	firing_lanes = TRUE
	can_flee = FALSE // Fearless dumb machines.