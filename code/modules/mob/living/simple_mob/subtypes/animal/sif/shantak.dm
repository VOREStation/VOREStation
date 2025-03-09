// Shantaks are essentially sif wolves.

/datum/category_item/catalogue/fauna/shantak
	name = "Sivian Fauna - Shantak"
	desc = "Classification: S Choeros shantak\
	<br><br>\
	The Shantak is easily recognized by its iridescent, crystaline mane. \
	The creature's specially adapted hairs are hardened by a natural hard mineral coating, \
	thickest in the mane but present across the whole body. \
	As well as giving the Shantak a coat nigh-inpenetrable to all but the most specialized predator, \
	their hard, almost metallic coat gives them a slightly musical accent as they move. \
	The Shantak uses its powerful foreclaws for both den-building and foraging. \
	<br><br>\
	Observed to share several square-mile territories with a small number of other individuals, \
	the Shantak will rotate between several dens dug deep into the hard earth throughout the year, \
	while deftly avoiding others of its species outwith mating season. While other wildlife makes use of these dens, \
	the Shantak is fiercely territorial and will defend itself against any creature it perceives as a threat with reckless abandon. \
	Their diet consists primarily of fungi and insects found just below the permafrost."
	value = CATALOGUER_REWARD_MEDIUM

/mob/living/simple_mob/animal/sif/shantak
	name = "shantak"
	desc = "A piglike creature with a bright iridiscent mane that sparkles as though lit by an inner light. \
	Don't be fooled by its beauty though."
	tt_desc = "S Choeros shantak"
	catalogue_data = list(/datum/category_item/catalogue/fauna/shantak)

	faction = FACTION_SHANTAK

	icon_state = "shantak"
	icon_living = "shantak"
	icon_dead = "shantak_dead"
	icon = 'icons/jungle.dmi'

	maxHealth = 75
	armor_soak = list(
				"melee" = 5,
				"bullet" = 0,
				"laser" = 0,
				"energy" = 0,
				"bomb" = 0,
				"bio" = 0,
				"rad" = 0
				)

	movement_cooldown = -1

	melee_damage_lower = 6
	melee_damage_upper = 14
	base_attack_cooldown = 1 SECOND
	melee_attack_delay = 0.5 SECONDS
	attack_armor_pen = 5
	attack_sharp = TRUE
	attack_edge = TRUE
	attacktext = list("gouged")

	organ_names = /decl/mob_organ_names/shantak

	say_list_type = /datum/say_list/shantak

/datum/say_list/shantak
	speak = list("Shuhn.","Shrunnph?","Shunpf.")
	emote_see = list("scratches the ground", "shakes out its mane", "clinks gently as it moves")


// The pack leader.
// Will command other shantaks to follow it.
/mob/living/simple_mob/animal/sif/shantak/leader
	name = "big shantak"
	desc = "A piglike creature with a bright iridiscent mane that sparkles as though lit by an inner light. \
	This one seems bigger than the others, and has a commanding presence."
	icon_scale_x = 1.5
	icon_scale_y = 1.5
	maxHealth = 125
	player_msg = "You have the ability to <b>command other shantaks to follow you</b>."

/mob/living/simple_mob/animal/sif/shantak/leader/verb/rally_pack()
	set name = "Rally Pack"
	set desc = "Commands your fellow packmembers to follow you, the leader."
	set category = "Abilities.Shantak"

	for(var/mob/living/simple_mob/animal/sif/shantak/S in hearers(7, src))
		if(istype(S, /mob/living/simple_mob/animal/sif/shantak/leader)) // Leaders won't follow other leaders. Also avoids trying to follow ourselves.
			continue
		if(!S.ai_holder)
			continue
		if(S.faction != src.faction)
			continue
		var/datum/ai_holder/AI = S.ai_holder
		AI.set_follow(src)

// Variant that automatically commands nearby allies to follow it when created.
// Suggested to spawn last so it can rally up all the shantaks easily before hunting for tasty explorers.
/mob/living/simple_mob/animal/sif/shantak/leader/autofollow/Initialize(mapload)
	rally_pack()
	return ..()

// These ones only retaliate. Used for PoIs.
/mob/living/simple_mob/animal/sif/shantak/retaliate
	ai_holder_type = /datum/ai_holder/simple_mob/retaliate

/mob/living/simple_mob/animal/sif/shantak/leader/autofollow/retaliate
	ai_holder_type = /datum/ai_holder/simple_mob/retaliate

//Vorestation Addition
/mob/living/simple_mob/animal/sif/shantak/scruffy
	name = "Scruffy"
	ai_holder_type = /datum/ai_holder/simple_mob/passive
	makes_dirt = 0
	faction = FACTION_NEUTRAL

/decl/mob_organ_names/shantak
	hit_zones = list("head", "torso", "left foreleg", "right foreleg", "left hind leg", "right hind leg", "tail", "mane", "snout")
