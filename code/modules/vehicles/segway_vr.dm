//HACKYNESS YAYA WIERD CODING!// // this is here so that the variables of the copied engine code would work properly
/obj/vehicle/train/security
	name = "Security Segway Hack fix"
	desc = " if you can see this... then bad things happend. Please tell dev."
	var/obj/item/weapon/key/key
	var/key_type = /obj/item/weapon/key/security

/obj/vehicle/train/security/secway
	name = "Security Segway"
	desc = " 'Safety never takes a holiday.' The true mode of transport for any and all sec officers!"
	description_info = "Use ctrl-click to quickly toggle the engine if you're adjacent (only when vehicle is stationary). Alt-click will grab the keys, if present."
	icon = 'icons/obj/vehicles_vr.dmi'
	icon_state = "secway"
	plane = ABOVE_MOB_PLANE
	layer = ABOVE_MOB_LAYER
	on = 0
	powered = 1
	locked = 0
	var/speed_mod = 1.1
	var/car_limit = 0		//should be zero cause segways cant move
	active_engines = 1


/obj/item/weapon/key/security
	name = "The Security Segway Key"
	desc = "This should should fit into any security segway and start it."
	icon = 'icons/obj/vehicles_vr.dmi'
	icon_state = "securikey"
	w_class = ITEMSIZE_TINY


















///
//BIG COPY PASTA FROM ENGINES JUST SO I DONT HAVE TO DEAL WITH SPRITE BLACK MAGIC AND YOU CAN USE THIS TO MAKE OTHER THINGS IN FUTURE//
///
//-------------------------------------------
// Standard procs
//-------------------------------------------
/obj/vehicle/train/security/New()
	..()
	cell = new /obj/item/weapon/cell/high(src)
	key = new key_type(src)
	//var/image/SW = new(icon = 'icons/obj/vehicles_vr.dmi', icon_state = "secway", plane = ABOVE_MOB_PLANE, layer = ABOVE_MOB_LAYER) //over mobs
	//add_overlay(SW)
	turn_off()

/obj/vehicle/train/security/Move(var/turf/destination)
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

/obj/vehicle/train/security/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, key_type))
		if(!key)
			user.drop_item()
			W.forceMove(src)
			key = W
			verbs += /obj/vehicle/train/engine/verb/remove_key
		return
	..()


/obj/vehicle/train/security/insert_cell(var/obj/item/weapon/cell/C, var/mob/living/carbon/human/H)
	..()
	update_stats()

/obj/vehicle/train/security/remove_cell(var/mob/living/carbon/human/H)
	..()
	update_stats()

//-------------------------------------------
// Train procs
//-------------------------------------------
/obj/vehicle/train/security/turn_on()
	if(!key)
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

/obj/vehicle/train/security/turn_off()
	..()

	verbs -= /obj/vehicle/train/engine/verb/stop_engine
	verbs -= /obj/vehicle/train/engine/verb/start_engine

	if(!on)
		verbs += /obj/vehicle/train/engine/verb/start_engine
	else
		verbs += /obj/vehicle/train/engine/verb/stop_engine

/obj/vehicle/train/RunOver(var/mob/living/M)
	var/list/parts = list(BP_HEAD, BP_TORSO, BP_L_LEG, BP_R_LEG, BP_L_ARM, BP_R_ARM)

	M.apply_effects(5, 5)
	for(var/i = 0, i < rand(1,3), i++)
		M.apply_damage(rand(1,5), BRUTE, pick(parts))

/obj/vehicle/train/security/RunOver(var/mob/living/M)
	..()

	if(is_train_head() && istype(load, /mob/living/carbon/human))
		var/mob/living/carbon/human/D = load
		to_chat(D, "<font color='red'><B>You ran over [M]!</B></font>")
		visible_message("<B><font color='red'>\The [src] ran over [M]!</B></font>")
		add_attack_logs(D,M,"Ran over with [src.name]")
		attack_log += text("\[[time_stamp()]\] <font color='red'>ran over [M.name] ([M.ckey]), driven by [D.name] ([D.ckey])</font>")
	else
		attack_log += text("\[[time_stamp()]\] <font color='red'>ran over [M.name] ([M.ckey])</font>")

//-------------------------------------------
// Interaction procs
//-------------------------------------------
/obj/vehicle/train/security/relaymove(mob/user, direction)
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

/obj/vehicle/train/security/examine(mob/user)
	. = ..()
	if(ishuman(user) && Adjacent(user))
		. += "The power light is [on ? "on" : "off"].\nThere are[key ? "" : " no"] keys in the ignition."
		. += "The charge meter reads [cell? round(cell.percent(), 0.01) : 0]%"


/obj/vehicle/train/security/CtrlClick(var/mob/user)
	if(Adjacent(user))
		if(on)
			stop_engine()
		else
			start_engine()
	else
		return ..()

/obj/vehicle/train/security/AltClick(var/mob/user)
	if(Adjacent(user))
		remove_key()
	else
		return ..()

/obj/vehicle/train/security/verb/start_engine()
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

/obj/vehicle/train/security/verb/stop_engine()
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

/obj/vehicle/train/security/verb/remove_key()
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

	verbs -= /obj/vehicle/train/engine/verb/remove_key

