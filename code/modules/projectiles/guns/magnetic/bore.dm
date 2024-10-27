/obj/item/gun/magnetic/matfed
	power_cost = 750
	load_type = list(/obj/item/stack/material, /obj/item/ore)
	var/mat_storage = 0			// How much material is stored inside? Input in multiples of 2000 as per auto/protolathe.
	var/max_mat_storage = 8000	// How much material can be stored inside?
	var/mat_cost = 500			// How much material is used per-shot?
	var/ammo_material
	var/obj/item/stock_parts/manipulator/manipulator    // Installed manipulator. Mostly for Phoron Bore, higher rating == less mats consumed upon firing. Set to a path to spawn with one of that type.
	var/rating_modifier = 0 // rating of installed capacitor + manipulator
	var/loading = FALSE

/obj/item/gun/magnetic/matfed/proc/update_rating_mod()
	if(capacitor && manipulator)
		rating_modifier = capacitor.get_rating() + manipulator.get_rating()
	else
		rating_modifier = FALSE

/obj/item/gun/magnetic/matfed/Initialize()
	. = ..()
	if(ispath(manipulator))
		manipulator = new manipulator(src)
	if(manipulator)
		mat_cost = initial(mat_cost) / (2*manipulator.rating)
	update_rating_mod()

/obj/item/gun/magnetic/matfed/Destroy()
	QDEL_NULL(manipulator)
	. = ..()

/obj/item/gun/magnetic/matfed/examine(mob/user)
	. = ..()
	if(manipulator)
		. += span_notice("The installed [manipulator.name] consumes [mat_cost] units of [ammo_material] per shot.")
	else
		. += span_notice("The \"manipulator missing\" indicator is lit. [src] consumes [mat_cost] units of [ammo_material] per shot.")

/obj/item/gun/magnetic/matfed/update_icon()
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

/obj/item/gun/magnetic/matfed/attack_hand(var/mob/user) // It doesn't keep a loaded item inside.
	if(user.get_inactive_hand() == src)
		var/obj/item/removing

		if(cell && removable_components)
			removing = cell
			cell = null

		if(removing)
			user.put_in_hands(removing)
			user.visible_message(span_infoplain(span_bold("\The [user]") + " removes \the [removing] from \the [src]."))
			playsound(src, 'sound/machines/click.ogg', 10, 1)
			update_icon()
			return
	. = ..()

/obj/item/gun/magnetic/matfed/check_ammo()
	if(mat_storage - mat_cost >= 0)
		return TRUE
	return FALSE

/obj/item/gun/magnetic/matfed/use_ammo()
	mat_storage -= mat_cost

/obj/item/gun/magnetic/matfed/show_ammo()
	if(mat_storage)
		return span_notice("It has [mat_storage] out of [max_mat_storage] units of [ammo_material] loaded.")
	else
		return span_warning("It\'s out of [ammo_material]!")


/obj/item/gun/magnetic/matfed/attackby(var/obj/item/thing, var/mob/user)
	. = ..()
	update_rating_mod()
	if(removable_components)
		if(thing.has_tool_quality(TOOL_CROWBAR))
			if(!manipulator)
				to_chat(user, span_warning("\The [src] has no manipulator installed."))
				return
			user.put_in_hands(manipulator)
			user.visible_message(span_infoplain(span_bold("\The [user]") + " levers \the [manipulator] from \the [src]."))
			playsound(src, thing.usesound, 50, 1)
			mat_cost = initial(mat_cost)
			manipulator = null
			update_icon()
			update_rating_mod()
			return

		if(istype(thing, /obj/item/stock_parts/manipulator))
			if(manipulator)
				to_chat(user, span_warning("\The [src] already has \a [manipulator] installed."))
				return
			manipulator = thing
			user.drop_from_inventory(manipulator, src)
			playsound(src, 'sound/machines/click.ogg', 10,1)
			mat_cost = initial(mat_cost) / (2*manipulator.rating)
			user.visible_message(span_infoplain(span_bold("\The [user]") + " slots \the [manipulator] into \the [src]."))
			update_icon()
			update_rating_mod()
			return

	if(is_type_in_list(thing, load_type))
		var/obj/item/stack/material/M = thing
		var/success = FALSE
		if(istype(M)) //stack
			if(!M.material || M.material.name != ammo_material || loading)
				return

			if(mat_storage + SHEET_MATERIAL_AMOUNT > max_mat_storage)
				to_chat(user, span_warning("\The [src] cannot hold more [ammo_material]."))
				return
			loading = TRUE
			while(mat_storage + SHEET_MATERIAL_AMOUNT <= max_mat_storage && do_after(user,1.5 SECONDS))
				mat_storage += SHEET_MATERIAL_AMOUNT
				playsound(src, 'sound/effects/phasein.ogg', 15, 1)
				M.use(1)
				success = TRUE
			loading = FALSE

		else //ore
			if(M.material != ammo_material)
				return

			if(mat_storage + (SHEET_MATERIAL_AMOUNT/2*0.8) > max_mat_storage)
				to_chat(user, span_warning("\The [src] cannot hold more [ammo_material]."))
				return

			qdel(M)
			mat_storage += (SHEET_MATERIAL_AMOUNT/2*0.8) //two plasma ores needed per sheet, some inefficiency for not using refined product
			success = TRUE
		if(success)
			user.visible_message(span_infoplain(span_bold("\The [user]") + " loads \the [src] with \the [M]."))
			playsound(src, 'sound/weapons/flipblade.ogg', 50, 1)
		update_icon()
		return

