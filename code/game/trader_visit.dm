//Based on the ERT setup

var/global/send_beruang = 0
var/can_call_traders = 1

/client/proc/trader_ship()
	set name = "Dispatch Beruang Trader Ship"
	set category = "Special Verbs"
	set desc = "Invite players to join the Beruang."

	if(!holder)
		to_chat(usr, "<span class='danger'>Only administrators may use this command.</span>")
		return
	if(!ticker)
		to_chat(usr, "<span class='danger'>The game hasn't started yet!</span>")
		return
	if(ticker.current_state == 1)
		to_chat(usr, "<span class='danger'>The round hasn't started yet!</span>")
		return
	if(send_beruang)
		to_chat(usr, "<span class='danger'>The Beruang has already been sent this round!</span>")
		return
	if(tgui_alert(usr, "Do you want to dispatch the Beruang trade ship?","Trade Ship",list("Yes","No")) != "Yes")
		return
	if(get_security_level() == "red") // Allow admins to reconsider if the alert level is Red
		switch(tgui_alert(usr, "The station is in red alert. Do you still want to send traders?","Trade Ship",list("Yes","No")))
			if("No")
				return
	if(send_beruang)
		to_chat(usr, "<span class='danger'>Looks like somebody beat you to it!</span>")
		return

	message_admins("[key_name_admin(usr)] is dispatching the Beruang.", 1)
	log_admin("[key_name(usr)] used Dispatch Beruang Trader Ship.")
	trigger_trader_visit()

/client/verb/JoinTraders()

	set name = "Join Trader Visit"
	set category = "IC"

	if(!MayRespawn(1))
		to_chat(usr, "<span class='warning'>You cannot join the traders.</span>")
		return

	if(istype(usr,/mob/observer/dead) || istype(usr,/mob/new_player))
		if(!send_beruang)
			to_chat(usr, "The Beruang is not currently heading to the station.")
			return
		if(traders.current_antagonists.len >= traders.hard_cap)
			to_chat(usr, "The number of trader slots is already full!")
			return
		traders.create_default(usr)
	else
		to_chat(usr, "You need to be an observer or new player to use this.")

/proc/trigger_trader_visit()
	if(!can_call_traders)
		return
	if(send_beruang)
		return

	command_announcement.Announce("Incoming cargo hauler: Beruang (Reg: VRS 22EB1F11C2).", "[station_name()] Traffic Control")

	can_call_traders = 0 // Only one call per round.
	send_beruang = 1
	consider_trader_load() //VOREStation Add

	sleep(600 * 5)
	send_beruang = 0 // Can no longer join the traders.
