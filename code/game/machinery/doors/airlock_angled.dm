#define FILL_NONE 0
#define FILL_METAL 1
#define FILL_GLASS 2
#define FILL_COLOR 3

/obj/machinery/door/airlock/angled
	icon_state = "preview"
	dir = 2

	var/fill_type = FILL_NONE

	var/static/list/angled_airlock_icon_cache = list()
	var/base_icon

	var/metal_fill_icon
	var/glass_fill_icon
	var/color_fill_icon
	var/stripe_icon
	var/stripe_fill_icon
	var/door_color_icon

	var/lights_deny_icon
	var/lights_green_icon
	var/lights_bolts_icon
	var/lights_emag_icon

	var/panel_icon
	var/welded_icon
	var/spark_damaged_icon
	var/spark_broken_icon

	var/fill_color
	var/stripe_color
	var/door_color

/obj/machinery/door/airlock/angled/Initialize()
	obtain_icon()
	. = ..()

/obj/machinery/door/airlock/angled/proc/obtain_icon()
	var/icon/fill_icon
	switch(fill_type)
		if(FILL_METAL)
			fill_icon = metal_fill_icon
			glass = FALSE
			opacity = TRUE
		if(FILL_GLASS)
			fill_icon = glass_fill_icon
			glass = TRUE
			opacity = FALSE
		if(FILL_COLOR)
			fill_icon = color_fill_icon
			glass = FALSE
			opacity = TRUE

	// don't care about lights since those will be the same for every base, and panel and welded
	var/cache_key = "[base_icon]:[fill_type]:[stripe_color]:[door_color]:[fill_color]"

	var/icon/mine = angled_airlock_icon_cache[cache_key]
	if(mine)
		icon = mine
		update_icon()
		return // hooray
	
	// Base layer - the bare metal
	var/icon/door_closed = icon(base_icon, "closed")
	var/icon/door_open = icon(base_icon, "open")
	var/icon/door_locked = icon(base_icon, "closed")
	var/icon/door_deny = icon(base_icon, "deny")
	var/icon/door_spark = icon(base_icon, "closed")
	var/icon/door_opening = icon(base_icon, "opening")
	var/icon/door_closing = icon(base_icon, "closing")
	var/icon/o_door_opening = icon(base_icon, "opening")
	var/icon/o_door_closing = icon(base_icon, "closing")
	var/icon/door_opening_stat = icon(base_icon, "opening")
	var/icon/door_closing_stat = icon(base_icon, "closing")
	
	var/icon/panel_open = icon(panel_icon, "closed")
	var/icon/welded = icon(welded_icon, "closed")
	
	var/icon/sparks_damaged = icon(spark_damaged_icon, "closed")
	var/icon/sparks_open = icon(spark_damaged_icon, "open")
	var/icon/sparks_broken = icon(spark_broken_icon, "closed")

	// The filler for the gaps in the door, metal or glass or other
	if(fill_icon)
		fill_icon = icon(fill_icon) // Yeah, kinda weird huh
		if(fill_color)
			fill_icon.Blend(fill_color, ICON_MULTIPLY)
		door_closed.Blend(icon(fill_icon, "closed"), ICON_OVERLAY)
		door_locked.Blend(icon(fill_icon, "closed"), ICON_OVERLAY)
		door_spark.Blend(icon(fill_icon, "closed"), ICON_OVERLAY)
		door_deny.Blend(icon(fill_icon, "deny"), ICON_OVERLAY)
		door_open.Blend(icon(fill_icon, "open"), ICON_OVERLAY)
		door_opening.Blend(icon(fill_icon, "opening"), ICON_OVERLAY)
		door_closing.Blend(icon(fill_icon, "closing"), ICON_OVERLAY)
		o_door_opening.Blend(icon(fill_icon, "opening"), ICON_OVERLAY)
		o_door_closing.Blend(icon(fill_icon, "closing"), ICON_OVERLAY)
		door_opening_stat.Blend(icon(fill_icon, "opening"), ICON_OVERLAY)
		door_closing_stat.Blend(icon(fill_icon, "closing"), ICON_OVERLAY)

	// Paint on the door
	if(door_color_icon && door_color)
		var/icon/dci = icon(door_color_icon)
		dci.Blend(door_color, ICON_MULTIPLY)
		door_closed.Blend(icon(dci, "closed"), ICON_OVERLAY)
		door_locked.Blend(icon(dci, "closed"), ICON_OVERLAY)
		door_spark.Blend(icon(dci, "closed"), ICON_OVERLAY)
		door_deny.Blend(icon(dci, "deny"), ICON_OVERLAY)
		door_open.Blend(icon(dci, "open"), ICON_OVERLAY)
		door_opening.Blend(icon(dci, "opening"), ICON_OVERLAY)
		door_closing.Blend(icon(dci, "closing"), ICON_OVERLAY)
		o_door_opening.Blend(icon(dci, "opening"), ICON_OVERLAY)
		o_door_closing.Blend(icon(dci, "closing"), ICON_OVERLAY)
		door_opening_stat.Blend(icon(dci, "opening"), ICON_OVERLAY)
		door_closing_stat.Blend(icon(dci, "closing"), ICON_OVERLAY)

	// Paint on top of that paint
	if(stripe_icon && stripe_color)
		var/icon/si = icon(stripe_icon)
		si.Blend(stripe_color, ICON_MULTIPLY)
		door_closed.Blend(icon(si, "closed"), ICON_OVERLAY)
		door_locked.Blend(icon(si, "closed"), ICON_OVERLAY)
		door_spark.Blend(icon(si, "closed"), ICON_OVERLAY)
		door_deny.Blend(icon(si, "deny"), ICON_OVERLAY)
		door_open.Blend(icon(si, "open"), ICON_OVERLAY)
		door_opening.Blend(icon(si, "opening"), ICON_OVERLAY)
		door_closing.Blend(icon(si, "closing"), ICON_OVERLAY)
		o_door_opening.Blend(icon(si, "opening"), ICON_OVERLAY)
		o_door_closing.Blend(icon(si, "closing"), ICON_OVERLAY)
		door_opening_stat.Blend(icon(si, "opening"), ICON_OVERLAY)
		door_closing_stat.Blend(icon(si, "closing"), ICON_OVERLAY)

		// Filler for gaps left by the filler
		if(stripe_fill_icon)
			var/icon/sfi = icon(stripe_fill_icon)
			sfi.Blend(stripe_color, ICON_MULTIPLY)
			door_closed.Blend(icon(sfi, "closed"), ICON_OVERLAY)
			door_locked.Blend(icon(sfi, "closed"), ICON_OVERLAY)
			door_spark.Blend(icon(sfi, "closed"), ICON_OVERLAY)
			door_deny.Blend(icon(sfi, "deny"), ICON_OVERLAY)
			door_open.Blend(icon(sfi, "open"), ICON_OVERLAY)
			door_opening.Blend(icon(sfi, "opening"), ICON_OVERLAY)
			door_closing.Blend(icon(sfi, "closing"), ICON_OVERLAY)
			o_door_opening.Blend(icon(sfi, "opening"), ICON_OVERLAY)
			o_door_closing.Blend(icon(sfi, "closing"), ICON_OVERLAY)
			door_opening_stat.Blend(icon(sfi, "opening"), ICON_OVERLAY)
			door_closing_stat.Blend(icon(sfi, "closing"), ICON_OVERLAY)

	// Lights on top of everything
	if(lights_green_icon)
		door_opening.Blend(icon(lights_green_icon, "opening"), ICON_OVERLAY)
		o_door_opening.Blend(icon(lights_green_icon, "opening"), ICON_OVERLAY)
		door_closing.Blend(icon(lights_green_icon, "closing"), ICON_OVERLAY)
		o_door_closing.Blend(icon(lights_green_icon, "closing"), ICON_OVERLAY)
	
	if(lights_deny_icon)
		door_deny.Blend(icon(lights_deny_icon, "deny"), ICON_OVERLAY)
	
	if(lights_bolts_icon)
		door_locked.Blend(icon(lights_bolts_icon, "closed"), ICON_OVERLAY)

	if(lights_emag_icon)
		door_spark.Blend(icon(lights_emag_icon, "deny"), ICON_OVERLAY)

	// Panel while opening/closing
	o_door_opening.Blend(icon(panel_icon, "opening"), ICON_OVERLAY)
	o_door_closing.Blend(icon(panel_icon, "closing"), ICON_OVERLAY)

	var/icon/final = icon('icons/effects/effects.dmi', "nothing")
	final.Insert(door_closed, "door_closed")
	final.Insert(door_open, "door_open")
	final.Insert(door_locked, "door_locked")
	final.Insert(door_deny, "door_deny")
	final.Insert(door_opening, "door_opening")
	final.Insert(door_closing, "door_closing")
	final.Insert(door_spark, "door_spark")
	final.Insert(o_door_opening, "o_door_opening")
	final.Insert(o_door_closing, "o_door_closing")
	final.Insert(door_opening_stat, "door_opening_stat")
	final.Insert(door_closing_stat, "door_closing_stat")
	final.Insert(panel_open, "panel_open")
	final.Insert(welded, "welded")
	final.Insert(sparks_damaged, "sparks_damaged")
	final.Insert(sparks_broken, "sparks_broken")
	final.Insert(sparks_open, "sparks_open")
	
	angled_airlock_icon_cache[cache_key] = final
	icon = final
	update_icon()

