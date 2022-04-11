/**
 * Creates a TGUI input text window and returns the user's response.
 *
 * This proc should be used to create alerts that the caller will wait for a response from.
 * Arguments:
 * * user - The user to show the input box to.
 * * message - The content of the input box, shown in the body of the TGUI window.
 * * title - The title of the input box, shown on the top of the TGUI window.
 * * default - The default value pre-populated in the input box.
 * * timeout - The timeout of the input box, after which the input box will close and qdel itself. Set to zero for no timeout.
 */
/proc/tgui_input_text(mob/user, message, title, default, timeout = 0)
	if (istext(user))
		stack_trace("tgui_input_text() received text for user instead of mob")
		return
	if (!user)
		user = usr
	if (!istype(user))
		if (istype(user, /client))
			var/client/client = user
			user = client.mob
		else
			return
	var/datum/tgui_input_dialog/input = new(user, message, title, default, timeout)
	input.input_type = "text"
	input.tgui_interact(user)
	input.wait()
	if (input)
		. = input.choice
		qdel(input)

/**
 * Creates a TGUI input message window and returns the user's response.
 *
 * This proc should be used to create alerts that the caller will wait for a response from.
 * Arguments:
 * * user - The user to show the input box to.
 * * message - The content of the input box, shown in the body of the TGUI window.
 * * title - The title of the input box, shown on the top of the TGUI window.
 * * default - The default value pre-populated in the input box.
 * * timeout - The timeout of the input box, after which the input box will close and qdel itself. Set to zero for no timeout.
 */
/proc/tgui_input_message(mob/user, message, title, default, timeout = 0)
	if (istext(user))
		stack_trace("tgui_input_message() received text for user instead of mob")
		return
	if (!user)
		user = usr
	if (!istype(user))
		if (istype(user, /client))
			var/client/client = user
			user = client.mob
		else
			return
	var/datum/tgui_input_dialog/input = new(user, message, title, default, timeout)
	input.input_type = "message"
	input.tgui_interact(user)
	input.wait()
	if (input)
		. = input.choice
		qdel(input)

/**
 * Creates a TGUI input num window and returns the user's response.
 *
 * This proc should be used to create alerts that the caller will wait for a response from.
 * Arguments:
 * * user - The user to show the input box to.
 * * message - The content of the input box, shown in the body of the TGUI window.
 * * title - The title of the input box, shown on the top of the TGUI window.
 * * default - The default value pre-populated in the input box.
 * * timeout - The timeout of the input box, after which the input box will close and qdel itself. Set to zero for no timeout.
 */
/proc/tgui_input_num(mob/user, message, title, default, timeout = 0)
	if (istext(user))
		stack_trace("tgui_input_num() received text for user instead of mob")
		return
	if (!user)
		user = usr
	if (!istype(user))
		if (istype(user, /client))
			var/client/client = user
			user = client.mob
		else
			return
	var/datum/tgui_input_dialog/input = new(user, message, title, default, timeout)
	input.input_type = "num"
	input.tgui_interact(user)
	input.wait()
	if (input)
		. = input.choice
		qdel(input)

/**
 * Creates an asynchronous TGUI input text window with an associated callback.
 *
 * This proc should be used to create inputs that invoke a callback with the user's chosen option.
 * Arguments:
 * * user - The user to show the input box to.
 * * message - The content of the input box, shown in the body of the TGUI window.
 * * title - The title of the input box, shown on the top of the TGUI window.
 * * default - The default value pre-populated in the input box.
 * * callback - The callback to be invoked when a choice is made.
 * * timeout - The timeout of the input box, after which the menu will close and qdel itself. Set to zero for no timeout.
 */
/proc/tgui_input_text_async(mob/user, message, title, default, datum/callback/callback, timeout = 60 SECONDS)
	if (istext(user))
		stack_trace("tgui_input_text_async() received text for user instead of mob")
		return
	if (!user)
		user = usr
	if (!istype(user))
		if (istype(user, /client))
			var/client/client = user
			user = client.mob
		else
			return
	var/datum/tgui_input_dialog/async/input = new(user, message, title, default, callback, timeout)
	input.input_type = "text"
	input.tgui_interact(user)

/**
 * Creates an asynchronous TGUI input message window with an associated callback.
 *
 * This proc should be used to create inputs that invoke a callback with the user's chosen option.
 * Arguments:
 * * user - The user to show the input box to.
 * * message - The content of the input box, shown in the body of the TGUI window.
 * * title - The title of the input box, shown on the top of the TGUI window.
 * * default - The default value pre-populated in the input box.
 * * callback - The callback to be invoked when a choice is made.
 * * timeout - The timeout of the input box, after which the menu will close and qdel itself. Set to zero for no timeout.
 */
