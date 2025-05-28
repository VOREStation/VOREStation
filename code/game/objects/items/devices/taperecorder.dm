/obj/item/taperecorder
	name = "universal recorder"
	desc = "A device that can record to cassette tapes, and play them. It automatically translates the content in playback."
	icon = 'icons/obj/device.dmi'
	icon_state = "taperecorder_empty"
	item_state = "analyzer"
	w_class = ITEMSIZE_SMALL

	matter = list(MAT_STEEL = 60,MAT_GLASS = 30)

	var/emagged = 0.0
	var/recording = 0.0
	var/playing = 0.0
	var/playsleepseconds = 0.0
	var/obj/item/rectape/mytape = /obj/item/rectape/random
	var/canprint = 1
	slot_flags = SLOT_BELT
	throwforce = 2
	throw_speed = 4
	throw_range = 20
	pickup_sound = 'sound/items/pickup/device.ogg'
	drop_sound = 'sound/items/drop/device.ogg'

/obj/item/taperecorder/Initialize(mapload)
	. = ..()
	if(ispath(mytape))
		mytape = new mytape(src)
		update_icon()
	listening_objects += src

/obj/item/taperecorder/empty
	mytape = null

/obj/item/taperecorder/Destroy()
	listening_objects -= src
	if(mytape)
		qdel(mytape)
		mytape = null
	return ..()


/obj/item/taperecorder/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/rectape))
		if(mytape)
			to_chat(user, span_notice("There's already a tape inside."))
			return
		if(!user.unEquip(I))
			return
		I.forceMove(src)
		mytape = I
		to_chat(user, span_notice("You insert [I] into [src]."))
		update_icon()
		return
	..()


/obj/item/taperecorder/fire_act()
	if(mytape)
		mytape.ruin() //Fires destroy the tape
	return ..()


/obj/item/taperecorder/attack_hand(mob/user)
	if(user.get_inactive_hand() == src)
		if(mytape)
			eject()
			return
	..()


/obj/item/taperecorder/verb/eject()
	set name = "Eject Tape"
	set category = "Object"

	if(usr.incapacitated())
		return
	if(!mytape)
		to_chat(usr, span_notice("There's no tape in \the [src]."))
		return
	if(emagged)
		to_chat(usr, span_notice("The tape seems to be stuck inside."))
		return

	if(playing || recording)
		stop()
	to_chat(usr, span_notice("You remove [mytape] from [src]."))
	usr.put_in_hands(mytape)
	mytape = null
	update_icon()


/obj/item/taperecorder/hear_talk(mob/M, list/message_pieces, verb)
	var/msg = multilingual_to_message(message_pieces, requires_machine_understands = TRUE, with_capitalization = TRUE)
	var/voice = M.GetVoice() //Defined on living, returns name for normal mobs/
	if(mytape && recording)
		mytape.record_speech("[voice] [verb], \"[msg]\"")


/obj/item/taperecorder/see_emote(mob/M as mob, text, var/emote_type)
	if(emote_type != 2) //only hearable emotes
		return
	if(mytape && recording)
		mytape.record_speech("[strip_html_properly(text)]")


/obj/item/taperecorder/show_message(msg, type, alt, alt_type)
	var/recordedtext
	if (msg && type == 2) //must be hearable
		recordedtext = msg
	else if (alt && alt_type == 2)
		recordedtext = alt
	else
		return
	if(mytape && recording)
		mytape.record_noise("[strip_html_properly(recordedtext)]")

/obj/item/taperecorder/emag_act(var/remaining_charges, var/mob/user)
	if(emagged == 0)
		emagged = 1
		recording = 0
		to_chat(user, span_warning("PZZTTPFFFT"))
		update_icon()
		return 1
	else
		to_chat(user, span_warning("It is already emagged!"))

/obj/item/taperecorder/proc/explode()
	var/turf/T = get_turf(loc)
	if(ismob(loc))
		var/mob/M = loc
		to_chat(M, span_danger("\The [src] explodes!"))
	if(T)
		T.hotspot_expose(700,125)
		explosion(T, -1, -1, 0, 4)
	qdel(src)
	return

