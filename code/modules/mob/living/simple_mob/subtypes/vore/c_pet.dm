/mob/living/simple_mob/animal/passive/honkpet
	name = "Hinkle"
	desc = "The Silence into Laughter program mass produces these animals for each member to raise and take care of."
	tt_desc = "Coulrian Honkus"
	icon = 'icons/mob/animal_vr.dmi'
	icon_state = "c_pet"
	icon_living = "c_pet"
	icon_dead = "c_pet_dead"

	maxHealth = 1500
	health = 1500
	minbodytemp = 175 // Same as Sif mobs.

	response_help  = "pets"
	response_disarm = "bonks"
	response_harm   = "squeaks"

	harm_intent_damage = 0
	melee_damage_lower = 0
	melee_damage_upper = 0
	attacktext = list("honked")

	armor = list(
				"melee" = 0,
				"bullet" = 0,
				"laser" = 0,
				"energy" = 0,
				"bomb" = 0,
				"bio" = 0,
				"rad" = 0
				)
	armor_soak = list(
				"melee" = 0,
				"bullet" = 0,
				"laser" = 0,
				"energy" = 0,
				"bomb" = 0,
				"bio" = 0,
				"rad" = 0
				)

	has_langs = list("Coulrian")

	var/list/potential_icons = list("c_pet, m_pet")

/mob/living/simple_mob/animal/passive/mimepet/attack_hand(mob/living/user as mob)
	.=..()
	if(user.a_intent == I_HELP)
		return icon_state = pick(potential_icons)

/mob/living/simple_mob/animal/passive/mimepet
	name = "Dave"
	desc = "That's Dave."
	tt_desc = "Polypodavesilencia"
	icon = 'icons/mob/animal_vr.dmi'
	icon_state = "dave1"
	icon_living = "dave1"
	icon_dead = "dave_dead"
	movement_cooldown = 300

	maxHealth = 1500
	health = 1500
	minbodytemp = 175 // Same as Sif mobs.

	response_help  = "..."
	response_disarm = "..."
	response_harm   = "..."

	harm_intent_damage = 0
	melee_damage_lower = 0
	melee_damage_upper = 0
	attacktext = list("...")

	armor = list(
				"melee" = 0,
				"bullet" = 0,
				"laser" = 0,
				"energy" = 0,
				"bomb" = 0,
				"bio" = 0,
				"rad" = 0
				)
	armor_soak = list(
				"melee" = 0,
				"bullet" = 0,
				"laser" = 0,
				"energy" = 0,
				"bomb" = 0,
				"bio" = 0,
				"rad" = 0
				)
	var/list/potential_icons = list("dave1", "dave2", "dave3", "dave5" , "dave6" , "dave7" , "dave8" , "dave9" , "dave10")

/mob/living/simple_mob/animal/passive/mimepet/attack_hand(mob/living/user as mob)
	.=..()
	if(user.a_intent == I_HELP)
		return icon_state = pick(potential_icons)