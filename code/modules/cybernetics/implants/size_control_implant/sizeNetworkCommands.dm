/datum/commandline_network_command/brand_support/size_implant_control
	name = "scale"
	default_alias = "scale"


/datum/commandline_network_command/brand_support/size_implant_control/Initialize()
	. = ..()
	dispatch_table = list()
	COMMAND_ACTION_DEFINE("set",setsize,1)
	COMMAND_ACTION_DEFINE("grow",grow,0)
	COMMAND_ACTION_DEFINE("shrink",shrink,0)

/datum/commandline_network_command/brand_support/size_implant_control/proc/grow(COMMAND_ACTION_PARAMS)
	if(installed_in_mob_boilerplate(from,logs))
		var/obj/item/endoware/end = from.assigned_to
		var/mob/living/carbon/target = end.host
		target.resize(min(target.size_multiplier*1.5, RESIZE_MAXIMUM))
		logs.set_log(from,"Set Target Scale To: [target.size_multiplier]")


/datum/commandline_network_command/brand_support/size_implant_control/proc/shrink(COMMAND_ACTION_PARAMS)
	if(installed_in_mob_boilerplate(from,logs))
		var/obj/item/endoware/end = from.assigned_to
		var/mob/living/carbon/target = end.host
		target.resize(max(target.size_multiplier*0.5, RESIZE_MINIMUM))
		logs.set_log(from,"Set Target Scale To: [target.size_multiplier]")

/datum/commandline_network_command/brand_support/size_implant_control/proc/setsize(COMMAND_ACTION_PARAMS)
	if(installed_in_mob_boilerplate(from,logs))
		var/obj/item/endoware/end = from.assigned_to
		var/mob/living/carbon/target = end.host
		var/list/arguments = LAZYACCESS(sorted_tokens,COMMAND_ARGUMENT_ARGUMENTS)
		var/size = arguments[2]
		var/size_as_num = text2num(size)
		if(isnull(size))
			logs.set_log(from,"Err: Argument \"Size\" must be valid number.",COMMAND_OUTPUT_ERROR)
			return
		var/size_select = clamp((size_as_num / 100), RESIZE_MINIMUM_DORMS, RESIZE_MAXIMUM_DORMS)
		if(size_select < RESIZE_MINIMUM || size_select > RESIZE_MAXIMUM)
			logs.set_log(from,"Warn: Unsafe Size Scales forbidden outside whitelisted areas. Will be capped to comply with regulations if so.")

		target.resize(size_select, uncapped = target.has_large_resize_bounds(), ignore_prefs = TRUE) //If you have a size implant I'm presuming you're open to getting hackerman'd

/datum/commandline_network_command/brand_support/size_implant_control/getHelpText(datum/commandline_network_node/homenode, list/tokens, alias_used, verbose, direct, usage)
	. = ..()
	var/usage_text = ">[alias_used] grow|shrink OR set 0-600"
	if(direct)
		return {"adjust the owner's relative scale.
Usage: [usage_text]
- "Grow" increases size up to 50%.
- "Shrink" decreases it by 50%.
- "Set" allows you to specify a percentage value.
"}
	if(verbose)
		return "Enables adjusting the size of the user. ae:\"[usage_text]\"."

	if(usage)
		return usage_text

	return "Grows or shrinks the user."
