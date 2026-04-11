GLOBAL_LIST_EMPTY(env_messages)

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
	GLOB.env_messages += src

/obj/effect/env_message/Destroy()
	GLOB.env_messages -= src
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
	for(var/obj/effect/env_message/EM in GLOB.env_messages)
		if(tckey in EM.message_list)
			EM.remove_message(tckey)

/mob/living/verb/create_env_message()
	set name = "Create Env Message"
	set desc = "Create an ooc message in the environment for other players to see."
	set category = "OOC.Game"

	if(!istype(src) || !get_turf(src) || !src.ckey)
		return

	var/new_message = tgui_input_text(src, "Type in your message. It will be displayed to players who hover over the spot where you are right now. If you already have a message somewhere, it will be removed in the process. Please refrain from abusive or deceptive messages, but otherwise, feel free to be creative!", "Env Message", max_length = MAX_MESSAGE_LEN)

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
	set category = "OOC.Game"

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

ADMIN_VERB(create_gm_message, R_FUN, "Map Message - Create", "Create an ooc message in the environment for other players to see.", ADMIN_CATEGORY_FUN_EVENT_KIT)
	var/mob/user_mob = user.mob
	if(isnewplayer(user_mob))
		to_chat(user, span_warning("You must spawn or observe to place messages."))
		return

	if(!get_turf(user_mob))
		return

	var/new_message = tgui_input_text(user, "Type in your message. It will be displayed to players who hover over the spot where you are right now.", "Env Message", "", MAX_MESSAGE_LEN)

	if(!new_message)
		return

	var/ourturf = get_turf(user_mob)

	var/obj/effect/env_message/new_env_message = locate(/obj/effect/env_message) in ourturf

	if(!new_env_message)
		new_env_message = new /obj/effect/env_message/admin(ourturf)
	new_env_message.add_message(user.ckey, new_message)

	log_game("[key_name(user)] created an Env Message: [new_message] at ([new_env_message.x], [new_env_message.y], [new_env_message.z])")

ADMIN_VERB(remove_gm_message, R_FUN, "Map Message - Remove", "Remove any env/map message.", ADMIN_CATEGORY_FUN_EVENT_KIT)
	var/list/all_map_messages = list()
	for(var/obj/effect/env_message/available_message in world)
		all_map_messages |= available_message.combined_message

	if(!length(all_map_messages))
		to_chat(user, span_warning("There are no map or env messages."))
		return

	var/mob/chosen_message = tgui_input_list(user, "Which message do you want to remove?", "Make contact", all_map_messages)
	if(!chosen_message)
		return

	for(var/obj/effect/env_message/env_message in world)
		if(env_message.combined_message == chosen_message)
			log_game("[key_name(user)] deleted an Env Message that contained other players' entries at ([env_message.x], [env_message.y], [env_message.z])")
			qdel(env_message)
