/datum/admin_secret_item/fun_secret/power_failure_end
	name = "Power Failure End"

/datum/admin_secret_item/fun_secret/power_failure_end/execute(var/mob/user)
	. = ..()
	if(.)
		power_restore()
