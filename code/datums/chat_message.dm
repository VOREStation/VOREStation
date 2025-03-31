#define CHAT_MESSAGE_SPAWN_TIME		0.2 SECONDS
#define CHAT_MESSAGE_LIFESPAN		5 SECONDS
#define CHAT_MESSAGE_EOL_FADE		0.7 SECONDS
#define CHAT_MESSAGE_GRACE_PERIOD	0.2 SECONDS
#define CHAT_MESSAGE_EXP_DECAY		0.8 // Messages decay at pow(factor, idx in stack)
#define CHAT_MESSAGE_HEIGHT_DECAY	0.7 // Increase message decay based on the height of the message
#define CHAT_MESSAGE_APPROX_LHEIGHT	11 // Approximate height in pixels of an 'average' line, used for height decay

#define CHAT_MESSAGE_WIDTH			96 // pixels
#define CHAT_MESSAGE_EXT_WIDTH		128
#define CHAT_MESSAGE_LENGTH			68 // characters
#define CHAT_MESSAGE_EXT_LENGTH		150

#define CHAT_MESSAGE_MOB			1
#define CHAT_MESSAGE_OBJ			2
#define WXH_TO_HEIGHT(x)			text2num(copytext((x), findtextEx((x), "x") + 1)) // thanks lummox

#define CHAT_RUNE_EMOTE				0x1
#define CHAT_RUNE_RADIO				0x2

/**
 * # Chat Message Overlay
 *
 * Datum for generating a message overlay on the map
 * Ported from TGStation; https://github.com/tgstation/tgstation/pull/50608/, author:  bobbahbrown
 */

// Cached runechat icon
var/list/runechat_image_cache = list()


/hook/startup/proc/runechat_images()
	var/image/radio_image = image('icons/UI_Icons/chat/chat_icons.dmi', icon_state = "radio")
	runechat_image_cache["radio"] = radio_image

	var/image/emote_image = image('icons/UI_Icons/chat/chat_icons.dmi', icon_state = "emote")
	runechat_image_cache["emote"] = emote_image

	return TRUE

/datum/chatmessage
	/// The visual element of the chat messsage
	var/image/message
	/// The location in which the message is appearing
	var/atom/message_loc
	/// The client who heard this message
	var/client/owned_by
	/// Contains the scheduled destruction time
	var/scheduled_destruction
	/// Contains the approximate amount of lines for height decay
	var/approx_lines
	/// If we are currently processing animation and cleanup at EOL
	var/ending_life
	/// When we started animating the message
	var/animate_start = 0
	/// Our animation lifespan, how long this message will last
	var/animate_lifespan = 0
	/// Callback to finish_image_generation passed to SSrunechat
	var/datum/callback/finish_callback


/**
 * Constructs a chat message overlay
 *
 * Arguments:
 * * text - The text content of the overlay
 * * target - The target atom to display the overlay at
 * * owner - The mob that owns this overlay, only this mob will be able to view it
 * * extra_classes - Extra classes to apply to the span that holds the text
 * * lifespan - The lifespan of the message in deciseconds
 */
/datum/chatmessage/New(text, atom/target, mob/owner, list/extra_classes = null, lifespan = CHAT_MESSAGE_LIFESPAN)
	. = ..()
	if(!istype(target))
		CRASH("Invalid target given for chatmessage")
	if(!istype(owner) || QDELETED(owner) || !owner.client)
		stack_trace("/datum/chatmessage created with [isnull(owner) ? "null" : "invalid"] mob owner")
		qdel(src)
		return
	INVOKE_ASYNC(src, PROC_REF(generate_image), text, target, owner, extra_classes, lifespan)

/datum/chatmessage/Destroy()
	if(istype(owned_by, /client)) // hopefully the PARENT_QDELETING on client should beat this if it's a disconnect
		UnregisterSignal(owned_by, COMSIG_PARENT_QDELETING)
		if(owned_by.seen_messages)
			LAZYREMOVEASSOC(owned_by.seen_messages, message_loc, src)
		owned_by.images.Remove(message)

	if (finish_callback)
		SSrunechat.message_queue -= finish_callback
		finish_callback = null

	owned_by = null
	message_loc = null
	message = null
	return ..()

