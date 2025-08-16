/obj/item
	var/list/tool_qualities = list()

/obj/item/examine(mob/user)
	. = ..()
	for(var/qual in tool_qualities)
		var/msg
		switch(tool_qualities[qual])
			if(TOOL_QUALITY_WORST)
				msg += "very poor "
			if(TOOL_QUALITY_POOR)
				msg += "poor "
			if(TOOL_QUALITY_MEDIOCRE)
				msg += "mediocre "
			if(TOOL_QUALITY_STANDARD)
				msg += ""
			if(TOOL_QUALITY_DECENT)
				msg += "decent "
			if(TOOL_QUALITY_GOOD)
				msg += "pretty good "
			if(TOOL_QUALITY_BEST)
				msg += "very good "
		. += "It looks like it can be used as a [msg][qual]."

/atom/proc/get_tool_quality(tool_quality)
	return TOOL_QUALITY_NONE

/// Used to check for a specific tool quality on an item.
/// Returns the value of `tool_quality` if it is found, else 0.
/obj/item/get_tool_quality(quality)
	return LAZYACCESS(tool_qualities, quality)

/obj/item/proc/set_tool_quality(tool, quality)
	tool_qualities[tool] = quality

/obj/item/proc/get_tool_speed(quality)
	return LAZYACCESS(tool_qualities, quality)

/obj/item/proc/get_use_time(quality, base_time)
	return LAZYACCESS(tool_qualities, quality) ? base_time / tool_qualities[quality] : -1
