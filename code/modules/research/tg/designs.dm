/***************************************************************
** Design Datums   **
** All the data for building stuff.   **
***************************************************************/
/*
For the materials datum, it assumes you need reagents unless specified otherwise. To designate a material that isn't a reagent,
you use one of the material IDs below. These are NOT ids in the usual sense (they aren't defined in the object or part of a datum),
they are simply references used as part of a "has materials?" type proc. They all start with a $ to denote that they aren't reagents.
The currently supporting non-reagent materials. All material amounts are set as the define SHEET_MATERIAL_AMOUNT, which defaults to 100

Don't add new keyword/IDs if they are made from an existing one (such as rods which are made from iron). Only add raw materials.

Design Guidelines
- When adding new designs, check rdreadme.dm to see what kind of things have already been made and where new stuff is needed.
- A single sheet of anything is 100 units of material. Materials besides iron/glass require help from other jobs (mining for
other types of metals and chemistry for reagents).
- Add the AUTOLATHE tag to
*/

//DESIGNS ARE GLOBAL. DO NOT CREATE OR DESTROY THEM AT RUNTIME OUTSIDE OF INIT, JUST REFERENCE THEM TO WHATEVER YOU'RE DOING! //why are you yelling?
//DO NOT REFERENCE OUTSIDE OF SSRESEARCH. USE THE PROCS IN SSRESEARCH TO OBTAIN A REFERENCE.

/datum/design_techweb //Datum for object designs, used in construction
	/// Name of the created object
	var/name = "Name"
	/// Description of the created object
	var/desc = null
	/// The ID of the design. Used for quick reference. Alphanumeric, lower-case, no symbols
	var/id = DESIGN_ID_IGNORE
	/// Bitflags indicating what machines this design is compatable with. ([IMPRINTER]|[AWAY_IMPRINTER]|[PROTOLATHE]|[AWAY_LATHE]|[AUTOLATHE]|[MECHFAB]|[BIOGENERATOR]|[LIMBGROWER]|[SMELTER])
	var/build_type = null
	/// List of materials required to create one unit of the product. Format is (typepath or caregory) -> amount
	var/list/materials = list()
	/// The amount of time required to create one unit of the product.
	var/construction_time = 3.2 SECONDS
	/// The typepath of the object produced by this design
	var/build_path = null
	/// Reagent produced by this design. Currently only supported by the biogenerator.
	var/make_reagent
	/// What categories this design falls under. Used for sorting in production machines.
	var/list/category = list()
	/// List of reagents required to create one unit of the product. Currently only supported by the limb grower.
	var/list/reagents_list = list()
	/// How many times faster than normal is this to build on the protolathe
	var/lathe_time_factor = 1
	/// Bitflags indicating what departmental lathes should be allowed to process this design.
	var/departmental_flags = ALL
	/// What techwebs nodes unlock this design. Constructed by SSresearch
	var/list/datum/techweb_node/unlocked_by = list()
	/// Override for the automatic icon generation used for the research console.
	var/research_icon
	/// Override for the automatic icon state generation used for the research console.
	var/research_icon_state
	/// Appears to be unused.
	var/icon_cache
	/// Optional string that interfaces can use as part of search filters. See- item/borg/upgrade/ai and the Exosuit Fabs.
	var/search_metadata
	/// For protolathe designs that don't require reagents: If they can be exported to autolathes with a design disk or not.
	var/autolathe_exportable = TRUE

/datum/design_techweb/error_design
	name = "ERROR"
	desc = "This usually means something in the database has corrupted. If this doesn't go away automatically, inform Central Command so their techs can fix this ASAP(tm)"

/datum/design_techweb/Destroy()
	SSresearch.techweb_designs -= id
	return ..()

/datum/design_techweb/proc/InitializeMaterials()
	var/list/temp_list = list()
	for(var/i in materials) //Go through all of our materials, get the subsystem instance, and then replace the list.
		var/amount = materials[i]
		if(!istext(i)) //Not a category, so get the ref the normal way
			var/datum/material/M = GET_MATERIAL_REF(i)
			temp_list[M] = amount
		else
			temp_list[i] = amount
	materials = temp_list

/datum/design_techweb/proc/icon_html(client/user)
	var/datum/asset/spritesheet_batched/sheet = get_asset_datum(/datum/asset/spritesheet_batched/research_designs)
	sheet.send(user)
	return sheet.icon_tag(id)

/// Returns the description of the design
/datum/design_techweb/proc/get_description()
	var/obj/object_build_item_path = build_path

	return isnull(desc) ? initial(object_build_item_path.desc) : desc

/datum/design_techweb/proc/create_item(target)
	return new build_path(target)
