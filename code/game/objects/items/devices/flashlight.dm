/obj/item/device/flashlight
	name = "flashlight"
	desc = "A hand-held emergency light."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "flashlight"
	w_class = ITEMSIZE_SMALL
	slot_flags = SLOT_BELT
	matter = list(DEFAULT_WALL_MATERIAL = 50,"glass" = 20)
	action_button_name = "Toggle Flashlight"
	var/on = 0
	var/brightness_on = 4 //luminosity when on
	var/flashlight_power = 0.8	//lighting power when on
	var/flashlight_colour = LIGHT_COLOR_INCANDESCENT_FLASHLIGHT	//lighting colour when on
	var/obj/item/weapon/cell/cell
	var/cell_type = /obj/item/weapon/cell/device
	var/list/brightness_levels
	var/brightness_level = "medium"
	var/power_usage
	var/power_use = 1

/obj/item/device/flashlight/Initialize()
	. = ..()
	update_icon()

/obj/item/device/flashlight/New()
	if(power_use)
		START_PROCESSING(SSobj, src)
		if(cell_type)
			cell = new cell_type(src)
			brightness_levels = list("low" = 0.25, "medium" = 0.5, "high" = 1)
			power_usage = brightness_levels[brightness_level]

	else
		verbs -= /obj/item/device/flashlight/verb/toggle
	..()

/obj/item/device/flashlight/Destroy()
	if(power_use)
		STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/device/flashlight/get_cell()
	return cell

/obj/item/device/flashlight/verb/toggle()
	set name = "Toggle Flashlight Brightness"
	set category = "Object"
	set src in usr
	set_brightness(usr)

/obj/item/device/flashlight/proc/set_brightness(mob/user as mob)
	var/choice = input("Choose a brightness level.") as null|anything in brightness_levels
	if(choice)
		brightness_level = choice
		power_usage = brightness_levels[choice]
		user << "<span class='notice'>You set the brightness level on \the [src] to [brightness_level].</span>"
		update_icon()

/obj/item/device/flashlight/process()
	if(on)
		if(cell)
			if(brightness_level && power_usage)
				if(power_usage < cell.charge)
					cell.charge -= power_usage
				else
					cell.charge = 0
					visible_message("<span class='warning'>\The [src] flickers before going dull.</span>")
					set_light(0)
					playsound(src.loc, 'sound/effects/sparks3.ogg', 10, 1, -3) //Small cue that your light went dull in your pocket.
					on = 0
					update_icon()

/obj/item/device/flashlight/update_icon()
	if(on)
		icon_state = "[initial(icon_state)]-on"

		if(brightness_level == "low")
			set_light(brightness_on/2, flashlight_power*0.75, flashlight_colour)
		else if(brightness_level == "high")
			set_light(brightness_on*1.5, flashlight_power*1.1, flashlight_colour)
		else
			set_light(brightness_on, flashlight_power, flashlight_colour)

	else
		icon_state = "[initial(icon_state)]"
		set_light(0)

/obj/item/device/flashlight/examine(mob/user)
	..()
	if(power_use && brightness_level)
		var/tempdesc
		tempdesc += "\The [src] is set to [brightness_level]. "
		if(cell)
			tempdesc += "\The [src] has a \the [cell] attached. "

			if(cell.charge <= cell.maxcharge*0.25)
				tempdesc += "It appears to have a low amount of power remaining."
			else if(cell.charge > cell.maxcharge*0.25 && cell.charge <= cell.maxcharge*0.5)
				tempdesc += "It appears to have an average amount of power remaining."
			else if(cell.charge > cell.maxcharge*0.5 && cell.charge <= cell.maxcharge*0.75)
				tempdesc += "It appears to have an above average amount of power remaining."
			else if(cell.charge > cell.maxcharge*0.75 && cell.charge <= cell.maxcharge)
				tempdesc += "It appears to have a high amount of power remaining."

		user << "[tempdesc]"

