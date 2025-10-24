/obj/vehicle/train/engine
	name = "cargo train tug"
	desc = "A ridable electric car designed for pulling cargo trolleys."
	icon = 'icons/obj/vehicles.dmi'
	description_info = "Use ctrl-click to quickly toggle the engine if you're adjacent (only when vehicle is stationary). Alt-click will grab the keys, if present."
	icon_state = "cargo_engine"
	on = 0
	powered = 1
	locked = 0

	load_item_visible = 1
	load_offset_x = 0
	mob_offset_y = 7

	var/speed_mod = 1.1
	var/car_limit = 3		//how many cars an engine can pull before performance degrades
	active_engines = 1
	var/obj/item/key/key
	var/key_type = /obj/item/key/cargo_train

/obj/item/key/cargo_train
	name = "key"
	desc = "A keyring with a small steel key, and a yellow fob reading \"Choo Choo!\"."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "train_keys"
	w_class = ITEMSIZE_TINY

/obj/vehicle/train/trolley
	name = "cargo train trolley"
	desc = "A large, flat platform made for putting things on. Or people."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "cargo_trailer"
	anchored = FALSE
	passenger_allowed = 0
	locked = 0

	load_item_visible = 1
	load_offset_x = 0
	load_offset_y = 7
	mob_offset_y = 8

//-------------------------------------------
// Standard procs
//-------------------------------------------
/obj/vehicle/train/engine/Initialize(mapload)
	. = ..()
	cell = new /obj/item/cell/high(src)
	key = new key_type(src)
	var/image/I = new(icon = 'icons/obj/vehicles.dmi', icon_state = "cargo_engine_overlay", layer = src.layer + 0.2) //over mobs
	add_overlay(I)
	update_icon()
	turn_off()	//so engine verbs are correctly set

/obj/vehicle/train/engine/Move(atom/newloc, direct = 0, movetime)
	if(on && cell.charge < charge_use)
		turn_off()
		update_stats()
		if(load && is_train_head())
			to_chat(load, "The drive motor briefly whines, then drones to a stop.")

	if(is_train_head() && !on)
		return FALSE

	//space check ~no flying space trains sorry
	if(on && isnonsolidturf(newloc))
		return FALSE

	return ..()

/obj/vehicle/train/trolley/attackby(obj/item/W as obj, mob/user as mob)
	if(open && W.has_tool_quality(TOOL_WIRECUTTER))
		passenger_allowed = !passenger_allowed
		user.visible_message(span_notice("[user] [passenger_allowed ? "cuts" : "mends"] a cable in [src]."),span_notice("You [passenger_allowed ? "cut" : "mend"] the load limiter cable."))
	else
		..()

/obj/vehicle/train/engine/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, key_type))
		if(!key)
			user.drop_item()
			W.forceMove(src)
			key = W
			verbs += /obj/vehicle/train/engine/verb/remove_key
		return
	..()

/*
//cargo trains are open topped, so there is a chance the projectile will hit the mob ridding the train instead
/obj/vehicle/train/cargo/bullet_act(var/obj/item/projectile/Proj)
	if(has_buckled_mobs() && prob(70))
		var/mob/living/L = pick(buckled_mobs)
		L.bullet_act(Proj)
		return
	..()

/obj/vehicle/train/cargo/update_icon()
	if(open)
		icon_state = initial(icon_state) + "_open"
	else
		icon_state = initial(icon_state)
*/

/obj/vehicle/train/trolley/insert_cell(var/obj/item/cell/C, var/mob/living/carbon/human/H)
	return

/obj/vehicle/train/engine/insert_cell(var/obj/item/cell/C, var/mob/living/carbon/human/H)
	..()
	update_stats()

/obj/vehicle/train/engine/remove_cell(var/mob/living/carbon/human/H)
	..()
	update_stats()

/obj/vehicle/train/engine/Bump(atom/Obstacle)
	var/obj/machinery/door/D = Obstacle
	var/mob/living/carbon/human/H = load
	if(istype(D) && istype(H))
		D.Bumped(H)		//a little hacky, but hey, it works, and respects access rights

	..()

/obj/vehicle/train/trolley/Bump(atom/Obstacle)
	if(!lead)
		return //so people can't knock others over by pushing a trolley around
	..()

//-------------------------------------------
// Train procs
//-------------------------------------------
/obj/vehicle/train/engine/turn_on()
	if(!key)
		return
	if(!cell)
		return
	else
		..()
		update_stats()

		verbs -= /obj/vehicle/train/engine/verb/stop_engine
		verbs -= /obj/vehicle/train/engine/verb/start_engine

		if(on)
			verbs += /obj/vehicle/train/engine/verb/stop_engine
		else
			verbs += /obj/vehicle/train/engine/verb/start_engine

