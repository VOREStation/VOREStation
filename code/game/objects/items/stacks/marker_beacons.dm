/*****************Marker Beacons**************************/
var/list/marker_beacon_colors = list(
"Random" = FALSE, //not a true color, will pick a random color
"Burgundy" = LIGHT_COLOR_FLARE,
"Bronze" = LIGHT_COLOR_ORANGE,
"Yellow" = LIGHT_COLOR_YELLOW,
"Lime" = LIGHT_COLOR_SLIME_LAMP,
"Olive" = LIGHT_COLOR_GREEN,
"Jade" = LIGHT_COLOR_BLUEGREEN,
"Teal" = LIGHT_COLOR_LIGHT_CYAN,
"Cerulean" = LIGHT_COLOR_BLUE,
"Indigo" = LIGHT_COLOR_DARK_BLUE,
"Purple" = LIGHT_COLOR_PURPLE,
"Violet" = LIGHT_COLOR_LAVENDER,
"Fuchsia" = LIGHT_COLOR_PINK
)

/obj/item/stack/marker_beacon
	name = "marker beacons"
	singular_name = "marker beacon"
	desc = "Prismatic path illumination devices. Used by explorers and miners to mark paths and warn of danger."
	description_info = "Use inhand to drop one marker beacon. You can pick them up again with an empty hand or \
	hitting them with this marker stack. Alt-click to select a specific color."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "markerrandom"
	max_amount = 100
	no_variants = TRUE
	w_class = ITEMSIZE_SMALL
	var/icon_base = "marker"
	var/picked_color = "random"

/obj/item/stack/marker_beacon/ten
	amount = 10

/obj/item/stack/marker_beacon/thirty
	amount = 30

/obj/item/stack/marker_beacon/hundred
	amount = 100

/obj/item/stack/marker_beacon/Initialize()
	. = ..()
	update_icon()

/obj/item/stack/marker_beacon/examine(mob/user)
	. = ..()
	. += span_notice("Use in-hand to place a [singular_name].")
	. += span_notice("Alt-click to select a color. Current color is [picked_color].")

/obj/item/stack/marker_beacon/update_icon()
	icon_state = "[icon_base][lowertext(picked_color)]"

/obj/item/stack/marker_beacon/attack_self(mob/user)
	if(!isturf(user.loc))
		to_chat(user, span_warning("You need more space to place a [singular_name] here."))
		return
	if(locate(/obj/structure/marker_beacon) in user.loc)
		to_chat(user, span_warning("There is already a [singular_name] here."))
		return
	if(use(1))
		to_chat(user, span_notice("You activate and anchor [amount ? "a":"the"] [singular_name] in place."))
		playsound(src, 'sound/machines/click.ogg', 50, 1)
		var/obj/structure/marker_beacon/M = new(user.loc, picked_color)
		transfer_fingerprints_to(M)

/obj/item/stack/marker_beacon/AltClick(mob/living/user)
	if(user.incapacitated() || !istype(user))
		to_chat(user, span_warning("You can't do that right now!"))
		return
	if(!in_range(src, user))
		return
	var/input_color = tgui_input_list(user, "Choose a color.", "Beacon Color", marker_beacon_colors)
	if(user.incapacitated() || !istype(user) || !in_range(src, user))
		return
	if(input_color)
		picked_color = input_color
		update_icon()

/obj/structure/marker_beacon
	name = "marker beacon"
	desc = "A prismatic path illumination device. It is anchored in place and glowing steadily."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "markerrandom"
//	layer = BELOW_OPEN_DOOR_LAYER
	anchored = TRUE
	light_range = 2
	light_power = 0.8
	var/icon_base = "marker"
	var/remove_speed = 15
	var/picked_color
	var/perma = FALSE
	var/mapped_in_color

/obj/structure/marker_beacon/New(newloc, set_color)
	. = ..()
	if(set_color)
		picked_color = set_color
	else if(mapped_in_color)
		picked_color = mapped_in_color
	update_icon()

/obj/structure/marker_beacon/examine(mob/user)
	. = ..()
	if(!perma)
		. += span_notice("Alt-click to select a color. Current color is [picked_color].")

/obj/structure/marker_beacon/update_icon()
	if(!picked_color || !marker_beacon_colors[picked_color])
		picked_color = pick(marker_beacon_colors)
	icon_state = "[icon_base][lowertext(picked_color)]-on"
	set_light(light_range, light_power, marker_beacon_colors[picked_color])

/obj/structure/marker_beacon/attack_hand(mob/living/user)
	if(perma)
		return
	to_chat(user, span_notice("You start picking [src] up..."))
	if(do_after(user, remove_speed, target = src))
		var/obj/item/stack/marker_beacon/M = new(loc)
		M.picked_color = picked_color
		M.update_icon()
		transfer_fingerprints_to(M)
		if(user.put_in_hands(M, TRUE)) //delete the beacon if it fails
			playsound(src, 'sound/items/deconstruct.ogg', 50, 1)
			qdel(src) //otherwise delete us

/obj/structure/marker_beacon/attackby(obj/item/I, mob/user, params)
	if(perma)
		return
	if(istype(I, /obj/item/stack/marker_beacon))
		var/obj/item/stack/marker_beacon/M = I
		to_chat(user, span_notice("You start picking [src] up..."))
		if(do_after(user, remove_speed, target = src) && M.get_amount() + 1 <= M.max_amount)
			M.add(1)
			playsound(src, 'sound/items/deconstruct.ogg', 50, 1)
			qdel(src)
	else
		return ..()

/obj/structure/marker_beacon/AltClick(mob/living/user)
	..()
	if(perma)
		return
	if(user.incapacitated() || !istype(user))
		to_chat(user, span_warning("You can't do that right now!"))
		return
	if(!in_range(src, user))
		return
	var/input_color = tgui_input_list(user, "Choose a color.", "Beacon Color", marker_beacon_colors)
	if(user.incapacitated() || !istype(user) || !in_range(src, user))
		return
	if(input_color)
		picked_color = input_color
		update_icon()
