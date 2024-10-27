/**********
* Gravity *
**********/
/datum/admin_secret_item/random_event/gravity
	name = "Toggle Station Artificial Gravity"

/datum/admin_secret_item/random_event/gravity/can_execute(var/mob/user)
	if(!(ticker && ticker.mode))
		return 0

	return ..()

/datum/admin_secret_item/random_event/gravity/execute(var/mob/user)
	. = ..()
	if(!.)
		return

	gravity_is_on = !gravity_is_on
	for(var/obj/machinery/gravity_generator/main/GG in machines)
		if(GG.z in using_map.station_levels)
			GG.breaker = gravity_is_on
			GG.set_power()
			GG.charge_count = gravity_is_on ? 90 : 10

	feedback_inc("admin_secrets_fun_used",1)
	feedback_add_details("admin_secrets_fun_used","Grav")
	if(gravity_is_on)
		log_admin("[key_name(user)] toggled gravity on.", 1)
		message_admins(span_notice("[key_name_admin(user)] toggled gravity on."), 1)
		command_announcement.Announce("Gravity generators are again functioning within normal parameters. Sorry for any inconvenience.")
	else
		log_admin("[key_name(user)] toggled gravity off.", 1)
		message_admins(span_notice("[key_name_admin(usr)] toggled gravity off."), 1)
		command_announcement.Announce("Feedback surge detected in mass-distributions systems. Artificial gravity has been disabled. Please wait for the system to reinitialize, or contact your engineering department.", "Gravity Failure")
