#define FILL_NONE 0
#define FILL_METAL 1
#define FILL_GLASS 2
#define FILL_COLOR 3

/**
 * A fairly rough translation of Bay's airlock icon system into ours, with the
 * icons being built at runtime to afford the luxury of not needing to pre-bake
 * all the icons like we have in the past, but preventing the overlay thrashing that
 * Bay's seem to encounter. All the heavy lifting is just done once at initialization.
 *
 * The input state names from the various Bay files are:
 * preview: Only in base_icon for mapping
 * closed: static, when closed
 * open: static, when open
 * closing: anim, from open to closed transition
 * opening: anim, from closed to open transition
 * deny: static/anim, when denying a mob access
 *
 * The output state names to our system are:
 * door_closed: closed
 * door_locked: closed+bolted lights
 * door_deny: deny
 * door_open: open
 * door_opening: opening+allow lights
 * door_closing: closing+allow lights
 * o_door_opening: opening+panel
 * o_door_closing: closing+panel
 * door_opening_stat: opening
 * door_closing_stat: closing
 *
 * These do not include the door icon and are overlays:
 * panel_open: bare panel overlay
 * welded: bare welded overlay
 * sparks_damaged: sparks for partial damage overlay
 * sparks_broken: sparks for full damage overlay
 * sparks_open: sparks when door is open overlay
 */


/obj/machinery/door/airlock/angled_bay
	icon_state = "preview"
	dir = 2

	var/fill_type = FILL_NONE

	var/static/list/angled_airlock_icon_cache = list()
	/// Mandatory: The base door structure icon, very required.
	var/base_icon

	/// Optional: Applied when fill_type is FILL_METAL
	var/metal_fill_icon
	/// Optional: Applied when fill_type is FILL_GLASS
	var/glass_fill_icon
	/// Optional: Applied when fill_type is FILL_COLOR
	var/color_fill_icon
	/// Optional: Used if stripe_color is set to a color value
	var/stripe_icon
	/// Optional: Used if stripe_color is set to a color value
	var/stripe_fill_icon
	/// Optional: Used if door_color is set to a color value
	var/door_color_icon

	/// Optional: Lights to flash when the door denies access
	var/lights_deny_icon
	/// Optional: Lights to flash when the door is opening/closing
	var/lights_green_icon
	/// Optional: Lights to display when the door is closed and locked
	var/lights_bolts_icon
	/// Optional: Lights and/or sparks to display when the door is being emagged
	var/lights_emag_icon

	/// Optional: Icon that contains the panel overlays for the door being worked on
	var/panel_icon = 'icons/obj/doors/angled/station/panel.dmi' // bay seems to think these are 'close enough' for default use
	/// Optional: Icon that contains the welded overlay
	var/welded_icon = 'icons/obj/doors/angled/station/welded.dmi'
	/// Optional: Icon that contains the spark animations for the door being partially destroyed
	var/spark_damaged_icon = 'icons/obj/doors/angled/station/sparks_damaged.dmi'
	/// Optional: Icon that contains the spark animations for the door being fully destroyed
	var/spark_broken_icon = 'icons/obj/doors/angled/station/sparks_broken.dmi'

	/// Optional: If fill_value is not FILL_NONE, this color will be applied to the fill of the door
	var/fill_color
	/// Optional: If stripe_icon is not null, this color will be applied to the stripe on the door
	var/stripe_color
	/// Optional: If door_color_icon is not null, this color will be applied to the door color overlay
	var/door_color

/obj/machinery/door/airlock/angled_bay/Initialize(mapload)
	obtain_icon()
	. = ..()

