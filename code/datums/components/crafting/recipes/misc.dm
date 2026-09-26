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

/datum/crafting_recipe/spring_trap
	name = "spring trap"
	result = /obj/item/spring_trap_kit
	reqs = list(
		list(/obj/item/stack/material/steel = 8),
		list(/obj/item/stack/rods = 2)
	)
	tool_behaviors = list(
		TOOL_SCREWDRIVER,
		TOOL_WELDER,
		TOOL_CROWBAR
	)
	time = 5 SECONDS
	category = CAT_MISC

/datum/crafting_recipe/spring_trap_self_resetting
	name = "self-resetting spring trap"
	result = /obj/item/spring_trap_kit/resetting
	reqs = list(
		list(/obj/item/stack/material/steel = 8),
		list(/obj/item/stack/rods = 2),
		list(/obj/item/stock_parts/motor = 1),
		list(/obj/item/stack/cable_coil = 2)
	)
	tool_behaviors = list(
		TOOL_SCREWDRIVER,
		TOOL_WELDER,
		TOOL_CROWBAR
	)
	time = 5 SECONDS
	category = CAT_MISC
