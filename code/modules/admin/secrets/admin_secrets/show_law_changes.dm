/datum/admin_secret_item/admin_secret/show_law_changes
	name = "Show law changes"

/datum/admin_secret_item/admin_secret/show_law_changes/name()
	return "Show Last [length(lawchanges)] Law change\s"

/datum/admin_secret_item/admin_secret/show_law_changes/execute(var/mob/user)
	. = ..()
	if(!.)
		return

	var/dat = span_bold("Showing last [length(lawchanges)] law changes.") + "<HR>"
	for(var/sig in lawchanges)
		dat += "[sig]<BR>"
	user << browse("<html>[dat]</html>", "window=lawchanges;size=800x500")
