/obj/item/organ/external/var/datum/nail_polish/nail_polish

/obj/item/weapon/nailpolish
	name = "nail polish"
	icon = 'icons/obj/nailpolish_vr.dmi'
	icon_state = "nailpolish"
	var/colour = "#FF0000"
	var/icon/top_underlay
	var/icon/top_underlay_open
	var/icon/color_underlay
	var/icon/color_underlay_open
	var/open = FALSE
	drop_sound = 'sound/items/drop/glass.ogg'
	pickup_sound = 'sound/items/pickup/glass.ogg'

/obj/item/weapon/nailpolish/Initialize()
	. = ..()
	regenerate_icons()

/obj/item/weapon/nailpolish/proc/regenerate_icons()
	top_underlay = icon(icon, "top")
	top_underlay_open = icon(icon, "top-open")
	color_underlay = icon(icon, "color")
	color_underlay.Blend(colour, ICON_MULTIPLY)
	color_underlay_open = icon(icon, "color-open")
	color_underlay_open.Blend(colour, ICON_MULTIPLY)
	update_icon()

/obj/item/weapon/nailpolish/proc/set_colour(var/_colour)
	colour = _colour
	regenerate_icons()

/obj/item/weapon/nailpolish/attack_self(var/mob/user)
	open = !open
	to_chat(user, SPAN_NOTICE("You [open ? "open" : "close"] \the [src]."))
	update_icon()

/obj/item/weapon/nailpolish/update_icon()
	. = ..()
	underlays.Cut()
	icon_state = "[initial(icon_state)][open ? "-open" : null]"
	if (open)
		underlays = list(color_underlay_open, top_underlay_open)
	else
		underlays = list(color_underlay, top_underlay)

/obj/item/weapon/nailpolish/proc/get_polish(var/mob/living/carbon/human/target, var/bp)
	var/static/forbidden_parts
	if(!forbidden_parts)
		forbidden_parts = BP_ALL - list(BP_L_HAND, BP_R_HAND, BP_L_FOOT, BP_R_FOOT)
	if(!istype(target)) // humantypes only for now
		return FALSE
	var/obj/item/organ/external/body_part = target.get_organ(bp)
	if(!body_part)
		return FALSE
	var/ico
	var/icostate
	if(length(body_part.markings))
		for(var/mark_name in body_part.markings)
			var/mark_data = body_part.markings[mark_name]
			var/datum/sprite_accessory/marking/mark = mark_data["datum"]
			if(length(mark.body_parts & forbidden_parts))
				continue
			ico = mark.icon
			icostate = "[mark.icon_state]-[bp]"
			break
	else
		ico = 'icons/obj/nailpolish_vr.dmi'
		icostate = bp
		if(bp in forbidden_parts)
			return FALSE
	return new /datum/nail_polish(ico, icostate, colour)

/obj/item/weapon/nailpolish/attack(var/mob/user, var/mob/living/carbon/human/target)
	if(!open)
		return

	if(!istype(target))
		return
	
	var/bp = user.zone_sel.selecting
	var/obj/item/organ/external/body_part = target.get_organ(bp)
	if(!body_part)
		to_chat(user, SPAN_WARNING("[target] is missing that limb!"))
		return
	if(body_part.nail_polish)
		to_chat(user, SPAN_NOTICE("[target]'s [body_part.name] already has nail polish on!"))
		return
	var/datum/nail_polish/polish = get_polish(target, bp)
	if(!polish)
		to_chat(user, SPAN_NOTICE("You can't find any nails on [body_part] to paint."))
		return
	if(user == target)
		user.visible_message("<b>\The [user]</b> paints their nails with \the [src].", "You paint your nails with \the [src].")
	else
		if(do_after(user, 2 SECONDS, target))
			user.visible_message("<b>\The [user]</b> paints \the [target]'s nails with \the [src].", "You paint \the [target]'s nails with \the [src].")
		else
			to_chat(user, SPAN_NOTICE("Both you and [target] must stay still!"))
			return
	body_part.nail_polish = polish
	target.update_icons_body()
	
/datum/nail_polish
	var/icon = 'icons/obj/nailpolish_vr.dmi'
	var/icon_state
	var/color

/datum/nail_polish/New(var/_icon, var/_icon_state, var/_color)
	icon = _icon
	icon_state = _icon_state
	color = _color
	