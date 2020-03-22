//
// Vore management panel for players
//

#define BELLIES_MAX 40
#define BELLIES_NAME_MIN 2
#define BELLIES_NAME_MAX 20
#define BELLIES_DESC_MAX 2048
#define FLAVOR_MAX 40

/mob/living
	var/datum/vore_look/vorePanel

/mob/living/proc/insidePanel()
	set name = "Vore Panel"
	set category = "IC"

	if(!vorePanel)
		log_debug("[src] ([type], \ref[src]) didn't have a vorePanel and tried to use the verb.")
		vorePanel = new

	vorePanel.selected = vore_selected
	vorePanel.show(src)

/mob/living/proc/updateVRPanel() //Panel popup update call from belly events.
	if(!vorePanel)
		log_debug("[src] ([type], \ref[src]) didn't have a vorePanel and something tried to update it.")
		vorePanel = new

	if(vorePanel.open)
		vorePanel.selected = vore_selected
		vorePanel.show(src)

//
// Callback Handler for the Inside form
//
/datum/vore_look
	var/datum/browser/popup
	var/obj/belly/selected
	var/show_interacts = 0
	var/open = FALSE

/datum/vore_look/Destroy()
	selected = null
	QDEL_NULL(popup)
	. = ..()

/datum/vore_look/Topic(href,href_list[])
	if(vp_interact(href, href_list))
		popup.set_content(gen_ui(usr))
		usr << output(popup.get_content(), "insidePanel.browser")

/datum/vore_look/proc/show(mob/living/user)
	if(popup)
		QDEL_NULL(popup)
	popup = new(user, "insidePanel", "Inside!", 450, 700, src)
	popup.set_content(gen_ui(user))
	popup.open()
	open = TRUE

