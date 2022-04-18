/obj/structure/noticeboard
	name = "notice board"
	desc = "A board for pinning important notices upon."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "nboard00"
	layer = ABOVE_WINDOW_LAYER
	density = FALSE
	anchored = TRUE
	var/list/notices
	var/base_icon_state = "nboard0"
	var/const/max_notices = 5

/obj/structure/noticeboard/Initialize()
	. = ..()

	// Grab any mapped notices.
	notices = list()
	for(var/obj/item/paper/note in get_turf(src))
		note.forceMove(src)
		LAZYADD(notices, note)
		if(LAZYLEN(notices) >= max_notices)
			break

	update_icon()

/obj/structure/noticeboard/proc/add_paper(var/atom/movable/paper, var/skip_icon_update)
	if(istype(paper))
		LAZYDISTINCTADD(notices, paper)
		paper.forceMove(src)
		if(!skip_icon_update)
			update_icon()

/obj/structure/noticeboard/proc/remove_paper(var/atom/movable/paper, var/skip_icon_update)
	if(istype(paper) && paper.loc == src)
		paper.dropInto(loc)
		LAZYREMOVE(notices, paper)
		SSpersistence.forget_value(paper, /datum/persistent/paper)
		if(!skip_icon_update)
			update_icon()

/obj/structure/noticeboard/proc/dismantle()
	for(var/thing in notices)
		remove_paper(thing, skip_icon_update = TRUE)
	new /obj/item/stack/material/wood(get_turf(src))
	qdel(src)

/obj/structure/noticeboard/Destroy()
	QDEL_NULL_LIST(notices)
	. = ..()

/obj/structure/noticeboard/ex_act(severity)
	dismantle()

/obj/structure/noticeboard/update_icon()
	icon_state = "[base_icon_state][LAZYLEN(notices)]"

<<<<<<< HEAD
/obj/structure/noticeboard/attackby(obj/item/I, mob/user)
	if(I.is_screwdriver())
		var/choice = tgui_input_list(usr, "Which direction do you wish to place the noticeboard?", "Noticeboard Offset", list("North", "South", "East", "West", "No Offset"))
		if(choice && Adjacent(user) && I.loc == user && !user.incapacitated())
=======
/obj/structure/noticeboard/attackby(var/obj/item/thing, var/mob/user)
	if(thing.is_screwdriver())
		var/choice = input("Which direction do you wish to place the noticeboard?", "Noticeboard Offset") as null|anything in list("North", "South", "East", "West")
		if(choice && Adjacent(user) && thing.loc == user && !user.incapacitated())
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
			playsound(loc, 'sound/items/Screwdriver.ogg', 50, 1)
			switch(choice)
				if("North")
					pixel_x = 0
					pixel_y = 32
				if("South")
					pixel_x = 0
					pixel_y = -32
				if("East")
					pixel_x = 32
					pixel_y = 0
				if("West")
					pixel_x = -32
					pixel_y = 0
				if("No Offset")
					return
		return
	else if(I.is_wrench())
		visible_message("<span class='warning'>[user] begins dismantling [src].</span>")
		playsound(loc, 'sound/items/Ratchet.ogg', 50, 1)
		if(do_after(user, 50, src))
			visible_message("<span class='danger'>[user] has dismantled [src]!</span>")
			dismantle()
		return
<<<<<<< HEAD
	else if(istype(I, /obj/item/weapon/paper) || istype(I, /obj/item/weapon/photo))
=======
	else if(istype(thing, /obj/item/paper) || istype(thing, /obj/item/photo))
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
		if(jobban_isbanned(user, "Graffiti"))
			to_chat(user, "<span class='warning'>You are banned from leaving persistent information across rounds.</span>")
		else
			if(LAZYLEN(notices) < max_notices && user.unEquip(I, src))
				add_fingerprint(user)
				add_paper(I)
				to_chat(user, "<span class='notice'>You pin [I] to [src].</span>")
				SSpersistence.track_value(I, /datum/persistent/paper)
			else
				to_chat(user, "<span class='warning'>You hesitate, certain [I] will not be seen among the many others already attached to \the [src].</span>")
		return
	return ..()

