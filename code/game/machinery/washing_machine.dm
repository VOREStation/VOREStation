#define EMPTY_OPEN 1
#define EMPTY_CLOSED 2
#define FULL_OPEN 3
#define FULL_CLOSED 4
#define RUNNING 5
#define BLOODY_OPEN 6 //Not actually used...
#define BLOODY_CLOSED 7
#define BLOODY_RUNNING 8


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
	var/state = EMPTY_OPEN
	var/hacked = TRUE //Bleh, screw hacking, let's have it hacked by default.
	var/gibs_ready = FALSE
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

/obj/machinery/washing_machine/Destroy()
	for(var/atom/movable/washed_items in contents)
		washed_items.forceMove(get_turf(src))
	washing.Cut()
	crayon = null
	. = ..()


/obj/machinery/washing_machine/AltClick()
	start()

/obj/machinery/washing_machine/verb/start_washing()
	set name = "Start Washing"
	set category = "Object"
	set src in oview(1)
	start()

/obj/machinery/washing_machine/proc/start(force, damage_modifier)

	if(!isliving(usr) && !force) //ew ew ew usr, but it's the only way to check.
		return
	if(!damage_modifier)
		damage_modifier = 0.5
	if(state != FULL_CLOSED)
		visible_message("The washing machine buzzes - it can not run in this state!")
		return

	if(locate(/mob,washing))
		state = BLOODY_RUNNING
	else
		state = RUNNING
	update_icon()
	visible_message("The washing machine starts a cycle.")
	playsound(src, 'sound/items/washingmachine.ogg', 50, 1, 1)

	addtimer(CALLBACK(src, PROC_REF(finish_wash), damage_modifier), 2 SECONDS)

/obj/machinery/washing_machine/proc/finish_wash(damage_modifier)
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
			var/max_health_coefficient = (our_human.maxHealth * 0.09) //9 for 100% hp human, 4.5 for 50% hp human (teshari), etc.
			for(var/i=0,i<10,i++)
				our_human.apply_damage(max_health_coefficient*damage_modifier, BRUTE, used_weapon = "spin cycle") //Let's randomly do damage across the body. One limb might get hurt more than the others. At 100% damge mod, does 90% of max hp in damage.
			continue
		mobs.stat = DEAD //Kill them so they can't interact anymore.

	if(has_mobs)
		state = BLOODY_CLOSED
		gibs_ready = TRUE
	else
		state = FULL_CLOSED
	update_icon()

/obj/machinery/washing_machine/verb/climb_out()
	set name = "Climb out"
	set category = "Object"
	set src in usr.loc
	user_climb_out(usr)

/obj/machinery/washing_machine/proc/user_climb_out(mob/user)
	if(user.loc != src) //Have to be in it to climb out of it.
		return
	if(state in list(EMPTY_OPEN, FULL_OPEN, BLOODY_OPEN)) //Door is open, we can climb out easily.
		visible_message("[user] begins to climb out of the [src]!")
		if(do_after(user, 2 SECONDS, target = src))
			if(!(state in list(EMPTY_CLOSED, FULL_CLOSED, BLOODY_CLOSED))) //Someone shut the door while we were trying to climb out!
				user.forceMove(get_turf(src))
				visible_message("[user] climbs out of the [src]!")
			else
				to_chat(user, "Someone shut the door on you!")
	else if(state in list(EMPTY_CLOSED, FULL_CLOSED, BLOODY_CLOSED)) //Door is shut.
		visible_message("[src] begins to rattle and shake!")
		if(do_after(user, 60 SECONDS, target = src))
			visible_message("[user] climbs out of the [src]!")
			attack_hand(user, force = TRUE)

/obj/machinery/washing_machine/container_resist(mob/living/escapee)
	user_climb_out(escapee)

/obj/machinery/washing_machine/update_icon()
	cut_overlays()
	icon_state = "wm_[state]"
	if(panel_open)
		add_overlay("panel")

/obj/machinery/washing_machine/attackby(obj/item/W as obj, mob/user as mob)
	if(state == EMPTY_CLOSED && washing.len < 1)
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
		if(state in list (EMPTY_OPEN, FULL_OPEN, BLOODY_OPEN))
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
		if((state == EMPTY_OPEN) && hacked)
			var/obj/item/grab/G = W
			if(ishuman(G.assailant) && (iscorgi(G.affecting) || ishuman(G.affecting)))
				user.visible_message("[user] begins stuffing [G.affecting] into the [src]!", "You begin stuffing [G.affecting] into the [src]!")
				if(do_after(user, 5 SECONDS, target = src))
					if(state == EMPTY_OPEN) //Checking to make sure nobody closed it before we shoved em in it.
						user.visible_message("[user] stuffs [G.affecting] into the [src] and shuts the door!", "You stuff [G.affecting] into the [src] and shut the door!")
						G.affecting.forceMove(src)
						washing += G.affecting
						qdel(G)
						state = FULL_CLOSED
					else
						to_chat(user, "You can't shove [G.affecting] in unless the washer is empty and open!")
		else
			..()

	else if(is_type_in_list(W, disallowed_types))
		to_chat(user, span_warning("You can't fit \the [W] inside."))
		return

	else if(istype(W, /obj/item/clothing) || istype(W, /obj/item/bedsheet) || istype(W, /obj/item/stack/hairlesshide))
		if(washing.len < 5)
			if(state in list(EMPTY_OPEN, FULL_OPEN))
				user.drop_item()
				W.forceMove(src)
				washing += W
				state = FULL_OPEN
			else
				to_chat(user, span_notice("You can't put the item in right now."))
		else
			to_chat(user, span_notice("The washing machine is full."))
	else
		..()
	update_icon()

/obj/machinery/washing_machine/attack_hand(mob/user, force)
	if(user.loc == src && !force)
		return //No interacting with it from the inside!
	switch(state)
		if(EMPTY_OPEN)
			state = EMPTY_CLOSED
		if(EMPTY_CLOSED)
			state = EMPTY_OPEN
			for(var/atom/movable/O in washing)
				O.forceMove(get_turf(src))
			washing.Cut()
		if(FULL_OPEN)
			state = FULL_CLOSED
		if(FULL_CLOSED)
			for(var/atom/movable/O in washing)
				O.forceMove(get_turf(src))
			crayon = null
			washing.Cut()
			state = EMPTY_OPEN
		if(RUNNING)
			if(user)
				to_chat(user, span_warning("The [src] is busy."))
		if(BLOODY_OPEN)
			state = BLOODY_CLOSED
		if(BLOODY_CLOSED)
			if(gibs_ready)
				gibs_ready = FALSE
				for(var/mob/living/mobs in washing)
					if(ishuman(mobs)) //Humans have special handling.
						continue
					mobs.gib()
			for(var/atom/movable/O in washing)
				O.forceMove(get_turf(src))
			crayon = null
			state = EMPTY_OPEN
			washing.Cut()

	update_icon()

#undef EMPTY_OPEN
#undef EMPTY_CLOSED
#undef FULL_OPEN
#undef FULL_CLOSED
#undef RUNNING
#undef BLOODY_OPEN
#undef BLOODY_CLOSED
#undef BLOODY_RUNNING
