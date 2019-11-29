//TFF 28/11/19 - Emojis enabled for use in LOOC/OOC " :TextOfEmojiName: " - Ported from CHOMPStation.
/proc/emoji_parse(text)
	. = text
	if(!config.emojis)
		return
	var/static/list/emojis = icon_states(icon('icons/vore/emoji_vr.dmi'))
	var/parsed = ""
	var/pos = 1
	var/search = 0
	var/emoji = ""
	while(1)
		search = findtext(text, ":", pos)
		parsed += copytext(text, pos, search)
		if(search)
			pos = search
			search = findtext(text, ":", pos+1)
			if(search)
				emoji = lowertext(copytext(text, pos+1, search))
				if(emoji in emojis)
					parsed += " <img class=icon src=\ref['icons/vore/emoji_vr.dmi'] iconstate='[emoji]'>"
					pos = search + 1
				else
					parsed += copytext(text, pos, search)
					pos = search
				emoji = ""
				continue
			else
				parsed += copytext(text, pos, search)
		break
	return parsed