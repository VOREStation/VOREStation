/obj/item/weapon/stool/baystool
	name = "bar stool"
	desc = "Apply butt."
	icon = 'icons/obj/furniture_vr.dmi' //VOREStation Edit - new Icons
	icon_state = "bar_stool_preview" //set for the map
	randpixel = 0
	center_of_mass = null
	force = 10
	throwforce = 10
	w_class = ITEMSIZE_HUGE
	base_icon = "bar_stool_base"
	anchored = 1

/obj/item/weapon/stool/baystool/padded/New(var/newloc, var/new_material)
	..(newloc, "steel", "carpet")
