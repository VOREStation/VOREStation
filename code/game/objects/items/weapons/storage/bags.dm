/*
 *	These absorb the functionality of the plant bag, ore satchel, etc.
 *	They use the use_to_pickup, quick_gather, and quick_empty functions
 *	that were already defined in weapon/storage, but which had been
 *	re-implemented in other classes.
 *
 *	Contains:
 *		Trash Bag
 *		Mining Satchel
 *		Plant Bag
 *		Sheet Snatcher
 *		Cash Bag
 *		Chemistry Bag
 		Food Bag

 *	-Sayu
 */

//  Generic non-item
/obj/item/weapon/storage/bag
	allow_quick_gather = 1
	allow_quick_empty = 1
	display_contents_with_number = 0 // UNStABLE AS FuCK, turn on when it stops crashing clients
	use_to_pickup = 1
	slot_flags = SLOT_BELT
	drop_sound = 'sound/items/drop/backpack.ogg'
	pickup_sound = 'sound/items/pickup/backpack.ogg'

// -----------------------------
//          Trash bag
// -----------------------------
/obj/item/weapon/storage/bag/trash
	name = "trash bag"
	desc = "It's the heavy-duty black polymer kind. Time to take out the trash!"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "trashbag0"
	item_state_slots = list(slot_r_hand_str = "trashbag", slot_l_hand_str = "trashbag")
	drop_sound = 'sound/items/drop/wrapper.ogg'
	pickup_sound = 'sound/items/pickup/wrapper.ogg'

	w_class = ITEMSIZE_LARGE
	max_w_class = ITEMSIZE_SMALL
	max_storage_space = ITEMSIZE_SMALL * 21
	can_hold = list() // any
	cant_hold = list(/obj/item/weapon/disk/nuclear)

/obj/item/weapon/storage/bag/trash/update_icon()
	if(contents.len == 0)
		icon_state = "trashbag0"
	else if(contents.len < 9)
		icon_state = "trashbag1"
	else if(contents.len < 18)
		icon_state = "trashbag2"
	else icon_state = "trashbag3"


// -----------------------------
//        Plastic Bag
// -----------------------------

/obj/item/weapon/storage/bag/plasticbag
	name = "plastic bag"
	desc = "It's a very flimsy, very noisy alternative to a bag."
	icon = 'icons/obj/trash.dmi'
	icon_state = "plasticbag"
	drop_sound = 'sound/items/drop/wrapper.ogg'
	pickup_sound = 'sound/items/pickup/wrapper.ogg'

	w_class = ITEMSIZE_LARGE
	max_w_class = ITEMSIZE_SMALL
	can_hold = list() // any
	cant_hold = list(/obj/item/weapon/disk/nuclear)

// -----------------------------
//        Mining Satchel
// -----------------------------
/*
 * Mechoid - Orebags are the most common quick-gathering thing, and also have tons of lag associated with it. Their checks are going to be hyper-simplified due to this, and their INCREDIBLY singular target contents.
 */

/obj/item/weapon/storage/bag/ore
	name = "mining satchel"
	desc = "This little bugger can be used to store and transport ores."
	icon = 'icons/obj/mining.dmi'
	icon_state = "satchel"
	slot_flags = SLOT_BELT | SLOT_POCKET
	w_class = ITEMSIZE_NORMAL
	max_storage_space = ITEMSIZE_COST_NORMAL * 25
	max_w_class = ITEMSIZE_NORMAL
	can_hold = list(/obj/item/weapon/ore)
	var/stored_ore = list()
	var/last_update = 0

/obj/item/weapon/storage/bag/ore/remove_from_storage(obj/item/W as obj, atom/new_location)
	if(!istype(W)) return 0

	if(new_location)
		if(ismob(loc))
			W.dropped(usr)
		if(ismob(new_location))
			W.hud_layerise()
		else
			W.reset_plane_and_layer()
		W.forceMove(new_location)
	else
		W.forceMove(get_turf(src))

	W.on_exit_storage(src)
	update_icon()
	return 1

