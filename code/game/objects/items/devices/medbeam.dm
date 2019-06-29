/obj/item/device/medbeam
	name = "rapid restoration system"
	desc = "The ML-3 'Medbeam' is a portable medical system used to treat external injuries from afar. It uses advanced nanite technology to deliver rapid restoration nanites along a targeted path, which self-destruct after healing their target. The ML-3/M takes heavy-capacity power cells."
	icon = 'icons/obj/gun_vr.dmi'
	icon_override = 'icons/obj/gun_vr.dmi'
	icon_state = "medbeam"
	item_state = "medbeam"
	w_class = ITEMSIZE_NORMAL
	origin_tech = list(TECH_MATERIAL = 2, TECH_DATA = 3, TECH_MAGNET = 3)
	force = 5
	icon_state = "medbeam"
	item_state = "medbeam"
	slot_flags = SLOT_BELT
	var/charge_tick = 10 //how much charge the beam uses per Process()
	var/scan_range = 6 // How many tiles away it can heal someone.
	var/busy = FALSE // Set to true when healing, to stop multiple targets being healed.
	var/obj/item/weapon/cell/cell
	var/cell_type = /obj/item/weapon/cell/high
	var/datum/beam/heal_beam = null
	var/filter = null
	var/mob/living/carbon/human/lasttarget

/obj/item/device/medbeam/New()
	if(cell_type)
		cell = new cell_type(src)
	update_icon()

/obj/item/device/medbeam/afterattack(atom/target, mob/user, proximity_flag)
	if(busy)
		busy = FALSE
	if(heal_beam) //delete the healbeam, and...
		qdel(heal_beam)
	if(lasttarget) //clear healbeam overlay
		lasttarget.filters -= filter

	if(!cell || cell.charge == 0)
		to_chat(user, span("warning", "\The [src] is out of charge!"))
		return

	if(istype(target, /mob/))
		if(!istype(target, /mob/living/carbon/human))
			to_chat(user, span("warning", "\The [src] can only heal humanoid targets."))
			return
	else
		return

	if(get_dist(target, user) > scan_range)
		to_chat(user, span("warning", "You are too far away from \the [target]."))
		return

	// If you've got this far, you're successfully healing someone
	world << "Beam created in afterattack()- before"
	heal_beam = Beam(target, icon_state = "medbeam", time = 6000, beam_type=/obj/effect/ebeam/healing,maxdistance=6) //arbitrarily long time ahoy!
	world << "Beam created in afterattack()- after"
	filter = filter(type = "outline", size = 1, color = "#FFFFFF")
	lasttarget = target
	busy = TRUE
	target.filters += filter
	update_icon()

/obj/item/device/medbeam/examine(mob/user)
	..()
	if(cell)
		var/tempdesc
		tempdesc += "\The [src] has a \the [cell] attached. "

		if(cell.charge <= cell.maxcharge*0.25)
			tempdesc += "It appears to have a low amount of power remaining."
		else if(cell.charge > cell.maxcharge*0.25 && cell.charge <= cell.maxcharge*0.5)
			tempdesc += "It appears to have an average amount of power remaining."
		else if(cell.charge > cell.maxcharge*0.5 && cell.charge <= cell.maxcharge*0.75)
			tempdesc += "It appears to have an above average amount of power remaining."
		else if(cell.charge > cell.maxcharge*0.75 && cell.charge <= cell.maxcharge)
			tempdesc += "It appears to have a high amount of power remaining."

		to_chat(user, "[tempdesc]")

/obj/item/device/medbeam/emp_act(severity)
	for(var/obj/O in contents)
		O.emp_act(severity)
	..()

/obj/item/device/medbeam/get_cell()
	return cell

/obj/item/device/medbeam/attack_hand(mob/user as mob)
	if(user.get_inactive_hand() == src)
		if(cell)
			cell.update_icon()
			user.put_in_hands(cell)
			cell = null
			to_chat(user, "<span class='notice'>You remove the cell from \the [src].</span>")
			playsound(src, 'sound/machines/button.ogg', 30, 1, 0)
			update_icon()
			return
		..()
	else
		return ..()

/obj/item/device/medbeam/attackby(obj/item/weapon/W, mob/user as mob)
	if(istype(W, /obj/item/weapon/cell))
		if(!cell)
			user.drop_item()
			W.loc = src
			cell = W
			to_chat(user, "<span class='notice'>You install a cell in \the [src].</span>")
			playsound(src, 'sound/machines/button.ogg', 30, 1, 0)
			update_icon()
		else
			to_chat(user, "<span class='notice'>\The [src] already has a cell.</span>")

	else
		..()

/obj/item/device/medbeam/update_icon()
	if(!cell)
		icon_state = "[initial(icon_state)]_open"
		return

	var/ratio = cell.charge / cell.maxcharge

	//make sure that rounding down will not give us the empty state even if we have charge left.
	if(cell.charge < charge_tick)
		ratio = 0
	else
		ratio = max(round(ratio, 0.25) * 100, 25)
	icon_state = "[initial(icon_state)][ratio]"

/obj/item/device/medbeam/Destroy()
	if(busy)
		busy = FALSE
	if(heal_beam) //delete the healbeam, and...
		qdel(heal_beam)
	if(lasttarget) //clear healbeam overlay
		lasttarget.filters -= filter

/obj/effect/ebeam/healing
	name = "healing beam"
	desc = "A beam of refined nanite technology designed to heal a patient."
	mouse_opacity = 1
	var/obj/item/device/medbeam/medbeam = null

/obj/effect/ebeam/healing/New()
	START_PROCESSING(SSobj, src)
	return ..()

/obj/effect/ebeam/healing/process(atom/target, atom/user)
	medbeam = owner.origin
	if(istype(target, /mob/))
		if(!istype(target, /mob/living/carbon/human)) //Sanity check- if you're not healing a humanoid, stoppit
			visible_message("<span class='warning'>\The [src]'s beam deactivates! Stop healing a non-human!!</span>")
			qdel(src)
		else
			var/mob/living/carbon/human/M = target
			if(M.health < M.maxHealth)
				var/obj/effect/overlay/pulse = new /obj/effect/overlay(get_turf(M))
				pulse.icon = 'icons/effects/effects.dmi'
				pulse.icon_state = "heal"
				pulse.name = "heal"
				pulse.anchored = 1
				spawn(20)
					qdel(pulse)
				M.adjustBruteLoss(-4)
				M.adjustFireLoss(-4)
				M.adjustToxLoss(-1)
				M.adjustOxyLoss(-1)
	if(medbeam.cell)
		if(medbeam.cell.charge >= medbeam.charge_tick)
			medbeam.cell.charge -= medbeam.charge_tick
		else
			medbeam.cell.charge = 0
			visible_message("<span class='warning'>\The [src]'s beam deactivates!</span>")
			qdel(src)
	return

/obj/effect/ebeam/healing/Destroy()
	STOP_PROCESSING(SSobj, src)
	if(medbeam)
		if(medbeam.filter)
			qdel(medbeam.filter)
	return ..()