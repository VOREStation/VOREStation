#define SEC_DATA_R_LIST	2	// Record list
#define SEC_DATA_MAINT	3	// Records maintenance
#define SEC_DATA_RECORD	4	// Record

#define FIELD(N, V, E) list(field = N, value = V, edit = E)

/obj/machinery/computer/secure_data//TODO:SANITY
	name = "security records console"
	desc = "Used to view, edit and maintain security records"
	icon_keyboard = "security_key"
	icon_screen = "security"
	light_color = "#a91515"
	req_one_access = list(access_security, access_forensics_lockers, access_lawyer)
	circuit = /obj/item/circuitboard/secure_data
	var/obj/item/card/id/scan = null
	var/authenticated = null
	var/rank = null
	var/screen = null
	var/datum/data/record/active1 = null
	var/datum/data/record/active2 = null
	var/list/temp = null
	var/printing = null
	// The below are used to make modal generation more convenient
	var/static/list/field_edit_questions
	var/static/list/field_edit_choices

/obj/machinery/computer/secure_data/Initialize()
	. = ..()
	field_edit_questions = list(
		// General
		"name" = "Please enter new name:",
		"id" = "Please enter new id:",
		"sex" = "Please select new sex:",
		"species" = "Please input new species:",
		"age" = "Please input new age:",
		"rank" = "Please enter new rank:",
		"fingerprint" = "Please input new fingerprint hash:",
		// Security
		"brain_type" = "Please select new brain type:",
		"criminal" = "Please select new criminal status:",
		"mi_crim" = "Please input new minor crime:",
		"mi_crim_d" = "Please input minor crime summary.",
		"ma_crim" = "Please input new major crime:",
		"ma_crim_d" = "Please input new major crime summary.",
		"notes" = "Please input new important notes:",
	)
	field_edit_choices = list(
		// General
		"sex" = all_genders_text_list,
		// Security
		"criminal" = list("*Arrest*", "Incarcerated", "Parolled", "Released", "None"),
	)

/obj/machinery/computer/secure_data/Destroy()
	active1 = null
	active2 = null
	return ..()

/obj/machinery/computer/secure_data/verb/eject_id()
	set category = "Object"
	set name = "Eject ID Card"
	set src in oview(1)

	if(!usr || usr.stat || usr.lying)	return

	if(scan)
		to_chat(usr, "You remove \the [scan] from \the [src].")
		scan.loc = get_turf(src)
		if(!usr.get_active_hand() && istype(usr,/mob/living/carbon/human))
			usr.put_in_hands(scan)
		scan = null
	else
		to_chat(usr, "There is nothing to remove from the console.")
	return

/obj/machinery/computer/secure_data/attackby(var/obj/item/O, var/mob/user)
	if(istype(O, /obj/item/card/id) && !scan && user.unEquip(O))
		O.loc = src
		scan = O
		to_chat(user, "You insert \the [O].")
		tgui_interact(user)
	else
		..()

/obj/machinery/computer/secure_data/attack_ai(mob/user as mob)
	return attack_hand(user)

//Someone needs to break down the dat += into chunks instead of long ass lines.
/obj/machinery/computer/secure_data/attack_hand(mob/user as mob)
	if(..())
		return
	add_fingerprint(user)
	tgui_interact(user)

/obj/machinery/computer/secure_data/tgui_interact(mob/user, datum/tgui/ui = null)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "SecurityRecords", "Security Records") // 800, 380
		ui.open()
		ui.set_autoupdate(FALSE)


