//Datum that's initialized on first calling the client procs. It's stored in /client
//We keep a distinct names/refs list in an effort to make things speedy, and for easy checking if something is on our list.
//We manually add to list element with procs to avoid dealing with clunky global lists that might not be relevant
//and for ability to narrate from long range.
/datum/entity_narrate
	var/list/entity_names = list()
	var/list/entity_refs = list()

//Appears as a right click verb on any obj and mob within view range.
//when not right clicking we get a list to pick from in aforementioned view range.
/client/proc/add_mob_for_narration(E as obj|mob in orange(world.view))
	set name = "Narrate Entity (Add ref)"
	set desc = "Saves a reference of target mob to be called when narrating."
	set category = "Fun"

	if(!check_rights(R_FUN)) return

	//Making sure we got the list datum on our client.
	if(!entity_narrate_holder)
		entity_narrate_holder = new /datum/entity_narrate()
	if(!istype(entity_narrate_holder, /datum/entity_narrate))
		return
	var/datum/entity_narrate/holder = entity_narrate_holder

	//Added /obj functionality on top of mob. It works practically the same.
	if(istype(E, /obj))
		var/obj/O = E
		var/unique_name = tgui_input_text(usr, "Please give the entity a unique name to track internally. \
		This doesn't override how it appears in game", "tracker", O.name)
		holder.entity_names += unique_name
		holder.entity_refs[unique_name] = O
		log_and_message_admins("added [O.name] for their personal list to narrate", usr) //Logging here to avoid spam, while still safeguarding abuse

	//We require a static mob/living type to check for .client and also later on, to use the unique .say mechanics for stuttering and language
	if(istype(E, /mob/living))
		var/mob/living/L = E
		if(L.client)
			to_chat(usr, "You may not speak for players!")
			log_and_message_admins("attempted to speak for [L.ckey]'s mob", usr)
			return
		var/unique_name = tgui_input_text(usr, "Please give the entity a unique name to track internally. \
		This doesn't override how it appears in game", "tracker", L.name)
		holder.entity_names += unique_name
		holder.entity_refs[unique_name] = L
		log_and_message_admins("added [L.name] for their personal list to narrate", usr) //Logging here to avoid spam, while still safeguarding abuse

//Proc for keeping our ref list relevant, deleting mobs that are no longer relevant for our event
/client/proc/remove_mob_for_narration()
	set name = "Narrate Entity (Remove ref)"
	set desc = "Remove mobs you're no longer narrating from your list for easier work."
	set category = "Fun"

	if(!check_rights(R_FUN)) return

	if(!entity_narrate_holder)
		entity_narrate_holder = new /datum/entity_narrate()
		to_chat(usr, "No references were added yet! First add references!")
		return
	if(!istype(entity_narrate_holder, /datum/entity_narrate))
		return
	var/datum/entity_narrate/holder = entity_narrate_holder

	var/removekey = tgui_input_list(usr, "Choose which entity to remove", "remove reference", holder.entity_names, null)
	if(removekey)
		holder.entity_refs -= removekey
		holder.entity_names -= removekey

