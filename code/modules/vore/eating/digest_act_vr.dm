//Please make sure to:
//return FALSE: You are not going away, stop asking me to digest.
//return TRUE: You are going away.

// Ye default implementation.
/obj/item/proc/digest_act(var/datum/belly/belly = null)
	if(belly)
		for(var/obj/item/AM in contents)
			AM.forceMove(belly.owner)
			belly.internal_contents |= AM

		belly.owner.nutrition += (1 * w_class)
		if(isrobot(belly.owner))
			var/mob/living/silicon/robot/R = belly.owner
			R.cell.charge += (50 * w_class)
	qdel(src)
	return TRUE

/////////////
// Some indigestible stuff
/////////////
/obj/item/weapon/hand_tele/digest_act(var/datum/belly/belly = null)
	return FALSE
/obj/item/weapon/card/id/gold/captain/spare/digest_act(var/datum/belly/belly = null)
	return FALSE
/obj/item/device/aicard/digest_act(var/datum/belly/belly = null)
	return FALSE
/obj/item/device/paicard/digest_act(var/datum/belly/belly = null)
	return FALSE
/obj/item/weapon/gun/digest_act(var/datum/belly/belly = null)
	return FALSE
/obj/item/weapon/pinpointer/digest_act(var/datum/belly/belly = null)
	return FALSE
/obj/item/blueprints/digest_act(var/datum/belly/belly = null)
	return FALSE
/obj/item/weapon/disk/nuclear/digest_act(var/datum/belly/belly = null)
	return FALSE
/obj/item/device/perfect_tele_beacon/digest_act(var/datum/belly/belly = null)
	return FALSE //Sorta important to not digest your own beacons.

/////////////
// Some special treatment
/////////////
//PDAs need to lose their ID to not take it with them, so we can get a digested ID
/obj/item/device/pda/digest_act(var/datum/belly/belly = null)
	if(id)
		id = null
		if(belly)
			id.forceMove(belly.owner)

	. = ..()

/obj/item/weapon/card/id/digest_act(var/datum/belly/belly = null)
	desc = "A partially digested card that has seen better days.  Much of it's data has been destroyed."
	icon = 'icons/obj/card_vr.dmi'
	icon_state = "digested"
	access = list() // No access
	return FALSE

/obj/item/weapon/reagent_containers/food/digest_act(var/datum/belly/belly = null)
	if(belly)
		if(istype(belly.owner,/mob/living/carbon/human))
			var/mob/living/carbon/human/H = belly.owner
			reagents.trans_to_holder(H.ingested, (reagents.total_volume * 0.3), 1, 0)

		else if(isrobot(belly.owner))
			var/mob/living/silicon/robot/R = belly.owner
			R.cell.charge += 150

	. = ..()

/obj/item/weapon/holder/digest_act(var/datum/belly/belly = null)
	held_mob = null

	. = ..()

/obj/item/organ/digest_act(var/datum/belly/belly = null)
	if(belly)
		belly.owner.nutrition += 66

	. = ..()

/////////////
// Some more complicated stuff
/////////////
/obj/item/device/mmi/digital/posibrain/digest_act(var/datum/belly/belly = null)
	//Replace this with a VORE setting so all types of posibrains can/can't be digested on a whim
	return FALSE
