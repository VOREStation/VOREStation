/datum/admin_secret_item/admin_secret/admin_logs
	name = "Admin Logs"

/datum/admin_secret_item/admin_secret/admin_logs/execute(var/mob/user)
	. = ..()
	if(!.)
		return
	var/dat = span_bold("Admin Log<HR>")
	for(var/l in admin_log)
		dat += "<li>[l]</li>"
	if(!admin_log.len)
		dat += "No-one has done anything this round!"

	var/datum/browser/popup = new(user, "adminlogs", "[src]", 550, 650, src)
	popup.set_content(jointext(dat,null))
	popup.open()

	onclose(user, "adminlogs")


/datum/admin_secret_item/admin_secret/round_logs
	name = "Round Dialogue Logs"

/datum/admin_secret_item/admin_secret/round_logs/execute(var/mob/user)
	. = ..()
	if(!.)
		return
	var/dat = span_bold("Dialogue Log<HR>")

	dat += "<fieldset style='border: 2px solid white; display: inline'>"

	for(var/l in GLOB.round_text_log)
		dat += "<li>[l]</li>"

	dat += "</fieldset>"

	if(!GLOB.round_text_log)
		dat += "No-one has said anything this round! (How odd?)"

	var/datum/browser/popup = new(user, "dialoguelogs", "[src]", 550, 650, src)
	popup.set_content(jointext(dat,null))
	popup.open()

	onclose(user, "dialoguelogs")
