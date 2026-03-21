// Design disk containing all ammunitions
/obj/item/disk/design_disk/security
	name = "security armory design disk"
	desc = "A disk containing many, many, many bullets."

/obj/item/disk/design_disk/security/Initialize(mapload)
	. = ..()

	// Lets get all security nodes and put them on a disk.
	// This way if bullets are disabled by default we can get a disk mapped instead.
	var/list/process_nodes = list(
		/datum/techweb_node/pistol_ammo::id,
		/datum/techweb_node/pistol_special::id,
		/datum/techweb_node/rifle_ammo::id,
		/datum/techweb_node/rifle_ammo_special::id,
		/datum/techweb_node/shotgun_ammo::id,
		/datum/techweb_node/speedloaders::id
	)
	for(var/node_id in process_nodes)
		var/datum/techweb_node/node = SSresearch.techweb_node_by_id(node_id)
		for(var/id in node.design_ids)
			var/datum/design_techweb/design = SSresearch.techweb_design_by_id(id)
			blueprints += design