/obj/item/taperecorder/verb/record()
	set name = "Start Recording"
	set category = "Object"

	if(usr.incapacitated())
		return
	if(!mytape)
		to_chat(usr, span_notice("There's no tape!"))
		return
	if(mytape.ruined)
		to_chat(usr, span_warning("The tape recorder makes a scratchy noise."))
		return
	if(recording)
		to_chat(usr, span_notice("You're already recording!"))
		return
	if(playing)
		to_chat(usr, span_notice("You can't record when playing!"))
		return
	if(emagged)
		to_chat(usr, span_warning("The tape recorder makes a scratchy noise."))
		return
	if(mytape.used_capacity < mytape.max_capacity)
		to_chat(usr, span_notice("Recording started."))
		recording = 1
		update_icon()

		mytape.record_speech("Recording started.")

		//count seconds until full, or recording is stopped
		while(mytape && recording && mytape.used_capacity < mytape.max_capacity)
			sleep(10)
			mytape.used_capacity++
			if(mytape.used_capacity >= mytape.max_capacity)
				if(ismob(loc))
					var/mob/M = loc
					to_chat(M, span_notice("The tape is full."))
				stop_recording()


		update_icon()
		return
	else
		to_chat(usr, span_notice("The tape is full."))


/obj/item/taperecorder/proc/stop_recording()
	//Sanity checks skipped, should not be called unless actually recording
	recording = 0
	update_icon()
	mytape.record_speech("Recording stopped.")
	if(ismob(loc))
		var/mob/M = loc
		to_chat(M, span_notice("Recording stopped."))


/obj/item/taperecorder/verb/stop()
	set name = "Stop"
	set category = "Object"

	if(usr.incapacitated())
		return
	if(recording)
		stop_recording()
		return
	else if(playing)
		playing = 0
		update_icon()
		to_chat(usr, span_notice("Playback stopped."))
		return
	else
		to_chat(usr, span_notice("Stop what?"))


/obj/item/taperecorder/verb/wipe_tape()
	set name = "Wipe Tape"
	set category = "Object"

	if(usr.incapacitated())
		return
	if(emagged)
		to_chat(usr, span_warning("The tape recorder makes a scratchy noise."))
		return
	if(mytape.ruined)
		to_chat(usr, span_warning("The tape recorder makes a scratchy noise."))
		return
	if(recording || playing)
		to_chat(usr, span_notice("You can't wipe the tape while playing or recording!"))
		return
	else
		if(mytape.storedinfo)	mytape.storedinfo.Cut()
		if(mytape.timestamp)	mytape.timestamp.Cut()
		mytape.used_capacity = 0
		to_chat(usr, span_notice("You wipe the tape."))
		return


/obj/item/taperecorder/verb/playback_memory()
	set name = "Playback Tape"
	set category = "Object"

	if(usr.incapacitated())
		return
	if(!mytape)
		to_chat(usr, span_notice("There's no tape!"))
		return
	if(mytape.ruined)
		to_chat(usr, span_warning("The tape recorder makes a scratchy noise."))
		return
	if(recording)
		to_chat(usr, span_notice("You can't playback when recording!"))
		return
	if(playing)
		to_chat(usr, span_notice("You're already playing!"))
		return
	playing = 1
	update_icon()
	to_chat(usr, span_notice("Playing started."))
	for(var/i=1 , i < mytape.max_capacity , i++)
		if(!mytape || !playing)
			break
		if(mytape.storedinfo.len < i)
			break

		var/turf/T = get_turf(src)
		var/playedmessage = mytape.storedinfo[i]
		if (findtextEx(playedmessage,"*",1,2)) //remove marker for action sounds
			playedmessage = copytext(playedmessage,2)
		T.audible_message(span_maroon(span_bold("Tape Recorder") + ": [playedmessage]"), runemessage = playedmessage)

		if(mytape.storedinfo.len < i+1)
			playsleepseconds = 1
			sleep(10)
			T = get_turf(src)
			T.audible_message(span_maroon(span_bold("Tape Recorder") + ": End of recording."), runemessage = "click")
			break
		else
			playsleepseconds = mytape.timestamp[i+1] - mytape.timestamp[i]

		if(playsleepseconds > 14)
			sleep(10)
			T = get_turf(src)
			T.audible_message(span_maroon(span_bold("Tape Recorder") + ": Skipping [playsleepseconds] seconds of silence"), runemessage = "tape winding")
			playsleepseconds = 1
		sleep(10 * playsleepseconds)


	playing = 0
	update_icon()

	if(emagged)
		var/turf/T = get_turf(src)
		T.audible_message(span_maroon(span_bold("Tape Recorder") + ": This tape recorder will self-destruct in... Five."), runemessage = "beep beep")
		sleep(10)
		T = get_turf(src)
		T.audible_message(span_maroon(span_bold("Tape Recorder") + ": Four."))
		sleep(10)
		T = get_turf(src)
		T.audible_message(span_maroon(span_bold("Tape Recorder") + ": Three."))
		sleep(10)
		T = get_turf(src)
		T.audible_message(span_maroon(span_bold("Tape Recorder") + ": Two."))
		sleep(10)
		T = get_turf(src)
		T.audible_message(span_maroon(span_bold("Tape Recorder") + ": One."))
		sleep(10)
		explode()


