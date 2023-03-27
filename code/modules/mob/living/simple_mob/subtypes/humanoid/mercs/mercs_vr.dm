/datum/say_list/merc/unknown_ind
	speak = list("One day the'll fix that damn engine..","Next time, We're hidding on the tropical beach planet.","Wish I had better equipment...","I knew I should have been a line chef...","Fuckin' helmet keeps fogging up.","Hate this blocky ass ship.")
	say_got_target = list("Looks like trouble!","Contact!","We've got company!","Perimeter Breached!!")

/mob/living/simple_mob/humanoid/merc/melee/sword/space
	name = "mercenary commando"

	maxbodytemp = 700

/mob/living/simple_mob/humanoid/merc/ranged/space
	name = "mercenary commando"

	maxbodytemp = 700

/mob/living/simple_mob/humanoid/merc/ranged/virgo
	name = "suspicious individual"
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

/datum/say_list/merc/drone
	speak = list("Area patrol in progress.",
				"All systems nominal.",
				"Situation analysis finalized. No hostiles detected.",
				"Reporting status: all functions normal.",
				"Location under control.")
	emote_see = list("beeps", "pings", "twitches erratically", "looks around")

	say_understood = list("Command acknowledged.")
	say_cannot = list("Command error.")
	say_maybe_target = list("Please come out.", "Where did you go?", "Scanning...")
	say_got_target = list("Engaging.", "Targeting.", "Combat initiated.", "Following protocol. Eliminating hostile.")
	say_threaten = list("This location is under control. You have %UNDEFINED% seconds to depart.", "Your presence at these premises must be terminated.")
	say_stand_down = list("Your compliance is welcome.")
	say_escalate = list("Combat initiated.", "Your termination is inevitable.")

	threaten_sound = 'sound/weapons/TargetOn.ogg'
	stand_down_sound = 'sound/weapons/TargetOff.ogg'

/mob/living/simple_mob/humanoid/merc/drone
	name = "combat droid"
	desc = "A set of prosthetics, piloted by simplistic combat algorhithm and dressed in combat armor."
	tt_desc = null
	say_list_type = /datum/say_list/merc/drone
	corpse = /obj/effect/landmark/mobcorpse/syndicatesoldier/drone

/mob/living/simple_mob/humanoid/merc/melee/drone
	name = "combat droid"
	desc = "A set of prosthetics, piloted by simplistic combat algorhithm and dressed in combat armor."
	tt_desc = null
	say_list_type = /datum/say_list/merc/drone
	corpse = /obj/effect/landmark/mobcorpse/syndicatesoldier/drone

/mob/living/simple_mob/humanoid/merc/melee/sword/drone
	name = "combat droid"
	desc = "A set of prosthetics, piloted by simplistic combat algorhithm and dressed in combat armor."
	tt_desc = null
	say_list_type = /datum/say_list/merc/drone
	corpse = /obj/effect/landmark/mobcorpse/syndicatesoldier/drone

/mob/living/simple_mob/humanoid/merc/ranged/drone
	name = "combat droid"
	desc = "A set of prosthetics, piloted by simplistic combat algorhithm and dressed in combat armor."
	tt_desc = null
	say_list_type = /datum/say_list/merc/drone
	corpse = /obj/effect/landmark/mobcorpse/syndicatesoldier/drone

/mob/living/simple_mob/humanoid/merc/ranged/smg/drone
	name = "combat droid"
	desc = "A set of prosthetics, piloted by simplistic combat algorhithm and dressed in combat armor."
	tt_desc = null
	say_list_type = /datum/say_list/merc/drone
	corpse = /obj/effect/landmark/mobcorpse/syndicatesoldier/drone

/mob/living/simple_mob/humanoid/merc/ranged/rifle/drone
	name = "combat droid"
	desc = "A set of prosthetics, piloted by simplistic combat algorhithm and dressed in combat armor."
	tt_desc = null
	say_list_type = /datum/say_list/merc/drone
	corpse = /obj/effect/landmark/mobcorpse/syndicatesoldier/drone

/mob/living/simple_mob/humanoid/merc/ranged/rifle/mag/drone
	name = "combat droid"
	desc = "A set of prosthetics, piloted by simplistic combat algorhithm and dressed in combat armor."
	tt_desc = null
	say_list_type = /datum/say_list/merc/drone
	corpse = /obj/effect/landmark/mobcorpse/syndicatesoldier/drone

/mob/living/simple_mob/humanoid/merc/ranged/laser/drone
	name = "combat droid"
	desc = "A set of prosthetics, piloted by simplistic combat algorhithm and dressed in combat armor."
	tt_desc = null
	say_list_type = /datum/say_list/merc/drone
	corpse = /obj/effect/landmark/mobcorpse/syndicatesoldier/drone

/mob/living/simple_mob/humanoid/merc/ranged/ionrifle/drone
	name = "combat droid"
	desc = "A set of prosthetics, piloted by simplistic combat algorhithm and dressed in combat armor."
	tt_desc = null
	say_list_type = /datum/say_list/merc/drone
	corpse = /obj/effect/landmark/mobcorpse/syndicatesoldier/drone

/mob/living/simple_mob/humanoid/merc/ranged/grenadier/drone
	name = "combat droid"
	desc = "A set of prosthetics, piloted by simplistic combat algorhithm and dressed in combat armor."
	tt_desc = null
	say_list_type = /datum/say_list/merc/drone
	corpse = /obj/effect/landmark/mobcorpse/syndicatesoldier/drone

/mob/living/simple_mob/humanoid/merc/ranged/technician/drone
	name = "combat droid"
	desc = "A set of prosthetics, piloted by simplistic combat algorhithm and dressed in combat armor."
	tt_desc = null
	say_list_type = /datum/say_list/merc/drone
	corpse = /obj/effect/landmark/mobcorpse/syndicatesoldier/drone

/mob/living/simple_mob/humanoid/merc/ranged/sniper/drone
	name = "combat droid"
	desc = "A set of prosthetics, piloted by simplistic combat algorhithm and dressed in combat armor."
	tt_desc = null
	say_list_type = /datum/say_list/merc/drone
	corpse = /obj/effect/landmark/mobcorpse/syndicatesoldier/drone

/mob/living/simple_mob/humanoid/merc/melee/sword/space/drone
	name = "combat droid"
	desc = "A set of prosthetics, piloted by simplistic combat algorhithm and dressed in combat spacesuit."
	tt_desc = null
	say_list_type = /datum/say_list/merc/drone
	corpse = /obj/effect/landmark/mobcorpse/syndicatecommando/drone

/mob/living/simple_mob/humanoid/merc/ranged/space/drone
	name = "combat droid"
	desc = "A set of prosthetics, piloted by simplistic combat algorhithm and dressed in combat spacesuit."
	tt_desc = null
	say_list_type = /datum/say_list/merc/drone
	corpse = /obj/effect/landmark/mobcorpse/syndicatecommando/drone