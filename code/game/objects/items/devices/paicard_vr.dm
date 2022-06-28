#define PP_FUNCTIONAL		0
#define PP_BROKEN			1
#define PP_MISSING			2

var/global/list/paikeys = list()

/obj/item/device/paicard
	var/panel_open = FALSE
	var/cell = PP_FUNCTIONAL				//critical- power
	var/processor = PP_FUNCTIONAL			//critical- the thinky part
	var/board = PP_FUNCTIONAL				//critical- makes everything work
	var/capacitor = PP_FUNCTIONAL			//critical- power processing
	var/projector = PP_FUNCTIONAL			//non-critical- affects unfolding
	var/emitter = PP_FUNCTIONAL				//non-critical- affects unfolding
	var/speech_synthesizer = PP_FUNCTIONAL	//non-critical- affects speech

/obj/item/device/paicard/attackby(var/obj/item/I as obj, mob/user as mob)
	if(istype(I,/obj/item/weapon/tool/screwdriver))
		if(panel_open)
			panel_open = FALSE
			user.visible_message("<span class ='notice'>\The [user] secured \the [src]'s maintenance panel.</span>")
		else
			panel_open = TRUE
			user.visible_message("<span class ='warning'>\The [user] opened \the [src]'s maintenance panel.</span>")
	if(istype(I,/obj/item/device/robotanalyzer))
		if(!panel_open)
			to_chat(user, "<span class ='warning'>The panel isn't open. You will need to unscrew it to open it.</span>")
		else
			if(cell == PP_FUNCTIONAL)
				to_chat(user,"Power cell: <span class ='notice'>functional</span>")
			else if(cell == PP_BROKEN)
				to_chat(user,"Power cell: <span class ='warning'>damaged - CRITICAL</span>")
			else
				to_chat(user,"Power cell: <span class ='warning'>missing - CRITICAL</span>")

			if(processor == PP_FUNCTIONAL)
				to_chat(user,"Processor: <span class ='notice'>functional</span>")
			else if(processor == PP_BROKEN)
				to_chat(user,"Processor: <span class ='warning'>damaged - CRITICAL</span>")
			else
				to_chat(user,"Processor: <span class ='warning'>missing - CRITICAL</span>")

			if(board == PP_FUNCTIONAL)
				to_chat(user,"Board: <span class ='notice'>functional</span>")
			else if(board == PP_BROKEN)
				to_chat(user,"Board: <span class ='warning'>damaged - CRITICAL</span>")
			else
				to_chat(user,"Board: <span class ='warning'>missing - CRITICAL</span>")

			if(capacitor == PP_FUNCTIONAL)
				to_chat(user,"Capacitors: <span class ='notice'>functional</span>")
			else if(capacitor == PP_BROKEN)
				to_chat(user,"Capacitors: <span class ='warning'>damaged - CRITICAL</span>")
			else
				to_chat(user,"Capacitors: <span class ='warning'>missing - CRITICAL</span>")

			if(projector == PP_FUNCTIONAL)
				to_chat(user,"Projectors: <span class ='notice'>functional</span>")
			else if(projector == PP_BROKEN)
				to_chat(user,"Projectors: <span class ='warning'>damaged</span>")
			else
				to_chat(user,"Projectors: <span class ='warning'>missing</span>")

			if(emitter == PP_FUNCTIONAL)
				to_chat(user,"Emitters: <span class ='notice'>functional</span>")
			else if(emitter == PP_BROKEN)
				to_chat(user,"Emitters: <span class ='warning'>damaged</span>")
			else
				to_chat(user,"Emitters: <span class ='warning'>missing</span>")

			if(speech_synthesizer == PP_FUNCTIONAL)
				to_chat(user,"Speech Synthesizer: <span class ='notice'>functional</span>")
			else if(speech_synthesizer == PP_BROKEN)
				to_chat(user,"Speech Synthesizer: <span class ='warning'>damaged</span>")
			else
				to_chat(user,"Speech Synthesizer: <span class ='warning'>missing</span>")

	if(istype(I,/obj/item/device/multitool))
		if(!panel_open)
			to_chat(user, "<span class ='warning'>You can't do that in this state.</span>")
		else
			var/list/parts = list()
			if(cell != PP_MISSING)
				parts |= "cell"
			if(processor != PP_MISSING)
				parts |= "processor"
			if(board != PP_MISSING)
				parts |= "board"
			if(capacitor != PP_MISSING)
				parts |= "capacitor"
			if(projector != PP_MISSING)
				parts |= "projector"
			if(emitter != PP_MISSING)
				parts |= "emitter"
			if(speech_synthesizer != PP_MISSING)
				parts |= "speech synthesizer"

			var/choice = tgui_input_list(user, "Which part would you like to check?", "Check part", parts)
			switch(choice)
				if("cell")
					if(cell == PP_FUNCTIONAL)
						to_chat(user,"Power cell: <span class ='notice'>functional</span>")
					else if(speech_synthesizer == PP_BROKEN)
						to_chat(user,"Power cell: <span class ='warning'>damaged</span>")
					else
						to_chat(user,"Power cell: <span class ='warning'>missing</span>")

				if("processor")
					if(processor == PP_FUNCTIONAL)
						to_chat(user,"Processor: <span class ='notice'>functional</span>")
					else if(speech_synthesizer == PP_BROKEN)
						to_chat(user,"Processor: <span class ='warning'>damaged</span>")
					else
						to_chat(user,"Processor: <span class ='warning'>missing</span>")

				if("board")
					if(board == PP_FUNCTIONAL)
						to_chat(user,"Board: <span class ='notice'>functional</span>")
					else if(speech_synthesizer == PP_BROKEN)
						to_chat(user,"Board: <span class ='warning'>damaged</span>")
					else
						to_chat(user,"Board: <span class ='warning'>missing</span>")

				if("capacitor")
					if(capacitor == PP_FUNCTIONAL)
						to_chat(user,"Capacitors: <span class ='notice'>functional</span>")
					else if(speech_synthesizer == PP_BROKEN)
						to_chat(user,"Capacitors: <span class ='warning'>damaged</span>")
					else
						to_chat(user,"Capacitors: <span class ='warning'>missing</span>")

				if("projector")
					if(projector == PP_FUNCTIONAL)
						to_chat(user,"Projectors: <span class ='notice'>functional</span>")
					else if(speech_synthesizer == PP_BROKEN)
						to_chat(user,"Projectors: <span class ='warning'>damaged</span>")
					else
						to_chat(user,"Projectors: <span class ='warning'>missing</span>")

				if("emitter")
					if(emitter == PP_FUNCTIONAL)
						to_chat(user,"Emitters: <span class ='notice'>functional</span>")
					else if(speech_synthesizer == PP_BROKEN)
						to_chat(user,"Emitters: <span class ='warning'>damaged</span>")
					else
						to_chat(user,"Emitters: <span class ='warning'>missing</span>")

				if("speech synthesizer")
					if(speech_synthesizer == PP_FUNCTIONAL)
						to_chat(user,"Speech Synthesizer: <span class ='notice'>functional</span>")
					else if(speech_synthesizer == PP_BROKEN)
						to_chat(user,"Speech Synthesizer: <span class ='warning'>damaged</span>")
					else
						to_chat(user,"Speech Synthesizer: <span class ='warning'>missing</span>")

	if(istype(I,/obj/item/paiparts/cell) && cell == PP_MISSING)
		user.visible_message("<span class ='notice'>\The [user] installs \the [I] into \the [src].</span>","<span class ='notice'>You install \the [I] into \the [src].</span>")
		cell = PP_FUNCTIONAL
		user.drop_from_inventory(I)
		qdel(I)
	if(istype(I,/obj/item/paiparts/processor) && processor == PP_MISSING)
		user.visible_message("<span class ='notice'>\The [user] installs \the [I] into \the [src].</span>","<span class ='notice'>You install \the [I] into \the [src].</span>")
		processor = PP_FUNCTIONAL
		user.drop_from_inventory(I)
		qdel(I)
	if(istype(I,/obj/item/paiparts/board) && board == PP_MISSING)
		user.visible_message("<span class ='notice'>\The [user] installs \the [I] into \the [src].</span>","<span class ='notice'>You install \the [I] into \the [src].</span>")
		board = PP_FUNCTIONAL
		user.drop_from_inventory(I)
		qdel(I)
	if(istype(I,/obj/item/paiparts/capacitor) && capacitor == PP_MISSING)
		user.visible_message("<span class ='notice'>\The [user] installs \the [I] into \the [src].</span>","<span class ='notice'>You install \the [I] into \the [src].</span>")
		capacitor = PP_FUNCTIONAL
		user.drop_from_inventory(I)
		qdel(I)
	if(istype(I,/obj/item/paiparts/projector) && projector == PP_MISSING)
		user.visible_message("<span class ='notice'>\The [user] installs \the [I] into \the [src].</span>","<span class ='notice'>You install \the [I] into \the [src].</span>")
		projector = PP_FUNCTIONAL
		user.drop_from_inventory(I)
		qdel(I)
	if(istype(I,/obj/item/paiparts/emitter) && emitter == PP_MISSING)
		user.visible_message("<span class ='notice'>\The [user] installs \the [I] into \the [src].</span>","<span class ='notice'>You install \the [I] into \the [src].</span>")
		emitter = PP_FUNCTIONAL
		user.drop_from_inventory(I)
		qdel(I)
	if(istype(I,/obj/item/paiparts/speech_synthesizer) && speech_synthesizer == PP_MISSING)
		user.visible_message("<span class ='notice'>\The [user] installs \the [I] into \the [src].</span>","<span class ='notice'>You install \the [I] into \the [src].</span>")
		speech_synthesizer = PP_FUNCTIONAL
		user.drop_from_inventory(I)
		qdel(I)