/obj/item/device/flashlight/attack_self(mob/user)
	if(power_use)
		if(!isturf(user.loc))
			user << "You cannot turn the light on while in this [user.loc]." //To prevent some lighting anomalities.
			return 0
		if(!cell || cell.charge == 0)
			user << "You flick the switch on [src], but nothing happens."
			return 0
	on = !on
	playsound(src.loc, 'sound/weapons/empty.ogg', 15, 1, -3)
	update_icon()
	user.update_action_buttons()
	return 1

/obj/item/device/flashlight/emp_act(severity)
	for(var/obj/O in contents)
		O.emp_act(severity)
	..()

/obj/item/device/flashlight/attack(mob/living/M as mob, mob/living/user as mob)
	add_fingerprint(user)
	if(on && user.zone_sel.selecting == O_EYES)

		if((CLUMSY in user.mutations) && prob(50))	//too dumb to use flashlight properly
			return ..()	//just hit them in the head

		var/mob/living/carbon/human/H = M	//mob has protective eyewear
		if(istype(H))
			for(var/obj/item/clothing/C in list(H.head,H.wear_mask,H.glasses))
				if(istype(C) && (C.body_parts_covered & EYES))
					user << "<span class='warning'>You're going to need to remove [C.name] first.</span>"
					return

			var/obj/item/organ/vision
			if(H.species.vision_organ)
				vision = H.internal_organs_by_name[H.species.vision_organ]
			if(!vision)
				user << "<span class='warning'>You can't find any [H.species.vision_organ ? H.species.vision_organ : "eyes"] on [H]!</span>"

			user.visible_message("<span class='notice'>\The [user] directs [src] to [M]'s eyes.</span>", \
							 	 "<span class='notice'>You direct [src] to [M]'s eyes.</span>")
			if(H != user)	//can't look into your own eyes buster
				if(M.stat == DEAD || M.blinded)	//mob is dead or fully blind
					user << "<span class='warning'>\The [M]'s pupils do not react to the light!</span>"
					return
				if(XRAY in M.mutations)
					user << "<span class='notice'>\The [M] pupils give an eerie glow!</span>"
				if(vision.is_bruised())
					user << "<span class='warning'>There's visible damage to [M]'s [vision.name]!</span>"
				else if(M.eye_blurry)
					user << "<span class='notice'>\The [M]'s pupils react slower than normally.</span>"
				if(M.getBrainLoss() > 15)
					user << "<span class='notice'>There's visible lag between left and right pupils' reactions.</span>"

				var/list/pinpoint = list("oxycodone"=1,"tramadol"=5)
				var/list/dilating = list("space_drugs"=5,"mindbreaker"=1)
				if(M.reagents.has_any_reagent(pinpoint) || H.ingested.has_any_reagent(pinpoint))
					user << "<span class='notice'>\The [M]'s pupils are already pinpoint and cannot narrow any more.</span>"
				else if(M.reagents.has_any_reagent(dilating) || H.ingested.has_any_reagent(dilating))
					user << "<span class='notice'>\The [M]'s pupils narrow slightly, but are still very dilated.</span>"
				else
					user << "<span class='notice'>\The [M]'s pupils narrow.</span>"

			user.setClickCooldown(user.get_attack_speed(src)) //can be used offensively
			M.flash_eyes()
	else
		return ..()

/obj/item/device/flashlight/attack_hand(mob/user as mob)
	if(user.get_inactive_hand() == src)
		if(cell)
			cell.update_icon()
			user.put_in_hands(cell)
			cell = null
			user << "<span class='notice'>You remove the cell from the [src].</span>"
			playsound(src, 'sound/machines/button.ogg', 30, 1, 0)
			on = 0
			update_icon()
			return
		..()
	else
		return ..()

/obj/item/device/flashlight/MouseDrop(obj/over_object as obj)
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

