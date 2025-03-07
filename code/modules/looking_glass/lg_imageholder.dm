#define LG_IMAGE_SIZE 736

/obj/effect/landmark/looking_glass
	var/image/holding

	var/list/viewers

	var/lg_id //Area sets this for you

	mouse_opacity = 0

/obj/effect/landmark/looking_glass/Initialize(mapload)
	. = ..()
	viewers = list()

/obj/effect/landmark/looking_glass/proc/gain_viewer(var/client/C)
	if(C in viewers)
		testing("Looking Glass [x],[y],[z] tried to add a duplicate viewer.")
	viewers |= C
	if(holding)
		show_to(C)

/obj/effect/landmark/looking_glass/proc/lose_viewer(var/client/C)
	if(!(C in viewers))
		testing("Looking Glass [x],[y],[z] tried to remove a viewer it didn't have")
	viewers -= C
	if(holding)
		unshow_to(C)

/obj/effect/landmark/looking_glass/proc/show_to(var/client/C)
	C.images |= holding

/obj/effect/landmark/looking_glass/proc/unshow_to(var/client/C)
	C.images -= holding

/obj/effect/landmark/looking_glass/proc/take_image(var/image/newimage)
	if(!istype(newimage))
		return

	if(holding)
		for(var/client in viewers)
			unshow_to(client)

	holding = newimage
	newimage.plane = PLANE_LOOKINGGLASS_IMG
	newimage.blend_mode = BLEND_MULTIPLY
	newimage.appearance_flags = RESET_TRANSFORM
	newimage.mouse_opacity = 0
	newimage.pixel_y = newimage.pixel_x = (LG_IMAGE_SIZE/-2) + 16
	newimage.loc = src

	for(var/client in viewers)
		show_to(client)

/obj/effect/landmark/looking_glass/proc/drop_image()
	if(!holding)
		return

	for(var/client in viewers)
		unshow_to(client)

	holding.loc = null
	holding = null


#undef LG_IMAGE_SIZE
