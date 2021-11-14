
/obj/item/weapon/broken_gun
	desc = "The remains of an unfortunate firearm."

	var/obj/item/weapon/gun/my_guntype = null

	// Materials needed for repair. Associative list, path - number of items
	var/list/material_needs

	var/do_rotation = TRUE

/obj/item/weapon/broken_gun/Initialize(var/ml, var/path)
	. = ..(ml)
	if(path)
		if(!setup_gun(path))
			qdel(src)
			return
		setup_repair_needs()
	addtimer(CALLBACK(src, .proc/validate_gun_type), 30 SECONDS)

/obj/item/weapon/broken_gun/proc/validate_gun_type()
	if(!my_guntype && !QDELETED(src))
		qdel(src)

/obj/item/weapon/broken_gun/examine(mob/user)
	. = ..()
	spawn()
		if(get_dist(get_turf(user),get_turf(src)) <= 1)
			to_chat(user, "<span class='notice'>You begin inspecting \the [src].</span>")

			if(do_after(user, 5 SECONDS))
				to_chat(user, "<span class='notice'>\The [src] can possibly be restored with:</span>")
				for(var/obj/item/res as anything in material_needs)
					if(material_needs[res] > 0)
						var/res_name = ""
						if(ispath(res,/obj/item/stack/material))
							var/obj/item/stack/material/mat_stack = res
							var/datum/material/mat = get_material_by_name("[initial(mat_stack.default_type)]")
							if(material_needs[res]>1)
								res_name = "[mat.use_name] [mat.sheet_plural_name]"
							else
								res_name = "[mat.use_name] [mat.sheet_singular_name]"
						else
							res_name = initial(res.name)
						to_chat(user, "<span class='notice'>- x [material_needs[res]] [res_name]</span>")

/obj/item/weapon/broken_gun/proc/setup_gun(var/obj/item/weapon/gun/path)
	if(ispath(path))
		name = "[pick("busted", "broken", "shattered", "scrapped")] [initial(path.name)]"
		icon = initial(path.icon)
		icon_state = initial(path.icon_state)

		my_guntype = path

		w_class = initial(path.w_class)

		if(do_rotation)
			adjust_rotation(rand() * pick(-1,1) * rand(0, 45))

		return TRUE

	return FALSE

/obj/item/weapon/broken_gun/proc/setup_repair_needs()
	if(!LAZYLEN(material_needs))
		material_needs = list()

	if(prob(40))
		var/chosen_mat = pick(/obj/item/stack/material/plastic, /obj/item/stack/material/plasteel, /obj/item/stack/material/glass)
		material_needs[chosen_mat] = rand(1, 3)

	if(prob(30))
		var/component_needed = pick(/obj/item/weapon/stock_parts/gear,/obj/item/weapon/stock_parts/spring,/obj/item/weapon/stock_parts/manipulator)
		material_needs[component_needed] = rand(1,3)

	if(ispath(my_guntype, /obj/item/weapon/gun/energy) && prob(25))
		var/component_needed = pick(/obj/item/stack/cable_coil, /obj/item/weapon/stock_parts/scanning_module,/obj/item/weapon/stock_parts/capacitor)
		material_needs[component_needed] = rand(1,3)

	if(ispath(my_guntype, /obj/item/weapon/gun/launcher) && prob(50))
		var/component_needed = pick(/obj/item/weapon/tape_roll, /obj/item/stack/rods, /obj/item/weapon/handcuffs/cable)
		material_needs[component_needed] = 1

	if(ispath(my_guntype, /obj/item/weapon/gun/magnetic) && prob(70))
		var/component_needed = pick(/obj/item/weapon/smes_coil, /obj/item/device/assembly/prox_sensor, /obj/item/weapon/module/power_control)
		material_needs[component_needed] = 1

	material_needs[/obj/item/stack/material/steel] = rand(1,5)

/obj/item/weapon/broken_gun/attackby(obj/item/W as obj, mob/user as mob)
	if(can_repair_with(W, user))
		if(do_after(user, (rand() * 10 SECONDS) + 5 SECONDS))
			repair_with(W, user)
		return

	..()

/obj/item/weapon/broken_gun/proc/can_repair_with(obj/item/I, mob/user)
	for(var/path in material_needs)
		if(ispath(path) && istype(I, path))
			if(material_needs[path] > 0)
				if(istype(I, /obj/item/stack))
					var/obj/item/stack/S = I
					if(S.can_use(material_needs[path]))
						return TRUE
					else
						to_chat(user, "<span class='notice'>You do not have enough [path] to continue repairs.</span>")
				else
					return TRUE

	return FALSE

/obj/item/weapon/broken_gun/proc/repair_with(obj/item/I, mob/user)
	for(var/path in material_needs)
		if(ispath(path) && istype(I, path))
			if(material_needs[path] > 0)
				if(istype(I, /obj/item/stack))
					var/obj/item/stack/S = I
					if(S.can_use(material_needs[path]))
						S.use(material_needs[path])
						material_needs[path] = 0
						to_chat(user, "<span class='notice'>You repair some damage on \the [src] with \the [S].</span>")
				else
					material_needs[path] = max(0, material_needs[path] - 1)
					user.drop_from_inventory(I)
					to_chat(user, "<span class='notice'>You repair some damage on \the [src] with \the [I].</span>")
					qdel(I)

	check_complete_repair(user)

	return

/obj/item/weapon/broken_gun/proc/check_complete_repair(mob/user)
	var/fully_repaired = TRUE
	for(var/resource in material_needs)
		if(material_needs[resource] > 0)
			fully_repaired = FALSE
			break

	if(fully_repaired)
		my_guntype = new my_guntype(get_turf(src))
		my_guntype.name = "[pick("salvaged", "repaired", "old")] [initial(my_guntype.name)]"
		to_chat(user, "<span class='notice'>You finish your repairs on \the [my_guntype].</span>")
		qdel(src)
