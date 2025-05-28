var/global/datum/repository/ammomaterial/ammo_repository = new()

/datum/repository/ammomaterial
	var/list/ammotypes

/datum/repository/ammomaterial/New()
	ammotypes = list()
	..()

/datum/repository/ammomaterial/proc/get_materials_from_object(obj/item/ammo_casing/I)

	if(!(I in ammotypes))
		ammotypes += I
		var/obj/item/ammo_casing/temp = new I
		ammotypes[I] = temp.matter
		qdel(temp)

	return ammotypes[I]
