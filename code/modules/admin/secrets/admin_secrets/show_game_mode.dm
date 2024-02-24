/datum/admin_secret_item/admin_secret/show_game_mode
	name = "Show Game Mode"

/datum/admin_secret_item/admin_secret/show_game_mode/can_execute(var/mob/user)
	if(!ticker)
		return 0
	return ..()

/datum/admin_secret_item/admin_secret/show_game_mode/execute(var/mob/user)
	. = ..()
	if(!.)
		return
	if (ticker.mode) tgui_alert_async(usr, "The game mode is [ticker.mode.name]")
	else tgui_alert_async(usr, "For some reason there's a ticker, but not a game mode")
