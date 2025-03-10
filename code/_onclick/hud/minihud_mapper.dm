// Specific types
/datum/mini_hud/mapper
	var/obj/item/mapping_unit/owner

/datum/mini_hud/mapper/New(var/datum/hud/other, owner)
	src.owner = owner
	screenobjs = list(new /obj/screen/movable/mapper_holder(null, owner))
	..()

/datum/mini_hud/mapper/Destroy()
	owner?.hud_item = null
	owner?.hud_datum = null
	return ..()
