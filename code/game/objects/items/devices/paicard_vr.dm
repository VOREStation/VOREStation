var/global/list/paikeys = list()

/obj/item/paicard
	var/panel_open = FALSE
	var/cell = PP_FUNCTIONAL				//critical- power
	var/processor = PP_FUNCTIONAL			//critical- the thinky part
	var/board = PP_FUNCTIONAL				//critical- makes everything work
	var/capacitor = PP_FUNCTIONAL			//critical- power processing
	var/projector = PP_FUNCTIONAL			//non-critical- affects unfolding
	var/emitter = PP_FUNCTIONAL				//non-critical- affects unfolding
	var/speech_synthesizer = PP_FUNCTIONAL	//non-critical- affects speech

/obj/item/paicard/attackby(var/obj/item/I as obj, mob/user as mob)
	if(istype(I,/obj/item/tool/screwdriver))
		if(panel_open)
			panel_open = FALSE
			user.visible_message(span_notice("\The [user] secured \the [src]'s maintenance panel."))
			playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
		else if(pai)
			if(do_after(user, 3 SECONDS))
				panel_open = TRUE
				user.visible_message(span_warning("\The [user] opened \the [src]'s maintenance panel."))
				playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
	if(istype(I,/obj/item/robotanalyzer))
		if(!panel_open)
			to_chat(user, span_warning("The panel isn't open. You will need to unscrew it to open it."))
		else
			if(cell == PP_FUNCTIONAL)
				to_chat(user,"Power cell: " + span_notice("functional"))
			else if(cell == PP_BROKEN)
				to_chat(user,"Power cell: " + span_warning("damaged - CRITICAL"))
			else
				to_chat(user,"Power cell: " + span_warning("missing - CRITICAL"))

			if(processor == PP_FUNCTIONAL)
				to_chat(user,"Processor: " + span_notice("functional"))
			else if(processor == PP_BROKEN)
				to_chat(user,"Processor: " + span_warning("damaged - CRITICAL"))
			else
				to_chat(user,"Processor: " + span_warning("missing - CRITICAL"))

			if(board == PP_FUNCTIONAL)
				to_chat(user,"Board: " + span_notice("functional"))
			else if(board == PP_BROKEN)
				to_chat(user,"Board: " + span_warning("damaged - CRITICAL"))
			else
				to_chat(user,"Board: " + span_warning("missing - CRITICAL"))

			if(capacitor == PP_FUNCTIONAL)
				to_chat(user,"Capacitors: " + span_notice("functional"))
			else if(capacitor == PP_BROKEN)
				to_chat(user,"Capacitors: " + span_warning("damaged - CRITICAL"))
			else
				to_chat(user,"Capacitors: " + span_warning("missing - CRITICAL"))

			if(projector == PP_FUNCTIONAL)
				to_chat(user,"Projectors: " + span_notice("functional"))
			else if(projector == PP_BROKEN)
				to_chat(user,"Projectors: " + span_warning("damaged"))
			else
				to_chat(user,"Projectors: " + span_warning("missing"))

			if(emitter == PP_FUNCTIONAL)
				to_chat(user,"Emitters: " + span_notice("functional"))
			else if(emitter == PP_BROKEN)
				to_chat(user,"Emitters: " + span_warning("damaged"))
			else
				to_chat(user,"Emitters: " + span_warning("missing"))

			if(speech_synthesizer == PP_FUNCTIONAL)
				to_chat(user,"Speech Synthesizer: " + span_notice("functional"))
			else if(speech_synthesizer == PP_BROKEN)
				to_chat(user,"Speech Synthesizer: " + span_warning("damaged"))
			else
				to_chat(user,"Speech Synthesizer: " + span_warning("missing"))

	if(istype(I,/obj/item/multitool))
		if(!panel_open)
			to_chat(user, span_warning("You can't do that in this state."))
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
						to_chat(user,"Power cell: " + span_notice("functional"))
					else if(speech_synthesizer == PP_BROKEN)
						to_chat(user,"Power cell: " + span_warning("damaged"))
					else
						to_chat(user,"Power cell: " + span_warning("missing"))

				if("processor")
					if(processor == PP_FUNCTIONAL)
						to_chat(user,"Processor: " + span_notice("functional"))
					else if(speech_synthesizer == PP_BROKEN)
						to_chat(user,"Processor: " + span_warning("damaged"))
					else
						to_chat(user,"Processor: " + span_warning("missing"))

				if("board")
					if(board == PP_FUNCTIONAL)
						to_chat(user,"Board: " + span_notice("functional"))
					else if(speech_synthesizer == PP_BROKEN)
						to_chat(user,"Board: " + span_warning("damaged"))
					else
						to_chat(user,"Board: " + span_warning("missing"))

				if("capacitor")
					if(capacitor == PP_FUNCTIONAL)
						to_chat(user,"Capacitors: " + span_notice("functional"))
					else if(speech_synthesizer == PP_BROKEN)
						to_chat(user,"Capacitors: " + span_warning("damaged"))
					else
						to_chat(user,"Capacitors: " + span_warning("missing"))

				if("projector")
					if(projector == PP_FUNCTIONAL)
						to_chat(user,"Projectors: " + span_notice("functional"))
					else if(speech_synthesizer == PP_BROKEN)
						to_chat(user,"Projectors: " + span_warning("damaged"))
					else
						to_chat(user,"Projectors: " + span_warning("missing"))

				if("emitter")
					if(emitter == PP_FUNCTIONAL)
						to_chat(user,"Emitters: " + span_notice("functional"))
					else if(speech_synthesizer == PP_BROKEN)
						to_chat(user,"Emitters: " + span_warning("damaged"))
					else
						to_chat(user,"Emitters: " + span_warning("missing"))

				if("speech synthesizer")
					if(speech_synthesizer == PP_FUNCTIONAL)
						to_chat(user,"Speech Synthesizer: " + span_notice("functional"))
					else if(speech_synthesizer == PP_BROKEN)
						to_chat(user,"Speech Synthesizer: " + span_warning("damaged"))
					else
						to_chat(user,"Speech Synthesizer: " + span_warning("missing"))

	if(istype(I,/obj/item/paiparts/cell))
		if(cell == PP_MISSING)
			if(do_after(user, 3 SECONDS))
				user.visible_message(span_notice("\The [user] installs \the [I] into \the [src]."),span_notice("You install \the [I] into \the [src]."))
				cell = PP_FUNCTIONAL
				user.drop_from_inventory(I)
				qdel(I)
		else
			to_chat(user, span_warning("You would need to remove the installed [I] first!"))
	if(istype(I,/obj/item/paiparts/processor))
		if(processor == PP_MISSING)
			if(do_after(user, 3 SECONDS))
				user.visible_message(span_notice("\The [user] installs \the [I] into \the [src]."),span_notice("You install \the [I] into \the [src]."))
				processor = PP_FUNCTIONAL
				user.drop_from_inventory(I)
				qdel(I)
		else
			to_chat(user, span_warning("You would need to remove the installed [I] first!"))
	if(istype(I,/obj/item/paiparts/board))
		if(board == PP_MISSING)
			if(do_after(user, 3 SECONDS))
				user.visible_message(span_notice("\The [user] installs \the [I] into \the [src]."),span_notice("You install \the [I] into \the [src]."))
				board = PP_FUNCTIONAL
				user.drop_from_inventory(I)
				qdel(I)
		else
			to_chat(user, span_warning("You would need to remove the installed [I] first!"))
	if(istype(I,/obj/item/paiparts/capacitor))
		if(capacitor == PP_MISSING)
			if(do_after(user, 3 SECONDS))
				user.visible_message(span_notice("\The [user] installs \the [I] into \the [src]."),span_notice("You install \the [I] into \the [src]."))
				capacitor = PP_FUNCTIONAL
				user.drop_from_inventory(I)
				qdel(I)
		else
			to_chat(user, span_warning("You would need to remove the installed [I] first!"))
	if(istype(I,/obj/item/paiparts/projector))
		if(projector == PP_MISSING)
			if(do_after(user, 3 SECONDS))
				user.visible_message(span_notice("\The [user] installs \the [I] into \the [src]."),span_notice("You install \the [I] into \the [src]."))
				projector = PP_FUNCTIONAL
				user.drop_from_inventory(I)
				qdel(I)
		else
			to_chat(user, span_warning("You would need to remove the installed [I] first!"))
	if(istype(I,/obj/item/paiparts/emitter))
		if(emitter == PP_MISSING)
			if(do_after(user, 3 SECONDS))
				user.visible_message(span_notice("\The [user] installs \the [I] into \the [src]."),span_notice("You install \the [I] into \the [src]."))
				emitter = PP_FUNCTIONAL
				user.drop_from_inventory(I)
				qdel(I)
		else
			to_chat(user, span_warning("You would need to remove the installed [I] first!"))
	if(istype(I,/obj/item/paiparts/speech_synthesizer))
		if(speech_synthesizer == PP_MISSING)
			if(do_after(user, 3 SECONDS))
				user.visible_message(span_notice("\The [user] installs \the [I] into \the [src]."),span_notice("You install \the [I] into \the [src]."))
				speech_synthesizer = PP_FUNCTIONAL
				user.drop_from_inventory(I)
				qdel(I)
		else
			to_chat(user, span_warning("You would need to remove the installed [I] first!"))

