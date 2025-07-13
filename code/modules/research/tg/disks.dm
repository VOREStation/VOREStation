/obj/item/disk/tech_disk
	name = "technology disk"
	desc = "A disk for storing technology data for further research."
	icon = 'icons/obj/discs_vr.dmi' //VOREStation Edit
	icon_state = "data-blue" //VOREStation Edit
	item_state = "card-id"
	randpixel = 5
	w_class = ITEMSIZE_SMALL
	matter = list(MAT_STEEL = 30, MAT_GLASS = 10)

/obj/item/disk/tech_disk/Initialize(mapload)
	. = ..()
	randpixel_xy()

/obj/item/disk/design_disk
	name = "component design disk"
	desc = "A disk for storing device design data for construction in lathes."
	icon = 'icons/obj/discs_vr.dmi' //VOREStation Edit
	icon_state = "data-purple" //VOREStation Edit
	item_state = "card-id"
	randpixel = 5
	w_class = ITEMSIZE_SMALL
	matter = list(MAT_STEEL = 30, MAT_GLASS = 10)

/obj/item/disk/design_disk/Initialize(mapload)
	. = ..()
	randpixel_xy()
