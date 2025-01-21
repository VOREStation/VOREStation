/**
 * Creates a TGUI color picker window and returns the user's response.
 *
 * This proc should be used to create a color picker that the caller will wait for a response from.
 * Arguments:
 * * user - The user to show the picker to.
 * * title - The of the picker modal, shown on the top of the TGUI window.
 * * timeout - The timeout of the picker, after which the modal will close and qdel itself. Set to zero for no timeout.
 * * autofocus - The bool that controls if this picker should grab window focus.
 */
/proc/tgui_color_picker(mob/user, message, title, default = "#000000", timeout = 0, autofocus = TRUE)
	if (!user)
		user = usr
	if (!istype(user))
		if (istype(user, /client))
			var/client/client = user
			user = client.mob
		else
			return
	// Client does NOT have tgui_input on: Returns regular input
	if(!user.client.prefs.read_preference(/datum/preference/toggle/tgui_input_mode) || user.client.byond_version < 516) // Todo, remove once virgo is on 516, but currently the TGUI interface is already programmed for edge
		return input(user, message, title, default) as color|null
	var/datum/tgui_color_picker/picker = new(user, message, title, default, timeout, autofocus)
	picker.tgui_interact(user)
	picker.wait()
	if (picker)
		. = picker.choice
		qdel(picker)

/**
 * # tgui_color_picker
 *
 * Datum used for instantiating and using a TGUI-controlled color picker.
 */
/datum/tgui_color_picker
	/// The title of the TGUI window
	var/title
	/// The message to show the user
	var/message
	/// The default choice, used if there is an existing value
	var/default
	/// The color the user selected, null if no selection has been made
	var/choice
	/// The time at which the tgui_color_picker was created, for displaying timeout progress.
	var/start_time
	/// The lifespan of the tgui_color_picker, after which the window will close and delete itself.
	var/timeout
	/// The bool that controls if this modal should grab window focus
	var/autofocus
	/// Boolean field describing if the tgui_color_picker was closed by the user.
	var/closed

/datum/tgui_color_picker/New(mob/user, message, title, default, timeout, autofocus)
	src.autofocus = autofocus
	src.title = title
	src.default = default
	src.message = message
	if (timeout)
		src.timeout = timeout
		start_time = world.time
		QDEL_IN(src, timeout)

/datum/tgui_color_picker/Destroy(force)
	SStgui.close_uis(src)
	. = ..()

/**
 * Waits for a user's response to the tgui_color_picker's prompt before returning. Returns early if
 * the window was closed by the user.
 */
/datum/tgui_color_picker/proc/wait()
	while (!choice && !closed && !QDELETED(src))
		stoplag(1)

/datum/tgui_color_picker/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ColorPickerModal")
		ui.open()
		ui.set_autoupdate(timeout > 0)

/datum/tgui_color_picker/tgui_close(mob/user)
	. = ..()
	closed = TRUE

/datum/tgui_color_picker/tgui_state(mob/user)
	return GLOB.tgui_always_state

/datum/tgui_color_picker/tgui_static_data(mob/user)
	. = list()
	.["autofocus"] = autofocus
	.["large_buttons"] = !user.client?.prefs || user.client.prefs.read_preference(/datum/preference/toggle/tgui_large_buttons)
	.["swapped_buttons"] = !user.client?.prefs || user.client.prefs.read_preference(/datum/preference/toggle/tgui_swapped_buttons)
	.["title"] = title
	.["default_color"] = default
	.["message"] = message

/datum/tgui_color_picker/tgui_data(mob/user)
	. = list()
	if(timeout)
		.["timeout"] = CLAMP01((timeout - (world.time - start_time) - 1 SECONDS) / (timeout - 1 SECONDS))
	.["presets"] = user.read_preference(/datum/preference/text/preset_colors)

/datum/tgui_color_picker/tgui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if (.)
		return
	switch(action)
		if("submit")
			var/raw_data = lowertext(params["entry"])
			var/hex = sanitize_hexcolor(raw_data)
			if (!hex)
				return
			set_choice(hex)
			closed = TRUE
			SStgui.close_uis(src)
			return TRUE
		if("cancel")
			closed = TRUE
			SStgui.close_uis(src)
			return TRUE
		if("null")
			set_choice(null)
			SStgui.close_uis(src)
			return TRUE
		if("preset")
			if(ui.user)
				var/raw_data = lowertext(params["color"])
				var/index = lowertext(params["index"])
				var/colors = ui.user.read_preference(/datum/preference/text/preset_colors)
				var/list/entries = splittext(colors, ";")
				while(LAZYLEN(entries) < 20)
					entries += "#FFFFFF"
				if(LAZYLEN(entries) > 20)
					entries.Cut(21)
				var/hex = sanitize_hexcolor(raw_data)
				if (!hex || !isnum(index) || entries[index] == hex)
					return
				entries[index] = hex
				ui.user.write_preference_directly(/datum/preference/text/preset_colors, entries.Join(";"))
			return TRUE

/datum/tgui_color_picker/proc/set_choice(choice)
	src.choice = choice
