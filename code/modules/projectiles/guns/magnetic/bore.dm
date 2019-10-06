/obj/item/weapon/gun/magnetic/matfed
	name = "portable phoron bore"
	desc = "A large man-portable tunnel bore, using phorogenic plasma blasts. Point away from user."
	description_fluff = "An aging Grayson Manufactories mining tool used for rapidly digging through rock. Mass production was discontinued when many of the devices were stolen and used to break into a high security facility by Boiling Point drones."
	description_antag = "This device is exceptional at breaking down walls, though it is incredibly loud when doing so."
	description_info = "The projectile of this tool will travel six tiles before dissipating, excavating mineral walls as it does so. It can be reloaded with phoron sheets."

	icon_state = "bore"
	item_state = "bore"
	wielded_item_state = "bore-wielded"
	one_handed_penalty = 5

	projectile_type = /obj/item/projectile/bullet/magnetic/bore

	gun_unreliable = 0

	power_cost = 750
	load_type = /obj/item/stack/material
	var/mat_storage = 0			// How much material is stored inside? Input in multiples of 2000 as per auto/protolathe.
	var/max_mat_storage = 8000	// How much material can be stored inside?
	var/mat_cost = 500			// How much material is used per-shot?
	var/ammo_material = MAT_PHORON
	var/loading = FALSE

/obj/item/weapon/gun/magnetic/matfed/examine(mob/user)
	. = ..()
	show_ammo(user)

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
			removing.forceMove(get_turf(src))
			user.put_in_hands(removing)
			user.visible_message("<span class='notice'>\The [user] removes \the [removing] from \the [src].</span>")
			playsound(loc, 'sound/machines/click.ogg', 10, 1)
			update_icon()
			return
	. = ..()

/obj/item/weapon/gun/magnetic/matfed/check_ammo()
	if(mat_storage - mat_cost >= 0)
		return TRUE
	return FALSE

/obj/item/weapon/gun/magnetic/matfed/use_ammo()
	mat_storage -= mat_cost

/obj/item/weapon/gun/magnetic/matfed/show_ammo(var/mob/user)
	if(mat_storage)
		to_chat(user, "<span class='notice'>It has [mat_storage] out of [max_mat_storage] units of [ammo_material] loaded.</span>")

/obj/item/weapon/gun/magnetic/matfed/attackby(var/obj/item/thing, var/mob/user)
	if(removable_components)
		if(istype(thing, /obj/item/weapon/cell))
			if(cell)
				to_chat(user, "<span class='warning'>\The [src] already has \a [cell] installed.</span>")
				return
			cell = thing
			user.drop_from_inventory(cell)
			cell.forceMove(src)
			playsound(loc, 'sound/machines/click.ogg', 10, 1)
			user.visible_message("<span class='notice'>\The [user] slots \the [cell] into \the [src].</span>")
			update_icon()
			return
		if(thing.is_crowbar())
			if(!manipulator)
				to_chat(user, "<span class='warning'>\The [src] has no manipulator installed.</span>")
				return
			manipulator.forceMove(get_turf(src))
			user.put_in_hands(manipulator)
			user.visible_message("<span class='notice'>\The [user] levers \the [manipulator] from \the [src].</span>")
			playsound(loc, 'sound/items/Crowbar.ogg', 50, 1)
			manipulator = null
			update_icon()
			return
		if(thing.is_screwdriver())
			if(!capacitor)
				to_chat(user, "<span class='warning'>\The [src] has no capacitor installed.</span>")
				return
			capacitor.forceMove(get_turf(src))
			user.put_in_hands(capacitor)
			user.visible_message("<span class='notice'>\The [user] unscrews \the [capacitor] from \the [src].</span>")
			playsound(loc, 'sound/items/Screwdriver.ogg', 50, 1)
			capacitor = null
			update_icon()
			return

		if(istype(thing, /obj/item/weapon/stock_parts/capacitor))
			if(capacitor)
				to_chat(user, "<span class='warning'>\The [src] already has \a [capacitor] installed.</span>")
				return
			capacitor = thing
			user.drop_from_inventory(capacitor)
			capacitor.forceMove(src)
			playsound(loc, 'sound/machines/click.ogg', 10, 1)
			power_per_tick = (power_cost*0.15) * capacitor.rating
			user.visible_message("<span class='notice'>\The [user] slots \the [capacitor] into \the [src].</span>")
			update_icon()
			return

		if(istype(thing, /obj/item/weapon/stock_parts/manipulator))
			if(manipulator)
				to_chat(user, "<span class='warning'>\The [src] already has \a [manipulator] installed.</span>")
				return
			manipulator = thing
			user.drop_from_inventory(manipulator)
			manipulator.forceMove(src)
			playsound(loc, 'sound/machines/click.ogg', 10,1)
			mat_cost = initial(mat_cost) % (2*manipulator.rating)
			user.visible_message("<span class='notice'>\The [user] slots \the [manipulator] into \the [src].</span>")
			update_icon()
			return


	if(istype(thing, load_type))
		loading = TRUE
		var/obj/item/stack/material/M = thing

		if(!M.material || M.material.name != ammo_material)
			return

		if(mat_storage + 2000 > max_mat_storage)
			to_chat(user, "<span class='warning'>\The [src] cannot hold more [ammo_material].</span>")
			return

		var/can_hold_val = 0
		while(can_hold_val < round(max_mat_storage / 2000))
			if(mat_storage + 2000 <= max_mat_storage && do_after(user,1.5 SECONDS))
				can_hold_val ++
				mat_storage += 2000
				playsound(loc, 'sound/effects/phasein.ogg', 15, 1)
			else
				loading = FALSE
				break
		M.use(can_hold_val)

		user.visible_message("<span class='notice'>\The [user] loads \the [src] with \the [M].</span>")
		playsound(loc, 'sound/weapons/flipblade.ogg', 50, 1)
		update_icon()
		return
	. = ..()