/obj/item/weapon/storage/bag/ore/gather_all(turf/T as turf, mob/user as mob, var/silent = 0)
	var/success = 0
	var/failure = 0
	for(var/obj/item/weapon/ore/I in T) //Only ever grabs ores. Doesn't do any extraneous checks, as all ore is the same size. Tons of checks means it causes hanging for up to three seconds.
		if(contents.len >= max_storage_space)
			failure = 1
			break
		I.forceMove(src)
		success = 1
	if(success && !failure && !silent)
		to_chat(user, "<span class='notice'>You put everything in [src].</span>")
	else if(success && (!silent || (silent && contents.len >= max_storage_space)))
		to_chat(user, "<span class='notice'>You fill the [src].</span>")
	else if(!silent)
		to_chat(user, "<span class='notice'>You fail to pick anything up with \the [src].</span>")
	if(istype(user.pulling, /obj/structure/ore_box)) //Bit of a crappy way to do this, as it doubles spam for the user, but it works.
		var/obj/structure/ore_box/O = user.pulling
		O.attackby(src, user)

/obj/item/weapon/storage/bag/ore/equipped(mob/user)
	..()
	if(user.get_inventory_slot(src) == slot_wear_suit || slot_l_hand || slot_l_hand || slot_belt) //Basically every place they can go. Makes sure it doesn't unregister if moved to other slots.
		GLOB.moved_event.register(user, src, /obj/item/weapon/storage/bag/ore/proc/autoload, user)

/obj/item/weapon/storage/bag/ore/dropped(mob/user)
	..()
	if(user.get_inventory_slot(src) == slot_wear_suit || slot_l_hand || slot_l_hand || slot_belt) //See above. This should really be a define.
		GLOB.moved_event.register(user, src, /obj/item/weapon/storage/bag/ore/proc/autoload, user)
	else
		GLOB.moved_event.unregister(user, src)

/obj/item/weapon/storage/bag/ore/proc/autoload(mob/user)
	var/obj/item/weapon/ore/O = locate() in get_turf(src)
	if(O)
		gather_all(get_turf(src), user)

/obj/item/weapon/storage/bag/ore/proc/rangedload(atom/A, mob/user)
	var/obj/item/weapon/ore/O = locate() in get_turf(A)
	if(O)
		gather_all(get_turf(A), user)

/obj/item/weapon/storage/bag/ore/examine(mob/user)
	. = ..()

	if(!Adjacent(user)) //Can only check the contents of ore bags if you can physically reach them.
		return .

	if(istype(user, /mob/living))
		add_fingerprint(user)

	if(!contents.len)
		. += "It is empty."

	else if(world.time > last_update + 10)
		update_ore_count()
		last_update = world.time

		. += "<span class='notice'>It holds:</span>"
		for(var/ore in stored_ore)
			. += "<span class='notice'>- [stored_ore[ore]] [ore]</span>"

/obj/item/weapon/storage/bag/ore/open(mob/user as mob) //No opening it for the weird UI of having shit-tons of ore inside it.
	if(world.time > last_update + 10)
		update_ore_count()
		last_update = world.time
		user.examinate(src)

/obj/item/weapon/storage/bag/ore/proc/update_ore_count() //Stolen from ore boxes.

	stored_ore = list()

	for(var/obj/item/weapon/ore/O in contents)
		if(stored_ore[O.name])
			stored_ore[O.name]++
		else
			stored_ore[O.name] = 1

// -----------------------------
//          Plant bag
// -----------------------------

/obj/item/weapon/storage/bag/plants
	name = "plant bag"
	icon = 'icons/obj/hydroponics_machines.dmi'
	icon_state = "plantbag"
	max_storage_space = ITEMSIZE_COST_NORMAL * 25
	max_w_class = ITEMSIZE_NORMAL
	w_class = ITEMSIZE_SMALL
	can_hold = list(/obj/item/weapon/reagent_containers/food/snacks/grown,/obj/item/seeds,/obj/item/weapon/grown)

/obj/item/weapon/storage/bag/plants/large
	name = "large plant bag"
	w_class = ITEMSIZE_SMALL
	max_storage_space = ITEMSIZE_COST_NORMAL * 45

