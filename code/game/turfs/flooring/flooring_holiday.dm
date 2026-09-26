/obj/effect/floor_decal/corner/holiday
	name = "white corner"
	icon_state = "corner_white"
	var/pattern = PATTERN_DEFAULT

/obj/effect/floor_decal/corner/holiday/vertical
	name = "white corner"
	icon_state = "corner_white"
	pattern = PATTERN_VERTICAL_STRIPE

/obj/effect/floor_decal/corner/holiday/Initialize(mapload, newdir, newcolour)
	var/custom_color = request_decoration_colors(src, pattern)
	if(custom_color)
		color = custom_color
	. = ..()

/obj/effect/floor_decal/corner/holiday/diagonal
	icon_state = "corner_white_diagonal"

/obj/effect/floor_decal/corner/holiday/diagonal/vertical
	icon_state = "corner_white_diagonal"
	pattern = PATTERN_VERTICAL_STRIPE

/obj/effect/floor_decal/corner/holiday/full
	icon_state = "corner_white_full"

/obj/effect/floor_decal/corner/holiday/full
	icon_state = "corner_white_full"
	pattern = PATTERN_VERTICAL_STRIPE

/obj/effect/floor_decal/corner/holiday/three_quarters
	icon_state = "corner_white_three_quarters"

/obj/effect/floor_decal/corner/holiday/three_quarters
	icon_state = "corner_white_three_quarters"
	pattern = PATTERN_VERTICAL_STRIPE

/obj/effect/floor_decal/corner/holiday/border
	icon_state = "bordercolor"

/obj/effect/floor_decal/corner/holiday/border/vertical
	icon_state = "bordercolor"
	pattern = PATTERN_VERTICAL_STRIPE

/obj/effect/floor_decal/corner/holiday/bordercorner
	icon_state = "bordercolorcorner"

/obj/effect/floor_decal/corner/holiday/bordercorner/vertical
	icon_state = "bordercolorcorner"
	pattern = PATTERN_VERTICAL_STRIPE

/obj/effect/floor_decal/corner/holiday/bordercorner2
	icon_state = "bordercolorcorner2"

/obj/effect/floor_decal/corner/holiday/bordercorner2/vertical
	icon_state = "bordercolorcorner2"
	pattern = PATTERN_VERTICAL_STRIPE

/obj/effect/floor_decal/corner/holiday/borderfull
	icon_state = "bordercolorfull"

/obj/effect/floor_decal/corner/holiday/borderfull/vertical
	icon_state = "bordercolorfull"
	pattern = PATTERN_VERTICAL_STRIPE

/obj/effect/floor_decal/corner/holiday/bordercee
	icon_state = "bordercolorcee"

/obj/effect/floor_decal/corner/holiday/bordercee/vertical
	icon_state = "bordercolorcee"
	pattern = PATTERN_VERTICAL_STRIPE
