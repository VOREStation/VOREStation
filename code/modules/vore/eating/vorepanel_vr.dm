//
// Vore management panel for players
//

/mob/living/proc/insidePanel()
	set name = "Vore Panel"
	set category = "Vore"

	var/datum/vore_look/picker_holder = new()
	picker_holder.loop = picker_holder
	picker_holder.selected = vore_organs[vore_selected]

	var/dat = picker_holder.gen_ui(src)

	picker_holder.popup = new(src, "insidePanel","Inside!", 400, 600, picker_holder)
	picker_holder.popup.set_content(dat)
	picker_holder.popup.open()

//
// Callback Handler for the Inside form
//
/datum/vore_look
	var/datum/belly/selected
	var/datum/browser/popup
	var/loop = null;  // Magic self-reference to stop the handler from being GC'd before user takes action.

/datum/vore_look/Topic(href,href_list[])
	if (vp_interact(href, href_list))
		popup.set_content(gen_ui(usr))
		usr << output(popup.get_content(), "insidePanel.browser")

/datum/vore_look/proc/gen_ui(var/mob/living/user)
	var/dat

	if (is_vore_predator(user.loc))
		var/mob/living/eater = user.loc
		var/datum/belly/inside_belly

		//This big block here figures out where the prey is
		inside_belly = check_belly(user)

		//Don't display this part if we couldn't find the belly since could be held in hand.
		if(inside_belly)
			dat += "<font color = 'green'>You are currently [user.absorbed ? "absorbed into " : "inside "]</font> <font color = 'yellow'>[eater]'s</font> <font color = 'red'>[inside_belly]</font>!<br><br>"

			if(inside_belly.inside_flavor)
				dat += "[inside_belly.inside_flavor]<br><br>"

			if (inside_belly.internal_contents.len > 1)
				dat += "You can see the following around you:<br>"
				for (var/atom/movable/O in inside_belly.internal_contents)
					if(istype(O,/mob/living))
						var/mob/living/M = O
						//That's just you
						if(M == user)
							continue

						//That's an absorbed person you're checking
						if(M.absorbed)
							if(user.absorbed)
								dat += "<a href='?src=\ref[src];outsidepick=\ref[O];outsidebelly=\ref[inside_belly]'><span style='color:purple;'>[O]</span></a>"
								continue
							else
								continue

					//Anything else
					dat += "<a href='?src=\ref[src];outsidepick=\ref[O];outsidebelly=\ref[inside_belly]'>[O]&#8203;</a>"

					//Zero-width space, for wrapping
					dat += "&#8203;"
	else
		dat += "You aren't inside anyone."

	dat += "<HR>"

	dat += "<ol style='list-style: none; padding: 0; overflow: auto;'>"
	for(var/K in user.vore_organs) //Fuggin can't iterate over values
		var/datum/belly/B = user.vore_organs[K]
		if(B == selected)
			dat += "<li style='float: left'><a href='?src=\ref[src];bellypick=\ref[B]'><b>[B.name]</b>"
		else
			dat += "<li style='float: left'><a href='?src=\ref[src];bellypick=\ref[B]'>[B.name]"

		var/spanstyle
		switch(B.digest_mode)
			if(DM_HOLD)
				spanstyle = ""
			if(DM_DIGEST)
				spanstyle = "color:red;"
			if(DM_HEAL)
				spanstyle = "color:green;"
			if(DM_ABSORB)
				spanstyle = "color:purple;"
			if(DM_DRAIN)
				spanstyle = "color:purple;"
			if(DM_TRANSFORM_MALE)
				spanstyle = "color:purple;"
			if(DM_TRANSFORM_FEMALE)
				spanstyle = "color:purple;"
			if(DM_TRANSFORM_KEEP_GENDER)
				spanstyle = "color:purple;"
			if(DM_TRANSFORM_CHANGE_SPECIES)
				spanstyle = "color:purple;"
			if(DM_TRANSFORM_CHANGE_SPECIES_EGG)
				spanstyle = "color:purple;"
			if(DM_TRANSFORM_KEEP_GENDER_EGG)
				spanstyle = "color:purple;"
			if(DM_TRANSFORM_MALE_EGG)
				spanstyle = "color:purple;"
			if(DM_TRANSFORM_FEMALE_EGG)
				spanstyle = "color:purple;"
			if(DM_EGG)
				spanstyle = "color:purple;"

		dat += "<span style='[spanstyle]'> ([B.internal_contents.len])</span></a></li>"

	if(user.vore_organs.len < 10)
		dat += "<li style='float: left'><a href='?src=\ref[src];newbelly=1'>New+</a></li>"
	dat += "</ol>"
	dat += "<HR>"

	// Selected Belly (contents, configuration)
	if(!selected)
		dat += "No belly selected. Click one to select it."
	else
		if(selected.internal_contents.len > 0)
			dat += "<b>Contents:</b> "
			for(var/O in selected.internal_contents)

				//Mobs can be absorbed, so treat them separately from everything else
				if(istype(O,/mob/living))
					var/mob/living/M = O

					//Absorbed gets special color OOoOOOOoooo
					if(M.absorbed)
						dat += "<a href='?src=\ref[src];insidepick=\ref[O]'><span style='color:purple;'>[O]</span></a>"
						continue

				//Anything else
				dat += "<a href='?src=\ref[src];insidepick=\ref[O]'>[O]</a>"

				//Zero-width space, for wrapping
				dat += "&#8203;"

			//If there's more than one thing, add an [All] button
			if(selected.internal_contents.len > 1)
				dat += "<a href='?src=\ref[src];insidepick=1;pickall=1'>\[All\]</a>"

			dat += "<HR>"

		//Belly Name Button
		dat += "<a href='?src=\ref[src];b_name=\ref[selected]'>Name:</a>"
		dat += " '[selected.name]'"

		//Digest Mode Button
		dat += "<br><a href='?src=\ref[src];b_mode=\ref[selected]'>Belly Mode:</a>"
		dat += " [selected.digest_mode]"

		//Belly verb
		dat += "<br><a href='?src=\ref[src];b_verb=\ref[selected]'>Vore Verb:</a>"
		dat += " '[selected.vore_verb]'"

		//Inside flavortext
		dat += "<br><a href='?src=\ref[src];b_desc=\ref[selected]'>Flavor Text:</a>"
		dat += " '[selected.inside_flavor]'"

		//Belly sound
		dat += "<br><a href='?src=\ref[src];b_sound=\ref[selected]'>Set Vore Sound</a>"
		dat += "<a href='?src=\ref[src];b_soundtest=\ref[selected]'>Test</a>"

		//Belly messages
		dat += "<br><a href='?src=\ref[src];b_msgs=\ref[selected]'>Belly Messages</a>"

		//Belly escapability
		dat += "<br><a href='?src=\ref[src];b_escapable=\ref[selected]'>Set Belly Interactions (below)</a>"

		dat += "<br><a href='?src=\ref[src];b_escapechance=\ref[selected]'>Set Belly Escape Chance</a>"

		dat += "<br><a href='?src=\ref[src];b_transferchance=\ref[selected]'>Set Belly Transfer Chance</a>"

		dat += "<br><a href='?src=\ref[src];b_transferlocation=\ref[selected]'>Set Belly Transfer Location</a>"
		dat += " [selected.transferlocation]"

		dat += "<br><a href='?src=\ref[src];b_absorbchance=\ref[selected]'>Set Belly Absorb Chance</a>"

		dat += "<br><a href='?src=\ref[src];b_digestchance=\ref[selected]'>Set Belly Digest Chance</a>"

		dat += "<br><a href='?src=\ref[src];b_escapetime=\ref[selected]'>Set Belly Escape Time</a>"

		//Delete button
		dat += "<br><a style='background:#990000;' href='?src=\ref[src];b_del=\ref[selected]'>Delete Belly</a>"

	dat += "<HR>"

	//Under the last HR, save and stuff.
	dat += "<a href='?src=\ref[src];saveprefs=1'>Save Prefs</a>"
	dat += "<a href='?src=\ref[src];refresh=1'>Refresh</a>"

	switch(user.digestable)
		if(1)
			dat += "<a href='?src=\ref[src];toggledg=1'>Toggle Digestable</a>"
		if(0)
			dat += "<a href='?src=\ref[src];toggledg=1'><span style='color:green;'>Toggle Digestable</span></a>"

	//Returns the dat html to the vore_look
	return dat

