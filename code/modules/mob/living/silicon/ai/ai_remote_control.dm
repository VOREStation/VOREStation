/mob/living/silicon/ai
	var/mob/living/silicon/robot/deployed_shell = null //For shell control

/mob/living/silicon/ai/Initialize()
	if(config.allow_ai_shells)
		verbs += /mob/living/silicon/ai/proc/deploy_to_shell_act
	return ..()

/mob/living/silicon/ai/proc/deploy_to_shell(var/mob/living/silicon/robot/target)
	if(!config.allow_ai_shells)
		to_chat(src, span("warning", "AI Shells are not allowed on this server. You shouldn't have this verb because of it, so consider making a bug report."))
		return

	if(incapacitated())
		to_chat(src, span("warning", "You are incapacitated!"))
		return

	if(lacks_power())
		to_chat(src, span("warning", "Your core lacks power, wireless is disabled."))
		return

	if(control_disabled)
		to_chat(src, span("warning", "Wireless networking module is offline."))
		return

	var/list/possible = list()
	for(var/mob/living/silicon/robot/R as anything in GLOB.available_ai_shells)
		if(R.shell && !R.deployed && (R.stat != DEAD) && (!R.connected_ai || (R.connected_ai == src) ) )	//VOREStation Edit: shell restrictions
			if(istype(R.loc, /obj/machinery/recharge_station))	//Check Rechargers
				var/obj/machinery/recharge_station/RS = R.loc
				if(!(using_map.ai_shell_restricted && !(RS.z in using_map.ai_shell_allowed_levels)))	//Allow station borgs to be redeployed from Chargers.
					possible += R

			if(isbelly(R.loc))	//check belly space
				var/obj/belly/B = R.loc
				if(!(using_map.ai_shell_restricted && !(B.owner.z in using_map.ai_shell_allowed_levels)))	//No smuggling in borgs
					possible += R

			if(!(using_map.ai_shell_restricted && !(R.z in using_map.ai_shell_allowed_levels)))
				possible += R

	if(!LAZYLEN(possible))
		to_chat(src, span("warning", "No usable AI shell beacons detected."))

	if(!target || !(target in possible)) //If the AI is looking for a new shell, or its pre-selected shell is no longer valid
		target = tgui_input_list(src, "Which body to control?", "Shell Choice", possible)

	if(!target || target.stat == DEAD || target.deployed || !(!target.connected_ai || (target.connected_ai == src) ) )
		if(target)
			to_chat(src, span("warning", "It is no longer possible to deploy to \the [target]."))
		else
			to_chat(src, span("notice", "Deployment aborted."))
		return

	else if(mind)
		soul_link(/datum/soul_link/shared_body, src, target)
		deployed_shell = target
		target.deploy_init(src)
		mind.transfer_to(target)
		teleop = target // So the AI 'hears' messages near its core.
		target.post_deploy()

/mob/living/silicon/ai/proc/deploy_to_shell_act()
	set category = "AI Commands"
	set name = "Deploy to Shell"
	deploy_to_shell() // This is so the AI is not prompted with a list of all mobs when using the 'real' proc.

/mob/living/silicon/ai/proc/disconnect_shell(message = "Your remote connection has been reset!")
	if(deployed_shell) // Forcibly call back AI in event of things such as damage, EMP or power loss.
		message = span("danger", message)
		deployed_shell.undeploy(message)
