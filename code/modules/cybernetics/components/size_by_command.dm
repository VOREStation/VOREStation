/datum/component/resize_by_verbal_command
	var/obj/item/endoware/endoware //endoware we're attached to

	var/list/whitelisted_mobs //who can send us commands, if any?


//added to a human
/datum/component/resize_by_verbal_command/Initialize(var/list/to_whitelist, var/obj/item/endoware/endoware)
	if(!ismob(parent))
		return COMPONENT_INCOMPATIBLE

	whitelisted_mobs = to_whitelist()

	RegisterSignal(parent,,PROC_REF(heard_words))

/datum/component/resize_by_verbal_command/proc/heard_words()
