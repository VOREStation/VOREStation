/obj/screen/alert/leash_dom
	name = "Leash Holder"
	desc = "You're holding a leash, with someone on the end."
	icon_state = "leash_master"

/obj/screen/alert/leash_dom/Click()
	var/obj/item/leash/owner = master
	owner.unleash()

/obj/screen/alert/leash_pet
	name = "Leashed"
	desc = "You're on the hook now!"
	icon_state = "leash_pet"

/obj/screen/alert/leash_dom/Click()
	var/obj/item/leash/owner = master
	owner.struggle_leash()

///// OBJECT /////
//The leash object itself
//The component variables are used for hooks, used later.
/obj/item/leash
	name = "leash"
	desc = "A simple tether that can easily be hooked onto a collar. Usually used to keep pets nearby."
	icon = 'icons/obj/leash.dmi'
	icon_state = "leash"
	item_state = "leash"
	throw_range = 4
	slot_flags = SLOT_TIE
	force = 1
	throwforce = 1
	w_class = ITEMSIZE_SMALL
	var/mob/living/leash_pet = null //Variable to store our pet later
	var/mob/living/leash_master = null //And our master too

/obj/item/leash/Destroy()
	// Just in case
	clear_leash()
	return ..()

/obj/item/leash/process()
	if(!leash_pet)
		return
	if(!is_wearing_collar(leash_pet)) //The pet has slipped their collar and is not the pet anymore.
		leash_pet.visible_message(
			span_warning("[leash_pet] has slipped out of their collar!"),
			span_warning("You have slipped out of your collar!")
		)
		clear_leash()

	if(!leash_pet || !leash_master) //If there is no pet, there is no dom. Loop breaks.
		clear_leash()

//Called when someone is clicked with the leash
/obj/item/leash/attack(mob/living/carbon/C, mob/living/user, attackchain_flags, damage_multiplier) //C is the target, user is the one with the leash
	if(C.alerts["leashed"]) //If the pet is already leashed, do not leash them. For the love of god.
		// If they re-click, remove the leash
		if (C == leash_pet && user == leash_master)
			unleash()
		else
			// Dear god not the double leashing
			to_chat(user, span_notice("[C] has already been leashed."))
		return

	if (C == user)
		to_chat(user, span_notice("You cannot leash yourself!"))
		return

	if (!is_wearing_collar(C))
		to_chat(user, span_notice("[C] needs a collar before you can attach a leash to it."))
		return

	var/leashtime = 35
	if(C.handcuffed)
		leashtime = 5

	C.visible_message(span_danger("\The [user] is attempting to put the leash on \the [C]!"), span_danger("\The [user] tries to put a leash on you"))
	add_attack_logs(user,C,"Leashed (attempt)")
	if(!do_mob(user, C, leashtime)) //do_mob adds a progress bar, but then we also check to see if they have a collar
		return
	if(tgui_alert(C, "Would you like to be leased by [user]? You can OOC escape to escape", "Become Leashed",list("No","Yes")) != "Yes")
		return

	C.visible_message(span_danger("\The [user] puts a leash on \the [C]!"), span_danger("The leash clicks onto your collar!"))

	leash_pet = C //Save pet reference for later
	leash_pet.add_modifier(/datum/modifier/leash)
	leash_pet.throw_alert("leashed", /obj/screen/alert/leash_pet, new_master = src) //Is the leasher
	RegisterSignal(leash_pet, COMSIG_MOVABLE_MOVED, PROC_REF(on_pet_move))
	to_chat(leash_pet, span_userdanger("You have been leashed!"))
	to_chat(leash_pet, span_danger("(You can use OOC escape to detach the leash)"))
	leash_master = user //Save dom reference for later
	leash_master.throw_alert("leash", /obj/screen/alert/leash_dom, new_master = src)//Has now been leashed
	RegisterSignal(leash_master, COMSIG_MOVABLE_MOVED, PROC_REF(on_master_move))

	START_PROCESSING(SSobj, src)

