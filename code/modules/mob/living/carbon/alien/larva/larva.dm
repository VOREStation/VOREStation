/mob/living/carbon/alien/larva
	name = "alien larva"
	real_name = "alien larva"
	adult_form = /mob/living/carbon/human
	speak_emote = list("hisses")
	icon_state = "larva"
	language = LANGUAGE_HIVEMIND
	maxHealth = 50
	health = 50
	faction = FACTION_XENO
	max_grown = 325 //Increase larva growth time due to not needing hosts.

/mob/living/carbon/alien/larva/Initialize(mapload)
	. = ..()
	add_language(LANGUAGE_XENOLINGUA) //Bonus language.
	internal_organs |= new /obj/item/organ/internal/xenos/hivenode(src)
