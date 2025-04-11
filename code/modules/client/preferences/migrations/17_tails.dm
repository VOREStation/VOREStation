/// Changes a few tails to their new paths.
/datum/preferences/proc/migration_17_tails(datum/json_savefile/S)
	for(var/slot in 1 to CONFIG_GET(number/character_slots))
		var/list/prefs = S.get_entry("character[slot]", null)
		if(!islist(prefs))
			continue
		prefs["tail_style"] = replacetext(prefs["tail_style"], "Kitsune 3 tails - colorable", "Kitsune 3 tails, colorable")
		prefs["tail_style"] = replacetext(prefs["tail_style"], "Kitsune 9 tails - colorable", "Kitsune 9 tails, colorable")

		prefs["tail_style"] = replacetext(prefs["tail_style"], "Male teshari tail(Pattern)", "Teshari male tail pattern")
		prefs["tail_style"] = replacetext(prefs["tail_style"], "Female teshari tail(Pattern)", "Teshari female tail pattern")

		prefs["tail_style"] = replacetext(prefs["tail_style"], "Male teshari tail(Pattern, Alt.)", "Teshari male tail alt. pattern")
		prefs["tail_style"] = replacetext(prefs["tail_style"], "Female teshari tail(Pattern, Alt.)", "Teshari fem tail alt. pattern")

		prefs["tail_style"] = replacetext(prefs["tail_style"], "feathered Raptor, duel colorable", "feathered Raptor, dual colorable")
		S.set_entry("character[slot]", prefs)

	S.save()