/**
 * Generates a chat message image representation
 *
 * Arguments:
 * * text - The text content of the overlay
 * * target - The target atom to display the overlay at
 * * owner - The mob that owns this overlay, only this mob will be able to view it
 * * extra_classes - Extra classes to apply to the span that holds the text
 * * lifespan - The lifespan of the message in deciseconds
 */
/datum/chatmessage/proc/generate_image(text, atom/target, mob/owner, list/extra_classes, lifespan)

	if(!target || !owner)
		qdel(src)
		return

	// Register client who owns this message
	owned_by = owner.client
	RegisterSignal(owned_by, COMSIG_PARENT_QDELETING, PROC_REF(unregister_qdel_self)) // this should only call owned_by if the client is destroyed

	var/extra_length = owned_by.prefs?.read_preference(/datum/preference/toggle/runechat_long_messages)
	var/maxlen = extra_length ? CHAT_MESSAGE_EXT_LENGTH : CHAT_MESSAGE_LENGTH

	// Clip message
	if(length_char(text) > maxlen)
		text = copytext_char(text, 1, maxlen + 1) + "..." // BYOND index moment

	// Calculate target color if not already present
	if(!target.chat_color || target.chat_color_name != target.name)
		target.chat_color = colorize_string(target.name)
		target.chat_color_darkened = colorize_string(target.name, 0.85, 0.85)
		target.chat_color_name = target.name

		// Always force it back to a pref if they have one
		if(ismob(target))
			var/mob/M = target
			if(M?.client?.prefs && M.client.prefs.runechat_color != COLOR_BLACK)
				target.chat_color = M.client.prefs.runechat_color
				target.chat_color_darkened = M.client.prefs.runechat_color

	// Get rid of any URL schemes that might cause BYOND to automatically wrap something in an anchor tag
	var/static/regex/url_scheme = new(@"[A-Za-z][A-Za-z0-9+-\.]*:\/\/", "g")
	text = replacetext(text, url_scheme, "")

	// Reject whitespace
	var/static/regex/whitespace = new(@"^\s*$")
	if(whitespace.Find(text))
		qdel(src)
		return

	// Non mobs speakers can be small
	if(!ismob(target))
		extra_classes |= "small"

	// If we heard our name, it's important
	// Differnt from our own system of name emphasis, maybe unify
	var/list/names = splittext(owner.name, " ")
	for (var/word in names)
		text = replacetext(text, word, span_bold("[word]"))

	var/list/prefixes

	// Append prefixes
	if(extra_classes.Find("virtual-speaker"))
		LAZYADD(prefixes, "[icon2html(runechat_image_cache["radio"],owner.client)]")
	if(extra_classes.Find("emote"))
		// Icon on both ends?
		//var/image/I = runechat_image_cache["emote"]
		//text = "icon2html(I)[text]icon2html(I)"

		// Icon on one end?
		//LAZYADD(prefixes, "icon2html(runechat_image_cache["emote")]")

		// Asterisks instead?
		text = "*&nbsp;[text]&nbsp;*"

	text = "[prefixes?.Join("&nbsp;")][text]"

	text = encode_html_emphasis(text)

	// We dim italicized text to make it more distinguishable from regular text
	var/tgt_color = extra_classes.Find("italics") ? target.chat_color_darkened : target.chat_color

	// Approximate text height
	var/complete_text = "<span class='center maptext [extra_classes != null ? extra_classes.Join(" ") : ""]' style='color: [tgt_color];'>[text]</span>"

	var/msgwidth = extra_length ? CHAT_MESSAGE_EXT_WIDTH : CHAT_MESSAGE_WIDTH
	var/mheight = WXH_TO_HEIGHT(owned_by.MeasureText(complete_text, null, msgwidth))

	if(!VERB_SHOULD_YIELD)
		return finish_image_generation(msgwidth, mheight, target, owner, complete_text, lifespan)

	finish_callback = CALLBACK(src, PROC_REF(finish_image_generation), msgwidth, mheight, target, owner, complete_text, lifespan)
	SSrunechat.message_queue += finish_callback

