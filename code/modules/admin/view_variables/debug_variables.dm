#define VV_HTML_ENCODE(thing) ( sanitize ? html_encode(thing) : thing )
/proc/debug_variable(name, value, level, datum/DA = null, sanitize = TRUE)
	var/header
	if(DA)
		if (islist(DA))
			var/index = name
			if (value)
				name = DA[name] //name is really the index until this line
			else
				value = DA[name]
			header = "<li style='backgroundColor:white'>(<a href='byond://?_src_=vars;[HrefToken()];[VV_HK_LIST_EDIT]=1;target=\ref[DA];index=[index]'>E</a>) (<a href='byond://?_src_=vars;[HrefToken()];[VV_HK_LIST_CHANGE]=1;target=\ref[DA];index=[index]'>C</a>) (<a href='byond://?_src_=vars;[HrefToken()];[VV_HK_LIST_REMOVE]=1;target=\ref[DA];index=[index]'>-</a>) "
		else
			header = "<li style='backgroundColor:white'>(<a href='byond://?_src_=vars;[HrefToken()];datumedit=\ref[DA];varnameedit=[name]'>E</a>) (<a href='byond://?_src_=vars;[HrefToken()];datumchange=\ref[DA];varnamechange=[name]'>C</a>) (<a href='byond://?_src_=vars;[HrefToken()];datummass=\ref[DA];varnamemass=[name]'>M</a>) "
	else
		header = "<li>"

	var/item
	if (isnull(value))
		item = "[VV_HTML_ENCODE(name)] = <span class='value'>null</span>"

	else if (istext(value))
		item = "[VV_HTML_ENCODE(name)] = <span class='value'>\"[VV_HTML_ENCODE(value)]\"</span>"

	else if (isicon(value))
		#ifdef VARSICON
		var/icon/I = new/icon(value)
		var/rnd = rand(1,10000)
		var/rname = "tmp\ref[I][rnd].png"
		usr << browse_rsc(I, rname)
		item = "[VV_HTML_ENCODE(name)] = (<span class='value'>[value]</span>) <img class=icon src=\"[rname]\">"
		#else
		item = "[VV_HTML_ENCODE(name)] = /icon (<span class='value'>[value]</span>)"
		#endif

	else if (isfile(value))
		item = "[VV_HTML_ENCODE(name)] = <span class='value'>'[value]'</span>"

	else if (istype(value, /datum))
		var/datum/D = value
		if ("[D]" != "[D.type]") //if the thing as a name var, lets use it.
			item = "<a href='byond://?_src_=vars;[HrefToken()];Vars=\ref[value]'>[VV_HTML_ENCODE(name)] \ref[value]</a> = [D] [D.type]"
		else
			item = "<a href='byond://?_src_=vars;[HrefToken()];Vars=\ref[value]'>[VV_HTML_ENCODE(name)] \ref[value]</a> = [D.type]"

	else if (islist(value))
		var/list/L = value
		var/list/items = list()

		if (L.len > 0 && !(name == "underlays" || name == "overlays" || L.len > (IS_NORMAL_LIST(L) ? VV_NORMAL_LIST_NO_EXPAND_THRESHOLD : VV_SPECIAL_LIST_NO_EXPAND_THRESHOLD)))
			for (var/i in 1 to L.len)
				var/key = L[i]
				var/val
				if (IS_NORMAL_LIST(L) && !isnum(key))
					val = L[key]
				if (isnull(val))	// we still want to display non-null false values, such as 0 or ""
					val = key
					key = i

				items += debug_variable(key, val, level + 1, sanitize = sanitize)

			item = "<a href='byond://?_src_=vars;[HrefToken()];Vars=\ref[value]'>[VV_HTML_ENCODE(name)] = /list ([L.len])</a><ul>[items.Join()]</ul>"
		else
			item = "<a href='byond://?_src_=vars;[HrefToken()];Vars=\ref[value]'>[VV_HTML_ENCODE(name)] = /list ([L.len])</a>"

	else if (name in GLOB.bitfields)
		var/list/flags = list()
		for (var/i in GLOB.bitfields[name])
			if (value & GLOB.bitfields[name][i])
				flags += i
			item = "[VV_HTML_ENCODE(name)] = [VV_HTML_ENCODE(jointext(flags, ", "))]"
	else
		item = "[VV_HTML_ENCODE(name)] = <span class='value'>[VV_HTML_ENCODE(value)]</span>"

	return "[header][item]</li>"

#undef VV_HTML_ENCODE