// -----------------------------
//        Sheet Snatcher
// -----------------------------
// Because it stacks stacks, this doesn't operate normally.
// However, making it a storage/bag allows us to reuse existing code in some places. -Sayu

/obj/item/weapon/storage/bag/sheetsnatcher
	name = "sheet snatcher"
	icon = 'icons/obj/mining.dmi'
	icon_state = "sheetsnatcher"
	desc = "A patented storage system designed for any kind of mineral sheet."

	var/capacity = 300; //the number of sheets it can carry.
	w_class = ITEMSIZE_NORMAL
	storage_slots = 7

	allow_quick_empty = 1 // this function is superceded

/obj/item/weapon/storage/bag/sheetsnatcher/can_be_inserted(obj/item/W as obj, stop_messages = 0)
	if(!istype(W,/obj/item/stack/material))
		if(!stop_messages)
			to_chat(usr, "The snatcher does not accept [W].")
		return 0
	var/current = 0
	for(var/obj/item/stack/material/S in contents)
		current += S.amount
	if(capacity == current)//If it's full, you're done
		if(!stop_messages)
			to_chat(usr, "<span class='warning'>The snatcher is full.</span>")
		return 0
	return 1


// Modified handle_item_insertion.  Would prefer not to, but...
/obj/item/weapon/storage/bag/sheetsnatcher/handle_item_insertion(obj/item/W as obj, prevent_warning = 0)
	var/obj/item/stack/material/S = W
	if(!istype(S)) return 0

	var/amount
	var/inserted = 0
	var/current = 0
	for(var/obj/item/stack/material/S2 in contents)
		current += S2.amount
	if(capacity < current + S.amount)//If the stack will fill it up
		amount = capacity - current
	else
		amount = S.amount

	for(var/obj/item/stack/material/sheet in contents)
		if(S.type == sheet.type) // we are violating the amount limitation because these are not sane objects
			sheet.amount += amount	// they should only be removed through procs in this file, which split them up.
			S.amount -= amount
			inserted = 1
			break

	if(!inserted || !S.amount)
		usr.remove_from_mob(S)
		usr.update_icons()	//update our overlays
		if (usr.client && usr.s_active != src)
			usr.client.screen -= S
		S.dropped(usr)
		if(!S.amount)
			qdel(S)
		else
			S.loc = src

	orient2hud(usr)
	if(usr.s_active)
		usr.s_active.show_to(usr)
	update_icon()
	return 1

// Sets up numbered display to show the stack size of each stored mineral
// NOTE: numbered display is turned off currently because it's broken
/obj/item/weapon/storage/bag/sheetsnatcher/orient2hud(mob/user as mob)
	var/adjusted_contents = contents.len

	//Numbered contents display
	var/list/datum/numbered_display/numbered_contents
	if(display_contents_with_number)
		numbered_contents = list()
		adjusted_contents = 0
		for(var/obj/item/stack/material/I in contents)
			adjusted_contents++
			var/datum/numbered_display/D = new/datum/numbered_display(I)
			D.number = I.amount
			numbered_contents.Add( D )

	var/row_num = 0
	var/col_count = min(7,storage_slots) -1
	if (adjusted_contents > 7)
		row_num = round((adjusted_contents-1) / 7) // 7 is the maximum allowed width.
	src.slot_orient_objs(row_num, col_count, numbered_contents)
	return

// Modified quick_empty verb drops appropriate sized stacks
/obj/item/weapon/storage/bag/sheetsnatcher/quick_empty()
	var/location = get_turf(src)
	for(var/obj/item/stack/material/S in contents)
		while(S.amount)
			var/obj/item/stack/material/N = new S.type(location)
			var/stacksize = min(S.amount,N.max_amount)
			N.amount = stacksize
			S.amount -= stacksize
			N.update_icon()
		if(!S.amount)
			qdel(S) // todo: there's probably something missing here
	orient2hud(usr)
	if(usr.s_active)
		usr.s_active.show_to(usr)
	update_icon()

