/obj/item/rcd
	icon = 'icons/obj/tools_vr.dmi'
	icon_state = "rcd"
	item_state = "rcd"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_vr.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_vr.dmi',
	)
	var/ammostate
	var/list/effects = list()

	var/static/image/radial_image_airlock = image(icon = 'icons/mob/radial.dmi', icon_state = "airlock")
	var/static/image/radial_image_decon = image(icon= 'icons/mob/radial.dmi', icon_state = "delete")
	var/static/image/radial_image_grillewind = image(icon = 'icons/mob/radial.dmi', icon_state = "grillewindow")
	var/static/image/radial_image_floorwall = image(icon = 'icons/mob/radial.dmi', icon_state = "wallfloor")

// Ammo for the (non-electric) RCDs.
/obj/item/rcd_ammo
	name = "compressed matter cartridge"
	desc = "Highly compressed matter for the RCD."
	icon = 'icons/obj/tools_vr.dmi'
	icon_state = "rcdammo"
	item_state = "rcdammo"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_vr.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_vr.dmi',
	)

/obj/item/rcd/Initialize()
	. = ..()
	update_icon()

/obj/item/rcd/consume_resources(amount)
	. = ..()
	update_icon()

/obj/item/rcd/update_icon()
	var/nearest_ten = round((stored_matter/max_stored_matter)*10, 1)

	//Just to prevent updates every use
	if(ammostate == nearest_ten)
		return //No change
	ammostate = nearest_ten

	cut_overlays()

	//Main sprite update
	if(!nearest_ten)
		icon_state = "[initial(icon_state)]_empty"
	else
		icon_state = "[initial(icon_state)]"

	add_overlay("[initial(icon_state)]_charge[nearest_ten]")

/obj/item/rcd/proc/perform_effect(var/atom/A, var/time_taken)
	effects[A] = new /obj/effect/constructing_effect(get_turf(A), time_taken, modes[mode_index])

/obj/item/rcd/use_rcd(atom/A, mob/living/user)
	. = ..()
	cleanup_effect(A)

/obj/item/rcd/proc/cleanup_effect(var/atom/A)
	if(A in effects)
		qdel(effects[A])
		effects -= A

/obj/item/rcd/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/rcd_ammo))
		var/obj/item/rcd_ammo/cartridge = W
		var/can_store = min(max_stored_matter - stored_matter, cartridge.remaining)
		if(can_store <= 0)
			to_chat(user, span("warning", "There's either no space or \the [cartridge] is empty!"))
			return FALSE
		stored_matter += can_store
		cartridge.remaining -= can_store
		if(!cartridge.remaining)
			to_chat(user, span("warning", "\The [cartridge] dissolves as it empties of compressed matter."))
			user.drop_from_inventory(W)
			qdel(W)
		playsound(src, 'sound/machines/click.ogg', 50, 1)
		to_chat(user, span("notice", "The RCD now holds [stored_matter]/[max_stored_matter] matter-units."))
		update_icon()
		return TRUE
	return ..()

/obj/item/rcd/proc/check_menu(mob/living/user)
	if(!istype(user))
		return FALSE
	if(user.incapacitated() || !user.Adjacent(src))
		return FALSE
	return TRUE

// Mounted one is more complex
/obj/item/rcd/electric/mounted/rig/check_menu(mob/living/user)
	if(!istype(user))
		world.log << "One"
		return FALSE
	if(user.incapacitated())
		world.log << "Two"
		return FALSE

	var/obj/item/rig_module/device/D = loc
	if(!istype(D) || !D?.holder?.wearer == user)
		world.log << "Three"
		return FALSE

	return TRUE