/datum/chatmessage/proc/finish_image_generation(msgwidth, mheight, atom/target, mob/owner, complete_text, lifespan)
	finish_callback = null
	var/rough_time = REALTIMEOFDAY

	approx_lines = max(1, mheight / CHAT_MESSAGE_APPROX_LHEIGHT)
	var/starting_height = target.runechat_y_offset()

	// Translate any existing messages upwards, apply exponential decay factors to timers
	message_loc = target.runechat_holder(src)
	RegisterSignal(message_loc, COMSIG_PARENT_QDELETING, PROC_REF(qdel_self))
	if(owned_by && owned_by.seen_messages)
		var/idx = 1
		var/combined_height = approx_lines
		for(var/datum/chatmessage/m as anything in owned_by.seen_messages[message_loc])
			combined_height += m.approx_lines

			var/time_spent = rough_time - m.animate_start
			var/time_before_fade = m.animate_lifespan - CHAT_MESSAGE_EOL_FADE

			// When choosing to update the remaining time we have to be careful not to update the
			// scheduled time once the EOL has been executed.
			var/continuing = NONE
			if (time_spent >= time_before_fade)
				if(m.message.pixel_y < starting_height)
					var/max_height = m.message.pixel_y + m.approx_lines * CHAT_MESSAGE_APPROX_LHEIGHT - starting_height
					if(max_height > 0)
						animate(m.message, pixel_y = m.message.pixel_y + max_height, time = CHAT_MESSAGE_SPAWN_TIME, flags = continuing | ANIMATION_PARALLEL)
						continuing |= ANIMATION_CONTINUE
				else if(mheight + starting_height >= m.message.pixel_y)
					animate(m.message, pixel_y = m.message.pixel_y + mheight, time = CHAT_MESSAGE_SPAWN_TIME, flags = continuing | ANIMATION_PARALLEL)
					continuing |= ANIMATION_CONTINUE
				continue

			var/remaining_time = time_before_fade * (CHAT_MESSAGE_EXP_DECAY ** idx++) * (CHAT_MESSAGE_HEIGHT_DECAY ** combined_height)
			// Ensure we don't accidentially spike alpha up or something silly like that
			m.message.alpha = m.get_current_alpha(time_spent)
			if(remaining_time > 0)
				if(time_spent < CHAT_MESSAGE_SPAWN_TIME)
					// We haven't even had the time to fade in yet!
					animate(m.message, alpha = 255, CHAT_MESSAGE_SPAWN_TIME - time_spent, flags=continuing)
					continuing |= ANIMATION_CONTINUE
				// Stay faded in for a while, then
				animate(m.message, alpha = 255, time = remaining_time, flags=continuing)
				continuing |= ANIMATION_CONTINUE
				// Fade out
				animate(m.message, alpha = 0, time = CHAT_MESSAGE_EOL_FADE, flags=continuing)
				continuing |= ANIMATION_CONTINUE
				m.animate_lifespan = remaining_time + CHAT_MESSAGE_EOL_FADE
			else
				// Your time has come my son
				animate(m.message, alpha = 0, time = CHAT_MESSAGE_EOL_FADE, flags=continuing)
				continuing |= ANIMATION_CONTINUE
			// We run this after the alpha animate, because we don't want to interrup it, but also don't want to block it by running first
			// Sooo instead we do this. bit messy but it fuckin works
			if(m.message.pixel_y < starting_height)
				var/max_height = m.message.pixel_y + m.approx_lines * CHAT_MESSAGE_APPROX_LHEIGHT - starting_height
				if(max_height > 0)
					animate(m.message, pixel_y = m.message.pixel_y + max_height, time = CHAT_MESSAGE_SPAWN_TIME, flags = continuing | ANIMATION_PARALLEL)
					continuing |= ANIMATION_CONTINUE
			else if(mheight + starting_height >= m.message.pixel_y)
				animate(m.message, pixel_y = m.message.pixel_y + mheight, time = CHAT_MESSAGE_SPAWN_TIME, flags = continuing | ANIMATION_PARALLEL)
				continuing |= ANIMATION_CONTINUE

	// Build message image
	message = image(loc = message_loc, layer = ABOVE_MOB_LAYER)
	message.plane = PLANE_RUNECHAT
	message.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA | KEEP_APART
	message.alpha = 0
	message.maptext_width = msgwidth
	message.maptext_height = mheight
	message.pixel_x = message_loc.runechat_x_offset(msgwidth, mheight)
	message.pixel_y = starting_height
	message.maptext = complete_text


	animate_start = rough_time
	animate_lifespan = lifespan

	if(!owner)
		qdel(src)
		return
	if(owner.contains(target)) // Special case, holding an atom speaking (pAI, recorder...)
		message.plane = PLANE_PLAYER_HUD_ABOVE

	// View the message
	LAZYADDASSOCLIST(owned_by.seen_messages, message_loc, src)
	owned_by.images |= message

	// Fade in
	animate(message, alpha = 255, time = CHAT_MESSAGE_SPAWN_TIME)
	var/time_before_fade = lifespan - CHAT_MESSAGE_SPAWN_TIME - CHAT_MESSAGE_EOL_FADE
	// Stay faded in
	animate(alpha = 255, time = time_before_fade)
	// Fade out
	animate(alpha = 0, time = CHAT_MESSAGE_EOL_FADE)

	// Register with the runechat SS to handle destruction
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(qdel), src), lifespan + CHAT_MESSAGE_GRACE_PERIOD, TIMER_DELETE_ME, SSrunechat)

