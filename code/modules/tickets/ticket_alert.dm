/obj/screen/alert/open_ticket
	icon = 'icons/covershield.dmi'
	name = "Admin Chat Request"
	desc = "A Administrator would like to chat with you. \
	Click here to begin."
	icon_state = "32x32"

/obj/screen/alert/open_ticket/Click()
	if(!usr || !usr.client) return

	// Open a new chat with the user
	var/datum/ticket_chat/TC = new()
	TC.T = usr.client.current_ticket
	TC.tgui_interact(usr.client.mob)
