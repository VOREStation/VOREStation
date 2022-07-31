/*
 * Wirecutters
 */
/obj/item/tool/wirecutters
	name = "wirecutters"
	desc = "This cuts wires."
	description_fluff = "This could be used to engrave messages on suitable surfaces if you really put your mind to it! Alt-click a floor or wall to engrave with it." //This way it's not a completely hidden, arcane art to engrave.
	icon = 'icons/obj/tools.dmi'
	icon_state = "cutters"
	item_state = "cutters"
	center_of_mass = list("x" = 18,"y" = 10)
	slot_flags = SLOT_BELT
	force = 6
	throw_speed = 2
	throw_range = 9
	w_class = ITEMSIZE_SMALL
	origin_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1)
	matter = list(MAT_STEEL = 80)
	attack_verb = list("pinched", "nipped")
	hitsound = 'sound/items/wirecutter.ogg'
	usesound = 'sound/items/wirecutter.ogg'
	drop_sound = 'sound/items/drop/wirecutter.ogg'
	pickup_sound = 'sound/items/pickup/wirecutter.ogg'
	sharp = TRUE
	edge = TRUE
	toolspeed = 1
	tool_qualities = list(TOOL_WIRECUTTER)
	var/random_color = TRUE

/obj/item/tool/wirecutters/Initialize()
	if(random_color)
		switch(pick("red","blue","yellow"))
			if ("red")
				icon_state = "cutters"
				item_state = "cutters"
			if ("blue")
				icon_state = "cutters-b"
				item_state = "cutters_blue"
			if ("yellow")
				icon_state = "cutters-y"
				item_state = "cutters_yellow"

	if (prob(75))
		src.pixel_y = rand(0, 16)
	. = ..()

/obj/item/tool/wirecutters/attack(mob/living/carbon/C as mob, mob/user as mob)
	if(istype(C) && user.a_intent == I_HELP && (C.handcuffed) && (istype(C.handcuffed, /obj/item/handcuffs/cable)))
		usr.visible_message("\The [usr] cuts \the [C]'s restraints with \the [src]!",\
		"You cut \the [C]'s restraints with \the [src]!",\
		"You hear cable being cut.")
		C.handcuffed = null
		if(C.buckled && C.buckled.buckle_require_restraints)
			C.buckled.unbuckle_mob()
		C.update_handcuffed()
		return
	else
		..()

/datum/category_item/catalogue/anomalous/precursor_a/alien_wirecutters
	name = "Precursor Alpha Object - Wire Seperator"
	desc = "An object appearing to have a tool shape. It has two handles, and two \
	sides which are attached to each other in the center. At the end on each side \
	is a sharp cutting edge, made from a seperate material than the rest of the \
	tool.\
	<br><br>\
	This tool appears to serve the same purpose as conventional wirecutters, due \
	to how similar the shapes are. If so, this implies that the creators of this \
	object also may utilize flexible cylindrical strands of metal to transmit \
	energy and signals, just as humans do."
	value = CATALOGUER_REWARD_EASY

/obj/item/tool/wirecutters/alien
	name = "alien wirecutters"
	desc = "Extremely sharp wirecutters, made out of a silvery-green metal."
	catalogue_data = list(/datum/category_item/catalogue/anomalous/precursor_a/alien_wirecutters)
	icon = 'icons/obj/abductor.dmi'
	icon_state = "cutters"
	toolspeed = 0.1
	origin_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 4)
	random_color = FALSE

/obj/item/tool/wirecutters/cyborg
	name = "wirecutters"
	desc = "This cuts wires.  With science."
	usesound = 'sound/items/jaws_cut.ogg'
	toolspeed = 0.5

/obj/item/tool/wirecutters/hybrid
	name = "strange wirecutters"
	desc = "This cuts wires.  With <span class='alien'>Science!</span>"
	icon_state = "hybcutters"
	w_class = ITEMSIZE_NORMAL
	origin_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 3, TECH_PHORON = 2)
	attack_verb = list("pinched", "nipped", "warped", "blasted")
	usesound = 'sound/effects/stealthoff.ogg'
	toolspeed = 0.4
	reach = 2

/obj/item/tool/wirecutters/power
	name = "jaws of life"
	desc = "A set of jaws of life, compressed through the magic of science. It's fitted with a cutting head."
	icon_state = "jaws_cutter"
	item_state = "jawsoflife"
	origin_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
	matter = list(MAT_METAL=150, MAT_SILVER=50)
	usesound = 'sound/items/jaws_cut.ogg'
	force = 15
	toolspeed = 0.25
	random_color = FALSE
	var/obj/item/tool/crowbar/power/counterpart = null

/obj/item/tool/wirecutters/power/Initialize(var/ml, no_counterpart = TRUE)
	. = ..(ml)
	if(!counterpart && no_counterpart)
		counterpart = new(src, FALSE)
		counterpart.counterpart = src

/obj/item/tool/wirecutters/power/Destroy()
	if(counterpart)
		counterpart.counterpart = null // So it can qdel cleanly.
		QDEL_NULL(counterpart)
	return ..()

/obj/item/tool/wirecutters/power/attack_self(mob/user)
	playsound(src, 'sound/items/change_jaws.ogg', 50, 1)
	user.drop_item(src)
	counterpart.forceMove(get_turf(src))
	src.forceMove(counterpart)
	user.put_in_active_hand(counterpart)
	to_chat(user, "<span class='notice'>You attach the pry jaws to [src].</span>")
