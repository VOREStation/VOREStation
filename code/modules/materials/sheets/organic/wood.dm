/obj/item/stack/material/wood
	name = MAT_WOOD + " plank"
	icon_state = "sheet-wood"
	default_type = MAT_WOOD
	strict_color_stacking = TRUE
	apply_colour = 1
	drop_sound = 'sound/items/drop/wooden.ogg'
	pickup_sound = 'sound/items/pickup/wooden.ogg'
	no_variants = FALSE

/obj/item/stack/material/wood/sif
	name = MAT_SIFWOOD + " plank"
	color = "#0099cc"
	default_type = MAT_SIFWOOD

/obj/item/stack/material/wood/hard
	name = MAT_HARDWOOD + " plank"
	color = "#42291a"
	default_type = MAT_HARDWOOD
	description_info = "Rich, lustrous hardwood, imported from offworld at moderate expense. Mostly used for luxurious furniture, and not very good for weapons or other structures."

/obj/item/stack/material/wood/birch
	name = MAT_BIRCHWOOD + " plank"
	color = "#f6dec0"
	default_type = MAT_BIRCHWOOD
	description_info = "Sturdy hardwood, birch makes for beautiful furniture but also has many secondary applications. It's also an exceptionally good choice for firewood."

/obj/item/stack/material/wood/pine
	name = MAT_PINEWOOD + " plank"
	color = "#cd9d6f"
	default_type = MAT_PINEWOOD
	description_info = "Planks from tall, fast-growing coniferous pine trees, dense and mostly used for construction or furnishings."

/obj/item/stack/material/wood/oak
	name = MAT_OAKWOOD + " plank"
	color = "#674928"
	default_type = MAT_OAKWOOD
	description_info = "A sturdy, fairly common hardwood. A good choice for furnishings and structures. Oak barrels can be used to age alcohol, whilst oakwood chips are often used for smoking meats and cheeses."

/obj/item/stack/material/wood/acacia
	name = MAT_ACACIAWOOD + " plank"
	color = "#b75e12"
	default_type = MAT_ACACIAWOOD
	description_info = "Vibrant reddish-orange acacia makes a striking statement wherever it's used, and the bark of some acacia species is useful for tanning leather."

/obj/item/stack/material/wood/redwood
	name = MAT_REDWOOD + " plank"
	color = "#a45a52"
	default_type = MAT_REDWOOD
	description_info = "Blazing orange-red redwood planks. The trees used to make this can grow for centuries, and are often protected. This wood has been sustainably harvested from special tree nurseries, rather than chopping down ancient giants."

/obj/item/stack/material/log
	name = MAT_LOG
	icon_state = "sheet-log"
	default_type = MAT_LOG
	no_variants = FALSE
	color = "#824B28"
	max_amount = 25
	w_class = ITEMSIZE_HUGE
	description_info = "Use inhand to craft things, or use a sharp and edged object on this to convert it into two wooden planks."
	var/plank_type = /obj/item/stack/material/wood
	drop_sound = 'sound/items/drop/wooden.ogg'
	pickup_sound = 'sound/items/pickup/wooden.ogg'

/obj/item/stack/material/log/reagents_per_sheet()
	return REAGENTS_PER_LOG

/obj/item/stack/material/log/sif
	name = MAT_SIFLOG
	default_type = MAT_SIFLOG
	color = "#0099cc"
	plank_type = /obj/item/stack/material/wood/sif

/obj/item/stack/material/log/hard
	name = MAT_HARDLOG
	default_type = MAT_HARDLOG
	color = "#6f432a"
	plank_type = /obj/item/stack/material/wood/hard

/obj/item/stack/material/log/attackby(var/obj/item/W, var/mob/user)
	if(!istype(W) || W.force <= 0)
		return ..()
	if(W.sharp && W.edge)
		var/time = (3 SECONDS / max(W.force / 10, 1)) * W.toolspeed
		user.setClickCooldown(time)
		var/our_material_name = src.material.name
		if(do_after(user, time, target = src) && use(1))
			to_chat(user, span_notice("You cut up a log into planks."))
			playsound(src, 'sound/effects/woodcutting.ogg', 50, 1)
			var/obj/item/stack/material/wood/existing_wood = null
			for(var/obj/item/stack/material/wood/M in user.loc)
				if(M.material.name == our_material_name)
					existing_wood = M
					break

			var/obj/item/stack/material/wood/new_wood = new plank_type(user.loc, 2)
			if(existing_wood && new_wood.transfer_to(existing_wood))
				to_chat(user, span_notice("You add the newly-formed wood to the stack. It now contains [existing_wood.get_amount()] planks."))
	else
		return ..()

/obj/item/stack/material/stick
	name = MAT_WOODEN_STICK
	icon_state = "sheet-stick"
	default_type = MAT_WOODEN_STICK
	strict_color_stacking = TRUE
	apply_colour = 1
	drop_sound = 'sound/items/drop/wooden.ogg'
	pickup_sound = 'sound/items/pickup/wooden.ogg'
	no_variants = FALSE
	pass_color = TRUE
	apply_colour = TRUE

/obj/item/stack/material/stick/reagents_per_sheet()
	return REAGENTS_PER_ROD

/obj/item/stack/material/stick/fivestack
	amount = 5
	color = "#824B28"