/obj/machinery/door/airlock/angled/standard/proc/gimme_icon()
	usr << ftp(icon, "[name].dmi")

/obj/machinery/door/airlock/angled/standard
	icon = 'icons/obj/doors/angled/station/door.dmi'
	icon_state = "preview"
	fill_type = FILL_METAL

	base_icon = 'icons/obj/doors/angled/station/door.dmi'
	metal_fill_icon = 'icons/obj/doors/angled/station/fill_steel.dmi'
	glass_fill_icon = 'icons/obj/doors/angled/station/fill_glass.dmi'
	color_fill_icon = 'icons/obj/doors/angled/station/fill_color.dmi'
	stripe_fill_icon = 'icons/obj/doors/angled/station/fill_stripe.dmi'
	stripe_icon = 'icons/obj/doors/angled/station/stripe.dmi'
	door_color_icon = 'icons/obj/doors/angled/station/color.dmi'
	lights_deny_icon = 'icons/obj/doors/angled/station/lights_deny.dmi'
	lights_green_icon = 'icons/obj/doors/angled/station/lights_green.dmi'
	lights_bolts_icon = 'icons/obj/doors/angled/station/lights_bolts.dmi'
	lights_emag_icon = 'icons/obj/doors/angled/station/emag.dmi'
	panel_icon = 'icons/obj/doors/angled/station/panel.dmi'
	welded_icon = 'icons/obj/doors/angled/station/welded.dmi'
	spark_damaged_icon = 'icons/obj/doors/angled/station/sparks_damaged.dmi'
	spark_broken_icon = 'icons/obj/doors/angled/station/sparks_broken.dmi'

/obj/machinery/door/airlock/angled/standard/demo_fill_color
	fill_type = FILL_COLOR
	fill_color = "#FF0000"

/obj/machinery/door/airlock/angled/standard/demo_stripe
	stripe_color = "#FF0000"

/obj/machinery/door/airlock/angled/standard/demo_door_color
	door_color = "#FF0000"

/*
door_closed - static
	base
	metal or glass
	stripe
	door color

door_locked - static
	as door_closed, plus lights_bolts_icon

door_opening - animated
	as door_closed, but opening states
	lights_green opening

door_deny - animated
	as door_closed, plus lights_deny_icon

door_closing - animated
	as door_open, but closing states
	lights_green closing

door_open - static
	as door_closed, but open states

door_spark - animated
	as door_closed
	spark_icon closed

o_door_opening
	as door_opening
	panel_icon opening

o_door_closing
	as door_closing
	panel_icon closing

door_opening_stat
	as door_closed, but opening states without lights

door_closing_stat
	as door_open, but closing states without lights

panel_open
	just the panel

welded
	just welded

sparks_damaged
	spark_icon closed

sparks_broken
	spark_icon closed

sparks_open
	spark_icon open
*/

#undef FILL_METAL
#undef FILL_GLASS
#undef FILL_COLOR