/obj/machinery/door/airlock/angled_bay/proc/obtain_icon()
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

	// Base layer - the bare metal - absolutely required sprites
	var/icon/door_closed = icon(base_icon, "closed")
	var/icon/door_open = icon(base_icon, "open")
	var/icon/door_locked = icon(base_icon, "closed")
	var/icon/door_deny = icon(base_icon, "deny")
	var/icon/door_spark = icon(base_icon, "closed")
	var/icon/door_opening = icon(base_icon, "opening")
	var/icon/door_closing = icon(base_icon, "closing")
	var/icon/door_opening_stat = icon(base_icon, "opening")
	var/icon/door_closing_stat = icon(base_icon, "closing")
	var/icon/o_door_opening = icon(base_icon, "opening")
	var/icon/o_door_closing = icon(base_icon, "closing")

	// Optional icons
	var/icon/panel_open
	var/icon/welded_closed
	var/icon/welded_open
	var/icon/sparks_damaged
	var/icon/sparks_open
	var/icon/sparks_broken

	if(panel_icon)
		panel_open = icon(panel_icon, "closed")
	else
		panel_open = icon('icons/effects/effects.dmi', "nothing")

	if(welded_icon)
		welded_closed = icon(welded_icon, "closed")
		welded_open = icon(welded_icon, "open") // only used on firedoors far as I can tell
	else
		welded_closed = icon('icons/effects/effects.dmi', "nothing")
		welded_open = icon('icons/effects/effects.dmi', "nothing")

	if(spark_damaged_icon)
		sparks_damaged = icon(spark_damaged_icon, "closed")
		sparks_open = icon(spark_damaged_icon, "open")
	else
		sparks_damaged = icon('icons/effects/effects.dmi', "nothing")
		sparks_open = icon('icons/effects/effects.dmi', "nothing")

	if(spark_broken_icon)
		sparks_broken = icon(spark_broken_icon, "closed")
	else
		sparks_broken = icon('icons/effects/effects.dmi', "nothing")

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
	if(width > 1)
		var/pixel_width = world.icon_size * width
		final.Crop(1,1,pixel_width,pixel_width)
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
	final.Insert(welded_closed, "welded")
	final.Insert(welded_open, "welded_open")
	final.Insert(sparks_damaged, "sparks_damaged")
	final.Insert(sparks_broken, "sparks_broken")
	final.Insert(sparks_open, "sparks_open")

	angled_airlock_icon_cache[cache_key] = final
	icon = final
	update_icon()

/obj/machinery/door/airlock/angled_bay/proc/gimme_icon()
	usr << ftp(icon, "[name].dmi")

/**
 * The actual door types you can map in.
 * Comments show what you can customize.
 */

// Fills: Metal, glass, color
// Supports stripe color
// Supports door color
/obj/machinery/door/airlock/angled_bay/standard
	icon = 'icons/obj/doors/angled/station/door.dmi'
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
/obj/machinery/door/airlock/angled_bay/standard/glass
	icon_state = "preview_glass"
	fill_type = FILL_GLASS
/obj/machinery/door/airlock/angled_bay/standard/color
	icon_state = "preview_color"
	fill_type = FILL_COLOR

// Fills: Metal
// Supports stripe color
/obj/machinery/door/airlock/angled_bay/hatch
	icon = 'icons/obj/doors/angled/hatch/door.dmi'
	fill_type = FILL_METAL

	base_icon = 'icons/obj/doors/angled/hatch/door.dmi'
	metal_fill_icon = 'icons/obj/doors/angled/hatch/fill_steel.dmi'
	stripe_fill_icon = 'icons/obj/doors/angled/hatch/fill_stripe.dmi'
	stripe_icon = 'icons/obj/doors/angled/hatch/stripe.dmi'
	lights_deny_icon = 'icons/obj/doors/angled/hatch/lights_deny.dmi'
	lights_green_icon = 'icons/obj/doors/angled/hatch/lights_green.dmi'
	lights_bolts_icon = 'icons/obj/doors/angled/hatch/lights_bolts.dmi'
	lights_emag_icon = 'icons/obj/doors/angled/hatch/emag.dmi'
	panel_icon = 'icons/obj/doors/angled/hatch/panel.dmi'
	welded_icon = 'icons/obj/doors/angled/hatch/welded.dmi'

