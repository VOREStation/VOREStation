//This is the initial set up for the new carts. Feel free to improve and/or rewrite everything here.
//I don't know what the hell I'm doing right now. Please help. Especially with the update_icons stuff. -Joan Risu

/obj/vehicle/train/security/engine
	name = "Security Cart"
	desc = "A ridable electric car designed for pulling trolleys as well as personal transport."
	icon = 'icons/obj/vehicles_vr.dmi'
	icon_state = "paddywagon"
	on = 0
	powered = 1
	locked = 0
	move_delay = 0.5

	//Health stuff
	health = 100
	maxhealth = 100
	fire_dam_coeff = 0.6
	brute_dam_coeff = 0.5

	load_item_visible = 1
	load_offset_x = 0
	mob_offset_y = 7

	var/car_limit = 0	//how many cars an engine can pull before performance degrades. This should be 0 to prevent trailers from unhitching.
	active_engines = 1
	var/obj/item/key/key
	var/key_type = /obj/item/key/security
	var/siren = 0 //This is for eventually getting the siren sprite to work.

/obj/item/key/security
	name = "The Security Cart key"
	desc = "The Security Cart Key used to start it."
	icon = 'icons/obj/vehicles_vr.dmi'
	icon_state = "securikey"
	w_class = ITEMSIZE_TINY

/obj/vehicle/train/security/trolley
	name = "Train trolley"
	desc = "A trolly designed to transport security personnel or prisoners."
	icon = 'icons/obj/vehicles_vr.dmi'
	icon_state = "paddy_trailer"
	anchored = FALSE
	passenger_allowed = 1
	locked = 0

	load_item_visible = 1
	load_offset_x = 0
	load_offset_y = 4
	mob_offset_y = 8

/obj/vehicle/train/security/trolley/cargo
	name = "Train trolley"
	desc = "A trolley designed to transport security equipment to a scene."
	icon = 'icons/obj/vehicles_vr.dmi'
	icon_state = "secitemcarrierbot"
	passenger_allowed = 0 //Stick a man inside the box. :v
	load_item_visible = 0 //The load is supposed to be invisible.

//-------------------------------------------
// Standard procs
//-------------------------------------------
/obj/vehicle/train/security/engine/New()
	..()
	cell = new /obj/item/cell/high(src)
	key = new key_type(src)
	var/image/I = new(icon = 'icons/obj/vehicles.dmi', icon_state = "cargo_engine_overlay", layer = src.layer + 0.2) //over mobs
	add_overlay(I)
	turn_off()	//so engine verbs are correctly set

/obj/vehicle/train/security/engine/Move(var/turf/destination)
	if(on && cell.charge < charge_use)
		turn_off()
		update_stats()
		if(load && is_train_head())
			to_chat(load, "The drive motor briefly whines, then drones to a stop.")

	if(is_train_head() && !on)
		return 0

	//space check ~no flying space trains sorry
	if(on && istype(destination, /turf/space))
		return 0

	return ..()

/obj/vehicle/train/security/trolley/attackby(obj/item/W as obj, mob/user as mob)
	if(open && istype(W, /obj/item/tool/wirecutters))
		passenger_allowed = !passenger_allowed
		user.visible_message("<span class='notice'>[user] [passenger_allowed ? "cuts" : "mends"] a cable in [src].</span>","<span class='notice'>You [passenger_allowed ? "cut" : "mend"] the load limiter cable.</span>")
	else
		..()

/obj/vehicle/train/security/engine/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, key_type))
		if(!key)
			user.drop_item()
			W.forceMove(src)
			key = W
			verbs += /obj/vehicle/train/security/engine/verb/remove_key
		return
	..()

//cargo trains are open topped, so there is a chance the projectile will hit the mob ridding the train instead
/obj/vehicle/train/security/bullet_act(var/obj/item/projectile/Proj)
	if(buckled_mob && prob(70))
		buckled_mob.bullet_act(Proj)
		return
	..()

/obj/vehicle/train/security/update_icon()
	if(open)
		icon_state = initial(icon_state) + "_open"
	else
		icon_state = initial(icon_state)

/obj/vehicle/train/security/trolley/insert_cell(var/obj/item/cell/C, var/mob/living/carbon/human/H)
	return

/obj/vehicle/train/security/engine/insert_cell(var/obj/item/cell/C, var/mob/living/carbon/human/H)
	..()
	update_stats()

/obj/vehicle/train/security/engine/remove_cell(var/mob/living/carbon/human/H)
	..()
	update_stats()

/obj/vehicle/train/security/engine/Bump(atom/Obstacle)
	var/obj/machinery/door/D = Obstacle
	var/mob/living/carbon/human/H = load
	if(istype(D) && istype(H))
		D.Bumped(H)		//a little hacky, but hey, it works, and respects access rights

	..()

/obj/vehicle/train/security/trolley/Bump(atom/Obstacle)
	if(!lead)
		return //so people can't knock others over by pushing a trolley around
	..()

//-------------------------------------------
// Train procs
//-------------------------------------------
/obj/vehicle/train/security/engine/turn_on()
	if(!key)
		return
	else
		..()
		update_stats()

		verbs -= /obj/vehicle/train/security/engine/verb/stop_engine
		verbs -= /obj/vehicle/train/security/engine/verb/start_engine

		if(on)
			verbs += /obj/vehicle/train/security/engine/verb/stop_engine
		else
			verbs += /obj/vehicle/train/security/engine/verb/start_engine

/obj/vehicle/train/security/engine/turn_off()
	..()

	verbs -= /obj/vehicle/train/security/engine/verb/stop_engine
	verbs -= /obj/vehicle/train/security/engine/verb/start_engine

	if(!on)
		verbs += /obj/vehicle/train/security/engine/verb/start_engine
	else
		verbs += /obj/vehicle/train/security/engine/verb/stop_engine

