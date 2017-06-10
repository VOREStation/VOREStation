/datum/nifsoft/apc_recharge
	name = "APC Connector"
	desc = "A small attachment that allows synthmorphs to recharge themselves from APCs."
	list_pos = NIF_APCCHARGE
	cost = 1250
	wear = 2
	applies_to = NIF_SYNTHETIC
	tick_flags = NIF_ACTIVETICK
	var/obj/machinery/power/apc/apc

	activate()
		if((. = ..()))
			var/mob/living/carbon/human/H = nif.human
			nif.set_flag(NIF_O_APCCHARGE,NIF_FLAGS_OTHER)
			apc = locate(/obj/machinery/power/apc) in get_step(H,H.dir)
			if(!apc)
				apc = locate(/obj/machinery/power/apc) in get_step(H,0)
			if(!apc)
				nif.notify("You must be facing an APC to connect to.",TRUE)
				spawn(0)
					deactivate()
				return FALSE

			H.visible_message("<span class='warning'>Thin snakelike tendrils grow from [H] and connect to \the [apc].</span>","<span class='notice'>Thin snakelike tendrils grow from you and connect to \the [apc].</span>")

	deactivate()
		if((. = ..()))
			nif.clear_flag(NIF_O_APCCHARGE,NIF_FLAGS_OTHER)
			apc = null

	life()
		if((. = ..()))
			var/mob/living/carbon/human/H = nif.human
			if(apc && (get_dist(H,apc) <= 1) && H.nutrition < 440) // 440 vs 450, life() happens before we get here so it'll never be EXACTLY 450
				H.nutrition = min(H.nutrition+10, 450)
				apc.drain_power(7000/450*10) //This is from the large rechargers. No idea what the math is.
				return TRUE
			else
				nif.notify("APC charging has ended.")
				H.visible_message("<span class='warning'>[H]'s snakelike tendrils whip back into their body from \the [apc].</span>","<span class='notice'>The APC connector tendrils return to your body.</span>")
				deactivate()
				return FALSE

/datum/nifsoft/pressure
	name = "Pressure Seals"
	desc = "Creates pressure seals around important synthetic components to protect them from vacuum. Almost impossible on organics."
	list_pos = NIF_PRESSURE
	cost = 1750
	a_drain = 0.5
	wear = 3
	applies_to = NIF_SYNTHETIC

	activate()
		if((. = ..()))
			nif.set_flag(NIF_O_PRESSURESEAL,NIF_FLAGS_OTHER)

	deactivate()
		if((. = ..()))
			nif.clear_flag(NIF_O_PRESSURESEAL,NIF_FLAGS_OTHER)

/datum/nifsoft/heatsinks
	name = "Heat Sinks"
	desc = "Advanced heat sinks for internal heat storage of heat on a synth until able to vent it in atmosphere."
	list_pos = NIF_HEATSINK
	cost = 1450
	a_drain = 0.25
	wear = 3
	var/used = 0
	tick_flags = NIF_ALWAYSTICK
	applies_to = NIF_SYNTHETIC

	activate()
		if((. = ..()))
			if(used >= 50)
				nif.notify("Heat sinks not safe to operate again yet!",TRUE)
				spawn(0)
					deactivate()
				return FALSE
			nif.set_flag(NIF_O_HEATSINKS,NIF_FLAGS_OTHER)

	deactivate()
		if((. = ..()))
			nif.clear_flag(NIF_O_HEATSINKS,NIF_FLAGS_OTHER)

	life()
		if((. = ..()))
			//Not being used, all clean.
			if(!active && !used)
				return TRUE

			//Being used, and running out.
			else if(active && ++used == 100)
				nif.notify("Heat sinks overloaded! Shutting down!",TRUE)
				deactivate()

			//Being cleaned, and finishing empty.
			else if(!active && --used == 0)
				nif.notify("Heat sinks re-chilled.")

/datum/nifsoft/compliance
	name = "Compliance Module"
	desc = "A system that allows one to apply 'laws' to sapient life. Extremely illegal, of course."
	list_pos = NIF_COMPLIANCE
	cost = 8200
	wear = 4
	illegal = TRUE
	vended = FALSE
	access = 999 //Prevents anyone from buying it without an emag.
	var/laws = "Be nice to people!"

	New(var/newloc,var/newlaws)
		laws = newlaws //Sanitize before this (the disk does)
		..(newloc)

	activate()
		if((. = ..()))
			to_chat(nif.human,"<span class='danger'>You are compelled to follow these rules: </span>\n<span class='notify'>[laws]</span>")

	install()
		if((. = ..()))
			to_chat(nif.human,"<span class='danger'>You feel suddenly compelled to follow these rules: </span>\n<span class='notify'>[laws]</span>")

	uninstall()
		nif.notify("ERROR! Unable to comply!",TRUE)
		return FALSE //NOPE.

	stat_text()
		return "Show Laws"

/datum/nifsoft/sizechange
	name = "Mass Alteration"
	desc = "A system that allows one to change their size, through drastic mass rearrangement. Causes significant wear when installed."
	list_pos = NIF_SIZECHANGE
	cost = 750
	wear = 6

	activate()
		if((. = ..()))
			var/choice = alert(nif.human,"Change which way?","Mass Alteration","Size Up","Cancel", "Size Down")
			if(choice == "Cancel")
				spawn(0) deactivate()
				return FALSE

			if(!nif.use_charge(100))
				nif.notify("Insufficient energy to resize!",TRUE)
				spawn(0) deactivate()
				return FALSE

			if(choice == "Size Up")
				switch(nif.human.size_multiplier)
					if(RESIZE_BIG to RESIZE_HUGE)
						nif.human.resize(RESIZE_HUGE)
					if(RESIZE_NORMAL to RESIZE_BIG)
						nif.human.resize(RESIZE_BIG)
					if(RESIZE_SMALL to RESIZE_NORMAL)
						nif.human.resize(RESIZE_NORMAL)
					if((0 - INFINITY) to RESIZE_TINY)
						nif.human.resize(RESIZE_SMALL)

			else if(choice == "Size Down")
				switch(nif.human.size_multiplier)
					if(RESIZE_HUGE to INFINITY)
						nif.human.resize(RESIZE_BIG)
					if(RESIZE_BIG to RESIZE_HUGE)
						nif.human.resize(RESIZE_NORMAL)
					if(RESIZE_NORMAL to RESIZE_BIG)
						nif.human.resize(RESIZE_SMALL)
					if((0 - INFINITY) to RESIZE_NORMAL)
						nif.human.resize(RESIZE_TINY)

			nif.human.visible_message("<span class='warning'>Swirling grey mist envelops [nif.human] as they change size!</span>","<span class='notice'>Swirling streams of nanites wrap around you as you change size!</span>")
			nif.human.update_icons()

			spawn(0)
				deactivate()

	deactivate()
		if((. = ..()))
			return TRUE

	stat_text()
		return "Change Size"