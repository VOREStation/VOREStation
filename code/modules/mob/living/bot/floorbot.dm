// Configure whether or not floorbot will fix hull breaches.
// This can be a problem if it tries to pave over space or shuttles.  That should be fixed but...
// If it can see space outside windows, it can be laggy since it keeps wondering if it should fix them.
// Therefore that functionality is disabled for now.  But it can be turned on by uncommenting this.
// #define FLOORBOT_PATCHES_HOLES 1

/mob/living/bot/floorbot
	name = "Floorbot"
	desc = "A little floor repairing robot, it looks so excited!"
	icon_state = "floorbot0"
	req_one_access = list(access_robotics, access_construction)
	wait_if_pulled = 1
	min_target_dist = 0

	var/vocal = 1
	var/amount = 10 // 1 for tile, 2 for lattice
	var/maxAmount = 60
	var/tilemake = 0 // When it reaches 100, bot makes a tile
	var/improvefloors = 0
	var/eattiles = 0
	var/maketiles = 0
	var/targetdirection = null
	var/floor_build_type = /decl/flooring/tiling // Basic steel floor.

/mob/living/bot/floorbot/update_icons()
	if(busy)
		icon_state = "floorbot-c"
	else if(amount > 0)
		icon_state = "floorbot[on]"
	else
		icon_state = "floorbot[on]e"

/mob/living/bot/floorbot/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Floorbot", name)
		ui.open()

/mob/living/bot/floorbot/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()

	data["on"] = on
	data["open"] = open
	data["locked"] = locked

	data["vocal"] = vocal
	data["amount"] = amount

	data["possible_bmode"] = list("NORTH", "EAST", "SOUTH", "WEST")

	data["improvefloors"] = null
	data["eattiles"] = null
	data["maketiles"] = null
	data["bmode"] = null

	if(!locked || issilicon(user))
		data["improvefloors"] = improvefloors
		data["eattiles"] = eattiles
		data["maketiles"] = maketiles
		data["bmode"] = dir2text(targetdirection)
	return data

/mob/living/bot/floorbot/attack_hand(var/mob/user)
	tgui_interact(user)

/mob/living/bot/floorbot/emag_act(var/remaining_charges, var/mob/user)
	. = ..()
	if(!emagged)
		emagged = 1
		if(user)
			to_chat(user, "<span class='notice'>The [src] buzzes and beeps.</span>")
			playsound(src, 'sound/machines/buzzbeep.ogg', 50, 0)
		return 1

/mob/living/bot/floorbot/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	add_fingerprint(src)

	switch(action)
		if("start")
			if(on)
				turn_off()
			else
				turn_on()
			. = TRUE

	if(locked && !issilicon(usr))
		return

	switch(action)
		if("vocal")
			vocal = !vocal
			. = TRUE
		if("improve")
			improvefloors = !improvefloors
			. = TRUE
		if("tiles")
			eattiles = !eattiles
			. = TRUE
		if("make")
			maketiles = !maketiles
			. = TRUE
		if("bridgemode")
			targetdirection = text2dir(params["dir"])
			. = TRUE

/mob/living/bot/floorbot/handleRegular()
	++tilemake
	if(tilemake >= 100)
		tilemake = 0
		addTiles(1)

	if(vocal && prob(1))
		custom_emote(2, "makes an excited beeping sound!")
		playsound(src, 'sound/machines/twobeep.ogg', 50, 0)

/mob/living/bot/floorbot/handleAdjacentTarget()
	if(get_turf(target) == src.loc)
		UnarmedAttack(target)

/mob/living/bot/floorbot/lookForTargets()
	if(emagged) // Time to griff
		for(var/turf/simulated/floor/D in view(src))
			if(confirmTarget(D))
				target = D
				return

	else if(amount)
		if(targetdirection) // Building a bridge
			var/turf/T = get_step(src, targetdirection)
			while(T in range(world.view, src))
				if(confirmTarget(T))
					target = T
					return
				T = get_step(T, targetdirection)
			return // In bridge mode we don't want to step off that line even to eat plates!

#ifdef FLOORBOT_PATCHES_HOLES
		for(var/turf/space/T in view(src)) // Breaches are of higher priority
			if(confirmTarget(T))
				target = T
				return

		for(var/turf/simulated/mineral/floor/T in view(src)) // Asteroids are of smaller priority
			if(confirmTarget(T))
				target = T
				return
#endif
		// Look for broken floors even if we aren't improvefloors
		for(var/turf/simulated/floor/T in view(src))
			if(confirmTarget(T))
				target = T
				return

	if(amount < maxAmount && (eattiles || maketiles))
		for(var/obj/item/stack/S in view(src))
			if(confirmTarget(S))
				target = S
				return

