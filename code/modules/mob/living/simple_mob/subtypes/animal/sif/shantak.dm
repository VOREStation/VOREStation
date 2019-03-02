// Shantaks are essentially sif wolves.

/mob/living/simple_mob/animal/sif/shantak
	name = "shantak"
	desc = "A piglike creature with a bright iridiscent mane that sparkles as though lit by an inner light. \
	Don't be fooled by its beauty though."
	tt_desc = "S Choeros shantak"

	faction = "shantak"

	icon_state = "shantak"
	icon_living = "shantak"
	icon_dead = "shantak_dead"
	icon = 'icons/jungle.dmi'

	maxHealth = 75

	movement_cooldown = 5

	melee_damage_lower = 6
	melee_damage_upper = 14
	base_attack_cooldown = 1 SECOND
	melee_attack_delay = 0.5 SECONDS
	attack_armor_pen = 5
	attack_sharp = TRUE
	attack_edge = TRUE
	attacktext = list("gouged")

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
	icon_scale = 1.5
	maxHealth = 125
	player_msg = "You have the ability to <b>command other shantaks to follow you</b>."

/mob/living/simple_mob/animal/sif/shantak/leader/verb/rally_pack()
	set name = "Rally Pack"
	set desc = "Commands your fellow packmembers to follow you, the leader."
	set category = "Abilities"

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
/mob/living/simple_mob/animal/sif/shantak/leader/autofollow/initialize()
	rally_pack()
	return ..()


// These ones only retaliate. Used for a PoI.
/mob/living/simple_mob/animal/sif/shantak/retaliate
	ai_holder_type = /datum/ai_holder/simple_mob/retaliate