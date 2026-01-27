/datum/trait/food_pref
	name = "Food Preference - Carnivore"
	desc = "You prefer to eat meat, and gain extra nutrition for doing so!"
	cost = 0
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL
	can_take = ORGANICS
	var_changes = list("food_preference_bonus" = 5)
	excludes = list(
	/datum/trait/food_pref,
	/datum/trait/food_pref/herbivore,
	/datum/trait/food_pref/beanivore,
	/datum/trait/food_pref/omnivore,
	/datum/trait/food_pref/fungivore,
	/datum/trait/food_pref/piscivore,
	/datum/trait/food_pref/granivore,
	/datum/trait/food_pref/cocoavore,
	/datum/trait/food_pref/glycovore,
	/datum/trait/food_pref/lactovore,
	/datum/trait/food_pref/coffee,
	/datum/trait/food_pref/stimulant
	)
	var/list/our_allergens = list(ALLERGEN_MEAT)

/datum/trait/food_pref/apply(datum/species/S, mob/living/carbon/human/H, trait_prefs)
	. = ..()
	for(var/a in our_allergens)
		S.food_preference |= a

/datum/trait/food_pref/herbivore
	name = "Food Preference - Herbivore"
	desc = "You prefer to eat fruits and vegitables, and gain extra nutrition for doing so!"
	category = TRAIT_TYPE_NEUTRAL
	excludes = list(
	/datum/trait/food_pref,
	/datum/trait/food_pref/beanivore,
	/datum/trait/food_pref/omnivore,
	/datum/trait/food_pref/fungivore,
	/datum/trait/food_pref/piscivore,
	/datum/trait/food_pref/granivore,
	/datum/trait/food_pref/cocoavore,
	/datum/trait/food_pref/glycovore,
	/datum/trait/food_pref/lactovore,
	/datum/trait/food_pref/coffee,
	/datum/trait/food_pref/stimulant
	)
	our_allergens = list(ALLERGEN_VEGETABLE,ALLERGEN_FRUIT)

/datum/trait/food_pref/beanivore
	name = "Food Preference - Legumovore"
	desc = "You prefer to eat bean related foods, such as tofu, and gain extra nutrition for doing so!"
	category = TRAIT_TYPE_NEUTRAL
	excludes = list(
	/datum/trait/food_pref,
	/datum/trait/food_pref/herbivore,
	/datum/trait/food_pref/omnivore,
	/datum/trait/food_pref/fungivore,
	/datum/trait/food_pref/piscivore,
	/datum/trait/food_pref/granivore,
	/datum/trait/food_pref/cocoavore,
	/datum/trait/food_pref/glycovore,
	/datum/trait/food_pref/lactovore,
	/datum/trait/food_pref/coffee,
	/datum/trait/food_pref/stimulant
	)
	our_allergens = list(ALLERGEN_BEANS)

/datum/trait/food_pref/omnivore
	name = "Food Preference - Omnivore"
	desc = "You prefer to eat meat and vegitables, and gain extra nutrition for doing so!"
	category = TRAIT_TYPE_NEUTRAL
	excludes = list(
	/datum/trait/food_pref,
	/datum/trait/food_pref/herbivore,
	/datum/trait/food_pref/beanivore,
	/datum/trait/food_pref/fungivore,
	/datum/trait/food_pref/piscivore,
	/datum/trait/food_pref/granivore,
	/datum/trait/food_pref/cocoavore,
	/datum/trait/food_pref/glycovore,
	/datum/trait/food_pref/lactovore,
	/datum/trait/food_pref/coffee,
	/datum/trait/food_pref/stimulant
	)
	our_allergens = list(ALLERGEN_VEGETABLE,ALLERGEN_MEAT)

/datum/trait/food_pref/fungivore
	name = "Food Preference - Fungivore"
	desc = "You prefer to eat mushrooms and fungus, and gain extra nutrition for doing so!"
	category = TRAIT_TYPE_NEUTRAL
	excludes = list(
	/datum/trait/food_pref,
	/datum/trait/food_pref/herbivore,
	/datum/trait/food_pref/beanivore,
	/datum/trait/food_pref/omnivore,
	/datum/trait/food_pref/piscivore,
	/datum/trait/food_pref/granivore,
	/datum/trait/food_pref/cocoavore,
	/datum/trait/food_pref/glycovore,
	/datum/trait/food_pref/lactovore,
	/datum/trait/food_pref/coffee,
	/datum/trait/food_pref/stimulant
	)
	our_allergens = list(ALLERGEN_FUNGI)

/datum/trait/food_pref/piscivore
	name = "Food Preference - Piscivore"
	desc = "You prefer to eat fish, and gain extra nutrition for doing so!"
	category = TRAIT_TYPE_NEUTRAL
	excludes = list(
	/datum/trait/food_pref,
	/datum/trait/food_pref/herbivore,
	/datum/trait/food_pref/beanivore,
	/datum/trait/food_pref/omnivore,
	/datum/trait/food_pref/fungivore,
	/datum/trait/food_pref/granivore,
	/datum/trait/food_pref/cocoavore,
	/datum/trait/food_pref/glycovore,
	/datum/trait/food_pref/lactovore,
	/datum/trait/food_pref/coffee,
	/datum/trait/food_pref/stimulant
	)
	our_allergens = list(ALLERGEN_FISH)

