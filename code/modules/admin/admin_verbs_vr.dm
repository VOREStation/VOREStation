/client/proc/adminorbit()
	set category = "Fun.Event Kit"
	set name = "Orbit Things"
	set desc = "Makes something orbit around something else."
	set popup_menu = FALSE

	if(!check_rights(R_FUN))
		return

	var/center
	var/atom/movable/orbiter
	var/input

	if(holder.marked_datum)
		input = tgui_alert(usr, "You have \n[holder.marked_datum] marked, should this be the center of the orbit, or the orbiter?", "Orbit", list("Center", "Orbiter", "Neither"))
		switch(input)
			if("Center")
				center = holder.marked_datum
			if("Orbiter")
				orbiter = holder.marked_datum
	var/list/possible_things = list()
	for(var/T as mob in view(view))	//Let's do mobs before objects
		if(ismob(T))
			possible_things |= T
	for(var/T as obj in view(view))
		if(isobj(T))
			possible_things |= T
	if(!center)
		center = tgui_input_list(src, "What should act as the center of the orbit?", "Center", possible_things)
		possible_things -= center
	if(!orbiter)
		orbiter = tgui_input_list(src, "What should act as the orbiter of the orbit?", "Orbiter", possible_things)
	if(!center || !orbiter)
		to_chat(usr, span_warning("A center of orbit and an orbiter must be configured. You can also do this by marking a target."))
		return
	if(center == orbiter)
		to_chat(usr, span_warning("The center of the orbit cannot also be the orbiter."))
		return
	if(isturf(orbiter))
		to_chat(usr, span_warning("The orbiter cannot be a turf. It can only be used as a center."))
		return
	var/distance = tgui_input_number(usr, "How large will their orbit radius be? (In pixels. 32 is 'near around a character)", "Orbit Radius", 32)
	var/speed = tgui_input_number(usr, "How fast will they orbit (negative numbers spin clockwise)", "Orbit Speed", 20)
	var/segments = tgui_input_number(usr, "How many segments will they have in their orbit? (3 is a triangle, 36 is a circle, etc)", "Orbit Segments", 36)
	var/clock = FALSE
	if(!distance)
		distance = 32
	if(!speed)
		speed = 20
	else if (speed < 0)
		clock = TRUE
		speed *= -1
	if(!segments)
		segments = 36
	if(tgui_alert(usr, "\The [orbiter] will orbit around [center]. Is this okay?", "Confirm Orbit", list("Yes", "No")) == "Yes")
		orbiter.orbit(center, distance, clock, speed, segments)

/client/proc/removetickets()
	set name = "Security Tickets"
	set category = "Admin.Investigate"
	set desc = "Allows one to remove tickets from the global list."

	if(!check_rights(R_ADMIN))
		return

	if(security_printer_tickets.len >= 1)
		var/input = tgui_input_list(usr, "Which message?", "Security Tickets", security_printer_tickets)
		if(!input)
			return
		if(tgui_alert(usr, "Do you want to remove the following message from the global list? \"[input]\"", "Remove Ticket", list("Yes", "No")) == "Yes")
			security_printer_tickets -= input
			log_and_message_admins("removed a security ticket from the global list: \"[input]\"", usr)

	else
		tgui_alert_async(usr, "The ticket list is empty.","Empty")

/client/proc/delbook()
	set name = "Delete Book"
	set desc = "Permamently deletes a book from the database."
	set category = "Admin.Game"
	if(!src.holder)
		to_chat(src, "Only administrators may use this command.")
		return

	var/obj/machinery/librarycomp/our_comp
	for(var/obj/machinery/librarycomp/l in world)
		if(istype(l, /obj/machinery/librarycomp))
			our_comp = l
			break

	if(!our_comp)
		to_chat(usr, span_warning("Unable to locate a library computer to use for book deleting."))
		return

	var/dat = "<HEAD><TITLE>Book Inventory Management</TITLE></HEAD><BODY>\n"
	dat += "<h3>ADMINISTRATIVE MANAGEMENT</h3>"
	establish_db_connection()

	if(!SSdbcore.IsConnected())
		dat += "<font color=red><b>ERROR</b>: Unable to contact External Archive. Please contact your system administrator for assistance.</font>"
	else
		dat += {"<A href='byond://?our_comp=\ref[our_comp];[HrefToken()];orderbyid=1'>(Order book by SS<sup>13</sup>BN)</A><BR><BR>
		<table>
		<tr><td><A href='byond://?our_comp=\ref[our_comp];[HrefToken()];sort=author>AUTHOR</A></td><td><A href='byond://?our_comp=\ref[our_comp];[HrefToken()];sort=title>TITLE</A></td><td><A href='byond://?our_comp=\ref[our_comp];[HrefToken()];sort=category>CATEGORY</A></td><td></td></tr>"}
		var/datum/db_query/query = SSdbcore.NewQuery("SELECT id, author, title, category FROM library ORDER BY [our_comp.sortby]")
		query.Execute()

		var/show_admin_options = check_rights(R_ADMIN, show_msg = FALSE)

		while(query.NextRow())
			var/id = query.item[1]
			var/author = query.item[2]
			var/title = query.item[3]
			var/category = query.item[4]
			dat += "<tr><td>[author]</td><td>[title]</td><td>[category]</td><td>"
			if(show_admin_options) // This isn't the only check, since you can just href-spoof press this button. Just to tidy things up.
				dat += "<A href='byond://?our_comp=\ref[our_comp];[HrefToken()];delid=[id]'>\[Del\]</A>"
			dat += "</td></tr>"
		dat += "</table>"

		qdel(query)
	usr << browse("<html>[dat]</html>", "window=library")
	onclose(usr, "library")

/client/proc/toggle_spawning_with_recolour()
	set name = "Toggle Simple/Robot recolour verb"
	set desc = "Makes it so new robots/simple_mobs spawn with a verb to recolour themselves for this round. You must set them separately."
	set category = "Server.Game"

	if(!check_rights(R_ADMIN|R_EVENT|R_FUN))
		return

	var/which = tgui_alert(usr, "Which do you want to toggle?", "Choose Recolour Toggle", list("Robot", "Simple Mob"))
	switch(which)
		if("Robot")
			CONFIG_SET(flag/allow_robot_recolor, !CONFIG_GET(flag/allow_robot_recolor))
			to_chat(usr, "You have [CONFIG_GET(flag/allow_robot_recolor) ? "enabled" : "disabled"] newly spawned cyborgs to spawn with the recolour verb")
		if("Simple Mob")
			CONFIG_SET(flag/allow_simple_mob_recolor, !CONFIG_GET(flag/allow_simple_mob_recolor))
			to_chat(usr, "You have [CONFIG_GET(flag/allow_simple_mob_recolor) ? "enabled" : "disabled"] newly spawned simple mobs to spawn with the recolour verb")
