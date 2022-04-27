#define pet_carrier_full(carrier) carrier.occupants.len >= carrier.max_occupants || carrier.occupant_weight >= carrier.max_occupant_weight

//Used to transport little animals without having to drag them across the station.
//Comes with a handy lock to prevent them from running off.
/obj/item/weapon/pet_carrier
	name = "pet carrier"
	desc = "A big white-and-blue pet carrier. Good for carrying <s>meat to the chef</s> cute animals around."
	icon = 'icons/obj/pet_carrier.dmi'
	icon_state = "pet_carrier_open"
	var/base_icon = "pet_carrier"
	//icon_state = "pet_carrier_open"
	//inhand_icon_state = "pet_carrier"
	//lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	//righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	item_icons = list(
			slot_l_hand_str = 'icons/mob/items/lefthand_melee_vr.dmi',
			slot_r_hand_str = 'icons/mob/items/righthand_melee_vr.dmi',
			)
	item_state_slots = list(slot_r_hand_str = "pet_carrier", slot_l_hand_str = "pet_carrier")
	force = 0.2
	attack_verb = list("bashed", "carried")
	//attack_verb_simple = list("bash", "carry")
	w_class = ITEMSIZE_LARGE
	throw_speed = 2
	throw_range = 3
	matter = list(MAT_STEEL = 150, MAT_GLASS = 100)
	var/open = TRUE
	var/locked = FALSE
	var/list/occupants = list()
	var/occupant_weight = 0
	var/max_occupants = 3 //Hard-cap so you can't have infinite mice or something in one carrier
	var/max_occupant_weight = MOB_SMALL //This is calculated from the mob sizes of occupants

/obj/item/weapon/pet_carrier/New()
	verbs += .proc/drop_pet
	..()

/obj/item/weapon/pet_carrier/Destroy()
	if(occupants.len)
		for(var/V in occupants)
			remove_occupant(V)
	return ..()

/obj/item/weapon/pet_carrier/Exited(atom/movable/gone, direction)
	if(isliving(gone) && (gone in occupants))
		var/mob/living/L = gone
		occupants -= gone
		occupant_weight -= L.mob_size
/*
/obj/item/pet_carrier/Destroy(atom/A)
	if(A in occupants && isliving(A))
		var/mob/living/L = A
		occupants -= L
		occupant_weight -= L.mob_size
	..()
*/
/obj/item/weapon/pet_carrier/examine(mob/user)
	. = ..()
	if(occupants.len)
		for(var/V in occupants)
			var/mob/living/L = V
			. += span_notice("It has [L] inside.")
	else
		. += span_notice("It has nothing inside.")
	if(user.CanUseTopic(src))
		. += span_notice("Activate it in your hand to [open ? "close" : "open"] its door.")
		if(!open)
			. += span_notice("Alt-click to [locked ? "unlock" : "lock"] its door.")

/obj/item/weapon/pet_carrier/attack_self(mob/living/user)
	if(open)
		to_chat(user, span_notice("You close [src]'s door."))
		//playsound(user, 'sound/effects/bin_close.ogg', 50, TRUE)
		playsound(user, 'sound/effects/crate_close.ogg', 50, TRUE)
		open = FALSE
	else
		if(locked)
			to_chat(user, span_warning("[src] is locked!"))
			return
		to_chat(user, span_notice("You open [src]'s door."))
		//playsound(user, 'sound/effects/bin_open.ogg', 50, TRUE)
		playsound(user, 'sound/effects/crate_open.ogg', 50, TRUE)
		open = TRUE
	//update_appearance()
	update_icon()

/obj/item/weapon/pet_carrier/AltClick(mob/living/user)
	if(open || !user.CanUseTopic(src))
		return
	locked = !locked
	to_chat(user, span_notice("You flip the lock switch [locked ? "down" : "up"]."))
	if(locked)
		playsound(user, 'sound/machines/door/boltsdown.ogg', 30, TRUE)
	else
		playsound(user, 'sound/machines/door/boltsup.ogg', 30, TRUE)
	//update_appearance()
	update_icon()

/obj/item/weapon/pet_carrier/attack(mob/living/target as mob, mob/living/user as mob)
	if(user.a_intent == I_HURT)
		return ..()
	if(!open)
		to_chat(user, span_warning("You need to open [src]'s door!"))
		return
	var/size_diff = user.get_effective_size() - target.get_effective_size()
	//if(target.mob_size > max_occupant_weight)
	if(ishuman(target) && size_diff < 0.45)
		to_chat(user, span_warning("You get the feeling [target] is a tad too large for a [name]."))
		return
	if(target.mob_size > max_occupant_weight)
		//if(ishuman(target))
			//to_chat(user, span_warning("Humans, generally, do not fit into pet carriers."))
		//else
		to_chat(user, span_warning("You get the feeling [target] isn't meant for a [name]."))
		return
	if(target.mob_size > MOB_SMALL)
		if(target.buckled && istype(target.buckled, /obj/effect/energy_net))
			//target.buckled.forceMove(target.loc)
			load_occupant(user, target)
			target.buckled.forceMove(target.loc)
			return
		else
			to_chat(user, "It's going to be difficult to convince \the [src] to move into \the [name] without capturing it in a net.")
			return
	if(user == target)
		to_chat(user, span_warning("Why would you ever do that?"))
		return
	load_occupant(user, target)

