/obj/item/halogen_counter
	name = "halogen counter"
	icon = 'icons/obj/device.dmi'
	icon_state = "eftpos"
	desc = "A hand-held halogen counter, used to detect the level of irradiation of living beings."
	w_class = ITEMSIZE_SMALL
	origin_tech = list(TECH_MAGNET = 1, TECH_BIO = 2)
	throwforce = 0
	throw_speed = 3
	throw_range = 7
	pickup_sound = 'sound/items/pickup/device.ogg'
	drop_sound = 'sound/items/drop/device.ogg'

/obj/item/halogen_counter/attack(mob/living/M as mob, mob/living/user as mob)
	if(!iscarbon(M))
		to_chat(user, span_warning("This device can only scan organic beings!"))
		return
	user.visible_message(span_warning("\The [user] has analyzed [M]'s radiation levels!"), span_notice("Analyzing Results for [M]:"))
	if(M.radiation)
		to_chat(user, span_notice("Radiation Level: [M.radiation]"))
	else
		to_chat(user, span_notice("No radiation detected."))
	return
