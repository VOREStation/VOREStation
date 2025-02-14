/*
 * Screwdriver
 */
/obj/item/tool/screwdriver
	name = "screwdriver"
	desc = "You can be totally screwwy with this."
	description_fluff = "This could be used to engrave messages on suitable surfaces if you really put your mind to it! Alt-click a floor or wall to engrave with it." //This way it's not a completely hidden, arcane art to engrave.
	icon = 'icons/obj/tools.dmi'
	icon_state = "screwdriver"
	center_of_mass_x = 13
	center_of_mass_y = 7
	slot_flags = SLOT_BELT | SLOT_EARS
	force = 6
	w_class = ITEMSIZE_TINY
	throwforce = 5
	throw_speed = 3
	throw_range = 5
	hitsound = 'sound/weapons/bladeslice.ogg'
	usesound = 'sound/items/screwdriver.ogg'
	drop_sound = 'sound/items/drop/screwdriver.ogg'
	pickup_sound = 'sound/items/pickup/screwdriver.ogg'
	matter = list(MAT_STEEL = 75)
	attack_verb = list("stabbed")
	sharp  = TRUE
	toolspeed = 1
	tool_qualities = list(TOOL_SCREWDRIVER)
	var/random_color = TRUE

/obj/item/tool/screwdriver/New()
	if(random_color)
		switch(pick("red","blue","purple","brown","green","cyan","yellow"))
			if ("red")
				icon_state = "screwdriver2"
				item_state = "screwdriver"
			if ("blue")
				icon_state = "screwdriver"
				item_state = "screwdriver_blue"
			if ("purple")
				icon_state = "screwdriver3"
				item_state = "screwdriver_purple"
			if ("brown")
				icon_state = "screwdriver4"
				item_state = "screwdriver_brown"
			if ("green")
				icon_state = "screwdriver5"
				item_state = "screwdriver_green"
			if ("cyan")
				icon_state = "screwdriver6"
				item_state = "screwdriver_cyan"
			if ("yellow")
				icon_state = "screwdriver7"
				item_state = "screwdriver_yellow"

	if (prob(75))
		src.pixel_y = rand(0, 16)
	..()

/obj/item/tool/screwdriver/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(!istype(M) || user.a_intent == I_HELP)
		return ..()
	if(user.zone_sel.selecting != O_EYES && user.zone_sel.selecting != BP_HEAD)
		return ..()
	if((CLUMSY in user.mutations) && prob(50))
		M = user
	return eyestab(M,user)

/datum/category_item/catalogue/anomalous/precursor_a/alien_screwdriver
	name = "Precursor Alpha Object - Hard Light Torgue Tool"
	desc = "This appears to be a tool, with a solid handle, and a thin hard light \
	shaft, with a tip at the end. On the handle appears to be two mechanisms that \
	causes the hard light section to spin at a high speed while held down, in a \
	similar fashion as an electric drill. One makes it spin clockwise, the other \
	counter-clockwise.\
	<br><br>\
	The hard light tip is able to shift its shape to a degree when pressed into \
	a solid receptacle. This allows it to be able to function on many kinds of \
	fastener, which includes the screws."
	value = CATALOGUER_REWARD_EASY

/obj/item/tool/screwdriver/alien
	name = "alien screwdriver"
	desc = "An ultrasonic screwdriver."
	catalogue_data = list(/datum/category_item/catalogue/anomalous/precursor_a/alien_screwdriver)
	icon = 'icons/obj/abductor.dmi'
	icon_state = "screwdriver_a"
	item_state = "screwdriver_black"
	usesound = 'sound/items/pshoom.ogg'
	toolspeed = 0.1
	random_color = FALSE

/obj/item/tool/screwdriver/hybrid
	name = "strange screwdriver"
	desc = "A strange conglomerate of a screwdriver."
	icon_state = "hybscrewdriver"
	item_state = "screwdriver_black"
	origin_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 3)
	w_class = ITEMSIZE_NORMAL
	usesound = 'sound/effects/uncloak.ogg'
	toolspeed = 0.4
	random_color = FALSE
	reach = 2

/obj/item/tool/screwdriver/cyborg
	name = "powered screwdriver"
	desc = "An electrical screwdriver, designed to be both precise and quick."
	usesound = 'sound/items/drill_use.ogg'
	toolspeed = 0.5

/obj/item/tool/screwdriver/power
	name = "power screwdriver"
	desc = "You shouldn't see this."
	force = 8
	attack_verb = list("drilled", "screwed", "jabbed", "whacked")
	hitsound = 'sound/items/drill_hit.ogg'
	usesound = 'sound/items/drill_use.ogg'
	toolspeed = 0.25
