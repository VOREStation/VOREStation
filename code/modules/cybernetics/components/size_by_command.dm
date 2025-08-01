/datum/component/resize_by_verbal_command
	var/obj/item/endoware/endoware //endoware we're attached to

	var/list/whitelisted_mobs //who can send us commands, if any?

	var/keyword_toggle = "implant-toggle"
	var/keyword_grow = "grow"
	var/keyword_shrink = "shrink"
	var/keyword_exact = "resize"

	var/active = TRUE

//added to a human
/datum/component/resize_by_verbal_command/Initialize(var/list/to_whitelist, var/obj/item/endoware/assigned_endoware) //doesn't need an endoware
	endoware = assigned_endoware
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE
	whitelisted_mobs = to_whitelist
	RegisterSignal(parent,COMSIG_MOB_RECIEVE_MESSAGE,PROC_REF(heard_words))
	if(endoware)
		RegisterSignal(endoware,COMSIG_ATOM_EMP_ACT,PROC_REF(emp_fired))

/datum/component/resize_by_verbal_command/Destroy(force)
	if(parent)
		UnregisterSignal(parent,COMSIG_MOB_RECIEVE_MESSAGE)
	if(endoware)
		UnregisterSignal(endoware,COMSIG_ATOM_EMP_ACT)
	. = ..()

/datum/component/resize_by_verbal_command/proc/heard_words(var/datum/source,var/speaker, var/message,var/message_type,var/alt_message,var/alt_type)
	to_chat(world,"Source:[source]| Speaker:[speaker]| Message:[message]| message type:[message_type]| alt_message[alt_message]| alt_type[alt_type]")
	if(LAZYLEN(whitelisted_mobs))
		if(speaker in whitelisted_mobs)
			parse_msg(message)
	else
		parse_msg(message)

/datum/component/resize_by_verbal_command/proc/parse_msg(msg)
	var/mob/living/H = parent
	if(findtext(msg,keyword_toggle))
		active = !active
	if(active)
		if(findtext(msg,keyword_grow))
			H.resize(min(H.size_multiplier*1.5, RESIZE_MAXIMUM))
		else if(findtext(msg,keyword_shrink))
			H.resize(max(H.size_multiplier*0.5, RESIZE_MINIMUM))
		else if(findtext(msg, keyword_exact))
			var/static/regex/size_mult = new/regex("\\d+")
			if(size_mult.Find(msg))
				var/resizing_value = text2num(size_mult.match)
				H.resize(CLAMP(resizing_value/100 , RESIZE_MINIMUM, RESIZE_MAXIMUM))
		if(endoware)
			endoware.activated_externally() //we DID activate it.

/datum/component/resize_by_verbal_command/proc/emp_fired(var/source, var/intensity)
	var/newsize = pick(RESIZE_HUGE,RESIZE_BIG,RESIZE_NORMAL,RESIZE_SMALL,RESIZE_TINY,RESIZE_A_HUGEBIG,RESIZE_A_BIGNORMAL,RESIZE_A_NORMALSMALL,RESIZE_A_SMALLTINY)
	var/mob/living/H = parent
	H.resize(newsize)
	to_chat(world,"EMP FIRED")
