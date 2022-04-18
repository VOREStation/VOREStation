/obj/machinery/oxygen_pump
	name = "emergency oxygen pump"
	icon = 'icons/obj/walllocker.dmi'
	desc = "A wall mounted oxygen pump with a retractable mask that you can pull over your face in case of emergencies."
	icon_state = "oxygen_tank"

	anchored = TRUE

	var/obj/item/tank/tank
	var/mob/living/carbon/breather
	var/obj/item/clothing/mask/breath/contained

	var/spawn_type = /obj/item/tank/emergency/oxygen/engi
	var/mask_type = /obj/item/clothing/mask/breath/emergency
	var/icon_state_open = "oxygen_tank_open"
	var/icon_state_closed = "oxygen_tank"

	power_channel = ENVIRON
	idle_power_usage = 10
	active_power_usage = 120 // No idea what the realistic amount would be.

/obj/machinery/oxygen_pump/Initialize()
	. = ..()
	tank = new spawn_type (src)
	contained = new mask_type (src)

/obj/machinery/oxygen_pump/Destroy()
	if(breather)
		breather.internal = null
		if(breather.internals)
			breather.internals.icon_state = "internal0"
		breather.remove_from_mob(contained)
		visible_message("<span class='notice'>\The [contained] rapidly retracts just before /the [src] is destroyed!</span>")
		breather = null

	QDEL_NULL(tank)
	QDEL_NULL(contained)
	return ..()

/obj/machinery/oxygen_pump/MouseDrop(var/mob/living/carbon/human/target, src_location, over_location)
	var/mob/living/user = usr
	if(!istype(user) || !istype(target))
		return ..()

	if(CanMouseDrop(target, user))
		if(!can_apply_to_target(target, usr)) // There is no point in attempting to apply a mask if it's impossible.
			return
		usr.visible_message("\The [usr] begins placing \the [contained] onto [target].")
		if(!do_mob(usr, target, 25) || !can_apply_to_target(target, usr))
			return
		// place mask and add fingerprints
		usr.visible_message("\The [usr] has placed \the [contained] on [target]'s mouth.")
		attach_mask(target)
		src.add_fingerprint(usr)

/obj/machinery/oxygen_pump/attack_hand(mob/user as mob)
	if((stat & MAINT) && tank)
		user.visible_message("<b>\The [user]</b> removes \the [tank] from \the [src].", "<span class='notice'>You remove \the [tank] from \the [src].</span>")
		user.put_in_hands(tank)
		src.add_fingerprint(user)
		tank.add_fingerprint(user)
		tank = null
		return
	if (!tank)
		to_chat(user, "<span class='warning'>There is no tank in \the [src]!</span>")
		return
	if(breather)
		if(tank)
			tank.forceMove(src)
		breather.remove_from_mob(contained)
		contained.forceMove(src)
		src.visible_message("<b>\The [user]</b> makes \the [contained] rapidly retract back into \the [src]!")
		if(breather.internals)
			breather.internals.icon_state = "internal0"
		breather = null
		update_use_power(USE_POWER_IDLE)

/obj/machinery/oxygen_pump/attack_ai(mob/user as mob)
	tgui_interact(user)

/obj/machinery/oxygen_pump/proc/attach_mask(var/mob/living/carbon/C)
	if(C && istype(C))
		contained.forceMove(get_turf(C))
		C.equip_to_slot(contained, slot_wear_mask)
		if(tank)
			tank.forceMove(C)
		breather = C
		spawn(1)
		if(!breather.internal && tank)
			breather.internal = tank
			if(breather.internals)
				breather.internals.icon_state = "internal1"
		update_use_power(USE_POWER_ACTIVE)

