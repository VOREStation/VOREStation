var/global/datum/ntnet/ntnet_global = new()


// This is the NTNet datum. There can be only one NTNet datum in game at once. Modular computers read data from this.
/datum/ntnet/
	var/list/relays = list()
	var/list/logs = list()
	var/list/available_station_software = list()
	var/list/available_antag_software = list()
	var/list/available_news = list()
	var/list/chat_channels = list()
	var/list/fileservers = list()
	/// Holds all the email accounts that exists. Hopefully won't exceed 999
	var/list/email_accounts = list()
	var/list/banned_nids = list()
	/// A list of nid - os datum pairs. An OS in this list is not necessarily connected to NTNet or visible on it.
	var/list/registered_nids = list()
	/// Amount of log entries the system tries to keep in memory. Keep below 999 to prevent byond from acting weirdly. High values make displaying logs much laggier.
	var/setting_maxlogcount = 100

	/// Programs requiring NTNET_SOFTWAREDOWNLOAD won't work if this is set to FALSE and public-facing device they are connecting with is wireless.
	var/setting_softwaredownload = TRUE
	/// Programs requiring NTNET_PEERTOPEER won't work if this is set to FALSE and public-facing device they are connecting with is wireless.
	var/setting_peertopeer = TRUE
	/// Programs requiring NTNET_COMMUNICATION won't work if this is set to FALSE and public-facing device they are connecting with is wireless.
	var/setting_communication = TRUE
	/// Programs requiring NTNET_SYSTEMCONTROL won't work if this is set to FALSE and public-facing device they are connecting with is wireless.
	var/setting_systemcontrol = TRUE

	/// Setting to TRUE will disable all wireless connections, independently off relays status.
	var/setting_disabled = FALSE

	/// Whether the IDS warning system is enabled
	var/intrusion_detection_enabled = TRUE
	/// Set when there is an IDS warning due to malicious (antag) software.
	var/intrusion_detection_alarm = FALSE


// If new NTNet datum is spawned, it replaces the old one.
/datum/ntnet/New()
	if(ntnet_global && (ntnet_global != src))
		ntnet_global = src // There can be only one.
	if (SSatoms && SSatoms.initialized > INITIALIZATION_INSSATOMS)
		for(var/obj/machinery/ntnet_relay/R in machines)
			relays.Add(R)
			R.NTNet = src
	build_software_lists()
	build_news_list()
	build_emails_list()
	add_log("NTNet logging system activated.")

/datum/ntnet/proc/add_log_with_ids_check(var/log_string, var/obj/item/weapon/computer_hardware/network_card/source = null)
	if(intrusion_detection_enabled)
		add_log(log_string, source)

// Simplified logging: Adds a log. log_string is mandatory parameter, source is optional.
/datum/ntnet/proc/add_log(var/log_string, var/obj/item/weapon/computer_hardware/network_card/source = null)
	var/log_text = "[stationtime2text()] - "
	if(source)
		log_text += "[source.get_network_tag()] - "
	else
		log_text += "*SYSTEM* - "
	log_text += log_string
	logs.Add(log_text)

	if(logs.len > setting_maxlogcount)
		// We have too many logs, remove the oldest entries until we get into the limit
		for(var/L in logs)
			if(logs.len > setting_maxlogcount)
				logs.Remove(L)
			else
				break

/datum/ntnet/proc/get_os_by_nid(NID)
	return registered_nids["[NID]"]

/datum/ntnet/proc/unregister(NID)
	registered_nids -= "[NID]"

/datum/ntnet/proc/check_banned(NID)
	if(!relays || !relays.len)
		return FALSE

	for(var/obj/machinery/ntnet_relay/R in relays)
		if(R.operable())
			return (NID in banned_nids)

	return FALSE

// Checks whether NTNet operates. If parameter is passed checks whether specific function is enabled.
/datum/ntnet/proc/check_function(var/specific_action = 0)
	if(!relays || !relays.len) // No relays found. NTNet is down
		return 0

	var/operating = 0

	// Check all relays. If we have at least one working relay, network is up.
	for(var/obj/machinery/ntnet_relay/R in relays)
		if(R.operable())
			operating = 1
			break

	if(setting_disabled)
		return 0

	if(specific_action == NTNET_SOFTWAREDOWNLOAD)
		return (operating && setting_softwaredownload)
	if(specific_action == NTNET_PEERTOPEER)
		return (operating && setting_peertopeer)
	if(specific_action == NTNET_COMMUNICATION)
		return (operating && setting_communication)
	if(specific_action == NTNET_SYSTEMCONTROL)
		return (operating && setting_systemcontrol)
	return operating