/obj/item/device/flashlight/attackby(obj/item/weapon/W, mob/user as mob)
	if(power_use)
		if(istype(W, /obj/item/weapon/cell))
			if(istype(W, /obj/item/weapon/cell/device))
				if(!cell)
					user.drop_item()
					W.loc = src
					cell = W
					user << "<span class='notice'>You install a cell in \the [src].</span>"
					playsound(src, 'sound/machines/button.ogg', 30, 1, 0)
					update_icon()
				else
					user << "<span class='notice'>\The [src] already has a cell.</span>"
			else
				user << "<span class='notice'>\The [src] cannot use that type of cell.</span>"

	else
		..()

/obj/item/device/flashlight/pen
	name = "penlight"
	desc = "A pen-sized light, used by medical staff."
	icon_state = "penlight"
	item_state = "pen"
	slot_flags = SLOT_EARS
	brightness_on = 2
	w_class = ITEMSIZE_TINY
	power_use = 0

/obj/item/device/flashlight/color	//Default color is blue, just roll with it.
	name = "blue flashlight"
	desc = "A hand-held emergency light. This one is blue."
	icon_state = "flashlight_blue"

/obj/item/device/flashlight/color/red
	name = "red flashlight"
	desc = "A hand-held emergency light. This one is red."
	icon_state = "flashlight_red"

/obj/item/device/flashlight/color/orange
	name = "orange flashlight"
	desc = "A hand-held emergency light. This one is orange."
	icon_state = "flashlight_orange"

/obj/item/device/flashlight/color/yellow
	name = "yellow flashlight"
	desc = "A hand-held emergency light. This one is yellow."
	icon_state = "flashlight_yellow"

/obj/item/device/flashlight/maglight
	name = "maglight"
	desc = "A very, very heavy duty flashlight."
	icon_state = "maglight"
	flashlight_colour = LIGHT_COLOR_FLUORESCENT_FLASHLIGHT
	force = 10
	slot_flags = SLOT_BELT
	w_class = ITEMSIZE_SMALL
	attack_verb = list ("smacked", "thwacked", "thunked")
	matter = list(DEFAULT_WALL_MATERIAL = 200,"glass" = 50)
	hitsound = "swing_hit"

/obj/item/device/flashlight/drone
	name = "low-power flashlight"
	desc = "A miniature lamp, that might be used by small robots."
	icon_state = "penlight"
	item_state = null
	brightness_on = 2
	w_class = ITEMSIZE_TINY
	power_use = 0

// the desk lamps are a bit special
/obj/item/device/flashlight/lamp
	name = "desk lamp"
	desc = "A desk lamp with an adjustable mount."
	icon_state = "lamp"
	force = 10
	brightness_on = 5
	w_class = ITEMSIZE_LARGE
	power_use = 0
	on = 1


// green-shaded desk lamp
/obj/item/device/flashlight/lamp/green
	desc = "A classic green-shaded desk lamp."
	icon_state = "lampgreen"
	brightness_on = 5
	flashlight_colour = "#FFC58F"

/obj/item/device/flashlight/lamp/verb/toggle_light()
	set name = "Toggle light"
	set category = "Object"
	set src in oview(1)

	if(!usr.stat)
		attack_self(usr)

// FLARES

/obj/item/device/flashlight/flare
	name = "flare"
	desc = "A red standard-issue flare. There are instructions on the side reading 'pull cord, make light'."
	w_class = ITEMSIZE_SMALL
	brightness_on = 8 // Pretty bright.
	flashlight_power = 0.8
	flashlight_colour = LIGHT_COLOR_FLARE
	icon_state = "flare"
	item_state = "flare"
	action_button_name = null //just pull it manually, neckbeard.
	var/fuel = 0
	var/on_damage = 7
	var/produce_heat = 1500
	power_use = 0

/obj/item/device/flashlight/flare/New()
	fuel = rand(800, 1000) // Sorry for changing this so much but I keep under-estimating how long X number of ticks last in seconds.
	..()

