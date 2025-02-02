/**
 * Returns the HTML for the status UI for this song datum.
 */
/datum/song/proc/instrument_status_ui()
	. = list()
	. += "<div class='statusDisplay'>"
	. += span_bold("<a href='byond://?src=[REF(src)];switchinstrument=1'>Current instrument</a>:") + " "
	if(!using_instrument)
		. += span_danger("No instrument loaded!") + "<br>"
	else
		. += "[using_instrument.name]<br>"
	. += "Playback Settings:<br>"
	if(can_noteshift)
		. += "<a href='byond://?src=[REF(src)];setnoteshift=1'>Note Shift/Note Transpose</a>: [note_shift] keys / [round(note_shift / 12, 0.01)] octaves<br>"
	var/smt
	var/modetext = ""
	switch(sustain_mode)
		if(SUSTAIN_LINEAR)
			smt = "Linear"
			modetext = "<a href='byond://?src=[REF(src)];setlinearfalloff=1'>Linear Sustain Duration</a>: [sustain_linear_duration / 10] seconds<br>"
		if(SUSTAIN_EXPONENTIAL)
			smt = "Exponential"
			modetext = "<a href='byond://?src=[REF(src)];setexpfalloff=1'>Exponential Falloff Factor</a>: [sustain_exponential_dropoff]% per decisecond<br>"
	. += "<a href='byond://?src=[REF(src)];setsustainmode=1'>Sustain Mode</a>: [smt]<br>"
	. += modetext
	. += using_instrument?.ready()? ("Status: " + span_green("Ready") + "<br>") : ("Status: " + span_red("!Instrument Definition Error!") + "<br>")
	. += "Instrument Type: [legacy? "Legacy" : "Synthesized"]<br>"
	. += "<a href='byond://?src=[REF(src)];setvolume=1'>Volume</a>: [volume]<br>"
	. += "<a href='byond://?src=[REF(src)];setdropoffvolume=1'>Volume Dropoff Threshold</a>: [sustain_dropoff_volume]<br>"
	. += "<a href='byond://?src=[REF(src)];togglesustainhold=1'>Sustain indefinitely last held note</a>: [full_sustain_held_note? "Enabled" : "Disabled"].<br>"
	. += "</div>"

