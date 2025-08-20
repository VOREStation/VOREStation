//base so we can share code for quirks/disabling/damage/etc
/obj/item/endoware/flag
	var/flag_to_add = 0

/obj/item/endoware/flag/Initialize(mapload)
	endoware_flags = flag_to_add //TODO
	. = ..()