/obj/vehicle/train/engine/turn_off()
	..()

	verbs -= /obj/vehicle/train/engine/verb/stop_engine
	verbs -= /obj/vehicle/train/engine/verb/start_engine

	if(!on)
		verbs += /obj/vehicle/train/engine/verb/start_engine
	else
		verbs += /obj/vehicle/train/engine/verb/stop_engine

/obj/vehicle/train/RunOver(var/mob/living/M)
	if(pulledby == M) // Don't destroy people pulling vehicles up stairs
		return

	var/list/parts = list(BP_HEAD, BP_TORSO, BP_L_LEG, BP_R_LEG, BP_L_ARM, BP_R_ARM)

	M.apply_effects(5, 5)
	for(var/i = 0, i < rand(1,3), i++)
		M.apply_damage(rand(1,5), BRUTE, pick(parts))

/obj/vehicle/train/trolley/RunOver(var/mob/living/M)
	..()
	attack_log += text("\[[time_stamp()]\] [span_red("ran over [M.name] ([M.ckey])")]")

/obj/vehicle/train/engine/RunOver(var/mob/living/M)
	..()

	if(is_train_head() && ishuman(load))
		var/mob/living/carbon/human/D = load
		to_chat(D, span_bolddanger("You ran over [M]!"))
		visible_message(span_bolddanger("\The [src] ran over [M]!"))
		add_attack_logs(D,M,"Ran over with [src.name]")
		attack_log += text("\[[time_stamp()]\] [span_red("ran over [M.name] ([M.ckey]), driven by [D.name] ([D.ckey])")]")
	else
		attack_log += text("\[[time_stamp()]\] [span_red("ran over [M.name] ([M.ckey])")]")


//-------------------------------------------
// Interaction procs
//-------------------------------------------
/obj/vehicle/train/engine/relaymove(mob/user, direction)
	if(user != load)
		return 0

	if(is_train_head())
		if(direction == reverse_direction(dir) && tow)
			return 0
		if(Move(get_step(src, direction)))
			return 1
		return 0
	else
		return ..()

/obj/vehicle/train/engine/examine(mob/user)
	. = ..()
	if(ishuman(user) && Adjacent(user))
		. += "The power light is [on ? "on" : "off"].\nThere are[key ? "" : " no"] keys in the ignition."
		. += "The charge meter reads [cell? round(cell.percent(), 0.01) : 0]%"


/obj/vehicle/train/engine/CtrlClick(var/mob/user)
	if(Adjacent(user))
		if(on)
			stop_engine()
		else
			start_engine()
	else
		return ..()

/obj/vehicle/train/engine/AltClick(var/mob/user)
	if(Adjacent(user))
		remove_key()
	else
		return ..()

/obj/vehicle/train/engine/verb/start_engine()
	set name = "Start engine"
	set category = "Vehicle"
	set src in view(0)

	if(!ishuman(usr))
		return

	if(on)
		to_chat(usr, "The engine is already running.")
		return

	turn_on()
	if (on)
		to_chat(usr, "You start [src]'s engine.")
	else
		if(!cell)
			to_chat(usr, "[src] doesn't appear to have a power cell!")
		else if(cell.charge < charge_use)
			to_chat(usr, "[src] is out of power.")
		else
			to_chat(usr, "[src]'s engine won't start.")

/obj/vehicle/train/engine/verb/stop_engine()
	set name = "Stop engine"
	set category = "Vehicle"
	set src in view(0)

	if(!ishuman(usr))
		return

	if(!on)
		to_chat(usr, "The engine is already stopped.")
		return

	turn_off()
	if (!on)
		to_chat(usr, "You stop [src]'s engine.")

/obj/vehicle/train/engine/verb/remove_key()
	set name = "Remove key"
	set category = "Vehicle"
	set src in view(0)

	if(!ishuman(usr))
		return

	if(!key || (load && load != usr))
		return

	if(on)
		turn_off()

	key.loc = usr.loc
	if(!usr.get_active_hand())
		usr.put_in_hands(key)
	key = null

	verbs -= /obj/vehicle/train/engine/verb/remove_key

