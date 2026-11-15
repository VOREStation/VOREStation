/obj/item/disk/design_disk/rapid_construction
	name = "rapid fabricator design disk"
	desc = "A disk containing several rapid fabrication devices."

/obj/item/disk/design_disk/rapid_construction/Initialize(mapload)
	. = ..()
	blueprints += SSresearch.techweb_design_by_id(/datum/design_techweb/rcd_loaded::id)
	blueprints += SSresearch.techweb_design_by_id(/datum/design_techweb/rcd_ammo::id)
	blueprints += SSresearch.techweb_design_by_id(/datum/design_techweb/rpd::id)
	blueprints += SSresearch.techweb_design_by_id(/datum/design_techweb/rms::id)
	blueprints += SSresearch.techweb_design_by_id(/datum/design_techweb/rsf::id) // may as well