/obj/item/weapon/pet_carrier/relaymove(mob/living/user, direction)
	if(open)
		loc.visible_message(span_notice("[user] climbs out of [src]!"), \
		span_warning("[user] jumps out of [src]!"))
		remove_occupant(user)
		return
	else if(!locked)
		loc.visible_message(span_notice("[user] pushes open the door to [src]!"), \
		span_warning("[user] pushes open the door of [src]!"))
		open = TRUE
		//update_appearance()
		update_icon()
		return
	else if(user.client)
		container_resist(user)

/obj/item/weapon/pet_carrier/container_resist(mob/living/user)
	//user.changeNext_move(100)
	//user.last_special = world.time + 100
	if(user.mob_size <= MOB_SMALL)
		to_chat(user, span_notice("You poke a limb through [src]'s bars and start fumbling for the lock switch... (This will take some time.)"))
		to_chat(loc, span_warning("You see [user] reach through the bars and fumble for the lock switch!"))
		if(!do_after(user, rand(300, 400), target = user) || open || !locked || !(user in occupants))
			return
		loc.visible_message(span_warning("[user] flips the lock switch on [src] by reaching through!"))
		to_chat(user, span_boldannounce("Bingo! The lock pops open!"))
		locked = FALSE
		playsound(src, 'sound/machines/door/boltsup.ogg', 30, TRUE)
		//update_appearance()
		update_icon()
	else
		loc.visible_message(span_warning("[src] starts rattling as something pushes against the door!"))
		to_chat(user, span_notice("You start pushing out of [src]... (This will take about 20 seconds.)"))
		if(!do_after(user, 200, target = user) || open || !locked || !(user in occupants))
			return
		loc.visible_message(span_warning("[user] shoves out of [src]!"))
		to_chat(user, span_notice("You shove open [src]'s door against the lock's resistance and fall out!"))
		locked = FALSE
		open = TRUE
		//update_appearance()
		update_icon()
		remove_occupant(user)

/obj/item/weapon/pet_carrier/update_icon()
	if(open)
		icon_state = initial(icon_state)
		return ..()
	icon_state = "[base_icon]_[!occupants.len ? "closed" : "occupied"]"
	cut_overlays()
	add_overlay("[base_icon]_[locked ? "" : "un"]locked")
	return ..()
/*
/obj/item/pet_carrier/update_overlays()
	. = ..()
	if(!open)
		. += "[icon_state]_[locked ? "" : "un"]locked"
// This wont fuckin work, and I don't care to fix it. I'll just make a verb do the same thing.
/obj/item/pet_carrier/MouseDrop(atom/over_atom)
	. = ..()
	var/turf/T = get_turf(over_atom.loc)
	if(T.check_density(ignore_mobs = TRUE) && usr.CanUseTopic(src, TRUE) && usr.Adjacent(over_atom) && open && occupants.len)
		usr.visible_message(span_notice("[usr] unloads [src]."), \
		span_notice("You unload [src] onto [over_atom]."))
		for(var/V in occupants)
			remove_occupant(V, T)
*/
/obj/item/weapon/pet_carrier/proc/drop_pet()
	set name = "Empty Carrier"
	set category = "Object"
	set src in view(1)

	for(var/V in occupants)
		remove_occupant(V)

/obj/item/weapon/pet_carrier/proc/load_occupant(mob/living/user, mob/living/target)
	if(pet_carrier_full(src))
		to_chat(user, span_warning("[src] is already carrying too much!"))
		return
	user.visible_message(span_notice("[user] starts loading [target] into [src]."), \
	span_notice("You start loading [target] into [src]..."))
	to_chat(target, span_userdanger("[user] starts loading you into \the [name]!"))
	if(!do_mob(user, target, 30))
		return
	if(target in occupants)
		return
	if(pet_carrier_full(src)) //Run the checks again, just in case
		to_chat(user, span_warning("[src] is already carrying too much!"))
		return
	user.visible_message(span_notice("[user] loads [target] into [src]!"), \
	span_notice("You load [target] into [src]."))
	to_chat(target, span_userdanger("[user] loads you into \the [name]!"))
	add_occupant(target)

/obj/item/weapon/pet_carrier/proc/add_occupant(mob/living/occupant)
	if(occupant in occupants || !istype(occupant))
		return
	occupant.forceMove(src)
	occupants += occupant
	occupant_weight += occupant.mob_size

/obj/item/weapon/pet_carrier/proc/remove_occupant(mob/living/occupant, turf/new_turf)
	if(!(occupant in occupants) || !istype(occupant))
		return
	occupant.forceMove(new_turf ? new_turf : drop_location())
	if(occupant.buckled && istype(occupant.buckled, /obj/effect/energy_net)) // Needs testing.
		occupant.buckled.dropInto(src)
	occupants -= occupant
	occupant_weight -= occupant.mob_size
	occupant.dir = SOUTH

/obj/item/weapon/pet_carrier/biopod
	name = "portable bluspace stasis cage"
	desc = "Alien device used for undescribable purpose. Or carrying pets."
	icon_state = "biopod_open"
	base_icon = "biopod"

	max_occupant_weight = MOB_MEDIUM
	//icon_state = "biopod_open"
	//inhand_icon_state = "biopod"

/obj/item/weapon/pet_carrier/biopod/add_occupant(mob/living/occupant)
	..()
	var/mob/living/simple_mob/animal = occupant
	if(istype(animal))
		animal.in_stasis = 1

/obj/item/weapon/pet_carrier/biopod/remove_occupant(mob/living/occupant, turf/new_turf)
	..()
	var/mob/living/simple_mob/animal = occupant
	if(istype(animal))
		animal.in_stasis = 0

#undef pet_carrier_full