/obj/machinery/computer/secure_data/tgui_data(mob/user)
	var/data[0]
	data["temp"] = temp
	data["scan"] = scan ? scan.name : null
	data["authenticated"] = authenticated
	data["rank"] = rank
	data["screen"] = screen
	data["printing"] = printing
	data["isAI"] = isAI(user)
	data["isRobot"] = isrobot(user)
	if(authenticated)
		switch(screen)
			if(SEC_DATA_R_LIST)
				if(!isnull(data_core.general))
					var/list/records = list()
					data["records"] = records
					for(var/datum/data/record/R in sortRecord(data_core.general))
						var/color = null
						var/criminal = "None"
						for(var/datum/data/record/M in data_core.security)
							if(M.fields["name"] == R.fields["name"] && M.fields["id"] == R.fields["id"])
								switch(M.fields["criminal"])
									if("*Arrest*")
										color = "bad"
									if("Incarcerated")
										color = "brown"
									if("Parolled", "Released")
										color = "average"
									if("None")
										color = "good"
								criminal = M.fields["criminal"]
								break
						records[++records.len] = list(
							"ref" = "\ref[R]",
							"id" = R.fields["id"],
							"name" = R.fields["name"],
							"color" = color,
							"criminal" = criminal
						)
			if(SEC_DATA_RECORD)
				var/list/general = list()
				data["general"] = general
				if(istype(active1, /datum/data/record) && data_core.general.Find(active1))
					var/list/fields = list()
					general["fields"] = fields
					fields[++fields.len] = FIELD("Name", active1.fields["name"], "name")
					fields[++fields.len] = FIELD("ID", active1.fields["id"], "id")
					fields[++fields.len] = FIELD("Entity Classification", active1.fields["brain_type"], "brain_type")
					fields[++fields.len] = FIELD("Sex", active1.fields["sex"], "sex")
					fields[++fields.len] = FIELD("Species", active1.fields["species"], "species")
					fields[++fields.len] = FIELD("Age", "[active1.fields["age"]]", "age")
					fields[++fields.len] = FIELD("Rank", active1.fields["rank"], "rank")
					fields[++fields.len] = FIELD("Fingerprint", active1.fields["fingerprint"], "fingerprint")
					fields[++fields.len] = FIELD("Physical Status", active1.fields["p_stat"], null)
					fields[++fields.len] = FIELD("Mental Status", active1.fields["m_stat"], null)
					var/list/photos = list()
					general["photos"] = photos
					photos[++photos.len] = active1.fields["photo-south"]
					photos[++photos.len] = active1.fields["photo-west"]
					general["has_photos"] = (active1.fields["photo-south"] || active1.fields["photo-west"] ? 1 : 0)
					general["empty"] = 0
				else
					general["empty"] = 1

				var/list/security = list()
				data["security"] = security
				if(istype(active2, /datum/data/record) && data_core.security.Find(active2))
					var/list/fields = list()
					security["fields"] = fields
					fields[++fields.len] = FIELD("Criminal Status", active2.fields["criminal"], "criminal")
					fields[++fields.len] = FIELD("Minor Crimes", active2.fields["mi_crim"], "mi_crim")
					fields[++fields.len] = FIELD("Details", active2.fields["mi_crim_d"], "mi_crim_d")
					fields[++fields.len] = FIELD("Major Crimes", active2.fields["ma_crim"], "ma_crim")
					fields[++fields.len] = FIELD("Details", active2.fields["ma_crim_d"], "ma_crim_d")
					fields[++fields.len] = FIELD("Important Notes", active2.fields["notes"], "notes")
					if(!active2.fields["comments"] || !islist(active2.fields["comments"]))
						active2.fields["comments"] = list()
					security["comments"] = active2.fields["comments"]
					security["empty"] = 0
				else
					security["empty"] = 1

	data["modal"] = tgui_modal_data(src)
	return data

