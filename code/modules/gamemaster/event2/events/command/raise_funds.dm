/datum/event2/meta/raise_funds
	name = "local funding drive"
	enabled = FALSE // There isn't really any suitable way for the crew to generate thalers right now, if that gets fixed feel free to turn this event on.
	departments = list(DEPARTMENT_COMMAND, DEPARTMENT_CARGO)
	chaotic_threshold = EVENT_CHAOS_THRESHOLD_LOW_IMPACT
	event_type = /datum/event2/event/raise_funds

/datum/event2/meta/raise_funds/get_weight()
	var/command = metric.count_people_in_department(DEPARTMENT_COMMAND)
	if(!command) // Need someone to read the centcom message.
		return 0

	var/cargo = metric.count_people_in_department(DEPARTMENT_CARGO)
	return (command * 20) + (cargo * 20)



/datum/event2/event/raise_funds
	length_lower_bound = 30 MINUTES
	length_upper_bound = 45 MINUTES
	var/money_at_start = 0

/datum/event2/event/raise_funds/announce()
	var/message = "Due to [pick("recent", "unfortunate", "possible future")] budget \
	[pick("changes", "issues")], in-system stations are now advised to increase funding income."

	send_command_report("Budget Advisement", message)

/datum/event2/event/raise_funds/start()
	// Note that the event remembers the amount of money when it started. If an issue develops where people try to scam centcom by
	// taking out loads of money before the event, then depositing it back in after the event fires, feel free to make this check for
	// roundstart money instead.
	money_at_start = count_money()
	log_debug("Funding Drive event logged a sum of [money_at_start] thalers in all station accounts at the start of the event.")

/datum/event2/event/raise_funds/end()
	var/money_at_end = count_money()
	log_debug("Funding Drive event logged a sum of [money_at_end] thalers in all station accounts at the end of the event, compared \
	to [money_at_start] thalers. A difference of [money_at_end / money_at_start] was calculated.")

	// A number above 1 indicates money was made, while below 1 does the opposite.
	var/budget_shift = money_at_end / money_at_start

	// Centcom will say different things based on if they gained or lost money.
	var/message = null
	switch(budget_shift)
		if(0 to 0.02) // Abyssmal response.
			message = "We are very interested in learning where [round(money_at_start, 1000)] thaler went in \
			just half an hour. We highly recommend rectifying this issue before the end of the shift, otherwise a \
			discussion regarding your future employment prospects will occur.<br><br>\
			Your facility's current balance of requisition tokens has been revoked."
			SSsupply.points = 0
			log_debug("Funding Drive event ended with an abyssmal response, and the loss of all cargo points.")

		if(0.02 to 0.98) // Bad response.
			message = "We're very disappointed that \the [location_name()] has ran a deficit since our request. \
			As such, we will be taking away some requisition tokens to cover the cost of operating your facility."
			var/points_lost = round(SSsupply.points * rand(0.5, 0.8))
			SSsupply.points -= points_lost
			log_debug("Funding Drive event ended with a bad response, and [points_lost] cargo points was taken away.")

		if(0.98 to 1.02) // Neutral response.
			message = "It is unfortunate that \the [location_name()]'s finances remain at a standstill, however \
			that is still preferred over having a decicit. We hope that in the future, your facility will be able to be \
			more profitable."
			log_debug("Funding Drive event ended with a neutral response.")

		if(1.02 to INFINITY) // Good response.
			message = "We appreciate the efforts made by \the [location_name()] to run at a surplus. \
			Together, along with the other facilities present in the [using_map.starsys_name] system, \
			the company is expected to meet the quota.<br><br>\
			We will allocate additional requisition tokens for the cargo department as a reward."

			// If cargo is ever made to use station funds instead of cargo points, then a new kind of reward will be needed.
			// Otherwise it would be weird for centcom to go 'thanks for not spending money, your reward is money to spend'.
			var/point_reward = rand(100, 200)
			SSsupply.points += point_reward
			log_debug("Funding Drive event ended with a good response and a bonus of [point_reward] cargo points.")

	send_command_report("Budget Followup", message)



// Returns the sum of the station account and all the departmental accounts.
/datum/event2/event/raise_funds/proc/count_money()
	. = 0
	. += GLOB.station_account.money
	for(var/i = 1 to SSjob.department_datums.len)
		var/datum/money_account/account = LAZYACCESS(GLOB.department_accounts, SSjob.department_datums[i])
		if(istype(account))
			. += account.money

/datum/event2/event/raise_funds/proc/send_command_report(title, message)
	post_comm_message(title, message)
	to_world(span_danger("New [using_map.company_name] Update available at all communication consoles."))
	SEND_SOUND(world, 'sound/AI/commandreport.ogg')
