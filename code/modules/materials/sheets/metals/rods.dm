/obj/item/stack/rods
	name = "metal rod"
	desc = "Some rods. Can be used for building, or something."
	singular_name = "metal rod"
	icon_state = "rods"
	w_class = ITEMSIZE_NORMAL
	force = 9.0
	throwforce = 15.0
	throw_speed = 5
	throw_range = 20
	drop_sound = 'sound/items/drop/metalweapon.ogg'
	pickup_sound = 'sound/items/pickup/metalweapon.ogg'
	matter = list(MAT_STEEL = SHEET_MATERIAL_AMOUNT / 2)
	max_amount = 60
	attack_verb = list("hit", "bludgeoned", "whacked")

	color = "#666666"

/obj/item/stack/rods/cyborg
	name = "metal rod synthesizer"
	desc = "A device that makes metal rods."
	gender = NEUTER
	matter = null
	uses_charge = 1
	charge_costs = list(500)
	stacktype = /obj/item/stack/rods
	no_variants = TRUE

/obj/item/stack/rods/Initialize(mapload)
	. = ..()
	recipes = rods_recipes
	update_icon()

/obj/item/stack/rods/update_icon()
	var/amount = get_amount()
	if((amount <= 5) && (amount > 0))
		icon_state = "rods-[amount]"
	else
		icon_state = "rods"

var/global/list/datum/stack_recipe/rods_recipes = list( \
	new/datum/stack_recipe("grille", /obj/structure/grille, 2, time = 10, one_per_turf = 1, on_floor = 0),
	new/datum/stack_recipe("catwalk", /obj/structure/catwalk, 2, time = 80, one_per_turf = 1, on_floor = 1))

/obj/item/stack/rods/attackby(obj/item/W, mob/user)
	if(W.has_tool_quality(TOOL_WELDER))
		var/obj/item/weldingtool/WT = W.get_welder()

		if(get_amount() < 2)
			to_chat(user, span_warning("You need at least two rods to do this."))
			return

		if(WT.remove_fuel(0,user))
			var/obj/item/stack/material/steel/new_item = new(user.loc)
			new_item.add_to_stacks(user)
			for (var/mob/M in viewers(src))
				M.show_message(span_notice("[src] is shaped into metal by [user.name] with the weldingtool."), 3, span_notice("You hear welding."), 2)
			var/obj/item/stack/rods/R = src
			src = null
			var/replace = (user.get_inactive_hand()==R)
			R.use(2)
			if (!R && replace)
				user.put_in_hands(new_item)
		return

	if (istype(W, /obj/item/tape_roll))
		var/obj/item/stack/medical/splint/ghetto/new_splint = new(get_turf(user))
		new_splint.add_fingerprint(user)

		user.visible_message(span_infoplain(span_bold("\The [user]") + " constructs \a [new_splint] out of a [singular_name]."), \
				span_notice("You use make \a [new_splint] out of a [singular_name]."))
		src.use(1)
		return

	..()

/*
/obj/item/stack/rods/attack_self(mob/user)
	src.add_fingerprint(user)

	if(!istype(user.loc,/turf)) return 0

	if (locate(/obj/structure/grille, user.loc))
		for(var/obj/structure/grille/G in user.loc)
			if (G.destroyed)
				G.health = 10
				G.density = TRUE
				G.destroyed = 0
				G.icon_state = "grille"
				use(1)
			else
				return 1

	else if(!in_use)
		if(get_amount() < 2)
			to_chat(user, span_warning("You need at least two rods to do this."))
			return
		to_chat(user, span_notice("Assembling grille..."))
		in_use = 1
		if (!do_after(user, 10))
			in_use = 0
			return
		var/obj/structure/grille/F = new /obj/structure/grille/ ( user.loc )
		to_chat(user, span_notice("You assemble a grille"))
		in_use = 0
		F.add_fingerprint(user)
		use(2)
	return
*/