//Called when the leash is used in hand
//Tugs the pet closer
/obj/item/leash/attack_self(mob/living/user)
	if(!leash_pet) //No pet, no tug.
		return
	//Yank the pet. Yank em in close.
	apply_tug_mob_to_mob(leash_pet, leash_master, 1)

/obj/item/leash/proc/on_master_move()
	SIGNAL_HANDLER

	//Make sure the dom still has a pet
	if(!leash_master || !leash_pet)
		return
	addtimer(CALLBACK(src, PROC_REF(after_master_move)), 0.2 SECONDS)

/obj/item/leash/proc/after_master_move()
	//If the master moves, pull the pet in behind
	//Also, the timer means that the distance check for master happens before the pet, to prevent both from proccing.
	if(!leash_master || !leash_pet) //Just to stop error messages
		return
	apply_tug_mob_to_mob(leash_pet, leash_master, 2)

	//Knock the pet over if they get further behind. Shouldn't happen too often.
	sleep(3) //This way running normally won't just yank the pet to the ground.
	if(!leash_master || !leash_pet) //Just to stop error messages. Break the loop early if something removed the master
		return
	if(get_dist(leash_pet, leash_master) > 3 && !leash_pet.stunned)
		leash_pet.visible_message(
			span_warning("[leash_pet] is pulled to the ground by their leash!"),
			span_warning("You are pulled to the ground by your leash!")
		)
		leash_pet.apply_effect(20, STUN, 0)

	//This code is to check if the pet has gotten too far away, and then break the leash.
	sleep(3) //Wait to snap the leash
	if(!leash_master || !leash_pet) //Just to stop error messages
		return
	if(get_dist(leash_pet, leash_master) > 5)
		leash_pet.visible_message(
			span_warning("The leash snaps free from [leash_pet]'s collar!"),
			span_warning("Your leash pops from your collar!")
		)
		leash_pet.apply_effect(20, STUN, 0)
		leash_pet.adjustOxyLoss(5)
		clear_leash()

/obj/item/leash/proc/on_pet_move()
	SIGNAL_HANDLER
	//This should only work if there is a pet and a master.
	//This is here pretty much just to stop the console from flooding with errors
	if(!leash_master || !leash_pet)
		return

	//If the pet gets too far away, they get tugged back
	addtimer(CALLBACK(src, PROC_REF(after_pet_move)), 0.3 SECONDS) //A short timer so the pet kind of bounces back after they make the step

/obj/item/leash/proc/after_pet_move()
	if(!leash_master || !leash_pet)
		return
	for(var/i in 3 to get_dist(leash_pet, leash_master)) // Move the pet to a minimum of 2 tiles away from the master, so the pet trails behind them.
		step_towards(leash_pet, leash_master)

/obj/item/leash/dropped(mob/user)
	 //Drop the leash, and the leash effects stop
	. = ..()
	if(!leash_pet || !leash_master) //There is no pet. Stop this silliness
		return
	//Dropping procs any time the leash changes slots. So, we will wait a tick and see if the leash was actually dropped
	addtimer(CALLBACK(src, PROC_REF(drop_effects), user), 1)

/obj/item/leash/proc/drop_effects(mob/user)
	SIGNAL_HANDLER
	if(leash_master.item_is_in_hands(src) || leash_master.get_item_by_slot(SLOT_TIE) == src)
		return  //Dom still has the leash as it turns out. Cancel the proc.
	leash_master.visible_message(span_notice("\The [leash_master] drops \the [src]."), span_notice("You drop \the [src]."))
	//DOM HAS DROPPED LEASH. PET IS FREE. SCP HAS BREACHED CONTAINMENT.
	clear_leash()

/obj/item/leash/proc/clear_leash()
	leash_pet?.clear_alert("leashed")
	leash_pet?.remove_a_modifier_of_type(/datum/modifier/leash)
	UnregisterSignal(leash_pet, COMSIG_MOVABLE_MOVED)
	leash_pet = null

	leash_master?.clear_alert("leash")
	UnregisterSignal(leash_master, COMSIG_MOVABLE_MOVED)
	leash_master = null

	STOP_PROCESSING(SSobj, src)

