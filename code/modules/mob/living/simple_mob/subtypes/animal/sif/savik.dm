// Saviks are dangerous, angry creatures that hit hard, and will berserk if losing a fight.

/mob/living/simple_mob/animal/sif/savik
	name = "savik"
	tt_desc = "S Pistris tellus" //landshark
	player_msg = "You have the ability to <b>berserk at will</b>, which will grant strong physical bonuses for \
	a short period of time, however it will tire you and you will be much weaker for awhile after it expires."

	faction = "savik"

	icon_state = "savik"
	icon_living = "savik"
	icon_dead = "savik_dead"
	icon = 'icons/jungle.dmi'

	maxHealth = 125
	health = 125

	movement_cooldown = 0.5 SECONDS

	melee_damage_lower = 15
	melee_damage_upper = 35
	attack_armor_pen = 15
	attack_sharp = TRUE
	attack_edge = TRUE
	melee_attack_delay = 1 SECOND
	attacktext = list("mauled")

	say_list_type = /datum/say_list/savik

/datum/say_list/savik
	speak = list("Hruuugh!","Hrunnph")
	emote_see = list("paws the ground","shakes its mane","stomps")
	emote_hear = list("snuffles")

/mob/living/simple_mob/animal/sif/savik/handle_special()
	if((get_AI_stance() in list(STANCE_APPROACH, STANCE_FIGHT)) && !is_AI_busy() && isturf(loc))
		if(health <= (maxHealth * 0.5)) // At half health, and fighting someone currently.
			berserk()


// So players can use it too.
/mob/living/simple_mob/animal/sif/savik/verb/berserk()
	set name = "Berserk"
	set desc = "Enrage and become vastly stronger for a period of time, however you will be weaker afterwards."
	set category = "Abilities"

	add_modifier(/datum/modifier/berserk, 30 SECONDS)