/mob/living/bot/floorbot/confirmTarget(var/atom/A) // The fact that we do some checks twice may seem confusing but remember that the bot's settings may be toggled while it's moving and we want them to stop in that case
	if(!..())
		return 0

	if(istype(A, /obj/item/stack/tile/floor))
		return (amount < maxAmount && eattiles)
	if(istype(A, /obj/item/stack/material/steel))
		return (amount < maxAmount && maketiles)

	// Don't pave over all of space, build there only if in bridge mode
	if(!targetdirection && istype(A.loc, /area/space)) // Note name == "Space" does not work!
		return 0

	if(istype(A.loc, /area/shuttle)) // Do NOT mess with shuttle drop zones
		return 0

	if(emagged)
		return (istype(A, /turf/simulated/floor))

	if(!amount)
		return 0

#ifdef FLOORBOT_PATCHES_HOLES
	if(istype(A, /turf/space))
		return 1

	if(istype(A, /turf/simulated/mineral/floor))
		return 1
#endif

	var/turf/simulated/floor/T = A
	return (istype(T) && (T.broken || T.burnt || (improvefloors && !T.flooring)) && (get_turf(T) == loc || prob(40)))

/mob/living/bot/floorbot/UnarmedAttack(var/atom/A, var/proximity)
	if(!..())
		return

	if(busy)
		return

	if(get_turf(A) != loc)
		return

	if(emagged && istype(A, /turf/simulated/floor))
		var/turf/simulated/floor/F = A
		busy = 1
		update_icons()
		if(F.flooring)
			visible_message("<span class='warning'>\The [src] begins to tear the floor tile from the floor!</span>")
			if(do_after(src, 50))
				F.break_tile_to_plating()
				addTiles(1)
		else
			visible_message("<span class='danger'>\The [src] begins to tear through the floor!</span>")
			if(do_after(src, 150)) // Extra time because this can and will kill.
				F.ReplaceWithLattice()
				addTiles(1)
		target = null
		busy = 0
		update_icons()
	else if(istype(A, /turf/space) || istype(A, /turf/simulated/mineral/floor))
		var/building = 2
		if(locate(/obj/structure/lattice, A))
			building = 1
		if(amount < building)
			return
		busy = 1
		update_icons()
		visible_message("<b>\The [src]</b> begins to repair the hole.")
		if(do_after(src, 50))
			if(A && (locate(/obj/structure/lattice, A) && building == 1 || !locate(/obj/structure/lattice, A) && building == 2)) // Make sure that it still needs repairs
				var/obj/item/I
				if(building == 1)
					I = new /obj/item/stack/tile/floor(src)
				else
					I = new /obj/item/stack/rods(src)
				A.attackby(I, src)
		target = null
		busy = 0
		update_icons()
	else if(istype(A, /turf/simulated/floor))
		var/turf/simulated/floor/F = A
		if(F.broken || F.burnt)
			busy = 1
			update_icons()
			visible_message("<b>\The [src]</b> begins to remove the broken floor.")
			if(do_after(src, 50, F))
				if(F.broken || F.burnt)
					F.make_plating()
			target = null
			busy = 0
			update_icons()
		else if(!F.flooring && amount)
			busy = 1
			update_icons()
			visible_message("<b>\The [src]</b> begins to improve the floor.")
			if(do_after(src, 50))
				if(!F.flooring)
					F.set_flooring(get_flooring_data(floor_build_type))
					addTiles(-1)
			target = null
			busy = 0
			update_icons()
	else if(istype(A, /obj/item/stack/tile/floor) && amount < maxAmount)
		var/obj/item/stack/tile/floor/T = A
		visible_message("<b>\The [src]</b> begins to collect tiles.")
		busy = 1
		update_icons()
		if(do_after(src, 20))
			if(T)
				var/eaten = min(maxAmount - amount, T.get_amount())
				T.use(eaten)
				addTiles(eaten)
		target = null
		busy = 0
		update_icons()
	else if(istype(A, /obj/item/stack/material) && amount + 4 <= maxAmount)
		var/obj/item/stack/material/M = A
		if(M.get_material_name() == MAT_STEEL)
			visible_message("<b>\The [src]</b> begins to make tiles.")
			busy = 1
			update_icons()
			if(do_after(50))
				if(M)
					M.use(1)
					addTiles(4)

