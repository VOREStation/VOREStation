/datum/admin_secret_item/admin_secret/bombing_list
	name = "Bombing List"

/datum/admin_secret_item/admin_secret/bombing_list/execute(var/mob/user)
	. = ..()
	if(!.)
		return

	var/dat = span_bold("Bombing List")
	for(var/l in GLOB.bombers)
		dat += text("[l]<BR>")

	var/datum/browser/popup = new(user, "bombers", "Bombers")
	popup.set_content(dat)
	popup.open()
