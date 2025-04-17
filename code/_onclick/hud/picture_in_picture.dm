/obj/screen/movable/pic_in_pic
	name = "Picture-in-picture"
	screen_loc = "CENTER"
	plane = PLANE_WORLD
	var/atom/center
	var/width = 0
	var/height = 0
	var/list/shown_to = list()
	var/list/viewing_turfs = list()
	var/obj/screen/component_button/button_x
	var/obj/screen/component_button/button_expand
	var/obj/screen/component_button/button_shrink

	var/list/background_mas = list()
	var/const/max_dimensions = 10

/obj/screen/movable/pic_in_pic/Initialize(mapload)
	. = ..()
	make_backgrounds()

/obj/screen/movable/pic_in_pic/Destroy()
	for(var/C in shown_to)
		unshow_to(C)
	QDEL_NULL(button_x)
	QDEL_NULL(button_shrink)
	QDEL_NULL(button_expand)
	return ..()

/obj/screen/movable/pic_in_pic/component_click(obj/screen/component_button/component, params)
	if(component == button_x)
		qdel(src)
	else if(component == button_expand)
		set_view_size(width+1, height+1)
	else if(component == button_shrink)
		set_view_size(width-1, height-1)

/obj/screen/movable/pic_in_pic/proc/make_backgrounds()
	var/mutable_appearance/base = new /mutable_appearance()
	base.icon = 'icons/misc/pic_in_pic.dmi'
	base.layer = DISPOSAL_LAYER
	base.plane = PLATING_PLANE
	base.appearance_flags = PIXEL_SCALE

	for(var/direction in GLOB.cardinal)
		var/mutable_appearance/dir = new /mutable_appearance(base)
		dir.dir = direction
		dir.icon_state = "background_[direction]"
		background_mas += dir

/obj/screen/movable/pic_in_pic/proc/add_buttons()
	var/static/mutable_appearance/move_tab
	if(!move_tab)
		move_tab = new /mutable_appearance()
		//all these properties are always the same, and since adding something to the overlay
		//list makes a copy, there is no reason to make a new one each call
		move_tab.icon = 'icons/misc/pic_in_pic.dmi'
		move_tab.icon_state = "move"
		move_tab.plane = PLANE_PLAYER_HUD
	var/matrix/M = matrix()
	M.Translate(0, (height + 0.25) * world.icon_size)
	move_tab.transform = M
	overlays += move_tab

	if(!button_x)
		button_x = new /obj/screen/component_button(null, src)
		var/mutable_appearance/MA = new /mutable_appearance()
		MA.name = "close"
		MA.icon = 'icons/misc/pic_in_pic.dmi'
		MA.icon_state = "x"
		MA.plane = PLANE_PLAYER_HUD
		button_x.appearance = MA
	M = matrix()
	M.Translate((max(4, width) - 0.75) * world.icon_size, (height + 0.25) * world.icon_size)
	button_x.transform = M
	vis_contents += button_x

	if(!button_expand)
		button_expand = new /obj/screen/component_button(null, src)
		var/mutable_appearance/MA = new /mutable_appearance()
		MA.name = "expand"
		MA.icon = 'icons/misc/pic_in_pic.dmi'
		MA.icon_state = "expand"
		MA.plane = PLANE_PLAYER_HUD
		button_expand.appearance = MA
	M = matrix()
	M.Translate(world.icon_size, (height + 0.25) * world.icon_size)
	button_expand.transform = M
	vis_contents += button_expand

	if(!button_shrink)
		button_shrink = new /obj/screen/component_button(null, src)
		var/mutable_appearance/MA = new /mutable_appearance()
		MA.name = "shrink"
		MA.icon = 'icons/misc/pic_in_pic.dmi'
		MA.icon_state = "shrink"
		MA.plane = PLANE_PLAYER_HUD
		button_shrink.appearance = MA
	M = matrix()
	M.Translate(2 * world.icon_size, (height + 0.25) * world.icon_size)
	button_shrink.transform = M
	vis_contents += button_shrink

/obj/screen/movable/pic_in_pic/proc/add_background()
	if((width > 0) && (height > 0))
		for(var/mutable_appearance/dir in background_mas)
			var/matrix/M = matrix()
			var/x_scale = 1
			var/y_scale = 1

			var/x_off = 0
			var/y_off = 0

			if(dir.dir & (NORTH|SOUTH))
				x_scale = width
				x_off = (width-1)/2 * world.icon_size
				if(dir.dir & NORTH)
					y_off = ((height-1) * world.icon_size) + 3
				else
					y_off = -3

			if(dir.dir & (EAST|WEST))
				y_scale = height
				y_off = (height-1)/2 * world.icon_size
				if(dir.dir & EAST)
					x_off = ((width-1) * world.icon_size) + 3
				else
					x_off = -3

			M.Scale(x_scale, y_scale)
			M.Translate(x_off, y_off)
			dir.transform = M
			overlays += dir

/obj/screen/movable/pic_in_pic/proc/set_view_size(width, height, do_refresh = TRUE)
	width = CLAMP(width, 0, max_dimensions)
	height = CLAMP(height, 0, max_dimensions)
	src.width = width
	src.height = height

	y_off = -height * world.icon_size - 16

	cut_overlays()
	add_background()
	add_buttons()
	if(do_refresh)
		refresh_view()

/obj/screen/movable/pic_in_pic/proc/set_view_center(atom/target, do_refresh = TRUE)
	center = target
	if(do_refresh)
		refresh_view()

/obj/screen/movable/pic_in_pic/proc/refresh_view()
	vis_contents -= viewing_turfs
	if(!width || !height)
		return
	var/turf/T = get_turf(center)
	if(!T)
		return
	var/turf/lowerleft = locate(max(1, T.x - round(width/2)), max(1, T.y - round(height/2)), T.z)
	var/turf/upperright = locate(min(world.maxx, lowerleft.x + width - 1), min(world.maxy, lowerleft.y + height - 1), lowerleft.z)
	viewing_turfs = block(lowerleft, upperright)
	vis_contents += viewing_turfs


/obj/screen/movable/pic_in_pic/proc/show_to(client/C)
	if(C)
		shown_to[C] = 1
		C.screen += src

/obj/screen/movable/pic_in_pic/proc/unshow_to(client/C)
	if(C)
		shown_to -= C
		C.screen -= src
