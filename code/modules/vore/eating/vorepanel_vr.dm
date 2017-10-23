//
// Vore management panel for players
//

#define BELLIES_MAX 20
#define BELLIES_NAME_MIN 2
#define BELLIES_NAME_MAX 12
#define BELLIES_DESC_MAX 1024
#define FLAVOR_MAX 40
#define NIF_EXAMINE_MAX 60

/mob/living/proc/insidePanel()
	set name = "Vore Panel"
	set category = "IC"

	var/datum/vore_look/picker_holder = new()
	picker_holder.loop = picker_holder
	picker_holder.selected = vore_organs[vore_selected]

	var/dat = picker_holder.gen_ui(src)

	picker_holder.popup = new(src, "insidePanel","Inside!", 400, 600, picker_holder)
	picker_holder.popup.set_content(dat)
	picker_holder.popup.open()
	src.openpanel = 1

/mob/living/proc/updateVRPanel() //Panel popup update call from belly events.
	if(src.openpanel == 1)
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
	var/show_interacts = 0
	var/datum/browser/popup
	var/loop = null;  // Magic self-reference to stop the handler from being GC'd before user takes action.

/datum/vore_look/Destroy()
	loop = null
	selected = null
	return QDEL_HINT_HARDDEL // TODO - Until I can better analyze how this weird thing works, lets be safe

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
			if(DM_ITEMWEAK)
				spanstyle = "color:red;"
			if(DM_STRIPDIGEST)
				spanstyle = "color:red;"
			if(DM_HEAL)
				spanstyle = "color:green;"
			if(DM_ABSORB)
				spanstyle = "color:purple;"
			if(DM_DRAIN)
				spanstyle = "color:purple;"
			if(DM_SHRINK)
				spanstyle = "color:purple;"
			if(DM_GROW)
				spanstyle = "color:purple;"
			if(DM_SIZE_STEAL)
				spanstyle = "color:purple;"
			if(DM_TRANSFORM_MALE)
				spanstyle = "color:purple;"
			if(DM_TRANSFORM_HAIR_AND_EYES)
				spanstyle = "color:purple;"
			if(DM_TRANSFORM_FEMALE)
				spanstyle = "color:purple;"
			if(DM_TRANSFORM_KEEP_GENDER)
				spanstyle = "color:purple;"
			if(DM_TRANSFORM_CHANGE_SPECIES_AND_TAUR)
				spanstyle = "color:purple;"
			if(DM_TRANSFORM_CHANGE_SPECIES_AND_TAUR_EGG)
				spanstyle = "color:purple;"
			if(DM_TRANSFORM_REPLICA)
				spanstyle = "color:purple;"
			if(DM_TRANSFORM_REPLICA_EGG)
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

	if(user.vore_organs.len < BELLIES_MAX)
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

		//Can belly taste?
		dat += "<br><a href='?src=\ref[src];b_tastes=\ref[selected]'>Can Taste:</a>"
		dat += " [selected.can_taste ? "Yes" : "No"]"

		//How much brute damage
		dat += "<br><a href='?src=\ref[src];b_brute_dmg=\ref[selected]'>Digest Brute Damage:</a>"
		dat += " [selected.digest_brute]"

		//How much burn damage
		dat += "<br><a href='?src=\ref[src];b_burn_dmg=\ref[selected]'>Digest Burn Damage:</a>"
		dat += " [selected.digest_burn]"

		//Minimum size prey must be to show up.
		dat += "<br><a href='?src=\ref[src];b_bulge_size=\ref[selected]'>Required examine size:</a>"
		dat += " [selected.bulge_size*100]%"

		//Size that prey will be grown/shrunk to.
		dat += "<br><a href='?src=\ref[src];b_grow_shrink=\ref[selected]'>Shrink/Grow size:</a>"
		dat += "[selected.shrink_grow_size*100]%"

		//Belly escapability
		dat += "<br><a href='?src=\ref[src];b_escapable=\ref[selected]'>Belly Interactions ([selected.escapable ? "On" : "Off"])</a>"
		if(selected.escapable)
			dat += "<a href='?src=\ref[src];show_int=\ref[selected]'>[show_interacts ? "Hide" : "Show"]</a>"

		if(show_interacts && selected.escapable)
			dat += "<HR>"
			dat += "Interaction Settings <a href='?src=\ref[src];int_help=\ref[selected]'>?</a>"
			dat += "<br><a href='?src=\ref[src];b_escapechance=\ref[selected]'>Set Belly Escape Chance</a>"
			dat += " [selected.escapechance]%"

			dat += "<br><a href='?src=\ref[src];b_escapetime=\ref[selected]'>Set Belly Escape Time</a>"
			dat += " [selected.escapetime/10]s"

			//Special <br> here to add a gap
			dat += "<br style='line-height:5px;'>"
			dat += "<br><a href='?src=\ref[src];b_transferchance=\ref[selected]'>Set Belly Transfer Chance</a>"
			dat += " [selected.transferchance]%"

			dat += "<br><a href='?src=\ref[src];b_transferlocation=\ref[selected]'>Set Belly Transfer Location</a>"
			dat += " [selected.transferlocation ? selected.transferlocation : "Disabled"]"

			//Special <br> here to add a gap
			dat += "<br style='line-height:5px;'>"
			dat += "<br><a href='?src=\ref[src];b_absorbchance=\ref[selected]'>Set Belly Absorb Chance</a>"
			dat += " [selected.absorbchance]%"

			dat += "<br><a href='?src=\ref[src];b_digestchance=\ref[selected]'>Set Belly Digest Chance</a>"
			dat += " [selected.digestchance]%"
			dat += "<HR>"

		//Delete button
		dat += "<br><a style='background:#990000;' href='?src=\ref[src];b_del=\ref[selected]'>Delete Belly</a>"

	dat += "<HR>"

	//Under the last HR, save and stuff.
	dat += "<a href='?src=\ref[src];saveprefs=1'>Save Prefs</a>"
	dat += "<a href='?src=\ref[src];refresh=1'>Refresh</a>"
	dat += "<a href='?src=\ref[src];setflavor=1'>Set Flavor</a>"
	dat += "<br><a href='?src=\ref[src];togglenoisy=1'>Toggle Hunger Noises</a>"

	switch(user.digestable)
		if(1)
			dat += "<a href='?src=\ref[src];toggledg=1'>Toggle Digestable</a>"
		if(0)
			dat += "<a href='?src=\ref[src];toggledg=1'><span style='color:green;'>Toggle Digestable</span></a>"

	dat += "<br><a href='?src=\ref[src];toggle_nif=1'>Set NIF concealment</a>" //These two get their own, custom row.
	dat += "<a href='?src=\ref[src];set_nif_flavor=1'>Set NIF Examine Message.</a>"

	//Returns the dat html to the vore_look
	return dat

