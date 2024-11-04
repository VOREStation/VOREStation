// Saviks are dangerous, angry creatures that hit hard, and will berserk if losing a fight.

/datum/category_item/catalogue/fauna/savik
	name = "Sivian Fauna - Savik"
	desc = "Classification: S Pistris tellus\
	<br><br>\
	A predatory warm-blooded reptillian species covered in a layer of insulating down feathers. \
	The Savik's preferred method of hunting is to burrow under deep snow drifts, and lie in ambush for prey. \
	The Savik has been known to lie in wait for days at a time, generating heat by vibrating its shoulder plates \
	at a nigh inperceptable frequency while most of its body enters a state of sopor in order to conserve energy. \
	<br><br>\
	Once the Savik detects its prey, it will charge with incredible kinetic force with the two enormous, \
	angled bony plates on either side of the Savik's upper body acting as a natural snow plow, \
	allowing frightening ease of movement through deep snow. Due to the long periods between feeding, \
	the Savik will hunt its prey with absolute perseverence, as failure to catch a suitable meal is likely to \
	spell death for the animal due to the high energy expenditure of its initial strike. \
	The Savik has no known predators, and should be avoided at all costs."
	value = CATALOGUER_REWARD_MEDIUM

/mob/living/simple_mob/animal/sif/savik
	name = "savik"
	tt_desc = "S Pistris tellus" //landshark
	catalogue_data = list(/datum/category_item/catalogue/fauna/savik)
	faction = FACTION_SAVIK

	icon_state = "savik"
	icon_living = "savik"
	icon_dead = "savik_dead"
	icon = 'icons/jungle.dmi'

	maxHealth = 125
	health = 125

	movement_cooldown = -1

	melee_damage_lower = 15
	melee_damage_upper = 35
	attack_armor_pen = 15
	attack_sharp = TRUE
	attack_edge = TRUE
	melee_attack_delay = 1 SECOND
	attacktext = list("mauled")

	organ_names = /decl/mob_organ_names/savik

	player_msg = "You have the ability to <b>berserk at will</b>, which will grant strong physical bonuses for \
	a short period of time, however it will tire you and you will be much weaker for awhile after it expires."

	tame_items = list(
	/obj/item/organ = 70,
	/obj/item/reagent_containers/food/snacks/crabmeat = 30,
	/obj/item/reagent_containers/food/snacks/meat = 20
	)

	say_list_type = /datum/say_list/savik
	ai_holder_type = /datum/ai_holder/simple_mob/savik

/datum/say_list/savik
	speak = list("Hruuugh!","Hrunnph")
	emote_see = list("paws the ground","shakes its mane","stomps")
	emote_hear = list("snuffles")

/mob/living/simple_mob/animal/sif/savik/handle_special()
	if((get_AI_stance() in list(STANCE_APPROACH, STANCE_FIGHT)) && !is_AI_busy() && isturf(loc))
		if(health <= (maxHealth * 0.5)) // At half health, and fighting someone currently.
			berserk()

/mob/living/simple_mob/animal/sif/savik/fail_tame(var/obj/O, var/mob/user)
	..()

	if(prob(30))	// They don't like people messing with them and their food.
		berserk()

/datum/ai_holder/simple_mob/savik
	mauling = TRUE

// So players can use it too.
/mob/living/simple_mob/animal/sif/savik/verb/berserk()
	set name = "Berserk"
	set desc = "Enrage and become vastly stronger for a period of time, however you will be weaker afterwards."
	set category = "Abilities.Savik"

	add_modifier(/datum/modifier/berserk, 30 SECONDS)

/decl/mob_organ_names/savik
	hit_zones = list("head", "torso", "left foreleg", "right foreleg", "left hind leg", "right hind leg", "right bone plate", "left bone plate", "tail", "left claw", "right claw")