/datum/trait/food_pref/granivore
	name = "Food Preference - Granivore"
	desc = "You prefer to eat grains and seeds, and gain extra nutrition for doing so!"
	category = TRAIT_TYPE_NEUTRAL
	excludes = list(
	/datum/trait/food_pref,
	/datum/trait/food_pref/herbivore,
	/datum/trait/food_pref/beanivore,
	/datum/trait/food_pref/omnivore,
	/datum/trait/food_pref/fungivore,
	/datum/trait/food_pref/piscivore,
	/datum/trait/food_pref/cocoavore,
	/datum/trait/food_pref/glycovore,
	/datum/trait/food_pref/lactovore,
	/datum/trait/food_pref/coffee,
	/datum/trait/food_pref/stimulant
	)
	our_allergens = list(ALLERGEN_GRAINS,ALLERGEN_SEEDS)

/datum/trait/food_pref/cocoavore
	name = "Food Preference - Cocoavore"
	desc = "You prefer to eat chocolate, and gain extra nutrition for doing so!"
	category = TRAIT_TYPE_NEUTRAL
	excludes = list(
	/datum/trait/food_pref,
	/datum/trait/food_pref/herbivore,
	/datum/trait/food_pref/beanivore,
	/datum/trait/food_pref/omnivore,
	/datum/trait/food_pref/fungivore,
	/datum/trait/food_pref/piscivore,
	/datum/trait/food_pref/granivore,
	/datum/trait/food_pref/glycovore,
	/datum/trait/food_pref/lactovore,
	/datum/trait/food_pref/coffee,
	/datum/trait/food_pref/stimulant
	)
	our_allergens = list(ALLERGEN_CHOCOLATE)

/datum/trait/food_pref/glycovore
	name = "Food Preference - Glycovore"
	desc = "You prefer to eat sugar, and gain extra nutrition for doing so!"
	category = TRAIT_TYPE_NEUTRAL
	excludes = list(
	/datum/trait/food_pref,
	/datum/trait/food_pref/herbivore,
	/datum/trait/food_pref/beanivore,
	/datum/trait/food_pref/omnivore,
	/datum/trait/food_pref/fungivore,
	/datum/trait/food_pref/piscivore,
	/datum/trait/food_pref/granivore,
	/datum/trait/food_pref/cocoavore,
	/datum/trait/food_pref/lactovore,
	/datum/trait/food_pref/coffee,
	/datum/trait/food_pref/stimulant
	)
	our_allergens = list(ALLERGEN_SUGARS)

/datum/trait/food_pref/lactovore
	name = "Food Preference - Lactovore"
	desc = "You prefer to eat and drink things with milk in them, and gain extra nutrition for doing so!"
	category = TRAIT_TYPE_NEUTRAL
	excludes = list(
	/datum/trait/food_pref,
	/datum/trait/food_pref/herbivore,
	/datum/trait/food_pref/beanivore,
	/datum/trait/food_pref/omnivore,
	/datum/trait/food_pref/fungivore,
	/datum/trait/food_pref/piscivore,
	/datum/trait/food_pref/granivore,
	/datum/trait/food_pref/cocoavore,
	/datum/trait/food_pref/glycovore,
	/datum/trait/food_pref/coffee,
	/datum/trait/food_pref/stimulant
	)
	our_allergens = list(ALLERGEN_DAIRY)

/datum/trait/food_pref/coffee
	name = "Food Preference - Coffee Dependant"
	desc = "You can get by on coffee alone if you have to, and you like it that way."
	category = TRAIT_TYPE_NEUTRAL
	excludes = list(
	/datum/trait/food_pref,
	/datum/trait/food_pref/herbivore,
	/datum/trait/food_pref/beanivore,
	/datum/trait/food_pref/omnivore,
	/datum/trait/food_pref/fungivore,
	/datum/trait/food_pref/piscivore,
	/datum/trait/food_pref/granivore,
	/datum/trait/food_pref/cocoavore,
	/datum/trait/food_pref/glycovore,
	/datum/trait/food_pref/lactovore,
	/datum/trait/food_pref/stimulant
	)
	our_allergens = list(ALLERGEN_COFFEE)

/datum/trait/food_pref/stimulant
	name = "Food Preference - Stimulant Dependant"
	desc = "You can get by on caffine alone if you have to, and you like it that way."
	category = TRAIT_TYPE_NEUTRAL
	excludes = list(
	/datum/trait/food_pref,
	/datum/trait/food_pref/herbivore,
	/datum/trait/food_pref/beanivore,
	/datum/trait/food_pref/omnivore,
	/datum/trait/food_pref/fungivore,
	/datum/trait/food_pref/piscivore,
	/datum/trait/food_pref/granivore,
	/datum/trait/food_pref/cocoavore,
	/datum/trait/food_pref/glycovore,
	/datum/trait/food_pref/lactovore,
	/datum/trait/food_pref/coffee
	)
	our_allergens = list(ALLERGEN_STIMULANT)
