// It.. uses a lot of power.  Everything under power is engineering stuff, at least.

/obj/machinery/computer/gravity_control_computer
	name = "gravity generator control"
	desc = "A computer to control a local gravity generator.  Qualified personnel only."
	icon_state = "airtunnel0e"
	anchored = TRUE
	density = TRUE
	var/obj/machinery/gravity_generator = null


/obj/machinery/gravity_generator/
	name = "gravitational generator"
	desc = "A device which produces a gravaton field when set up."
	icon = 'icons/obj/singularity.dmi'
	icon_state = "TheSingGen"
	anchored = TRUE
	density = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 200
	active_power_usage = 1000
	var/on = 1
	var/list/localareas = list()
	var/effectiverange = 25

	// Borrows code from cloning computer
/obj/machinery/computer/gravity_control_computer/Initialize(mapload)
	. = ..()
	updatemodules()

/obj/machinery/gravity_generator/Initialize(mapload)
	. = ..()
	locatelocalareas()

/obj/machinery/computer/gravity_control_computer/proc/updatemodules()
	src.gravity_generator = findgenerator()

/obj/machinery/gravity_generator/proc/locatelocalareas()
	for(var/area/A in range(src,effectiverange))
		if(A.name == "Space")
			continue // No (de)gravitizing space.
		if(!(A in localareas))
			localareas += A

/obj/machinery/computer/gravity_control_computer/proc/findgenerator()
	var/obj/machinery/gravity_generator/foundgenerator = null
	for(dir in list(NORTH,EAST,SOUTH,WEST))
		//to_world("SEARCHING IN [dir]")
		foundgenerator = locate(/obj/machinery/gravity_generator/, get_step(src, dir))
		if (!isnull(foundgenerator))
			//to_world("FOUND")
			break
	return foundgenerator

/obj/machinery/computer/gravity_control_computer/attack_ai(mob/user as mob)
	return attack_hand(user)

/obj/machinery/computer/gravity_control_computer/attack_hand(mob/user as mob)
	user.set_machine(src)
	add_fingerprint(user)

	if(stat & (BROKEN|NOPOWER))
		return

	updatemodules()

	var/dat = "<h3>Generator Control System</h3>"
	//dat += span_small("<a href='byond://?src=\ref[src];refresh=1'>Refresh</a>")
	if(gravity_generator)
		if(gravity_generator:on)
			dat += span_green("<br><tt>Gravity Status: ON</tt>") + "<br>"
		else
			dat += span_red("<br><tt>Gravity Status: OFF</tt>") + "<br>"

		dat += "<br><tt>Currently Supplying Gravitons To:</tt><br>"

		for(var/area/A in gravity_generator:localareas)
			if(A.has_gravity && gravity_generator:on)
				dat += "<tt>" + span_green("[A]</tt>") + "<br>"

			else if (A.has_gravity)
				dat += "<tt>" + span_yellow("[A]</tt>") + "<br>"

			else
				dat += "<tt>" + span_red("[A]</tt>") + "<br>"

		dat += "<br><tt>Maintenance Functions:</tt><br>"
		if(gravity_generator:on)
			dat += "<a href='byond://?src=\ref[src];gentoggle=1'>" + span_red(" TURN GRAVITY GENERATOR OFF. ") + "</a>"
		else
			dat += "<a href='byond://?src=\ref[src];gentoggle=1'>" + span_green(" TURN GRAVITY GENERATOR ON. ") + "</a>"

	else
		dat += "No local gravity generator detected!"

	user << browse("<html>[dat]</html>", "window=gravgen")
	onclose(user, "gravgen")


/obj/machinery/computer/gravity_control_computer/Topic(href, href_list)
	set background = 1
	..()

	if ( (get_dist(src, usr) > 1 ))
		if (!istype(usr, /mob/living/silicon))
			usr.unset_machine()
			usr << browse(null, "window=air_alarm")
			return

	if(href_list["gentoggle"])
		if(gravity_generator:on)
			gravity_generator:on = 0

			for(var/area/A in gravity_generator:localareas)
				var/obj/machinery/gravity_generator/G
				for(G in GLOB.machines)
					if((A in G.localareas) && (G.on))
						break
				if(!G)
					A.gravitychange(0)


		else
			for(var/area/A in gravity_generator:localareas)
				gravity_generator:on = 1
				A.gravitychange(1)

		src.updateUsrDialog(usr)
		return