/obj/item/leash/proc/struggle_leash()
	leash_pet.visible_message(span_danger("\The [leash_pet] is attempting to unhook their leash!"), span_danger("You attempt to unhook your leash"))
	add_attack_logs(leash_master,leash_pet,"Self-unleash (attempt)")

	if(!do_mob(leash_pet, leash_pet, 35))
		return

	to_chat(leash_pet, span_userdanger("You have been released!"))
	clear_leash()

/obj/item/leash/proc/unleash()
	leash_pet.visible_message(span_danger("\The [leash_master] is attempting to remove the leash on \the [leash_pet]!"), span_danger("\The [leash_master] tries to remove leash from you"))
	add_attack_logs(leash_master,leash_pet,"Unleashed (attempt)")

	if(!do_mob(leash_master, leash_pet, 5))
		return

	to_chat(leash_pet, span_userdanger("You have been released!"))
	clear_leash()

/obj/item/leash/proc/is_wearing_collar(var/mob/living/carbon/human/human)
	if (!istype(human))
		return FALSE
	for (var/obj/item/clothing/worn in human.worn_clothing)
		if (istype(worn, /obj/item/clothing/accessory/collar) || (locate(/obj/item/clothing/accessory/collar) in worn.accessories))
			return TRUE
	return FALSE

/datum/modifier/leash
	name = "Leash"
	slowdown = 5

// Utility functions
/obj/item/proc/apply_tug_mob_to_mob(mob/living/carbon/tug_pet, mob/living/carbon/tug_master, distance = 2)
	apply_tug_position(tug_pet, tug_pet.x, tug_pet.y, tug_master.x, tug_master.y, distance)

/obj/item/proc/apply_tug_mob_to_object(mob/living/carbon/tug_pet, obj/tug_master, distance = 2)
	apply_tug_position(tug_pet, tug_pet.x, tug_pet.y, tug_master.x, tug_master.y, distance)

/obj/item/proc/apply_tug_object_to_mob(obj/tug_pet, mob/living/carbon/tug_master, distance = 2)
	apply_tug_position(tug_pet, tug_pet.x, tug_pet.y, tug_master.x, tug_master.y, distance)

// TODO: improve this for bigger distances, where it's easy to hide behind something and break the tugging
/obj/item/proc/apply_tug_position(tug_pet, tug_pet_x, tug_pet_y, tug_master_x, tug_master_y, distance = 2)
	if(tug_pet_x > tug_master_x + distance)
		step(tug_pet, WEST, 1) //"1" is the speed of movement. We want the tug to be faster than their slow current walk speed.
		if(tug_pet_y > tug_master_y)//Check the other axis, and tug them into alignment so they are behind the master
			step(tug_pet, SOUTH, 1)
		if(tug_pet_y < tug_master_y)
			step(tug_pet, NORTH, 1)
	if(tug_pet_x < tug_master_x - distance)
		step(tug_pet, EAST, 1)
		if(tug_pet_y > tug_master_y)
			step(tug_pet, SOUTH, 1)
		if(tug_pet_y < tug_master_y)
			step(tug_pet, NORTH, 1)
	if(tug_pet_y > tug_master_y + distance)
		step(tug_pet, SOUTH, 1)
		if(tug_pet_x > tug_master_x)
			step(tug_pet, WEST, 1)
		if(tug_pet_x < tug_master_x)
			step(tug_pet, EAST, 1)
	if(tug_pet_y < tug_master_y - distance)
		step(tug_pet, NORTH, 1)
		if(tug_pet_x > tug_master_x)
			step(tug_pet, WEST, 1)
		if(tug_pet_x < tug_master_x)
			step(tug_pet, EAST, 1)

/obj/item/leash/cable
	name = "cable leash"
	desc = "A simple tether that can easily be hooked onto a collar. This one is made from wiring cable."
	icon = 'icons/obj/leash.dmi'
	icon_state = "cable"

/datum/crafting_recipe/leash
	name = "cable leash"
	result = /obj/item/leash/cable
	reqs = list(
		list(/obj/item/stack/cable_coil = 3)
	)
	time = 60
	category = CAT_MISC
