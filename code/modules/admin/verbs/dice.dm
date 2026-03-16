
ADMIN_VERB(roll_dices, R_FUN, "Roll Dice", "Allows to roll a dice.", ADMIN_CATEGORY_FUN_EVENT_KIT)
	var/sum = tgui_input_number(user, "How many times should we throw?")
	var/side = tgui_input_number(user, "Select the number of sides.")
	if(!side)
		side = 6
	if(!sum)
		sum = 2

	var/dice = num2text(sum) + "d" + num2text(side)

	if(tgui_alert(user, "Do you want to inform the world about your game?","Show world?",list("Yes", "No")) == "Yes")
		to_chat(world, "<h2 style=\"color:#A50400\">The dice have been rolled by Gods!</h2>")

	var/result = roll(dice)

	if(tgui_alert(user, "Do you want to inform the world about the result?","Show world?",list("Yes", "No")) == "Yes")
		to_chat(world, "<h2 style=\"color:#A50400\">Gods rolled [dice], result is [result]</h2>")

	message_admins("[key_name_admin(user)] rolled dice [dice], result is [result]", 1)
