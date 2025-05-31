/decl/emote/visible/bellyrub
	key = "bellyrub"
	check_restraints = TRUE
	check_range = 1
	//These aren't actually ever shown BUT can_target requires 1p_target or 3p_target to be set or you can't target people.
	emote_message_1p = "You rub your belly!"
	emote_message_1p_target = "You rub TARGET's belly!"
	emote_message_3p = "rubs their belly!"
	emote_message_3p_target = "rubs TARGET's belly!"

/decl/emote/visible/bellyrub/get_emote_message_1p(var/atom/user, var/atom/target, var/extra_params)
	if(!target && isliving(user)) //We shouldn't NEED an isliving check here but...Whatever, safety first.
		var/mob/living/U = user
		U.vore_bellyrub(U)
		//We don't need to return a message here. The vore bellyrub does it itself!

	else if(isliving(user) && isliving(target))
		var/mob/living/U = user
		var/mob/living/T = target
		U.vore_bellyrub(T)
		//We don't need to return a message here. The vore bellyrub does it itself!
	else
		to_chat(user, "You can not rub [target]'s belly.")
	return

/decl/emote/visible/bellyrub/get_emote_message_3p(var/atom/user, var/atom/target, var/extra_params)
	return
