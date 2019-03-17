/obj/item/organ/internal/cell
	name = "microbattery"
	desc = "A small, powerful cell for use in fully prosthetic bodies."
	icon_state = "scell"
	organ_tag = O_CELL
	parent_organ = BP_TORSO
	vital = 1

/obj/item/organ/internal/cell/New()
	robotize()
	..()

/obj/item/organ/internal/cell/replaced()
	..()
	// This is very ghetto way of rebooting an IPC. TODO better way.
	if(owner && owner.stat == DEAD)
		owner.stat = 0
		owner.visible_message("<span class='danger'>\The [owner] twitches visibly!</span>")

/obj/item/organ/internal/cell/emp_act(severity)
	// ..() // VOREStation Edit - Don't take damage
	owner.nutrition = max(0, owner.nutrition - rand(10/severity, 50/severity))

// Used for an MMI or posibrain being installed into a human.
/obj/item/organ/internal/mmi_holder
	name = "brain interface"
	organ_tag = O_BRAIN
	parent_organ = BP_HEAD
	vital = 1
	var/brain_type = /obj/item/device/mmi
	var/obj/item/device/mmi/stored_mmi
	robotic = ORGAN_ASSISTED

/obj/item/organ/internal/mmi_holder/Destroy()
	if(stored_mmi && (stored_mmi.loc == src))
		qdel(stored_mmi)
		stored_mmi = null
	return ..()

/obj/item/organ/internal/mmi_holder/New(var/mob/living/carbon/human/new_owner, var/internal)
	..(new_owner, internal)
	var/mob/living/carbon/human/dummy/mannequin/M = new_owner
	if(istype(M))
		return
	stored_mmi = new brain_type(src)
	sleep(-1)
	update_from_mmi()

/obj/item/organ/internal/mmi_holder/proc/update_from_mmi()

	if(!stored_mmi.brainmob)
		stored_mmi.brainmob = new(stored_mmi)
		stored_mmi.brainobj = new(stored_mmi)
		stored_mmi.brainmob.container = stored_mmi
		stored_mmi.brainmob.real_name = owner.real_name
		stored_mmi.brainmob.name = stored_mmi.brainmob.real_name
		stored_mmi.name = "[initial(stored_mmi.name)] ([owner.real_name])"

	if(!owner) return

	name = stored_mmi.name
	desc = stored_mmi.desc
	icon = stored_mmi.icon

	stored_mmi.icon_state = "mmi_full"
	icon_state = stored_mmi.icon_state

	stored_mmi.brainmob.languages = owner.languages

	if(owner && owner.stat == DEAD)
		owner.stat = 0
		dead_mob_list -= owner
		living_mob_list |= owner
		owner.visible_message("<span class='danger'>\The [owner] twitches visibly!</span>")

/obj/item/organ/internal/mmi_holder/removed(var/mob/living/user)

	if(stored_mmi)
		. = stored_mmi //VOREStation Code
		stored_mmi.loc = get_turf(src)
		if(owner.mind)
			owner.mind.transfer_to(stored_mmi.brainmob)
	..()

	var/mob/living/holder_mob = loc
	if(istype(holder_mob))
		holder_mob.drop_from_inventory(src)
	qdel(src)

/obj/item/organ/internal/mmi_holder/emp_act(severity)
	// ..() // VOREStation Edit - Don't take damage
	owner.adjustToxLoss(rand(6/severity, 12/severity))

/obj/item/organ/internal/mmi_holder/posibrain
	name = "positronic brain interface"
	brain_type = /obj/item/device/mmi/digital/posibrain
	robotic = ORGAN_ROBOT

/obj/item/organ/internal/mmi_holder/posibrain/update_from_mmi()
	..()
	stored_mmi.icon_state = "posibrain-occupied"
	icon_state = stored_mmi.icon_state

	stored_mmi.brainmob.languages = owner.languages

/obj/item/organ/internal/mmi_holder/robot
	name = "digital brain interface"
	brain_type = /obj/item/device/mmi/digital/robot
	robotic = ORGAN_ROBOT

/obj/item/organ/internal/mmi_holder/robot/update_from_mmi()
	..()
	stored_mmi.icon_state = "mainboard"
	icon_state = stored_mmi.icon_state

	stored_mmi.brainmob.languages = owner.languages
