/obj/machinery/washing_machine
	name = "Washing Machine"
	desc = "Not a hiding place. Unfit for pets."
	icon = 'icons/obj/machines/washing_machine_vr.dmi' //VOREStation Edit
	icon_state = "wm_1" //VOREStation Edit
	density = TRUE
	anchored = TRUE
	clicksound = "button"
	clickvol = 40

	circuit = /obj/item/circuitboard/washing
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

/obj/machinery/washing_machine/Initialize(mapload)
	. = ..()
	default_apply_parts()
	AddElement(/datum/element/climbable)

/obj/machinery/washing_machine/AltClick()
	start()

/obj/machinery/washing_machine/verb/start_washing()
	set name = "Start Washing"
	set category = "Object"
	set src in oview(1)
	start()

/obj/machinery/washing_machine/proc/start(force)

	if(!isliving(usr) && !force) //ew ew ew usr, but it's the only way to check.
		return

	if(state != 4)
		visible_message("The washing machine buzzes - it can not run in this state!")
		return

	if(locate(/mob,washing))
		state = 8
	else
		state = 5
	update_icon()
	visible_message("The washing machine starts a cycle.")
	playsound(src, 'sound/items/washingmachine.ogg', 50, 1, 1)

	addtimer(CALLBACK(src, PROC_REF(finish_wash)), 2 SECONDS)

/obj/machinery/washing_machine/proc/finish_wash()
	for(var/atom/A in washing)
		A.wash(CLEAN_ALL)

	//Tanning!
	for(var/obj/item/stack/hairlesshide/HH in washing)
		var/obj/item/stack/wetleather/WL = new(src, HH.get_amount())
		washing -= HH
		HH.forceMove(get_turf(src))
		HH.use(HH.get_amount())

		washing += WL
	var/has_mobs = FALSE
	for(var/mob/living/mobs in washing)
		has_mobs = TRUE
		if(ishuman(mobs))
			var/mob/living/carbon/human/our_human = mobs
			for(var/obj/item/organ/external/limb in our_human.organs) //In total, you should have 11 limbs (generally, unless you have an amputation). The full omen variant we want to leave you at 1 hp, the trait version less. As of writing, the trait version is 25% of the damage, so you take 24.75 across all limbs.
				our_human.apply_damage(9, BRUTE, used_weapon = "spin cycle") //Let's randomly do damage across the body. One limb might get hurt more than the others
			continue
		mobs.stat = DEAD //Kill them so they can't interact anymore.

	if(has_mobs)
		state = 7
		gibs_ready = 1
	else
		state = 4
	update_icon()

/obj/machinery/washing_machine/verb/climb_out()
	set name = "Climb out"
	set category = "Object"
	set src in usr.loc

	if((state in list(1,3,6)) && do_after(usr, 2 SECONDS, target = src))
		usr.forceMove(get_turf(src))

/obj/machinery/washing_machine/update_icon()
	cut_overlays()
	icon_state = "wm_[state]"
	if(panel_open)
		add_overlay("panel")

/obj/machinery/washing_machine/attackby(obj/item/W as obj, mob/user as mob)
	if(state == 2 && washing.len < 1)
		if(default_deconstruction_screwdriver(user, W))
			return
		if(default_deconstruction_crowbar(user, W))
			return
		if(default_unfasten_wrench(user, W, 40))
			return
	/*if(W.has_tool_quality(TOOL_SCREWDRIVER))
		panel = !panel
		to_chat(user, span_notice("You [panel ? "open" : "close"] the [src]'s maintenance panel"))*/
	if(istype(W,/obj/item/pen/crayon) || istype(W,/obj/item/stamp))
		if(state in list(	1, 3, 6))
			if(!crayon)
				user.drop_item()
				crayon = W
				crayon.forceMove(src)
				crayon.loc = src
			else
				..()
		else
			..()
	else if(istype(W,/obj/item/grab))
		if((state == 1) && hacked)
			var/obj/item/grab/G = W
			if(ishuman(G.assailant) && (iscorgi(G.affecting) || ishuman(G.affecting)))
				if(do_after(user, 5 SECONDS, target = src))
					G.affecting.forceMove(src)
					qdel(G)
					state = 3
		else
			..()

	else if(is_type_in_list(W, disallowed_types))
		to_chat(user, span_warning("You can't fit \the [W] inside."))
		return

	else if(istype(W, /obj/item/clothing) || istype(W, /obj/item/bedsheet) || istype(W, /obj/item/stack/hairlesshide))
		if(washing.len < 5)
			if(state in list(1, 3))
				user.drop_item()
				W.forceMove(src)
				washing += W
				state = 3
			else
				to_chat(user, span_notice("You can't put the item in right now."))
		else
			to_chat(user, span_notice("The washing machine is full."))
	else
		..()
	update_icon()

/obj/machinery/washing_machine/attack_hand(mob/user as mob)
	if(user.loc == src)
		return //No interacting with it from the inside!
	switch(state)
		if(1)
			state = 2
		if(2)
			state = 1
			for(var/atom/movable/O in washing)
				O.forceMove(get_turf(src))
			washing.Cut()
		if(3)
			state = 4
		if(4)
			state = 3
			for(var/atom/movable/O in washing)
				O.forceMove(get_turf(src))
			crayon = null
			washing.Cut()
			state = 1
		if(5)
			to_chat(user, span_warning("The [src] is busy."))
		if(6)
			state = 7
		if(7)
			if(gibs_ready)
				gibs_ready = 0
				for(var/mob/living/mobs in washing)
					if(ishuman(mobs)) //Humans have special handling.
						continue
					mobs.gib()
			for(var/atom/movable/O in washing)
				O.forceMove(get_turf(src))
			crayon = null
			state = 1
			washing.Cut()

	update_icon()
