/obj/item/disk/tech_disk
	name = "technology disk"
	desc = "A disk for storing technology data for further research."
	icon = 'icons/obj/discs_vr.dmi' //VOREStation Edit
	icon_state = "data-blue" //VOREStation Edit
	item_state = "card-id"
	randpixel = 5
	w_class = ITEMSIZE_SMALL
	matter = list(MAT_STEEL = 30, MAT_GLASS = 10)
	var/datum/techweb/stored_research

/obj/item/disk/tech_disk/Initialize(mapload)
	. = ..()
	if(!stored_research)
		stored_research = new /datum/techweb/disk
	randpixel_xy()

/obj/item/disk/tech_disk/debug
	name = "\improper CentCom technology disk"
	desc = "A debug item for research"

/obj/item/disk/tech_disk/debug/Initialize(mapload)
	stored_research = locate(/datum/techweb/admin) in SSresearch.techwebs
	return ..()

/obj/item/disk/design_disk
	name = "component design disk"
	desc = "A disk for storing device design data for construction in lathes."
	icon = 'icons/obj/discs_vr.dmi' //VOREStation Edit
	icon_state = "data-purple" //VOREStation Edit
	item_state = "card-id"
	randpixel = 5
	w_class = ITEMSIZE_SMALL
	matter = list(MAT_STEEL = 30, MAT_GLASS = 10)

	///List of all `/datum/design` stored on the disk.
	var/list/blueprints = list()

/obj/item/disk/design_disk/Initialize(mapload)
	. = ..()
	randpixel_xy()

/**
 * Used for special interactions with a techweb when uploading the designs.
 * Args:
 * - stored_research - The techweb that's storing us.
 */
/obj/item/disk/design_disk/proc/on_upload(datum/techweb/stored_research, atom/research_source)
	return
