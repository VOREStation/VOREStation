/obj/item/stack/material/wood
	name = "wooden plank"
	icon_state = "sheet-wood"
	default_type = MAT_WOOD
	strict_color_stacking = TRUE
	apply_colour = 1
	drop_sound = 'sound/items/drop/wooden.ogg'
	pickup_sound = 'sound/items/pickup/wooden.ogg'
	no_variants = FALSE

/obj/item/stack/material/wood/sif
	name = "alien wooden plank"
	color = "#0099cc"
	default_type = MAT_SIFWOOD

/obj/item/stack/material/log
	name = "log"
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

/obj/item/stack/material/log/sif
	name = "alien log"
	default_type = MAT_SIFLOG
	color = "#0099cc"
	plank_type = /obj/item/stack/material/wood/sif

/obj/item/stack/material/log/attackby(var/obj/item/W, var/mob/user)
	if(!istype(W) || W.force <= 0)
		return ..()
	if(W.sharp && W.edge)
		var/time = (3 SECONDS / max(W.force / 10, 1)) * W.toolspeed
		user.setClickCooldown(time)
		if(do_after(user, time, src) && use(1))
			to_chat(user, "<span class='notice'>You cut up a log into planks.</span>")
			playsound(src, 'sound/effects/woodcutting.ogg', 50, 1)
			var/obj/item/stack/material/wood/existing_wood = null
			for(var/obj/item/stack/material/wood/M in user.loc)
				if(M.material.name == src.material.name)
					existing_wood = M
					break

			var/obj/item/stack/material/wood/new_wood = new plank_type(user.loc)
			new_wood.amount = 2
			if(existing_wood && new_wood.transfer_to(existing_wood))
				to_chat(user, "<span class='notice'>You add the newly-formed wood to the stack. It now contains [existing_wood.amount] planks.</span>")
	else
		return ..()
