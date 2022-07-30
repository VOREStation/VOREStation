/obj/item/inducer
	name = "industrial inducer"
	desc = "A tool for inductively charging internal power cells."
	icon = 'icons/obj/tools_vr.dmi'
	icon_state = "inducer-engi"
	item_state = "inducer-engi"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_vr.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_vr.dmi',
	)
	force = 7

	var/powertransfer = 1000 //Transfer per time when charging something
	var/cell_type = /obj/item/cell/high //Type of cell to spawn in it
	var/charge_guns = FALSE //Can it charge guns?

	var/datum/effect/effect/system/spark_spread/spark_system
	var/obj/item/cell/cell
	var/recharging = FALSE
	var/opened = FALSE

/obj/item/inducer/unloaded
	cell_type = null
	opened = TRUE

/obj/item/inducer/Initialize()
	. = ..()
	if(!cell && cell_type)
		cell = new cell_type

/obj/item/inducer/proc/induce(var/obj/item/cell/target, coefficient)
	var/totransfer = min(cell.charge,(powertransfer * coefficient))
	var/transferred = target.give(totransfer)
	cell.use(transferred)
	cell.update_icon()
	target.update_icon()

/obj/item/inducer/get_cell()
	return cell

/obj/item/inducer/emp_act(severity)
	. = ..()
	if(cell)
		cell.emp_act(severity)

/obj/item/inducer/attack(mob/living/M, mob/living/user)
	if(user.a_intent == I_HURT)
		return ..()
	else
		return 0 //No accidental bludgeons!

/obj/item/inducer/afterattack(atom/A, mob/living/carbon/user, proximity)
	if(user.a_intent == I_HURT)
		return ..()

	if(cantbeused(user))
		return

	if(recharge(A, user))
		return

	return ..()

/obj/item/inducer/proc/cantbeused(mob/user)
	if(!user.IsAdvancedToolUser())
		to_chat(user, "<span class='warning'>You don't have the dexterity to use [src]!</span>")
		return TRUE

	if(!cell)
		to_chat(user, "<span class='warning'>[src] doesn't have a power cell installed!</span>")
		return TRUE

	if(!cell.charge)
		to_chat(user, "<span class='warning'>[src]'s battery is dead!</span>")
		return TRUE
	return FALSE


/obj/item/inducer/attackby(obj/item/W, mob/user)
	if(W.is_screwdriver())
		playsound(src, W.usesound, 50, 1)
		if(!opened)
			to_chat(user, "<span class='notice'>You open the battery compartment.</span>")
			opened = TRUE
			update_icon()
			return
		else
			to_chat(user, "<span class='notice'>You close the battery compartment.</span>")
			opened = FALSE
			update_icon()
			return
	if(istype(W, /obj/item/cell))
		if(opened)
			if(!cell)
				user.drop_from_inventory(W)
				W.forceMove(src)
				to_chat(user, "<span class='notice'>You insert [W] into [src].</span>")
				cell = W
				update_icon()
				return
			else
				to_chat(user, "<span class='warning'>[src] already has \a [cell] installed!</span>")
				return

	if(cantbeused(user))
		return

	if(recharge(W, user))
		return

	return ..()

/obj/item/inducer/proc/recharge(atom/movable/A, mob/user)
	if(!isturf(A) && user.loc == A)
		return FALSE
	if(recharging)
		return TRUE
	else
		recharging = TRUE

	if(istype(A, /obj/item/gun/energy) && !charge_guns)
		to_chat(user, "<span class='alert'>Error unable to interface with device.</span>")
		return FALSE

	//The cell we hopefully eventually find
	var/obj/item/cell/C

	//Synthetic humanoids
	if(ishuman(A))
		var/mob/living/carbon/human/H = A
		if(H.isSynthetic())
			C = new /obj/item/cell/standin(null, H) // o o f

	//Borg frienbs
	else if(isrobot(A))
		var/mob/living/silicon/robot/R = A
		C = R.cell

	//Can set different coefficients per item if you want
	var/coefficient = 1

	//Last ditch effort
	var/obj/O //For updating icons, just in case they have a battery meter icon
	if(!C && isobj(A))
		O = A
		C = O.get_cell()

	if(C)
		var/done_any = FALSE

		if(C.charge >= C.maxcharge)
			to_chat(user, "<span class='notice'>[A] is fully charged ([round(C.charge)] / [C.maxcharge])!</span>")
			recharging = FALSE
			return TRUE
		user.visible_message("<span class='notice'>[user] starts recharging [A] with [src].</span>", "<span class='notice'>You start recharging [A] with [src].</span>")

		var/datum/beam/charge_beam = user.Beam(A, icon_state = "rped_upgrade", time = 20 SECONDS)
		var/filter = filter(type = "outline", size = 1, color = "#22AAFF")
		A.filters += filter

		spark_system = new /datum/effect/effect/system/spark_spread
		spark_system.set_up(5, 0, get_turf(A))
		spark_system.attach(A)

		while(C.charge < C.maxcharge)
			if(do_after(user, 2 SECONDS, target = user) && cell.charge)
				done_any = TRUE
				induce(C, coefficient)
				spark_system.start()
				if(O)
					O.update_icon()
			else
				break

		QDEL_NULL(charge_beam)
		QDEL_NULL(spark_system)
		if(A)
			A.filters -= filter

		if(done_any) // Only show a message if we succeeded at least once
			user.visible_message("<span class='notice'>[user] recharged [A]!</span>", "<span class='notice'>You recharged [A]!</span>")

		recharging = FALSE
		return TRUE
	else //Couldn't find a cell
		to_chat(user, "<span class='alert'>Error unable to interface with device.</span>")

	recharging = FALSE

