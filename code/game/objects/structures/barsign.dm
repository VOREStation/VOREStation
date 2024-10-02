/obj/structure/sign/double/barsign
	desc = "The current barsign of this shift! The bartender can change it with their ID."
	icon = 'icons/obj/barsigns.dmi'
	plane = ABOVE_PLANE
	icon_state = "empty"
	appearance_flags = 0
	anchored = TRUE
	var/cult = 0

/obj/structure/sign/double/barsign/proc/get_valid_states(initial=1)
	. = cached_icon_states(icon)
	. -= "On"
	. -= "Nar-sie Bistro"
	. -= "Empty"
	if(initial)
		. -= "Off"

/obj/structure/sign/double/barsign/examine(mob/user)
	. = ..()
	switch(icon_state)
		if("Off")
			. += "It appears to be switched off."
		if("Nar-sie Bistro")
			. += "It shows a picture of a large black and red being. Spooky!"
		if("On", "Empty")
			. += "The lights are on, but there's no picture."
		else
			. += "It says '[icon_state]'"

/obj/structure/sign/double/barsign/New()
	..()
	icon_state = pick(get_valid_states())

/obj/structure/sign/double/barsign/attackby(obj/item/I, mob/user)
	if(cult)
		return ..()

	var/obj/item/card/id/card = I.GetID()
	if(istype(card))
		if(access_bar in card.GetAccess())
			var/sign_type = tgui_input_list(user, "What would you like to change the barsign to?", "Bar Sign Choice", get_valid_states(0))
			if(!sign_type)
				return
			icon_state = sign_type
			to_chat(user, span_notice("You change the barsign."))
		else
			to_chat(user, span_warning("Access denied."))
		return

	return ..()
