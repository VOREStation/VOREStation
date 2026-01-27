/datum/trait/patting_defence
	name = "Reflexive Biting"
	desc = "You will reflexively bite hands that attempt to pat your head or boop your nose, this can be toggled off."
	cost = 0
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL
	has_preferences = list("biting_toggle" = list(TRAIT_PREF_TYPE_BOOLEAN, "Enabled on spawn", TRAIT_NO_VAREDIT_TARGET, TRUE))

/datum/trait/patting_defence/apply(var/datum/species/S, var/mob/living/carbon/human/H, var/list/trait_prefs)
	..()
	if(trait_prefs && trait_prefs["biting_toggle"])
		H.touch_reaction_flags |= SPECIES_TRAIT_PATTING_DEFENCE
	add_verb(H, /mob/living/proc/toggle_patting_defence)

/datum/trait/personal_space
	name = "Personal Space Bubble"
	desc = "You are adept at avoiding unwanted physical contact and dodge it with ease. You will reflexively dodge any attempt to hug, pat, boop, lick, sniff you, shake your hand, or pick you up. These can be toggled independently."
	cost = 0
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL
	has_preferences = list("bubble_toggle" = list(TRAIT_PREF_TYPE_BOOLEAN, "Dodge physical contact on spawn", TRAIT_NO_VAREDIT_TARGET, TRUE),
						"pickup_dodge_toggle" = list(TRAIT_PREF_TYPE_BOOLEAN, "Dodge pickup attempts on spawn", TRAIT_NO_VAREDIT_TARGET, TRUE))

/datum/trait/personal_space/apply(var/datum/species/S, var/mob/living/carbon/human/H, var/list/trait_prefs)
	..()
	if(trait_prefs && trait_prefs["bubble_toggle"])
		H.touch_reaction_flags |= SPECIES_TRAIT_PERSONAL_BUBBLE
	if(trait_prefs && trait_prefs["pickup_dodge_toggle"])
		H.touch_reaction_flags |= SPECIES_TRAIT_PICKUP_DODGE
	add_verb(H, /mob/living/proc/toggle_personal_space)
	add_verb(H, /mob/living/proc/toggle_pickup_dodge)

/datum/trait/skin_reagents
	name = "Skin Reagents"
	desc = "You secret some sort of reagent across your skin that can poison those who dare to lick you."
	cost = 0
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL
	multiple_choice = list(REAGENT_ID_ETHANOL, REAGENT_ID_CAPSAICIN, REAGENT_ID_SODIUMCHLORIDE, REAGENT_ID_STOXIN, REAGENT_ID_RAINBOWTOXIN, REAGENT_ID_PARALYSISTOXIN, REAGENT_ID_PAINENZYME)
	has_preferences = list("Reagent" = list(TRAIT_PREF_TYPE_LIST, "Skin Reagent", TRAIT_NO_VAREDIT_TARGET, REAGENT_ID_ETHANOL))

/datum/trait/skin_reagents/apply(var/datum/species/S, var/mob/living/carbon/human/H, var/list/trait_prefs)
	..()
	if(trait_prefs && trait_prefs["Reagent"])
		H.skin_reagent = trait_prefs["Reagent"]