/datum/chatmessage/proc/unregister_qdel_self()  // this should only call owned_by if the client is destroyed
	SIGNAL_HANDLER
	UnregisterSignal(owned_by, COMSIG_PARENT_QDELETING)
	owned_by = null
	qdel_self()

/datum/chatmessage/proc/get_current_alpha(time_spent)
	if(time_spent < CHAT_MESSAGE_SPAWN_TIME)
		return (time_spent / CHAT_MESSAGE_SPAWN_TIME) * 255

	var/time_before_fade = animate_lifespan - CHAT_MESSAGE_EOL_FADE
	if(time_spent <= time_before_fade)
		return 255

	return (1 - ((time_spent - time_before_fade) / CHAT_MESSAGE_EOL_FADE)) * 255

/**
 * Applies final animations to overlay CHAT_MESSAGE_EOL_FADE deciseconds prior to message deletion
 */
/datum/chatmessage/proc/end_of_life(fadetime = CHAT_MESSAGE_EOL_FADE)
	if(gc_destroyed || ending_life)
		return
	ending_life = TRUE
	animate(message, alpha = 0, time = fadetime, flags = ANIMATION_PARALLEL)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(qdel), src), fadetime, TIMER_DELETE_ME)

/**
 * Creates a message overlay at a defined location for a given speaker
 *
 * Arguments:
 * * speaker - The atom who is saying this message
 * * message - The text content of the message
 * * italics - Decides if this should be small or not, as generally italics text are for whisper/radio overhear
 * * existing_extra_classes - Additional classes to add to the message
 */
/mob/proc/create_chat_message(atom/movable/speaker, message, italics, list/existing_extra_classes, audible = TRUE)
	if(!client)
		return

	// Source Deleting
	if(QDELETED(speaker))
		return
	// Doesn't want to hear
	if(ismob(speaker) && !client.prefs?.read_preference(/datum/preference/toggle/runechat_mob))
		return
	// I know the pref is 'obj' but people dunno what turfs are
	else if(!client.prefs?.read_preference(/datum/preference/toggle/runechat_obj))
		return

	// Incapable of receiving
	if((audible && is_deaf()) || (!audible && is_blind()))
		return

	// Check for virtual speakers (aka hearing a message through a radio)
	if(existing_extra_classes.Find("radio"))
		return

	/* Not currently necessary
	message = strip_html_properly(message)
	if(!message)
		return
 */

	var/list/extra_classes = list()
	extra_classes += existing_extra_classes

	if(italics)
		extra_classes |= "italics"

	if(client.prefs?.read_preference(/datum/preference/toggle/runechat_border))
		extra_classes |= "black_outline"

	var/dist = get_dist(src, speaker)
	switch (dist)
		if(4 to 5)
			extra_classes |= "small"
		if(5 to 16)
			extra_classes |= "very_small"

	// Display visual above source
	new /datum/chatmessage(message, speaker, src, extra_classes)

// Tweak these defines to change the available color ranges
#define CM_COLOR_SAT_MIN	0.6
#define CM_COLOR_SAT_MAX	0.95
#define CM_COLOR_LUM_MIN	0.70
#define CM_COLOR_LUM_MAX	0.90

/**
 * Gets a color for a name, will return the same color for a given string consistently within a round.atom
 *
 * Note that this proc aims to produce pastel-ish colors using the HSL colorspace. These seem to be favorable for displaying on the map.
 *
 * Arguments:
 * * name - The name to generate a color for
 * * sat_shift - A value between 0 and 1 that will be multiplied against the saturation
 * * lum_shift - A value between 0 and 1 that will be multiplied against the luminescence
 */