/obj/item/rcd/attack_self(mob/living/user)
	..()
	var/list/choices = list(
		"Airlock" = radial_image_airlock,
		"Deconstruct" = radial_image_decon,
		"Grilles & Windows" = radial_image_grillewind,
		"Floors & Walls" = radial_image_floorwall
	)
	/* We don't have these features yet
	if(upgrade & RCD_UPGRADE_FRAMES)
		choices += list(
		"Machine Frames" = image(icon = 'icons/mob/radial.dmi', icon_state = "machine"),
		"Computer Frames" = image(icon = 'icons/mob/radial.dmi', icon_state = "computer_dir"),
		)
	if(upgrade & RCD_UPGRADE_SILO_LINK)
		choices += list(
		"Silo Link" = image(icon = 'icons/obj/mining.dmi', icon_state = "silo"),
		)
	if(mode == RCD_AIRLOCK)
		choices += list(
		"Change Access" = image(icon = 'icons/mob/radial.dmi', icon_state = "access"),
		"Change Airlock Type" = image(icon = 'icons/mob/radial.dmi', icon_state = "airlocktype")
		)
	else if(mode == RCD_WINDOWGRILLE)
		choices += list(
			"Change Window Type" = image(icon = 'icons/mob/radial.dmi', icon_state = "windowtype")
		)
	*/
	var/choice = show_radial_menu(user, user, choices, custom_check = CALLBACK(src, PROC_REF(check_menu), user), tooltips = TRUE)
	if(!check_menu(user))
		return
	switch(choice)
		if("Floors & Walls")
			mode_index = modes.Find(RCD_FLOORWALL)
		if("Airlock")
			mode_index = modes.Find(RCD_AIRLOCK)
		if("Deconstruct")
			mode_index = modes.Find(RCD_DECONSTRUCT)
		if("Grilles & Windows")
			mode_index = modes.Find(RCD_WINDOWGRILLE)
		/* We don't have these features yet
		if("Machine Frames")
			mode = RCD_MACHINE
		if("Computer Frames")
			mode = RCD_COMPUTER
			change_computer_dir(user)
			return
		if("Change Access")
			change_airlock_access(user)
			return
		if("Change Airlock Type")
			change_airlock_setting(user)
			return
		if("Change Window Type")
			toggle_window_type(user)
			return
		if("Silo Link")
			toggle_silo_link(user)
			return
		*/
		else
			return
	playsound(src, 'sound/effects/pop.ogg', 50, FALSE)
	to_chat(user, "<span class='notice'>You change RCD's mode to '[choice]'.</span>")

//////////////////
/obj/item/rcd/electric/update_icon()
	return

/obj/item/rcd/shipwright
	icon_state = "swrcd"
	item_state = "ircd"
	can_remove_rwalls = TRUE
	make_rwalls = TRUE

//////////////////
/obj/item/rcd_ammo/examine(mob/user)
	. = ..()
	. += display_resources()

// Used to show how much stuff (matter units, cell charge, etc) is left inside.
/obj/item/rcd_ammo/proc/display_resources()
	return "It currently holds [remaining]/[initial(remaining)] matter-units."

//////////////////
/obj/effect/constructing_effect
	icon = 'icons/effects/effects_rcd.dmi'
	icon_state = ""
	plane = TURF_PLANE
	layer = ABOVE_TURF_LAYER
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	var/status = 0
	var/delay = 0

/obj/effect/constructing_effect/Initialize(mapload, rcd_delay, rcd_status)
	. = ..()
	status = rcd_status
	delay = rcd_delay
	if (status == RCD_DECONSTRUCT)
		addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, update_icon)), 11)
		delay -= 11
		icon_state = "rcd_end_reverse"
	else
		update_icon()

/obj/effect/constructing_effect/update_icon()
	icon_state = "rcd"
	if (delay < 10)
		icon_state += "_shortest"
	else if (delay < 20)
		icon_state += "_shorter"
	else if (delay < 37)
		icon_state += "_short"
	if (status == RCD_DECONSTRUCT)
		icon_state += "_reverse"

/obj/effect/constructing_effect/proc/end_animation()
	if (status == RCD_DECONSTRUCT)
		qdel(src)
	else
		icon_state = "rcd_end"
		addtimer(CALLBACK(src, PROC_REF(end)), 15)

/obj/effect/constructing_effect/proc/end()
	qdel(src)