/obj/item/device/paicard/attack_self(mob/user)
	if(!panel_open)
		access_screen(user)
		return
	var/list/parts = list()
	if(cell != PP_MISSING)
		parts |= "cell"
	if(processor != PP_MISSING)
		parts |= "processor"
	if(board != PP_MISSING)
		parts |= "board"
	if(capacitor != PP_MISSING)
		parts |= "capacitor"
	if(projector != PP_MISSING)
		parts |= "projector"
	if(emitter != PP_MISSING)
		parts |= "emitter"
	if(speech_synthesizer != PP_MISSING)
		parts |= "speech synthesizer"

	var/choice = tgui_input_list(user, "Which part would you like to remove?", "Remove part", parts)
	switch(choice)
		if("cell")
			if(cell == PP_FUNCTIONAL)
				new /obj/item/paiparts/capacitor(get_turf(user))
			else
				new /obj/item/paiparts(get_turf(user))
			user.visible_message("<span class ='warning'>\The [user] removes \the [choice] from \the [src].</span>","<span class ='warning'>You remove \the [choice] from \the [src].</span>")
			cell = PP_MISSING
		if("processor")
			if(processor == PP_FUNCTIONAL)
				new /obj/item/paiparts/capacitor(get_turf(user))
			else
				new /obj/item/paiparts(get_turf(user))
			user.visible_message("<span class ='warning'>\The [user] removes \the [choice] from \the [src].</span>","<span class ='warning'>You remove \the [choice] from \the [src].</span>")
			processor = PP_MISSING
		if("board")
			board = PP_MISSING
			if(board == PP_FUNCTIONAL)
				new /obj/item/paiparts/capacitor(get_turf(user))
			else
				new /obj/item/paiparts(get_turf(user))
			user.visible_message("<span class ='warning'>\The [user] removes \the [choice] from \the [src].</span>","<span class ='warning'>You remove \the [choice] from \the [src].</span>")

		if("capacitor")
			if(capacitor == PP_FUNCTIONAL)
				new /obj/item/paiparts/capacitor(get_turf(user))
			else
				new /obj/item/paiparts(get_turf(user))
			user.visible_message("<span class ='warning'>\The [user] removes \the [choice] from \the [src].</span>","<span class ='warning'>You remove \the [choice] from \the [src].</span>")
			capacitor = PP_MISSING
		if("projector")
			if(projector == PP_FUNCTIONAL)
				new /obj/item/paiparts/capacitor(get_turf(user))
			else
				new /obj/item/paiparts(get_turf(user))
			user.visible_message("<span class ='warning'>\The [user] removes \the [choice] from \the [src].</span>","<span class ='warning'>You remove \the [choice] from \the [src].</span>")
			projector = PP_MISSING
		if("emitter")
			if(emitter == PP_FUNCTIONAL)
				new /obj/item/paiparts/capacitor(get_turf(user))
			else
				new /obj/item/paiparts(get_turf(user))
			user.visible_message("<span class ='warning'>\The [user] removes \the [choice] from \the [src].</span>","<span class ='warning'>You remove \the [choice] from \the [src].</span>")
			emitter = PP_MISSING
		if("speech synthesizer")
			if(speech_synthesizer == PP_FUNCTIONAL)
				new /obj/item/paiparts/capacitor(get_turf(user))
			else
				new /obj/item/paiparts(get_turf(user))
			user.visible_message("<span class ='warning'>\The [user] removes \the [choice] from \the [src].</span>","<span class ='warning'>You remove \the [choice] from \the [src].</span>")
			speech_synthesizer = PP_MISSING

