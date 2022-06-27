/obj/item/device/paicard
	var/panel_open = FALSE
	var/cell = TRUE			//critical- power
	var/processor = TRUE	//critical- the thinky part
	var/board = TRUE		//critical- makes everything work
	var/capacitor = TRUE	//critical- power processing
	var/projector = TRUE	//non-critical- affects unfolding
	var/emitter = TRUE		//non-critical- affects unfolding
	var/screen = TRUE		//non-critical- affects screen
	var/list/parts = list(
		"cell",
		"processor",
		"board",
		"capacitor",
		"projector",
		"emitter",
		"screen")

/obj/item/device/paicard/attackby(var/obj/item/I as obj, mob/user as mob)
	if(istype(I,/obj/item/weapon/tool/screwdriver))
		if(panel_open)
			panel_open = FALSE
			user.visible_message("<span class ='warning'>\The [user] secured \the [src]'s maintenance panel.</span>")
		else
			panel_open = TRUE
			user.visible_message("<span class ='notice'>\The [user] opened \the [src]'s maintenance panel.</span>")
	if(istype(I,/obj/item/device/robotanalyzer))
		if(!panel_open)
			to_chat(user, "<span class ='warning'>The panel isn't open. You will need to unscrew it to open it.</span>")
		else
			if(cell)
				to_chat(user,"Power cell: <span class ='notice'>functional</span>")
			else
				to_chat(user,"Power cell: <span class ='warning'>damaged - CRITICAL</span>")
			if(processor)
				to_chat(user,"Processor: <span class ='notice'>functional</span>")
			else
				to_chat(user,"Processor: <span class ='warning'>damaged - CRITICAL</span>")
			if(board)
				to_chat(user,"Board: <span class ='notice'>functional</span>")
			else
				to_chat(user,"Board: <span class ='warning'>damaged - CRITICAL</span>")
			if(capacitor)
				to_chat(user,"Capacitors: <span class ='notice'>functional</span>")
			else
				to_chat(user,"Capacitors: <span class ='warning'>damaged - CRITICAL</span>")
			if(projector)
				to_chat(user,"Projectors: <span class ='notice'>functional</span>")
			else
				to_chat(user,"Projectors: <span class ='warning'>damaged</span>")
			if(emitter)
				to_chat(user,"Emitters: <span class ='notice'>functional</span>")
			else
				to_chat(user,"Emitters: <span class ='warning'>damaged</span>")
			if(screen)
				to_chat(user,"Screen: <span class ='notice'>functional</span>")
			else
				to_chat(user,"Screen: <span class ='warning'>damaged</span>")
	if(istype(I,/obj/item/device/multitool))
		if(!panel_open)
			to_chat(user, "<span class ='warning'>You can't do that in this state.</span>")
		else
			var/choice = tgui_input_list(user, "Which part would you like to check?", "Check part", parts)
			switch(choice)
				if("cell")
					if(cell)
						to_chat(user,"Power cell: <span class ='notice'>functional</span>")
					else
						to_chat(user,"Power cell: <span class ='warning'>damaged</span>")
				if("processor")
					if(processor)
						to_chat(user,"Processor: <span class ='notice'>functional</span>")
					else
						to_chat(user,"Processor: <span class ='warning'>damaged</span>")
				if("board")
					if(board)
						to_chat(user,"Board: <span class ='notice'>functional</span>")
					else
						to_chat(user,"Board: <span class ='warning'>damaged</span>")
				if("capacitor")
					if(capacitor)
						to_chat(user,"Capacitors: <span class ='notice'>functional</span>")
					else
						to_chat(user,"Capacitors: <span class ='warning'>damaged</span>")
				if("projector")
					if(projector)
						to_chat(user,"Projectors: <span class ='notice'>functional</span>")
					else
						to_chat(user,"Projectors: <span class ='warning'>damaged</span>")
				if("emitter")
					if(emitter)
						to_chat(user,"Emitters: <span class ='notice'>functional</span>")
					else
						to_chat(user,"Emitters: <span class ='warning'>damaged</span>")
				if("screen")
					if(screen)
						to_chat(user,"Screen: <span class ='notice'>functional</span>")
					else
						to_chat(user,"Screen: <span class ='warning'>damaged</span>")

/obj/item/device/paicard/attack_self(mob/user)
	if(!panel_open)
		access_screen(user)
		return
	var/choice = tgui_input_list(user, "Which part would you like to remove?", "Remove part", parts)
	switch(choice)
		if("cell")
			cell = FALSE
			if(pai.stat != DEAD)
				pai.death()
		if("processor")
			processor = FALSE
			if(pai.stat != DEAD)
				pai.death()
		if("board")
			board = FALSE
			if(pai.stat != DEAD)
				pai.death()
		if("capacitor")
			capacitor = FALSE
			if(pai.stat != DEAD)
				pai.death()
		if("projector")
			projector = FALSE
		if("emitter")
			emitter = FALSE
		if("screen")
			screen = FALSE
	parts -= choice

/obj/item/device/paicard/proc/death_damage()

	var/number = pick(1,4)
	while(number)
		switch(pick(1,4))
			if(1)
				cell = FALSE
			if(2)
				processor = FALSE
			if(3)
				board = FALSE
			if(4)
				capacitor = FALSE

/obj/item/device/paicard/proc/damage_random_component(nonfatal = FALSE)
	if(prob(80) || nonfatal)	//Way more likely to be non-fatal part damage
		switch(pick(1,3))
			if(1)
				projector = FALSE
			if(2)
				emitter = FALSE
			if(3)
				screen = FALSE
	else
		switch(pick(1,4))
			if(1)
				cell = FALSE
			if(2)
				processor = FALSE
			if(3)
				board = FALSE
			if(4)
				capacitor = FALSE
