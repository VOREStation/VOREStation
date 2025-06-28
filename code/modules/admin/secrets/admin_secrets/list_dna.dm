/datum/admin_secret_item/admin_secret/list_dna
	name = "List DNA (Blood)"

/datum/admin_secret_item/admin_secret/list_dna/execute(var/mob/user)
	. = ..()
	if(!.)
		return
	var/dat = span_bold("Showing DNA from blood.") + "<HR>"
	dat += "<table cellspacing=5><tr><th>Name</th><th>DNA</th><th>Blood Type</th></tr>"
	for(var/mob/living/carbon/human/H in GLOB.mob_list)
		if(H.dna && H.ckey)
			dat += "<tr><td>[H]</td><td>[H.dna.unique_enzymes]</td><td>[H.dna ? H.dna.b_type : DEFAULT_BLOOD_TYPE]</td></tr>"
	dat += "</table>"

	var/datum/browser/popup = new(user, "DNA", "DNA", 440, 410)
	popup.set_content(dat)
	popup.open()
