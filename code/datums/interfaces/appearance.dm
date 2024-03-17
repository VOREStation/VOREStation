/**
 * hey, remember mutable appearance?
 *
 * only:
 * - this isn't a real object rather than a struct
 * - i'm making a cast for it so we can VV it
 * - this is also used to cast procs that operate on appearance-like things.
 *
 * Sue me, I need to debug things somehow
 *
 * DO NOT USE THESE UNLESS YOU KNOW WHAT YOU ARE DOING.
 */
/appearance
	var/alpha
	var/appearance_flags
	var/blend_mode
	var/color
	var/desc
	var/dir
	var/gender
	var/icon
	var/icon_state
	var/invisibility
	var/infra_luminosity
	var/list/filters
	var/layer
	var/luminosity
	var/maptext
	var/maptext_width
	var/maptext_height
	var/maptext_x
	var/maptext_y
	var/mouse_over_pointer
	var/mouse_drag_pointer
	var/mouse_drop_pointer
	var/mouse_drop_zone
	var/mouse_opacity
	var/name
	var/opacity
	var/list/overlays
	var/override
	var/pixel_x
	var/pixel_y
	var/pixel_w
	var/pixel_z
	var/plane
	var/render_source
	var/render_target
	var/suffix
	var/text
	var/transform
	var/list/underlays
	// var/vis_flags

//! vis_flags missing even though byond ref says it's there, fuck off why is this possible

GLOBAL_REAL_VAR(_appearance_var_list) = list(
	"alpha",
	"appearance_flags",
	"blend_mode",
	"color",
	"desc",
	"dir",
	"gender",
	"icon",
	"icon_state",
	"invisibility",
	"infra_luminosity",
	"filters",
	"layer",
	"luminosity",
	"maptext",
	"maptext_width",
	"maptext_height",
	"maptext_x",
	"maptext_y",
	"mouse_over_pointer",
	"mouse_drag_pointer",
	"mouse_drop_pointer",
	"mouse_drop_zone",
	"mouse_opacity",
	"name",
	"opacity",
	"overlays",
	"override",
	"pixel_x",
	"pixel_y",
	"pixel_w",
	"pixel_z",
	"plane",
	"render_source",
	"render_target",
	"suffix",
	"text",
	"transform",
	"underlays"
	// "vis_flags"
)

/proc/__appearance_v_debug(appearance/A, name)
	switch(name)
#define DEBUG_APPEARANCE_VAR(n) if(#n) return debug_variable(name, A.n, 0, null)
		DEBUG_APPEARANCE_VAR(alpha)
		DEBUG_APPEARANCE_VAR(appearance_flags)
		DEBUG_APPEARANCE_VAR(blend_mode)
		DEBUG_APPEARANCE_VAR(color)
		DEBUG_APPEARANCE_VAR(desc)
		DEBUG_APPEARANCE_VAR(dir)
		DEBUG_APPEARANCE_VAR(gender)
		DEBUG_APPEARANCE_VAR(icon)
		DEBUG_APPEARANCE_VAR(icon_state)
		DEBUG_APPEARANCE_VAR(invisibility)
		DEBUG_APPEARANCE_VAR(infra_luminosity)
		DEBUG_APPEARANCE_VAR(filters)
		DEBUG_APPEARANCE_VAR(layer)
		DEBUG_APPEARANCE_VAR(luminosity)
		DEBUG_APPEARANCE_VAR(maptext)
		DEBUG_APPEARANCE_VAR(maptext_width)
		DEBUG_APPEARANCE_VAR(maptext_height)
		DEBUG_APPEARANCE_VAR(maptext_x)
		DEBUG_APPEARANCE_VAR(maptext_y)
		DEBUG_APPEARANCE_VAR(mouse_over_pointer)
		DEBUG_APPEARANCE_VAR(mouse_drag_pointer)
		DEBUG_APPEARANCE_VAR(mouse_drop_pointer)
		DEBUG_APPEARANCE_VAR(mouse_drop_zone)
		DEBUG_APPEARANCE_VAR(mouse_opacity)
		DEBUG_APPEARANCE_VAR(name)
		DEBUG_APPEARANCE_VAR(opacity)
		DEBUG_APPEARANCE_VAR(overlays)
		DEBUG_APPEARANCE_VAR(override)
		DEBUG_APPEARANCE_VAR(pixel_x)
		DEBUG_APPEARANCE_VAR(pixel_y)
		DEBUG_APPEARANCE_VAR(pixel_w)
		DEBUG_APPEARANCE_VAR(pixel_z)
		DEBUG_APPEARANCE_VAR(plane)
		DEBUG_APPEARANCE_VAR(render_source)
		DEBUG_APPEARANCE_VAR(render_target)
		DEBUG_APPEARANCE_VAR(suffix)
		DEBUG_APPEARANCE_VAR(text)
		DEBUG_APPEARANCE_VAR(transform)
		DEBUG_APPEARANCE_VAR(underlays)
		// DEBUG_APPEARANCE_VAR(vis_flags)
#undef DEBUG_APPEARANCE_VAR
