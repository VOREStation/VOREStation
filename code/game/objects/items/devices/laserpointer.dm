/obj/item/laser_pointer
	name = "laser pointer"
	desc = "Don't shine it in your eyes!"
	icon = 'icons/obj/device.dmi'
	icon_state = "pointer"
	item_state = "pen"
	var/pointer_icon_state
	slot_flags = SLOT_BELT
	matter = list(MAT_GLASS = 500, MAT_STEEL = 500)
	w_class = 2 //Increased to 2, because diodes are w_class 2. Conservation of matter.
	origin_tech = list(TECH_MAGNET = 2, TECH_COMBAT = 1)
	var/turf/pointer_loc
	var/energy = 8
	var/max_energy = 8
	var/effectchance = 20
	var/cooldown = 10
	var/last_used_time = 0
	var/recharging = 0
	var/recharge_locked = 0
	var/obj/item/stock_parts/micro_laser/diode //used for upgrading!
	pickup_sound = 'sound/items/pickup/device.ogg'
	drop_sound = 'sound/items/drop/device.ogg'


/obj/item/laser_pointer/red
	pointer_icon_state = "red_laser"
/obj/item/laser_pointer/green
	pointer_icon_state = "green_laser"
/obj/item/laser_pointer/blue
	pointer_icon_state = "blue_laser"
/obj/item/laser_pointer/purple
	pointer_icon_state = "purple_laser"

/obj/item/laser_pointer/Initialize(mapload, var/laser_path)
	. = ..()
	if(ispath(laser_path))
		diode = new laser_path
	else
		diode = new(src)
	if(!pointer_icon_state)
		pointer_icon_state = pick("red_laser","green_laser","blue_laser","purple_laser")

/obj/item/laser_pointer/upgraded/Initialize(mapload)
	. = ..(mapload, /obj/item/stock_parts/micro_laser/ultra)

/obj/item/laser_pointer/ultimate/Initialize(mapload)
	. = ..(mapload, /obj/item/stock_parts/micro_laser/omni)

/obj/item/laser_pointer/attack(mob/living/M, mob/user)
	laser_act(M, user)

/obj/item/laser_pointer/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/stock_parts/micro_laser))
		if(!diode)
			user.drop_item()
			W.loc = src
			diode = W
			to_chat(user, span_notice("You install a [diode.name] in [src]."))
		else
			to_chat(user, span_notice("[src] already has a diode."))

	else if(W.has_tool_quality(TOOL_SCREWDRIVER))
		if(diode)
			to_chat(user, span_notice("You remove the [diode.name] from the [src]."))
			diode.loc = get_turf(src.loc)
			diode = null
			return
		..()
	return

/obj/item/laser_pointer/afterattack(var/atom/target, var/mob/living/user, flag, params)
	if(flag)	//we're placing the object on a table or in backpack
		return
	laser_act(target, user)

