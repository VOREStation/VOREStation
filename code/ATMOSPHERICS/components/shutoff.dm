GLOBAL_LIST_EMPTY(shutoff_valves)

/obj/machinery/atmospherics/valve/shutoff
	icon = 'icons/atmos/clamp.dmi'
	icon_state = "map_vclamp0"
	pipe_state = "vclamp"

	name = "automatic shutoff valve"
	desc = "An automatic valve with control circuitry and pipe integrity sensor, capable of automatically isolating damaged segments of the pipe network."
	description_info = "Clicking this will toggle the automatic control. Alt-clicking this when the automatic control is disabled will manually open or close the valve."
	var/close_on_leaks = TRUE	// If false it will be always open
	level = 1

/obj/machinery/atmospherics/valve/shutoff/update_icon()
	icon_state = "vclamp[open]"

/obj/machinery/atmospherics/valve/shutoff/examine(var/mob/user)
	. = ..()
	. += "The automatic shutoff circuit is [close_on_leaks ? "enabled" : "disabled"]."

/obj/machinery/atmospherics/valve/shutoff/Initialize(mapload)
	. = ..()
	open()
	GLOB.shutoff_valves += src
	hide(1)

/obj/machinery/atmospherics/valve/shutoff/Destroy()
	GLOB.shutoff_valves -= src
	..()

/obj/machinery/atmospherics/valve/shutoff/attack_ai(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/atmospherics/valve/shutoff/attack_hand(var/mob/user)
	src.add_fingerprint(user)
	update_icon(1)
	close_on_leaks = !close_on_leaks
	to_chat(user, "You [close_on_leaks ? "enable" : "disable"] the automatic shutoff circuit.")
	return TRUE

// Alt+Click now toggles the open/close function, when the autoseal is disabled
/obj/machinery/atmospherics/valve/shutoff/AltClick(var/mob/user)
	if(isliving(user))
		if(close_on_leaks)
			to_chat(user, "You try to manually [open ? "close" : "open"] the valve, but it [open ? "opens" : "closes"] automatically again.")
			return

		open ? close() : open()
		to_chat(user, "You manually [open ? "open" : "close"] the valve.")

/obj/machinery/atmospherics/valve/shutoff/process()
	..()

	if(!network_node1 || !network_node2 || !node1 || !node2)
		if(open && close_on_leaks)
			close()
		return

	if(close_on_leaks)
		if(open && (network_node1.leaks.len || network_node2.leaks.len))
			find_leaks() // If we can see the leak, then this will find it, close the valve, and cut off that network
						 // If we cannot see the leak, then this will not close the valve, and any valves that can see the leak will cut it off from us
		else if(!open && !network_node1.leaks.len && !network_node2.leaks.len)
			open()
	return

// Breadth-first search for any leaking pipes that we can directly see
/obj/machinery/atmospherics/valve/shutoff/proc/find_leaks()
	var/list/obj/machinery/atmospherics/search = list()

	// We're the leak!
	if(!node1 || !node2)
		close()
		return

	// Only searching pipes
	if(istype(node1, /obj/machinery/atmospherics))
		search |= node1
	if(istype(node2, /obj/machinery/atmospherics))
		search |= node2

	// Breadth-first search
	for(var/i = 1, i <= search.len, i++) // wooo, proper for loop syntax!
		var/obj/machinery/atmospherics/A = search[i]
		if(!A)
			continue

		if(istype(A, /obj/machinery/atmospherics/pipe))
			var/obj/machinery/atmospherics/pipe/L = A
			if(L.leaking)
				close() // Found the leak!
				return


		if(istype(A, /obj/machinery/atmospherics/valve/shutoff))
			var/obj/machinery/atmospherics/valve/shutoff/S = A
			if(S.close_on_leaks || !S.open)
				continue 										// Either it will close, or it is closed. We don't care what's on the other side
			search |= list(S.node1, S.node2) 					// |= skips existing nodes, so we don't search loops infinitely

		else if(istype(A, /obj/machinery/atmospherics/valve))	// Putting the shutoff before this means this won't catch shutoffs
			var/obj/machinery/atmospherics/valve/V = A
			if(V.open)
				search |= list(V.node1, V.node2)
			else
				continue // Closed valve, dead end

		else if(istype(A, /obj/machinery/atmospherics/tvalve))
			var/obj/machinery/atmospherics/tvalve/T = A
			if(T.state)
				search |= list(T.node1, T.node2)
			else
				search |= list(T.node1, T.node3)

		else if(istype(A, /obj/machinery/atmospherics/pipe/zpipe))
			var/obj/machinery/atmospherics/pipe/zpipe/P = A
			search |= list(P.node1, P.node2)

		else if(istype(A, /obj/machinery/atmospherics/pipe/simple))
			var/obj/machinery/atmospherics/pipe/P = A
			search |= list(P.node1, P.node2)

		else if(istype(A, /obj/machinery/atmospherics/pipe/manifold))
			var/obj/machinery/atmospherics/pipe/manifold/M = A
			search |= list(M.node1, M.node2, M.node3)

		else if(istype(A, /obj/machinery/atmospherics/pipe/manifold4w))
			var/obj/machinery/atmospherics/pipe/manifold4w/M = A
			search |= list(M.node1, M.node2, M.node3, M.node4)

		// else continue, dead end
	// We broke out of the loop, so we see no leaks
	// The leaks therefore must be on the other side of another shutoff valve
	return
