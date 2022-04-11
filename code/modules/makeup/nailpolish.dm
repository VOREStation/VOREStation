/obj/item/organ/external/var/datum/nail_polish/nail_polish

/obj/item/weapon/nailpolish
	name = "nail polish"
	desc = "to paint your nails with. Or someone else's!"
	icon = 'icons/obj/nailpolish_vr.dmi'
	icon_state = "nailpolish"
	var/colour = "#FFFFFF"
	var/image/top_underlay
	var/image/color_underlay
	var/open = FALSE
	drop_sound = 'sound/items/drop/glass.ogg'
	pickup_sound = 'sound/items/pickup/glass.ogg'

/obj/item/weapon/nailpolish/Initialize()
	. = ..()
	desc = "<font color='[colour]'>Nail polish,</font> " + initial(desc)
	top_underlay = image(icon, "top")
	color_underlay = image(icon, "color")
	update_icon()

/obj/item/weapon/nailpolish/proc/set_colour(var/_colour)
	colour = _colour
	desc = "<font color='[colour]'>Nail polish,</font> " + initial(desc)
	update_icon()

/obj/item/weapon/nailpolish/attack_self(var/mob/user)
	open = !open
	to_chat(user, SPAN_NOTICE("You [open ? "open" : "close"] \the [src]."))
	update_icon()

/obj/item/weapon/nailpolish/update_icon()
	. = ..()
	icon_state = "[initial(icon_state)][open ? "-open" : ""]"
	top_underlay.icon_state = "top[open ? "-open" : ""]"
	color_underlay.icon_state = "color[open ? "-open" : ""]"
	color_underlay.color = colour
	underlays = list(color_underlay, top_underlay)

/obj/item/organ/external/proc/get_polish(var/colour)
	var/static/forbidden_parts = BP_ALL - list(BP_L_HAND, BP_R_HAND, BP_L_FOOT, BP_R_FOOT)
	if(organ_tag in forbidden_parts)
		return FALSE
	var/ico
	var/icostate
	if(length(markings))
		for(var/mark_name in markings)
			var/mark_data = markings[mark_name]
			var/datum/sprite_accessory/marking/mark = mark_data["datum"]
			if(length(mark.body_parts & forbidden_parts))
				continue
			ico = mark.icon
			icostate = "[mark.icon_state]-[organ_tag]"
			break
	else
		ico = 'icons/obj/nailpolish_vr.dmi'
		icostate = organ_tag
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
	var/datum/nail_polish/polish = body_part.get_polish(colour)
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
	body_part.set_polish(polish)

/obj/item/organ/external/proc/set_polish(var/datum/nail_polish/polish)
	nail_polish = polish
	owner?.update_icons_body()

/obj/item/weapon/nailpolish_remover
	name = "nail polish remover"
	desc = "Paint thinner, acetone, nail polish remover; whatever you call it, it gets the job done."
	drop_sound = 'sound/items/drop/helm.ogg'
	pickup_sound = 'sound/items/pickup/helm.ogg'
	icon = 'icons/obj/nailpolish_vr.dmi'
	icon_state = "nailpolishremover"
	var/open = FALSE

/obj/item/weapon/nailpolish_remover/attack_self(var/mob/user)
	open = !open
	to_chat(user, SPAN_NOTICE("You [open ? "open" : "close"] \the [src]."))
	update_icon()

/obj/item/weapon/nailpolish_remover/update_icon()
	. = ..()
	icon_state = "[initial(icon_state)][open ? "-open" : ""]"

/obj/item/weapon/nailpolish_remover/attack(var/mob/user, var/mob/living/carbon/human/target)
	if(!open)
		return

	if(!istype(target))
		return
	
	var/bp = user.zone_sel.selecting
	var/obj/item/organ/external/body_part = target.get_organ(bp)
	if(!body_part)
		to_chat(user, SPAN_WARNING("[target] is missing that limb!"))
		return
	if(!body_part.nail_polish)
		to_chat(user, SPAN_NOTICE("[target]'s [body_part.name] has no nail polish to remove!"))
		return
	if(user == target)
		user.visible_message("<b>\The [user]</b> removes their nail polish with \the [src].", "You remove your nail polish with \the [src].")
	else
		if(do_after(user, 2 SECONDS, target))
			user.visible_message("<b>\The [user]</b> removes \the [target]'s nail polish with \the [src].", "You remove \the [target]'s nail polish with \the [src].")
		else
			to_chat(user, SPAN_NOTICE("Both you and [target] must stay still!"))
			return
	body_part.set_polish(null)

/datum/nail_polish
	var/icon = 'icons/obj/nailpolish_vr.dmi'
	var/icon_state
	var/color

/datum/nail_polish/New(var/_icon, var/_icon_state, var/_color)
	icon = _icon
	icon_state = _icon_state
	color = _color
	