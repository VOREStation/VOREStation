/mob/living/silicon/ai
	var/mob/living/silicon/robot/deployed_shell = null //For shell control

/mob/living/silicon/ai/proc/deploy_to_shell(mob/living/silicon/robot/target)
	if(!CONFIG_GET(flag/allow_ai_shells))
		to_chat(src, span_warning("AI Shells are not allowed on this server. You shouldn't have this verb because of it, so consider making a bug report."))
		return

	if(incapacitated())
		to_chat(src, span_warning("You are incapacitated!"))
		return

	if(lacks_power())
		to_chat(src, span_warning("Your core lacks power, wireless is disabled."))
		return

	if(control_disabled)
		to_chat(src, span_warning("Wireless networking module is offline."))
		return

	var/list/possible = list()
	for(var/mob/living/silicon/robot/R as anything in GLOB.available_ai_shells)
		if(R.shell && !R.deployed && (R.stat != DEAD) && (!R.connected_ai || (R.connected_ai == src) ) && shell_z_valid(R.z))
			possible += R

	if(!LAZYLEN(possible))
		to_chat(src, span_warning("No usable AI shell beacons detected."))

	if(!target || !(target in possible)) //If the AI is looking for a new shell, or its pre-selected shell is no longer valid
		target = tgui_input_list(src, "Which body to control?", "Shell Choice", possible)

	if(!target || target.stat == DEAD || target.deployed || !(!target.connected_ai || (target.connected_ai == src) ) )
		if(target)
			to_chat(src, span_warning("It is no longer possible to deploy to \the [target]."))
		else
			to_chat(src, span_notice("Deployment aborted."))
		return

	else if(mind)
		soul_link(/datum/soul_link/shared_body, src, target)
		deployed_shell = target
		target.deploy_init(src)
		mind.transfer_to(target)
		if(target.first_transfer)
			target.first_transfer = FALSE
			target.copy_from_prefs_vr()
			if(LAZYLEN(target.vore_organs))
				target.vore_selected = target.vore_organs[1]
		src.copy_vore_prefs_to_mob(target)
		teleop = target // So the AI 'hears' messages near its core.
		target.post_deploy()

/mob/living/silicon/ai/proc/deploy_to_shell_act()
	set category = "AI.Commands"
	set name = "Deploy to Shell"
	deploy_to_shell() // This is so the AI is not prompted with a list of all mobs when using the 'real' proc.

/mob/living/silicon/ai/proc/disconnect_shell(message = "Your remote connection has been reset!")
	if(deployed_shell) // Forcibly call back AI in event of things such as damage, EMP or power loss.
		message = span_danger(message)
		deployed_shell.undeploy(message)

/mob/living/silicon/robot/proc/shell_z_valid(var/check_z)
	var/found_z = check_z
	// Try to get the turf so that we don't get disconnected when inside rechargers or disposals
	var/turf/check_turf = get_turf(src)
	if(isdisposalpacket(loc)) // Disposal holders fail get_turf() and required snowflake handling
		check_turf = get_turf(loc.loc)
	if(isturf(check_turf))
		found_z = check_turf.z

	return !(using_map.ai_shell_restricted && !(found_z in using_map.ai_shell_allowed_levels))