/datum/chatmessage/proc/colorize_string(name, sat_shift = 1, lum_shift = 1)
	// seed to help randomness
	var/static/rseed = rand(1,26)

	// get hsl using the selected 6 characters of the md5 hash
	var/hash = copytext(md5(name + "[world_startup_time]"), rseed, rseed + 6)
	var/h = hex2num(copytext(hash, 1, 3)) * (360 / 255)
	var/s = (hex2num(copytext(hash, 3, 5)) >> 2) * ((CM_COLOR_SAT_MAX - CM_COLOR_SAT_MIN) / 63) + CM_COLOR_SAT_MIN
	var/l = (hex2num(copytext(hash, 5, 7)) >> 2) * ((CM_COLOR_LUM_MAX - CM_COLOR_LUM_MIN) / 63) + CM_COLOR_LUM_MIN

	// adjust for shifts
	s *= clamp(sat_shift, 0, 1)
	l *= clamp(lum_shift, 0, 1)

	// convert to rgba
	var/h_int = round(h/60) // mapping each section of H to 60 degree sections
	var/c = (1 - abs(2 * l - 1)) * s
	var/x = c * (1 - abs((h / 60) % 2 - 1))
	var/m = l - c * 0.5
	x = (x + m) * 255
	c = (c + m) * 255
	m *= 255
	switch(h_int)
		if(0)
			return rgb(c,x,m)
		if(1)
			return rgb(x,c,m)
		if(2)
			return rgb(m,c,x)
		if(3)
			return rgb(m,x,c)
		if(4)
			return rgb(x,m,c)
		if(5)
			return rgb(c,m,x)

#undef CM_COLOR_SAT_MIN
#undef CM_COLOR_SAT_MAX
#undef CM_COLOR_LUM_MIN
#undef CM_COLOR_LUM_MAX

/atom/proc/runechat_message(message, range = world.view, italics, list/classes = list(), audible = TRUE, list/specific_viewers)
	var/hearing_mobs
	if(islist(specific_viewers))
		hearing_mobs = specific_viewers.Copy()
	else
		var/list/hear = get_mobs_and_objs_in_view_fast(get_turf(src), range, remote_ghosts = FALSE)
		hearing_mobs = hear["mobs"]

	for(var/mob/M as anything in hearing_mobs)
		if(!M?.client)
			continue
		M.create_chat_message(src, message, italics, classes, audible)

// Allows you to specify your desired offset for messages from yourself
/atom/proc/runechat_x_offset(width, height)
	return (width - world.icon_size) * -0.5

/atom/proc/runechat_y_offset()
	return maptext_height

/atom/movable/runechat_x_offset(width, height)
	return (width - bound_width) * -0.5 + get_oversized_icon_offsets()["x"]

/atom/movable/runechat_y_offset()
	return ..() + get_oversized_icon_offsets()["y"]

/* Nothing special
/mob/runechat_x_offset(width, height)
	return (width - bound_width) * -0.5
*/

/mob/runechat_y_offset()
	return ..()*size_multiplier

// Allows you to specify a different attachment point for messages from yourself
/atom/proc/runechat_holder(datum/chatmessage/CM)
	return src

/mob/runechat_holder(datum/chatmessage/CM)
	if(istype(loc, /obj/item/holder))
		return loc
	return ..()

#undef CHAT_MESSAGE_SPAWN_TIME
#undef CHAT_MESSAGE_LIFESPAN
#undef CHAT_MESSAGE_EOL_FADE
#undef CHAT_MESSAGE_GRACE_PERIOD
#undef CHAT_MESSAGE_EXP_DECAY
#undef CHAT_MESSAGE_HEIGHT_DECAY
#undef CHAT_MESSAGE_APPROX_LHEIGHT

#undef CHAT_MESSAGE_WIDTH
#undef CHAT_MESSAGE_EXT_WIDTH
#undef CHAT_MESSAGE_LENGTH
#undef CHAT_MESSAGE_EXT_LENGTH

#undef CHAT_MESSAGE_MOB
#undef CHAT_MESSAGE_OBJ
#undef WXH_TO_HEIGHT

#undef CHAT_RUNE_EMOTE
#undef CHAT_RUNE_RADIO
