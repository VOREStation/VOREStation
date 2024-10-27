/obj/structure/window/titanium
	name = "ti-glass window"
	desc = "A titanium alloy window, combining the strength of titanium with the transparency of glass. It seems to be very strong."
	basestate = "window"
	icon_state = "window"
	color = "#A7A3A6"
	shardtype = /obj/item/material/shard/titaniumglass
	glasstype = /obj/item/stack/material/glass/titanium
	reinf = 0
	maximal_heat = T0C + 5000
	damage_per_fire_tick = 1.0
	maxhealth = 100.0
	force_threshold = 10

/obj/structure/window/titanium/full
	icon_state = "window-full"
	maxhealth = 200
	fulltile = TRUE

/obj/structure/window/plastitanium
	name = "plastanium glass window"
	desc = "A plastitanium alloy window, combining the strength of plastitanium with the transparency of glass. It seems to be very strong."
	basestate = "window"
	icon_state = "window"
	color = "#676366"
	shardtype = /obj/item/material/shard/plastitaniumglass
	glasstype = /obj/item/stack/material/glass/plastitanium
	reinf = 0
	maximal_heat = T0C + 7000
	damage_per_fire_tick = 1.0
	maxhealth = 120.0
	force_threshold = 10

/obj/structure/window/plastitanium/full
	icon_state = "window-full"
	maxhealth = 250
	fulltile = TRUE

/obj/structure/window/reinforced/tinted/full
	icon_state = "window-full"
	fulltile = TRUE
