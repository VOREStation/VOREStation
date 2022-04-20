/mob/verb/mob_examine()
	set name = "Mob Examine"
	set desc = "Allows one to examine mobs they can see, even from inside of bellies and objects."
	set category = "IC"
	set popup_menu = FALSE

	if((is_blind(src) || src.stat) && !isobserver(src))
		to_chat(src, "<span class='notice'>Something is there but you can't see it.</span>")
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
		to_chat(src, SPAN_NOTICE("There are no mobs to examine."))
		return
	var/atom/B = null
	if(E.len == 1)
		B = pick(E)
	else
		B = tgui_input_list(src, "What would you like to examine?", "Examine", E)
	if(!B)
		return
	if(!isbelly(loc) && !istype(loc, /obj/item/weapon/holder) && !isAI(src))
		if(B.z == src.z)
			face_atom(B)
	var/list/results = B.examine(src)
	if(!results || !results.len)
		results = list("You were unable to examine that. Tell a developer!")
	to_chat(src, jointext(results, "<br>"))
	update_examine_panel(B)