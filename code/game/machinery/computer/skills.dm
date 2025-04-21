//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

#define GENERAL_RECORD_LIST 2
#define GENERAL_RECORD_MAINT 3
#define GENERAL_RECORD_DATA 4

#define FIELD(N, V, E) list(field = N, value = V, edit = E)

/obj/machinery/computer/skills//TODO:SANITY //[TO DO] Change name to PCU and update mapdata to include replacement computers
	name = "\improper Employment Records PCU"
	desc = "A personal computer unit that's used to view, edit and maintain employment records."
	icon_screen = "pcu_generic"
	icon_state = "pcu"
	icon_keyboard = "pcu_key"
	light_color = "#5284e7"
	req_one_access = list(access_heads)
	circuit = /obj/item/circuitboard/skills/pcu
	density = FALSE
	var/obj/item/card/id/scan = null
	var/authenticated = null
	var/rank = null
	var/screen = null
	var/datum/data/record/active1 = null
	var/a_id = null
	var/list/temp = null
	var/printing = null
	var/can_change_id = 0
	// The below are used to make modal generation more convenient
	var/static/list/field_edit_questions
	var/static/list/field_edit_choices

/obj/machinery/computer/skills/Initialize(mapload)
	. = ..()
	field_edit_questions = list(
		// General
		"name" = "Please input new name:",
		"id" = "Please input new ID:",
		"sex" = "Please select new sex:",
		"species" = "Please input new species:",
		"age" = "Please input new age:",
		"fingerprint" = "Please input new fingerprint hash:",
		"home_system" = "Please input new home:",
		"birthplace" = "Please input new birthplace:",
		"citizenship" = "Please input new citizenship:",
		"languages" = "Please input known languages:",
		"faction" = "Please input new employer:",
		"religion" = "Please input new religion:",
	)
	field_edit_choices = list(
		// General
		"sex" = all_genders_text_list,
		"p_stat" = list("*Deceased*", "*SSD*", "Active", "Physically Unfit", "Disabled"),
		"m_stat" = list("*Insane*", "*Unstable*", "*Watch*", "Stable"),
	)

/obj/machinery/computer/skills/Destroy()
	active1 = null
	return ..()

/obj/machinery/computer/skills/attackby(obj/item/O as obj, var/mob/user)
	if(istype(O, /obj/item/card/id) && !scan && user.unEquip(O))
		O.loc = src
		scan = O
		to_chat(user, "You insert [O].")
		tgui_interact(user)
	else
		..()

/obj/machinery/computer/skills/attack_ai(mob/user as mob)
	return attack_hand(user)

//Someone needs to break down the dat += into chunks instead of long ass lines.
/obj/machinery/computer/skills/attack_hand(mob/user as mob)
	if(..())
		return
	if (using_map && !(src.z in using_map.contact_levels))
		to_chat(user, span_danger("Unable to establish a connection:") + " You're too far away from the station!")
		return
	tgui_interact(user)

/obj/machinery/computer/skills/tgui_interact(mob/user, datum/tgui/ui = null)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "GeneralRecords", "Employee Records") // 800, 380
		ui.open()
		ui.set_autoupdate(FALSE)

