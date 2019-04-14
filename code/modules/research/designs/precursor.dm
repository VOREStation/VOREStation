/*
 * Contains Precursor and Anomalous designs for the Protolathe.
 */

/datum/design/item/precursor/AssembleDesignName()
	..()
	name = "Alien prototype ([item_name])"

/datum/design/item/precursor/AssembleDesignDesc()
	if(!desc)
		if(build_path)
			var/obj/item/I = build_path
			desc = initial(I.desc)
		..()

/datum/design/item/anomaly/AssembleDesignName()
	..()
	name = "Anomalous prototype ([item_name])"

/datum/design/item/anomaly/AssembleDesignDesc()
	if(!desc)
		if(build_path)
			var/obj/item/I = build_path
			desc = initial(I.desc)
		..()