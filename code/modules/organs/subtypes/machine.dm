/obj/item/organ/cell
	name = "microbattery"
	desc = "A small, powerful cell for use in fully prosthetic bodies."
	icon = 'icons/obj/power.dmi'
	icon_state = "scell"
	organ_tag = "cell"
	parent_organ = "chest"
	vital = 1

/obj/item/organ/cell/New()
	robotize()
	..()

/obj/item/organ/cell/replaced()
	..()
	// This is very ghetto way of rebooting an IPC. TODO better way.
	if(owner && owner.stat == DEAD)
		owner.stat = 0
		owner.visible_message("<span class='danger'>\The [owner] twitches visibly!</span>")

// Used for an MMI or posibrain being installed into a human.
/obj/item/organ/mmi_holder
	name = "brain"
	organ_tag = "brain"
	parent_organ = "head"
	vital = 1
	var/obj/item/device/mmi/stored_mmi

/obj/item/organ/mmi_holder/Destroy()
	stored_mmi = null
	return ..()

/obj/item/organ/mmi_holder/New()
	..()
	if(!stored_mmi)
		stored_mmi = new(src)

	spawn(1)

		if(!owner)
			if(stored_mmi)
				stored_mmi.loc = get_turf(src)
			qdel(src)
			return

		update_from_mmi()
		if(stored_mmi.brainmob && owner && owner.stat == DEAD)
			owner.stat = 0
			owner.visible_message("<span class='danger'>\The [owner] twitches visibly!</span>")

/obj/item/organ/mmi_holder/proc/update_from_mmi()

	if(!stored_mmi)
		return

	if(!stored_mmi.brainmob)
		stored_mmi.brainmob = new(src)

	stored_mmi.brainmob.real_name = owner.name
	stored_mmi.brainmob.name = stored_mmi.brainmob.real_name

	if(owner)
		stored_mmi.name = "[initial(stored_mmi.name)] ([owner.name])"

	name = stored_mmi.name
	desc = stored_mmi.desc
	icon = stored_mmi.icon
	icon_state = stored_mmi.icon_state

/obj/item/organ/mmi_holder/removed()
	update_from_mmi()
	return ..()

/obj/item/organ/mmi_holder/removed(var/mob/living/user)

	if(stored_mmi)
		stored_mmi.loc = get_turf(src)
		if(owner.mind)
			owner.mind.transfer_to(stored_mmi.brainmob)
	..()

	var/mob/living/holder_mob = loc
	if(istype(holder_mob))
		holder_mob.drop_from_inventory(src)
	qdel(src)

/obj/item/organ/mmi_holder/posibrain
	name = "positronic brain"

/obj/item/organ/mmi_holder/posibrain/New()
	stored_mmi = new /obj/item/device/mmi/digital/posibrain(src)
	..()
