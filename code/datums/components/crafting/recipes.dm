///If the machine is used/deleted in the crafting process
#define CRAFTING_MACHINERY_CONSUME 1
///If the machine is only "used" i.e. it checks to see if it's nearby and allows crafting, but doesn't delete it
#define CRAFTING_MACHINERY_USE 0

/datum/crafting_recipe
	var/name = "" //in-game display name
	/// type paths of items consumed associated with how many are needed
	/// Note that stacks have special handling: the logic accounts for having '23' available
	/// in the case of just having one stack of 23 amount, so stack/steel = 23 is fine
	var/list/reqs = list()
	var/list/blacklist = list() //type paths of items explicitly not allowed as an ingredient
	var/result //type path of item resulting from this craft
	/// String defines of items needed but not consumed. Lazy list.
	var/list/tool_behaviors
	/// Type paths of items needed but not consumed. Lazy list.
	var/list/tool_paths
	var/time = 30 //time in deciseconds
	var/list/parts = list() //type paths of items that will be placed in the result
	var/list/chem_catalysts = list() //like tool_behaviors but for reagents
	var/category = CAT_NONE //where it shows up in the crafting UI
	var/subcategory = CAT_NONE
	var/always_available = TRUE //Set to FALSE if it needs to be learned first.
	/// Additonal requirements text shown in UI
	var/additional_req_text
	///Required machines for the craft, set the assigned value of the typepath to CRAFTING_MACHINERY_CONSUME or CRAFTING_MACHINERY_USE. Lazy associative list: type_path key -> flag value.
	var/list/machinery
	///Should only one object exist on the same turf?
	var/one_per_turf = FALSE

/datum/crafting_recipe/New()
	if(!(result in reqs))
		blacklist += result
	if(tool_behaviors)
		tool_behaviors = string_list(tool_behaviors)
	if(tool_paths)
		tool_paths = string_list(tool_paths)

/**
 * Run custom pre-craft checks for this recipe
 *
 * user: The /mob that initiated the crafting
 * collected_requirements: A list of lists of /obj/item instances that satisfy reqs. Top level list is keyed by requirement path.
 */
/datum/crafting_recipe/proc/check_requirements(mob/user, list/collected_requirements)
	return TRUE

/datum/crafting_recipe/proc/on_craft_completion(mob/user, atom/result)
	return

// Computes the total reagents volume 
/datum/crafting_recipe/proc/get_parts_reagents_volume()
	. = 0
	for(var/list/L in parts)
		for(var/path in L)
			if(ispath(path, /datum/reagent))
				. += L[path]

// Locate one of the things that set the material type, and update it from the default (glass)
/datum/crafting_recipe/spear/on_craft_completion(mob/user, atom/result)
	var/obj/item/weapon/material/M
	for(var/path in parts)
		var/obj/item/weapon/material/N = locate(path) in result
		if(istype(N, path))
			if(!istype(M))
				M = N
			else
				N.forceMove(get_turf(result))
	if(!istype(M))
		return

	var/obj/item/weapon/material/twohanded/spear/S = result
	S.set_material(M.material.name)
	qdel(M)
<<<<<<< HEAD
=======


/datum/crafting_recipe/material_armor
	name = "Material Armor Plate"
	result = /obj/item/clothing/accessory/material/advanced
	reqs = list(
		list(/obj/item/weapon/material/armor_plating/insert = 1),
		list(/datum/reagent/toxin/plasticide = 5),
		list(/datum/reagent/glycerol = 10),
		list(/datum/reagent/silicon = 10)
	)
	parts = list(
		/obj/item/weapon/material/armor_plating/insert = 1
	)
	machinery = list(
		/obj/machinery/r_n_d/protolathe = CRAFTING_MACHINERY_USE
	)
	always_available = FALSE
	time = 80
	category = CAT_CLOTHING


/datum/crafting_recipe/material_armor/chestplate
	name = "Material armor plate"
	result = /obj/item/clothing/accessory/material/advanced
	always_available = TRUE


/datum/crafting_recipe/material_armor/legguards
	name = "Material armor arm-guards"
	result = /obj/item/clothing/accessory/material/advanced/armguards
	reqs = list(
		list(/obj/item/weapon/material/armor_plating/insert = 1),
		list(/datum/reagent/toxin/plasticide = 5),
		list(/datum/reagent/glycerol = 10),
		list(/datum/reagent/silicon = 10)
	)
	always_available = TRUE


/datum/crafting_recipe/material_armor/armguards
	name = "Material armor leg-guards"
	result = /obj/item/clothing/accessory/material/advanced/legguards
	reqs = list(
		list(/obj/item/weapon/material/armor_plating/insert = 1),
		list(/datum/reagent/toxin/plasticide = 5),
		list(/datum/reagent/glycerol = 10),
		list(/datum/reagent/silicon = 10)
	)
	always_available = TRUE


/datum/crafting_recipe/material_armor/on_craft_completion(mob/user, obj/item/clothing/result)
	var/obj/item/weapon/material/armor_plating/insert/insert = locate() in result
	var/material_name = insert?.material?.name
	if (!material_name)
		qdel(result)
		return
	result.set_material(material_name)
	qdel(insert)
>>>>>>> 09210644019... Merge pull request #8492 from Spookerton/fenodyreeav/material-armor-crafting
