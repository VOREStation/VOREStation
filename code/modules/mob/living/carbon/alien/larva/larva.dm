/mob/living/carbon/alien/larva
	name = "alien larva"
	real_name = "alien larva"
	adult_form = /mob/living/carbon/human
	speak_emote = list("hisses")
	icon_state = "larva"
	language = "Hivemind"
	maxHealth = 25
	health = 25
	faction = "xeno"

/mob/living/carbon/alien/larva/Initialize()
	. = ..()
	add_language("Xenomorph") //Bonus language.
	internal_organs |= new /obj/item/organ/internal/xenos/hivenode(src)