//-------------------------------------------
// Loading/unloading procs
//-------------------------------------------
/obj/vehicle/train/trolley/load(var/atom/movable/C, var/mob/user)
	if(ismob(C) && !passenger_allowed)
		return 0
	if(!istype(C,/obj/machinery) && !istype(C,/obj/structure/closet) && !istype(C,/obj/structure/largecrate) && !istype(C,/obj/structure/reagent_dispensers) && !istype(C,/obj/structure/ore_box) && !ishuman(C))
		return 0

	//if there are any items you don't want to be able to interact with, add them to this check
	// ~no more shielded, emitter armed death trains
	if(istype(C, /obj/machinery))
		load_object(C)
	else
		..(C, user)

	if(load)
		return 1

/obj/vehicle/train/engine/load(var/atom/movable/C, var/mob/user)
	if(!ishuman(C))
		return 0

	return ..()

//Load the object "inside" the trolley and add an overlay of it.
//This prevents the object from being interacted with until it has
// been unloaded. A dummy object is loaded instead so the loading
// code knows to handle it correctly.
/obj/vehicle/train/trolley/proc/load_object(var/atom/movable/C)
	if(!isturf(C.loc)) //To prevent loading things from someone's inventory, which wouldn't get handled properly.
		return 0
	if(load || C.anchored)
		return 0

	var/datum/vehicle_dummy_load/dummy_load = new()
	load = dummy_load

	if(!load)
		return
	dummy_load.actual_load = C
	C.forceMove(src)

	if(load_item_visible)
		C.pixel_x += load_offset_x
		C.pixel_y += load_offset_y
		C.layer = layer

		add_overlay(C)

		//we can set these back now since we have already cloned the icon into the overlay
		C.pixel_x = initial(C.pixel_x)
		C.pixel_y = initial(C.pixel_y)
		C.layer = initial(C.layer)

/obj/vehicle/train/trolley/unload(var/mob/user, var/direction)
	if(istype(load, /datum/vehicle_dummy_load))
		var/datum/vehicle_dummy_load/dummy_load = load
		load = dummy_load.actual_load
		dummy_load.actual_load = null
		qdel(dummy_load)
		cut_overlays()
	..()

//-------------------------------------------
// Latching/unlatching procs
//-------------------------------------------

/obj/vehicle/train/engine/latch(obj/vehicle/train/T, mob/user)
	if(!istype(T) || !Adjacent(T))
		return 0

	//if we are attaching a trolley to an engine we don't care what direction
	// it is in and it should probably be attached with the engine in the lead
	if(istype(T, /obj/vehicle/train/trolley) || istype(T, /obj/vehicle/train/trolley_tank))
		T.attach_to(src, user)
	else
		var/T_dir = get_dir(src, T)	//figure out where T is wrt src

		if(dir == T_dir) 	//if car is ahead
			src.attach_to(T, user)
		else if(reverse_direction(dir) == T_dir)	//else if car is behind
			T.attach_to(src, user)

//-------------------------------------------------------
// Stat update procs
//
// Update the trains stats for speed calculations.
// The longer the train, the slower it will go. car_limit
// sets the max number of cars one engine can pull at
// full speed. Adding more cars beyond this will slow the
// train proportionate to the length of the train. Adding
// more engines increases this limit by car_limit per
// engine.
//-------------------------------------------------------
/obj/vehicle/train/engine/update_car(var/train_length, var/active_engines)
	src.train_length = train_length
	src.active_engines = active_engines

	//Update move delay
	if(!is_train_head() || !on)
		move_delay = initial(move_delay)		//so that engines that have been turned off don't lag behind
	else
		move_delay = max(0, (-car_limit * active_engines) + train_length - active_engines)	//limits base overweight so you cant overspeed trains
		move_delay *= (1 / max(1, active_engines)) * 2 										//overweight penalty (scaled by the number of engines)
		move_delay += CONFIG_GET(number/run_speed) 											//base reference speed
		move_delay *= speed_mod																//makes cargo trains 10% slower than running when not overweight

/obj/vehicle/train/trolley/update_car(var/train_length, var/active_engines)
	src.train_length = train_length
	src.active_engines = active_engines

	if(!lead && !tow)
		anchored = FALSE
	else
		anchored = TRUE

/obj/vehicle/train/engine/update_icon()
	..()
	cut_overlays()
	var/image/O = image(icon = 'icons/obj/vehicles.dmi', icon_state = "cargo_engine_overlay", dir = src.dir)
	O.layer = FLY_LAYER
	O.plane = MOB_PLANE
	add_overlay(O)

/obj/vehicle/train/engine/set_dir()
	..()
	update_icon()

//-------------------------------------------------------
// Cargo tugs for reagent transport from chemical refinery
//-------------------------------------------------------
/obj/vehicle/train/trolley_tank
	name = "cargo train tanker"
	desc = "A large, tank made for transporting liquids."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "cargo_tank"
	anchored = FALSE
	flags = OPENCONTAINER
	paint_color = "#efdd16"

