//Please make sure to:
//return FALSE: You are not going away, stop asking me to digest.
//return non-negative integer: Amount of nutrition/charge gained (scaled to nutrition, other end can multiply for charge scale).

// Ye default implementation.
/obj/item/proc/digest_act(var/list/internal_contents = null, var/atom/movable/item_storage = null)
	for(var/obj/item/O in contents)
		if(istype(O,/obj/item/weapon/storage/internal)) //Dump contents from dummy pockets.
			for(var/obj/item/SO in O)
				if(internal_contents)
					internal_contents |= SO
				if(item_storage)
					SO.forceMove(item_storage)
				qdel(O)
		else
			if(internal_contents)
				internal_contents |= O
			if(item_storage)
				O.forceMove(item_storage)

	qdel(src)
	return w_class

/////////////
// Some indigestible stuff
/////////////
/obj/item/weapon/hand_tele/digest_act(var/list/internal_contents = null, var/atom/movable/item_storage = null)
	return FALSE
/obj/item/weapon/card/id/gold/captain/spare/digest_act(var/list/internal_contents = null, var/atom/movable/item_storage = null)
	return FALSE
/obj/item/device/aicard/digest_act(var/list/internal_contents = null, var/atom/movable/item_storage = null)
	return FALSE
/obj/item/device/paicard/digest_act(var/list/internal_contents = null, var/atom/movable/item_storage = null)
	return FALSE
/obj/item/weapon/gun/digest_act(var/list/internal_contents = null, var/atom/movable/item_storage = null)
	return FALSE
/obj/item/weapon/pinpointer/digest_act(var/list/internal_contents = null, var/atom/movable/item_storage = null)
	return FALSE
/obj/item/blueprints/digest_act(var/list/internal_contents = null, var/atom/movable/item_storage = null)
	return FALSE
/obj/item/weapon/disk/nuclear/digest_act(var/list/internal_contents = null, var/atom/movable/item_storage = null)
	return FALSE
/obj/item/device/perfect_tele_beacon/digest_act(var/list/internal_contents = null, var/atom/movable/item_storage = null)
	return FALSE //Sorta important to not digest your own beacons.

/////////////
// Some special treatment
/////////////
//PDAs need to lose their ID to not take it with them, so we can get a digested ID
/obj/item/device/pda/digest_act(var/list/internal_contents = null, var/atom/movable/item_storage = null)
	if(id)
		id = null

		/* Doesn't appear to be necessary anymore.
		if(item_storage)
			id.forceMove(item_storage)
		if(internal_contents)
			internal_contents |= id
		*/

	. = ..()

/obj/item/weapon/card/id/digest_act(var/list/internal_contents = null, var/atom/movable/item_storage = null)
	desc = "A partially digested card that has seen better days.  Much of it's data has been destroyed."
	icon = 'icons/obj/card_vr.dmi'
	icon_state = "digested"
	access = list() // No access
	return FALSE

/obj/item/weapon/reagent_containers/food/digest_act(var/list/internal_contents = null, var/atom/movable/item_storage = null)
	if(ishuman(item_storage))
		var/mob/living/carbon/human/H = item_storage
		reagents.trans_to_holder(H.ingested, (reagents.total_volume * 0.3), 1, 0)

	else if(isrobot(item_storage))
		var/mob/living/silicon/robot/R = item_storage
		R.cell.charge += 150

	. = ..()

/obj/item/weapon/holder/digest_act(var/list/internal_contents = null, var/atom/movable/item_storage = null)
	for(var/mob/living/M in contents)
		if(internal_contents)
			internal_contents |= M
		if(item_storage)
			M.forceMove(item_storage)
	held_mob = null

	. = ..()

/obj/item/organ/digest_act(var/list/internal_contents = null, var/atom/movable/item_storage = null)
	if((. = ..()))
		. += 70 //Organs give a little more

/////////////
// Some more complicated stuff
/////////////
/obj/item/device/mmi/digital/posibrain/digest_act(var/list/internal_contents = null, var/atom/movable/item_storage = null)
	//Replace this with a VORE setting so all types of posibrains can/can't be digested on a whim
	return FALSE