/datum/vore_look/proc/gen_ui(var/mob/living/user)
	var/dat

	var/atom/userloc = user.loc
	if(isbelly(userloc))
		var/obj/belly/inside_belly = userloc
		var/mob/living/eater = inside_belly.owner

		//Don't display this part if we couldn't find the belly since could be held in hand.
		if(inside_belly)
			dat += "<font color='green'>You are currently [user.absorbed ? "absorbed into " : "inside "]</font> <font color = 'yellow'>[eater]'s</font> <font color = 'red'>[inside_belly]</font>!<br><br>"

			if(inside_belly.desc)
				dat += "[inside_belly.desc]<br><br>"

			if(inside_belly.contents.len > 1)
				dat += "You can see the following around you:<br>"
				for (var/atom/movable/O in inside_belly)
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
	for(var/belly in user.vore_organs)
		var/obj/belly/B = belly
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
			if(DM_ABSORB)
				spanstyle = "color:purple;"
			if(DM_DRAIN)
				spanstyle = "color:purple;"
			if(DM_HEAL)
				spanstyle = "color:green;"
			if(DM_SHRINK)
				spanstyle = "color:purple;"
			if(DM_GROW)
				spanstyle = "color:purple;"
			if(DM_SIZE_STEAL)
				spanstyle = "color:purple;"
			if(DM_TRANSFORM)
				switch(B.tf_mode)
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

		dat += "<span style='[spanstyle]'> ([B.contents.len])</span></a></li>"

	if(user.vore_organs.len < BELLIES_MAX)
		dat += "<li style='float: left'><a href='?src=\ref[src];newbelly=1'>New+</a></li>"
	dat += "</ol>"
	dat += "<HR>"

	// Selected Belly (contents, configuration)
	if(!selected)
		dat += "No belly selected. Click one to select it."
	else
		if(selected.contents.len)
			dat += "<b>Contents:</b> "
			for(var/O in selected)

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
			if(selected.contents.len > 1)
				dat += "<a href='?src=\ref[src];insidepick=1;pickall=1'>\[All\]</a>"

			dat += "<HR>"

		//Belly Name Button
		dat += "<a href='?src=\ref[src];b_name=\ref[selected]'>Name:</a>"
		dat += " '[selected.name]'"

		//Belly Type button
		dat += "<br><a href='?src=\ref[src];b_wetness=\ref[selected]'>Is this belly fleshy:</a>"
		dat += "[selected.is_wet ? "Yes" : "No"]"
		if(selected.is_wet)
			dat += "<br><a href='?src=\ref[src];b_wetloop=\ref[selected]'>Internal loop for prey?:</a>"
			dat += "[selected.wet_loop ? "Yes" : "No"]"

		//Digest Mode Button
		dat += "<br><a href='?src=\ref[src];b_mode=\ref[selected]'>Belly Mode:</a>"
		var/mode = selected.digest_mode
		dat += " [mode == DM_TRANSFORM ? selected.tf_mode : mode]"

		//Mode addons button
		dat += "<br><a href='?src=\ref[src];b_addons=\ref[selected]'>Mode Addons:</a>"
		var/list/flag_list = list()
		for(var/flag_name in selected.mode_flag_list)
			if(selected.mode_flags & selected.mode_flag_list[flag_name])
				flag_list += flag_name
		if(flag_list.len)
			dat += " [english_list(flag_list)]"
		else
			dat += " None"

		//Item Digest Mode Button
		dat += "<br><a href='?src=\ref[src];b_item_mode=\ref[selected]'>Item Mode:</a>"
		dat += "[selected.item_digest_mode]"

		//Will it contaminate contents?
		dat += "<br><a href='?src=\ref[src];b_contaminates=\ref[selected]'>Contaminates:</a>"
		dat += " [selected.contaminates ? "Yes" : "No"]"

		if(selected.contaminates)
			//Contamination descriptors
			dat += "<br><a href='?src=\ref[src];b_contamination_flavor=\ref[selected]'>Contamination Flavor:</a>"
			dat += "[selected.contamination_flavor]"
			//Contamination color
			dat += "<br><a href='?src=\ref[src];b_contamination_color=\ref[selected]'>Contamination Color:</a>"
			dat += "[selected.contamination_color]"

		//Belly verb
		dat += "<br><a href='?src=\ref[src];b_verb=\ref[selected]'>Vore Verb:</a>"
		dat += " '[selected.vore_verb]'"

		//Inside flavortext
		dat += "<br><a href='?src=\ref[src];b_desc=\ref[selected]'>Flavor Text:</a>"
		dat += " '[selected.desc]'"

		//Belly Sound Fanciness
		dat += "<br><a href='?src=\ref[src];b_fancy_sound=\ref[selected]'>Use Fancy Sounds:</a>"
		dat += "[selected.fancy_vore ? "Yes" : "No"]"

		//Belly sound
		dat += "<br><a href='?src=\ref[src];b_sound=\ref[selected]'>Vore Sound: [selected.vore_sound]</a>"
		dat += "<a href='?src=\ref[src];b_soundtest=\ref[selected]'>Test</a>"

		//Release sound
		dat += "<br><a href='?src=\ref[src];b_release=\ref[selected]'>Release Sound: [selected.release_sound]</a>"
		dat += "<a href='?src=\ref[src];b_releasesoundtest=\ref[selected]'>Test</a>"

		//Belly messages
		dat += "<br><a href='?src=\ref[src];b_msgs=\ref[selected]'>Belly Messages</a>"

		//Can belly taste?
		dat += "<br><a href='?src=\ref[src];b_tastes=\ref[selected]'>Can Taste:</a>"
		dat += " [selected.can_taste ? "Yes" : "No"]"

		//Nutritional percentage
		dat += "<br><a href='?src=\ref[src];b_nutritionpercent=\ref[selected]'>Nutritional Gain:</a>"
		dat += " [selected.nutrition_percent]%"

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

	switch(user.digestable)
		if(TRUE)
			dat += "<a style='background:#173d15;' href='?src=\ref[src];toggledg=1'>Toggle Digestable (Currently: ON)</a>"
		if(FALSE)
			dat += "<a style='background:#990000;' href='?src=\ref[src];toggledg=1'>Toggle Digestable (Currently: OFF)</a>"
	switch(user.devourable)
		if(TRUE)
			dat += "<a style='background:#173d15;' href='?src=\ref[src];toggleddevour=1'>Toggle Devourable (Currently: ON)</a>"
		if(FALSE)
			dat += "<a style='background:#990000;' href='?src=\ref[src];toggleddevour=1'>Toggle Devourable (Currently: OFF)</a>"
	switch(user.feeding)
		if(TRUE)
			dat += "<br><a style='background:#173d15;' href='?src=\ref[src];toggledfeed=1'>Toggle Feeding (Currently: ON)</a>"
		if(FALSE)
			dat += "<br><a style='background:#990000;' href='?src=\ref[src];toggledfeed=1'>Toggle Feeding (Currently: OFF)</a>"
	switch(user.absorbable)
		if(TRUE)
			dat += "<a style='background:#173d15;' href='?src=\ref[src];toggleabsorbable=1'>Toggle Absorbtion Permission (Currently: ON)</a>"
		if(FALSE)
			dat += "<a style='background:#990000;' href='?src=\ref[src];toggleabsorbable=1'>Toggle Absorbtion Permission (Currently: OFF)</a>"
	switch(user.digest_leave_remains)
		if(TRUE)
			dat += "<a style='background:#173d15;' href='?src=\ref[src];toggledlm=1'>Toggle Leaving Remains (Currently: ON)</a>"
		if(FALSE)
			dat += "<a style='background:#990000;' href='?src=\ref[src];toggledlm=1'>Toggle Leaving Remains (Currently: OFF)</a>"
	switch(user.allowmobvore)
		if(TRUE)
			dat += "<br><a style='background:#173d15;' href='?src=\ref[src];togglemv=1'>Toggle Mob Vore (Currently: ON)</a>"
		if(FALSE)
			dat += "<br><a style='background:#990000;' href='?src=\ref[src];togglemv=1'>Toggle Mob Vore (Currently: OFF)</a>"
	switch(user.permit_healbelly)
		if(TRUE)
			dat += "<a style='background:#173d15;' href='?src=\ref[src];togglehealbelly=1'>Toggle Healbelly Permission (Currently: ON)</a>"
		if(FALSE)
			dat += "<a style='background:#990000;' href='?src=\ref[src];togglehealbelly=1'>Toggle Healbelly Permission (Currently: OFF)</a>"

	switch(user.can_be_drop_prey)
		if(TRUE)
			dat += "<br><a style='background:#173d15;' href='?src=\ref[src];toggle_dropnom_prey=1'>Toggle Prey Spontaneous Vore (Currently: ON)</a>"
		if(FALSE)
			dat += "<br><a style='background:#990000;' href='?src=\ref[src];toggle_dropnom_prey=1'>Toggle Prey Spontaneous Vore (Currently: OFF)</a>"

	switch(user.can_be_drop_pred)
		if(TRUE)
			dat += "<a style='background:#173d15;' href='?src=\ref[src];toggle_dropnom_pred=1'>Toggle Pred Spontaneous Vore (Currently: ON)</a>"
		if(FALSE)
			dat += "<a style='background:#990000;' href='?src=\ref[src];toggle_dropnom_pred=1'>Toggle Pred Spontaneous Vore (Currently: OFF)</a>"

	dat += "<br><a href='?src=\ref[src];setflavor=1'>Set Your Taste</a>"
	dat += "<a href='?src=\ref[src];togglenoisy=1'>Toggle Hunger Noises</a>"

	dat += "<HR>"

	//Under the last HR, save and stuff.
	dat += "<a href='?src=\ref[src];saveprefs=1'>Save Prefs</a>"
	dat += "<a href='?src=\ref[src];refresh=1'>Refresh</a>"
	dat += "<a href='?src=\ref[src];applyprefs=1'>Reload Slot Prefs</a>"

	//Returns the dat html to the vore_look
	return dat

