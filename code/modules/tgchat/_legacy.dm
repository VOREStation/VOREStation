/// Old VChat Code Stuff

//This is used to convert icons to base64 <image> strings, because byond stores icons in base64 in savefiles.
GLOBAL_DATUM_INIT(iconCache, /savefile, new("data/iconCache.sav")) //Cache of icons for the browser output

//Converts an icon to base64. Operates by putting the icon in the iconCache savefile,
// exporting it as text, and then parsing the base64 from that.
// (This relies on byond automatically storing icons in savefiles as base64)
/proc/icon2base64(var/icon/icon, var/iconKey = "misc")
	if (!isicon(icon)) return FALSE

	GLOB.iconCache[iconKey] << icon
	var/iconData = GLOB.iconCache.ExportText(iconKey)
	var/list/partial = splittext(iconData, "{")
	return replacetext(copytext(partial[2], 3, -5), "\n", "")

/proc/expire_bicon_cache(key)
	if(GLOB.bicon_cache[key])
		GLOB.bicon_cache -= key
		return TRUE
	return FALSE

GLOBAL_LIST_EMPTY(bicon_cache) // Cache of the <img> tag results, not the icons
/proc/bicon(var/obj, var/use_class = 1, var/custom_classes = "")
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
			addtimer(CALLBACK(GLOBAL_PROC, .proc/expire_bicon_cache, key), 50 SECONDS, TIMER_UNIQUE)

	// May add a class to the img tag created by bicon
	if(use_class)
		class = "class='icon [A.icon_state] [custom_classes]'"

	return "<IMG [class] src='data:image/png;base64,[base64]'>"