/obj/vehicle/train/security/RunOver(var/mob/living/M)
	var/list/parts = list(BP_HEAD, BP_TORSO, BP_L_LEG, BP_R_LEG, BP_L_ARM, BP_R_ARM)

	M.apply_effects(5, 5)
	for(var/i = 0, i < rand(1,3), i++)
		M.apply_damage(rand(1,5), BRUTE, pick(parts))

/obj/vehicle/train/security/trolley/RunOver(var/mob/living/M)
	..()
	attack_log += text("\[[time_stamp()]\] <font color='red'>ran over [M.name] ([M.ckey])</font>")

/obj/vehicle/train/security/engine/RunOver(var/mob/living/M)
	..()

	if(is_train_head() && istype(load, /mob/living/carbon/human))
		var/mob/living/carbon/human/D = load
		to_chat(D, "<span class='danger'>You ran over \the [M]!</span>"
		visible_message("<span class='danger'>\The [src] ran over \the [M]!</span>")
		add_attack_logs(D,M,"Ran over with [src.name]")
		attack_log += text("\[[time_stamp()]\] <font color='red'>ran over [M.name] ([M.ckey]), driven by [D.name] ([D.ckey])</font>")
	else
		attack_log += text("\[[time_stamp()]\] <font color='red'>ran over [M.name] ([M.ckey])</font>")


//-------------------------------------------
// Interaction procs
//-------------------------------------------
/obj/vehicle/train/security/engine/relaymove(mob/user, direction)
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

/obj/vehicle/train/security/engine/examine(mob/user)
	. = ..()
	if(Adjacent(user))
		. += "The power light is [on ? "on" : "off"]."
		. += "There are[key ? "" : " no"] keys in the ignition."
		. += "The charge meter reads [cell? round(cell.percent(), 0.01) : 0]%"

/obj/vehicle/train/security/engine/verb/start_engine()
	set name = "Start engine"
	set category = "Vehicle"
	set src in view(0)

	if(!istype(usr, /mob/living/carbon/human))
		return

	if(on)
		to_chat(usr, "The engine is already running.")
		return

	turn_on()
	if (on)
		to_chat(usr, "You start [src]'s engine.")
	else
		if(cell.charge < charge_use)
			to_chat(usr, "[src] is out of power.")
		else
			to_chat(usr, "[src]'s engine won't start.")

/obj/vehicle/train/security/engine/verb/stop_engine()
	set name = "Stop engine"
	set category = "Vehicle"
	set src in view(0)

	if(!istype(usr, /mob/living/carbon/human))
		return

	if(!on)
		to_chat(usr, "The engine is already stopped.")
		return

	turn_off()
	if (!on)
		to_chat(usr, "You stop [src]'s engine.")

/obj/vehicle/train/security/engine/verb/remove_key()
	set name = "Remove key"
	set category = "Vehicle"
	set src in view(0)

	if(!istype(usr, /mob/living/carbon/human))
		return

	if(!key || (load && load != usr))
		return

	if(on)
		turn_off()

	key.loc = usr.loc
	if(!usr.get_active_hand())
		usr.put_in_hands(key)
	key = null

	verbs -= /obj/vehicle/train/security/engine/verb/remove_key

//-------------------------------------------
// Loading/unloading procs
//-------------------------------------------
/obj/vehicle/train/security/trolley/load(var/atom/movable/C)
	if(ismob(C) && !passenger_allowed)
		return 0
	if(!istype(C,/obj/machinery) && !istype(C,/obj/structure/closet) && !istype(C,/obj/structure/largecrate) && !istype(C,/obj/structure/reagent_dispensers) && !istype(C,/obj/structure/ore_box) && !istype(C, /mob/living/carbon/human))
		return 0

	//if there are any items you don't want to be able to interact with, add them to this check
	// ~no more shielded, emitter armed death trains
	if(istype(C, /obj/machinery))
		load_object(C)
	else
		..()

	if(load)
		return 1

/obj/vehicle/train/security/engine/load(var/atom/movable/C)
	if(!istype(C, /mob/living/carbon/human))
		return 0

	return ..()

//Load the object "inside" the trolley and add an overlay of it.
//This prevents the object from being interacted with until it has
// been unloaded. A dummy object is loaded instead so the loading
// code knows to handle it correctly.
/obj/vehicle/train/security/trolley/proc/load_object(var/atom/movable/C)
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

/obj/vehicle/train/security/trolley/unload(var/mob/user, var/direction)
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

/obj/vehicle/train/security/engine/latch(obj/vehicle/train/T, mob/user)
	if(!istype(T) || !Adjacent(T))
		return 0

	//if we are attaching a trolley to an engine we don't care what direction
	// it is in and it should probably be attached with the engine in the lead
	if(istype(T, /obj/vehicle/train/security/trolley))
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
/obj/vehicle/train/security/engine/update_car(var/train_length, var/active_engines)
	src.train_length = train_length
	src.active_engines = active_engines

	//Update move delay
	if(!is_train_head() || !on)
		move_delay = initial(move_delay)		//so that engines that have been turned off don't lag behind
	else
		move_delay = max(0, (-car_limit * active_engines) + train_length - active_engines)	//limits base overweight so you cant overspeed trains
		move_delay *= (1 / max(1, active_engines)) * 2 										//overweight penalty (scaled by the number of engines)
		move_delay += config.run_speed 														//base reference speed
		move_delay *= 1.1																	//makes cargo trains 10% slower than running when not overweight

/obj/vehicle/train/security/trolley/update_car(var/train_length, var/active_engines)
	src.train_length = train_length
	src.active_engines = active_engines

	if(!lead && !tow)
		anchored = FALSE
	else
		anchored = TRUE
