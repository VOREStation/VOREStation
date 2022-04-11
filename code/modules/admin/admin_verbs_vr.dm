/client/proc/adminorbit()
	set category = "Fun"
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
		center = input(usr, "What should act as the center of the orbit?", "Center") as anything in possible_things
		possible_things -= center
	if(!orbiter)
		orbiter = input(usr, "What should act as the orbiter of the orbit?", "Orbiter") as anything in possible_things
	if(!center || !orbiter)
		to_chat(usr, "<span class = 'warning'>A center of orbit and an orbiter must be configured. You can also do this by marking a target.</span>")
		return
	if(center == orbiter)
		to_chat(usr, "<span class = 'warning'>The center of the orbit cannot also be the orbiter.</span>")
		return
	if(isturf(orbiter))
		to_chat(usr, "<span class = 'warning'>The orbiter cannot be a turf. It can only be used as a center.</span>")
		return
	var/distance = input(usr, "How large will their orbit radius be? (In pixels. 32 is 'near around a character)", "Orbit Radius", 32) as num|null
	var/speed = input(usr, "How fast will they orbit (negative numbers spin clockwise)", "Orbit Speed", 20) as num|null
	var/segments = input(usr, "How many segments will they have in their orbit? (3 is a triangle, 36 is a circle, etc)", "Orbit Segments", 36) as num|null
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