/obj/machinery/computer/skills/tgui_data(mob/user)
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
			if(GENERAL_RECORD_LIST)
				if(!isnull(GLOB.data_core.general))
					var/list/records = list()
					data["records"] = records
					for(var/datum/data/record/R in sortRecord(GLOB.data_core.general))
						records[++records.len] = list(
							"ref" = "\ref[R]",
							"id" = R.fields["id"],
							"name" = R.fields["name"],
							"b_dna" = R.fields["b_dna"])
			if(GENERAL_RECORD_DATA)
				var/list/general = list()
				data["general"] = general
				if(istype(active1, /datum/data/record) && GLOB.data_core.general.Find(active1))
					var/list/fields = list()
					general["fields"] = fields
					fields[++fields.len] = FIELD("Name", active1.fields["name"], "name")
					fields[++fields.len] = FIELD("ID", active1.fields["id"], "id")
					fields[++fields.len] = FIELD("Sex", active1.fields["sex"], "sex")
					fields[++fields.len] = FIELD("Species", active1.fields["species"], "species")
					fields[++fields.len] = FIELD("Age", active1.fields["age"], "age")
					fields[++fields.len] = FIELD("Fingerprint", active1.fields["fingerprint"], "fingerprint")
					fields[++fields.len] = FIELD("Home", active1.fields["home_system"], "home_system")
					fields[++fields.len] = FIELD("Birthplace", active1.fields["birthplace"], "birthplace")
					fields[++fields.len] = FIELD("Citizenship", active1.fields["citizenship"], "citizenship")
					fields[++fields.len] = FIELD("Faction", active1.fields["faction"], "faction")
					fields[++fields.len] = FIELD("Religion", active1.fields["religion"], "religion")
					fields[++fields.len] = FIELD("Known Languages", active1.fields["languages"], "languages")
					fields[++fields.len] = FIELD("Physical Status", active1.fields["p_stat"], null)
					fields[++fields.len] = FIELD("Mental Status", active1.fields["m_stat"], null)
					var/list/photos = list()
					general["photos"] = photos
					photos[++photos.len] = active1.fields["photo-south"]
					photos[++photos.len] = active1.fields["photo-west"]
					general["has_photos"] = (active1.fields["photo-south"] || active1.fields["photo-west"] ? 1 : 0)
					if(!active1.fields["comments"] || !islist(active1.fields["comments"]))
						active1.fields["comments"] = list()
					general["skills"] = active1.fields["notes"]
					general["comments"] = active1.fields["comments"]
					general["empty"] = 0
				else
					general["empty"] = 1

	data["modal"] = tgui_modal_data(src)
	return data

/obj/machinery/computer/skills/tgui_act(action, params, datum/tgui/ui)
	if(..())
		return TRUE

	add_fingerprint(ui.user)

	if(!GLOB.data_core.general.Find(active1))
		active1 = null

	. = TRUE
	if(tgui_act_modal(action, params))
		return

	switch(action)
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
		if("cleartemp")
			temp = null
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
				screen = GENERAL_RECORD_LIST
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
			if("screen")
				screen = clamp(text2num(params["screen"]) || 0, GENERAL_RECORD_LIST, GENERAL_RECORD_MAINT)
				active1 = null
			if("del_all")
				if(GLOB.PDA_Manifest)
					GLOB.PDA_Manifest.Cut()
				for(var/datum/data/record/R in GLOB.data_core.general)
					qdel(R)
				set_temp("All employment records deleted.")
			if("sync_r")
				if(active1)
					set_temp(client_update_record(src,active1,ui.user))
			if("edit_notes")
				// The modal input in tgui is busted for this sadly...
				var/new_notes = strip_html_simple(tgui_input_text(ui.user,"Enter new information here.","Character Preference", html_decode(active1.fields["notes"]), MAX_RECORD_LENGTH, TRUE, prevent_enter = TRUE), MAX_RECORD_LENGTH)
				if(ui.user.Adjacent(src))
					if(new_notes != "" || tgui_alert(ui.user, "Are you sure you want to delete the current record's notes?", "Confirm Delete", list("Delete", "No")) == "Delete")
						if(ui.user.Adjacent(src))
							active1.fields["notes"] = new_notes
			if("del_r")
				if(GLOB.PDA_Manifest)
					GLOB.PDA_Manifest.Cut()
				if(active1)
					for(var/datum/data/record/R in GLOB.data_core.medical)
						if ((R.fields["name"] == active1.fields["name"] || R.fields["id"] == active1.fields["id"]))
							qdel(R)
					set_temp("Employment record deleted.")
					QDEL_NULL(active1)
			if("d_rec")
				var/datum/data/record/general_record = locate(params["d_rec"] || "")
				if(!GLOB.data_core.general.Find(general_record))
					set_temp("Record not found.", "danger")
					return

				active1 = general_record
				screen = GENERAL_RECORD_DATA
			if("new")
				if(GLOB.PDA_Manifest)
					GLOB.PDA_Manifest.Cut()
				active1 = GLOB.data_core.CreateGeneralRecord()
				screen = GENERAL_RECORD_DATA
				set_temp("Employment record created.", "success")
			if("del_c")
				var/index = text2num(params["del_c"] || "")
				if(!index || !istype(active1, /datum/data/record))
					return

				var/list/comments = active1.fields["comments"]
				index = clamp(index, 1, length(comments))
				if(comments[index])
					comments.Cut(index, index + 1)
			if("print_p")
				if(!printing)
					printing = TRUE
					// playsound(loc, 'sound/goonstation/machines/printer_dotmatrix.ogg', 50, TRUE)
					SStgui.update_uis(src)
					addtimer(CALLBACK(src, PROC_REF(print_finish)), 5 SECONDS)
			else
				return FALSE

