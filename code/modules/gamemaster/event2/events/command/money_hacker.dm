/datum/event2/meta/money_hacker
	name = "money hacker"
	departments = list(DEPARTMENT_COMMAND)
	chaos = 10
	chaotic_threshold = EVENT_CHAOS_THRESHOLD_LOW_IMPACT
	event_type = /datum/event2/event/money_hacker

/datum/event2/meta/money_hacker/get_weight()
	var/command = metric.count_people_with_job(/datum/job/hop) + metric.count_people_with_job(/datum/job/captain)

	if(!command)
		return 0
	return 30 + (command * 20) + (all_money_accounts.len * 5)



/datum/event2/event/money_hacker
	length_lower_bound = 8 MINUTES
	length_upper_bound = 12 MINUTES
	var/datum/money_account/targeted_account = null

/datum/event2/event/money_hacker/set_up()
	if(LAZYLEN(all_money_accounts))
		targeted_account = pick(all_money_accounts)

	if(!targeted_account)
		log_debug("Money hacker event could not find an account to hack. Aborting.")
		abort()
		return

/datum/event2/event/money_hacker/announce()
	var/message = "A brute force hack has been detected (in progress since [stationtime2text()]). The target of the attack is: Financial account #[targeted_account.account_number], \
	without intervention this attack will succeed in approximately 10 minutes. Required intervention: temporary suspension of affected accounts until the attack has ceased. \
	Notifications will be sent as updates occur."
	var/my_department = "[location_name()] Firewall Subroutines"

	for(var/obj/machinery/message_server/MS in machines)
		if(!MS.active)
			continue
		MS.send_rc_message(JOB_HEAD_OF_PERSONNEL + "'s Desk", my_department, "[message]<br>", "", "", 2)

	// Nobody reads the requests consoles so lets use the radio as well.
	global_announcer.autosay(message, my_department, DEPARTMENT_COMMAND)

/datum/event2/event/money_hacker/end()
	var/message = null
	if(targeted_account && !targeted_account.suspended) // Hacker wins.
		message = "The hack attempt has succeeded."
		hack_account(targeted_account)
		log_debug("Money hacker event managed to hack the targeted account.")

	else // Crew wins.
		message = "The attack has ceased, the affected accounts can now be brought online."
		log_debug("Money hacker event failed to hack the targeted account due to intervention by the crew.")

	var/my_department = "[location_name()] Firewall Subroutines"

	for(var/obj/machinery/message_server/MS in machines)
		if(!MS.active) continue
		MS.send_rc_message(JOB_HEAD_OF_PERSONNEL + "'s Desk", my_department, message, "", "", 2)

	global_announcer.autosay(message, my_department, DEPARTMENT_COMMAND)

/datum/event2/event/money_hacker/proc/hack_account(datum/money_account/A)
	// Subtract the money.
	var/lost = A.money * 0.8 + (rand(2,4) - 2) / 10
	A.money -= lost

	// Create a taunting log entry.
	var/datum/transaction/T = new()
	T.target_name = pick(list(
		"",
		"yo brotha from anotha motha",
		"el Presidente",
		"chieF smackDowN",
		"Nobody"
	))

	T.purpose = pick(list(
		"Ne$ ---ount fu%ds init*&lisat@*n",
		"PAY BACK YOUR MUM",
		"Funds withdrawal",
		"pWnAgE",
		"l33t hax",
		"liberationez",
		"Hit",
		"Nothing"
	))

	T.amount = pick(list(
		"",
		"([rand(0,99999)])",
		"alla money",
		"9001$",
		"HOLLA HOLLA GET DOLLA",
		"([lost])",
		"69,420t"
		))

	var/date1 = "1 January 1970" // Unix epoch.
	var/date2 = "[num2text(rand(1,31))] [pick("January","February","March","April","May","June","July","August","September","October","November","December")], [rand(1000,3000)]"
	T.date = pick("", current_date_string, date1, date2,"Nowhen")

	var/time1 = rand(0, 99999999)
	var/time2 = "[round(time1 / 36000)+12]:[(time1 / 600 % 60) < 10 ? add_zero(time1 / 600 % 60, 1) : time1 / 600 % 60]"
	T.time = pick("", stationtime2text(), time2, "Never")

	T.source_terminal = pick("","[pick("Biesel","New Gibson")] GalaxyNet Terminal #[rand(111,999)]","your mums place","nantrasen high CommanD","Angessa's Pearl","Nowhere")

	A.transaction_log.Add(T)