/obj/item/paicard/attack_self(mob/user)
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
	if(choice)
		playsound(src, 'sound/items/pickup/component.ogg', vary = TRUE)
	else
		return
	if(!do_after(user, 3 SECONDS))
		return
	switch(choice)
		if("cell")
			if(cell == PP_FUNCTIONAL)
				new /obj/item/paiparts/capacitor(get_turf(user))
			else
				new /obj/item/paiparts(get_turf(user))
			user.visible_message(span_warning("\The [user] removes \the [choice] from \the [src]."),span_warning("You remove \the [choice] from \the [src]."))
			cell = PP_MISSING
		if("processor")
			if(processor == PP_FUNCTIONAL)
				new /obj/item/paiparts/capacitor(get_turf(user))
			else
				new /obj/item/paiparts(get_turf(user))
			user.visible_message(span_warning("\The [user] removes \the [choice] from \the [src]."),span_warning("You remove \the [choice] from \the [src]."))
			processor = PP_MISSING
		if("board")
			board = PP_MISSING
			if(board == PP_FUNCTIONAL)
				new /obj/item/paiparts/capacitor(get_turf(user))
			else
				new /obj/item/paiparts(get_turf(user))
			user.visible_message(span_warning("\The [user] removes \the [choice] from \the [src]."),span_warning("You remove \the [choice] from \the [src]."))

		if("capacitor")
			if(capacitor == PP_FUNCTIONAL)
				new /obj/item/paiparts/capacitor(get_turf(user))
			else
				new /obj/item/paiparts(get_turf(user))
			user.visible_message(span_warning("\The [user] removes \the [choice] from \the [src]."),span_warning("You remove \the [choice] from \the [src]."))
			capacitor = PP_MISSING
		if("projector")
			if(projector == PP_FUNCTIONAL)
				new /obj/item/paiparts/capacitor(get_turf(user))
			else
				new /obj/item/paiparts(get_turf(user))
			user.visible_message(span_warning("\The [user] removes \the [choice] from \the [src]."),span_warning("You remove \the [choice] from \the [src]."))
			projector = PP_MISSING
		if("emitter")
			if(emitter == PP_FUNCTIONAL)
				new /obj/item/paiparts/capacitor(get_turf(user))
			else
				new /obj/item/paiparts(get_turf(user))
			user.visible_message(span_warning("\The [user] removes \the [choice] from \the [src]."),span_warning("You remove \the [choice] from \the [src]."))
			emitter = PP_MISSING
		if("speech synthesizer")
			if(speech_synthesizer == PP_FUNCTIONAL)
				new /obj/item/paiparts/capacitor(get_turf(user))
			else
				new /obj/item/paiparts(get_turf(user))
			user.visible_message(span_warning("\The [user] removes \the [choice] from \the [src]."),span_warning("You remove \the [choice] from \the [src]."))
			speech_synthesizer = PP_MISSING

/obj/item/paicard/proc/death_damage()

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


/obj/item/paicard/proc/damage_random_component(nonfatal = FALSE)
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

/obj/item/paicard/proc/is_damage_critical()
	if(cell != PP_FUNCTIONAL || processor != PP_FUNCTIONAL || board != PP_FUNCTIONAL || capacitor != PP_FUNCTIONAL)
		return TRUE
	return FALSE

/obj/item/paiparts
	name = "broken pAI component"
	desc = "It's broken scrap from a pAI card!"
	icon = 'icons/obj/paicard.dmi'
	icon_state = "broken"
	pickup_sound = 'sound/items/pickup/card.ogg'
	drop_sound = 'sound/items/drop/card.ogg'
/obj/item/paiparts/Initialize(mapload)
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
