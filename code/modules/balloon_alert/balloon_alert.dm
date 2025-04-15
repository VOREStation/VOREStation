#define BALLOON_TEXT_WIDTH 200
#define BALLOON_TEXT_SPAWN_TIME (0.2 SECONDS)
#define BALLOON_TEXT_FADE_TIME (0.1 SECONDS)
#define BALLOON_TEXT_FULLY_VISIBLE_TIME (0.7 SECONDS)
#define BALLOON_TEXT_TOTAL_LIFETIME(mult) (BALLOON_TEXT_SPAWN_TIME + BALLOON_TEXT_FULLY_VISIBLE_TIME*mult + BALLOON_TEXT_FADE_TIME)
#define BALLOON_TEXT_CHAR_LIFETIME_INCREASE_MULT (0.05)
#define BALLOON_TEXT_CHAR_LIFETIME_INCREASE_MIN 10

/// Creates text that will float from the atom upwards to the viewer.
/atom/proc/balloon_alert(mob/viewer, text)
	SHOULD_NOT_SLEEP(TRUE)

	INVOKE_ASYNC(src, PROC_REF(balloon_alert_perform), viewer, text)

/atom/proc/balloon_alert_visible(message, self_message, blind_message, range = world.view, list/exclude_mobs = null)
	SHOULD_NOT_SLEEP(TRUE)

	var/runechat_enabled

	var/list/hearers = get_mobs_in_view(range, src)
	hearers -= exclude_mobs

	for(var/mob/M in hearers)

		runechat_enabled = M.client.prefs?.read_preference(/datum/preference/toggle/runechat_mob)

		if(M.client && !runechat_enabled)
			continue

		if(M.is_blind())
			continue

		balloon_alert(M, (M == src && self_message) || message)

/atom/proc/balloon_alert_perform(mob/viewer, text)

	var/client/viewer_client = viewer?.client
	if (isnull(viewer_client))
		return

	if (isbelly(src.loc))
		return

	var/bound_width = world.icon_size
	if (ismovable(src))
		var/atom/movable/movable_source = src
		bound_width = movable_source.bound_width

	var/image/balloon_alert = image(loc = isturf(src) ? src : get_atom_on_turf(src), layer = ABOVE_MOB_LAYER)
	balloon_alert.plane = PLANE_RUNECHAT
	balloon_alert.alpha = 0
	balloon_alert.appearance_flags = RESET_ALPHA|RESET_COLOR|RESET_TRANSFORM
	balloon_alert.maptext = MAPTEXT("<span style='text-align: center; -dm-text-outline: 1px #0005'>[text]</span>")
	balloon_alert.maptext_x = (BALLOON_TEXT_WIDTH - bound_width) * -0.5
	balloon_alert.maptext_height = WXH_TO_HEIGHT(viewer_client?.MeasureText(text, null, BALLOON_TEXT_WIDTH))
	balloon_alert.maptext_width = BALLOON_TEXT_WIDTH

	viewer_client?.images += balloon_alert

	var/length_mult = 1 + max(0, length(strip_html_simple(text)) - BALLOON_TEXT_CHAR_LIFETIME_INCREASE_MIN) * BALLOON_TEXT_CHAR_LIFETIME_INCREASE_MULT

	animate(
		balloon_alert,
		pixel_y = world.icon_size * 1.2,
		time = BALLOON_TEXT_TOTAL_LIFETIME(length_mult),
		easing = SINE_EASING | EASE_OUT,
	)

	animate(
		alpha = 255,
		time = BALLOON_TEXT_SPAWN_TIME,
		easing = CUBIC_EASING | EASE_OUT,
		flags = ANIMATION_PARALLEL,
	)

	animate(
		alpha = 0,
		time = BALLOON_TEXT_FULLY_VISIBLE_TIME * length_mult,
		easing = CUBIC_EASING | EASE_IN,
	)

	LAZYADD(update_on_z, balloon_alert)
	addtimer(CALLBACK(balloon_alert.loc, PROC_REF(forget_balloon_alert), balloon_alert), BALLOON_TEXT_TOTAL_LIFETIME(length_mult))
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(remove_image_from_client), balloon_alert, viewer_client), BALLOON_TEXT_TOTAL_LIFETIME(length_mult))

/atom/proc/forget_balloon_alert(image/balloon_alert)
	LAZYREMOVE(update_on_z, balloon_alert)

#undef BALLOON_TEXT_FADE_TIME
#undef BALLOON_TEXT_FULLY_VISIBLE_TIME
#undef BALLOON_TEXT_SPAWN_TIME
#undef BALLOON_TEXT_TOTAL_LIFETIME
#undef BALLOON_TEXT_WIDTH
#undef BALLOON_TEXT_CHAR_LIFETIME_INCREASE_MULT
#undef BALLOON_TEXT_CHAR_LIFETIME_INCREASE_MIN
