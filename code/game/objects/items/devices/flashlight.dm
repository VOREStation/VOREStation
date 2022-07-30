/*
 * Contains:
 *		Flashlights
 *		Lamps
 *		Flares
 *		Chemlights
 *		Slime Extract
 */

/*
 * Flashlights
 */

/obj/item/flashlight
	name = "flashlight"
	desc = "A hand-held emergency light."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "flashlight"
	w_class = ITEMSIZE_SMALL
	slot_flags = SLOT_BELT
	matter = list(MAT_STEEL = 50,MAT_GLASS = 20)
	action_button_name = "Toggle Flashlight"

	light_system = MOVABLE_LIGHT_DIRECTIONAL
	light_range = 4 //luminosity when on
	light_power = 0.8	//lighting power when on
	light_color = "#FFFFFF" //LIGHT_COLOR_INCANDESCENT_FLASHLIGHT	//lighting colour when on
	light_cone_y_offset = -7

	var/on = 0

	var/obj/item/cell/cell
	var/cell_type = /obj/item/cell/device
	var/power_usage = 1
	var/power_use = 1

/obj/item/flashlight/Initialize()
	. = ..()

	if(power_use && cell_type)
		cell = new cell_type(src)

	update_brightness()

/obj/item/flashlight/Destroy()
	STOP_PROCESSING(SSobj, src)
	qdel_null(cell)
	return ..()

/obj/item/flashlight/get_cell()
	return cell

/obj/item/flashlight/process()
	if(!on || !cell)
		return PROCESS_KILL

	if(power_usage)
		if(cell.use(power_usage) != power_usage) // we weren't able to use our full power_usage amount!
			visible_message("<span class='warning'>\The [src] flickers before going dull.</span>")
			playsound(src, 'sound/effects/sparks3.ogg', 10, 1, -3) //Small cue that your light went dull in your pocket. //VOREStation Edit
			on = 0
			update_brightness()
			return PROCESS_KILL

/obj/item/flashlight/proc/update_brightness()
	if(on)
		icon_state = "[initial(icon_state)]-on"
	else
		icon_state = initial(icon_state)
	set_light_on(on)
	if(light_system == STATIC_LIGHT)
		update_light()

/obj/item/flashlight/examine(mob/user)
	. = ..()
	if(power_use && cell)
		. += "\The [src] has a \the [cell] attached."

		if(cell.charge <= cell.maxcharge*0.25)
			. += "It appears to have a low amount of power remaining."
		else if(cell.charge > cell.maxcharge*0.25 && cell.charge <= cell.maxcharge*0.5)
			. += "It appears to have an average amount of power remaining."
		else if(cell.charge > cell.maxcharge*0.5 && cell.charge <= cell.maxcharge*0.75)
			. += "It appears to have an above average amount of power remaining."
		else if(cell.charge > cell.maxcharge*0.75 && cell.charge <= cell.maxcharge)
			. += "It appears to have a high amount of power remaining."

/obj/item/flashlight/attack_self(mob/user)
	if(power_use)
		if(!isturf(user.loc))
			to_chat(user, "You cannot turn the light on while in this [user.loc].") //To prevent some lighting anomalities.
			return 0
		if(!cell || cell.charge == 0)
			to_chat(user, "You flick the switch on [src], but nothing happens.")
			return 0
	on = !on
	if(on && power_use)
		START_PROCESSING(SSobj, src)
	else if(power_use)
		STOP_PROCESSING(SSobj, src)
	playsound(src, 'sound/weapons/empty.ogg', 15, 1, -3) // VOREStation Edit
	update_brightness()
	user.update_action_buttons()
	return 1

/obj/item/flashlight/emp_act(severity)
	for(var/obj/O in contents)
		O.emp_act(severity)
	..()