/datum/vore_look/proc/vp_interact(href, href_list)
	var/mob/living/user = usr
	for(var/H in href_list)

	if(href_list["close"])
		qdel(src)  // Cleanup
		user.openpanel = 0
		return

	if(href_list["show_int"])
		show_interacts = !show_interacts
		return 1 //Force update

	if(href_list["int_help"])
		alert("These control how your belly responds to someone using 'resist' while inside you. The percent chance to trigger each is listed below, \
				and you can change them to whatever you see fit. Setting them to 0% will disable the possibility of that interaction. \
				These only function as long as interactions are turned on in general. Keep in mind, the 'belly mode' interactions (digest/absorb) \
				will affect all prey in that belly, if one resists and triggers digestion/absorption. If multiple trigger at the same time, \
				only the first in the order of 'Escape > Transfer > Absorb > Digest' will occur.","Interactions Help")
		return 0 //Force update

	if(href_list["outsidepick"])
		var/atom/movable/tgt = locate(href_list["outsidepick"])
		var/datum/belly/OB = locate(href_list["outsidebelly"])
		if(!(tgt in OB.internal_contents)) //Aren't here anymore, need to update menu.
			return 1
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
			if(!(tgt in OB.internal_contents))
				//Doesn't exist anymore, update.
				return 1
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
					return 0

				if("Eject all")
					if(user.stat)
						user << "<span class='warning'>You can't do that in your state!</span>"
						return 0

					selected.release_all_contents()
					playsound(user, 'sound/effects/splat.ogg', 50, 1)

				if("Move all")
					if(user.stat)
						user << "<span class='warning'>You can't do that in your state!</span>"
						return 0

					var/choice = input("Move all where?","Select Belly") in user.vore_organs + "Cancel - Don't Move"

					if(choice == "Cancel - Don't Move")
						return 0
					else
						var/datum/belly/B = user.vore_organs[choice]
						for(var/atom/movable/tgt in selected.internal_contents)
							tgt << "<span class='warning'>You're squished from [user]'s [selected] to their [B]!</span>"
							selected.transfer_contents(tgt, B, 1)

						for(var/mob/hearer in range(1,user))
							hearer << sound('sound/vore/squish2.ogg',volume=80)

		var/atom/movable/tgt = locate(href_list["insidepick"])
		if(!(tgt in selected.internal_contents)) //Old menu, needs updating because they aren't really there.
			return 1 //Forces update
		intent = "Examine"
		intent = alert("Examine, Eject, Move? Examine if you want to leave this box.","Query","Examine","Eject","Move")
		switch(intent)
			if("Examine")
				tgt.examine(user)

			if("Eject")
				if(user.stat)
					user << "<span class='warning'>You can't do that in your state!</span>"
					return 0

				selected.release_specific_contents(tgt)
				playsound(user, 'sound/effects/splat.ogg', 50, 1)

			if("Move")
				if(user.stat)
					user << "<span class='warning'>You can't do that in your state!</span>"
					return 0

				var/choice = input("Move [tgt] where?","Select Belly") in user.vore_organs + "Cancel - Don't Move"

				if(choice == "Cancel - Don't Move")
					return 0
				else
					var/datum/belly/B = user.vore_organs[choice]
					if (!(tgt in selected.internal_contents))
						return 0
					tgt << "<span class='warning'>You're squished from [user]'s [lowertext(selected.name)] to their [lowertext(B.name)]!</span>"
					selected.transfer_contents(tgt, B)


	if(href_list["newbelly"])
		if(user.vore_organs.len >= BELLIES_MAX)
			return 0

		var/new_name = html_encode(input(usr,"New belly's name:","New Belly") as text|null)

		if(length(new_name) > BELLIES_NAME_MAX || length(new_name) < BELLIES_NAME_MIN)
			alert("Entered belly name length invalid (must be longer than [BELLIES_NAME_MIN], no more than than [BELLIES_NAME_MAX]).","Error")
			return 0
		if(new_name in user.vore_organs)
			alert("No duplicate belly names, please.","Error")
			return 0

		var/datum/belly/NB = new(user)
		NB.name = new_name
		user.vore_organs[new_name] = NB
		selected = NB

	if(href_list["bellypick"])
		selected = locate(href_list["bellypick"])
		user.vore_selected = selected.name

	////
	//Please keep these the same order they are on the panel UI for ease of coding
	////
	if(href_list["b_name"])
		var/new_name = html_encode(input(usr,"Belly's new name:","New Name") as text|null)

		if(length(new_name) > BELLIES_NAME_MAX || length(new_name) < BELLIES_NAME_MIN)
			alert("Entered belly name length invalid (must be longer than [BELLIES_NAME_MIN], no more than than [BELLIES_NAME_MAX]).","Error")
			return 0
		if(new_name in user.vore_organs)
			alert("No duplicate belly names, please.","Error")
			return 0

		user.vore_organs[new_name] = selected
		user.vore_organs -= selected.name
		selected.name = new_name

	if(href_list["b_mode"])
		var/list/menu_list = selected.digest_modes
		if(istype(usr,/mob/living/carbon/human))
			//var/mob/living/carbon/human/H = usr
			//if(H.species.vore_numbing)
				//menu_list += DM_DIGEST_NUMB
			menu_list += selected.transform_modes

		if(selected.digest_modes.len == 1) // Don't do anything
			return 0
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

		if(new_desc)
			new_desc = readd_quotes(new_desc)
			if(length(new_desc) > BELLIES_DESC_MAX)
				alert("Entered belly desc too long. [BELLIES_DESC_MAX] character limit.","Error")
				return 0
			selected.inside_flavor = new_desc
		else //Returned null
			return 0

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
				var/new_message = input(user,"These are sent to people who examine you when this belly has contents. Write them in 3rd person ('Their %belly is bulging')."+help,"Examine Message (when full)",selected.get_messages("em")) as message
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
				return 0

	if(href_list["b_verb"])
		var/new_verb = html_encode(input(usr,"New verb when eating (infinitive tense, e.g. nom or swallow):","New Verb") as text|null)

		if(length(new_verb) > BELLIES_NAME_MAX || length(new_verb) < BELLIES_NAME_MIN)
			alert("Entered verb length invalid (must be longer than [BELLIES_NAME_MIN], no longer than [BELLIES_NAME_MAX]).","Error")
			return 0

		selected.vore_verb = new_verb

	if(href_list["b_sound"])
		var/choice = input(user,"Currently set to [selected.vore_sound]","Select Sound") in vore_sounds + "Cancel - No Changes"

		if(choice == "Cancel")
			return 0

		selected.vore_sound = vore_sounds[choice]

	if(href_list["b_soundtest"])
		user << selected.vore_sound

	if(href_list["b_tastes"])
		selected.can_taste = !selected.can_taste

	if(href_list["b_bulge_size"])
		var/new_bulge = input(user, "Choose the required size prey must be to show up on examine, ranging from 25% to 200% Set this to 0 for no text on examine.", "Set Belly Examine Size.") as num|null
		if(new_bulge == null)
			return
		if(new_bulge == 0) //Disable.
			selected.bulge_size = 0
			user << "<span class='notice'>Your stomach will not be seen on examine.</span>"
		else if (!IsInRange(new_bulge,25,200))
			selected.bulge_size = 0.25 //Set it to the default.
			user << "<span class='notice'>Invalid size.</span>"
		else if(new_bulge)
			selected.bulge_size = (new_bulge/100)
	if(href_list["b_grow_shrink"])
		var/new_grow = input(user, "Choose the size that prey will be grown/shrunk to, ranging from 25% to 200%", "Set Growth Shrink Size.") as num|null
		if (new_grow == null)
			return
		if (!IsInRange(new_grow,25,200))
			selected.shrink_grow_size = 1 //Set it to the default
			user << "<span class='notice'>Invalid size.</span>"
		else if(new_grow)
			selected.shrink_grow_size = (new_grow/100)

	if(href_list["b_burn_dmg"])
		var/new_damage = input(user, "Choose the amount of burn damage prey will take per tick. Ranges from 0 to 6.", "Set Belly Burn Damage.") as num|null
		if(new_damage == null)
			return
		var/new_new_damage = Clamp(new_damage, 0, 6)
		selected.digest_burn = new_new_damage

	if(href_list["b_brute_dmg"])
		var/new_damage = input(user, "Choose the amount of brute damage prey will take per tick. Ranges from 0 to 6", "Set Belly Brute Damage.") as num|null
		if(new_damage == null)
			return
		var/new_new_damage = Clamp(new_damage, 0, 6)
		selected.digest_brute = new_new_damage

	if(href_list["b_escapable"])
		if(selected.escapable == 0) //Possibly escapable and special interactions.
			selected.escapable = 1
			usr << "<span class='warning'>Prey now have special interactions with your [selected.name] depending on your settings.</span>"
		else if(selected.escapable == 1) //Never escapable.
			selected.escapable = 0
			usr << "<span class='warning'>Prey will not be able to have special interactions with your [selected.name].</span>"
			show_interacts = 0 //Force the hiding of the panel
		else
			alert("Something went wrong. Your stomach will now not have special interactions. Press the button enable them again and tell a dev.","Error") //If they somehow have a varable that's not 0 or 1
			selected.escapable = 0
			show_interacts = 0 //Force the hiding of the panel

	if(href_list["b_escapechance"])
		var/escape_chance_input = input(user, "Set prey escape chance on resist (as %)", "Prey Escape Chance") as num|null
		if(!isnull(escape_chance_input)) //These have to be 'null' because both cancel and 0 are valid, separate options
			selected.escapechance = sanitize_integer(escape_chance_input, 0, 100, initial(selected.escapechance))

	if(href_list["b_escapetime"])
		var/escape_time_input = input(user, "Set number of seconds for prey to escape on resist (1-60)", "Prey Escape Time") as num|null
		if(!isnull(escape_time_input))
			selected.escapetime = sanitize_integer(escape_time_input*10, 10, 600, initial(selected.escapetime))

	if(href_list["b_transferchance"])
		var/transfer_chance_input = input(user, "Set belly transfer chance on resist (as %). You must also set the location for this to have any effect.", "Prey Escape Time") as num|null
		if(!isnull(transfer_chance_input))
			selected.transferchance = sanitize_integer(transfer_chance_input, 0, 100, initial(selected.transferchance))

	if(href_list["b_transferlocation"])
		var/choice = input("Where do you want your [selected.name] to lead if prey resists?","Select Belly") as null|anything in (user.vore_organs + "None - Remove" - selected.name)

		if(!choice) //They cancelled, no changes
			return 0
		else if(choice == "None - Remove")
			selected.transferlocation = null
		else
			selected.transferlocation = user.vore_organs[choice]

	if(href_list["b_absorbchance"])
		var/absorb_chance_input = input(user, "Set belly absorb mode chance on resist (as %)", "Prey Absorb Chance") as num|null
		if(!isnull(absorb_chance_input))
			selected.absorbchance = sanitize_integer(absorb_chance_input, 0, 100, initial(selected.absorbchance))

	if(href_list["b_digestchance"])
		var/digest_chance_input = input(user, "Set belly digest mode chance on resist (as %)", "Prey Digest Chance") as num|null
		if(!isnull(digest_chance_input))
			selected.digestchance = sanitize_integer(digest_chance_input, 0, 100, initial(selected.digestchance))

	if(href_list["b_del"])
		var/dest_for = 0 //Check to see if it's the destination of another vore organ.
		for(var/I in user.vore_organs)
			var/datum/belly/B = user.vore_organs[I]
			if(B.transferlocation == selected)
				dest_for = B.name
				break

		if(dest_for)
			alert("This is the destiantion for at least '[dest_for]' belly transfers. Remove it as the destination from any bellies before deleting it.","Error")
			return 1
		else if(selected.internal_contents.len)
			alert("Can't delete bellies with contents!","Error")
			return 1
		else if(selected.immutable)
			alert("This belly is marked as undeletable.","Error")
			return 1
		else if(user.vore_organs.len == 1)
			alert("You must have at least one belly.","Error")
			return 1
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
			alert("ERROR: Virgo-specific preferences failed to save!","Error")
		else
			user << "<span class='notice'>Virgo-specific preferences saved!</span>"

	if(href_list["setflavor"])
		var/new_flavor = html_encode(input(usr,"What your character tastes like (40ch limit). This text will be printed to the pred after 'X tastes of...' so just put something like 'strawberries and cream':","Character Flavor",user.vore_taste) as text|null)

		if(new_flavor)
			new_flavor = readd_quotes(new_flavor)
			if(length(new_flavor) > FLAVOR_MAX)
				alert("Entered flavor/taste text too long. [FLAVOR_MAX] character limit.","Error")
				return 0
			user.vore_taste = new_flavor
		else //Returned null
			return 0

	if(href_list["toggle_nif"])
		var/choice = alert(user, "Your nif is currently: [user.conceal_nif ? "Not able to be seen" : "Able to be seen"]", "", "Conceal NIF", "Cancel", "Show NIF")
		switch(choice)
			if("Cancel")
				return 0
			if("Conceal NIF")
				user.conceal_nif = 1
			if("Show NIF")
				user.conceal_nif = 0

	if(href_list["set_nif_flavor"])
		var/new_nif_examine = html_encode(input(usr,"How people will see your NIF on examine (100ch limit):","Character Flavor",user.nif_examine) as text|null)

		if(new_nif_examine)
			new_nif_examine = readd_quotes(new_nif_examine)
			if(length(new_nif_examine) > NIF_EXAMINE_MAX)
				alert("Entered NIF examine text too long. [NIF_EXAMINE_MAX] character limit.","Error")
				return 0
			user.nif_examine = new_nif_examine
		else //Returned null
			return 0

	if(href_list["toggledg"])
		var/choice = alert(user, "This button is for those who don't like being digested. It can make you undigestable. Don't abuse this button by toggling it back and forth to extend a scene or whatever, or you'll make the admins cry. Digesting you is currently: [user.digestable ? "Allowed" : "Prevented"]", "", "Allow Digestion", "Cancel", "Prevent Digestion")
		switch(choice)
			if("Cancel")
				return 0
			if("Allow Digestion")
				user.digestable = 1
			if("Prevent Digestion")
				user.digestable = 0

		message_admins("[key_name(user)] toggled their digestability to [user.digestable] ([user ? "<a href='?_src_=holder;adminplayerobservecoodjump=1;X=[user.loc.];Y=[user.loc.y];Z=[user.loc.z]'>JMP</a>" : "null"])")

		if(user.client.prefs_vr)
			user.client.prefs_vr.digestable = user.digestable

	if(href_list["togglenoisy"])
		var/choice = alert(user, "Toggle audible hunger noises. Currently: [user.noisy ? "Enabled" : "Disabled"]", "", "Enable audible hunger", "Cancel", "Disable audible hunger")
		switch(choice)
			if("Cancel")
				return 0
			if("Enable audible hunger")
				user.noisy = 1
			if("Disable audible hunger")
				user.noisy = 0

	//Refresh when interacted with, returning 1 makes vore_look.Topic update
	return 1