//Planned to have TGUI functionality
//For now brings up a list of all entities on our reference list and gives us the option to choose what we wanna do
//using TGUI/Byond list/alert inputs
/client/proc/narrate_mob()
	set name = "Narrate Entity (Interface)"
	set desc = "Send either a visible or audiable message through your chosen entities using an interface"
	set category = "Fun"

	if(!check_rights(R_FUN)) return

	if(!entity_narrate_holder)
		entity_narrate_holder = new /datum/entity_narrate()
		to_chat(usr, "No references were added yet! First add references!")
		return
	if(!istype(entity_narrate_holder, /datum/entity_narrate))
		return
	var/datum/entity_narrate/holder = entity_narrate_holder


	var/which_entity = tgui_input_list(usr, "Choose which mob to narrate", "Narrate mob", holder.entity_names, null)
	if(!which_entity) return
	var/mode = tgui_alert(usr, "Speak or emote?", "mode", list("Speak", "Emote", "Cancel"))

	//Separate definition for mob/living and /obj due to .say() code allowing us to engage with languages, stuttering etc
	//We also need this to check for .client
	if(istype(holder.entity_refs[which_entity], /mob/living))
		var/mob/living/our_entity = holder.entity_refs[which_entity]
		if(our_entity.client) //Making sure we can't speak for players
			to_chat(usr, SPAN_NOTICE("You cannot narrate for a player mob!"))
			log_and_message_admins("attempted to speak for [our_entity.ckey]'s mob", usr)
			return
		if(mode == "Speak")
			var/content = tgui_input_text(usr, "Input what you want [our_entity] to say", "narrate", null)
			if(content)
				our_entity.say(content)
		else if(mode == "Emote")
			var/content = tgui_input_text(usr, "Input what you want [our_entity] to do", "narrate", null)
			if(content)
				our_entity.custom_emote(VISIBLE_MESSAGE, content)
		else
			return

	//This does cost us some code duplication, but I think it's worth it.
	//furthermore, objs require the usr to specify the verb when speaking, otherwise it looks like an emote.
	else if(istype(holder.entity_refs[which_entity], /obj))
		var/obj/our_entity = holder.entity_refs[which_entity]
		if(mode == "Speak")
			var/content = tgui_input_text(usr, "Input what you want [our_entity] to say", "narrate", null)
			if(content)
				our_entity.audible_message("[our_entity.name] [content]")
		else if(mode == "Emote")
			var/content = tgui_input_text(usr, "Input what you want [our_entity] to do", "narrate", null)
			if(content)
				our_entity.visible_message("[our_entity.name] [content]")
		else
			return

/client/proc/narrate_mob_args(name as text, mode as text, message as text)
	set name = "Narrate Mob"
	set desc = "Narrate entities using positional arguments. Name should be as saved in ref list, mode should be Speak or Emote, follow with message"
	set category = "Fun"



	if(!check_rights(R_FUN)) return

	if(!entity_narrate_holder)
		entity_narrate_holder = new /datum/entity_narrate()
		to_chat(usr, "No references were added yet! First add references!")
		return
	if(!istype(entity_narrate_holder, /datum/entity_narrate))
		return
	var/datum/entity_narrate/holder = entity_narrate_holder

	if(!(mode in list("Speak", "Emote")))
		to_chat(usr, SPAN_NOTICE("Valid modes are 'Speak' and 'Emote'."))
		return
	if(!holder.entity_refs[name])
		to_chat(usr, SPAN_NOTICE("[name] not in saved references!"))

	//Separate definition for mob/living and /obj due to .say() code allowing us to engage with languages, stuttering etc
	//We also need this so we can check for .client
	if(istype(holder.entity_refs[name], /mob/living))
		var/mob/living/our_entity = holder.entity_refs[name]
		if(our_entity.client) //Making sure we can't speak for players
			to_chat(usr, SPAN_NOTICE("Cannot narrate mobs with active clients!"))
			log_and_message_admins("attempted to speak for [our_entity.ckey]'s mob", usr)
			return
		if(!message)
			message = tgui_input_text(usr, "Input what you want [our_entity] to [mode]", "narrate", null)
		if(message && mode == "Speak")
			our_entity.say(message)
		else if(message && mode == "Emote")
			our_entity.custom_emote(VISIBLE_MESSAGE, message)
		else
			return

	//This does cost us some code duplication, but I think it's worth it.
	//furthermore, objs require the usr to specify the verb when speaking, otherwise it looks like an emote.
	else if(istype(holder.entity_refs[name], /obj))
		var/obj/our_entity = holder.entity_refs[name]
		if(!message)
			message = tgui_input_text(usr, "Input what you want [our_entity] to [mode]", "narrate", null)
		if(message && mode == "Speak")
			our_entity.audible_message("[our_entity.name] [message]")
		else if(message && mode == "Emote")
			our_entity.visible_message("[our_entity.name] [message]")
		else
			return
