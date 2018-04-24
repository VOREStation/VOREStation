/obj/item/device/laser_pointer
	name = "laser pointer"
	desc = "Don't shine it in your eyes!"
	icon = 'icons/obj/device_alt.dmi'
	icon_state = "pointer"
	item_state = "pen"
	var/pointer_icon_state
	flags = CONDUCT
	slot_flags = SLOT_BELT
	matter = list(DEFAULT_WALL_MATERIAL = 500, "glass" = 500)
	w_class = ITEMSIZE_SMALL
	origin_tech = list(TECH_COMBAT = 1, TECH_MAGNET = 2)
	var/energy = 5
	var/max_energy = 5
	var/effectchance = 33
	var/recharging = 0
	var/recharge_locked = 0
	var/obj/item/weapon/stock_parts/micro_laser/diode //used for upgrading!

/obj/item/device/laser_pointer/red
	pointer_icon_state = "red_laser"
/obj/item/device/laser_pointer/green
	pointer_icon_state = "green_laser"
/obj/item/device/laser_pointer/blue
	pointer_icon_state = "blue_laser"
/obj/item/device/laser_pointer/purple
	pointer_icon_state = "purple_laser"

/obj/item/device/laser_pointer/New()
	..()
	diode = new(src)
	if(!pointer_icon_state)
		pointer_icon_state = pick("red_laser","green_laser","blue_laser","purple_laser")

/obj/item/device/laser_pointer/upgraded/New()
	..()
	diode = new /obj/item/weapon/stock_parts/micro_laser/ultra

/obj/item/device/laser_pointer/Destroy()
	qdel_null(diode)
	processing_objects -= src
	. = ..()

/obj/item/device/laser_pointer/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/weapon/stock_parts/micro_laser))
		if(!diode)
			user.drop_item()
			W.forceMove(src)
			diode = W
			to_chat(user, "<span class='notice'>You install \a [diode] in [src].</span>")
		else
			to_chat(user, "<span class='notice'>\The [src] already has a diode installed.</span>")

	else if(isscrewdriver(W))
		if(diode)
			to_chat(user, "<span class='notice'>You remove \the [diode] from \the [src].</span>")
			diode.forceMove(drop_location())
			diode = null
	else
		return ..()

/obj/item/device/laser_pointer/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	laser_act(target, user, click_parameters)

/obj/item/device/laser_pointer/proc/laser_act(atom/target, mob/living/user, click_parameters)
	if( !(user in (viewers(world.view, target))) )
		return
	if (!diode)
		to_chat(user, "<span class='notice'>You point \the [src] at \the [target], but nothing happens!</span>")
		return
	if (!user.IsAdvancedToolUser())
		to_chat(user, "<span class='warning'>You don't have the dexterity to do this!</span>")
		return
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(HULK in H.mutations)
			to_chat(user, "<span class='warning'>Your fingers can't press the button!</span>")
			return

	add_fingerprint(user)

	//nothing happens if the battery is drained
	if(recharge_locked)
		to_chat(user, "<span class='notice'>You point \the [src] at \the [target], but it's still charging.</span>")
		return

	var/outmsg
	var/turf/targloc = get_turf(target)

	//human/alien mobs
	if(iscarbon(target))
		var/mob/living/carbon/C = target
		if(user.zone_sel.selecting == O_EYES)
			add_attack_logs(user, C, "shone [src] in the eyes")

			var/severity = 1
			if(prob(33))
				severity = 2
			else if(prob(50))
				severity = 0

			//20% chance to actually hit the eyes
			if(prob(effectchance * diode.rating) && C.flash_eyes(severity))
				outmsg = "<span class='notice'>You blind [C] by shining [src] in their eyes.</span>"
			else
				outmsg = "<span class='warning'>You fail to blind [C] by shining [src] at their eyes!</span>"

	//cameras
	else if(istype(target, /obj/machinery/camera))
		var/obj/machinery/camera/C = target
		if(prob(effectchance * diode.rating))
			C.emp_act(1)
			outmsg = "<span class='notice'>You hit the lens of [C] with [src], temporarily disabling the camera!</span>"
			add_attack_logs(user, C, "EMPed with [src]")
		else
			outmsg = "<span class='warning'>You miss the lens of [C] with [src]!</span>"

	//cats!
	for(var/mob/living/simple_animal/cat/C in view(1, targloc))
		if(prob(50))
			C.visible_message("<span class='notice'>[C] pounces on the light!</span>", "<span class='warning'>LIGHT!</span>")
			C.Move(targloc)
			C.resting = TRUE
			C.update_canmove()
		else
			C.visible_message("<span class='notice'>[C] looks uninterested in your games.</span>", "<span class='warning'>You spot [user] shining [src] at you. How insulting!</span>")

	//laser pointer image
	icon_state = "pointer_[pointer_icon_state]"
	var/image/I = image('icons/obj/projectiles_vr.dmi', targloc, pointer_icon_state)
	I.plane = ABOVE_PLANE
	var/list/click_params = params2list(click_parameters)
	if(click_params)
		if(click_params["icon-x"])
			I.pixel_x = (text2num(click_params["icon-x"]) - 16)
		if(click_params["icon-y"])
			I.pixel_y = (text2num(click_params["icon-y"]) - 16)
	else
		I.pixel_x = target.pixel_x + rand(-5,5)
		I.pixel_y = target.pixel_y + rand(-5,5)

	if(outmsg)
		to_chat(user, outmsg)
	else
		to_chat(user, "<span class='info'>You point [src] at [target].</span>")

	energy -= 1
	if(energy <= max_energy)
		if(!recharging)
			recharging = 1
			processing_objects.Add(src)
		if(energy <= 0)
			to_chat(user, "<span class='warning'>[src]'s battery is overused, it needs time to recharge!</span>")
			recharge_locked = TRUE

	flick_overlay_view(I, targloc, 1 SECOND)
	sleep(1 SECOND)
	icon_state = "pointer"

/obj/item/device/laser_pointer/process()
	if(prob(20 - recharge_locked*5))
		energy += 1
		if(energy >= max_energy)
			energy = max_energy
			recharging = 0
			recharge_locked = FALSE
			..()
