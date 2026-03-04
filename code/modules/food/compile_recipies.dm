///Builds the global list for kitchen recipies. Sorted by appliance type.
/proc/build_kitchen_recipes()
	var/alist/recipes = alist()
	for(var/datum/recipe/typepath as anything in subtypesof(/datum/recipe))
		var/datum/recipe/new_recipe = new typepath
		LAZYADDASSOC(recipes, new_recipe.appliance, new_recipe)
	return recipes

///Builds the list for acceptable reagents and items.
/proc/build_kitchen_items()
	var/list/acceptable_items = list()
	for(var/list/list_to_check as anything in GLOB.available_recipes)
		for(var/datum/recipe/recipe as anything in list_to_check)
			for(var/item in recipe.items)
				acceptable_items |= item
	acceptable_items |= /obj/item/holder
	acceptable_items |= /obj/item/reagent_containers/food/snacks/grown
	acceptable_items |= /obj/item/soulstone
	acceptable_items |= /obj/item/fuel_assembly/supermatter
	return acceptable_items

///Builds the list for acceptable reagents and items.
/proc/build_kitchen_reagents()
	var/list/acceptable_reagents = list()
	for(var/list/list_to_check as anything in GLOB.available_recipes)
		for(var/datum/recipe/recipe as anything in list_to_check)
			for(var/reagent in recipe.reagents)
				acceptable_reagents |= reagent
	return acceptable_reagents
