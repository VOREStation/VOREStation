/obj/item
	var/list/tool_qualities

/// Used to check for a specific tool quality on an item.
/// Returns TRUE or FALSE depending on whether `tool_quality` is found.
/obj/item/proc/has_tool_quality(tool_quality)
	return !!LAZYFIND(tool_qualities, tool_quality)

/* Legacy Support */

/// DEPRECATED PROC: DO NOT USE IN NEW CODE
/obj/item/proc/is_screwdriver()
	return has_tool_quality(TOOL_SCREWDRIVER)

/// DEPRECATED PROC: DO NOT USE IN NEW CODE
/obj/item/proc/is_wrench()
	return has_tool_quality(TOOL_WRENCH)

/// DEPRECATED PROC: DO NOT USE IN NEW CODE
/obj/item/proc/is_crowbar()
	return has_tool_quality(TOOL_CROWBAR)

/// DEPRECATED PROC: DO NOT USE IN NEW CODE
/obj/item/proc/is_wirecutter()
	return has_tool_quality(TOOL_WIRECUTTER)

/// DEPRECATED PROC: DO NOT USE IN NEW CODE
/obj/item/proc/is_multitool()
	return has_tool_quality(TOOL_MULTITOOL)

/// DEPRECATED PROC: DO NOT USE IN NEW CODE
/obj/item/proc/is_welder()
	return has_tool_quality(TOOL_WELDER)
