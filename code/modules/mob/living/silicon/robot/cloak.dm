//Personal shielding for the combat module.
/obj/item/borg/cloak
	name = "personal cloaking"
	desc = "A powerful experimental module that allows one to adjust their visiblity."
	description_info = "Ctrl-Clicking on the cloak will turn it on or off.<br>\
	Clicking the cloak while selected will allow you to change the strength of the cloak."
	icon = 'icons/obj/decals.dmi'
	icon_state = "shock"
	var/cloak_strength = 0.5		//Percent of visibility, 0 is visible, 1 is fully invisible
	var/active = FALSE				//If the shield is on
/obj/item/borg/cloak/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/borg/cloak/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/borg/cloak/attack_self(mob/user)
	set_cloak_level(user)

/obj/item/borg/cloak/CtrlClick(mob/user)
	toggle_cloak(user)
	return

/obj/item/borg/cloak/process()
	if(!active || !cloak_strength) //We are not active or cloak strength is set to 0
		return
	if(!isliving(src.loc)) //It's not currently in our active modules.
		active = FALSE
		if(isrobot(loc.loc)) //The robot
			var/mob/living/silicon/robot/R = src.loc.loc
			update_cloak(R)
	else if(isrobot(src.loc)) //We are in a robot.
		var/mob/living/silicon/robot/R = src.loc
		//MATH: CELLRATE = 0.002 CYBORG_POWER_USAGE_MULTIPLIER = 2 and power_use = amount * CYBORG_POWER_USAGE_MULTIPLIER...
		//So 250W = 1 charge. Syndi battery has 25000 charge.
		//Let's make it so that 20 charge is used per 2 seconds if we are 100% cloaked. We subtract 100 since that's the idle power used for a module being selected.
		if(!R.cell_use_power((cloak_strength * 5000) - 100))
			active = FALSE
			update_cloak(R) //Update the cloak strength on the robot.
			return //We ran out of power. RIP.

/obj/item/borg/cloak/proc/update_cloak(var/mob/living/silicon/robot/robot)
	if(!robot || !isrobot(robot))
		return
	if(active && cloak_strength) //We remove any cloaks they might have
		robot.remove_modifiers_of_type(/datum/modifier/robot_cloak)
		robot.add_modifier(/datum/modifier/robot_cloak)
	else
		robot.remove_modifiers_of_type(/datum/modifier/robot_cloak)
		active = FALSE

/obj/item/borg/cloak/verb/set_cloak_level()
	set name = "Toggle Cloak Strength"
	set category = "Object"
	set src in range(0)
	var/mob/living/silicon/robot/R = usr
	set_cloaking_level(R)

/obj/item/borg/cloak/proc/set_cloaking_level(mob/living/silicon/robot/R)
	if(!isrobot(R)) //sod off
		return

	var/N = tgui_input_number(R, "How obscured do you want to be? In %", "Cloak Level", cloak_strength*100, 100, 0)
	if(!isnull(N) && N >= 0 && N <= 100)
		cloak_strength = N/100
		to_chat(R, span_warning("You will now be [N]% obscured when the cloak is active."))
		update_cloak(R)
	else if(!N)
		return
	else
		to_chat(R, span_warning("Invalid cloak level. Must be between 0 and 100."))
		return

/obj/item/borg/cloak/verb/activate_cloak()
	set name = "Toggle Cloak"
	set category = "Object"
	set src in range(0)
	var/mob/living/silicon/robot/R = usr
	toggle_cloak(R)

/obj/item/borg/cloak/proc/toggle_cloak(mob/living/silicon/robot/R)
	if(!isrobot(R)) //sod off
		return

	active = !active
	to_chat(R, span_notice("You [active ? "re" : "de"]activate your personal cloaking device."))
	update_cloak(R)

/datum/modifier/robot_cloak
	name = "robotic stealth"
	desc = "You are currently cloaked and harder to see!."

	on_created_text = span_warning("You become harder to see.")
	on_expired_text = span_notice("You become fully visible once more.")
	var/visibility
	///How many times we have been hit in a short succession.
	var/times_hit = 0 //How many times we have been hit while cloaked.
	///How many hits it can sustain before the cloak drops
	var/cloak_durability = 3
	///When we were last hit.
	var/last_hit_time = 0
	///How slow we are to reset the hit counter.
	var/hit_dissipation = 5 SECONDS //How long we wait before resetting the hit counter.
	///If our cloak is currently up or not
	var/cloaked = TRUE
	///How much evasion we have when our cloak is up.
	var/modified_evasion

	stacks = MODIFIER_STACK_FORBID

