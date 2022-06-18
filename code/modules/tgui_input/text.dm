/**
 * Creates a TGUI window with a text input. Returns the user's response.
 *
 * This proc should be used to create windows for text entry that the caller will wait for a response from.
 * If tgui fancy chat is turned off: Will return a normal input. If max_length is specified, will return
 * stripped_multiline_input.
 *
 * Arguments:
 * * user - The user to show the text input to.
 * * message - The content of the text input, shown in the body of the TGUI window.
 * * title - The title of the text input modal, shown on the top of the TGUI window.
 * * default - The default (or current) value, shown as a placeholder.
 * * max_length - Specifies a max length for input. MAX_MESSAGE_LEN is default (1024)
 * * multiline -  Bool that determines if the input box is much larger. Good for large messages, laws, etc.
 * * encode - Toggling this determines if input is filtered via html_encode. Setting this to FALSE gives raw input.
 * * timeout - The timeout of the textbox, after which the modal will close and qdel itself. Set to zero for no timeout.
 */
/proc/tgui_input_text(mob/user, message = "", title = "Text Input", default, max_length = MAX_MESSAGE_LEN, multiline = FALSE, encode = TRUE, timeout = 0)
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
	// Client does NOT have tgui_input on: Returns regular input
	if(!usr.client.prefs.tgui_input_mode)
		if(encode)
			if(multiline)
				return stripped_multiline_input(user, message, title, default, max_length)
			else
				return stripped_input(user, message, title, default, max_length)
		else
			if(multiline)
				return input(user, message, title, default) as message|null
			else
				return input(user, message, title, default) as text|null
	var/datum/tgui_input_text/text_input = new(user, message, title, default, max_length, multiline, encode, timeout)
	text_input.tgui_interact(user)
	text_input.wait()
	if (text_input)
		. = text_input.entry
		qdel(text_input)

/**
 * tgui_input_text
 *
 * Datum used for instantiating and using a TGUI-controlled text input that prompts the user with
 * a message and has an input for text entry.
 */
/datum/tgui_input_text
	/// Boolean field describing if the tgui_input_text was closed by the user.
	var/closed
	/// The default (or current) value, shown as a default.
	var/default
	/// Whether the input should be stripped using html_encode
	var/encode
	/// The entry that the user has return_typed in.
	var/entry
	/// The maximum length for text entry
	var/max_length
	/// The prompt's body, if any, of the TGUI window.
	var/message
	/// Multiline input for larger input boxes.
	var/multiline
	/// The time at which the text input was created, for displaying timeout progress.
	var/start_time
	/// The lifespan of the text input, after which the window will close and delete itself.
	var/timeout
	/// The title of the TGUI window
	var/title

/datum/tgui_input_text/New(mob/user, message, title, default, max_length, multiline, encode, timeout)
	src.default = default
	src.encode = encode
	src.max_length = max_length
	src.message = message
	src.multiline = multiline
	src.title = title
	if (timeout)
		src.timeout = timeout
		start_time = world.time
		QDEL_IN(src, timeout)

/datum/tgui_input_text/Destroy(force, ...)
	SStgui.close_uis(src)
	. = ..()

/**
 * Waits for a user's response to the tgui_text_input's prompt before returning. Returns early if
 * the window was closed by the user.
 */
/datum/tgui_input_text/proc/wait()
	while (!entry && !closed)
		stoplag(1)

/datum/tgui_input_text/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "TextInputModal")
		ui.open()

/datum/tgui_input_text/tgui_close(mob/user)
	. = ..()
	closed = TRUE

/datum/tgui_input_text/tgui_state(mob/user)
	return GLOB.tgui_always_state

/datum/tgui_input_text/tgui_static_data(mob/user)
	var/list/data = list()
	data["large_buttons"] = usr.client.prefs.tgui_large_buttons
	data["max_length"] = max_length
	data["message"] = message
	data["multiline"] = multiline
	data["placeholder"] = default // Default is a reserved keyword
	data["large_buttons"] = usr.client.prefs.tgui_swapped_buttons
	data["title"] = title
	return data

/datum/tgui_input_text/tgui_data(mob/user)
	var/list/data = list()
	if(timeout)
		.["timeout"] = clamp((timeout - (world.time - start_time) - 1 SECONDS) / (timeout - 1 SECONDS), 0, 1)
	return data

/datum/tgui_input_text/tgui_act(action, list/params)
	. = ..()
	if (.)
		return
	switch(action)
		if("submit")
			if(length(params["entry"]) > max_length)
				return
			if(encode && (length(html_encode(params["entry"])) > max_length))
				to_chat(usr, span_notice("Your message was clipped due to special character usage."))
			set_entry(params["entry"])
			closed = TRUE
			SStgui.close_uis(src)
			return TRUE
		if("cancel")
			SStgui.close_uis(src)
			closed = TRUE
			return TRUE

/datum/tgui_input_text/proc/set_entry(entry)
	if(!isnull(entry))
		var/converted_entry = encode ? html_encode(entry) : entry
		src.entry = trim(converted_entry, max_length)

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
/proc/tgui_input_text_async(mob/user, message, title, default, datum/callback/callback, max_length, multiline, encode, timeout = 60 SECONDS)
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
	var/datum/tgui_input_text/async/input = new(user, message, title, default, callback, max_length, multiline, encode, timeout)
	input.tgui_interact(user)

/**
 * # async tgui_text_input
 *
 * An asynchronous version of tgui_text_input to be used with callbacks instead of waiting on user responses.
 */
/datum/tgui_input_text/async
	/// The callback to be invoked by the tgui_text_input upon having a choice made.
	var/datum/callback/callback

/datum/tgui_input_text/async/New(mob/user, message, title, default, callback, max_length, multiline, encode, timeout)
	..(user, title, message, default, max_length, multiline, encode, timeout)
	src.callback = callback

/datum/tgui_input_text/async/Destroy(force, ...)
	QDEL_NULL(callback)
	. = ..()

/datum/tgui_input_text/async/tgui_close(mob/user)
	. = ..()
	qdel(src)

/datum/tgui_input_text/async/set_entry(entry)
	. = ..()
	if(!isnull(src.entry))
		callback?.InvokeAsync(src.entry)

/datum/tgui_input_text/async/wait()
	return
