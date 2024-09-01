/datum/eventkit/fake_pdaconvos
	var/list/names = list()		//Assoc list of refs in fakeRefs = name
	var/list/fakeRefs = list() //Used to find elements in other lists and tracking conversations. MUST BE UNIQUE.
	var/list/fakeJobs = list() //Assoc list of name in names = job


/client/proc/fake_pdaconvos()
	set category = "EventKit"
	set name = "Manage PDA identities"
	set desc = "Creates fake identities for use in setting up PDA props"

	if(!check_rights(R_FUN))
		return

	var/choice = tgui_input_list(usr, "What do you wish to do?", "Options",
	list("Add new identity", "Edit existing identity", "Delete existing identity", "Delete holder", "Cancel"))

	if(choice == "Delete holder")
		qdel(fakeConversations)
		fakeConversations = null
		return
	if(choice == "Cancel")
		return

	if(!fakeConversations || !istype(fakeConversations, /datum/eventkit/fake_pdaconvos))
		fakeConversations = new /datum/eventkit/fake_pdaconvos

	var/datum/eventkit/fake_pdaconvos/FPC = fakeConversations

	if(choice == "Add new identity")
		var/newRef = sanitize(tgui_input_text(usr, "Input unique reference. Duplicates are FORBIDDEN!. Players can't see this.\
		Used to uniquely identify conversations in PDAs", null))
		if(!newRef) return
		FPC.fakeRefs.Add(newRef)
		FPC.names[newRef] = sanitize(tgui_input_text(usr, "Input fake name",newRef))
		FPC.fakeJobs[newRef] = sanitize(tgui_input_text(usr, "Input fake assignment.",newRef))
		to_chat(usr, span_notice("You have created [newRef]. Current name: [FPC.names[newRef]]. Current assignment: [FPC.fakeJobs[newRef]]"))
		return

	if(choice == "Edit existing identity")
		var/ref = tgui_input_list(usr, "Pick which identity to edit (details are printed to chat)", "identities", FPC.fakeRefs)
		to_chat(usr, span_notice("You are editing [ref]. Current name: [FPC.names[ref]]. Current assignment: [FPC.fakeJobs[ref]]"))
		var/editChoice = tgui_alert(usr, "What do you wish to edit?", "Details", list("Name", "Job", "Cancel"))
		if(editChoice == "Name")
			FPC.names[ref] = sanitize(tgui_input_text(usr, "Input fake name", FPC.names[ref]))
			to_chat(usr, span_notice("Current data for [ref] are : Current name: [FPC.names[ref]]. Current assignment: [FPC.fakeJobs[ref]]"))
		if(editChoice == "Job")
			FPC.fakeJobs[ref] = sanitize(tgui_input_text(usr, "Input fake name", FPC.fakeJobs[ref]))
			to_chat(usr, span_notice("Current data for [ref] are : Current name: [FPC.names[ref]]. Current assignment: [FPC.fakeJobs[ref]]"))
		return
	if(choice == "Delete existing identity")
		var/ref = tgui_input_list(usr, "Pick which identity to delete (details are printed to chat)", "identities", FPC.fakeRefs)
		if(tgui_alert(usr, "You are deleting [ref]. Current name: [FPC.names[ref]]. Current assignment: [FPC.fakeJobs[ref]]",
		"are you sure?", list("Yes", "No"))=="Yes")
			FPC.fakeRefs =- ref
			FPC.fakeJobs =- ref
			FPC.names =- ref
		return



/*
Invoked by vv topic "fakepdapropconvo" in code\modules\admin\view_variables\topic.dm found in PDA vv dropdown.
*/
/obj/item/device/pda/proc/createPropFakeConversation_admin(mob/M)
	if(!M.client || !check_rights_for(M.client,R_FUN))
		return

	var/datum/eventkit/fake_pdaconvos/FPC = M.client.fakeConversations

	if(!FPC || !istype(FPC, /datum/eventkit/fake_pdaconvos))
		to_chat(M, span_warning("First you must create a new identity with Manage PDA identities in EventKit"))
		return

	var/choice = tgui_alert(M,"Use TGUI or dialogue boxes?", "TGUI?", list("TGUI", "Dialogue", "Cancel"))
	if(!choice || choice == "Cancel") return

	var/datum/data/pda/app/messenger/ourPDA = find_program(/datum/data/pda/app/messenger)

	if(choice == "Dialogue")
		var/identity = tgui_input_list(M, "Pick which identity to use(details are printed to chat)", "identities", FPC.fakeRefs)
		var/job = FPC.fakeJobs[identity]
		var/name = FPC.names[identity]
		to_chat(M, span_notice("You are using [identity]. Current name: [name]. Current assignment: [job]"))
		var/safetyLimit = 0
		while(safetyLimit < 30)
			safetyLimit += 1
			var/message = sanitize(tgui_input_text(M, "Input fake message. Leave empty to cancel. Can create up to 30 messages in a row",null),
			MAX_MESSAGE_LEN)
			if(!message) return
			var/input = tgui_alert(M, "Received or Sent?", "Direction", list("Received", "Sent"))
			if(!input)
				return
			var/receipent = ((input=="Sent") ? 1 : 0)
			ourPDA.createFakeMessage(name,identity,job,receipent, message)

	if(choice == "TGUI")
		to_chat(M, span_notice("Sorry, the TGUI functionality is not yet implemented - use Dialogue mode!"))
