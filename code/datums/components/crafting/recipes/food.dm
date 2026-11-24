/datum/crafting_recipe/marsh_stick
	name = "marshmallow on a stick"
	result = /obj/item/marsh_stick
	reqs = list(
		list(/obj/item/stack/material/stick = 1),
		list(/obj/item/reagent_containers/food/snacks/marshmallow = 1)
	)
	time = 1 SECOND
	category = CAT_FOOD
	subcategory = CAT_MISCFOOD

/datum/crafting_recipe/smore
	name = "smores"
	result = /obj/item/reagent_containers/food/snacks/smores
	reqs = list(
		list(/obj/item/reagent_containers/food/snacks/graham = 2),
		list(/obj/item/reagent_containers/food/snacks/chocolatebar = 1),
		list(/obj/item/reagent_containers/food/snacks/marshmallow = 1)
	)
	category = CAT_FOOD
	subcategory = CAT_SANDWICH