/datum/vore_look/proc/vp_interact(href, href_list)
	var/mob/living/user = usr
	if(href_list["close"])
		open = FALSE
		QDEL_NULL(popup)
		return

	if(href_list["show_int"])
		show_interacts = !show_interacts
		return TRUE //Force update

	if(href_list["int_help"])
		alert("These control how your belly responds to someone using 'resist' while inside you. The percent chance to trigger each is listed below, \
				and you can change them to whatever you see fit. Setting them to 0% will disable the possibility of that interaction. \
				These only function as long as interactions are turned on in general. Keep in mind, the 'belly mode' interactions (digest/absorb) \
				will affect all prey in that belly, if one resists and triggers digestion/absorption. If multiple trigger at the same time, \
				only the first in the order of 'Escape > Transfer > Absorb > Digest' will occur.","Interactions Help")
		return FALSE //Force update

	if(href_list["outsidepick"])
		var/atom/movable/tgt = locate(href_list["outsidepick"])
		var/obj/belly/OB = locate(href_list["outsidebelly"])
		if(!(tgt in OB)) //Aren't here anymore, need to update menu.
			return TRUE
		var/intent = "Examine"

		if(istype(tgt,/mob/living))
			var/mob/living/M = tgt
			intent = alert("What do you want to do to them?","Query","Examine","Help Out","Devour")
			switch(intent)
				if("Examine") //Examine a mob inside another mob
					M.examine(user)

				if("Help Out") //Help the inside-mob out
					if(user.stat || user.absorbed || M.absorbed)
						to_chat(user,"<span class='warning'>You can't do that in your state!</span>")
						return TRUE

					to_chat(user,"<font color='green'>You begin to push [M] to freedom!</font>")
					to_chat(M,"[usr] begins to push you to freedom!")
					to_chat(M.loc,"<span class='warning'>Someone is trying to escape from inside you!</span>")
					sleep(50)
					if(prob(33))
						OB.release_specific_contents(M)
						to_chat(usr,"<font color='green'>You manage to help [M] to safety!</font>")
						to_chat(M,"<font color='green'>[user] pushes you free!</font>")
						to_chat(OB.owner,"<span class='alert'>[M] forces free of the confines of your body!</span>")
					else
						to_chat(user,"<span class='alert'>[M] slips back down inside despite your efforts.</span>")
						to_chat(M,"<span class='alert'> Even with [user]'s help, you slip back inside again.</span>")
						to_chat(OB.owner,"<font color='green'>Your body efficiently shoves [M] back where they belong.</font>")

				if("Devour") //Eat the inside mob
					if(user.absorbed || user.stat)
						to_chat(user,"<span class='warning'>You can't do that in your state!</span>")
						return TRUE

					if(!user.vore_selected)
						to_chat(user,"<span class='warning'>Pick a belly on yourself first!</span>")
						return TRUE

					var/obj/belly/TB = user.vore_selected
					to_chat(user,"<span class='warning'>You begin to [lowertext(TB.vore_verb)] [M] into your [lowertext(TB.name)]!</span>")
					to_chat(M,"<span class='warning'>[user] begins to [lowertext(TB.vore_verb)] you into their [lowertext(TB.name)]!</span>")
					to_chat(OB.owner,"<span class='warning'>Someone inside you is eating someone else!</span>")

					sleep(TB.nonhuman_prey_swallow_time) //Can't do after, in a stomach, weird things abound.
					if((user in OB) && (M in OB)) //Make sure they're still here.
						to_chat(user,"<span class='warning'>You manage to [lowertext(TB.vore_verb)] [M] into your [lowertext(TB.name)]!</span>")
						to_chat(M,"<span class='warning'>[user] manages to [lowertext(TB.vore_verb)] you into their [lowertext(TB.name)]!</span>")
						to_chat(OB.owner,"<span class='warning'>Someone inside you has eaten someone else!</span>")
						TB.nom_mob(M)

		else if(istype(tgt,/obj/item))
			var/obj/item/T = tgt
			if(!(tgt in OB))
				//Doesn't exist anymore, update.
				return TRUE
			intent = alert("What do you want to do to that?","Query","Examine","Use Hand")
			switch(intent)
				if("Examine")
					T.examine(user)

				if("Use Hand")
					if(user.stat)
						to_chat(user,"<span class='warning'>You can't do that in your state!</span>")
						return TRUE

					user.ClickOn(T)
					sleep(5) //Seems to exit too fast for the panel to update

	if(href_list["insidepick"])
		var/intent

		//Handle the [All] choice. Ugh inelegant. Someone make this pretty.
		if(href_list["pickall"])
			intent = alert("Eject all, Move all?","Query","Eject all","Cancel","Move all")
			switch(intent)
				if("Cancel")
					return FALSE

				if("Eject all")
					if(user.stat)
						to_chat(user,"<span class='warning'>You can't do that in your state!</span>")
						return FALSE

					selected.release_all_contents()

				if("Move all")
					if(user.stat)
						to_chat(user,"<span class='warning'>You can't do that in your state!</span>")
						return FALSE

					var/obj/belly/choice = input("Move all where?","Select Belly") as null|anything in user.vore_organs
					if(!choice)
						return FALSE

					for(var/atom/movable/tgt in selected)
						to_chat(tgt,"<span class='warning'>You're squished from [user]'s [lowertext(selected)] to their [lowertext(choice.name)]!</span>")
						selected.transfer_contents(tgt, choice, 1)

		var/atom/movable/tgt = locate(href_list["insidepick"])
		if(!(tgt in selected)) //Old menu, needs updating because they aren't really there.
			return TRUE //Forces update
		intent = "Examine"
		intent = alert("Examine, Eject, Move? Examine if you want to leave this box.","Query","Examine","Eject","Move")
		switch(intent)
			if("Examine")
				tgt.examine(user)

			if("Eject")
				if(user.stat)
					to_chat(user,"<span class='warning'>You can't do that in your state!</span>")
					return FALSE

				selected.release_specific_contents(tgt)

			if("Move")
				if(user.stat)
					to_chat(user,"<span class='warning'>You can't do that in your state!</span>")
					return FALSE

				var/obj/belly/choice = input("Move [tgt] where?","Select Belly") as null|anything in user.vore_organs
				if(!choice || !(tgt in selected))
					return FALSE

				to_chat(tgt,"<span class='warning'>You're squished from [user]'s [lowertext(selected.name)] to their [lowertext(choice.name)]!</span>")
				selected.transfer_contents(tgt, choice)

	if(href_list["newbelly"])
		if(user.vore_organs.len >= BELLIES_MAX)
			return FALSE

		var/new_name = html_encode(input(usr,"New belly's name:","New Belly") as text|null)

		var/failure_msg
		if(length(new_name) > BELLIES_NAME_MAX || length(new_name) < BELLIES_NAME_MIN)
			failure_msg = "Entered belly name length invalid (must be longer than [BELLIES_NAME_MIN], no more than than [BELLIES_NAME_MAX])."
		// else if(whatever) //Next test here.
		else
			for(var/belly in user.vore_organs)
				var/obj/belly/B = belly
				if(lowertext(new_name) == lowertext(B.name))
					failure_msg = "No duplicate belly names, please."
					break

		if(failure_msg) //Something went wrong.
			alert(user,failure_msg,"Error!")
			return FALSE

		var/obj/belly/NB = new(user)
		NB.name = new_name
		selected = NB

	if(href_list["bellypick"])
		selected = locate(href_list["bellypick"])
		user.vore_selected = selected

	////
	//Please keep these the same order they are on the panel UI for ease of coding
	////
	if(href_list["b_name"])
		var/new_name = html_encode(input(usr,"Belly's new name:","New Name") as text|null)

		var/failure_msg
		if(length(new_name) > BELLIES_NAME_MAX || length(new_name) < BELLIES_NAME_MIN)
			failure_msg = "Entered belly name length invalid (must be longer than [BELLIES_NAME_MIN], no more than than [BELLIES_NAME_MAX])."
		// else if(whatever) //Next test here.
		else
			for(var/belly in user.vore_organs)
				var/obj/belly/B = belly
				if(lowertext(new_name) == lowertext(B.name))
					failure_msg = "No duplicate belly names, please."
					break

		if(failure_msg) //Something went wrong.
			alert(user,failure_msg,"Error!")
			return FALSE

		selected.name = new_name

	if(href_list["b_wetness"])
		selected.is_wet = !selected.is_wet

	if(href_list["b_wetloop"])
		selected.wet_loop = !selected.wet_loop

	if(href_list["b_mode"])
		var/list/menu_list = selected.digest_modes.Copy()
		if(istype(usr,/mob/living/carbon/human))
			menu_list += DM_TRANSFORM

		var/new_mode = input("Choose Mode (currently [selected.digest_mode])") as null|anything in menu_list
		if(!new_mode)
			return FALSE

		if(new_mode == DM_TRANSFORM) //Snowflek submenu
			var/list/tf_list = selected.transform_modes
			var/new_tf_mode = input("Choose TF Mode (currently [selected.tf_mode])") as null|anything in tf_list
			if(!new_tf_mode)
				return FALSE
			selected.tf_mode = new_tf_mode

		selected.digest_mode = new_mode
		//selected.items_preserved.Cut() //Re-evaltuate all items in belly on belly-mode change	//Handled with item modes now

	if(href_list["b_addons"])
		var/list/menu_list = selected.mode_flag_list.Copy()
		var/toggle_addon = input("Toggle Addon") as null|anything in menu_list
		if(!toggle_addon)
			return FALSE
		selected.mode_flags ^= selected.mode_flag_list[toggle_addon]
		selected.items_preserved.Cut() //Re-evaltuate all items in belly on addon toggle

	if(href_list["b_item_mode"])
		var/list/menu_list = selected.item_digest_modes.Copy()

		var/new_mode = input("Choose Mode (currently [selected.item_digest_mode])") as null|anything in menu_list
		if(!new_mode)
			return FALSE

		selected.item_digest_mode = new_mode
		selected.items_preserved.Cut() //Re-evaltuate all items in belly on belly-mode change

	if(href_list["b_contaminates"])
		selected.contaminates = !selected.contaminates

	if(href_list["b_contamination_flavor"])
		var/list/menu_list = contamination_flavors.Copy()
		var/new_flavor = input("Choose Contamination Flavor Text Type (currently [selected.contamination_flavor])") as null|anything in menu_list
		if(!new_flavor)
			return FALSE
		selected.contamination_flavor = new_flavor

	if(href_list["b_contamination_color"])
		var/list/menu_list = contamination_colors.Copy()
		var/new_color = input("Choose Contamination Color (currently [selected.contamination_color])") as null|anything in menu_list
		if(!new_color)
			return FALSE
		selected.contamination_color = new_color
		selected.items_preserved.Cut() //To re-contaminate for new color

	if(href_list["b_desc"])
		var/new_desc = html_encode(input(usr,"Belly Description ([BELLIES_DESC_MAX] char limit):","New Description",selected.desc) as message|null)

		if(new_desc)
			new_desc = readd_quotes(new_desc)
			if(length(new_desc) > BELLIES_DESC_MAX)
				alert("Entered belly desc too long. [BELLIES_DESC_MAX] character limit.","Error")
				return FALSE
			selected.desc = new_desc
		else //Returned null
			return FALSE

	if(href_list["b_msgs"])
		var/list/messages = list(
			"Digest Message (to prey)",
			"Digest Message (to you)",
			"Struggle Message (outside)",
			"Struggle Message (inside)",
			"Examine Message (when full)",
			"Reset All To Default"
		)

		alert(user,"Setting abusive or deceptive messages will result in a ban. Consider this your warning. Max 150 characters per message, max 10 messages per topic.","Really, don't.")
		var/choice = input(user,"Select a type to modify. Messages from each topic are pulled at random when needed.","Pick Type") as null|anything in messages
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

	if(href_list["b_verb"])
		var/new_verb = html_encode(input(usr,"New verb when eating (infinitive tense, e.g. nom or swallow):","New Verb") as text|null)

		if(length(new_verb) > BELLIES_NAME_MAX || length(new_verb) < BELLIES_NAME_MIN)
			alert("Entered verb length invalid (must be longer than [BELLIES_NAME_MIN], no longer than [BELLIES_NAME_MAX]).","Error")
			return FALSE

		selected.vore_verb = new_verb

	if(href_list["b_fancy_sound"])
		selected.fancy_vore = !selected.fancy_vore
		selected.vore_sound = "Gulp"
		selected.release_sound = "Splatter"
		// defaults as to avoid potential bugs

	if(href_list["b_release"])
		var/choice
		if(selected.fancy_vore)
			choice = input(user,"Currently set to [selected.release_sound]","Select Sound") as null|anything in fancy_release_sounds
		else
			choice = input(user,"Currently set to [selected.release_sound]","Select Sound") as null|anything in classic_release_sounds

		if(!choice)
			return FALSE

		selected.release_sound = choice

	if(href_list["b_releasesoundtest"])
		var/sound/releasetest
		if(selected.fancy_vore)
			releasetest = fancy_release_sounds[selected.release_sound]
		else
			releasetest = classic_release_sounds[selected.release_sound]

		if(releasetest)
			SEND_SOUND(user, releasetest)

	if(href_list["b_sound"])
		var/choice
		if(selected.fancy_vore)
			choice = input(user,"Currently set to [selected.vore_sound]","Select Sound") as null|anything in fancy_vore_sounds
		else
			choice = input(user,"Currently set to [selected.vore_sound]","Select Sound") as null|anything in classic_vore_sounds

		if(!choice)
			return FALSE

		selected.vore_sound = choice

	if(href_list["b_soundtest"])
		var/sound/voretest
		if(selected.fancy_vore)
			voretest = fancy_vore_sounds[selected.vore_sound]
		else
			voretest = classic_vore_sounds[selected.vore_sound]
		if(voretest)
			SEND_SOUND(user, voretest)

	if(href_list["b_tastes"])
		selected.can_taste = !selected.can_taste

	if(href_list["b_bulge_size"])
		var/new_bulge = input(user, "Choose the required size prey must be to show up on examine, ranging from 25% to 200% Set this to 0 for no text on examine.", "Set Belly Examine Size.") as num|null
		if(new_bulge == null)
			return
		if(new_bulge == 0) //Disable.
			selected.bulge_size = 0
			to_chat(user,"<span class='notice'>Your stomach will not be seen on examine.</span>")
		else if (!ISINRANGE(new_bulge,25,200))
			selected.bulge_size = 0.25 //Set it to the default.
			to_chat(user,"<span class='notice'>Invalid size.</span>")
		else if(new_bulge)
			selected.bulge_size = (new_bulge/100)

	if(href_list["b_grow_shrink"])
		var/new_grow = input(user, "Choose the size that prey will be grown/shrunk to, ranging from 25% to 200%", "Set Growth Shrink Size.", selected.shrink_grow_size) as num|null
		if (new_grow == null)
			return
		if (!ISINRANGE(new_grow,25,200))
			selected.shrink_grow_size = 1 //Set it to the default
			to_chat(user,"<span class='notice'>Invalid size.</span>")
		else if(new_grow)
			selected.shrink_grow_size = (new_grow*0.01)

	if(href_list["b_nutritionpercent"])
		var/new_damage = input(user, "Choose the nutrition gain percentage you will recieve per tick from prey. Ranges from 0.01 to 100.", "Set Nutrition Gain Percentage.", selected.digest_brute) as num|null
		if(new_damage == null)
			return
		var/new_new_damage = CLAMP(new_damage, 0.01, 100)
		selected.nutrition_percent = new_new_damage

	if(href_list["b_burn_dmg"])
		var/new_damage = input(user, "Choose the amount of burn damage prey will take per tick. Ranges from 0 to 6.", "Set Belly Burn Damage.", selected.digest_burn) as num|null
		if(new_damage == null)
			return
		var/new_new_damage = CLAMP(new_damage, 0, 6)
		selected.digest_burn = new_new_damage

	if(href_list["b_brute_dmg"])
		var/new_damage = input(user, "Choose the amount of brute damage prey will take per tick. Ranges from 0 to 6", "Set Belly Brute Damage.", selected.digest_brute) as num|null
		if(new_damage == null)
			return
		var/new_new_damage = CLAMP(new_damage, 0, 6)
		selected.digest_brute = new_new_damage

	if(href_list["b_escapable"])
		if(selected.escapable == 0) //Possibly escapable and special interactions.
			selected.escapable = 1
			to_chat(usr,"<span class='warning'>Prey now have special interactions with your [lowertext(selected.name)] depending on your settings.</span>")
		else if(selected.escapable == 1) //Never escapable.
			selected.escapable = 0
			to_chat(usr,"<span class='warning'>Prey will not be able to have special interactions with your [lowertext(selected.name)].</span>")
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
		var/obj/belly/choice = input("Where do you want your [lowertext(selected.name)] to lead if prey resists?","Select Belly") as null|anything in (user.vore_organs + "None - Remove" - selected)

		if(!choice) //They cancelled, no changes
			return FALSE
		else if(choice == "None - Remove")
			selected.transferlocation = null
		else
			selected.transferlocation = choice.name

	if(href_list["b_absorbchance"])
		var/absorb_chance_input = input(user, "Set belly absorb mode chance on resist (as %)", "Prey Absorb Chance") as num|null
		if(!isnull(absorb_chance_input))
			selected.absorbchance = sanitize_integer(absorb_chance_input, 0, 100, initial(selected.absorbchance))

	if(href_list["b_digestchance"])
		var/digest_chance_input = input(user, "Set belly digest mode chance on resist (as %)", "Prey Digest Chance") as num|null
		if(!isnull(digest_chance_input))
			selected.digestchance = sanitize_integer(digest_chance_input, 0, 100, initial(selected.digestchance))

	if(href_list["b_del"])
		var/alert = alert("Are you sure you want to delete your [lowertext(selected.name)]?","Confirmation","Delete","Cancel")
		if(!(alert == "Delete"))
			return FALSE

		var/failure_msg = ""

		var/dest_for //Check to see if it's the destination of another vore organ.
		for(var/belly in user.vore_organs)
			var/obj/belly/B = belly
			if(B.transferlocation == selected)
				dest_for = B.name
				failure_msg += "This is the destiantion for at least '[dest_for]' belly transfers. Remove it as the destination from any bellies before deleting it. "
				break

		if(selected.contents.len)
			failure_msg += "You cannot delete bellies with contents! " //These end with spaces, to be nice looking. Make sure you do the same.
		if(selected.immutable)
			failure_msg += "This belly is marked as undeletable. "
		if(user.vore_organs.len == 1)
			failure_msg += "You must have at least one belly. "

		if(failure_msg)
			alert(user,failure_msg,"Error!")
			return FALSE

		qdel(selected)
		selected = user.vore_organs[1]
		user.vore_selected = user.vore_organs[1]

	if(href_list["saveprefs"])
		if(!user.save_vore_prefs())
			alert("ERROR: Virgo-specific preferences failed to save!","Error")
		else
			to_chat(user,"<span class='notice'>Virgo-specific preferences saved!</span>")

	if(href_list["applyprefs"])
		var/alert = alert("Are you sure you want to reload character slot preferences? This will remove your current vore organs and eject their contents.","Confirmation","Reload","Cancel")
		if(!alert == "Reload")
			return FALSE
		if(!user.apply_vore_prefs())
			alert("ERROR: Virgo-specific preferences failed to apply!","Error")
		else
			to_chat(user,"<span class='notice'>Virgo-specific preferences applied from active slot!</span>")

	if(href_list["setflavor"])
		var/new_flavor = html_encode(input(usr,"What your character tastes like (40ch limit). This text will be printed to the pred after 'X tastes of...' so just put something like 'strawberries and cream':","Character Flavor",user.vore_taste) as text|null)
		if(!new_flavor)
			return FALSE

		new_flavor = readd_quotes(new_flavor)
		if(length(new_flavor) > FLAVOR_MAX)
			alert("Entered flavor/taste text too long. [FLAVOR_MAX] character limit.","Error!")
			return FALSE
		user.vore_taste = new_flavor

	if(href_list["toggle_dropnom_pred"])
		var/choice = alert(user, "This toggle is for spontaneous, environment related vore as a predator, including drop-noms, teleporters, etc. You are currently [user.can_be_drop_pred ? " able to eat prey that you encounter by environmental actions." : "avoiding eating prey encountered in the environment."]", "", "Be Pred", "Cancel", "Don't be Pred")
		switch(choice)
			if("Cancel")
				return FALSE
			if("Be Pred")
				user.can_be_drop_pred = TRUE
			if("Don't be Pred")
				user.can_be_drop_pred = FALSE

	if(href_list["toggle_dropnom_prey"])
		var/choice = alert(user, "This toggle is for spontaneous, environment related vore as a prey, including drop-noms, teleporters, etc. You are currently [user.can_be_drop_prey ? "able to be eaten by environmental actions." : "not able to be eaten by environmental actions."]", "", "Be Prey", "Cancel", "Don't Be Prey")
		switch(choice)
			if("Cancel")
				return FALSE
			if("Be Prey")
				user.can_be_drop_prey = TRUE
			if("Don't Be Prey")
				user.can_be_drop_prey = FALSE

	if(href_list["toggledg"])
		var/choice = alert(user, "This button is for those who don't like being digested. It can make you undigestable. Messages admins when changed, so don't try to use it for mechanical benefit. Set it once and save it. Digesting you is currently: [user.digestable ? "Allowed" : "Prevented"]", "", "Allow Digestion", "Cancel", "Prevent Digestion")
		switch(choice)
			if("Cancel")
				return FALSE
			if("Allow Digestion")
				user.digestable = TRUE
			if("Prevent Digestion")
				user.digestable = FALSE

		message_admins("[key_name(user)] toggled their digestability to [user.digestable] ([user ? "<a href='?_src_=holder;adminplayerobservecoodjump=1;X=[user.loc.];Y=[user.loc.y];Z=[user.loc.z]'>JMP</a>" : "null"])")

		if(user.client.prefs_vr)
			user.client.prefs_vr.digestable = user.digestable

	if(href_list["toggleddevour"])
		var/choice = alert(user, "This button is to toggle your ability to be devoured by others. Devouring is currently: [user.devourable ? "Allowed" : "Prevented"]", "", "Be Devourable", "Cancel", "Prevent being Devoured")
		switch(choice)
			if("Cancel")
				return FALSE
			if("Be Devourable")
				user.devourable = TRUE
			if("Prevent being Devoured")
				user.devourable = FALSE

		if(user.client.prefs_vr)
			user.client.prefs_vr.devourable = user.devourable

	if(href_list["toggledfeed"])
		var/choice = alert(user, "This button is to toggle your ability to be fed to or by others vorishly. Force Feeding is currently: [user.feeding ? "Allowed" : "Prevented"]", "", "Allow Feeding", "Cancel", "Prevent Feeding")
		switch(choice)
			if("Cancel")
				return FALSE
			if("Allow Feeding")
				user.feeding = TRUE
			if("Prevent Feeding")
				user.feeding = FALSE

		if(user.client.prefs_vr)
			user.client.prefs_vr.feeding = user.feeding

	if(href_list["toggleabsorbable"])
		var/choice = alert(user, "This button allows preds to know whether you prefer or don't prefer to be absorbed. Currently you are [user.absorbable? "" : "not"] giving permission.", "", "Allow absorption", "Cancel", "Disallow absorption")
		switch(choice)
			if("Cancel")
				return FALSE
			if("Allow absorption")
				user.absorbable = TRUE
			if("Disallow absorption")
				user.absorbable = FALSE

		if(user.client.prefs_vr)
			user.client.prefs_vr.absorbable = user.absorbable

	if(href_list["toggledlm"])
		var/choice = alert(user, "This button allows preds to have your remains be left in their belly after you are digested. This will only happen if pred sets their belly to do so. Remains consist of skeletal parts. Currently you are [user.digest_leave_remains? "" : "not"] leaving remains.", "", "Allow Post-digestion Remains", "Cancel", "Disallow Post-digestion Remains")
		switch(choice)
			if("Cancel")
				return FALSE
			if("Allow Post-digestion Remains")
				user.digest_leave_remains = TRUE
			if("Disallow Post-digestion Remains")
				user.digest_leave_remains = FALSE

		if(user.client.prefs_vr)
			user.client.prefs_vr.digest_leave_remains = user.digest_leave_remains

	if(href_list["togglemv"])
		var/choice = alert(user, "This button is for those who don't like being eaten by mobs. Messages admins when changed, so don't try to use it for mechanical benefit. Set it once and save it. Mobs are currently: [user.allowmobvore ? "Allowed to eat" : "Prevented from eating"] you.", "", "Allow Mob Predation", "Cancel", "Prevent Mob Predation")
		switch(choice)
			if("Cancel")
				return FALSE
			if("Allow Mob Predation")
				user.allowmobvore = TRUE
			if("Prevent Mob Predation")
				user.allowmobvore = FALSE

		message_admins("[key_name(user)] toggled their mob vore preference to [user.allowmobvore] ([user ? "<a href='?_src_=holder;adminplayerobservecoodjump=1;X=[user.loc.];Y=[user.loc.y];Z=[user.loc.z]'>JMP</a>" : "null"])")

		if(user.client.prefs_vr)
			user.client.prefs_vr.allowmobvore = user.allowmobvore

	if(href_list["togglehealbelly"])
		var/choice = alert(user, "This button is for those who don't like healbelly used on them as a mechanic. It does not affect anything, but is displayed under mechanical prefs for ease of quick checks. You are currently: [user.allowmobvore ? "Okay" : "Not Okay"] with players using healbelly on you.", "", "Allow Healing Belly", "Cancel", "Disallow Healing Belly")
		switch(choice)
			if("Cancel")
				return FALSE
			if("Allow Healing Belly")
				user.permit_healbelly = TRUE
			if("Disallow Healing Belly")
				user.permit_healbelly = FALSE

		if(user.client.prefs_vr)
			user.client.prefs_vr.permit_healbelly = user.permit_healbelly

	if(href_list["togglenoisy"])
		var/choice = alert(user, "Toggle audible hunger noises. Currently: [user.noisy ? "Enabled" : "Disabled"]", "", "Enable audible hunger", "Cancel", "Disable audible hunger")
		switch(choice)
			if("Cancel")
				return FALSE
			if("Enable audible hunger")
				user.noisy = TRUE
			if("Disable audible hunger")
				user.noisy = FALSE

	//Refresh when interacted with, returning 1 makes vore_look.Topic update
	return TRUE
