/obj/machinery/washing_machine
	name = "Washing Machine"
	icon = 'icons/obj/machines/washing_machine.dmi'
	icon_state = "wm_10"
	density = 1
	anchored = 1.0
	circuit = /obj/item/weapon/circuitboard/washing
	var/state = 1
	//1 = empty, open door
	//2 = empty, closed door
	//3 = full, open door
	//4 = full, closed door
	//5 = running
	//6 = blood, open door
	//7 = blood, closed door
	//8 = blood, running
	var/hacked = 1 //Bleh, screw hacking, let's have it hacked by default.
	//0 = not hacked
	//1 = hacked
	var/gibs_ready = 0
	var/obj/crayon
	var/list/washing = list()
	var/list/disallowed_types = list(
		/obj/item/clothing/suit/space,
		/obj/item/clothing/head/helmet/space
		)

/obj/machinery/washing_machine/New()
	..()
	component_parts = list()
	component_parts += new /obj/item/weapon/stock_parts/motor(src)
	component_parts += new /obj/item/weapon/stock_parts/gear(src)
	component_parts += new /obj/item/weapon/stock_parts/gear(src)
	RefreshParts()

/obj/machinery/washing_machine/verb/start()
	set name = "Start Washing"
	set category = "Object"
	set src in oview(1)

	if(!istype(usr, /mob/living)) //ew ew ew usr, but it's the only way to check.
		return

	if(state != 4)
		usr << "The washing machine cannot run in this state."
		return

	if(locate(/mob,washing))
		state = 8
	else
		state = 5
	update_icon()
	playsound(src, 'sound/items/washingmachine.ogg', 50, 1, 1)
	sleep(200)
	for(var/atom/A in washing)
		A.clean_blood()

	for(var/obj/item/I in washing)
		I.decontaminate()

	//Tanning!
	for(var/obj/item/stack/material/hairlesshide/HH in washing)
		var/obj/item/stack/material/wetleather/WL = new(src)
		WL.amount = HH.amount
		qdel(HH)

	if(locate(/mob,washing))
		state = 7
		gibs_ready = 1
	else
		state = 4
	update_icon()

/obj/machinery/washing_machine/verb/climb_out()
	set name = "Climb out"
	set category = "Object"
	set src in usr.loc

	sleep(20)
	if(state in list(1,3,6))
		usr.loc = src.loc

/obj/machinery/washing_machine/update_icon()
	icon_state = "wm_[state][panel_open]"

/obj/machinery/washing_machine/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(state == 2 && washing.len < 1)
		if(default_deconstruction_screwdriver(user, W))
			return
		if(default_deconstruction_crowbar(user, W))
			return
		if(default_unfasten_wrench(user, W, 40))
			return
	/*if(W.is_screwdriver())
		panel = !panel
		user << "<span class='notice'>You [panel ? "open" : "close"] the [src]'s maintenance panel</span>"*/
	if(istype(W,/obj/item/weapon/pen/crayon) || istype(W,/obj/item/weapon/stamp))
		if(state in list(	1, 3, 6))
			if(!crayon)
				user.drop_item()
				crayon = W
				crayon.loc = src
			else
				..()
		else
			..()
	else if(istype(W,/obj/item/weapon/grab))
		if((state == 1) && hacked)
			var/obj/item/weapon/grab/G = W
			if(ishuman(G.assailant) && iscorgi(G.affecting))
				G.affecting.loc = src
				qdel(G)
				state = 3
		else
			..()

	else if(is_type_in_list(W, disallowed_types))
		user << "<span class='warning'>You can't fit \the [W] inside.</span>"
		return

	else if(istype(W, /obj/item/clothing) || istype(W, /obj/item/weapon/bedsheet))
		if(washing.len < 5)
			if(state in list(1, 3))
				user.drop_item()
				W.loc = src
				washing += W
				state = 3
			else
				user << "<span class='notice'>You can't put the item in right now.</span>"
		else
			user << "<span class='notice'>The washing machine is full.</span>"
	else
		..()
	update_icon()

/obj/machinery/washing_machine/attack_hand(mob/user as mob)
	switch(state)
		if(1)
			state = 2
		if(2)
			state = 1
			for(var/atom/movable/O in washing)
				O.loc = src.loc
			washing.Cut()
		if(3)
			state = 4
		if(4)
			state = 3
			for(var/atom/movable/O in washing)
				O.loc = src.loc
			crayon = null
			washing.Cut()
			state = 1
		if(5)
			user << "<span class='warning'>The [src] is busy.</span>"
		if(6)
			state = 7
		if(7)
			if(gibs_ready)
				gibs_ready = 0
				if(locate(/mob,washing))
					var/mob/M = locate(/mob,washing)
					M.gib()
			for(var/atom/movable/O in washing)
				O.loc = src.loc
			crayon = null
			state = 1
			washing.Cut()

	update_icon()