/obj/item/taperecorder/verb/print_transcript()
	set name = "Print Transcript"
	set category = "Object"

	if(usr.incapacitated())
		return
	if(!mytape)
		to_chat(usr, span_notice("There's no tape!"))
		return
	if(mytape.ruined)
		to_chat(usr, span_warning("The tape recorder makes a scratchy noise."))
		return
	if(emagged)
		to_chat(usr, span_warning("The tape recorder makes a scratchy noise."))
		return
	if(!canprint)
		to_chat(usr, span_notice("The recorder can't print that fast!"))
		return
	if(recording || playing)
		to_chat(usr, span_notice("You can't print the transcript while playing or recording!"))
		return

	to_chat(usr, span_notice("Transcript printed."))
	var/obj/item/paper/P = new /obj/item/paper(get_turf(src))
	var/t1 = span_bold("Transcript:") + "<BR><BR>"
	for(var/i=1,mytape.storedinfo.len >= i,i++)
		var/printedmessage = mytape.storedinfo[i]
		if (findtextEx(printedmessage,"*",1,2)) //replace action sounds
			printedmessage = "\[[time2text(mytape.timestamp[i]*10,"mm:ss")]\] (Unrecognized sound)"
		t1 += "[printedmessage]<BR>"
	P.info = t1
	P.name = "Transcript"
	canprint = 0
	sleep(300)
	canprint = 1


/obj/item/taperecorder/attack_self(mob/user)
	if(recording || playing)
		stop()
	else
		record()


/obj/item/taperecorder/update_icon()
	if(!mytape)
		icon_state = "taperecorder_empty"
	else if(recording)
		icon_state = "taperecorder_recording"
	else if(playing)
		icon_state = "taperecorder_playing"
	else
		icon_state = "taperecorder_idle"



/obj/item/rectape
	name = "tape"
	desc = "A magnetic tape that can hold up to ten minutes of content."
	icon = 'icons/obj/device.dmi'
	icon_state = "tape_white"
	item_state = "analyzer"
	w_class = ITEMSIZE_TINY
	matter = list(MAT_STEEL=20, MAT_GLASS=5)
	force = 1
	throwforce = 0
	var/max_capacity = 1800
	var/used_capacity = 0
	var/list/storedinfo = new/list()
	var/list/timestamp = new/list()
	var/ruined = 0


/obj/item/rectape/update_icon()
	cut_overlays()
	if(ruined)
		add_overlay("ribbonoverlay")


/obj/item/rectape/fire_act()
	ruin()

/obj/item/rectape/attack_self(mob/user)
	if(!ruined)
		to_chat(user, span_notice("You pull out all the tape!"))
		ruin()


/obj/item/rectape/proc/ruin()
	ruined = 1
	update_icon()


/obj/item/rectape/proc/fix()
	ruined = 0
	update_icon()


/obj/item/rectape/proc/record_speech(text)
	timestamp += used_capacity
	storedinfo += "\[[time2text(used_capacity*10,"mm:ss")]\] [text]"


//shows up on the printed transcript as (Unrecognized sound)
/obj/item/rectape/proc/record_noise(text)
	timestamp += used_capacity
	storedinfo += "*\[[time2text(used_capacity*10,"mm:ss")]\] [text]"


/obj/item/rectape/attackby(obj/item/I, mob/user, params)
	if(ruined && I.has_tool_quality(TOOL_SCREWDRIVER))
		to_chat(user, span_notice("You start winding the tape back in..."))
		playsound(src, I.usesound, 50, 1)
		if(do_after(user, 120 * I.toolspeed, target = src))
			to_chat(user, span_notice("You wound the tape back in."))
			fix()
		return
	else if(istype(I, /obj/item/pen))
		if(loc == user && !user.incapacitated())
			var/new_name = tgui_input_text(user, "What would you like to label the tape?", "Tape labeling")
			if(isnull(new_name)) return
			new_name = sanitizeSafe(new_name)
			if(new_name)
				name = "tape - '[new_name]'"
				to_chat(user, span_notice("You label the tape '[new_name]'."))
			else
				name = "tape"
				to_chat(user, span_notice("You scratch off the label."))
		return
	..()


//Random colour tapes
/obj/item/rectape/random/Initialize(mapload)
	. = ..()
	icon_state = "tape_[pick("white", "blue", "red", "yellow", "purple")]"
