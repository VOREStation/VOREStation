/*
 * SeedBag
 */
//uncomment when this is updated to match storage update
/*
/obj/item/seedbag
	icon = 'icons/obj/hydroponics_machines.dmi'
	icon_state = "seedbag"
	name = "Seed Bag"
	desc = "A small satchel made for organizing seeds."
	var/mode = 1;  //0 = pick one at a time, 1 = pick all on tile
	var/capacity = 500; //the number of seeds it can carry.
	slot_flags = SLOT_BELT
	w_class = ITEMSIZE_TINY
	var/list/item_quants = list()

/obj/item/seedbag/attack_self(mob/user)
	user.machine = src
	interact(user)

/obj/item/seedbag/verb/toggle_mode()
	set name = "Switch Bagging Method"
	set category = "Object"

	mode = !mode
	switch (mode)
		if(1)
			to_chat(usr, "The bag now picks up all seeds in a tile at once.")
		if(0)
			to_chat(usr, "The bag now picks up one seed pouch at a time.")

/obj/item/seeds/attackby(var/obj/item/O, var/mob/user)
	..()
	if (istype(O, /obj/item/seedbag))
		var/obj/item/seedbag/S = O
		if (S.mode == 1)
			for (var/obj/item/seeds/G in locate(src.x,src.y,src.z))
				if (S.contents.len < S.capacity)
					S.contents += G;
					if(S.item_quants[G.name])
						S.item_quants[G.name]++
					else
						S.item_quants[G.name] = 1
				else
					to_chat(user, span_warning("The seed bag is full."))
					S.updateUsrDialog(user)
					return
			to_chat(user, span_notice("You pick up all the seeds."))
		else
			if (S.contents.len < S.capacity)
				S.contents += src;
				if(S.item_quants[name])
					S.item_quants[name]++
				else
					S.item_quants[name] = 1
			else
				to_chat(user, span_warning("The seed bag is full."))
		S.updateUsrDialog(user)
	return

/obj/item/seedbag/interact(mob/user)

	var/dat = "<TT><b>Select an item:</b><br>"

	if (contents.len == 0)
		dat += span_red("No seeds loaded!")
	else
		for (var/O in item_quants)
			if(item_quants[O] > 0)
				var/N = item_quants[O]
				dat += span_blue(span_bold("[capitalize(O)]") + ": [N] ")
				dat += "<a href='byond://?src=\ref[src];vend=[O]'>Vend</A>"
				dat += "<br>"

		dat += "<br><a href='byond://?src=\ref[src];unload=1'>Unload All</A>"
		dat += "</TT>"
	user << browse("<html><HEAD><TITLE>Seedbag Supplies</TITLE></HEAD><TT>[dat]</TT></html>", "window=seedbag")
	onclose(user, "seedbag")
	return

/obj/item/seedbag/Topic(href, href_list)
	if(..())
		return

	usr.machine = src
	if ( href_list["vend"] )
		var/N = href_list["vend"]

		if(item_quants[N] <= 0) // Sanity check, there are probably ways to press the button when it shouldn't be possible.
			return

		item_quants[N] -= 1
		for(var/obj/O in contents)
			if(O.name == N)
				O.loc = get_turf(src)
				usr.put_in_hands(O)
				break

	else if ( href_list["unload"] )
		item_quants.Cut()
		for(var/obj/O in contents )
			O.loc = get_turf(src)

	src.updateUsrDialog(usr)
	return

/obj/item/seedbag/updateUsrDialog(mob/user)
	var/list/nearby = range(1, src)
	for(var/mob/M in nearby)
		if ((M.client && M.machine == src))
			src.attack_self(M)
*/
