/obj/item/weapon/gun/magnetic/matfed
	power_cost = 750
	load_type = list(/obj/item/stack/material, /obj/item/weapon/ore)
	var/mat_storage = 0			// How much material is stored inside? Input in multiples of 2000 as per auto/protolathe.
	var/max_mat_storage = 8000	// How much material can be stored inside?
	var/mat_cost = 500			// How much material is used per-shot?
	var/ammo_material
	var/obj/item/weapon/stock_parts/manipulator/manipulator    // Installed manipulator. Mostly for Phoron Bore, higher rating == less mats consumed upon firing. Set to a path to spawn with one of that type.
	var/loading = FALSE

/obj/item/weapon/gun/magnetic/matfed/Initialize()
	. = ..()
	if(ispath(manipulator))
		manipulator = new manipulator(src)
	if(manipulator)
		mat_cost = initial(mat_cost) / (2*manipulator.rating)

/obj/item/weapon/gun/magnetic/matfed/Destroy()
	QDEL_NULL(manipulator)
	. = ..()

/obj/item/weapon/gun/magnetic/matfed/examine(mob/user)
	. = ..()
	var/ammotext = show_ammo()
	if(ammotext)
		. += ammotext

/obj/item/weapon/gun/magnetic/matfed/update_icon()
	var/list/overlays_to_add = list()
	if(removable_components)
		if(cell)
			overlays_to_add += image(icon, "[icon_state]_cell")
		if(capacitor)
			overlays_to_add += image(icon, "[icon_state]_capacitor")
	if(!cell || !capacitor)
		overlays_to_add += image(icon, "[icon_state]_red")
	else if(capacitor.charge < power_cost)
		overlays_to_add += image(icon, "[icon_state]_amber")
	else
		overlays_to_add += image(icon, "[icon_state]_green")
	if(mat_storage)
		overlays_to_add += image(icon, "[icon_state]_loaded")

	overlays = overlays_to_add
	..()

/obj/item/weapon/gun/magnetic/matfed/attack_hand(var/mob/user) // It doesn't keep a loaded item inside.
	if(user.get_inactive_hand() == src)
		var/obj/item/removing

		if(cell && removable_components)
			removing = cell
			cell = null

		if(removing)
			user.put_in_hands(removing)
			user.visible_message("<span class='notice'>\The [user] removes \the [removing] from \the [src].</span>")
			playsound(src, 'sound/machines/click.ogg', 10, 1)
			update_icon()
			return
	. = ..()

/obj/item/weapon/gun/magnetic/matfed/check_ammo()
	if(mat_storage - mat_cost >= 0)
		return TRUE
	return FALSE

/obj/item/weapon/gun/magnetic/matfed/use_ammo()
	mat_storage -= mat_cost

/obj/item/weapon/gun/magnetic/matfed/show_ammo()
	if(mat_storage)
		return list("<span class='notice'>It has [mat_storage] out of [max_mat_storage] units of [ammo_material] loaded.</span>")

/obj/item/weapon/gun/magnetic/matfed/attackby(var/obj/item/thing, var/mob/user)
	if(removable_components)
		if(thing.is_crowbar())
			if(!manipulator)
				to_chat(user, "<span class='warning'>\The [src] has no manipulator installed.</span>")
				return
			user.put_in_hands(manipulator)
			user.visible_message("<span class='notice'>\The [user] levers \the [manipulator] from \the [src].</span>")
			playsound(src, thing.usesound, 50, 1)
			mat_cost = initial(mat_cost)
			manipulator = null
			update_icon()
			return

		if(istype(thing, /obj/item/weapon/stock_parts/manipulator))
			if(manipulator)
				to_chat(user, "<span class='warning'>\The [src] already has \a [manipulator] installed.</span>")
				return
			manipulator = thing
			user.drop_from_inventory(manipulator, src)
			playsound(src, 'sound/machines/click.ogg', 10,1)
			mat_cost = initial(mat_cost) / (2*manipulator.rating)
			user.visible_message("<span class='notice'>\The [user] slots \the [manipulator] into \the [src].</span>")
			update_icon()
			return


	if(is_type_in_list(thing, load_type))
		var/obj/item/stack/material/M = thing

		if(istype(M)) //stack
			if(!M.material || M.material.name != ammo_material || loading)
				return

			if(mat_storage + SHEET_MATERIAL_AMOUNT > max_mat_storage)
				to_chat(user, "<span class='warning'>\The [src] cannot hold more [ammo_material].</span>")
				return

			var/can_hold_val = 0
			loading = TRUE
			while(mat_storage + SHEET_MATERIAL_AMOUNT <= max_mat_storage && do_after(user,1.5 SECONDS))
				can_hold_val ++
				mat_storage += SHEET_MATERIAL_AMOUNT
				playsound(src, 'sound/effects/phasein.ogg', 15, 1)
			M.use(can_hold_val)
			loading = FALSE

		else //ore
			if(M.material != ammo_material)
				return

			if(mat_storage + (SHEET_MATERIAL_AMOUNT/2*0.8) > max_mat_storage)
				to_chat(user, "<span class='warning'>\The [src] cannot hold more [ammo_material].</span>")
				return

			qdel(M)
			mat_storage += (SHEET_MATERIAL_AMOUNT/2*0.8) //two plasma ores needed per sheet, some inefficiency for not using refined product


		user.visible_message("<span class='notice'>\The [user] loads \the [src] with \the [M].</span>")
		playsound(src, 'sound/weapons/flipblade.ogg', 50, 1)
		update_icon()
		return

	. = ..()

