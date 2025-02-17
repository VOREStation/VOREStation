
/client/verb/who_advanced()
	set name = "Advanced Who"
	set category = "OOC.Resources"

	var/msg = span_bold("Current Players:") + "\n"

	var/list/Lines = list()

	if(check_rights_for(src, R_ADMIN|R_SERVER|R_MOD))
		for(var/client/C in GLOB.clients)
			var/entry = "<tr><td>[C.key]"
			if(C.holder && C.holder.fakekey)
				entry += " " + span_italics("(as [C.holder.fakekey])")

			entry += "</td><td>"

			if(C.mob.real_name)
				switch(C.mob.stat)
					if(UNCONSCIOUS)
						entry += span_darkgray(span_bold("Unconscious")) // these are literally all spans so I can apply .inverted to them because black on dark grey isn't legible

					if(DEAD)
						if(isobserver(C.mob))
							var/mob/observer/dead/O = C.mob
							if(O.started_as_observer)
								entry += span_gray("Observing")
							else
								entry += span_black(span_bold("Died"))

					else
						entry += span_green("Playing")

				entry += " as [C.mob.real_name]"

			else if(isnewplayer(C.mob))
				entry += span_blue(span_bold("In lobby"))

			entry += "</td><td>"

			var/age
			if(isnum(C.player_age))
				age = C.player_age
			else
				age = 0

			if(age <= 1)
				age = span_red(span_bold("[age]"))
			else if(age < 10)
				age = span_orange(span_bold("[age]"))

			entry += "Age: [age]"
			entry += "</td><td>"

			if(is_special_character(C.mob))
				if(C.mob?.mind?.special_role)
					entry += span_red(span_bold("[C.mob.mind.special_role]"))
				else
					entry += span_red(span_bold("Antagonist"))

			entry += "</td><td>"

			if(C.is_afk())
				var/seconds = C.last_activity_seconds()
				entry += " (AFK - "
				entry += "[round(seconds / 60)] minutes, "
				entry += "[seconds % 60] seconds)"

			entry += "</td><td>"
			entry += " (<A href='byond://?_src_=holder;[HrefToken()];adminmoreinfo=\ref[C.mob]'>?</A>)"
			entry += "</td></tr>"

			Lines += entry
	else
		for(var/client/C in GLOB.clients)
			var/entry = "\t"
			if(C.holder && C.holder.fakekey)
				entry += "[C.holder.fakekey]"
			else
				entry += "[C.key]"
			var/mob/observer/dead/O = C.mob
			if(isobserver(O))
				entry += " - " + span_gray("Observing") + "<br>"
			else if(isnewplayer(O))
				entry += " - " + span_blue("In Lobby") + "<br>"
			else
				entry += " - "+ span_green("Playing") + "<br>"

			Lines += entry

	msg += "<table>"
	for(var/line in sortList(Lines))
		msg += "[line]"
	msg += "</table>"
	msg += span_bold("Total Players: [length(Lines)]")
	msg = span_filter_notice(msg)
	to_chat(src, msg)