/obj/item/flashlight/attack(mob/living/M as mob, mob/living/user as mob)
	add_fingerprint(user)
	if(on && user.zone_sel.selecting == O_EYES)

		if((CLUMSY in user.mutations) && prob(50))	//too dumb to use flashlight properly
			return ..()	//just hit them in the head

		var/mob/living/carbon/human/H = M	//mob has protective eyewear
		if(istype(H))
			for(var/obj/item/clothing/C in list(H.head,H.wear_mask,H.glasses))
				if(istype(C) && (C.body_parts_covered & EYES))
					to_chat(user, "<span class='warning'>You're going to need to remove [C.name] first.</span>")
					return

			var/obj/item/organ/vision
			if(H.species.vision_organ)
				vision = H.internal_organs_by_name[H.species.vision_organ]
			if(!vision)
				to_chat(user, "<span class='warning'>You can't find any [H.species.vision_organ ? H.species.vision_organ : "eyes"] on [H]!</span>")

			user.visible_message("<b>\The [user]</b> directs [src] to [M]'s eyes.", \
							 	 "<span class='notice'>You direct [src] to [M]'s eyes.</span>")
			if(H != user)	//can't look into your own eyes buster
				if(M.stat == DEAD || M.blinded)	//mob is dead or fully blind
					to_chat(user, "<span class='warning'>\The [M]'s pupils do not react to the light!</span>")
					return
				if(XRAY in M.mutations)
					to_chat(user, "<span class='notice'>\The [M] pupils give an eerie glow!</span>")
				if(vision.is_bruised())
					to_chat(user, "<span class='warning'>There's visible damage to [M]'s [vision.name]!</span>")
				else if(M.eye_blurry)
					to_chat(user, "<span class='notice'>\The [M]'s pupils react slower than normally.</span>")
				if(M.getBrainLoss() > 15)
					to_chat(user, "<span class='notice'>There's visible lag between left and right pupils' reactions.</span>")

				var/list/pinpoint = list("oxycodone"=1,"tramadol"=5)
				var/list/dilating = list("bliss"=5,"ambrosia_extract"=5,"mindbreaker"=1)
				if(M.reagents.has_any_reagent(pinpoint) || H.ingested.has_any_reagent(pinpoint))
					to_chat(user, "<span class='notice'>\The [M]'s pupils are already pinpoint and cannot narrow any more.</span>")
				else if(M.reagents.has_any_reagent(dilating) || H.ingested.has_any_reagent(dilating))
					to_chat(user, "<span class='notice'>\The [M]'s pupils narrow slightly, but are still very dilated.</span>")
				else
					to_chat(user, "<span class='notice'>\The [M]'s pupils narrow.</span>")

			user.setClickCooldown(user.get_attack_speed(src)) //can be used offensively
			M.flash_eyes()
	else
		return ..()

/obj/item/flashlight/attack_hand(mob/user as mob)
	if(user.get_inactive_hand() == src)
		if(cell)
			cell.update_icon()
			user.put_in_hands(cell)
			cell = null
			to_chat(user, "<span class='notice'>You remove the cell from the [src].</span>")
			playsound(src, 'sound/machines/button.ogg', 30, 1, 0)
			on = 0
			update_brightness()
			return
		..()
	else
		return ..()

/obj/item/flashlight/MouseDrop(obj/over_object as obj)
	if(!canremove)
		return

	if (ishuman(usr) || issmall(usr)) //so monkeys can take off their backpacks -- Urist

		if (istype(usr.loc,/obj/mecha)) // stops inventory actions in a mech. why?
			return

		if (!( istype(over_object, /obj/screen) ))
			return ..()

		//makes sure that the thing is equipped, so that we can't drag it into our hand from miles away.
		//there's got to be a better way of doing this.
		if (!(src.loc == usr) || (src.loc && src.loc.loc == usr))
			return

		if (( usr.restrained() ) || ( usr.stat ))
			return

		if ((src.loc == usr) && !(istype(over_object, /obj/screen)) && !usr.unEquip(src))
			return

		switch(over_object.name)
			if("r_hand")
				usr.u_equip(src)
				usr.put_in_r_hand(src)
			if("l_hand")
				usr.u_equip(src)
				usr.put_in_l_hand(src)
		src.add_fingerprint(usr)

/obj/item/flashlight/attackby(obj/item/W, mob/user as mob)
	if(power_use)
		if(istype(W, /obj/item/cell))
			if(istype(W, /obj/item/cell/device))
				if(!cell)
					user.drop_item()
					W.loc = src
					cell = W
					to_chat(user, "<span class='notice'>You install a cell in \the [src].</span>")
					playsound(src, 'sound/machines/button.ogg', 30, 1, 0)
					update_brightness()
				else
					to_chat(user, "<span class='notice'>\The [src] already has a cell.</span>")
			else
				to_chat(user, "<span class='notice'>\The [src] cannot use that type of cell.</span>")

	else
		..()

