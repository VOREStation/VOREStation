/*
Ships can now be hijacked!
*/
/obj/machinery/computer/ship
	var/hacked = 0   // Has been emagged, no access restrictions.

/obj/machinery/computer/ship/emag_act(var/remaining_charges, var/mob/user)
	if (!hacked)
		req_access = list()
		req_one_access = list()
		hacked = 1
		to_chat(user, "You short out the console's ID checking system. It's now available to everyone!")
		return 1
