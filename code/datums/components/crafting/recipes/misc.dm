//Craftable toilets in vorecode, 2026 oh yeah woo yeah
/datum/crafting_recipe/toilet
	name = "toilet"
	result = /obj/structure/toilet
	reqs = list(
		list(/obj/item/stack/material/steel = 5),
		list(/obj/item/reagent_containers/glass/bucket = 1)
		)
	time = 3 SECONDS
	category = CAT_MISC

/datum/crafting_recipe/toilet/on_craft_completion(mob/user, atom/result)
	result.dir = user.dir //face the toilet where you face.