#define GEN_STARTING -1
#define GEN_OFF 0
#define GEN_IDLE 1
#define GEN_ACTIVE 2

/obj/item/weapon/gun/magnetic/matfed/phoronbore
	name = "portable phoron bore"
	desc = "A large man-portable tunnel bore, using phorogenic plasma blasts. Point away from user."
	description_fluff = "An aging Grayson Manufactories mining tool used for rapidly digging through rock. Mass production was discontinued when many of the devices were stolen and used to break into a high security facility by Boiling Point drones."
	description_antag = "This device is exceptional at breaking down walls, though it is incredibly loud when doing so."
	description_info = "The projectile of this tool will travel six tiles before dissipating, excavating mineral walls as it does so. It can be reloaded with phoron sheets or ore, and has a togglable generator that can recharge the power cell using stored phoron."

	icon_state = "bore"
	item_state = "bore"
	wielded_item_state = "bore-wielded"
	one_handed_penalty = 5

	projectile_type = /obj/item/projectile/bullet/magnetic/bore

	gun_unreliable = 0
	power_cost = 100
	ammo_material = MAT_PHORON

	action_button_name = "Toggle internal generator"

	var/generator_state = GEN_OFF
	var/datum/looping_sound/small_motor/soundloop
	var/time_started //to keep the soundloop from being "stopped" too soon and playing indefinitely

/obj/item/weapon/gun/magnetic/matfed/phoronbore/Initialize()
	. = ..()
	soundloop = new(list(src), 0)

/obj/item/weapon/gun/magnetic/matfed/phoronbore/Destroy()
	QDEL_NULL(soundloop)
	. = ..()

/obj/item/weapon/gun/magnetic/matfed/phoronbore/ui_action_click()
	toggle_generator(usr)

/obj/item/weapon/gun/magnetic/matfed/phoronbore/process()
	if(generator_state && !mat_storage)
		audible_message(SPAN_NOTICE("\The [src] goes quiet."),SPAN_NOTICE("A motor noise cuts out."))
		soundloop.stop()
		generator_state = GEN_OFF

	else if(generator_state > GEN_OFF)
		if(generator_state == GEN_IDLE && (cell?.percent() < 80 || (!cell && capacitor && capacitor.charge/capacitor.max_charge < 0.8)))
			generator_state = GEN_ACTIVE
		else if(generator_state == GEN_ACTIVE && (!cell || cell.fully_charged()) && (!capacitor || capacitor.charge == capacitor.max_charge))
			generator_state = GEN_IDLE
		soundloop.speed = generator_state
		generator_generate()

	if(capacitor)
		if(cell)
			if(capacitor.charge < capacitor.max_charge && cell.checked_use(power_per_tick))
				capacitor.charge(power_per_tick)
		else if(!generator_state)
			capacitor.use(capacitor.charge * 0.05)

	update_state()

/obj/item/weapon/gun/magnetic/matfed/phoronbore/proc/generator_generate()
	var/fuel_used = generator_state == GEN_IDLE ? 5 : 25
	var/power_made = fuel_used * 800 * CELLRATE //20kW when active, same power as a pacman on setting one, but less efficient because compact and portable
	if(cell)
		cell.give(power_made)
	else if(capacitor)
		capacitor.charge(power_made)
	mat_storage = max(mat_storage - fuel_used, 0)
	var/turf/T = get_turf(src)
	if(T)
		T.assume_gas("carbon_dioxide", fuel_used * 0.01, T0C+200)

/obj/item/weapon/gun/magnetic/matfed/phoronbore/proc/toggle_generator(mob/living/user)
	if(!generator_state && !mat_storage)
		to_chat(user, SPAN_NOTICE("\The [src] has no fuel!"))
		return

	else if(!generator_state)
		generator_state = GEN_STARTING
		var/pull = (!cell || cell.charge < 100) ? rand(1,4) : 0
		while(pull)
			playsound(src, 'sound/items/small_motor/motor_pull_attempt.ogg', 100)
			if(!do_after(user, 2 SECONDS, src))
				generator_state = GEN_OFF
				return
			pull--
		soundloop.start()
		time_started = world.time
		cell?.use(100)
		audible_message(SPAN_NOTICE("\The [src] starts chugging."),SPAN_NOTICE("A motor noise starts up."))
		generator_state = GEN_IDLE

	else if(generator_state > GEN_OFF && time_started + 3 SECONDS < world.time)
		soundloop.stop()
		audible_message(SPAN_NOTICE("\The [src] goes quiet."),SPAN_NOTICE("A motor noise cuts out."))
		generator_state = GEN_OFF

/obj/item/weapon/gun/magnetic/matfed/phoronbore/loaded
	cell = /obj/item/weapon/cell/apc
	capacitor = /obj/item/weapon/stock_parts/capacitor