/obj/machinery/computer/secure_data/tgui_act(action, params, datum/tgui/ui)
	if(..())
		return TRUE

	if(!data_core.general.Find(active1))
		active1 = null
	if(!data_core.security.Find(active2))
		active2 = null

	. = TRUE
	if(tgui_act_modal(action, params))
		return

	switch(action)
		if("cleartemp")
			temp = null
		if("scan")
			if(scan)
				scan.forceMove(loc)
				if(ishuman(ui.user) && !ui.user.get_active_hand())
					ui.user.put_in_hands(scan)
				scan = null
			else
				var/obj/item/I = ui.user.get_active_hand()
				if(istype(I, /obj/item/card/id))
					ui.user.drop_item()
					I.forceMove(src)
					scan = I
		if("login")
			var/login_type = text2num(params["login_type"])
			if(login_type == LOGIN_TYPE_NORMAL && istype(scan))
				if(check_access(scan))
					authenticated = scan.registered_name
					rank = scan.assignment
			else if(login_type == LOGIN_TYPE_AI && isAI(ui.user))
				authenticated = ui.user.name
				rank = JOB_AI
			else if(login_type == LOGIN_TYPE_ROBOT && isrobot(ui.user))
				authenticated = ui.user.name
				var/mob/living/silicon/robot/R = ui.user
				rank = "[R.modtype] [R.braintype]"
			if(authenticated)
				active1 = null
				active2 = null
				screen = SEC_DATA_R_LIST
		else
			. = FALSE

	if(.)
		return

	if(authenticated)
		. = TRUE
		switch(action)
			if("logout")
				if(scan)
					scan.forceMove(loc)
					if(ishuman(ui.user) && !ui.user.get_active_hand())
						ui.user.put_in_hands(scan)
					scan = null
				authenticated = null
				screen = null
				active1 = null
				active2 = null
			if("screen")
				screen = clamp(text2num(params["screen"]) || 0, SEC_DATA_R_LIST, SEC_DATA_RECORD)
				active1 = null
				active2 = null
			if("del_all")
				for(var/datum/data/record/R in data_core.security)
					qdel(R)
				set_temp("All security records deleted.")
			if("del_r")
				if(active2)
					set_temp("Security record deleted.")
					qdel(active2)
			if("del_r_2")
				set_temp("All records for [active1.fields["name"]] deleted.")
				if(active1)
					for(var/datum/data/record/R in data_core.medical)
						if((R.fields["name"] == active1.fields["name"] || R.fields["id"] == active1.fields["id"]))
							qdel(R)
					qdel(active1)
				if(active2)
					qdel(active2)
			if("d_rec")
				var/datum/data/record/general_record = locate(params["d_rec"] || "")
				if(!data_core.general.Find(general_record))
					set_temp("Record not found.", "danger")
					return

				var/datum/data/record/security_record
				for(var/datum/data/record/M in data_core.security)
					if(M.fields["name"] == general_record.fields["name"] && M.fields["id"] == general_record.fields["id"])
						security_record = M
						break

				active1 = general_record
				active2 = security_record
				screen = SEC_DATA_RECORD
			if("new")
				if(istype(active1, /datum/data/record) && !istype(active2, /datum/data/record))
					var/datum/data/record/R = new /datum/data/record()
					R.fields["name"] = active1.fields["name"]
					R.fields["id"] = active1.fields["id"]
					R.name = "Security Record #[R.fields["id"]]"
					R.fields["brain_type"]	= "Unknown"
					R.fields["criminal"]	= "None"
					R.fields["mi_crim"]		= "None"
					R.fields["mi_crim_d"]	= "No minor crime convictions."
					R.fields["ma_crim"]		= "None"
					R.fields["ma_crim_d"]	= "No major crime convictions."
					R.fields["notes"]		= "No notes."
					R.fields["notes"]		= "No notes."
					data_core.security += R
					active2 = R
					screen = SEC_DATA_RECORD
					set_temp("Security record created.", "success")
			if("del_c")
				var/index = text2num(params["del_c"] || "")
				if(!index || !istype(active2, /datum/data/record))
					return

				var/list/comments = active2.fields["comments"]
				index = clamp(index, 1, length(comments))
				if(comments[index])
					comments.Cut(index, index + 1)
			if("search")
				active1 = null
				active2 = null
				var/t1 = lowertext(params["t1"] || "")
				if(!length(t1))
					return

				for(var/datum/data/record/R in data_core.general)
					if(t1 == lowertext(R.fields["name"]) || t1 == lowertext(R.fields["id"]) || t1 == lowertext(R.fields["fingerprint"]))
						active1 = R
						break
				if(!active1)
					set_temp("Security record not found. You must enter the person's exact name, ID, or fingerprint.", "danger")
					return
				for(var/datum/data/record/E in data_core.security)
					if(E.fields["name"] == active1.fields["name"] && E.fields["id"] == active1.fields["id"])
						active2 = E
						break
				screen = SEC_DATA_RECORD
			if("print_p")
				if(!printing)
					printing = TRUE
					// playsound(loc, 'sound/goonstation/machines/printer_dotmatrix.ogg', 50, TRUE)
					SStgui.update_uis(src)
					addtimer(CALLBACK(src, PROC_REF(print_finish)), 5 SECONDS)
			if("photo_front")
				var/icon/photo = get_photo(ui.user)
				if(photo && active1)
					active1.fields["photo_front"] = photo
					active1.fields["photo-south"] = "'data:image/png;base64,[icon2base64(photo)]'"
			if("photo_side")
				var/icon/photo = get_photo(ui.user)
				if(photo && active1)
					active1.fields["photo_side"] = photo
					active1.fields["photo-west"] = "'data:image/png;base64,[icon2base64(photo)]'"
			else
				return FALSE

