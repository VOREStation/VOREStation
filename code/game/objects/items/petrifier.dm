/obj/item/petrifier
	name = "odd button"
	desc = "A metal device with a single, purple button on it, and a tiny interface."
	icon = 'icons/obj/machines/petrification.dmi'
	icon_state = "petrifier"

	var/mob/living/carbon/human/target
	var/identifier = "statue"
	var/material = "stone"
	var/adjective = "hardens"
	var/tint = "#FFFFFF"
	var/discard_clothes = TRUE
	var/able_to_unpetrify = TRUE
	var/obj/machinery/petrification/linked

/obj/item/petrifier/Initialize(mapload, var/to_link)
	. = ..()
	linked = to_link

/obj/item/petrifier/attack_self(var/mob/user)
	. = ..()
	if (!isturf(user.loc) && user.get_ultimate_mob() != target)
		to_chat(user, span_warning("The device beeps but does nothing."))
		return
	if (linked?.petrify(user, src))
		visible_message(span_notice("A ray of purple light streams out of \the [src], aimed directly at [target]. Everywhere the light touches on them quickly [adjective] into [material]."))
		to_chat(user, span_warning("The device fizzles and crumbles into dust."))
		qdel(src)
