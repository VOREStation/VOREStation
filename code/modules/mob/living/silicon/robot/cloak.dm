//Personal shielding for the combat module.
/obj/item/borg/cloak
	name = "personal cloaking"
	desc = "A powerful experimental module that allows one to adjust their visiblity."
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

/obj/item/borg/cloak/attack_self(var/mob/living/user)
	set_cloak_level(user)

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

	stacks = MODIFIER_STACK_FORBID

/datum/modifier/robot_cloak/can_apply()
	if(holder && isrobot(holder) && holder.stat != DEAD)
		return TRUE
	return FALSE

/datum/modifier/robot_cloak/on_applied()
	var/mob/living/silicon/robot/R = holder
	var/obj/item/borg/cloak/cloak = locate() in R //Find the borg cloak module
	to_world("R = [R] cloak = [cloak]")
	var/cloak_strength = cloak.cloak_strength
	to_world("CS = [cloak_strength]")
	visibility = 255 * (1 - cloak_strength)
	holder.alpha = visibility
	return

/datum/modifier/robot_cloak/on_expire()
	holder.alpha = initial(holder.alpha)
	return

/datum/modifier/robot_cloak/tick()
	holder.alpha = visibility
	if(holder.stat == DEAD)
		expire(silent = TRUE)