// Fills: None
/obj/machinery/door/airlock/angled_bay/ascent
	icon = 'icons/obj/doors/angled/ascent/door.dmi'

	base_icon = 'icons/obj/doors/angled/ascent/door.dmi'
	lights_deny_icon = 'icons/obj/doors/angled/ascent/lights_deny.dmi'
	lights_green_icon = 'icons/obj/doors/angled/ascent/lights_green.dmi'
	lights_bolts_icon = 'icons/obj/doors/angled/ascent/lights_bolts.dmi'
	lights_emag_icon = 'icons/obj/doors/angled/ascent/emag.dmi'
	panel_icon = 'icons/obj/doors/angled/ascent/panel.dmi'
	welded_icon = 'icons/obj/doors/angled/ascent/welded.dmi'
	spark_damaged_icon = 'icons/obj/doors/angled/ascent/sparks_damaged.dmi'
	spark_broken_icon = 'icons/obj/doors/angled/ascent/sparks_broken.dmi'

// Fills: Metal, glass, color
// Supports door color
/obj/machinery/door/airlock/angled_bay/external
	icon = 'icons/obj/doors/angled/external/door.dmi'
	fill_type = FILL_METAL

	base_icon = 'icons/obj/doors/angled/external/door.dmi'
	metal_fill_icon = 'icons/obj/doors/angled/external/fill_steel.dmi'
	glass_fill_icon = 'icons/obj/doors/angled/external/fill_glass.dmi'
	color_fill_icon = 'icons/obj/doors/angled/external/fill_color.dmi'
	door_color_icon = 'icons/obj/doors/angled/external/color.dmi'
	lights_deny_icon = 'icons/obj/doors/angled/external/lights_deny.dmi'
	lights_green_icon = 'icons/obj/doors/angled/external/lights_green.dmi'
	lights_bolts_icon = 'icons/obj/doors/angled/external/lights_bolts.dmi'
	lights_emag_icon = 'icons/obj/doors/angled/external/emag.dmi'
/obj/machinery/door/airlock/angled_bay/external/glass
	icon_state = "preview_glass"
	fill_type = FILL_GLASS
/obj/machinery/door/airlock/angled_bay/external/color
	icon_state = "preview_color"
	fill_type = FILL_COLOR

// Fills: Metal, glass
/obj/machinery/door/airlock/angled_bay/elevator
	icon = 'icons/obj/doors/angled/elevator/door.dmi'
	fill_type = FILL_METAL

	base_icon = 'icons/obj/doors/angled/elevator/door.dmi'
	metal_fill_icon = 'icons/obj/doors/angled/elevator/fill_steel.dmi'
	glass_fill_icon = 'icons/obj/doors/angled/elevator/fill_glass.dmi'
	lights_deny_icon = 'icons/obj/doors/angled/elevator/lights_deny.dmi'
	lights_green_icon = 'icons/obj/doors/angled/elevator/lights_green.dmi'
	lights_bolts_icon = 'icons/obj/doors/angled/elevator/lights_bolts.dmi'
	welded_icon = 'icons/obj/doors/angled/elevator/welded.dmi'
/obj/machinery/door/airlock/angled_bay/elevator/glass
	icon_state = "preview_glass"
	fill_type = FILL_GLASS


// Very few options on these, basically just static doors.
/obj/machinery/door/airlock/angled_bay/hazard // firedoors
	icon = 'icons/obj/doors/angled/hazard/door.dmi'

	base_icon = 'icons/obj/doors/angled/hazard/door.dmi'
	panel_icon = 'icons/obj/doors/angled/hazard/panel.dmi'
	welded_icon = 'icons/obj/doors/angled/hazard/welded.dmi'

