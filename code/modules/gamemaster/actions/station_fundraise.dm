/datum/gm_action/station_fund_raise
	name = "local funding drive"
	departments = list(DEPARTMENT_SECURITY, DEPARTMENT_CARGO, DEPARTMENT_EVERYONE)

/datum/gm_action/station_fund_raise/announce()
	spawn(rand(1 MINUTE, 2 MINUTES))
		command_announcement.Announce("Due to [pick("recent", "unfortunate", "possible future")] budget [pick("changes", "issues")], in-system stations are now advised to increase funding income.", "Security & Supply Advisement")

/datum/gm_action/station_fund_raise/get_weight()
	var/weight_modifier = 0.5
	if(station_account.money <= 80000)
		weight_modifier = 1

	return (max(-20, 10 + gm.staleness) + ((metric.count_people_in_department(DEPARTMENT_SECURITY) + (metric.count_people_in_department(DEPARTMENT_CARGO))) * 5) + (metric.count_people_in_department(DEPARTMENT_EVERYONE) * 3)) * weight_modifier
