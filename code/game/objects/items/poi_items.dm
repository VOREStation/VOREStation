
/obj/item/poi
	icon = 'icons/obj/objects.dmi'
	desc = "This is definitely something cool."

/obj/item/poi/pascalb
	icon_state = "pascalb"
	name = "misshapen manhole cover"
	desc = "The top of this twisted chunk of metal is faintly stamped with a five pointed star. 'Property of US Army, Pascal B - 1957'."

/obj/item/poi/pascalb/New()
	processing_objects += src
	return ..()

/obj/item/poi/pascalb/process()
	radiation_repository.radiate(src, 5)

/obj/item/poi/pascalb/Destroy()
	processing_objects -= src
	return ..()