/**
  * Called in tgui_act() to process modal actions
  *
  * Arguments:
  * * action - The action passed by tgui
  * * params - The params passed by tgui
  */
/obj/machinery/computer/secure_data/proc/tgui_act_modal(action, params)
	. = TRUE
	var/id = params["id"] // The modal's ID
	var/list/arguments = istext(params["arguments"]) ? json_decode(params["arguments"]) : params["arguments"]
	switch(tgui_modal_act(src, action, params))
		if(TGUI_MODAL_OPEN)
			switch(id)
				if("edit")
					var/field = arguments["field"]
					if(!length(field) || !field_edit_questions[field])
						return
					var/question = field_edit_questions[field]
					var/choices = field_edit_choices[field]
					if(length(choices))
						tgui_modal_choice(src, id, question, arguments = arguments, value = arguments["value"], choices = choices)
					else
						tgui_modal_input(src, id, question, arguments = arguments, value = arguments["value"])
				if("add_c")
					tgui_modal_input(src, id, "Please enter your message:")
				else
					return FALSE
		if(TGUI_MODAL_ANSWER)
			var/answer = params["answer"]
			switch(id)
				if("edit")
					var/field = arguments["field"]
					if(!length(field) || !field_edit_questions[field])
						return
					var/list/choices = field_edit_choices[field]
					if(length(choices) && !(answer in choices))
						return

					if(field == "age")
						answer = text2num(answer)

					if(field == "rank")
						if(answer in joblist)
							active1.fields["real_rank"] = answer

					if(field == "criminal")
						for(var/mob/living/carbon/human/H in player_list)
							BITSET(H.hud_updateflag, WANTED_HUD)

					if(istype(active2) && (field in active2.fields))
						active2.fields[field] = answer
					if(istype(active1) && (field in active1.fields))
						active1.fields[field] = answer
				if("add_c")
					if(!length(answer) || !istype(active2) || !length(authenticated))
						return
					active2.fields["comments"] += list(list(
						header = "Made by [authenticated] ([rank]) at [worldtime2stationtime(world.time)]",
						text = answer
					))
				else
					return FALSE
		else
			return FALSE


/**
  * Called when the print timer finishes
  */
