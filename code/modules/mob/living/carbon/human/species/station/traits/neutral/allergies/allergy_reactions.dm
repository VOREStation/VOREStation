/datum/trait/allergy_reaction
	name = "Allergy Reaction: Disable Toxicity"
	desc = "Take this trait to disable the toxic damage effect of being exposed to one of your allergens. Combine with the Disable Suffocation trait to have purely nonlethal reactions."
	cost = 0
	custom_only = FALSE
	var/reaction = AG_TOX_DMG
	category = TRAIT_TYPE_NEUTRAL

/datum/trait/allergy_reaction/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	S.allergen_reaction ^= reaction
	..()

/datum/trait/allergy_reaction/oxy
	name = "Allergy Reaction: Disable Suffocation"
	desc = "Take this trait to disable the oxygen deprivation damage effect of being exposed to one of your allergens. Combine with the Disable Toxicity trait to have purely nonlethal reactions."
	cost = 0
	custom_only = FALSE
	reaction = AG_OXY_DMG
	category = TRAIT_TYPE_NEUTRAL

/datum/trait/allergy_reaction/brute
	name = "Allergy Reaction: Spontaneous Trauma"
	desc = "When exposed to one of your allergens, your skin develops unnatural bruises and other 'stigmata'-like injuries. Be aware that untreated wounds may become infected."
	cost = 0
	custom_only = FALSE
	reaction = AG_PHYS_DMG
	category = TRAIT_TYPE_NEUTRAL

/datum/trait/allergy_reaction/burn
	name = "Allergy Reaction: Blistering"
	desc = "When exposed to one of your allergens, your skin develops unnatural blisters and burns, as if exposed to fire. Be aware that untreated burns are very susceptible to infection!"
	cost = 0
	custom_only = FALSE
	reaction = AG_BURN_DMG
	category = TRAIT_TYPE_NEUTRAL

/datum/trait/allergy_reaction/pain
	name = "Allergy Reaction: Disable Pain"
	desc = "Take this trait to disable experiencing pain after being exposed to one of your allergens."
	cost = 0
	custom_only = FALSE
	reaction = AG_PAIN
	category = TRAIT_TYPE_NEUTRAL

/datum/trait/allergy_reaction/weaken
	name = "Allergy Reaction: Knockdown"
	desc = "When exposed to one of your allergens, you will experience sudden and abrupt loss of muscle control and tension, resulting in immediate collapse and immobility. Does nothing if you have no allergens."
	cost = 0
	custom_only = FALSE
	reaction = AG_WEAKEN
	category = TRAIT_TYPE_NEUTRAL

/datum/trait/allergy_reaction/blurry
	name = "Allergy Reaction: Disable Blurring"
	desc = "Take this trait to disable the blurred/impeded vision effect of allergens."
	cost = 0
	custom_only = FALSE
	reaction = AG_BLURRY
	category = TRAIT_TYPE_NEUTRAL

/datum/trait/allergy_reaction/sleepy
	name = "Allergy Reaction: Fatigue"
	desc = "When exposed to one of your allergens, you will experience fatigue and tiredness, and may potentially pass out entirely. Does nothing if you have no allergens."
	cost = 0
	custom_only = FALSE
	reaction = AG_SLEEPY
	category = TRAIT_TYPE_NEUTRAL

/datum/trait/allergy_reaction/confusion
	name = "Allergy Reaction: Disable Confusion"
	desc = "Take this trait to disable the confusion/disorientation effect of allergens."
	cost = 0
	custom_only = FALSE
	reaction = AG_CONFUSE
	category = TRAIT_TYPE_NEUTRAL

/datum/trait/allergy_reaction/gibbing
	name = "Allergy Reaction: Gibbing"
	desc = "When exposed to one of your allergens, you will explode, god help you. Does nothing if you have no allergens."
	cost = 0
	custom_only = FALSE
	reaction = AG_GIBBING
	hidden = TRUE // Disabled on virgo for obvious reasons
	category = TRAIT_TYPE_NEUTRAL

/datum/trait/allergy_reaction/sneeze
	name = "Allergy Reaction: Sneezing"
	desc = "When exposed to one of your allergens, you will begin sneezing harmlessly. Does nothing if you have no allergens."
	cost = 0
	custom_only = FALSE
	reaction = AG_SNEEZE
	category = TRAIT_TYPE_NEUTRAL

/datum/trait/allergy_reaction/cough
	name = "Allergy Reaction: Coughing"
	desc = "When exposed to one of your allergens, you will begin coughing, potentially dropping items. Does nothing if you have no allergens."
	cost = 0
	custom_only = FALSE
	reaction = AG_COUGH
	category = TRAIT_TYPE_NEUTRAL
