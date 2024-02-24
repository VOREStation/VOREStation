/client/proc/roll_dices()
	set category = "Fun"
	set name = "Roll Dice"
	if(!check_rights(R_FUN))
		return

	var/sum = tgui_input_number(usr, "How many times should we throw?")
	var/side = tgui_input_number(usr, "Select the number of sides.")
	if(!side)
		side = 6
	if(!sum)
		sum = 2

	var/dice = num2text(sum) + "d" + num2text(side)

	if(tgui_alert(usr, "Do you want to inform the world about your game?","Show world?",list("Yes", "No")) == "Yes")
		to_world("<h2 style=\"color:#A50400\">The dice have been rolled by Gods!</h2>")

	var/result = roll(dice)

	if(tgui_alert(usr, "Do you want to inform the world about the result?","Show world?",list("Yes", "No")) == "Yes")
		to_world("<h2 style=\"color:#A50400\">Gods rolled [dice], result is [result]</h2>")

	message_admins("[key_name_admin(src)] rolled dice [dice], result is [result]", 1)