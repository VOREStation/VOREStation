/*
Xenobiological product lives here as a basic type.
*/
/obj/item/xenoproduct
	name = "Xenobiological product"
	desc = "How did this get here?."
	icon = 'icons/mob/slime2.dmi'
	icon_state = "slime extract"
	var/datum/xeno/traits/traits
	var/source = "Unknown"
	var/product = "mess"
	var/nameVar = "blah"

/obj/item/xenoproduct/Destroy()
	QDEL_NULL(traits)
	. = ..()
