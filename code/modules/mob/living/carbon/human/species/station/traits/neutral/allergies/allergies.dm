//Allergen traits! Not available to any species with a base allergens var.
/datum/trait/allergy
	name = "Allergy: Gluten"
	desc = "You're highly allergic to gluten proteins, which are found in most common grains. NB: By taking this trait, you acknowledge there is a significant risk your character may suffer a fatal reaction if exposed to this substance."
	cost = 0
	custom_only = FALSE
	var/allergen = ALLERGEN_GRAINS
	category = TRAIT_TYPE_NEUTRAL

	// Traitgenes Made ALL ALLERGYS into gene traits
	is_genetrait = TRUE
	hidden = FALSE

	activation_message="Something feels odd..."

/datum/trait/allergy/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	S.allergens |= allergen
	..()

// Traitgenes edit begin - Made ALL ALLERGYS into gene traits
/datum/trait/allergy/unapply(var/datum/species/S,var/mob/living/carbon/human/H)
	S.allergens &= ~allergen
	..()
// Traitgenes edit end

/datum/trait/allergy/meat
	name = "Allergy: Meat"
	desc = "You're highly allergic to just about any form of meat. You're probably better off just sticking to vegetables. NB: By taking this trait, you acknowledge there is a significant risk your character may suffer a fatal reaction if exposed to this substance."
	cost = 0
	custom_only = FALSE
	allergen = ALLERGEN_MEAT
	category = TRAIT_TYPE_NEUTRAL

/datum/trait/allergy/fish
	name = "Allergy: Fish"
	desc = "You're highly allergic to fish. It's probably best to avoid seafood in general. NB: By taking this trait, you acknowledge there is a significant risk your character may suffer a fatal reaction if exposed to this substance."
	cost = 0
	custom_only = FALSE
	allergen = ALLERGEN_FISH
	category = TRAIT_TYPE_NEUTRAL

/datum/trait/allergy/fruit
	name = "Allergy: Fruit"
	desc = "You're highly allergic to fruit. Vegetables are fine, but you should probably read up on how to tell the difference. Remember, tomatoes are a fruit. NB: By taking this trait, you acknowledge there is a significant risk your character may suffer a fatal reaction if exposed to this substance."
	cost = 0
	custom_only = FALSE
	allergen = ALLERGEN_FRUIT
	category = TRAIT_TYPE_NEUTRAL

/datum/trait/allergy/vegetable
	name = "Allergy: Vegetable"
	desc = "You're highly allergic to vegetables. Fruit are fine, but you should probably read up on how to tell the difference. NB: By taking this trait, you acknowledge there is a significant risk your character may suffer a fatal reaction if exposed to this substance."
	cost = 0
	custom_only = FALSE
	allergen = ALLERGEN_VEGETABLE
	category = TRAIT_TYPE_NEUTRAL

/datum/trait/allergy/nuts
	name = "Allergy: Nuts"
	desc = "You're highly allergic to hard-shell seeds, such as peanuts. NB: By taking this trait, you acknowledge there is a significant risk your character may suffer a fatal reaction if exposed to this substance."
	cost = 0
	custom_only = FALSE
	allergen = ALLERGEN_SEEDS
	category = TRAIT_TYPE_NEUTRAL

/datum/trait/allergy/soy
	name = "Allergy: Soy"
	desc = "You're highly allergic to soybeans, and some other kinds of bean. NB: By taking this trait, you acknowledge there is a significant risk your character may suffer a fatal reaction if exposed to this substance."
	cost = 0
	custom_only = FALSE
	allergen = ALLERGEN_BEANS
	category = TRAIT_TYPE_NEUTRAL

/datum/trait/allergy/dairy
	name = "Allergy: Lactose"
	desc = "You're highly allergic to lactose, and consequently, just about all forms of dairy. NB: By taking this trait, you acknowledge there is a significant risk your character may suffer a fatal reaction if exposed to this substance."
	cost = 0
	custom_only = FALSE
	allergen = ALLERGEN_DAIRY
	category = TRAIT_TYPE_NEUTRAL

/datum/trait/allergy/fungi
	name = "Allergy: Fungi"
	desc = "You're highly allergic to fungi such as mushrooms. NB: By taking this trait, you acknowledge there is a significant risk your character may suffer a fatal reaction if exposed to this substance."
	cost = 0
	custom_only = FALSE
	allergen = ALLERGEN_FUNGI
	category = TRAIT_TYPE_NEUTRAL

/datum/trait/allergy/coffee
	name = "Allergy: Coffee"
	desc = "You're highly allergic to coffee in specific. NB: By taking this trait, you acknowledge there is a significant risk your character may suffer a fatal reaction if exposed to this substance."
	cost = 0
	custom_only = FALSE
	allergen = ALLERGEN_COFFEE
	category = TRAIT_TYPE_NEUTRAL

/datum/trait/allergy/chocolate
	name = "Allergy: Chocolate"
	desc = "You're highly allergic to coco and chocolate in specific. NB: By taking this trait, you acknowledge there is a significant risk your character may suffer a fatal reaction if exposed to this substance."
	cost = 0
	custom_only = FALSE
	allergen = ALLERGEN_CHOCOLATE
	category = TRAIT_TYPE_NEUTRAL

/datum/trait/allergy/pollen
	name = "Allergy: Pollen"
	desc = "You're highly allergic to pollen and many plants. It's probably best to avoid hydroponics in general. Be sure to configure your allergic reactions, otherwise you will die touching grass. NB: By taking this trait, you acknowledge there is a significant risk your character may suffer a fatal reaction if exposed to this substance."
	cost = 0
	custom_only = FALSE
	allergen = ALLERGEN_POLLEN // Gee billy...
	added_component_path = /datum/component/pollen_disability // Why does mom let you have two things?
	category = TRAIT_TYPE_NEUTRAL

/datum/trait/allergy/salt
	name = "Allergy: Salt"
	desc = "You're highly allergic to sodium chloride aka salt. NB: By taking this trait, you acknowledge there is a significant risk your character may suffer a fatal reaction if exposed to this substance."
	cost = 0
	allergen = ALLERGEN_SALT
	category = TRAIT_TYPE_NEUTRAL