/datum/vore_look/proc/vp_interact(href, href_list)
	var/mob/living/user = usr
	for(var/H in href_list)

	if(href_list["close"])
		del(src)  // Cleanup
		return

	if(href_list["outsidepick"])
		var/tgt = locate(href_list["outsidepick"])
		var/datum/belly/OB = locate(href_list["outsidebelly"])
		var/intent = "Examine"

		if(istype(tgt,/mob/living))
			var/mob/living/M = tgt
			intent = alert("What do you want to do to them?","Query","Examine","Help Out","Devour")
			switch(intent)
				if("Examine") //Examine a mob inside another mob
					M.examine(user)

				if("Help Out") //Help the inside-mob out
					if(user.stat || user.absorbed || M.absorbed)
						user << "<span class='warning'>You can't do that in your state!</span>"
						return 1

					user << "<font color='green'>You begin to push [M] to freedom!</font>"
					M << "[usr] begins to push you to freedom!"
					M.loc << "<span class='warning'>Someone is trying to escape from inside you!</span>"
					sleep(50)
					if(prob(33))
						OB.release_specific_contents(M)
						usr << "<font color='green'>You manage to help [M] to safety!</font>"
						M << "<font color='green'>[user] pushes you free!</font>"
						M.loc << "<span class='alert'>[M] forces free of the confines of your body!</span>"
					else
						user << "<span class='alert'>[M] slips back down inside despite your efforts.</span>"
						M << "<span class='alert'> Even with [user]'s help, you slip back inside again.</span>"
						M.loc << "<font color='green'>Your body efficiently shoves [M] back where they belong.</font>"

				if("Devour") //Eat the inside mob
					if(user.absorbed || user.stat)
						user << "<span class='warning'>You can't do that in your state!</span>"
						return 1

					if(!user.vore_selected)
						user << "<span class='warning'>Pick a belly on yourself first!</span>"
						return 1

					var/datum/belly/TB = user.vore_organs[user.vore_selected]
					user << "<span class='warning'>You begin to [lowertext(TB.vore_verb)] [M] into your [lowertext(TB.name)]!</span>"
					M << "<span class='warning'>[user] begins to [lowertext(TB.vore_verb)] you into their [lowertext(TB.name)]!</span>"
					M.loc << "<span class='warning'>Someone inside you is eating someone else!</span>"

					sleep(TB.nonhuman_prey_swallow_time)
					if((user in OB.internal_contents) && (M in OB.internal_contents))
						user << "<span class='warning'>You manage to [lowertext(TB.vore_verb)] [M] into your [lowertext(TB.name)]!</span>"
						M << "<span class='warning'>[user] manages to [lowertext(TB.vore_verb)] you into their [lowertext(TB.name)]!</span>"
						M.loc << "<span class='warning'>Someone inside you has eaten someone else!</span>"
						M.loc = user
						TB.nom_mob(M)
						OB.internal_contents -= M

		else if(istype(tgt,/obj/item))
			var/obj/item/T = tgt
			intent = alert("What do you want to do to that?","Query","Examine","Use Hand")
			switch(intent)
				if("Examine")
					T.examine(user)

				if("Use Hand")
					if(user.stat)
						user << "<span class='warning'>You can't do that in your state!</span>"
						return 1

					user.ClickOn(T)
					sleep(5) //Seems to exit too fast for the panel to update

	if(href_list["insidepick"])
		var/intent

		//Handle the [All] choice. Ugh inelegant. Someone make this pretty.
		if(href_list["pickall"])
			intent = alert("Eject all, Move all?","Query","Eject all","Cancel","Move all")
			switch(intent)
				if("Cancel")
					return 1

				if("Eject all")
					if(user.stat)
						user << "<span class='warning'>You can't do that in your state!</span>"
						return 1

					selected.release_all_contents()
					playsound(user, 'sound/effects/splat.ogg', 50, 1)

				if("Move all")
					if(user.stat)
						user << "<span class='warning'>You can't do that in your state!</span>"
						return 1

					var/choice = input("Move all where?","Select Belly") in user.vore_organs + "Cancel - Don't Move"

					if(choice == "Cancel - Don't Move")
						return 1
					else
						var/datum/belly/B = user.vore_organs[choice]
						for(var/atom/movable/tgt in selected.internal_contents)
							if (!(tgt in selected.internal_contents))
								continue
							selected.internal_contents -= tgt
							B.internal_contents += tgt

							tgt << "<span class='warning'>You're squished from [user]'s [selected] to their [B]!</span>"

						for(var/mob/hearer in range(1,user))
							hearer << sound('sound/vore/squish2.ogg',volume=80)
			return 1


		var/atom/movable/tgt = locate(href_list["insidepick"])
		intent = "Examine"
		intent = alert("Examine, Eject, Move? Examine if you want to leave this box.","Query","Examine","Eject","Move")
		switch(intent)
			if("Examine")
				tgt.examine(user)

			if("Eject")
				if(user.stat)
					user << "<span class='warning'>You can't do that in your state!</span>"
					return 1

				selected.release_specific_contents(tgt)
				playsound(user, 'sound/effects/splat.ogg', 50, 1)

			if("Move")
				if(user.stat)
					user << "<span class='warning'>You can't do that in your state!</span>"
					return 1

				var/choice = input("Move [tgt] where?","Select Belly") in user.vore_organs + "Cancel - Don't Move"

				if(choice == "Cancel - Don't Move")
					return 1
				else
					var/datum/belly/B = user.vore_organs[choice]
					if (!(tgt in selected.internal_contents))
						return 0
					selected.internal_contents -= tgt
					B.internal_contents += tgt

					tgt << "<span class='warning'>You're squished from [user]'s [lowertext(selected.name)] to their [lowertext(B.name)]!</span>"
					for(var/mob/hearer in range(1,user))
						hearer << sound('sound/vore/squish2.ogg',volume=80)

	if(href_list["newbelly"])
		if(user.vore_organs.len >= 10)
			return 1

		var/new_name = html_encode(input(usr,"New belly's name:","New Belly") as text|null)

		if(length(new_name) > 12 || length(new_name) < 2)
			usr << "<span class='warning'>Entered belly name is too long.</span>"
			return 0
		if(new_name in user.vore_organs)
			usr << "<span class='warning'>No duplicate belly names, please.</span>"
			return 0

		var/datum/belly/NB = new(user)
		NB.name = new_name
		user.vore_organs[new_name] = NB
		selected = NB

	if(href_list["bellypick"])
		selected = locate(href_list["bellypick"])
		user.vore_selected = selected.name

	if(href_list["b_name"])
		var/new_name = html_encode(input(usr,"Belly's new name:","New Name") as text|null)

		if(length(new_name) > 12 || length(new_name) < 2)
			usr << "<span class='warning'>Entered belly name length invalid (must be longer than 2, shorter than 12).</span>"
			return 0
		if(new_name in user.vore_organs)
			usr << "<span class='warning'>No duplicate belly names, please.</span>"
			return 0

		user.vore_organs[new_name] = selected
		user.vore_organs -= selected.name
		selected.name = new_name

	if(href_list["b_mode"])
		var/list/menu_list = selected.digest_modes
		if(istype(usr,/mob/living/carbon/human))
			menu_list += selected.transform_modes

		if(selected.digest_modes.len == 1) // Don't do anything
			return 1
		if(selected.digest_modes.len == 2) // Just toggle... there's probably a more elegant way to do this...
			var/index = selected.digest_modes.Find(selected.digest_mode)
			switch(index)
				if(1)
					selected.digest_mode = selected.digest_modes[2]
				if(2)
					selected.digest_mode = selected.digest_modes[1]
		else
			selected.digest_mode = input("Choose Mode (currently [selected.digest_mode])") in menu_list

	if(href_list["b_desc"])
		var/new_desc = html_encode(input(usr,"Belly Description (1024 char limit):","New Description",selected.inside_flavor) as message|null)
		new_desc = readd_quotes(new_desc)

		if(length(new_desc) > 1024)
			usr << "<span class='warning'>Entered belly desc too long. 1024 character limit.</span>"
			return 0

		selected.inside_flavor = new_desc

	if(href_list["b_msgs"])
		var/list/messages = list(
			"Digest Message (to prey)",
			"Digest Message (to you)",
			"Struggle Message (outside)",
			"Struggle Message (inside)",
			"Examine Message (when full)",
			"Reset All To Default",
			"Cancel - No Changes"
		)

		alert(user,"Setting abusive or deceptive messages will result in a ban. Consider this your warning. Max 150 characters per message, max 10 messages per topic.","Really, don't.")
		var/choice = input(user,"Select a type to modify. Messages from each topic are pulled at random when needed.","Pick Type") in messages
		var/help = " Press enter twice to separate messages. '%pred' will be replaced with your name. '%prey' will be replaced with the prey's name. '%belly' will be replaced with your belly's name."

		switch(choice)
			if("Digest Message (to prey)")
				var/new_message = input(user,"These are sent to prey when they expire. Write them in 2nd person ('you feel X'). Avoid using %prey in this type."+help,"Digest Message (to prey)",selected.get_messages("dmp")) as message
				if(new_message)
					selected.set_messages(new_message,"dmp")

			if("Digest Message (to you)")
				var/new_message = input(user,"These are sent to you when prey expires in you. Write them in 2nd person ('you feel X'). Avoid using %pred in this type."+help,"Digest Message (to you)",selected.get_messages("dmo")) as message
				if(new_message)
					selected.set_messages(new_message,"dmo")

			if("Struggle Message (outside)")
				var/new_message = input(user,"These are sent to those nearby when prey struggles. Write them in 3rd person ('X's Y bulges')."+help,"Struggle Message (outside)",selected.get_messages("smo")) as message
				if(new_message)
					selected.set_messages(new_message,"smo")

			if("Struggle Message (inside)")
				var/new_message = input(user,"These are sent to prey when they struggle. Write them in 2nd person ('you feel X'). Avoid using %prey in this type."+help,"Struggle Message (inside)",selected.get_messages("smi")) as message
				if(new_message)
					selected.set_messages(new_message,"smi")

			if("Examine Message (when full)")
				var/new_message = input(user,"These are sent to people who examine you when this belly has contents. Write them in 3rd person ('Their %belly is bulging'). Do not use %pred or %prey in this type."+help,"Examine Message (when full)",selected.get_messages("em")) as message
				if(new_message)
					selected.set_messages(new_message,"em")

			if("Reset All To Default")
				var/confirm = alert(user,"This will delete any custom messages. Are you sure?","Confirmation","DELETE","Cancel")
				if(confirm == "DELETE")
					selected.digest_messages_prey = initial(selected.digest_messages_prey)
					selected.digest_messages_owner = initial(selected.digest_messages_owner)
					selected.struggle_messages_outside = initial(selected.struggle_messages_outside)
					selected.struggle_messages_inside = initial(selected.struggle_messages_inside)

			if("Cancel - No Changes")
				return 1

	if(href_list["b_verb"])
		var/new_verb = html_encode(input(usr,"New verb when eating (infinitive tense, e.g. nom or swallow):","New Verb") as text|null)

		if(length(new_verb) > 12 || length(new_verb) < 2)
			usr << "<span class='warning'>Entered verb length invalid (must be longer than 2, shorter than 12).</span>"
			return 0

		selected.vore_verb = new_verb

	if(href_list["b_sound"])
		var/choice = input(user,"Currently set to [selected.vore_sound]","Select Sound") in vore_sounds + "Cancel - No Changes"

		if(choice == "Cancel")
			return 1

		selected.vore_sound = vore_sounds[choice]

	if(href_list["b_escapable"])
		if(selected.escapable == 0) //Possibly escapable and special interactions.
			selected.escapable = 1
			usr << "<span class='warning'>Prey now have special interactions with your [selected.name] depending on your settings.</span>"
		else if(selected.escapable == 1) //Never escapable.
			selected.escapable = 0
			usr << "<span class='warning'>Prey will not be able to have special interactions with your [selected.name].</span>"
		else
			usr << "<span class='warning'>Something went wrong. Your stomach will now not have special interactions. Press the button enable them again.</span>" //If they somehow have a varable that's not 0 or 1
			selected.escapable = 0

	if(href_list["b_escapechance"])
		var/escape_chance_input = input(user, "Choose the (%) chance that prey that attempt to escape will be able to escape.\
			Stomach special interactions must be enabled for this to work.\
			Ranges from -1(disabled) to 100.\n\
			(-1-100)", "Prey Escape Chance") as num|null
		if(escape_chance_input)
			escape_chance_input = round(text2num(escape_chance_input),4)
			selected.escapechance = sanitize_integer(escape_chance_input, 0, 100, selected.escapechance)

	if(href_list["b_absorbchance"])
		var/absorb_chance_input = input(user, "Choose the (%) chance that prey that attempt to escape will be absorbed into your [selected.name].\
			 Stomach special interactions must be enabled for this to work.\
			 Ranges from -1(disabled) to 100.\n\
			(-1-100)", "Prey Absorb Chance") as num|null
		if(absorb_chance_input)
			absorb_chance_input = round(text2num(absorb_chance_input),4)
			selected.absorbchance = sanitize_integer(absorb_chance_input, 0, 100, selected.absorbchance)

	if(href_list["b_digestchance"])
		var/digest_chance_input = input(user, "Choose the (%) chance that prey that attempt to escape will begin to digest inside of your [selected.name].\
			 Stomach special interactions must be enabled for this to work.\
			 Ranges from -1(disabled) to 100.\n\
			(-1-100)", "Prey Digest Chance") as num|null
		if(digest_chance_input)
			digest_chance_input = round(text2num(digest_chance_input),4)
			selected.digestchance = sanitize_integer(digest_chance_input, 0, 100, selected.digestchance)

	if(href_list["b_escapetime"])
		var/escape_time_input = input(user, "Choose the amount of time it will take for prey to be able to escape.\
			 Stomach special interactions must be enabled for this to effect anything, along with the escape chance\
			 Ranges from 10 to 600.(10 = 1 second, 600 = 60 seconds)\n\
			(10-600)", "Prey Escape Time") as num|null
		if(escape_time_input)
			escape_time_input = round(text2num(escape_time_input),4)
			selected.escapetime = sanitize_integer(escape_time_input, 9, 600, selected.escapetime) //Set to 9 to stop rounding problems.

	if(href_list["b_transferchance"])
		var/transfer_chance_input = input(user, "Choose the chance that that prey will be dropped off if they attempt to struggle.\
			 Stomach special interactions must be enabled for this to effect anything, along with a transfer location set\
			 Ranges from -1(disabled) to 100.\n\
			(-1-100)", "Prey Escape Time") as num|null
		if(transfer_chance_input)
			transfer_chance_input = round(text2num(transfer_chance_input),4)
			selected.transferchance = sanitize_integer(transfer_chance_input, 9, 600, selected.transferchance) //Set to 9 to stop rounding problems.

	if(href_list["b_transferlocation"])
		var/choice = input("Where do you want your [selected.name] to lead if prey struggles??","Select Belly") in user.vore_organs + "Cancel - None - Remove"

		if(choice == "Cancel - None - Remove")
			selected.transferlocation = null
			return 1
		else
			selected.transferlocation = user.vore_organs[choice]
			usr << "<span class='warning'>Note: Do not delete your [choice] while this is enabled. This will cause your prey to be unable to escape. If you want to delete your [choice], select Cancel - None - Remove and then delete it.</span>"

	if(href_list["b_soundtest"])
		user << selected.vore_sound

	if(href_list["b_del"])
		if(selected.internal_contents.len)
			usr << "<span class='warning'>Can't delete bellies with contents!</span>"
		else if(selected.immutable)
			usr << "<span class='warning'>This belly is marked as undeletable.</span>"
		else if(user.vore_organs.len == 1)
			usr << "<span class='warning'>You must have at least one belly.</span>"
		else
			var/alert = alert("Are you sure you want to delete [selected]?","Confirmation","Delete","Cancel")
			if(alert == "Delete" && !selected.internal_contents.len)
				user.vore_organs -= selected.name
				user.vore_organs.Remove(selected)
				selected = user.vore_organs[1]
				user.vore_selected = user.vore_organs[1]
				usr << "<span class='warning'>Note: If you had this organ selected as a transfer location, please remove the transfer location by selecting Cancel - None - Remove on this stomach.</span>" //If anyone finds a fix to this bug, please tell me. I, for the life of me, can't find any way to fix it.

	if(href_list["saveprefs"])
		if(!user.save_vore_prefs())
			user << "<span class='warning'>ERROR: Virgo-specific preferences failed to save!</span>"
		else
			user << "<span class='notice'>Virgo-specific preferences saved!</span>"

	if(href_list["toggledg"])
		var/choice = alert(user, "This button is for those who don't like being digested. It can make you undigestable. Don't abuse this button by toggling it back and forth to extend a scene or whatever, or you'll make the admins cry. Digesting you is currently: [user.digestable ? "Allowed" : "Prevented"]", "", "Allow Digestion", "Cancel", "Prevent Digestion")
		switch(choice)
			if("Cancel")
				return 1
			if("Allow Digestion")
				user.digestable = 1
			if("Prevent Digestion")
				user.digestable = 0

		message_admins("[key_name(user)] toggled their digestability to [user.digestable] ([user ? "<a href='?_src_=holder;adminplayerobservecoodjump=1;X=[user.loc.];Y=[user.loc.y];Z=[user.loc.z]'>JMP</a>" : "null"])")

		if(user.client.prefs_vr)
			user.client.prefs_vr.digestable = user.digestable

	//Refresh when interacted with, returning 1 makes vore_look.Topic update
	return 1