/datum/song/proc/interact(mob/user)
	var/list/dat = list()

	dat += instrument_status_ui()

	if(lines.len > 0)
		dat += "<H3>Playback</H3>"
		if(!playing)
			dat += "<A href='byond://?src=[REF(src)];play=1'>Play</A> " + span_linkOn("Stop") + "<BR><BR>"
			dat += "Repeat Song: "
			dat += repeat > 0 ? "<A href='byond://?src=[REF(src)];repeat=-10'>-</A><A href='byond://?src=[REF(src)];repeat=-1'>-</A>" : (span_linkOff("-") + span_linkOff("-"))
			dat += " [repeat] times "
			dat += repeat < max_repeats ? "<A href='byond://?src=[REF(src)];repeat=1'>+</A><A href='byond://?src=[REF(src)];repeat=10'>+</A>" : (span_linkOff("+") + span_linkOff("+"))
			dat += "<BR>"
		else
			dat += span_linkOn("Play") + " <A href='byond://?src=[REF(src)];stop=1'>Stop</A><BR>"
			dat += "Repeats left: " + span_bold("[repeat]") + "<BR>"
	if(!editing)
		dat += "<BR>" + span_bold("<A href='byond://?src=[REF(src)];edit=2'>Show Editor</A>") + "<BR>"
	else
		dat += "<H3>Editing</H3>"
		dat += span_bold("<A href='byond://?src=[REF(src)];edit=1'>Hide Editor</A>")
		dat += " <A href='byond://?src=[REF(src)];newsong=1'>Start a New Song</A>"
		dat += " <A href='byond://?src=[REF(src)];import=1'>Import a Song</A><BR><BR>"
		var/bpm = round(600 / tempo)
		dat += "Tempo: <A href='byond://?src=[REF(src)];tempo=[world.tick_lag]'>-</A> [bpm] BPM <A href='byond://?src=[REF(src)];tempo=-[world.tick_lag]'>+</A><BR><BR>"
		var/linecount = 0
		for(var/line in lines)
			linecount += 1
			dat += "Line [linecount]: <A href='byond://?src=[REF(src)];modifyline=[linecount]'>Edit</A> <A href='byond://?src=[REF(src)];deleteline=[linecount]'>X</A> [line]<BR>"
		dat += "<A href='byond://?src=[REF(src)];newline=1'>Add Line</A><BR><BR>"
		if(help)
			dat += span_bold("<A href='byond://?src=[REF(src)];help=1'>Hide Help</A>") + "<BR>"
			dat += {"
					Lines are a series of chords, separated by commas (,), each with notes separated by hyphens (-).<br>
					Every note in a chord will play together, with chord timed by the tempo.<br>
					<br>
					Notes are played by the names of the note, and optionally, the accidental, and/or the octave number.<br>
					By default, every note is natural and in octave 3. Defining otherwise is remembered for each note.<br>
					Example: <i>C,D,E,F,G,A,B</i> will play a C major scale.<br>
					After a note has an accidental placed, it will be remembered: <i>C,C4,C,C3</i> is <i>C3,C4,C4,C3</i><br>
					Chords can be played simply by separating each note with a hyphen: <i>A-C#,Cn-E,E-G#,Gn-B</i><br>
					A pause may be denoted by an empty chord: <i>C,E,,C,G</i><br>
					To make a chord be a different time, end it with /x, where the chord length will be length<br>
					defined by tempo / x: <i>C,G/2,E/4</i><br>
					Combined, an example is: <i>E-E4/4,F#/2,G#/8,B/8,E3-E4/4</i>
					<br>
					Lines may be up to [MUSIC_MAXLINECHARS] characters.<br>
					A song may only contain up to [MUSIC_MAXLINES] lines.<br>
					"}
		else
			dat += span_bold("<A href='byond://?src=[REF(src)];help=2'>Show Help</A>") + "<BR>"

	var/datum/browser/popup = new(user, "instrument", parent?.name || "instrument", 700, 500)
	popup.set_content(dat.Join(""))
	popup.open()

/**
 * Parses a song the user has input into lines and stores them.
 */
/datum/song/proc/ParseSong(text)
	set waitfor = FALSE
	//split into lines
	lines = splittext(text, "\n")
	if(lines.len)
		var/bpm_string = "BPM: "
		if(findtext(lines[1], bpm_string, 1, length(bpm_string) + 1))
			var/divisor = text2num(copytext(lines[1], length(bpm_string) + 1)) || 120 // default
			tempo = sanitize_tempo(600 / round(divisor, 1))
			lines.Cut(1, 2)
		else
			tempo = sanitize_tempo(5) // default 120 BPM
		if(lines.len > MUSIC_MAXLINES)
			to_chat(usr, "Too many lines!")
			lines.Cut(MUSIC_MAXLINES + 1)
		var/linenum = 1
		for(var/l in lines)
			if(length_char(l) > MUSIC_MAXLINECHARS)
				to_chat(usr, "Line [linenum] too long!")
				lines.Remove(l)
			else
				linenum++
		updateDialog(usr) // make sure updates when complete

/datum/song/Topic(href, href_list)
	if(!parent.CanUseTopic(usr))
		usr << browse(null, "window=instrument")
		usr.unset_machine()
		return

	parent.add_fingerprint(usr)

	if(href_list["newsong"])
		lines = new()
		tempo = sanitize_tempo(5) // default 120 BPM
		name = ""

	else if(href_list["import"])
		var/t = ""
		do
			t = html_encode(tgui_input_text(usr, "Please paste the entire song, formatted:", text("[]", name), t, multiline = TRUE, prevent_enter = TRUE))
			if(!in_range(parent, usr))
				return

			if(length_char(t) >= MUSIC_MAXLINES * MUSIC_MAXLINECHARS)
				var/cont = tgui_alert(usr, "Your message is too long! Would you like to continue editing it?", "Too long!", list("Yes", "No"))
				if(cont != "Yes")
					break
		while(length_char(t) > MUSIC_MAXLINES * MUSIC_MAXLINECHARS)
		ParseSong(t)

	else if(href_list["help"])
		help = text2num(href_list["help"]) - 1

	else if(href_list["edit"])
		editing = text2num(href_list["edit"]) - 1

	if(href_list["repeat"]) //Changing this from a toggle to a number of repeats to avoid infinite loops.
		if(playing)
			return //So that people cant keep adding to repeat. If the do it intentionally, it could result in the server crashing.
		repeat += round(text2num(href_list["repeat"]))
		if(repeat < 0)
			repeat = 0
		if(repeat > max_repeats)
			repeat = max_repeats

	else if(href_list["tempo"])
		tempo = sanitize_tempo(tempo + text2num(href_list["tempo"]))

	else if(href_list["play"])
		INVOKE_ASYNC(src, PROC_REF(start_playing), usr)

	else if(href_list["newline"])
		var/newline = html_encode(tgui_input_text(usr, "Enter your line: ", parent.name))
		if(!newline || !in_range(parent, usr))
			return
		if(lines.len > MUSIC_MAXLINES)
			return
		if(length(newline) > MUSIC_MAXLINECHARS)
			newline = copytext(newline, 1, MUSIC_MAXLINECHARS)
		lines.Add(newline)

	else if(href_list["deleteline"])
		var/num = round(text2num(href_list["deleteline"]))
		if(num > lines.len || num < 1)
			return
		lines.Cut(num, num+1)

	else if(href_list["modifyline"])
		var/num = round(text2num(href_list["modifyline"]),1)
		var/content = tgui_input_text(usr, "Enter your line: ", parent.name, lines[num], MUSIC_MAXLINECHARS, encode=TRUE)
		if(!content || !in_range(parent, usr))
			return
		if(num > lines.len || num < 1)
			return
		lines[num] = content

	else if(href_list["stop"])
		stop_playing()

	else if(href_list["setlinearfalloff"])
		var/amount = tgui_input_number(usr, "Set linear sustain duration in seconds", "Linear Sustain Duration", round_value=FALSE)
		if(!isnull(amount))
			set_linear_falloff_duration(round(amount * 10, world.tick_lag))

	else if(href_list["setexpfalloff"])
		var/amount = tgui_input_number(usr, "Set exponential sustain factor", "Exponential sustain factor", round_value=FALSE)
		if(!isnull(amount))
			set_exponential_drop_rate(round(amount, 0.00001))

	else if(href_list["setvolume"])
		var/amount = tgui_input_number(usr, "Set volume", "Volume")
		if(!isnull(amount))
			set_volume(round(amount, 1))

	else if(href_list["setdropoffvolume"])
		var/amount = tgui_input_number(usr, "Set dropoff threshold", "Dropoff Threshold Volume", round_value=FALSE)
		if(!isnull(amount))
			set_dropoff_volume(round(amount, 0.01))

	else if(href_list["switchinstrument"])
		if(!length(allowed_instrument_ids))
			return
		else if(length(allowed_instrument_ids) == 1)
			set_instrument(allowed_instrument_ids[1])
			return
		var/list/categories = list()
		for(var/i in allowed_instrument_ids)
			var/datum/instrument/I = SSinstruments.get_instrument(i)
			if(I)
				LAZYSET(categories[I.category || "ERROR CATEGORY"], I.name, I.id)
		var/cat = tgui_input_list(usr, "Select Category", "Instrument Category", categories)
		if(!cat)
			return
		var/list/instruments = categories[cat]
		var/choice = tgui_input_list(usr, "Select Instrument", "Instrument Selection", instruments)
		if(!choice)
			return
		choice = instruments[choice] //get id
		if(choice)
			set_instrument(choice)

	else if(href_list["setnoteshift"])
		var/amount = tgui_input_number(usr, "Set note shift", "Note Shift", null, note_shift_max, note_shift_min)
		if(!isnull(amount))
			note_shift = clamp(amount, note_shift_min, note_shift_max)

	else if(href_list["setsustainmode"])
		var/choice = tgui_input_list(usr, "Choose a sustain mode", "Sustain Mode", list("Linear", "Exponential"))
		switch(choice)
			if("Linear")
				sustain_mode = SUSTAIN_LINEAR
			if("Exponential")
				sustain_mode = SUSTAIN_EXPONENTIAL

	else if(href_list["togglesustainhold"])
		full_sustain_held_note = !full_sustain_held_note

	updateDialog()
