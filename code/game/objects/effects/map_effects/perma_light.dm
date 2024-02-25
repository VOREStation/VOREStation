// Emits light forever with magic. Useful for mood lighting in Points of Interest.
// Be sure to check how it looks ingame, and fiddle with the settings until it looks right.
/obj/effect/map_effect/perma_light
	name = "permanent light"
	icon_state = "permalight"

	light_range = 3
	light_power = 1
	light_color = "#FFFFFF"
	light_on = TRUE

/obj/effect/map_effect/perma_light/brighter
	name = "permanent light (bright)"
	icon_state = "permalight"

	light_range = 5
	light_power = 3
	light_color = "#FFFFFF"

/obj/effect/map_effect/perma_light/concentrated
	name = "permanent light (concentrated)"

	light_range = 2
	light_power = 5

/obj/effect/map_effect/perma_light/concentrated/incandescent
	name = "permanent light (concentrated incandescent)"

	light_color = LIGHT_COLOR_INCANDESCENT_TUBE

// VOREStation Addition Start
/obj/effect/map_effect/perma_light/gateway
	name = "permanent light (gateway)"
	icon_state = "permalight"

	light_range = 10
	light_power = 5
	light_color = "#b6cdff"
// VOREStation Addition End