/*	This code is responsible for the examine tab.  When someone examines something, it copies the examined object's description_info,
	description_fluff, and description_antag, and shows it in a new tab.

	In this file, some atom and mob stuff is defined here.  It is defined here instead of in the normal files, to keep the whole system self-contained.
	This means that this file can be unchecked, along with the other examine files, and can be removed entirely with no effort.
*/


/atom/
	var/description_info = null //Helpful blue text.
	var/description_fluff = null //Green text about the atom's fluff, if any exists.
	var/description_antag = null //Malicious red text, for the antags.

//Override these if you need special behaviour for a specific type.
/atom/proc/get_description_info()
	if(description_info)
		return description_info
	return

/atom/proc/get_description_fluff()
	if(description_fluff)
		return description_fluff
	return

/atom/proc/get_description_antag()
	if(description_antag)
		return description_antag
	return

// This one is slightly different, in that it must return a list.
/atom/proc/get_description_interaction()
	return list()

// Quickly adds the boilerplate code to add an image and padding for the image.
/proc/desc_panel_image(var/icon_state)
	return "[icon2html(description_icons[icon_state], usr)]&emsp;"

/mob/living/get_description_fluff()
	if(flavor_text) //Get flavor text for the green text.
		return flavor_text
	else //No flavor text?  Try for hardcoded fluff instead.
		return ..()

/mob/living/carbon/human/get_description_fluff()
	return print_flavor_text(0)

/* The examine panel itself */

/client/var/description_holders[0]

/client/proc/update_description_holders(atom/A, update_antag_info=0)
	examine_icon = null
	description_holders["info"] = A.get_description_info()
	description_holders["fluff"] = A.get_description_fluff()
	description_holders["antag"] = (update_antag_info)? A.get_description_antag() : ""
	description_holders["interactions"] = A.get_description_interaction()

	description_holders["name"] = "[A.name]"
	description_holders["icon"] = A
	description_holders["desc"] = A.desc

//override examinate verb to update description holders when things are examined
//mob verbs are faster than object verbs. See http://www.byond.com/forum/?post=1326139&page=2#comment8198716 for why this isn't atom/verb/examine()
/mob/verb/examinate(atom/A as mob|obj|turf in _validate_atom(A))
	set name = "Examine"
	set category = "IC.Game"

	if((is_blind(src) || src.stat) && !isobserver(src))
		to_chat(src, span_notice("Something is there but you can't see it."))
		return 1

	//Could be gone by the time they finally pick something
	if(!A)
		return 1

	face_atom(A)
	var/list/results = A.examine(src)
	if(!results || !results.len)
		results = list("You were unable to examine that. Tell a developer!")
	var/final_string = span_infoplain("[jointext(results, "<br>")]")
	if(ismob(A)) // mob descriptions matter more than others
		final_string = examine_block(final_string)
	to_chat(src, final_string)
	update_examine_panel(A)

/mob/proc/update_examine_panel(var/atom/A)
	if(client)
		var/is_antag = ((mind && mind.special_role) || isobserver(src)) //ghosts don't have minds
		client.update_description_holders(A, is_antag)
		SSstatpanels.set_examine_tab(client)


/mob/verb/mob_examine()
	set name = "Mob Examine"
	set desc = "Allows one to examine mobs they can see, even from inside of bellies and objects."
	set category = "IC.Game"
	set popup_menu = FALSE

	if((is_blind(src) || src.stat) && !isobserver(src))
		to_chat(src, span_notice("Something is there but you can't see it."))
		return 1
	var/list/E = list()
	if(isAI(src))
		var/mob/living/silicon/ai/my_ai = src
		for(var/e in my_ai.all_eyes)
			var/turf/my_turf = get_turf(e)
			var/foundcam = FALSE
			for(var/obj/cam in view(world.view, my_turf))
				if(istype(cam, /obj/machinery/camera))
					var/obj/machinery/camera/mycam = cam
					if(!mycam.stat)
						foundcam = TRUE
			if(!foundcam)
				continue
			for(var/atom/M in view(world.view, my_turf))
				if(M == src || istype(M, /mob/observer))
					continue
				if(ismob(M) && !M.invisibility)
					if(src && src == M)
						var/list/results = src.examine(src)
						if(!results || !results.len)
							results = list("You were unable to examine that. Tell a developer!")
						to_chat(src, jointext(results, "<br>"))
						update_examine_panel(src)
						return
					else
						E |= M
		if(E.len == 0)
			return
	else
		var/my_turf = get_turf(src)
		for(var/atom/M in view(world.view, my_turf))
			if(ismob(M) && M != src && !istype(M, /mob/observer) && !M.invisibility)
				E |= M
		for(var/turf/T in view(world.view, my_turf))
			if(!isopenspace(T))
				continue
			var/turf/checked = T
			var/keepgoing = TRUE
			while(keepgoing)
				var/checking = GetBelow(checked)
				for(var/atom/m in checking)
					if(ismob(m) && !istype(m, /mob/observer) && !m.invisibility)
						E |= m
				checked = checking
				if(!isopenspace(checked))
					keepgoing = FALSE

	if(E.len == 0)
		to_chat(src, span_notice("There are no mobs to examine."))
		return
	var/atom/B = null
	if(E.len == 1)
		B = pick(E)
	else
		B = tgui_input_list(src, "What would you like to examine?", "Examine", E)
	if(!B)
		return
	if(!isbelly(loc) && !istype(loc, /obj/item/holder) && !isAI(src))
		if(B.z == src.z)
			face_atom(B)
	var/list/results = B.examine(src)
	if(!results || !results.len)
		results = list("You were unable to examine that. Tell a developer!")
	to_chat(src, jointext(results, "<br>"))
	update_examine_panel(B)