/obj/machinery/oxygen_pump/proc/can_apply_to_target(var/mob/living/carbon/human/target, mob/user as mob)
	if(!user)
		user = target
	// Check target validity
	if(!target.organs_by_name[BP_HEAD])
		to_chat(user, "<span class='warning'>\The [target] doesn't have a head.</span>")
		return
	if(!target.check_has_mouth())
		to_chat(user, "<span class='warning'>\The [target] doesn't have a mouth.</span>")
		return
	if(target.wear_mask && target != breather)
		to_chat(user, "<span class='warning'>\The [target] is already wearing a mask.</span>")
		return
	if(target.head && (target.head.body_parts_covered & FACE))
		to_chat(user, "<span class='warning'>Remove their [target.head] first.</span>")
		return
	if(!tank)
		to_chat(user, "<span class='warning'>There is no tank in \the [src].</span>")
		return
	if(stat & MAINT)
		to_chat(user, "<span class='warning'>Please close the maintenance hatch first.</span>")
		return
	if(!Adjacent(target))
		to_chat(user, "<span class='warning'>Please stay close to \the [src].</span>")
		return
	//when there is a breather:
	if(breather && target != breather)
		to_chat(user, "<span class='warning'>\The pump is already in use.</span>")
		return
	//Checking if breather is still valid
	if(target == breather && target.wear_mask != contained)
		to_chat(user, "<span class='warning'>\The [target] is not using the supplied [contained].</span>")
		return
	return 1

/obj/machinery/oxygen_pump/attackby(obj/item/W as obj, mob/user as mob)
	if(W.is_screwdriver())
		stat ^= MAINT
		user.visible_message("<span class='notice'>\The [user] [(stat & MAINT) ? "opens" : "closes"] \the [src].</span>", "<span class='notice'>You [(stat & MAINT) ? "open" : "close"] \the [src].</span>")
		icon_state = (stat & MAINT) ? icon_state_open : icon_state_closed
		//TO-DO: Open icon
	if(istype(W, /obj/item/tank) && (stat & MAINT))
		if(tank)
			to_chat(user, "<span class='warning'>\The [src] already has a tank installed!</span>")
		else
			user.drop_item()
			W.forceMove(src)
			tank = W
			user.visible_message("<b>\The [user]</b> installs \the [tank] into \the [src].", "<span class='notice'>You install \the [tank] into \the [src].</span>")
			src.add_fingerprint(user)
	if(istype(W, /obj/item/tank) && !stat)
		to_chat(user, "<span class='warning'>Please open the maintenance hatch first.</span>")

/obj/machinery/oxygen_pump/examine(var/mob/user)
	. = ..()
	if(tank)
		. += "The meter shows [round(tank.air_contents.return_pressure())] kPa."
	else
		. += "<span class='warning'>It is missing a tank!</span>"


/obj/machinery/oxygen_pump/process()
	if(breather)
		if(!can_apply_to_target(breather))
			if(tank)
				tank.forceMove(src)
			breather.remove_from_mob(contained)
			contained.forceMove(src)
			src.visible_message("<span class='notice'>\The [contained] rapidly retracts back into \the [src]!</span>")
			breather = null
			update_use_power(USE_POWER_IDLE)
		else if(!breather.internal && tank)
			breather.internal = tank
			if(breather.internals)
				breather.internals.icon_state = "internal0"

//Create rightclick to view tank settings
/obj/machinery/oxygen_pump/verb/settings()
	set src in oview(1)
	set category = "Object"
	set name = "Show Tank Settings"
	tgui_interact(usr)

/obj/machinery/oxygen_pump/tgui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	if(!tank)
		to_chat(user, "<span class='warning'>[src] is missing a tank.</span>")
		if(ui)
			ui.close()
		return

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Tank", name)
		ui.open()

/obj/machinery/oxygen_pump/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()

	data["showToggle"] = FALSE
	data["maskConnected"] = !!breather

	data["tankPressure"] = 0
	data["releasePressure"] = 0
	data["defaultReleasePressure"] = 0
	data["minReleasePressure"] = 0
	data["releasePressure"] = round(tank.distribute_pressure ? tank.distribute_pressure : 0)
	data["maxReleasePressure"] = round(TANK_MAX_RELEASE_PRESSURE)

	if(tank)
		data["tankPressure"] = round(tank.air_contents.return_pressure() ? tank.air_contents.return_pressure() : 0)
		data["defaultReleasePressure"] = round(TANK_DEFAULT_RELEASE_PRESSURE)

	return data