/obj/item/inducer/attack_self(mob/user)
	if(opened && cell)
		user.visible_message("<span class='notice'>[user] removes [cell] from [src]!</span>", "<span class='notice'>You remove [cell].</span>")
		cell.update_icon()
		user.put_in_hands(cell)
		cell = null
		update_icon()

/obj/item/inducer/examine(mob/living/M)
	. = ..()
	if(cell)
		. += "<span class='notice'>Its display shows: [round(cell.charge)] / [cell.maxcharge].</span>"
	else
		. += "<span class='notice'>Its display is dark.</span>"
	if(opened)
		. += "<span class='notice'>Its battery compartment is open.</span>"

/obj/item/inducer/update_icon()
	..()
	cut_overlays()
	if(opened)
		if(!cell)
			add_overlay("inducer-nobat")
		else
			add_overlay("inducer-bat")

//////// Variants
/obj/item/inducer/sci
	name = "inducer"
	desc = "A tool for inductively charging internal power cells. This one has a science color scheme, and is less potent than its engineering counterpart."
	icon_state = "inducer-sci"
	item_state = "inducer-sci"
	cell_type = null
	powertransfer = 500
	opened = TRUE

/obj/item/inducer/sci/Initialize()
	. = ..()
	update_icon() //To get the 'open' state applied

/obj/item/inducer/syndicate
	name = "suspicious inducer"
	desc = "A tool for inductively charging internal power cells. This one has a suspicious colour scheme, and seems to be rigged to transfer charge at a much faster rate."
	icon_state = "inducer-syndi"
	item_state = "inducer-syndi"
	powertransfer = 2000
	cell_type = /obj/item/cell/super
	charge_guns = TRUE

/obj/item/inducer/hybrid
	name = "hybrid-tech inducer"
	desc = "A tool for inductively charging internal power cells. This one has some flashy bits and recharges devices slower, but seems to recharge itself between uses."
	icon_state = "inducer-hybrid"
	item_state = "inducer-hybrid"
	powertransfer = 250
	cell_type = /obj/item/cell/void
	charge_guns = TRUE

// A 'human stand-in' cell for recharging 'nutrition' on synthetic humans (wow this is terrible! \o/)
#define NUTRITION_COEFF 0.05 // 1000 charge = 50 nutrition at 0.05
/obj/item/cell/standin
	name = "don't spawn this"
	desc = "this is for weird code use, don't spawn it!!!"

	charge = 100
	maxcharge = 100

	var/mob/living/carbon/human/hume

/obj/item/cell/standin/New(newloc, var/mob/living/carbon/human/H)
	..()
	hume = H
	charge = H.nutrition
	maxcharge = initial(H.nutrition)

	QDEL_IN(src, 20 SECONDS)


/obj/item/cell/standin/give(var/amount)
	. = ..(amount * NUTRITION_COEFF) //Shrink amount to store
	hume.adjust_nutrition(.) //Add the amount we really stored
	. /= NUTRITION_COEFF //Inflate amount to take from the giver

#undef NUTRITION_COEFF

// Various sideways-defined get_cells
/obj/mecha/get_cell()
	return cell

/obj/vehicle/get_cell()
	return cell