/proc/tgui_input_message_async(mob/user, message, title, default, datum/callback/callback, timeout = 60 SECONDS)
	if (istext(user))
		stack_trace("tgui_input_message_async() received text for user instead of mob")
		return
	if (!user)
		user = usr
	if (!istype(user))
		if (istype(user, /client))
			var/client/client = user
			user = client.mob
		else
			return
	var/datum/tgui_input_dialog/async/input = new(user, message, title, default, callback, timeout)
	input.input_type = "message"
	input.tgui_interact(user)

/**
 * Creates an asynchronous TGUI input num window with an associated callback.
 *
 * This proc should be used to create inputs that invoke a callback with the user's chosen option.
 * Arguments:
 * * user - The user to show the input box to.
 * * message - The content of the input box, shown in the body of the TGUI window.
 * * title - The title of the input box, shown on the top of the TGUI window.
 * * default - The default value pre-populated in the input box.
 * * callback - The callback to be invoked when a choice is made.
 * * timeout - The timeout of the input box, after which the menu will close and qdel itself. Set to zero for no timeout.
 */
/proc/tgui_input_num_async(mob/user, message, title, default, datum/callback/callback, timeout = 60 SECONDS)
	if (istext(user))
		stack_trace("tgui_input_num_async() received text for user instead of mob")
		return
	if (!user)
		user = usr
	if (!istype(user))
		if (istype(user, /client))
			var/client/client = user
			user = client.mob
		else
			return
	var/datum/tgui_input_dialog/async/input = new(user, message, title, default, callback, timeout)
	input.input_type = "num"
	input.tgui_interact(user)

/**
 * # tgui_input_dialog
 *
 * Datum used for instantiating and using a TGUI-controlled input that prompts the user with
 * a message and a box for accepting text/message/num input.
 */
/datum/tgui_input_dialog
	/// The title of the TGUI window
	var/title
	/// The textual body of the TGUI window
	var/message
	/// The default value to initially populate the input box.
	var/initial
	/// The value that the user input into the input box, null if cancelled.
	var/choice
	/// The time at which the tgui_text_input was created, for displaying timeout progress.
	var/start_time
	/// The lifespan of the tgui_text_input, after which the window will close and delete itself.
	var/timeout
	/// Boolean field describing if the tgui_text_input was closed by the user.
	var/closed
	/// Indicates the data type we want to collect ("text", "message", "num")
	var/input_type = "text"

/datum/tgui_input_dialog/New(mob/user, message, title, default, timeout)
	src.title = title
	src.message = message
	// TODO - Do we need to sanitize the initial value for illegal characters?
	src.initial = default
	if (timeout)
		src.timeout = timeout
		start_time = world.time
		QDEL_IN(src, timeout)

/datum/tgui_input_dialog/Destroy(force, ...)
	SStgui.close_uis(src)
	. = ..()

/**
 * Waits for a user's response to the tgui_text_input's prompt before returning. Returns early if
 * the window was closed by the user.
 */
/datum/tgui_input_dialog/proc/wait()
	while (!choice && !closed)
		stoplag(1)

/datum/tgui_input_dialog/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "InputModal")
		ui.open()

/datum/tgui_input_dialog/tgui_close(mob/user)
	. = ..()
	closed = TRUE

/datum/tgui_input_dialog/tgui_state(mob/user)
	return GLOB.tgui_always_state

/datum/tgui_input_dialog/tgui_static_data(mob/user)
	. = list(
		"title" = title,
		"message" = message,
		"initial" = initial,
		"input_type" = input_type
	)

/datum/tgui_input_dialog/tgui_data(mob/user)
	. = list()
	if(timeout)
		.["timeout"] = clamp((timeout - (world.time - start_time) - 1 SECONDS) / (timeout - 1 SECONDS), 0, 1)

/datum/tgui_input_dialog/tgui_act(action, list/params)
	. = ..()
	if (.)
		return
	switch(action)
		if("choose")
			set_choice(params["choice"])
			if(isnull(src.choice))
				return
			SStgui.close_uis(src)
			return TRUE
		if("cancel")
			SStgui.close_uis(src)
			closed = TRUE
			return TRUE

/datum/tgui_input_dialog/proc/set_choice(choice)
	if(input_type == "num")
		src.choice = text2num(choice)
		return
	src.choice = choice

/**
 * # async tgui_text_input
 *
 * An asynchronous version of tgui_text_input to be used with callbacks instead of waiting on user responses.
 */
/datum/tgui_input_dialog/async
	/// The callback to be invoked by the tgui_text_input upon having a choice made.
	var/datum/callback/callback

/datum/tgui_input_dialog/async/New(mob/user, message, title, default, callback, timeout)
	..(user, title, message, default, timeout)
	src.callback = callback

/datum/tgui_input_dialog/async/Destroy(force, ...)
	QDEL_NULL(callback)
	. = ..()

/datum/tgui_input_dialog/async/tgui_close(mob/user)
	. = ..()
	qdel(src)

/datum/tgui_input_dialog/async/set_choice(choice)
	. = ..()
	if(!isnull(src.choice))
		callback?.InvokeAsync(src.choice)

/datum/tgui_input_dialog/async/wait()
	return