/obj/item/flashlight/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(!on)
		return
	if(light_system == MOVABLE_LIGHT_DIRECTIONAL)
		var/datum/component/overlay_lighting/OL = GetComponent(/datum/component/overlay_lighting)
		if(!OL)
			return
		var/turf/T = get_turf(target)
		OL.place_directional_light(T)

/obj/item/flashlight/pen
	name = "penlight"
	desc = "A pen-sized light, used by medical staff."
	icon_state = "penlight"
	item_state = "pen"
	drop_sound = 'sound/items/drop/accessory.ogg'
	pickup_sound = 'sound/items/pickup/accessory.ogg'
	slot_flags = SLOT_EARS
	light_range = 2
	w_class = ITEMSIZE_TINY
	power_use = 0

/obj/item/flashlight/color	//Default color is blue
	name = "blue flashlight"
	desc = "A small flashlight. This one is blue."
	icon_state = "flashlight_blue"

/obj/item/flashlight/color/green
	name = "green flashlight"
	desc = "A small flashlight. This one is green."
	icon_state = "flashlight_green"

/obj/item/flashlight/color/purple
	name = "purple flashlight"
	desc = "A small flashlight. This one is purple."
	icon_state = "flashlight_purple"

/obj/item/flashlight/color/red
	name = "red flashlight"
	desc = "A small flashlight. This one is red."
	icon_state = "flashlight_red"

/obj/item/flashlight/color/orange
	name = "orange flashlight"
	desc = "A small flashlight. This one is orange."
	icon_state = "flashlight_orange"

/obj/item/flashlight/color/yellow
	name = "yellow flashlight"
	desc = "A small flashlight. This one is yellow."
	icon_state = "flashlight_yellow"

/obj/item/flashlight/maglight
	name = "maglight"
	desc = "A very, very heavy duty flashlight."
	icon_state = "maglight"
	light_color = LIGHT_COLOR_FLUORESCENT_FLASHLIGHT
	force = 10
	slot_flags = SLOT_BELT
	w_class = ITEMSIZE_SMALL
	attack_verb = list ("smacked", "thwacked", "thunked")
	matter = list(MAT_STEEL = 200,MAT_GLASS = 50)
	hitsound = "swing_hit"

/obj/item/flashlight/drone
	name = "low-power flashlight"
	desc = "A miniature lamp, that might be used by small robots."
	icon_state = "penlight"
	item_state = null
	light_range = 2
	w_class = ITEMSIZE_TINY
	power_use = 0

/*
 * Lamps
 */

// pixar desk lamp
/obj/item/flashlight/lamp
	name = "desk lamp"
	desc = "A desk lamp with an adjustable mount."
	icon_state = "lamp"
	force = 10
	center_of_mass = list("x" = 13,"y" = 11)
	light_range = 5
	w_class = ITEMSIZE_LARGE
	power_use = 0
	on = 1
	light_system = STATIC_LIGHT

/obj/item/flashlight/lamp/verb/toggle_light()
	set name = "Toggle light"
	set category = "Object"
	set src in oview(1)

	if(!usr.stat)
		attack_self(usr)

// green-shaded desk lamp
/obj/item/flashlight/lamp/green
	desc = "A classic green-shaded desk lamp."
	icon_state = "lampgreen"
	center_of_mass = list("x" = 15,"y" = 11)
	light_color = "#FFC58F"

// clown lamp
/obj/item/flashlight/lamp/clown
	desc = "A whacky banana peel shaped lamp."
	icon_state = "bananalamp"
	center_of_mass = list("x" = 15,"y" = 11)


/*
 * Flares
 */

/obj/item/flashlight/flare
	name = "flare"
	desc = "A red standard-issue flare. There are instructions on the side reading 'pull cord, make light'."
	w_class = ITEMSIZE_SMALL
	light_range = 8 // Pretty bright.
	light_power = 0.8
	light_color = LIGHT_COLOR_FLARE
	icon_state = "flare"
	item_state = "flare"
	action_button_name = null //just pull it manually, neckbeard.
	var/fuel = 0
	var/on_damage = 7
	var/produce_heat = 1500
	power_use = 0
	drop_sound = 'sound/items/drop/gloves.ogg'
	pickup_sound = 'sound/items/pickup/gloves.ogg'
	light_system = MOVABLE_LIGHT

