/datum/gm_action/request
	name = "general request"
	departments = list(DEPARTMENT_CARGO)

/datum/gm_action/request/announce()
	spawn(rand(1 MINUTE, 2 MINUTES))
		command_announcement.Announce("[pick("A nearby vessel", "A Solar contractor", "A Skrellian contractor", "A NanoTrasen board director")] has requested the delivery of [pick("one","two","three","several")] [pick("medical","engineering","research","civilian")] supply packages. The [station_name()] has been tasked with completing this request.", "Supply Request")

/datum/gm_action/request/get_weight()
	return max(15, 15 + round(gm.staleness / 2) - gm.danger) + (metric.count_people_in_department(DEPARTMENT_CARGO) * 10)

