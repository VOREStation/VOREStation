// Somewhere between a fox and a weasel. Doesn't mess with stuff significantly bigger than it, but you don't want to get on its bad side.

/datum/category_item/catalogue/fauna/siffet
	name = "Sivian Fauna - Siffet"
	desc = "Classification: S Pruinaeictis velocis\
	<br><br>\
	The Siffet, or Sivian Frost Weasel is a small, solitary predator known for its striking ability to take down prey up to twice their size. \
	The majority of the Siffet's adult life is spent in isolation, prowling large territories in Sif's tundra regions, \
	only seeking out other individuals during the summer mating season, when deadly battles for dominance are common. \
	Though mostly docile towards adult humans and other large sapients, the Siffet has been known to target children and smaller species as prey, \
	and a provoked Siffet can be a danger to even the most experienced handler due to its quick movement and surprisingly powerful jaws. \
	The Siffet is sometimes hunted for its remarkably soft pelt, though most is obtained through fur farming."
	value = CATALOGUER_REWARD_MEDIUM

/mob/living/simple_mob/animal/sif/siffet
	name = "siffet"
	desc = "A small, solitary predator with silky fur. Despite its size, the Siffet is ferocious when provoked."
	tt_desc = "S Pruinaeictis velocis" //Sivian frost weasel, fast
	catalogue_data = list(/datum/category_item/catalogue/fauna/siffet)

	faction =FACTION_SIFFET

	mob_size = MOB_SMALL

	icon_state = "siffet"
	icon_living = "siffet"
	icon_dead = "siffet_dead"
	icon = 'icons/mob/animal.dmi'

	maxHealth = 60
	health = 60

	movement_cooldown = -2

	melee_damage_lower = 10
	melee_damage_upper = 15
	base_attack_cooldown = 1 SECOND
	attack_sharp = TRUE
	attacktext = list("sliced", "snapped", "gnawed")

	say_list_type = /datum/say_list/siffet
	ai_holder_type = /datum/ai_holder/simple_mob/siffet

/datum/say_list/siffet
	speak = list("Yap!", "Heh!", "Huff.")
	emote_see = list("sniffs its surroundings","flicks its ears", "scratches the ground")
	emote_hear = list("chatters", "huffs")

/datum/ai_holder/simple_mob/siffet
	hostile = TRUE
	retaliate = TRUE

/datum/ai_holder/simple_mob/siffet/post_melee_attack(atom/A) //Evasive
	if(holder.Adjacent(A))
		holder.IMove(get_step(holder, pick(alldirs)))
		holder.face_atom(A)

/mob/living/simple_mob/animal/sif/siffet/IIsAlly(mob/living/L)
	. = ..()
	if(!. && L.mob_size > 10) //Attacks things it considers small enough to take on, otherwise only attacks if attacked.
		return TRUE
