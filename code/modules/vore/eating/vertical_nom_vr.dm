/mob/living/proc/vertical_nom()
	set name = "Nom from Above"
	set desc = "Allows you to eat people who are below your tile or adjacent one. Requires passability."
	set category = "Abilities"

	if(stat == DEAD || paralysis || weakened || stunned)
		to_chat(src, "<span class='notice'>You cannot do that while in your current state.</span>")
		return

	if(!(src.vore_selected))
		to_chat(src, "<span class='notice'>No selected belly found.</span>")
		return

	var/list/targets = list()

	for(var/turf/T in range(1, src))
		if(isopenspace(T))
			while(isopenspace(T))
				T = GetBelow(T)
			if(T)
				for(var/mob/living/L in T)
					if(L.devourable && L.can_be_drop_prey)
						targets += L

	if(!(targets.len))
		to_chat(src, "<span class='notice'>No eligible targets found.</span>")
		return

	var/mob/living/target = tgui_input_list(src, "Please select a target.", "Victim", targets)

	if(!target)
		return

	to_chat(target, "<span class='vwarning'>You feel yourself being pulled up by something... Or someone?!</span>")
	var/starting_loc = target.loc

	if(do_after(src, 50))
		if(target.loc != starting_loc)
			to_chat(target, "<span class='vwarning'>You have interrupted whatever that was...</span>")
			to_chat(src, "<span class='vnotice'>They got away.</span>")
			return
		if(target.buckled)
			target.buckled.unbuckle_mob()
		target.visible_message("<span class='vwarning'>\The [target] suddenly disappears somewhere above!</span>",\
			"<span class='vdanger'>You are dragged above and feel yourself slipping directly into \the [src]'s [vore_selected]!</span>")
		to_chat(src, "<span class='vnotice'>You successfully snatch \the [target], slipping them into your [vore_selected].</span>")
		target.forceMove(src.vore_selected)