/obj/structure/noticeboard/attack_ai(var/mob/user)
	examine(user)

/obj/structure/noticeboard/attack_hand(var/mob/user)
	examine(user)

<<<<<<< HEAD
/obj/structure/noticeboard/examine(mob/user)
	tgui_interact(user)
	return ..()

/obj/structure/noticeboard/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "NoticeBoard", name)
		ui.open()

/obj/structure/noticeboard/tgui_data(mob/user)
	var/list/data = ..()
	
	
	var/list/tgui_notices = list()
	for(var/obj/item/I in src.notices)
		tgui_notices.Add(list(list(
			"ispaper" = istype(I, /obj/item/weapon/paper),
			"isphoto" = istype(I, /obj/item/weapon/photo),
			"name" = I.name,
			"ref" = "\ref[I]",
		)))
	data["notices"] = tgui_notices
	return data

/obj/structure/noticeboard/tgui_act(action, params)
	if(..())
		return TRUE

	switch(action)
		if("read")
			var/obj/item/weapon/paper/P = locate(params["ref"])
			if(P && P.loc == src)
				P.show_content(usr)
			. = TRUE

		if("look")
			var/obj/item/weapon/photo/P = locate(params["ref"])
			if(P && P.loc == src)
				P.show(usr)
			. = TRUE

		if("remove")
			if(!in_range(src, usr))
				return FALSE
			var/obj/item/I = locate(params["ref"])
			remove_paper(I)
			if(istype(I))
				usr.put_in_hands(I)
			add_fingerprint(usr)
			. = TRUE

		if("write")
			if(!in_range(src, usr))
				return FALSE
			var/obj/item/P = locate(params["ref"])
			if((P && P.loc == src)) //if the paper's on the board
				var/mob/living/M = usr
				if(istype(M))
					var/obj/item/weapon/pen/E = M.get_type_in_hands(/obj/item/weapon/pen)
					if(E)
						add_fingerprint(M)
						P.attackby(E, usr)
					else
						to_chat(M, "<span class='notice'>You'll need something to write with!</span>")
						. = TRUE
=======
/obj/structure/noticeboard/examine(var/mob/user)
	. = ..()
	if(.)
		var/list/dat = list("<table>")
		for(var/thing in notices)
			LAZYADD(dat, "<tr><td>[thing]</td><td>")
			if(istype(thing, /obj/item/paper))
				LAZYADD(dat, "<a href='?src=\ref[src];read=\ref[thing]'>Read</a><a href='?src=\ref[src];write=\ref[thing]'>Write</a>")
			else if(istype(thing, /obj/item/photo))
				LAZYADD(dat, "<a href='?src=\ref[src];look=\ref[thing]'>Look</a>")
			LAZYADD(dat, "<a href='?src=\ref[src];remove=\ref[thing]'>Remove</a></td></tr>")
		var/datum/browser/popup = new(user, "noticeboard-\ref[src]", "Noticeboard")
		popup.set_content(jointext(dat, null))
		popup.open()

/obj/structure/noticeboard/Topic(var/mob/user, var/list/href_list)
	if(href_list["read"])
		var/obj/item/paper/P = locate(href_list["read"])
		if(P && P.loc == src)
			P.show_content(user)
		. = TOPIC_HANDLED

	if(href_list["look"])
		var/obj/item/photo/P = locate(href_list["look"])
		if(P && P.loc == src)
			P.show(user)
		. = TOPIC_HANDLED

	if(href_list["remove"])
		remove_paper(locate(href_list["remove"]))
		add_fingerprint(user)
		. = TOPIC_REFRESH

	if(href_list["write"])
		if((usr.stat || usr.restrained())) //For when a player is handcuffed while they have the notice window open
			return
		var/obj/item/P = locate(href_list["write"])
		if((P && P.loc == src)) //ifthe paper's on the board
			var/mob/living/M = usr
			if(istype(M))
				var/obj/item/pen/E = M.get_type_in_hands(/obj/item/pen)
				if(E)
					add_fingerprint(M)
					P.attackby(E, usr)
				else
					to_chat(M, "<span class='notice'>You'll need something to write with!</span>")
					. = TOPIC_REFRESH

	if(. == TOPIC_REFRESH)
		interact(user)
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon

