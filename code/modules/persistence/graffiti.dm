/obj/effect/decal/writing
	name = "hand graffiti"
	icon_state = "writing1"
	icon = 'icons/effects/writing.dmi'
	desc = "It looks like someone has scratched something here."
	plane = DIRTY_PLANE
	layer = DIRTY_LAYER
	gender = PLURAL
	blend_mode = BLEND_MULTIPLY
	color = "#000000"
	alpha = 120
	anchored = TRUE

	var/message
	var/graffiti_age = 0
	var/author = "unknown"

/obj/effect/decal/writing/Initialize(var/ml, var/_age, var/_message, var/_author)
	. = ..(ml)
	if(!isnull(_age))
		graffiti_age = _age
	if(!isnull(_message))
		message = _message
	if(!isnull(author))
		author = _author

/obj/effect/decal/writing/Initialize(mapload)
	var/list/random_icon_states = icon_states(icon)
	for(var/obj/effect/decal/writing/W in loc)
		random_icon_states.Remove(W.icon_state)
	if(random_icon_states.len)
		icon_state = pick(random_icon_states)
	if(!mapload || !config.persistence_ignore_mapload)
		SSpersistence.track_value(src, /datum/persistent/graffiti)
	. = ..()

/obj/effect/decal/writing/Destroy()
	SSpersistence.forget_value(src, /datum/persistent/graffiti)
	. = ..()

/obj/effect/decal/writing/examine(mob/user)
	. = ..()
	. += "\n It reads \"[message]\"."

/obj/effect/decal/writing/attackby(var/obj/item/thing, var/mob/user)
	if(istype(thing, /obj/item/weldingtool))
		var/obj/item/weldingtool/welder = thing
		if(welder.isOn() && welder.remove_fuel(0,user) && do_after(user, 5, src) && !QDELETED(src))
			playsound(src.loc, welder.usesound, 50, 1)
			user.visible_message("<b>\The [user]</b> clears away some graffiti.")
			qdel(src)
	else if(thing.sharp)

		if(jobban_isbanned(user, "Graffiti"))
			to_chat(user, SPAN_WARNING("You are banned from leaving persistent information across rounds."))
			return

		var/_message = sanitize(tgui_input_text(usr, "Enter an additional message to engrave.", "Graffiti"), trim = TRUE)
		if(_message && loc && user && !user.incapacitated() && user.Adjacent(loc) && thing.loc == user)
			user.visible_message("<span class='warning'>\The [user] begins carving something into \the [loc].</span>")
			if(do_after(user, max(20, length(_message)), src) && loc)
				user.visible_message("<span class='danger'>\The [user] carves some graffiti into \the [loc].</span>")
				message = "[message] [_message]"
				author = user.ckey
				if(lowertext(message) == "elbereth")
					to_chat(user, "<span class='notice'>You feel much safer.</span>")
	else
		. = ..()
