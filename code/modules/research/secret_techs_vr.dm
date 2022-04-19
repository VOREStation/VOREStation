/*
	The secret tech system! This is to add some more gameplay to RnD beyond the basic tech speedruns and deconstructing.

	Basically, we setup origin techs on an item and also secret techs, when the item is successfully scanned in a radiocarbon spectrometer (code/modules/xenoarcheaology/tools/geosample_scanner.dm), then it will add secret techs to it's origin tech list.
*/

/obj/item
	var/list/secret_tech = null

// This is the proc for updating tech, calling it will add secret_tech into origin_tech, then set secret_tech to null so that one can't just infinitely increase an item's tech level.
/obj/item/proc/update_techs()
	for(var/I in origin_tech)
		for(var/T in secret_tech)
			if(CallTechName(T) == CallTechName(I))
				origin_tech[I] = secret_tech[T] + origin_tech[I]
				secret_tech.Remove(T)
	origin_tech += secret_tech
	secret_tech = null