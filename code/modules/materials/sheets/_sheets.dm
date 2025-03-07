// Stacked resources. They use a material datum for a lot of inherited values.
// If you're adding something here, make sure to add it to fifty_spawner_mats.dm as well
/obj/item/stack/material
	force = 5.0
	throwforce = 5
	w_class = ITEMSIZE_NORMAL
	throw_speed = 3
	throw_range = 3
	center_of_mass_x = 0
	center_of_mass_y = 0
	max_amount = 50
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_material.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_material.dmi',
		)

	var/default_type = MAT_STEEL
	var/datum/material/material
	var/coin_type = null
	var/perunit = SHEET_MATERIAL_AMOUNT
	var/apply_colour //temp pending icon rewrite
	drop_sound = 'sound/items/drop/axe.ogg'
	pickup_sound = 'sound/items/pickup/axe.ogg'

/obj/item/stack/material/Initialize(mapload)
	. = ..()

	randpixel_xy()

	if(!default_type)
		default_type = MAT_STEEL
	material = get_material_by_name("[default_type]")
	if(!material)
		return INITIALIZE_HINT_QDEL

	recipes = material.get_recipes()
	stacktype = material.stack_type
	if(islist(material.stack_origin_tech))
		origin_tech = material.stack_origin_tech.Copy()

	if(apply_colour)
		color = material.icon_colour

	if(!material.conductive)
		flags |= NOCONDUCT

	matter = material.get_matter()
	update_strings()

/obj/item/stack/material/get_material()
	return material

/obj/item/stack/material/proc/update_strings()
	// Update from material datum.
	singular_name = material.sheet_singular_name

	if(amount>1)
		name = "[material.use_name] [material.sheet_plural_name]"
		desc = "A [material.sheet_collective_name] of [material.use_name] [material.sheet_plural_name]."
		gender = PLURAL
	else
		name = "[material.use_name] [material.sheet_singular_name]"
		desc = "A [material.sheet_singular_name] of [material.use_name]."
		gender = NEUTER

/obj/item/stack/material/get_examine_string()
	if(!uses_charge)
		return "There [amount == 1 ? "is" : "are"] [amount] [material.sheet_singular_name]\s in the [material.sheet_collective_name]."
	return ..()

/obj/item/stack/material/use(var/used)
	. = ..()
	update_strings()
	return

/obj/item/stack/material/transfer_to(obj/item/stack/S, var/tamount=null, var/type_verified)
	var/obj/item/stack/material/M = S
	if(!istype(M) || material.name != M.material.name)
		return 0
	var/transfer = ..(S,tamount,1)
	if(src) update_strings()
	if(M) M.update_strings()
	return transfer

/obj/item/stack/material/attack_self(var/mob/user)
	if(!material.build_windows(user, src))
		..()

/obj/item/stack/material/attackby(var/obj/item/W, var/mob/user)
	if(istype(W,/obj/item/stack/cable_coil))
		material.build_wired_product(user, W, src)
		return
	else if(istype(W, /obj/item/stack/rods))
		material.build_rod_product(user, W, src)
		return
	return ..()
