var/global/client_record_update_lock = FALSE

// Manually updating records from medical console to a player's save.
/proc/get_current_mob_from_record(var/datum/data/record/active)
	var/datum/transcore_db/db = SStranscore.db_by_mind_name(active.fields["name"])
	if(db)
		var/datum/transhuman/mind_record/record = db.backed_up[active.fields["name"]]
		if(record.mind_ref)
			var/datum/mind/D = record.mind_ref
			if(D.current)
				var/client/C = D.current.client
				if(C && C.ckey != record.ckey)
					return null
			return D.current
	return null


/proc/client_update_record(var/obj/machinery/computer/COM, var/user)
	if(!COM || QDELETED(COM))
		return "Invalid console"

	if(jobban_isbanned(user, "Records") )
		COM.visible_message(span_notice("\The [COM] buzzes!"))
		playsound(COM, 'sound/machines/deniedbeep.ogg', 50, 0)
		return "Update syncronization denied (OOC: You are banned from editing records)"

	var/record_string = ""
	var/datum/data/record/active
	var/console_path = null
	if(istype(COM,/obj/machinery/computer/med_data))
		var/obj/machinery/computer/med_data/MCOM = COM
		active = MCOM.active2
		record_string = "medical"
		console_path = /obj/machinery/computer/med_data
	if(istype(COM,/obj/machinery/computer/skills))
		var/obj/machinery/computer/skills/ECOM = COM
		active = ECOM.active1
		record_string = "employment"
		console_path = /obj/machinery/computer/skills
	if(istype(COM,/obj/machinery/computer/secure_data))
		var/obj/machinery/computer/secure_data/SCOM = COM
		active = SCOM.active2
		record_string = "security"
		console_path = /obj/machinery/computer/secure_data

	if(client_record_update_lock)
		to_chat(user,"Update already in progress! Please wait a moment...")
		if(COM && !QDELETED(COM))
			COM.visible_message(span_notice("\The [COM] buzzes!"))
			playsound(COM, 'sound/machines/deniedbeep.ogg', 50, 0)
		return "Update already in progress! Please wait a moment..."
	client_record_update_lock = TRUE
	spawn(60 SECONDS)
		client_record_update_lock = FALSE

	if(!active || !console_path)
		if(COM && !QDELETED(COM))
			COM.visible_message(span_notice("\The [COM] buzzes!"))
			playsound(COM, 'sound/machines/deniedbeep.ogg', 50, 0)
		return "Update syncronization failed (OOC: Record or console destroyed)"

	to_chat(user,"Update sent! Please wait for a response...")
	message_admins("[user] pushed [record_string] record update to [active.fields["name"]].")

	var/mob/M = get_current_mob_from_record(active)
	if(!M)
		if(COM && !QDELETED(COM))
			COM.visible_message(span_notice("\The [COM] buzzes!"))
			playsound(COM, 'sound/machines/deniedbeep.ogg', 50, 0)
		return "Update syncronization failed (OOC: Client mob does not exist, has no mind record, or is possesssed)"

	var/client/C = M.client
	if(!C)
		if(COM && !QDELETED(COM))
			COM.visible_message(span_notice("\The [COM] buzzes!"))
			playsound(COM, 'sound/machines/deniedbeep.ogg', 50, 0)
		return "Update syncronization failed (OOC: Record's owner is offline)"

	var/choice = tgui_alert(M, "Your [record_string] record has been updated from the a records console by [user]. Please review the changes made to your [record_string] record. Accepting these changes will SAVE your CURRENT character slot! If your new [record_string] record has errors, it is recomended to have it corrected IC instead of editing it yourself.", "Record Updated", list("Review Changes","Refuse Update"))
	if(choice == "Refuse Update")
		message_admins("[active.fields["name"]] refused [record_string] record update from [user] without review.")
		if(COM && !QDELETED(COM))
			COM.visible_message(span_notice("\The [COM] buzzes!"))
			playsound(COM, 'sound/machines/deniedbeep.ogg', 50, 0)
		return "Update syncronization failed (OOC: Client refused without review)"

	var/datum/preferences/P = C.prefs
	var/new_data = strip_html_simple(tgui_input_text(M,"Please review [user]'s changes to your [record_string] record before confirming. Confirming will SAVE your CURRENT character slot! If your new [record_string] record major errors, it is recomended to have it corrected IC instead of editing it yourself.","Character Preference", html_decode(active.fields["notes"]), MAX_RECORD_LENGTH, TRUE, prevent_enter = TRUE), MAX_RECORD_LENGTH)
	if(!new_data)
		message_admins("[active.fields["name"]] refused [record_string] record update from [user] with review.")
		if(COM && !QDELETED(COM))
			COM.visible_message(span_notice("\The [COM] buzzes!"))
			playsound(COM, 'sound/machines/deniedbeep.ogg', 50, 0)
		return "Update syncronization failed (OOC: Client refused with review)"
	if(!M || !M.client || !P)
		message_admins("[active.fields["name"]]'s [record_string] record could not be updated, client disconnected.")
		if(COM && !QDELETED(COM))
			COM.visible_message(span_notice("\The [COM] buzzes!"))
			playsound(COM, 'sound/machines/deniedbeep.ogg', 50, 0)
		return "Update syncronization failed (OOC: Client does not exist)"

	// Update records in the consoles, remember this can happen a while after a record is closed on the console... Use cached data.
	switch(console_path)
		if(/obj/machinery/computer/med_data)
			P.med_record = new_data
			if(active)
				active.fields["notes"] = new_data
		if(/obj/machinery/computer/skills)
			P.gen_record = new_data
			if(active)
				active.fields["notes"] = new_data
		if(/obj/machinery/computer/secure_data)
			P.sec_record = new_data
			if(active)
				active.fields["notes"] = new_data

	// Update player record
	P.save_preferences()
	P.save_character()
	if(M)
		to_chat(M,span_notice("Your [record_string] record for [active.fields["name"]] has been updated."))
	message_admins("[active.fields["name"]] accepted the [record_string] record update from [user].")

		// ding!
	if(COM && !QDELETED(COM))
		COM.visible_message(span_notice("\The [COM] dings!"))
		playsound(COM, 'sound/machines/ding.ogg', 50, 1)

	return "Record syncronized."
