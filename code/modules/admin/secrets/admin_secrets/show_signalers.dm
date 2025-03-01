/datum/admin_secret_item/admin_secret/show_signalers
	name = "Show Last Signalers"

/datum/admin_secret_item/admin_secret/show_signalers/name()
	return "Show Last [length(GLOB.lastsignalers)] Signaler\s"

/datum/admin_secret_item/admin_secret/show_signalers/execute(var/mob/user)
	. = ..()
	if(!.)
		return

	var/dat = span_bold("Showing last [length(GLOB.lastsignalers)] signalers.") + "<HR>"
	for(var/sig in GLOB.lastsignalers)
		dat += "[sig]<BR>"
	user << browse("<html>[dat]</html>", "window=lastsignalers;size=800x500")