/mob/living/bot/floorbot/explode()
	turn_off()
	visible_message("<span class='danger'>\The [src] blows apart!</span>")
	playsound(src, "sparks", 50, 1)
	var/turf/Tsec = get_turf(src)

	var/obj/item/weapon/storage/toolbox/mechanical/N = new /obj/item/weapon/storage/toolbox/mechanical(Tsec)
	N.contents = list()
	new /obj/item/device/assembly/prox_sensor(Tsec)
	if(prob(50))
		new /obj/item/robot_parts/l_arm(Tsec)
	new /obj/item/stack/tile/floor(Tsec, amount)
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(3, 1, src)
	s.start()
	//qdel(src)
	return ..()

/mob/living/bot/floorbot/proc/addTiles(var/am)
	amount += am
	if(amount < 0)
		amount = 0
	else if(amount > maxAmount)
		amount = maxAmount

/mob/living/bot/floorbot/handlePanic()	// Speed modification based on alert level.
	. = 0
	switch(get_security_level())
		if("green")
			. = 0

		if("yellow")
			. = 0

		if("violet")
			. = 0

		if("orange")
			. = 1

		if("blue")
			. = 1

		if("red")
			. = 2

		if("delta")
			. = 2

	return .

/* Assembly */

/obj/item/weapon/storage/toolbox/mechanical/attackby(var/obj/item/stack/tile/floor/T, mob/living/user as mob)
	if(!istype(T, /obj/item/stack/tile/floor))
		..()
		return
	if(contents.len >= 1)
		to_chat(user, "<span class='notice'>They wont fit in as there is already stuff inside.</span>")
		return
	if(user.s_active)
		user.s_active.close(user)
	if(T.use(10))
		var/obj/item/weapon/toolbox_tiles/B = new /obj/item/weapon/toolbox_tiles
		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You add the tiles into the empty toolbox. They protrude from the top.</span>")
		user.drop_from_inventory(src)
		qdel(src)
	else
		to_chat(user, "<span class='warning'>You need 10 floor tiles for a floorbot.</span>")
	return

/obj/item/weapon/toolbox_tiles
	desc = "It's a toolbox with tiles sticking out the top"
	name = "tiles and toolbox"
	icon = 'icons/obj/aibots.dmi'
	icon_state = "toolbox_tiles"
	force = 3.0
	throwforce = 10.0
	throw_speed = 2
	throw_range = 5
	w_class = ITEMSIZE_NORMAL
	var/created_name = "Floorbot"

/obj/item/weapon/toolbox_tiles/attackby(var/obj/item/W, mob/user as mob)
	..()
	if(isprox(W))
		qdel(W)
		var/obj/item/weapon/toolbox_tiles_sensor/B = new /obj/item/weapon/toolbox_tiles_sensor()
		B.created_name = created_name
		user.put_in_hands(B)
		to_chat(user, "<span class='notice'>You add the sensor to the toolbox and tiles!</span>")
		user.drop_from_inventory(src)
		qdel(src)
	else if (istype(W, /obj/item/weapon/pen))
		var/t = sanitizeSafe(input(user, "Enter new robot name", name, created_name), MAX_NAME_LEN)
		if(!t)
			return
		if(!in_range(src, user) && loc != user)
			return
		created_name = t

/obj/item/weapon/toolbox_tiles_sensor
	desc = "It's a toolbox with tiles sticking out the top and a sensor attached"
	name = "tiles, toolbox and sensor arrangement"
	icon = 'icons/obj/aibots.dmi'
	icon_state = "toolbox_tiles_sensor"
	force = 3.0
	throwforce = 10.0
	throw_speed = 2
	throw_range = 5
	w_class = ITEMSIZE_NORMAL
	var/created_name = "Floorbot"

/obj/item/weapon/toolbox_tiles_sensor/attackby(var/obj/item/W, mob/user as mob)
	..()
	if(istype(W, /obj/item/robot_parts/l_arm) || istype(W, /obj/item/robot_parts/r_arm) || (istype(W, /obj/item/organ/external/arm) && ((W.name == "robotic right arm") || (W.name == "robotic left arm"))))
		qdel(W)
		var/turf/T = get_turf(user.loc)
		var/mob/living/bot/floorbot/A = new /mob/living/bot/floorbot(T)
		A.name = created_name
		to_chat(user, "<span class='notice'>You add the robot arm to the odd looking toolbox assembly! Boop beep!</span>")
		user.drop_from_inventory(src)
		qdel(src)
	else if(istype(W, /obj/item/weapon/pen))
		var/t = sanitizeSafe(input(user, "Enter new robot name", name, created_name), MAX_NAME_LEN)
		if(!t)
			return
		if(!in_range(src, user) && loc != user)
			return
		created_name = t
