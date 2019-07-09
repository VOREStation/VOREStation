// This is a container for mobs to hold onto skills.

/mob/living
	var/datum/skillset/skillset

/datum/skillset
	var/mob/living/owner = null
	var/list/skill_list = list()