/obj/machinery/computer3/card
	default_prog = /datum/file/program/card_comp
	spawn_parts = list(/obj/item/part/computer/storage/hdd,/obj/item/part/computer/cardslot/dual)
/obj/machinery/computer3/card/hop
	default_prog = /datum/file/program/card_comp
	spawn_parts = list(/obj/item/part/computer/storage/hdd,/obj/item/part/computer/cardslot/dual)
	spawn_files = list(/datum/file/program/arcade, /datum/file/program/security, /datum/file/camnet_key/mining, /datum/file/camnet_key/entertainment,/datum/file/camnet_key/prison)


/obj/machinery/computer3/card/centcom
	default_prog = /datum/file/program/card_comp/centcom

/datum/file/program/card_comp
	name			= "identification card console"
	desc			= "Used to modify magnetic strip ID cards."
	image			= 'icons/ntos/cardcomp.png'
	active_state	= "id"

	var/obj/item/card/id/reader = null
	var/obj/item/card/id/writer = null

	var/mode = 0
	var/auth = 0
	var/printing = 0

/datum/file/program/card_comp/proc/list_jobs()
	return get_all_jobs() + "Custom"

// creates the block with the script in it
// cache the result since it's almost constant but not quite
// the list of jobs won't change after all...
/datum/file/program/card_comp/proc/scriptblock()
	var/global/dat = null
	var/counter = 0
	var jobs_all = ""
	jobs_all += "<table><tr><td></td><td><b>Command</b></td>"

	jobs_all += "</tr><tr height='20'><td><b>Special</b></td>"//Site Manager in special because he is head of heads ~Intercross21
	jobs_all += "<td weight='100'><a href='byond://?src=\ref[src];;assign="+JOB_SITE_MANAGER+"'>"+JOB_SITE_MANAGER+"</a></td>"
	jobs_all += "<td weight='100'><a href='byond://?src=\ref[src];;assign=Custom'>Custom</a></td>"

	counter = 0
	jobs_all += "</tr><tr><td>" + span_red(span_bold("Security")) + "</td>"//Red
	for(var/job in security_positions)
		counter++
		if(counter >= 6)
			jobs_all += "</tr><tr height='20'><td></td><td></td>"
			counter = 0
		jobs_all += "<td height='20' weight='100'><a href='byond://?src=\ref[src];assign=[job]'>[replacetext(job, " ", "&nbsp")]</a></td>"

	counter = 0
	jobs_all += "</tr><tr><td>" + span_orange(span_bold("Engineering")) + "</td>"//Orange
	for(var/job in engineering_positions)
		counter++
		if(counter >= 6)
			jobs_all += "</tr><tr height='20'><td></td><td></td>"
			counter = 0
		jobs_all += "<td height='20' weight='100'><a href='byond://?src=\ref[src];assign=[job]'>[replacetext(job, " ", "&nbsp")]</a></td>"

	counter = 0
	jobs_all += "</tr><tr height='20'><td>" + span_green(span_bold("Medical")) + "</td>"//Green
	for(var/job in medical_positions)
		counter++
		if(counter >= 6)
			jobs_all += "</tr><tr height='20'><td></td><td></td>"
			counter = 0
		jobs_all += "<td weight='100'><a href='byond://?src=\ref[src];assign=[job]'>[replacetext(job, " ", "&nbsp")]</a></td>"

	counter = 0
	jobs_all += "</tr><tr height='20'><td>" + span_purple(span_bold("Science")) + "</td>"//Purple
	for(var/job in science_positions)
		counter++
		if(counter >= 6)
			jobs_all += "</tr><tr height='20'><td></td><td></td>"
			counter = 0
		jobs_all += "<td weight='100'><a href='byond://?src=\ref[src];assign=[job]'>[replacetext(job, " ", "&nbsp")]</a></td>"

	counter = 0
	jobs_all += "</tr><tr height='20'><td>" + span_grey(span_bold("Civilian")) + "</td>"//Grey
	for(var/job in civilian_positions)
		counter++
		if(counter >= 6)
			jobs_all += "</tr><tr height='20'><td></td><td></td>"
			counter = 0
		jobs_all += "<td weight='100'><a href='byond://?src=\ref[src];assign=[job]'>[replacetext(job, " ", "&nbsp")]</a></td>"

		dat = {"<script type="text/javascript">
							function markRed(){
								var nameField = document.getElementById('namefield');
								nameField.style.backgroundColor = "#FFDDDD";
							}
							function markGreen(){
								var nameField = document.getElementById('namefield');
								nameField.style.backgroundColor = "#DDFFDD";
							}
							function markAccountGreen(){
								var nameField = document.getElementById('accountfield');
								nameField.style.backgroundColor = "#DDFFDD";
							}
							function markAccountRed(){
								var nameField = document.getElementById('accountfield');
								nameField.style.backgroundColor = "#FFDDDD";
							}
							function showAll(){
								var allJobsSlot = document.getElementById('alljobsslot');
								allJobsSlot.innerHTML = "<a href='#' onclick='hideAll()'>hide</a><br>"+ "[jobs_all]";
							}
							function hideAll(){
								var allJobsSlot = document.getElementById('alljobsslot');
								allJobsSlot.innerHTML = "<a href='#' onclick='showAll()'>[(writer.assignment) ? writer.assignment : "Unassgied"]</a>";
							}
						</script>"}
	return dat

// creates the list of access rights on the card
/datum/file/program/card_comp/proc/accessblock()
	var/accesses = "<div align='center'><b>Access</b></div>"
	accesses += "<table style='width:100%'>"
	accesses += "<tr>"
	for(var/i = 1; i <= 7; i++)
		accesses += "<td style='width:14%'><b>[get_region_accesses_name(i)]:</b></td>"
	accesses += "</tr><tr>"
	for(var/i = 1; i <= 7; i++)
		accesses += "<td style='width:14%' valign='top'>"
		for(var/A in get_region_accesses(i))
			if(A in writer.GetAccess())
				accesses += topic_link(src,"access=[A]",span_red("[replacetext(get_access_desc(A), " ", "&nbsp")]")) + " "
			else
				accesses += topic_link(src,"access=[A]",replacetext(get_access_desc(A), " ", "&nbsp")) + " "
			accesses += "<br>"
		accesses += "</td>"
	accesses += "</tr></table>"
	return accesses

/datum/file/program/card_comp/proc/card_modify_menu()
	//assume peripherals and cards, do checks for them in interact

	// Header
	var/dat = "<div align='center'><br>"
	dat += topic_link(src,"remove=writer","Remove [writer.name]") + " || "
	dat += topic_link(src,"remove=reader","Remove [reader.name]") + " <br> "
	dat += topic_link(src,"mode=1","Access Crew Manifest") + " || "
	dat += topic_link(src,"logout","Log Out") + "</div>"
	dat += "<hr>" + scriptblock()

	// form for renaming the ID
	dat += "<form name='cardcomp' action='byond://' method='get'>"
	dat += "<input type='hidden' name='src' value='\ref[src]'>"
	dat += span_bold("registered_name:") + " <input type='text' id='namefield' name='reg' value='[writer.registered_name]' style='width:250px; background-color:white;' onchange='markRed()'>"
	dat += "<input type='submit' value='Rename' onclick='markGreen()'>"
	dat += "</form>"

	// form for changing assignment, taken care of by scriptblock() mostly
	var/assign_temp = writer.assignment
	if(!assign_temp || assign_temp == "") assign_temp = "Unassigned"
	dat += span_bold("Assignment:") + " [assign_temp] <span id='alljobsslot'><a href='#' onclick='showAll()'>change</a></span>"

	// list of access rights
	dat += accessblock()
	return dat

/datum/file/program/card_comp/proc/login_menu()
	//assume peripherals and cards, do checks for them in interact
	var/dat = "<br><i>Please insert the cards into the slots</i><br>"

	if(istype(writer))
		dat += "Target: [topic_link(src,"remove=writer",writer.name)]<br>"
	else
		dat += "Target: [topic_link(src,"insert=writer","--------")]<br>"

	if(istype(reader))
		dat += "Confirm Identity: [topic_link(src,"remove=reader",reader.name)]<br>"
	else
		dat += "Confirm Identity: [topic_link(src,"insert=reader","--------")]<br>"
	dat += "[topic_link(src,"auth","{Log in}")]<br><hr>"
	dat += topic_link(src,"mode=1","Access Crew Manifest")
	return dat

/datum/file/program/card_comp/proc/show_manifest()
	// assume linked_db since called by interact()
	var/crew = ""
	var/list/L = list()
	for (var/datum/data/record/t in GLOB.data_core.general)
		var/R = t.fields["name"] + " - " + t.fields["rank"]
		L += R
	for(var/R in sortList(L))
		crew += "[R]<br>"
	return "<tt>" + span_bold("Crew Manifest:") + "<br>Please use security record computer to modify entries.<br><br>[crew][topic_link(src,"print","Print")]<br><br>[topic_link(src,"mode=0","Access ID modification console.")]<br></tt>"

// These are here partly in order to be overwritten by the centcom card computer code
/datum/file/program/card_comp/proc/authenticate()
	if(access_change_ids in reader.GetAccess())
		return 1
	if(isAI(usr))
		return 1
	return 0

/datum/file/program/card_comp/proc/set_default_access(var/jobname)
	var/datum/job/jobdatum
	for(var/jobtype in typesof(/datum/job))
		var/datum/job/J = new jobtype
		if(ckey(J.title) == ckey(jobname))
			jobdatum = J
			break
	if(jobdatum)
		writer.access = jobdatum.get_access() // ( istype(src,/obj/machinery/computer/card/centcom) ? get_centcom_access(t1)


/datum/file/program/card_comp/interact()
	if(!interactable())
		return

	if(!istype(computer.cardslot, /obj/item/part/computer/cardslot/dual))
		computer.Crash(MISSING_PERIPHERAL)
		return

	var/obj/item/part/computer/cardslot/dual/D = computer.cardslot
	reader = D.reader
	writer = D.writer

	var/dat

	switch(mode)
		if(0)
			if( !istype(writer) || !istype(reader) )
				auth = 0
			if( !auth )
				dat = login_menu()
			else
				dat = card_modify_menu()
		if(1)
			dat = show_manifest()


	popup.width = 940
	popup.height = 520
	popup.set_content(dat)
	popup.open()
	return


/datum/file/program/card_comp/Topic(href, list/href_list)
	if(!interactable() || !computer.cardslot || ..(href,href_list))
		return
	// todo distance/disability checks

	if("mode" in href_list)
		mode = text2num(href_list["mode"])
		if(mode != 0 && mode != 1)
			mode = 0

		auth = 0 // always log out if switching modes just in case

	if("remove" in href_list)
		var/which = href_list["remove"]
		if(which == "writer")
			computer.cardslot.remove(usr, 2)
		else
			computer.cardslot.remove(usr, 1)
		auth = 0

	if("insert" in href_list)
		var/obj/item/card/card = usr.get_active_hand()
		if(!istype(card)) return

		var/which = href_list["insert"]
		if(which == "writer")
			computer.cardslot.insert(card, usr, 2)
		else
			computer.cardslot.insert(card,usr)

	if("print" in href_list)
		if (printing)
			return

		printing = 1
		sleep(50)
		var/obj/item/paper/P = new /obj/item/paper( computer.loc )
		P.info = span_bold("Crew Manifest:") + "<BR>"
		var/list/L = list()
		for (var/datum/data/record/t in GLOB.data_core.general)
			var/R = t.fields["name"] + " - " + t.fields["rank"]
			L += R
		for(var/R in sortList(L))
			P.info += "[R]<br>"
		P.name = "paper- 'Crew Manifest'"
		printing = 0

	if("auth" in href_list)
		auth = 0
		if(istype(reader) && istype(writer) && authenticate())
			auth = 1

	if("logout" in href_list)
		auth = 0

	// Actual ID changing

	if("access" in href_list)
		if(auth)
			var/access_type = text2num(href_list["access"])
			writer.access ^= list(access_type)		//logical xor: remove if present, add if not

	if("assign" in href_list)
		if(auth)
			var/t1 = href_list["assign"]
			if(t1 == "Custom")
				var/temp_t = sanitize(tgui_input_text(usr, "Enter a custom job assignment.","Assignment"))
				if(temp_t)
					t1 = temp_t
			set_default_access(t1)

			writer.assignment = t1
			writer.name = text("[writer.registered_name]'s ID Card ([writer.assignment])")
			data_core.manifest_modify(writer.registered_name, writer.assignment, writer.rank)
			callHook("reassign_employee", list(writer))

	if("reg" in href_list)
		if(auth)
			writer.registered_name = href_list["reg"]
			writer.name = text("[writer.registered_name]'s ID Card ([writer.assignment])")
			data_core.manifest_modify(writer.registered_name, writer.assignment, writer.rank)
			callHook("reassign_employee", list(writer))

	computer.updateUsrDialog(usr)
	return

/datum/file/program/card_comp/centcom
	name = "CentCom identification console"
	drm = 1

/datum/file/program/card_comp/centcom/list_jobs()
	return get_all_centcom_jobs() + "Custom"

/datum/file/program/card_comp/centcom/accessblock()
	var/accesses = "<h5>[using_map.boss_name]:</h5>"
	for(var/A in get_all_centcom_access())
		if(A in writer.GetAccess())
			accesses += topic_link(src,"access=[A]",span_red("[replacetext(get_centcom_access_desc(A), " ", "&nbsp")]")) + " "
		else
			accesses += topic_link(src,"access=[A]",replacetext(get_centcom_access_desc(A), " ", "&nbsp")) + " "
	return accesses

/datum/file/program/card_comp/centcom/authenticate()
	if(access_cent_captain in reader.GetAccess())
		return 1
	return 0
