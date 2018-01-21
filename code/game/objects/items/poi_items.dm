/obj/item/poi/pascalb
	icon = 'icons/obj/objects.dmi'
	icon_state = "pascalb"
	name = "Charred Manhole Cover"
	desc = "The top of this twisted chunk of metal is faintly stamped with a five pointed star. 'Property of US Army, Pascal B 1957'."

object/item/poi/pascalb/process()

	radiation_repository.radiate(src, 5)