/datum/modifier/robot_cloak/can_apply()
	if(holder && isrobot(holder) && holder.stat != DEAD)
		return TRUE
	return FALSE

/datum/modifier/robot_cloak/on_applied()
	var/mob/living/silicon/robot/R = holder
	var/obj/item/borg/cloak/cloak = locate() in R //Find the borg cloak module
	var/cloak_strength = cloak.cloak_strength
	visibility = 255 * (1 - cloak_strength)
	modified_evasion = 60*cloak_strength
	evasion = modified_evasion //60 at full strength, 30 at half strength.
	animate(holder, alpha = visibility, time = 1 SECOND)
	RegisterSignal(holder, COMSIG_MOB_APPLY_DAMAGE, PROC_REF(damage_inflicted))
	RegisterSignal(holder, COMSIG_ROBOT_ITEM_ATTACK, PROC_REF(attacked_in_cloak))
	return

/datum/modifier/robot_cloak/on_expire()
	holder.alpha = initial(holder.alpha)
	UnregisterSignal(holder, COMSIG_MOB_APPLY_DAMAGE)
	UnregisterSignal(holder, COMSIG_ROBOT_ITEM_ATTACK)
	remove_wibble(TRUE)
	return

/datum/modifier/robot_cloak/tick()
	if(holder.stat == DEAD)
		expire(silent = TRUE)
	else if(times_hit && (world.time - last_hit_time) > hit_dissipation) //If we have been hit, but the time has passed, reset the hit counter.
		if(!cloaked)
			to_chat(holder, span_warning("Your cloak whirrs back to life!"))
		reset_cloak()

	if(cloaked && !times_hit) //The !times_hit is here so it doesn't interfere with the animation.
		animate(holder, alpha = visibility, time = 1 SECOND)

/datum/modifier/robot_cloak/proc/damage_inflicted(mob/living/source, damage)
	if(damage < 5) //weak, don't do anything.
		return
	times_hit++
	var/alpha_to_show = CLAMP((holder.alpha+(damage*10)), holder.alpha, 255) //The more damage we take, the more visible we become.
	flick_cloak(alpha_to_show)
	last_hit_time = world.time
	if(damage >= 50 || times_hit >= cloak_durability)
		to_chat(holder, span_warning("Your cloak buzzes and fails after sustaining too much damage!!"))
		drop_cloak()
		remove_wibble(TRUE)
		return

/datum/modifier/robot_cloak/proc/flick_cloak(alpha_to_show)
	animate(holder, alpha = alpha_to_show, time = 0.1 SECONDS, loop = 0.5 SECONDS)
	animate(alpha = visibility, time = 0.1 SECONDS)
	apply_wibbly_filters(holder, 0.5 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(remove_wibble), 0.1 SECOND), 0.5 SECONDS, TIMER_DELETE_ME) //Calling a proc with no arguments

/datum/modifier/robot_cloak/proc/attacked_in_cloak()
	if(holder && !holder.get_filter("wibbly-[1]")) //We're not wibbled at the moment.
		var/alpha_to_show = CLAMP((holder.alpha+(rand(50,200))), holder.alpha, 255) //Become more visible by a significant margin, randomly.
		flick_cloak(alpha_to_show)

/datum/modifier/robot_cloak/proc/remove_wibble(instant)
	if(holder && holder.get_filter("wibbly-[1]")) //We just check for the first wibble. If it has one it has them all.
		if(instant)
			remove_wibbly_filters(holder)
		else
			remove_wibbly_filters(holder, 0.1 SECOND)

/datum/modifier/robot_cloak/proc/drop_cloak()
	holder.alpha = initial(holder.alpha)
	cloaked = FALSE
	evasion = 0

/datum/modifier/robot_cloak/proc/reset_cloak()
	times_hit = 0
	cloaked = TRUE
	evasion = modified_evasion