/obj/machinery/computer/secure_data/proc/print_finish()
	var/obj/item/paper/P = new(loc)
	P.info = "<center>" + span_bold("Security Record") + "</center><br>"
	if(istype(active1, /datum/data/record) && data_core.general.Find(active1))
		P.info += {"Name: [active1.fields["name"]] ID: [active1.fields["id"]]
		<br>\nSex: [active1.fields["sex"]]
		<br>\nSpecies: [active1.fields["species"]]
		<br>\nAge: [active1.fields["age"]]
		<br>\nFingerprint: [active1.fields["fingerprint"]]
		<br>\nPhysical Status: [active1.fields["p_stat"]]
		<br>\nMental Status: [active1.fields["m_stat"]]<br>"}
	else
		P.info += span_bold("General Record Lost!") + "<br>"
	if(istype(active2, /datum/data/record) && data_core.security.Find(active2))
		P.info += {"<br>\n<center><b>Security Data</b></center>
		<br>\nCriminal Status: [active2.fields["criminal"]]<br>\n
		<br>\nMinor Crimes: [active2.fields["mi_crim"]]
		<br>\nDetails: [active2.fields["mi_crim_d"]]<br>\n
		<br>\nMajor Crimes: [active2.fields["ma_crim"]]
		<br>\nDetails: [active2.fields["ma_crim_d"]]<br>\n
		<br>\nImportant Notes:
		<br>\n\t[active2.fields["notes"]]<br>\n
		<br>\n
		<center><b>Comments/Log</b></center><br>"}
		for(var/c in active2.fields["comments"])
			P.info += "[c["header"]]<br>[c["text"]]<br>"
	else
		P.info += span_bold("Security Record Lost!") + "<br>"
	P.info += "</tt>"
	P.name = "paper - 'Security Record: [active1.fields["name"]]'"
	printing = FALSE
	SStgui.update_uis(src)


/**
  * Sets a temporary message to display to the user
  *
  * Arguments:
  * * text - Text to display, null/empty to clear the message from the UI
  * * style - The style of the message: (color name), info, success, warning, danger, virus
  */
/obj/machinery/computer/secure_data/proc/set_temp(text = "", style = "info", update_now = FALSE)
	temp = list(text = text, style = style)
	if(update_now)
		SStgui.update_uis(src)

/obj/machinery/computer/secure_data/proc/is_not_allowed(var/mob/user)
	return !src.authenticated || user.stat || user.restrained() || (!in_range(src, user) && (!istype(user, /mob/living/silicon)))

/obj/machinery/computer/secure_data/proc/get_photo(var/mob/user)
	if(istype(user.get_active_hand(), /obj/item/photo))
		var/obj/item/photo/photo = user.get_active_hand()
		return photo.img
	if(istype(user, /mob/living/silicon))
		var/mob/living/silicon/tempAI = user
		var/obj/item/photo/selection = tempAI.GetPicture()
		if (selection)
			return selection.img

/obj/machinery/computer/secure_data/emp_act(severity)
	if(stat & (BROKEN|NOPOWER))
		..(severity)
		return

	for(var/datum/data/record/R in data_core.security)
		if(prob(10/severity))
			switch(rand(1,6))
				if(1)
					R.fields["name"] = "[pick(pick(first_names_male), pick(first_names_female))] [pick(last_names)]"
				if(2)
					R.fields["sex"]	= pick("Male", "Female")
				if(3)
					R.fields["age"] = rand(5, 85)
				if(4)
					R.fields["criminal"] = pick("None", "*Arrest*", "Incarcerated", "Parolled", "Released")
				if(5)
					R.fields["p_stat"] = pick("*Unconcious*", "Active", "Physically Unfit")
					if(PDA_Manifest.len)
						PDA_Manifest.Cut()
				if(6)
					R.fields["m_stat"] = pick("*Insane*", "*Unstable*", "*Watch*", "Stable")
			continue

		else if(prob(1))
			qdel(R)
			continue

	..(severity)

/obj/machinery/computer/secure_data/detective_computer
	icon_state = "messyfiles"

#undef SEC_DATA_R_LIST
#undef SEC_DATA_MAINT
#undef SEC_DATA_RECORD

#undef FIELD
