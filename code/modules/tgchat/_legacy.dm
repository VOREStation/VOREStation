/// Old VChat Code Stuff

/* Old bicon code
/proc/expire_bicon_cache(key)
	if(GLOB.bicon_cache[key])
		GLOB.bicon_cache -= key
		return TRUE
	return FALSE

GLOBAL_LIST_EMPTY(bicon_cache) // Cache of the <img> tag results, not the icons
*/

/proc/bicon(var/obj, var/use_class = 1, var/custom_classes = "")
	return icon2base64html(obj, custom_classes)

	/* Old bicon code
	var/class = use_class ? "class='icon misc [custom_classes]'" : null
	if(!obj)
		return

	// Try to avoid passing bicon an /icon directly. It is better to pass it an atom so it can cache.
	if(isicon(obj)) // Passed an icon directly, nothing to cache-key on, as icon refs get reused *often*
		return "<img [class] src='data:image/png;base64,[icon2base64(obj)]'>"

	// Either an atom or somebody fucked up and is gonna get a runtime, which I'm fine with.
	var/atom/A = obj
	var/key
	var/changes_often = ishuman(A) || isobserver(A) // If this ends up with more, move it into a proc or var on atom.

	if(changes_often)
		key = "\ref[A]"
	else
		key = "[istype(A.icon, /icon) ? "\ref[A.icon]" : A.icon]:[A.icon_state]"

	var/base64 = GLOB.bicon_cache[key]
	// Non-human atom, no cache
	if(!base64) // Doesn't exist, make it.
		base64 = icon2base64(A.examine_icon(), key)
		GLOB.bicon_cache[key] = base64
		if(changes_often)
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(expire_bicon_cache), key), 50 SECONDS, TIMER_UNIQUE)

	// May add a class to the img tag created by bicon
	if(use_class)
		class = "class='icon [A.icon_state] [custom_classes]'"

	return "<IMG [class] src='data:image/png;base64,[base64]'>"
	*/
