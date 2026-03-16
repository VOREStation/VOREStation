/datum/eventkit/fake_pdaconvos
	var/list/names = list()		//Assoc list of refs in fakeRefs = name
	var/list/fakeRefs = list() //Used to find elements in other lists and tracking conversations. MUST BE UNIQUE.
	var/list/fakeJobs = list() //Assoc list of name in names = job

ADMIN_VERB(fake_pdaconvos, R_FUN, "Manage PDA identities", "Creates fake identities for use in setting up PDA props", ADMIN_CATEGORY_FUN_EVENT_KIT)
	var/choice = tgui_input_list(user, "What do you wish to do?", "Options",
	list("Add new identity", "Edit existing identity", "Delete existing identity", "Delete holder", "Cancel"))

	if(choice == "Delete holder")
		QDEL_NULL(user.fakeConversations)
		return
	if(choice == "Cancel")
		return

	if(!user.fakeConversations || !istype(user.fakeConversations, /datum/eventkit/fake_pdaconvos))
		user.fakeConversations = new /datum/eventkit/fake_pdaconvos

	var/datum/eventkit/fake_pdaconvos/FPC = user.fakeConversations

	if(choice == "Add new identity")
		var/newRef = tgui_input_text(user, "Input unique reference. Duplicates are FORBIDDEN!. Players can't see this.\
		Used to uniquely identify conversations in PDAs", null, MAX_MESSAGE_LEN)
		if(!newRef) return
		FPC.fakeRefs.Add(newRef)
		FPC.names[newRef] = tgui_input_text(user, "Input fake name",newRef, "", MAX_MESSAGE_LEN)
		FPC.fakeJobs[newRef] = tgui_input_text(user, "Input fake assignment.",newRef, "", MAX_MESSAGE_LEN)
		to_chat(user, span_notice("You have created [newRef]. Current name: [FPC.names[newRef]]. Current assignment: [FPC.fakeJobs[newRef]]"))
		return

	if(choice == "Edit existing identity")
		var/ref = tgui_input_list(user, "Pick which identity to edit (details are printed to chat)", "identities", FPC.fakeRefs)
		to_chat(user, span_notice("You are editing [ref]. Current name: [FPC.names[ref]]. Current assignment: [FPC.fakeJobs[ref]]"))
		var/editChoice = tgui_alert(user, "What do you wish to edit?", "Details", list("Name", "Job", "Cancel"))
		if(editChoice == "Name")
			FPC.names[ref] = tgui_input_text(user, "Input fake name", FPC.names[ref], "", MAX_MESSAGE_LEN)
			to_chat(user, span_notice("Current data for [ref] are : Current name: [FPC.names[ref]]. Current assignment: [FPC.fakeJobs[ref]]"))
		if(editChoice == "Job")
			FPC.fakeJobs[ref] = tgui_input_text(user, "Input fake name", FPC.fakeJobs[ref], "", MAX_MESSAGE_LEN)
			to_chat(user, span_notice("Current data for [ref] are : Current name: [FPC.names[ref]]. Current assignment: [FPC.fakeJobs[ref]]"))
		return
	if(choice == "Delete existing identity")
		var/ref = tgui_input_list(user, "Pick which identity to delete (details are printed to chat)", "identities", FPC.fakeRefs)
		if(tgui_alert(user, "You are deleting [ref]. Current name: [FPC.names[ref]]. Current assignment: [FPC.fakeJobs[ref]]",
		"are you sure?", list("Yes", "No"))=="Yes")
			FPC.fakeRefs =- ref
			FPC.fakeJobs =- ref
			FPC.names =- ref
		return


/*
Invoked by vv topic "fakepdapropconvo" in code\modules\admin\view_variables\topic.dm found in PDA vv dropdown.
*/
/obj/item/pda/proc/createPropFakeConversation_admin(mob/M)
	if(!M.client || !check_rights_for(M.client, R_FUN))
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
			var/message = tgui_input_text(M, "Input fake message. Leave empty to cancel. Can create up to 30 messages in a row",null, "", MAX_MESSAGE_LEN)
			if(!message) return
			var/input = tgui_alert(M, "Received or Sent?", "Direction", list("Received", "Sent"))
			if(!input)
				return
			var/receipent = ((input=="Sent") ? 1 : 0)
			ourPDA.createFakeMessage(name,identity,job,receipent, message)

	if(choice == "TGUI")
		to_chat(M, span_notice("Sorry, the TGUI functionality is not yet implemented - use Dialogue mode!"))
