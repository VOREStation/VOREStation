/obj/effect/floor_decal/corner/holiday
	name = "white corner"
	icon_state = "corner_white"
	var/pattern = PATTERN_DEFAULT

/obj/effect/floor_decal/corner/holiday/Initialize(mapload, newdir, newcolour)
	var/custom_color = request_decoration_colors(src, pattern)
	if(custom_color)
		color = custom_color
	. = ..()

/obj/effect/floor_decal/corner/holiday/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/floor_decal/corner/holiday/full
	icon_state = "corner_white_full"

/obj/effect/floor_decal/corner/holiday/three_quarters
	icon_state = "corner_white_three_quarters"

/obj/effect/floor_decal/corner/holiday/border
	icon_state = "bordercolor"

/obj/effect/floor_decal/corner/holiday/bordercorner
	icon_state = "bordercolorcorner"

/obj/effect/floor_decal/corner/holiday/bordercorner2
	icon_state = "bordercolorcorner2"

/obj/effect/floor_decal/corner/holiday/borderfull
	icon_state = "bordercolorfull"

/obj/effect/floor_decal/corner/holiday/bordercee
	icon_state = "bordercolorcee"