/obj/item/laser_pointer/proc/laser_act(var/atom/target, var/mob/living/user)
	if(!(user in (viewers(world.view,target))))
		return
	if(!(target in view(user, world.view)))
		return
	if(!(world.time - last_used_time >= cooldown))
		return
	if (!diode)
		to_chat(user, span_notice("You point [src] at [target], but nothing happens!"))
		return
	if (!user.IsAdvancedToolUser())
		to_chat(user, span_warning("You don't have the dexterity to do this!"))
		return

	add_fingerprint(user)

	//nothing happens if the battery is drained
	if(recharge_locked)
		to_chat(user, span_notice("You point [src] at [target], but it's still charging."))
		return

	var/outmsg
	var/turf/targloc = get_turf(target)

	//human/alien mobs
	if(ishuman(target))
		if(user.zone_sel.selecting == "eyes")
			var/mob/living/carbon/human/H = target

			//20% chance to actually hit the eyes

			if(prob(effectchance * diode.rating))
				add_attack_logs(user, H, "Tried blinding using [src]")

				//eye target check, will return -2 to 2
				var/eye_prot = H.eyecheck()
				if(!H.has_vision() || eye_prot >= FLASH_PROTECTION_MAJOR)
					eye_prot = 100 //Immune
				var/obj/item/organ/internal/eyes/E = H.internal_organs_by_name[O_EYES]
				if(!E || eye_prot == 100)
					outmsg = span_notice("You shine [src] at [H] with no response.")
				else
					outmsg = span_notice("You shine [src] into [H]'s eyes.")
					//Comment to explain the below math because reading it makes my eyes glaze over:
					// Rand 0-1 + diode.rating(1 to 5) minus eye protection. (This can be anywhere between 0 and 8, depending on protection and thermals)
					// We then multiply by flash_mod (usually 1, 1.5, or 2) and then clamp it. Min 0, max 16 now.
					// We then round it (whole numbers, let's not deal 5.281 damage to someone's eyes) and clamp it in case of any weirdness so we don't get negatives.
					var/severity = CLAMP(round((rand(0, 1) + diode.rating - eye_prot) * H.species.flash_mod), 0, 100) //If you get a severity above 100 I'm impressed.
					//Handle the visual flash effect first
					if(severity >= 4)
						flick("e_flash", H.flash_eyes())
					else if(severity >= 2)
						flick("flash", H.flash_eyes())

					//Handle the weakness effect afterwards
					if(severity >= 3)
						if(prob(severity * diode.rating))
							H.Weaken(max(H.weakened, severity - 2))
						E.damage += severity - 2

					var/eye_message = span_info("A small, bright dot appears in your vision.")
					switch(severity)
						if(1)
							eye_message = span_notice("Something bright flashes in the corner of your vision.")
						if(2)
							eye_message = span_danger("A bright light shines across your eyes!")
						if(3)
							eye_message = span_danger("A bright light briefly blinds you!")
						if(4)
							eye_message = span_danger("A blinding light burns your eyes!")
					if(severity > 4)
						eye_message = span_bolddanger("It feels like the sun is being beamed directly into your eyes!") //Bolddanger because you are taking MASSIVE eye damage.
					to_chat(H, eye_message)
			else
				outmsg = span_notice("You shine the [src] at [H], but miss their eyes.")

	//robots and AI
	else if(issilicon(target))
		var/mob/living/silicon/S = target
		//20% chance to actually hit the sensors
		if(prob(effectchance * diode.rating))
			flick("flash", S.flash_eyes(affect_silicon = TRUE))
			if (prob(3 * diode.rating))
				S.Weaken(1)
			to_chat(S, span_warning("Your sensors were blinded by a laser!"))
			outmsg = span_notice("You blind [S] by shining [src] at their sensors.")
			add_attack_logs(user,S,"Tried disabling using [src]")
		else
			outmsg = span_notice("You shine the [src] at [S], but miss their sensors.")

	//cameras
	else if(istype(target, /obj/machinery/camera))
		var/obj/machinery/camera/C = target
		if(prob(effectchance * diode.rating))
			C.emp_act(CLAMP(4 - diode.rating, 1, 4), forced = TRUE)
			outmsg = span_notice("You shine the [src] into the lens of [C].")
			add_attack_logs(user,C,"Disabled using [src]")
		else
			outmsg = span_info("You missed the lens of [C] with [src].")
			add_attack_logs(user,C,"Tried disabling using [src]")

	//cats!
	for(var/mob/living/simple_mob/animal/passive/cat/C in viewers(1,targloc))
		if (!(C.stat || C.buckled))
			if(prob(50) && !(C.client))
				C.visible_message(span_warning("[C] pounces on the light!"), span_warning("You pounce on the light!"))
				step_towards(C, targloc)
				C.lay_down()
				spawn(10)
					C.lay_down()
			else
				C.set_dir(get_dir(C,targloc))
				C.visible_message(span_notice("[C] watches the light."), span_notice("Your attention is drawn to the mysterious glowing dot."))


	//laser pointer image
	icon_state = "[initial(icon_state)]_[pointer_icon_state]"
	var/list/showto = list()
	for(var/mob/M in viewers(world.view,targloc))
		if(M.client)
			showto.Add(M.client)
	var/image/I = image('icons/obj/projectiles.dmi',targloc,pointer_icon_state,cooldown)
	I.plane = PLANE_LIGHTING_ABOVE
	I.pixel_x = target.pixel_x + rand(-5,5)
	I.pixel_y = target.pixel_y + rand(-5,5)

	if(outmsg)
		user.visible_message(span_info("[user] points [src] at [target]."), outmsg)
	else
		user.visible_message(span_info("[user] points [src] at [target]."), span_info("You point [src] at [target]."))

	last_used_time = world.time
	energy -= 1
	if(energy <= max_energy)
		if(!recharging)
			recharging = TRUE
			START_PROCESSING(SSobj, src)
		if(energy <= 0)
			to_chat(user, span_warning("You've overused the battery of [src], now it needs time to recharge!"))
			recharge_locked = TRUE

	flick_overlay(I, showto, cooldown)
	spawn(cooldown)
		icon_state = initial(icon_state)

/obj/item/laser_pointer/process()
	if(prob(20 - recharge_locked*5))
		energy++
		if(energy >= max_energy)
			energy = max_energy
			recharging = FALSE
			recharge_locked = FALSE
			..()
