/datum/admin_secret_item/fun_secret/power_failure_begin
	name = "Power Failure Begin"

/datum/admin_secret_item/fun_secret/power_failure_begin/execute(var/mob/user)
	. = ..()
	if(.)
		power_failure()
