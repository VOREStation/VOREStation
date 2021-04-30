/obj/item/stack/material/chitin
	name = "chitin"
	desc = "The by-product of mob grinding."
	icon_state = "chitin"
	default_type = MAT_CHITIN
	no_variants = FALSE
	pass_color = TRUE
	strict_color_stacking = TRUE
	drop_sound = 'sound/items/drop/leather.ogg'
	pickup_sound = 'sound/items/pickup/leather.ogg'

//don't see anywhere else to put these, maybe together they could be used to make the xenos suit?
/obj/item/stack/xenochitin
	name = "alien chitin"
	desc = "A piece of the hide of a terrible creature."
	singular_name = "alien chitin piece"
	icon = 'icons/mob/alien.dmi'
	icon_state = "chitin"
	stacktype = "hide-chitin"

/obj/item/xenos_claw
	name = "alien claw"
	desc = "The claw of a terrible creature."
	icon = 'icons/mob/alien.dmi'
	icon_state = "claw"

/obj/item/weed_extract
	name = "weed extract"
	desc = "A piece of slimy, purplish weed."
	icon = 'icons/mob/alien.dmi'
	icon_state = "weed_extract"