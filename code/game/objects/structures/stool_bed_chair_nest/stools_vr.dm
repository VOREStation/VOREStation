/obj/item/stool/baystool
	name = "bar stool"
	desc = "Apply butt."
	icon = 'icons/obj/furniture_vr.dmi' //VOREStation Edit - new Icons
	icon_state = "bar_stool_preview" //set for the map
	randpixel = 0
	center_of_mass_x = 0
	center_of_mass_y = 0
	force = 10
	throwforce = 10
	w_class = ITEMSIZE_HUGE
	base_icon = "bar_stool_base"
	anchored = TRUE

/obj/item/stool/baystool/padded
	icon_state = "bar_stool_padded_preview" //set for the map

/obj/item/stool/baystool/padded/New(var/newloc, var/new_material)
	..(newloc, MAT_STEEL, MAT_CARPET)
