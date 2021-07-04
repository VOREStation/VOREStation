/datum/computer_file/program/email_administration
	filename = "emailadmin"
	filedesc = "Email Administration Utility"
	extended_desc = "This program may be used to administrate NTNet's emailing service."
	program_icon_state = "comm_monitor"
	program_key_state = "generic_key"
	program_menu_icon = "mail-open"
	size = 12
	requires_ntnet = 1
	available_on_ntnet = 1
	tgui_id = "NtosEmailAdministration"
	required_access = access_network

	var/datum/computer_file/data/email_account/current_account = null
	var/datum/computer_file/data/email_message/current_message = null
	var/error = ""

/datum/computer_file/program/email_administration/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = get_header_data()

	data["error"] = error

	data["cur_title"] = null
	data["cur_body"] = null
	data["cur_timestamp"] = null
	data["cur_source"] = null

	if(istype(current_message))
		data["cur_title"] = current_message.title
		data["cur_body"] = pencode2html(current_message.stored_data)
		data["cur_timestamp"] = current_message.timestamp
		data["cur_source"] = current_message.source

	data["current_account"] = null
	data["cur_suspended"] = null
	data["messages"] = null

	if(istype(current_account))
		data["current_account"] = current_account.login
		data["cur_suspended"] = current_account.suspended
		var/list/all_messages = list()
		for(var/datum/computer_file/data/email_message/message in (current_account.inbox | current_account.spam | current_account.deleted))
			all_messages.Add(list(list(
				"title" = message.title,
				"source" = message.source,
				"timestamp" = message.timestamp,
				"uid" = message.uid
			)))
		data["messages"] = all_messages

	var/list/all_accounts = list()
	for(var/datum/computer_file/data/email_account/account in ntnet_global.email_accounts)
		if(!account.can_login)
			continue
		all_accounts.Add(list(list(
			"login" = account.login,
			"uid" = account.uid
		)))
	data["accounts"] = all_accounts

	return data

/datum/computer_file/program/email_administration/tgui_act(action, list/params, datum/tgui/ui)
	if(..())
		return TRUE

	// High security - can only be operated when the user has an ID with access on them.
	var/obj/item/weapon/card/id/I = usr.GetIdCard()
	if(!istype(I) || !(access_network in I.access))
		return TRUE

	switch(action)
		if("back")
			if(error)
				error = ""
			else if(current_message)
				current_message = null
			else
				current_account = null
			return TRUE

		if("ban")
			if(!current_account)
				return TRUE

			current_account.suspended = !current_account.suspended
			ntnet_global.add_log_with_ids_check("EMAIL LOG: SA-EDIT Account [current_account.login] has been [current_account.suspended ? "" : "un" ]suspended by SA [I.registered_name] ([I.assignment]).")
			error = "Account [current_account.login] has been [current_account.suspended ? "" : "un" ]suspended."
			return TRUE

		if("changepass")
			if(!current_account)
				return TRUE

			var/newpass = sanitize(input(usr,"Enter new password for account [current_account.login]", "Password"), 100)
			if(!newpass)
				return TRUE
			current_account.password = newpass
			ntnet_global.add_log_with_ids_check("EMAIL LOG: SA-EDIT Password for account [current_account.login] has been changed by SA [I.registered_name] ([I.assignment]).")
			return TRUE

		if("viewmail")
			if(!current_account)
				return TRUE

			for(var/datum/computer_file/data/email_message/received_message in (current_account.inbox | current_account.spam | current_account.deleted))
				if(received_message.uid == text2num(params["viewmail"]))
					current_message = received_message
					break
			return TRUE

		if("viewaccount")
			for(var/datum/computer_file/data/email_account/email_account in ntnet_global.email_accounts)
				if(email_account.uid == text2num(params["viewaccount"]))
					current_account = email_account
					break
			return TRUE

		if("newaccount")
			var/newdomain = sanitize(tgui_input_list(usr,"Pick domain:", "Domain name", using_map.usable_email_tlds))
			if(!newdomain)
				return TRUE
			var/newlogin = sanitize(input(usr,"Pick account name (@[newdomain]):", "Account name"), 100)
			if(!newlogin)
				return TRUE

			var/complete_login = "[newlogin]@[newdomain]"
			if(ntnet_global.does_email_exist(complete_login))
				error = "Error creating account: An account with same address already exists."
				return TRUE

			var/datum/computer_file/data/email_account/new_account = new/datum/computer_file/data/email_account()
			new_account.login = complete_login
			new_account.password = GenerateKey()
			error = "Email [new_account.login] has been created, with generated password [new_account.password]"
			return TRUE