/obj/item/device/paicard/proc/death_damage()

	var/number = rand(1,4)
	while(number)
		number --
		switch(rand(1,4))
			if(1)
				cell = PP_BROKEN
			if(2)
				processor = PP_BROKEN
			if(3)
				board = PP_BROKEN
			if(4)
				capacitor = PP_BROKEN


/obj/item/device/paicard/proc/damage_random_component(nonfatal = FALSE)
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(2, 1, src)
	s.start()
	if(prob(80) || nonfatal)	//Way more likely to be non-fatal part damage
		switch(rand(1,3))
			if(1)
				projector = PP_BROKEN
			if(2)
				emitter = PP_BROKEN
			if(3)
				speech_synthesizer = PP_BROKEN
	else
		switch(rand(1,4))
			if(1)
				cell = PP_BROKEN
			if(2)
				processor = PP_BROKEN
			if(3)
				board = PP_BROKEN
			if(4)
				capacitor = PP_BROKEN

/obj/item/device/paicard/proc/is_damage_critical()
	if(cell != PP_FUNCTIONAL || processor != PP_FUNCTIONAL || board != PP_FUNCTIONAL || capacitor != PP_FUNCTIONAL)
		return TRUE
	return FALSE

/obj/item/paiparts
	name = "broken pAI component"
	desc = "It's broken scrap from a pAI card!"
	icon = 'icons/obj/paicard.dmi'
	icon_state = "broken"
/obj/item/paiparts/Initialize()
	. = ..()
	pixel_x = rand(-10,10)
	pixel_y = rand(-10,10)

/obj/item/paiparts/cell
	name = "pAI power cell"
	desc = "It's very small and efficient! It powers the pAI!"
	icon_state = "cell"
/obj/item/paiparts/processor
	name = "pAI processor"
	desc = "It's the brain of your computer friend!"
	icon_state = "processor"
/obj/item/paiparts/board
	name = "pAI board"
	desc = "It's the thing all the other parts get attatched to!"
	icon_state = "board"
/obj/item/paiparts/capacitor
	name = "pAI capacitor"
	desc = "It helps regulate power flow!"
	icon_state = "capacitor"
/obj/item/paiparts/projector
	name = "pAI projector"
	desc = "It projects the pAI's form!"
	icon_state = "projector"
/obj/item/paiparts/emitter
	name = "pAI emitter"
	desc = "It emits the fields to help the pAI get around!"
	icon_state = "emitter"
/obj/item/paiparts/speech_synthesizer
	name = "pAI speech synthesizer"
	desc = "It's a little voice box!"
	icon_state = "speech_synthesizer"
