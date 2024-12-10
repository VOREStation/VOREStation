/obj/item/stack/sandbags
	name = "sandbag"
	desc = "Filled sandbags. Fortunately pre-filled."
	singular_name = "sandbag"
	icon = 'icons/obj/sandbags.dmi'
	icon_state = "sandbag"
	w_class = ITEMSIZE_LARGE
	force = 10.0
	throwforce = 20.0
	throw_speed = 5
	throw_range = 3
	drop_sound = 'sound/items/drop/clothing.ogg'
	pickup_sound = 'sound/items/pickup/clothing.ogg'
	matter = list(MAT_CLOTH = SHEET_MATERIAL_AMOUNT * 2)
	max_amount = 30
	attack_verb = list("hit", "bludgeoned", "pillowed")
	no_variants = TRUE
	stacktype = /obj/item/stack/sandbags

	pass_color = TRUE

	var/bag_material = MAT_CLOTH

/obj/item/stack/sandbags/cyborg
	name = "sandbag synthesizer"
	desc = "A device that makes filled sandbags. Don't ask how."
	gender = NEUTER
	matter = null
	uses_charge = 1
	charge_costs = list(500)
	stacktype = /obj/item/stack/sandbags

	bag_material = MAT_SYNCLOTH

/obj/item/stack/sandbags/Initialize(var/ml, var/amt, var/bag_mat)
	. = ..(ml, amt)
	recipes = sandbag_recipes
	update_icon()
	if(bag_mat)
		bag_material = bag_mat
	var/datum/material/M = get_material_by_name("[bag_material]")
	if(!M)
		return INITIALIZE_HINT_QDEL
	color = M.icon_colour

/obj/item/stack/sandbags/update_icon()
	var/amount = get_amount()

	slowdown = round(amount / 10, 0.1)

var/global/list/datum/stack_recipe/sandbag_recipes = list( \
	new/datum/stack_recipe("barricade", /obj/structure/barricade/sandbag, 3, time = 5 SECONDS, one_per_turf = 1, on_floor = 1, pass_stack_color = TRUE))

/obj/item/stack/sandbags/produce_recipe(datum/stack_recipe/recipe, var/quantity, mob/user)
	var/required = quantity*recipe.req_amount
	var/produced = min(quantity*recipe.res_amount, recipe.max_res_amount)

	if (!can_use(required))
		if (produced>1)
			to_chat(user, span_warning("You haven't got enough [src] to build \the [produced] [recipe.title]\s!"))
		else
			to_chat(user, span_warning("You haven't got enough [src] to build \the [recipe.title]!"))
		return

	if (recipe.one_per_turf && (locate(recipe.result_type) in user.loc))
		to_chat(user, span_warning("There is another [recipe.title] here!"))
		return

	if (recipe.on_floor && !isfloor(user.loc))
		to_chat(user, span_warning("\The [recipe.title] must be constructed on the floor!"))
		return

	if (recipe.time)
		to_chat(user, span_notice("Building [recipe.title] ..."))
		if (!do_after(user, recipe.time))
			return

	if (use(required))
		var/atom/O = new recipe.result_type(user.loc, bag_material)

		if(istype(O, /obj))
			var/obj/Ob = O

			if(LAZYLEN(Ob.matter))	// Law of equivalent exchange.
				Ob.matter.Cut()

			else
				Ob.matter = list()

			var/mattermult = istype(Ob, /obj/item) ? min(2000, 400 * Ob.w_class) : 2000

			Ob.matter[recipe.use_material] = mattermult / produced * required

		O.set_dir(user.dir)
		O.add_fingerprint(user)

		if (istype(O, /obj/item/stack))
			var/obj/item/stack/S = O
			S.amount = produced
			S.add_to_stacks(user)

		if (istype(O, /obj/item/storage)) //BubbleWrap - so newly formed boxes are empty
			for (var/obj/item/I in O)
				qdel(I)

		if ((pass_color || recipe.pass_color))
			if(!color)
				if(recipe.use_material)
					var/datum/material/MAT = get_material_by_name(recipe.use_material)
					if(MAT.icon_colour)
						O.color = MAT.icon_colour
				else
					return
			else
				O.color = color

// Empty bags. Yes, you need to fill them.

/obj/item/stack/emptysandbag
	name = "sandbag"
	desc = "Empty sandbags. You know what must be done."
	singular_name = "sandbag"
	icon = 'icons/obj/sandbags.dmi'
	icon_state = "sandbag_e"
	w_class = ITEMSIZE_LARGE

	strict_color_stacking = TRUE
	max_amount = 30
	stacktype = /obj/item/stack/emptysandbag

	pass_color = TRUE

	var/bag_material = MAT_CLOTH

/obj/item/stack/emptysandbag/Initialize(var/ml, var/amt, var/bag_mat)
	. = ..(ml, amt)
	if(bag_mat)
		bag_material = bag_mat
	var/datum/material/M = get_material_by_name("[bag_material]")
	if(!M)
		return INITIALIZE_HINT_QDEL
	color = M.icon_colour

/obj/item/stack/emptysandbag/attack_self(var/mob/user)
	while(do_after(user, 1 SECOND) && can_use(1) && istype(get_turf(src), /turf/simulated/floor/outdoors))
		use(1)
		var/obj/item/stack/sandbags/SB = new (get_turf(src), 1, bag_material)
		SB.color = color
		if(user)
			to_chat(user, span_notice("You fill a sandbag."))
