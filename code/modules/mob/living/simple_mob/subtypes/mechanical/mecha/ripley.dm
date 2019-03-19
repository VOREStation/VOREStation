// Beefy, but somewhat slow.
// Melee attack is to bore you with its big drill, which has a lot of armor penetration and strikes rapidly.

/mob/living/simple_mob/mechanical/mecha/ripley
	name = "\improper APLU ripley"
	desc = "Autonomous Power Loader Unit. The workhorse of the exosuit world. This one has big drill."
	icon_state = "ripley"
	wreckage = /obj/structure/loot_pile/mecha/ripley

	maxHealth = 200

	melee_damage_lower = 10
	melee_damage_upper = 10
	base_attack_cooldown = 5 // About 20 DPS.
	attack_armor_pen = 50
	attack_sharp = TRUE
	attack_sound = 'sound/mecha/mechdrill.ogg'
	attacktext = list("drilled", "bored", "pierced")

/mob/living/simple_mob/mechanical/mecha/ripley/manned
	pilot_type = /mob/living/simple_mob/humanoid/merc/ranged // Carries a pistol.

/mob/living/simple_mob/mechanical/mecha/ripley/red_flames
	icon_state = "ripley_flames_red"

/mob/living/simple_mob/mechanical/mecha/ripley/blue_flames
	icon_state = "ripley_flames_blue"


// Immune to heat damage, resistant to lasers, and somewhat beefier. Still tries to melee you.
/mob/living/simple_mob/mechanical/mecha/ripley/firefighter
	name = "\improper APLU firefighter"
	desc = "A standard APLU chassis, refitted with additional thermal protection and cistern. This one has a big drill."
	icon_state = "firefighter"
	wreckage = /obj/structure/loot_pile/mecha/ripley/firefighter

	maxHealth = 250
	heat_resist = 1
	armor = list(
				"melee"		= 0,
				"bullet"	= 20,
				"laser"		= 50,
				"energy"	= 0,
				"bomb"		= 50,
				"bio"		= 100,
				"rad"		= 100
				)

/mob/living/simple_mob/mechanical/mecha/ripley/firefighter/manned
	pilot_type = /mob/living/simple_mob/humanoid/merc/ranged

// Mostly a joke mob, like the real DEATH-RIPLEY.
/mob/living/simple_mob/mechanical/mecha/ripley/deathripley
	name = "\improper DEATH-RIPLEY"
	desc = "OH SHIT RUN!!! IT HAS A KILL CLAMP!"
	icon_state = "deathripley"
	wreckage = /obj/structure/loot_pile/mecha/deathripley

	melee_damage_lower = 0
	melee_damage_upper = 0
	friendly = list("utterly obliterates", "furiously destroys", "permanently removes", "unflichingly decimates", "brutally murders", "absolutely demolishes", "completely annihilates")

/mob/living/simple_mob/mechanical/mecha/ripley/deathripley/manned
	pilot_type = /mob/living/simple_mob/humanoid/merc/ranged
