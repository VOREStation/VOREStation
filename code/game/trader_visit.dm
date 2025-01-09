//Based on the ERT setup

GLOBAL_VAR_INIT(send_beruang, 0)
GLOBAL_VAR_INIT(can_call_traders, 1)

/client/proc/trader_ship()
	set name = "Dispatch Beruang Trader Ship"
	set category = "Fun.Event Kit"
	set desc = "Invite players to join the Beruang."

	if(!holder)
		to_chat(usr, span_danger("Only administrators may use this command."))
		return
	if(!ticker)
		to_chat(usr, span_danger("The game hasn't started yet!"))
		return
	if(ticker.current_state == 1)
		to_chat(usr, span_danger("The round hasn't started yet!"))
		return
	if(GLOB.send_beruang)
		to_chat(usr, span_danger("The Beruang has already been sent this round!"))
		return
	if(tgui_alert(usr, "Do you want to dispatch the Beruang trade ship?","Trade Ship",list("Yes","No")) != "Yes")
		return
	if(get_security_level() == "red") // Allow admins to reconsider if the alert level is Red
		if(tgui_alert(usr, "The station is in red alert. Do you still want to send traders?","Trade Ship",list("Yes","No")) != "Yes")
			return
	if(GLOB.send_beruang)
		to_chat(usr, span_danger("Looks like somebody beat you to it!"))
		return

	message_admins("[key_name_admin(usr)] is dispatching the Beruang.", 1)
	log_admin("[key_name(usr)] used Dispatch Beruang Trader Ship.")
	trigger_trader_visit()

/client/verb/JoinTraders()

	set name = "Join Trader Visit"
	set category = "IC.Event"

	if(!MayRespawn(1))
		to_chat(usr, span_warning("You cannot join the traders."))
		return

	if(isobserver(usr) || isnewplayer(usr))
		if(!GLOB.send_beruang)
			to_chat(usr, "The Beruang is not currently heading to the station.")
			return
		if(GLOB.traders.current_antagonists.len >= GLOB.traders.hard_cap)
			to_chat(usr, "The number of trader slots is already full!")
			return
		GLOB.traders.create_default(usr)
	else
		to_chat(usr, "You need to be an observer or new player to use this.")

/proc/trigger_trader_visit()
	if(!GLOB.can_call_traders)
		return
	if(GLOB.send_beruang)
		return

	command_announcement.Announce("Incoming cargo hauler: Beruang (Reg: VRS 22EB1F11C2).", "[station_name()] Traffic Control")

	GLOB.can_call_traders = 0 // Only one call per round.
	GLOB.send_beruang = 1
	consider_trader_load() //VOREStation Add

	sleep(600 * 5)
	GLOB.send_beruang = 0 // Can no longer join the traders.