/obj/structure/noticeboard/anomaly
	notices = 5
	icon_state = "nboard05"

<<<<<<< HEAD
/obj/structure/noticeboard/anomaly/New()
	var/obj/item/weapon/paper/P = new()
	P.name = "Memo RE: proper analysis procedure"
	P.info = "<br>We keep test dummies in pens here for a reason, so standard procedure should be to activate newfound alien artifacts and place the two in close proximity. Promising items I might even approve monkey testing on."
	P.stamped = list(/obj/item/weapon/stamp/rd)
	P.add_overlay("paper_stamped_rd")
	contents += P
=======
/obj/structure/noticeboard/anomaly/Initialize()
	. = ..()
	
	var/obj/item/paper/P = new()
	P.name = "Memo RE: proper analysis procedure"
	P.info = "<br>We keep test dummies in pens here for a reason, so standard procedure should be to activate newfound alien artifacts and place the two in close proximity. Promising items I might even approve monkey testing on."
	P.stamped = list(/obj/item/stamp/rd)
	P.overlays = list("paper_stamped_rd")
	src.contents += P
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon

	P = new()
	P.name = "Memo RE: materials gathering"
	P.info = "Corasang,<br>the hands-on approach to gathering our samples may very well be slow at times, but it's safer than allowing the blundering miners to roll willy-nilly over our dig sites in their mechs, destroying everything in the process. And don't forget the escavation tools on your way out there!<br>- R.W"
<<<<<<< HEAD
	P.stamped = list(/obj/item/weapon/stamp/rd)
	P.add_overlay("paper_stamped_rd")
	contents += P
=======
	P.stamped = list(/obj/item/stamp/rd)
	P.overlays = list("paper_stamped_rd")
	src.contents += P
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon

	P = new()
	P.name = "Memo RE: ethical quandaries"
	P.info = "Darion-<br><br>I don't care what his rank is, our business is that of science and knowledge - questions of moral application do not come into this. Sure, so there are those who would employ the energy-wave particles my modified device has managed to abscond for their own personal gain, but I can hardly see the practical benefits of some of these artifacts our benefactors left behind. Ward--"
<<<<<<< HEAD
	P.stamped = list(/obj/item/weapon/stamp/rd)
	P.add_overlay("paper_stamped_rd")
	contents += P
=======
	P.stamped = list(/obj/item/stamp/rd)
	P.overlays = list("paper_stamped_rd")
	src.contents += P
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon

	P = new()
	P.name = "READ ME! Before you people destroy any more samples"
	P.info = "how many times do i have to tell you people, these xeno-arch samples are del-i-cate, and should be handled so! careful application of a focussed, concentrated heat or some corrosive liquids should clear away the extraneous carbon matter, while application of an energy beam will most decidedly destroy it entirely - like someone did to the chemical dispenser! W, <b>the one who signs your paychecks</b>"
<<<<<<< HEAD
	P.stamped = list(/obj/item/weapon/stamp/rd)
	P.add_overlay("paper_stamped_rd")
	contents += P
=======
	P.stamped = list(/obj/item/stamp/rd)
	P.overlays = list("paper_stamped_rd")
	src.contents += P
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon

	P = new()
	P.name = "Reminder regarding the anomalous material suits"
	P.info = "Do you people think the anomaly suits are cheap to come by? I'm about a hair trigger away from instituting a log book for the damn things. Only wear them if you're going out for a dig, and for god's sake don't go tramping around in them unless you're field testing something, R"
<<<<<<< HEAD
	P.stamped = list(/obj/item/weapon/stamp/rd)
	P.add_overlay("paper_stamped_rd")
	contents += P
=======
	P.stamped = list(/obj/item/stamp/rd)
	P.overlays = list("paper_stamped_rd")
	src.contents += P
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
