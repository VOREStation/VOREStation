var/global/list/env_messages = list()

/obj/effect/env_message
	name = "Env message"
	icon = 'icons/effects/env_message.dmi'
	icon_state = "env_message"
	plane = PLANE_LIGHTING_ABOVE
	mouse_opacity = TRUE
	anchored = TRUE
	var/list/message_list = list()
	var/combined_message = DEVELOPER_WARNING_NAME

/obj/effect/env_message/Initialize(mapload)
	.=..()
	env_messages += src

/obj/effect/env_message/Destroy()
	env_messages -= src
	return ..()

/obj/effect/env_message/examine(mob/user)
	. = ..()
	for(var/tckey in message_list)
		. += message_list[tckey]

/obj/effect/env_message/proc/add_message(var/tckey, var/message)
	message_list[tckey] = message
	update_message()

/obj/effect/env_message/proc/remove_message(var/tckey)
	message_list -= tckey
	if(!message_list.len)
		qdel(src)
	else
		update_message()

/obj/effect/env_message/proc/update_message()
	combined_message = ""
	var/count = 0
	for(var/tckey in message_list)
		combined_message += message_list[tckey]
		count++
		if(!(count == message_list.len))
			combined_message += "<br><br>"

/obj/effect/env_message/MouseEntered(location, control, params)
	if(usr)
		openToolTip(user = usr, tip_src = src, params = params, title = null, content = combined_message)

	..()

/obj/effect/env_message/MouseDown()
	closeToolTip(usr) //No reason not to, really

	..()

/obj/effect/env_message/MouseExited()
	closeToolTip(usr) //No reason not to, really

	..()

/proc/clear_env_message(var/tckey)
	for(var/obj/effect/env_message/EM in env_messages)
		if(tckey in EM.message_list)
			EM.remove_message(tckey)

/mob/living/verb/create_env_message()
	set name = "Create Env Message"
	set desc = "Create an ooc message in the environment for other players to see."
	set category = "OOC"

	if(!istype(src) || !get_turf(src) || !src.ckey)
		return

	var/new_message = sanitize(tgui_input_text(src, "Type in your message. It will be displayed to players who hover over the spot where you are right now. If you already have a message somewhere, it will be removed in the process. Please refrain from abusive or deceptive messages, but otherwise, feel free to be creative!", "Env Message"))

	if(!new_message)
		return

	clear_env_message(src.ckey)

	var/ourturf = get_turf(src)

	var/obj/effect/env_message/EM = locate(/obj/effect/env_message) in ourturf

	if(!EM)
		EM = new /obj/effect/env_message(ourturf)
	EM.add_message(src.ckey, new_message)

	log_game("[key_name(src)] created an Env Message: [new_message] at ([EM.x], [EM.y], [EM.z])")

/mob/living/verb/remove_env_message()
	set name = "Remove Env Message"
	set desc = "Remove your current env message."
	set category = "OOC"

	if(!istype(src) || !src.ckey)
		return

	var/ourturf = get_turf(src)

	var/obj/effect/env_message/EM = locate(/obj/effect/env_message) in ourturf

	if(EM)
		var/answer = tgui_alert(src, "Do you want to remove this env message? (Note: Selecting 'Yes' will remove other players' messages on this tyle too. Please don't remove other players' messages for no reason. Use 'Only My Message' to remove yours only.)", "Env Message", list("Yes", "Only My Message", "No"))
		if(answer == "Yes")
			if(!(src.ckey in EM.message_list) || EM.message_list.len > 1)
				log_game("[key_name(src)] deleted an Env Message that contained other players' entries at ([EM.x], [EM.y], [EM.z])")
			qdel(EM)
		else if(answer == "Only My Message")
			clear_env_message(src.ckey)
	else
		var/answer = tgui_alert(src, "Do you want to remove your env message?", "Env Message", list("Yes", "No"))
		if(answer == "Yes")
			clear_env_message(src.ckey)

//GM tool version

/obj/effect/env_message/admin
	name = "Map message"
	icon = 'icons/effects/env_message.dmi'
	icon_state = "env_message_red"

/client/proc/create_gm_message()
	set name = "Map Message - Create"
	set desc = "Create an ooc message in the environment for other players to see."
	set category = "EventKit"

	if(!check_rights(R_FUN))
		return

	if(isnewplayer(mob))
		to_chat(src, span_warning("You must spawn or observe to place messages."))
		return

	if(!get_turf(mob) || !src.ckey)
		return

	var/new_message = sanitize(tgui_input_text(src, "Type in your message. It will be displayed to players who hover over the spot where you are right now.", "Env Message"))

	if(!new_message)
		return

	var/ourturf = get_turf(mob)

	var/obj/effect/env_message/EM = locate(/obj/effect/env_message) in ourturf

	if(!EM)
		EM = new /obj/effect/env_message/admin(ourturf)
	EM.add_message(src.ckey, new_message)

	log_game("[key_name(src)] created an Env Message: [new_message] at ([EM.x], [EM.y], [EM.z])")

/client/proc/remove_gm_message()
	set name = "Map Message - Remove"
	set desc = "Remove any env/map message."
	set category = "EventKit"

	if(!istype(src) || !src.ckey)
		return

	if(!check_rights(R_FUN))
		return

	var/list/all_map_messages = list()
	for(var/obj/effect/env_message/A in world)
		all_map_messages |= A.combined_message

	if(!all_map_messages.len)
		to_chat(src, span_warning("There are no map or env messages."))
		return

	var/mob/chosen_message = tgui_input_list(src, "Which message do you want to remove?", "Make contact", all_map_messages)
	if(!chosen_message)
		return

	for(var/obj/effect/env_message/EM in world)
		if(EM.combined_message == chosen_message)
			qdel(EM)
			log_game("[key_name(src)] deleted an Env Message that contained other players' entries at ([EM.x], [EM.y], [EM.z])")