/obj/machinery/door/airlock/angled_bay/vault
	icon = 'icons/obj/doors/angled/vault/door.dmi'
	fill_type = FILL_METAL // the only option

	base_icon = 'icons/obj/doors/angled/vault/door.dmi'
	metal_fill_icon = 'icons/obj/doors/angled/vault/fill_steel.dmi'

/obj/machinery/door/airlock/angled_bay/secure
	icon = 'icons/obj/doors/angled/secure/door.dmi'
	fill_type = FILL_METAL // the only option

	base_icon = 'icons/obj/doors/angled/secure/door.dmi'
	metal_fill_icon = 'icons/obj/doors/angled/secure/fill_steel.dmi'

/obj/machinery/door/airlock/angled_bay/centcomm
	icon = 'icons/obj/doors/angled/centcomm/door.dmi'
	fill_type = FILL_METAL // the only option

	base_icon = 'icons/obj/doors/angled/centcomm/door.dmi'
	metal_fill_icon = 'icons/obj/doors/angled/centcomm/fill_steel.dmi'

// Double door requires a little code
// Fills: Metal, glass, color
// Supports stripe color
// Supports door color
/obj/machinery/door/airlock/angled_bay/double
	width = 2
	appearance_flags = 0
	icon = 'icons/obj/doors/angled/double/door.dmi'
	fill_type = FILL_METAL

	base_icon = 'icons/obj/doors/angled/double/door.dmi'
	metal_fill_icon = 'icons/obj/doors/angled/double/fill_steel.dmi'
	glass_fill_icon = 'icons/obj/doors/angled/double/fill_glass.dmi'
	color_fill_icon = 'icons/obj/doors/angled/double/fill_color.dmi'
	stripe_fill_icon = 'icons/obj/doors/angled/double/fill_stripe.dmi'
	stripe_icon = 'icons/obj/doors/angled/double/stripe.dmi'
	door_color_icon = 'icons/obj/doors/angled/double/color.dmi'
	lights_deny_icon = 'icons/obj/doors/angled/double/lights_deny.dmi'
	lights_green_icon = 'icons/obj/doors/angled/double/lights_green.dmi'
	lights_bolts_icon = 'icons/obj/doors/angled/double/lights_bolts.dmi'
	lights_emag_icon = 'icons/obj/doors/angled/double/emag.dmi'
	panel_icon = 'icons/obj/doors/angled/double/panel.dmi'
	welded_icon = 'icons/obj/doors/angled/double/welded.dmi'
	spark_damaged_icon = 'icons/obj/doors/angled/double/sparks_damaged.dmi'
	spark_broken_icon = 'icons/obj/doors/angled/double/sparks_broken.dmi'
/obj/machinery/door/airlock/angled_bay/double/glass
	icon_state = "preview_glass"
	fill_type = FILL_GLASS
/obj/machinery/door/airlock/angled_bay/double/color
	icon_state = "preview_color"
	fill_type = FILL_COLOR

/obj/machinery/door/airlock/angled_bay/double/Initialize(mapload)
	. = ..()
	SetBounds()
	apply_opacity_to_my_turfs(opacity)

/obj/machinery/door/airlock/angled_bay/double/set_opacity()
	. = ..()
	apply_opacity_to_my_turfs(opacity)

/obj/machinery/door/airlock/angled_bay/double/Moved()
	. = ..()
	SetBounds()

/obj/machinery/door/airlock/angled_bay/double/proc/apply_opacity_to_my_turfs(new_opacity)
	for(var/turf/T in locs)
		T.set_opacity(new_opacity)
	update_nearby_tiles()

/obj/machinery/door/airlock/angled_bay/double/proc/SetBounds()
	if(dir & 3) // weird, but their icons are 'backwards' so whatever
		bound_width = width * world.icon_size
		bound_height = world.icon_size
	else
		bound_width = world.icon_size
		bound_height = width * world.icon_size

#undef FILL_NONE
#undef FILL_METAL
#undef FILL_GLASS
#undef FILL_COLOR
