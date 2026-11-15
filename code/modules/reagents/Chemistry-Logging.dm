
GLOBAL_LIST_EMPTY(chemical_reaction_logs)

/proc/log_chemical_reaction(atom/A, datum/decl/chemical_reaction/R, multiplier)
	if(!A || !R)
		return

	var/turf/T = get_turf(A)
	var/logstr = "[usr ? key_name(usr) : "EVENT"] mixed [R.name] ([R.result]) (x[multiplier]) in \the [A] at [T ? "[T.x],[T.y],[T.z]" : "*null*"]"

	GLOB.chemical_reaction_logs += "\[[time_stamp()]\] [logstr]"

	if(R.log_is_important)
		message_admins(logstr)
	log_admin(logstr)

ADMIN_VERB(view_chemical_reaction_logs, R_ADMIN|R_MOD, "Show Chemical Reactions", "Access the chemical reactions log.", ADMIN_CATEGORY_INVESTIGATE)
	var/html = ""
	for(var/entry in GLOB.chemical_reaction_logs)
		html += "[entry]<br>"

	var/datum/browser/popup = new(user, "chemlogs", "Chemlogs")
	popup.set_content(html)
	popup.open()