// Builds lists that contain downloadable software.
/datum/ntnet/proc/build_software_lists()
	available_station_software = list()
	available_antag_software = list()
	for(var/F in typesof(/datum/computer_file/program))
		var/datum/computer_file/program/prog = new F
		// Invalid type (shouldn't be possible but just in case), invalid filetype (not executable program) or invalid filename (unset program)
		if(!prog || !istype(prog) || prog.filename == "UnknownProgram" || prog.filetype != "PRG")
			continue
		// Check whether the program should be available for station/antag download, if yes, add it to lists.
		if(prog.available_on_ntnet)
			available_station_software.Add(prog)
		if(prog.available_on_syndinet)
			available_antag_software.Add(prog)

// Builds lists that contain downloadable software.
/datum/ntnet/proc/build_news_list()
	available_news = list()
	for(var/F in typesof(/datum/computer_file/data/news_article/))
		var/datum/computer_file/data/news_article/news = new F(1)
		if(news.stored_data)
			available_news.Add(news)

// Generates service email list. Currently only used by broadcaster service
/datum/ntnet/proc/build_emails_list()
	for(var/F in subtypesof(/datum/computer_file/data/email_account/service))
		new F()

// Attempts to find a downloadable file according to filename var
/datum/ntnet/proc/find_ntnet_file_by_name(var/filename)
	for(var/datum/computer_file/program/P in available_station_software)
		if(filename == P.filename)
			return P
	for(var/datum/computer_file/program/P in available_antag_software)
		if(filename == P.filename)
			return P

// Resets the IDS alarm
/datum/ntnet/proc/resetIDS()
	intrusion_detection_alarm = 0
	add_log("-!- INTRUSION DETECTION ALARM RESET BY SYSTEM OPERATOR -!-")

/datum/ntnet/proc/toggleIDS()
	resetIDS()
	intrusion_detection_enabled = !intrusion_detection_enabled
	add_log("Configuration Updated. Intrusion Detection [intrusion_detection_enabled ? "enabled" : "disabled"].")

// Removes all logs
/datum/ntnet/proc/purge_logs()
	logs = list()
	add_log("-!- LOGS DELETED BY SYSTEM OPERATOR -!-")

// Updates maximal amount of stored logs. Use this instead of setting the number, it performs required checks.
/datum/ntnet/proc/update_max_log_count(var/lognumber)
	if(!lognumber)
		return 0
	// Trim the value if necessary
	lognumber = between(MIN_NTNET_LOGS, lognumber, MAX_NTNET_LOGS)
	setting_maxlogcount = lognumber
	add_log("Configuration Updated. Now keeping [setting_maxlogcount] logs in system memory.")

/datum/ntnet/proc/toggle_function(var/function)
	if(!function)
		return
	function = text2num(function)
	switch(function)
		if(NTNET_SOFTWAREDOWNLOAD)
			setting_softwaredownload = !setting_softwaredownload
			add_log("Configuration Updated. Wireless network firewall now [setting_softwaredownload ? "allows" : "disallows"] connection to software repositories.")
		if(NTNET_PEERTOPEER)
			setting_peertopeer = !setting_peertopeer
			add_log("Configuration Updated. Wireless network firewall now [setting_peertopeer ? "allows" : "disallows"] peer to peer network traffic.")
		if(NTNET_COMMUNICATION)
			setting_communication = !setting_communication
			add_log("Configuration Updated. Wireless network firewall now [setting_communication ? "allows" : "disallows"] instant messaging and similar communication services.")
		if(NTNET_SYSTEMCONTROL)
			setting_systemcontrol = !setting_systemcontrol
			add_log("Configuration Updated. Wireless network firewall now [setting_systemcontrol ? "allows" : "disallows"] remote control of station's systems.")

/datum/ntnet/proc/does_email_exist(var/login)
	for(var/datum/computer_file/data/email_account/A in ntnet_global.email_accounts)
		if(A.login == login)
			return 1
	return 0

/datum/ntnet/proc/get_chat_channel_by_id(id)
	for(var/datum/ntnet_conversation/chan in chat_channels)
		if(chan.id == id)
			return chan