/**
 * Called in tgui_act() to process modal actions
 *
 * Arguments:
 * * action - The action passed by tgui
 * * params - The params passed by tgui
 */
/obj/machinery/computer/skills/proc/tgui_act_modal(action, params)
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

					if(istype(active1) && (field in active1.fields))
						active1.fields[field] = answer
					. = TRUE
				if("add_c")
					if(!length(answer) || !istype(active1) || !length(authenticated))
						return
					active1.fields["comments"] += list(list(
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
/obj/machinery/computer/skills/proc/print_finish()
	var/obj/item/paper/P = new(loc)
	P.info = "<center>" + span_bold("Medical Record") + "</center><br>"
	if(istype(active1, /datum/data/record) && GLOB.data_core.general.Find(active1))
		P.info += {"Name: [active1.fields["name"]] ID: [active1.fields["id"]]
		<br>\nSex: [active1.fields["sex"]]
		<br>\nSpecies: [active1.fields["species"]]
		<br>\nAge: [active1.fields["age"]]
		<br>\nFingerprint: [active1.fields["fingerprint"]]
		<br>\nHome: [active1.fields["home_system"]]
		<br>\nBirthplace: [active1.fields["birthplace"]]
		<br>\nCitizenship: [active1.fields["citizenship"]]
		<br>\nFaction: [active1.fields["faction"]]
		<br>\nReligion: [active1.fields["religion"]]
		<br>\nKnown Languages: [active1.fields["languages"]]
		<br>\nPhysical Status: [active1.fields["p_stat"]]
		<br>\nMental Status: [active1.fields["m_stat"]]<br>
		<br>\nEmployment/Skills Summary: [active1.fields["notes"]]
		<br>\n
		<center><b>Comments/Log</b></center><br>"}
		for(var/c in active1.fields["comments"])
			P.info += "[c["header"]]<br>[c["text"]]<br>"
	else
		P.info += span_bold("General Record Lost!") + "<br>"
	P.info += "</tt>"
	P.name = "paper - 'Employment Record: [active1.fields["name"]]'"
	printing = FALSE
	SStgui.update_uis(src)

/**
 * Sets a temporary message to display to the user
 *
 * Arguments:
 * * text - Text to display, null/empty to clear the message from the UI
 * * style - The style of the message: (color name), info, success, warning, danger, virus
 */
/obj/machinery/computer/skills/proc/set_temp(text = "", style = "info", update_now = FALSE)
	temp = list(text = text, style = style)
	if(update_now)
		SStgui.update_uis(src)

/obj/machinery/computer/skills/emp_act(severity)
	if(stat & (BROKEN|NOPOWER))
		..(severity)
		return

	for(var/datum/data/record/R in GLOB.data_core.security)
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
					if(GLOB.PDA_Manifest.len)
						GLOB.PDA_Manifest.Cut()
				if(6)
					R.fields["m_stat"] = pick("*Insane*", "*Unstable*", "*Watch*", "Stable")
			continue

		else if(prob(1))
			qdel(R)
			continue

	..(severity)

#undef GENERAL_RECORD_LIST
#undef GENERAL_RECORD_MAINT
#undef GENERAL_RECORD_DATA

#undef FIELD