/obj/item/flashlight/flare/New()
	fuel = rand(800, 1000) // Sorry for changing this so much but I keep under-estimating how long X number of ticks last in seconds.
	..()

/obj/item/flashlight/flare/process()
	var/turf/pos = get_turf(src)
	if(pos)
		pos.hotspot_expose(produce_heat, 5)
	fuel = max(fuel - 1, 0)
	if(!fuel || !on)
		turn_off()
		if(!fuel)
			src.icon_state = "[initial(icon_state)]-empty"
		STOP_PROCESSING(SSobj, src)

/obj/item/flashlight/flare/proc/turn_off()
	on = 0
	src.force = initial(src.force)
	src.damtype = initial(src.damtype)
	update_brightness()

/obj/item/flashlight/flare/attack_self(mob/user)

	// Usual checks
	if(!fuel)
		to_chat(user, "<span class='notice'>It's out of fuel.</span>")
		return
	if(on)
		return

	. = ..()
	// All good, turn it on.
	if(.)
		user.visible_message("<span class='notice'>[user] activates the flare.</span>", "<span class='notice'>You pull the cord on the flare, activating it!</span>")
		src.force = on_damage
		src.damtype = "fire"
		START_PROCESSING(SSobj, src)

/obj/item/flashlight/flare/proc/ignite() //Used for flare launchers.
	on = !on
	update_brightness()
	force = on_damage
	damtype = "fire"
	START_PROCESSING(SSobj, src)
	return 1

/*
 * Chemlights
 */

/obj/item/flashlight/glowstick
	name = "green glowstick"
	desc = "A green military-grade chemical light."
	w_class = ITEMSIZE_SMALL
	light_system = MOVABLE_LIGHT
	light_range = 4
	light_power = 0.9
	light_color = "#49F37C"
	icon_state = "glowstick_green"
	item_state = "glowstick_green"
	var/fuel = 0
	power_use = 0

/obj/item/flashlight/glowstick/New()
	fuel = rand(1600, 2000)
	..()

/obj/item/flashlight/glowstick/process()
	fuel = max(fuel - 1, 0)
	if(!fuel || !on)
		turn_off()
		if(!fuel)
			src.icon_state = "[initial(icon_state)]-empty"
		STOP_PROCESSING(SSobj, src)

/obj/item/flashlight/glowstick/proc/turn_off()
	on = 0
	update_brightness()

/obj/item/flashlight/glowstick/attack_self(mob/user)

	if(!fuel)
		to_chat(user, "<span class='notice'>The glowstick has already been turned on.</span>")
		return
	if(on)
		return

	. = ..()
	if(.)
		user.visible_message("<span class='notice'>[user] cracks and shakes \the [name].</span>", "<span class='notice'>You crack and shake \the [src], turning it on!</span>")
		START_PROCESSING(SSobj, src)

/obj/item/flashlight/glowstick/red
	name = "red glowstick"
	desc = "A red military-grade chemical light."
	light_color = "#FC0F29"
	icon_state = "glowstick_red"
	item_state = "glowstick_red"

/obj/item/flashlight/glowstick/blue
	name = "blue glowstick"
	desc = "A blue military-grade chemical light."
	light_color = "#599DFF"
	icon_state = "glowstick_blue"
	item_state = "glowstick_blue"

/obj/item/flashlight/glowstick/orange
	name = "orange glowstick"
	desc = "A orange military-grade chemical light."
	light_color = "#FA7C0B"
	icon_state = "glowstick_orange"
	item_state = "glowstick_orange"

/obj/item/flashlight/glowstick/yellow
	name = "yellow glowstick"
	desc = "A yellow military-grade chemical light."
	light_color = "#FEF923"
	icon_state = "glowstick_yellow"
	item_state = "glowstick_yellow"

/obj/item/flashlight/glowstick/radioisotope
	name = "radioisotope glowstick"
	desc = "A radioisotope powered chemical light. Escaping particles light up the area far brighter on similar levels to flares and for longer"
	icon_state = "glowstick_isotope"
	item_state = "glowstick_isotope"

	light_range = 8
	light_power = 0.1
	light_color = "#49F37C"
