/mob/verb/mob_examine(atom/A as mob)
	set name = "Mob Examine"
	set desc = "Allows one to examine mobs they can see, even from inside of bellies and objects."
	set category = "IC"

	if((is_blind(src) || usr.stat) && !isobserver(src))
		to_chat(src, "<span class='notice'>Something is there but you can't see it.</span>")
		return 1

	if(!isbelly(loc) && !istype(loc, /obj/item/weapon/holder) && !isAI(src))
		examinate(A)
		return
	var/list/E = list()
	if(isAI(src))
		var/mob/living/silicon/ai/my_ai = src
		for(var/e in my_ai.all_eyes)
			for(var/atom/M in view(world.view, get_turf(e)))
				if(M == src || istype(M, /mob/observer))
					continue
				if(ismob(M))
					if(A && A == M)
						var/list/results = A.examine(src)
						if(!results || !results.len)
							results = list("You were unable to examine that. Tell a developer!")
						to_chat(src, jointext(results, "<br>"))
						update_examine_panel(A)
						return
					else
						E |= M	
		if(E.len == 0)
			return
	else
		for(var/atom/M in view(world.view, get_turf(src)))
			if(M == src || istype(M, /mob/observer))
				continue
			E |= M	
	if(E.len == 0)
		return
	if(A && A in E)
		var/list/results = A.examine(src)
		if(!results || !results.len)
			results = list("You were unable to examine that. Tell a developer!")
			to_chat(src, jointext(results, "<br>"))
			update_examine_panel(A)
			return
	var/atom/B = input(usr, "What would you like to examine?", "Examine") as mob in E
	if(!B)
		return
	var/list/results = B.examine(src)
	if(!results || !results.len)
		results = list("You were unable to examine that. Tell a developer!")
	to_chat(src, jointext(results, "<br>"))
	update_examine_panel(B)

/turf/simulated/open/verb/examine_below(mob/usr)
	set name = "Examine Below"
	set desc = "Allows one to examine things below them."
	set src in oview(7)

	
	var/list/E = list()
	var/list/T = list()
	
	var/keepgoing = TRUE
	while(keepgoing)
		var/t = GetBelow(src)
		T |= t
		if(!isopenspace(t))
			keepgoing = FALSE
	
	for(var/trf in T)
		for(var/O in trf)
			if(isopenspace(O))
				continue
			E |= O

	if(E.len == 0)
		return
	var/atom/B = input(usr, "What would you like to examine?", "Examine") as anything in E
	if(!B)
		return
	var/list/results = B.examine(usr)
	if(!results || !results.len)
		results = list("You were unable to examine that. Tell a developer!")
	to_chat(usr, jointext(results, "<br>"))
	usr.update_examine_panel(B)