/obj/machinery/oxygen_pump/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	switch(action)
		if("pressure")
			var/pressure = params["pressure"]
			if(pressure == "reset")
				pressure = TANK_DEFAULT_RELEASE_PRESSURE
				. = TRUE
			else if(pressure == "min")
				pressure = 0
				. = TRUE
			else if(pressure == "max")
				pressure = TANK_MAX_RELEASE_PRESSURE
				. = TRUE
			else if(text2num(pressure) != null)
				pressure = text2num(pressure)
				. = TRUE
			if(.)
				tank.distribute_pressure = clamp(round(pressure), 0, TANK_MAX_RELEASE_PRESSURE)

/obj/machinery/oxygen_pump/anesthetic
	name = "anesthetic pump"
	desc = "A wall mounted anesthetic pump with a retractable mask that someone can pull over your face to knock you out."
	spawn_type = /obj/item/tank/anesthetic
	icon_state = "anesthetic_tank"
	icon_state_closed = "anesthetic_tank"
	icon_state_open = "anesthetic_tank_open"
	mask_type = /obj/item/clothing/mask/breath/anesthetic

/obj/machinery/oxygen_pump/mobile
	name = "portable oxygen pump"
	icon = 'icons/obj/atmos.dmi'
	desc = "A portable oxygen pump with a retractable mask that you can pull over your face in case of emergencies."
	icon_state = "medpump"
	icon_state_open = "medpump_open"
	icon_state_closed = "medpump"

	anchored = FALSE
	density = TRUE

	mask_type = /obj/item/clothing/mask/gas/clear

	var/last_area = null

/obj/machinery/oxygen_pump/mobile/process()
	..()

	var/turf/T = get_turf(src)

	if(!last_area && T)
		last_area = T.loc

	if(last_area != T.loc)
		power_change()
		last_area = T.loc

/obj/machinery/oxygen_pump/mobile/anesthetic
	name = "portable anesthetic pump"
	desc = "A portable anesthetic pump with a retractable mask that someone can pull over your face to knock you out."
	spawn_type = /obj/item/tank/anesthetic
	icon_state = "medpump_n2o"
	icon_state_closed = "medpump_n2o"
	icon_state_open = "medpump_n2o_open"
	mask_type = /obj/item/clothing/mask/breath/anesthetic

/obj/machinery/oxygen_pump/mobile/stabilizer
	name = "portable patient stabilizer"
	desc = "A portable oxygen pump with a retractable mask used for stabilizing patients in the field."

/obj/machinery/oxygen_pump/mobile/stabilizer/process()
	if(breather)
		if(!can_apply_to_target(breather))
			if(tank)
				tank.forceMove(src)
			breather.remove_from_mob(contained)
			contained.forceMove(src)
			src.visible_message("<span class='notice'>\The [contained] rapidly retracts back into \the [src]!</span>")
			breather = null
			update_use_power(USE_POWER_IDLE)
		else if(!breather.internal && tank)
			breather.internal = tank
			if(breather.internals)
				breather.internals.icon_state = "internal0"

		if(breather)	// Safety.
			if(ishuman(breather) && !(breather.isSynthetic()))
				var/mob/living/carbon/human/H = breather

				if(H.internal_organs_by_name[O_LUNGS])
					var/obj/item/organ/internal/L = H.internal_organs_by_name[O_LUNGS]
					if(L)
						if(!(L.status & ORGAN_DEAD))
							H.adjustOxyLoss(-(rand(10,15)))

							if(L.is_bruised() && prob(30))
								L.take_damage(-1)
							else
								H.AdjustLosebreath(-(rand(1, 5)))
						else
							H.adjustOxyLoss(-(rand(1,8)))

				if(H.stat == DEAD)
					H.add_modifier(/datum/modifier/bloodpump_corpse, 6 SECONDS)

				else
					H.add_modifier(/datum/modifier/bloodpump, 6 SECONDS)

	var/turf/T = get_turf(src)

	if(!last_area && T)
		last_area = T.loc

	if(last_area != T.loc)
		power_change()
		last_area = T.loc