/obj/vehicle/train/trolley_tank/Initialize(mapload)
	. = ..()
	create_reagents(CARGOTANKER_VOLUME)
	update_icon()
	AddComponent(/datum/component/hose_connector/input)
	AddComponent(/datum/component/hose_connector/output)
	AddElement(/datum/element/climbable)
	AddElement(/datum/element/sellable/trolley_tank)

/obj/vehicle/train/trolley_tank/insert_cell(var/obj/item/cell/C, var/mob/living/carbon/human/H)
	return

/obj/vehicle/train/trolley_tank/Bump(atom/Obstacle)
	if(!lead)
		return //so people can't knock others over by pushing a trolley around
	..()

/obj/vehicle/train/trolley_tank/MouseDrop_T(var/atom/movable/C, mob/user as mob)
	if(C == user)
		SEND_SIGNAL(src, COMSIG_CLIMBABLE_START_CLIMB, user)
		return

	if(istype(C,/obj/item/reagent_containers/glass))
		var/obj/item/reagent_containers/glass/G = C
		G.reagents.trans_to(src,G.reagents.total_volume)
		to_chat(usr,"You empty \the [G] into the \the [src].")
		return

	if(istype(C,/obj/vehicle/train)) // Only allow latching
		. = ..()

/obj/vehicle/train/trolley_tank/load(var/atom/movable/C, var/mob/living/user)
	return FALSE // Cannot load anything onto this

/obj/vehicle/train/trolley_tank/RunOver(var/mob/living/M)
	..()
	attack_log += text("\[[time_stamp()]\] [span_red("ran over [M.name] ([M.ckey])")]")

/obj/vehicle/train/trolley_tank/attackby(obj/item/W, mob/user)

	if(istype(W,/obj/item/reagent_containers/glass))
		var/obj/item/reagent_containers/glass/G = W
		if(reagents.total_volume <= 0)
			to_chat(usr,"\The [src] is empty.")
			return
		if(G.reagents.total_volume >= G.reagents.maximum_volume)
			to_chat(usr,"\The [G] is full.")
			return
		playsound(src, 'sound/machines/reagent_dispense.ogg', 25, 1)
		to_chat(usr,"You drain \the [src] into the \the [G].")
		reagents.trans_to_holder( G.reagents, G.reagents.maximum_volume)
		update_icon()
		return

	if(istype(W, /obj/item/multitool))
		var/new_paint = input(usr, "Please select paint color.", "Paint Color", paint_color) as color|null
		if(new_paint)
			paint_color = new_paint
			update_icon()
			return

	if(istype(W, /obj/item/pen))
		var/t = tgui_input_text(user, "What would you like the label to be?", text("[]", src.name), null, MAX_NAME_LEN)
		if (user.get_active_hand() != W)
			return
		if((!in_range(src, user) && src.loc != user))
			return
		t = sanitizeSafe(t, MAX_NAME_LEN)
		if(t)
			src.name = "[initial(name)] - '[t]'"
		else
			src.name = initial(name)
		return

	. = ..()

/obj/vehicle/train/trolley_tank/update_car(var/train_length, var/active_engines)
	src.train_length = train_length
	src.active_engines = active_engines

	if(!lead && !tow)
		anchored = FALSE
	else
		anchored = TRUE

/obj/vehicle/train/trolley_tank/examine(mob/user, infix, suffix)
	. = ..()
	. += "The meter shows [reagents.total_volume]u / [reagents.maximum_volume]u."

/obj/vehicle/train/trolley_tank/update_icon()
	. = ..()
	cut_overlays()
	if(reagents && reagents.total_volume > 0)
		var/percent = (reagents.total_volume / reagents.maximum_volume) * 100
		switch(percent)
			if(5 to 10)			percent = 10
			if(10 to 20) 		percent = 20
			if(20 to 30) 		percent = 30
			if(30 to 40) 		percent = 40
			if(40 to 50)		percent = 50
			if(50 to 60)		percent = 60
			if(60 to 70)		percent = 70
			if(70 to 80)		percent = 80
			if(80 to 90)		percent = 90
			if(90 to INFINITY)	percent = 100
		var/image/chems = image(icon, icon_state = "[icon_state]_r_[percent]", dir = NORTH)
		chems.color = reagents.get_color()
		add_overlay(chems)
	var/image/Bodypaint = image(icon, icon_state = "[icon_state]_c", dir = NORTH)
	Bodypaint.color = paint_color
	add_overlay(Bodypaint)

/obj/vehicle/train/trolley_tank/on_reagent_change(changetype)
	update_icon()
