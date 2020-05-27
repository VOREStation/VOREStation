/client/proc/smite(var/mob/living/carbon/human/target in player_list)
	set name = "Smite"
	set desc = "Abuse a player with various 'special treatments' from a list."
	set category = "Fun"
	if(!check_rights(R_FUN))
		return

	if(!istype(target))
		return

	var/list/smite_types = list(SMITE_BREAKLEGS,SMITE_BLUESPACEARTILLERY,SMITE_SPONTANEOUSCOMBUSTION,SMITE_LIGHTNINGBOLT)

	var/smite_choice = input("Select the type of SMITE for [target]","SMITE Type Choice") as null|anything in smite_types
	if(!smite_choice)
		return

	switch(smite_choice)
		if(SMITE_BREAKLEGS)
			var/broken_legs = 0
			var/obj/item/organ/external/left_leg = target.get_organ(BP_L_LEG)
			if(left_leg && left_leg.fracture())
				broken_legs++
			var/obj/item/organ/external/right_leg = target.get_organ(BP_R_LEG)
			if(right_leg && right_leg.fracture())
				broken_legs++
			if(!broken_legs)
				to_chat(src,"[target] didn't have any breakable legs, sorry.")
		
		if(SMITE_BLUESPACEARTILLERY)
			bluespace_artillery(target,src)
		
		if(SMITE_SPONTANEOUSCOMBUSTION)
			target.adjust_fire_stacks(10)
			target.IgniteMob()
			target.visible_message("<span class='danger'>[target] bursts into flames!</span>")
		
		if(SMITE_LIGHTNINGBOLT)
			var/turf/T = get_step(get_step(target, NORTH), NORTH)
			T.Beam(target, icon_state="lightning[rand(1,12)]", time = 5)
			target.electrocute_act(75,def_zone = BP_HEAD)
			target.visible_message("<span class='danger'>[target] is struck by lightning!</span>")
		
		else
			return //Injection? Don't print any messages.

	log_and_message_admins("[key_name(src)] has used SMITE ([smite_choice]) on [key_name(target)].")
	feedback_add_details("admin_verb","SMITE") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/proc/bluespace_artillery(mob/living/target, user)
	if(!istype(target))
		return

	if(BSACooldown)
		if(user)
			to_chat(user,"<span class='warning'>BSA is still cooling down, please wait!</span>")
		return

	BSACooldown = 1
	VARSET_IN(global, BSACooldown, FALSE, 5 SECONDS)

	to_chat(target,"You've been hit by bluespace artillery!")
	log_and_message_admins("[key_name(target)] has been hit by Bluespace Artillery fired by [key_name(user ? user : usr)]")

	target.setMoveCooldown(2 SECONDS)

	var/turf/simulated/floor/T = get_turf(target)
	if(istype(T))
		if(prob(80))	T.break_tile_to_plating()
		else			T.break_tile()

	if(target.health == 1)
		target.gib()
	else
		target.adjustBruteLoss( min( 99 , (target.health - 1) )    )
		target.Stun(20)
		target.Weaken(20)
		target.stuttering = 20