#define GEN_STARTING -1
#define GEN_OFF 0
#define GEN_IDLE 1
#define GEN_ACTIVE 2

/obj/item/gun/magnetic/matfed/phoronbore
	name = "portable phoron bore"
	desc = "A large man-portable tunnel bore, using phorogenic plasma blasts. Point away from user."
	description_fluff = "An aging Grayson Manufactories mining tool used for rapidly digging through rock. Mass production was discontinued when many of the devices were stolen and used to break into a high security facility by Boiling Point drones."
	description_antag = "This device is exceptional at breaking down walls, though it is incredibly loud when doing so."
	description_info = "The projectile of this tool will travel six tiles before dissipating, excavating mineral walls as it does so. It can be reloaded with phoron sheets or ore, and has a togglable generator that can recharge the power cell using stored phoron."

	icon_state = "bore"
	item_state = "bore"
	wielded_item_state = "bore-wielded"
	one_handed_penalty = 5
	fire_delay = 20

	projectile_type = /obj/item/projectile/bullet/magnetic/bore

	gun_unreliable = 0
	power_cost = 100
	ammo_material = MAT_PHORON

	actions_types = list(/datum/action/item_action/toggle_internal_generator)

	var/generator_state = GEN_OFF
	var/datum/looping_sound/small_motor/soundloop
	var/time_started //to keep the soundloop from being "stopped" too soon and playing indefinitely

/obj/item/gun/magnetic/matfed/phoronbore/consume_next_projectile()
	if(!check_ammo() || !capacitor || capacitor.charge < power_cost)
		return

	use_ammo()
	capacitor.use(power_cost)
	update_icon()

	return new projectile_type(src, rating_modifier)

/obj/item/gun/magnetic/matfed/phoronbore/examine(mob/user)
	. = ..()
	if(rating_modifier)
		. += span_notice("A display on the side slowly scrolls the text \"BLAST EFFICIENCY [rating_modifier]\".")
	else // rating_mod 0 = something's not right
		. += span_warning("A display on the side slowly scrolls the text \"ERR: MISSING COMPONENT - EFFICIENCY MODIFICATION INCOMPLETE\".")

/obj/item/gun/magnetic/matfed/phoronbore/Initialize()
	. = ..()
	soundloop = new(list(src), 0)

/obj/item/gun/magnetic/matfed/phoronbore/Destroy()
	QDEL_NULL(soundloop)
	. = ..()

/obj/item/gun/magnetic/matfed/phoronbore/ui_action_click(mob/user, actiontype)
	toggle_generator(user)

/obj/item/gun/magnetic/matfed/phoronbore/process()
	if(generator_state && !mat_storage)
		audible_message(span_notice("\The [src] goes quiet."),span_notice("A motor noise cuts out."), runemessage = "goes quiet")
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

/obj/item/gun/magnetic/matfed/phoronbore/proc/generator_generate()
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

/obj/item/gun/magnetic/matfed/phoronbore/proc/toggle_generator(mob/living/user)
	if(!generator_state && !mat_storage)
		to_chat(user, span_notice("\The [src] has no fuel!"))
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
		audible_message(span_notice("\The [src] starts chugging."),span_notice("A motor noise starts up."), runemessage = "whirr")
		generator_state = GEN_IDLE

	else if(generator_state > GEN_OFF && time_started + 3 SECONDS < world.time)
		soundloop.stop()
		audible_message(span_notice("\The [src] goes quiet."),span_notice("A motor noise cuts out."), runemessage = "goes quiet")
		generator_state = GEN_OFF

/obj/item/gun/magnetic/matfed/phoronbore/loaded
	cell = /obj/item/cell/apc
	capacitor = /obj/item/stock_parts/capacitor

#undef GEN_STARTING
#undef GEN_OFF
#undef GEN_IDLE
#undef GEN_ACTIVE