// Instead of removing
/obj/item/weapon/storage/bag/sheetsnatcher/remove_from_storage(obj/item/W as obj, atom/new_location)
	var/obj/item/stack/material/S = W
	if(!istype(S)) return 0

	//I would prefer to drop a new stack, but the item/attack_hand code
	// that calls this can't recieve a different object than you clicked on.
	//Therefore, make a new stack internally that has the remainder.
	// -Sayu

	if(S.amount > S.max_amount)
		var/obj/item/stack/material/temp = new S.type(src)
		temp.amount = S.amount - S.max_amount
		S.amount = S.max_amount

	return ..(S,new_location)

// -----------------------------
//    Sheet Snatcher (Cyborg)
// -----------------------------

/obj/item/weapon/storage/bag/sheetsnatcher/borg
	name = "sheet snatcher 9000"
	desc = ""
	capacity = 500//Borgs get more because >specialization

// -----------------------------
//    Food Bag (Service Hound)
// -----------------------------
/obj/item/weapon/storage/bag/dogborg
	name = "dog bag"
	icon = 'icons/obj/storage.dmi'
	icon_state = "foodbag"
	desc = "A bag for storing things of all kinds."
	max_storage_space = ITEMSIZE_COST_NORMAL * 25
	max_w_class = ITEMSIZE_NORMAL
	w_class = ITEMSIZE_SMALL
	can_hold = list(/obj/item/weapon/reagent_containers/food/snacks,/obj/item/weapon/reagent_containers/food/condiment,
	/obj/item/weapon/reagent_containers/glass/beaker,/obj/item/weapon/reagent_containers/glass/bottle,/obj/item/weapon/coin,/obj/item/weapon/spacecash,
	/obj/item/weapon/reagent_containers/food/snacks/grown,/obj/item/seeds,/obj/item/weapon/grown,/obj/item/weapon/reagent_containers/pill)

// -----------------------------
//           Cash Bag
// -----------------------------

/obj/item/weapon/storage/bag/cash
	name = "cash bag"
	icon = 'icons/obj/storage.dmi'
	icon_state = "cashbag"
	desc = "A bag for carrying lots of cash. It's got a big dollar sign printed on the front."
	max_storage_space = ITEMSIZE_COST_NORMAL * 25
	max_w_class = ITEMSIZE_NORMAL
	w_class = ITEMSIZE_SMALL
	can_hold = list(/obj/item/weapon/coin,/obj/item/weapon/spacecash)

	// -----------------------------
	//           Chemistry Bag
	// -----------------------------
/obj/item/weapon/storage/bag/chemistry
	name = "chemistry bag"
	icon = 'icons/obj/storage.dmi'
	icon_state = "chembag"
	desc = "A bag for storing pills, patches, and bottles."
	max_storage_space = 200
	w_class = ITEMSIZE_LARGE
	slowdown = 1
	can_hold = list(/obj/item/weapon/reagent_containers/pill,/obj/item/weapon/reagent_containers/glass/beaker,/obj/item/weapon/reagent_containers/glass/bottle)

	// -----------------------------
	//           Food Bag
	// -----------------------------
/obj/item/weapon/storage/bag/food
	name = "food bag"
	icon = 'icons/obj/storage.dmi'
	icon_state = "foodbag"
	desc = "A bag for storing foods of all kinds."
	max_storage_space = ITEMSIZE_COST_NORMAL * 25
	max_w_class = ITEMSIZE_NORMAL
	w_class = ITEMSIZE_SMALL
	can_hold = list(/obj/item/weapon/reagent_containers/food/snacks,/obj/item/weapon/reagent_containers/food/condiment)

	// -----------------------------
	//           Evidence Bag
	// -----------------------------
/obj/item/weapon/storage/bag/detective
	name = "secure satchel"
	icon = 'icons/obj/storage.dmi'
	icon_state = "detbag"
	desc = "A bag for storing investigation things. You know, securely."
	max_storage_space = ITEMSIZE_COST_NORMAL * 15
	max_w_class = ITEMSIZE_NORMAL
	w_class = ITEMSIZE_SMALL
	can_hold = list(/obj/item/weapon/forensics/swab,/obj/item/weapon/sample/print,/obj/item/weapon/sample/fibers,/obj/item/weapon/evidencebag)

