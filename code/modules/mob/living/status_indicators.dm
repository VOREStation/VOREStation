#define STATUS_INDICATOR_Y_OFFSET 2 // Offset from the edge of the icon sprite, so 32 pixels plus whatever number is here.
#define STATUS_INDICATOR_ICON_X_SIZE 16 // Don't need to care about the Y size due to the origin being on the bottom side.
#define STATUS_INDICATOR_ICON_MARGIN 2 // The space between two status indicators.

// 'Status indicators' are icons that display over a mob's head, that visually indicate that the mob is suffering
// from some kind of effect, such as being stunned, blinded, confused, asleep, etc.
// The icons are managed automatically by the mob itself, so that their positions will shift if another indicator is added,
// and it will try to always be above the mob sprite, even for larger sprites like xenos.

/mob/living
	var/list/status_indicators = null // Will become a list as needed.

// Adds an icon_state, or image overlay, to the list of indicators to be managed automatically.
// Also initializes the list if one doesn't exist.
/mob/living/proc/add_status_indicator(image/thing)
	if(get_status_indicator(thing)) // No duplicates, please.
		return

	if(!istype(thing, /image))
		thing = image(icon = 'icons/mob/status_indicators.dmi', icon_state = thing)

	LAZYADD(status_indicators, thing)
	handle_status_indicators()

// Similar to above but removes it instead, and nulls the list if it becomes empty as a result.
/mob/living/proc/remove_status_indicator(image/thing)
	thing = get_status_indicator(thing)

	cut_overlay(thing)
	LAZYREMOVE(status_indicators, thing)
	handle_status_indicators()

/mob/living/proc/get_status_indicator(image/thing)
	if(!istype(thing, /image))
		for(var/image/I in status_indicators)
			if(I.icon_state == thing)
				return I
	return LAZYACCESS(status_indicators, LAZYFIND(status_indicators, thing))

// Refreshes the indicators over a mob's head. Should only be called when adding or removing a status indicator with the above procs,
// or when the mob changes size visually for some reason.
/mob/living/proc/handle_status_indicators()
	// First, get rid of all the overlays.
	for(var/thing in status_indicators)
		cut_overlay(thing)

	if(!LAZYLEN(status_indicators))
		return

	if(stat == DEAD)
		return

	// Now put them back on in the right spot.
	var/our_sprite_x = icon_expected_width * get_icon_scale_x()
	var/our_sprite_y = icon_expected_height * get_icon_scale_y()

	var/x_offset = our_sprite_x // Add your own offset here later if you want.
	var/y_offset = our_sprite_y + STATUS_INDICATOR_Y_OFFSET

	// Calculates how 'long' the row of indicators and the margin between them should be.
	// The goal is to have the center of that row be horizontally aligned with the sprite's center.
	var/expected_status_indicator_length = (STATUS_INDICATOR_ICON_X_SIZE * status_indicators.len) + (STATUS_INDICATOR_ICON_MARGIN * max(status_indicators.len - 1, 0))
	var/current_x_position = (x_offset / 2) - (expected_status_indicator_length / 2)

	// In /mob/living's `update_transform()`, the sprite is horizontally shifted when scaled up, so that the center of the sprite doesn't move to the right.
	// Because of that, this adjustment needs to happen with the future indicator row as well, or it will look bad.
	current_x_position -= (icon_expected_width / 2) * (get_icon_scale_y() - 1)

	// Now the indicator row can actually be built.
	for(var/image/I as anything in status_indicators)

		// This is a semi-HUD element, in a similar manner as medHUDs, in that they're 'above' everything else in the world,
		// but don't pierce obfuscation layers such as blindness or darkness, unlike actual HUD elements like inventory slots.
		I.plane = PLANE_STATUS
		I.layer = HUD_LAYER
		I.appearance_flags = PIXEL_SCALE|TILE_BOUND|NO_CLIENT_COLOR|RESET_COLOR|RESET_ALPHA|RESET_TRANSFORM|KEEP_APART
		I.pixel_y = y_offset
		I.pixel_x = current_x_position
		add_overlay(I)
		// Adding the margin space every time saves a conditional check on the last iteration,
		// and it won't cause any issues since no more icons will be added, and the var is not used for anything else.
		current_x_position += STATUS_INDICATOR_ICON_X_SIZE + STATUS_INDICATOR_ICON_MARGIN


#undef STATUS_INDICATOR_Y_OFFSET
#undef STATUS_INDICATOR_ICON_X_SIZE
#undef STATUS_INDICATOR_ICON_MARGIN
