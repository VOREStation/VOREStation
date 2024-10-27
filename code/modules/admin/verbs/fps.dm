//Merged Doohl's and the existing ticklag as they both had good elements about them ~
//Replaces the old Ticklag verb, fps is easier to understand
/client/proc/set_server_fps()
	set category = "Debug"
	set name = "Set Server FPS"
	set desc = "Sets game speed in frames-per-second. Can potentially break the game"

	if(!check_rights(R_DEBUG))
		return

	var/new_fps = round(tgui_input_number(usr, "Sets game frames-per-second. Can potentially break the game (default: [CONFIG_GET(number/fps)])", "FPS", world.fps), round(CONFIG_GET(number/fps) * 1.5))
	if(new_fps <= 0)
		to_chat(src, span_danger("Error: set_server_fps(): Invalid world.fps value. No changes made."))
		return
	if(new_fps > CONFIG_GET(number/fps) * 1.5)
		if(tgui_alert(src, "You are setting fps to a high value:\n\t[new_fps] frames-per-second\n\tconfig.fps = [CONFIG_GET(number/fps)]", "Warning!", list("Confirm", "ABORT-ABORT-ABORT")) != "Confirm")
			return

	var/msg = "[key_name(src)] has modified world.fps to [new_fps]"
	log_admin(msg, 0)
	message_admins(msg, 0)
	world.change_fps(new_fps)
	feedback_add_details("admin_verb", "SETFPS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
