// Mobs intended to be on Sif. As such, they won't die to the cold.
/mob/living/simple_mob/animal/sif
	minbodytemp = 175
	cold_resist = 0.75
	heat_resist = -0.5

	tame_items = list(
	/obj/item/weapon/reagent_containers/food/snacks/crabmeat = 20,
	/obj/item/weapon/reagent_containers/food/snacks/meat = 10
	)
<<<<<<< HEAD
=======

	// Healing threshold for grafadreka healing spit effect.
	var/sap_heal_threshold = 1
	var/const/scarification_period = 0.25

/mob/living/simple_mob/animal/sif/Stat()
	. = ..()
	if(statpanel("Status"))
		stat("Scarring:", "[round((1-sap_heal_threshold)*100)]%")

/mob/living/simple_mob/animal/sif/updatehealth()
	. = ..()
	// Set our heal threshold to a 0-1 percentage value. This times our max HP
	// caps the amount drakes can heal with their sap wound tending interaction.
	sap_heal_threshold = min(sap_heal_threshold, (round(health / getMaxHealth() / scarification_period)+1) * scarification_period)

/mob/living/simple_mob/animal/sif/examine(mob/user)
	. = ..()
	if(stat != DEAD)
		var/scarification = 1-sap_heal_threshold
		var/datum/gender/G = gender_datums[get_visible_gender()]
		var/scar_text = "[G.He] [G.is]"
		if(scarification >= 0.75)
			scar_text = "[scar_text] [SPAN_DANGER("a solid mass of scar tissue")]."
		else if(scarification > 0.5)
			scar_text = "[scar_text] [SPAN_DANGER("heavily scarred")]."
		else if(scarification > 0.25)
			scar_text = "[scar_text] [SPAN_WARNING("moderately scarred")]."
		else if(scarification > 0)
			scar_text = "[scar_text] [SPAN_WARNING("lightly scarred")]."
		else
			scar_text = "[scar_text] [SPAN_NOTICE("unscarred")]."
		. += scar_text
>>>>>>> 781fe82a78a... Merge pull request #8841 from MistakeNot4892/aminals