/obj/item/device/flashlight/flare/process()
	var/turf/pos = get_turf(src)
	if(pos)
		pos.hotspot_expose(produce_heat, 5)
	fuel = max(fuel - 1, 0)
	if(!fuel || !on)
		turn_off()
		if(!fuel)
			src.icon_state = "[initial(icon_state)]-empty"
		STOP_PROCESSING(SSobj, src)

/obj/item/device/flashlight/flare/proc/turn_off()
	on = 0
	src.force = initial(src.force)
	src.damtype = initial(src.damtype)
	update_icon()

/obj/item/device/flashlight/flare/attack_self(mob/user)

	// Usual checks
	if(!fuel)
		user << "<span class='notice'>It's out of fuel.</span>"
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

/obj/item/device/flashlight/flare/proc/ignite() //Used for flare launchers.
	on = !on
	update_icon()
	force = on_damage
	damtype = "fire"
	START_PROCESSING(SSobj, src)
	return 1

//Glowsticks

/obj/item/device/flashlight/glowstick
	name = "green glowstick"
	desc = "A green military-grade glowstick."
	w_class = ITEMSIZE_SMALL
	brightness_on = 4
	flashlight_power = 0.9
	flashlight_colour = "#49F37C"
	icon_state = "glowstick"
	item_state = "glowstick"
	var/fuel = 0
	power_use = 0

/obj/item/device/flashlight/glowstick/New()
	fuel = rand(1600, 2000)
	..()

/obj/item/device/flashlight/glowstick/process()
	fuel = max(fuel - 1, 0)
	if(!fuel || !on)
		turn_off()
		if(!fuel)
			src.icon_state = "[initial(icon_state)]-empty"
		STOP_PROCESSING(SSobj, src)

/obj/item/device/flashlight/glowstick/proc/turn_off()
	on = 0
	update_icon()

/obj/item/device/flashlight/glowstick/attack_self(mob/user)

	if(!fuel)
		user << "<span class='notice'>The glowstick has already been turned on.</span>"
		return
	if(on)
		return

	. = ..()
	if(.)
		user.visible_message("<span class='notice'>[user] cracks and shakes the glowstick.</span>", "<span class='notice'>You crack and shake the glowstick, turning it on!</span>")
		START_PROCESSING(SSobj, src)

/obj/item/device/flashlight/glowstick/red
	name = "red glowstick"
	desc = "A red military-grade glowstick."
	flashlight_colour = "#FC0F29"
	icon_state = "glowstick_red"
	item_state = "glowstick_red"

/obj/item/device/flashlight/glowstick/blue
	name = "blue glowstick"
	desc = "A blue military-grade glowstick."
	flashlight_colour = "#599DFF"
	icon_state = "glowstick_blue"
	item_state = "glowstick_blue"

/obj/item/device/flashlight/glowstick/orange
	name = "orange glowstick"
	desc = "A orange military-grade glowstick."
	flashlight_colour = "#FA7C0B"
	icon_state = "glowstick_orange"
	item_state = "glowstick_orange"

/obj/item/device/flashlight/glowstick/yellow
	name = "yellow glowstick"
	desc = "A yellow military-grade glowstick."
	flashlight_colour = "#FEF923"
	icon_state = "glowstick_yellow"
	item_state = "glowstick_yellow"

/obj/item/device/flashlight/slime
	gender = PLURAL
	name = "glowing slime extract"
	desc = "A slimy ball that appears to be glowing from bioluminesence."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "floor1" //not a slime extract sprite but... something close enough!
	item_state = "slime"
	flashlight_colour = "#FFF423"
	w_class = ITEMSIZE_TINY
	brightness_on = 6
	on = 1 //Bio-luminesence has one setting, on.
	power_use = 0

/obj/item/device/flashlight/slime/New()
	..()
	set_light(brightness_on, flashlight_power, flashlight_colour)

/obj/item/device/flashlight/slime/update_icon()
	return

/obj/item/device/flashlight/slime/attack_self(mob/user)
	return //Bio-luminescence does not toggle.
