/*
 * Crowbar
 */

/obj/item/weapon/tool/crowbar
	name = "crowbar"
	desc = "Used to remove floors and to pry open doors."
	icon = 'icons/obj/tools.dmi'
	icon_state = "crowbar"
	slot_flags = SLOT_BELT
	force = 6
	throwforce = 7
	item_state = "crowbar"
	w_class = ITEMSIZE_SMALL
	origin_tech = list(TECH_ENGINEERING = 1)
	matter = list(MAT_STEEL = 50)
	attack_verb = list("attacked", "bashed", "battered", "bludgeoned", "whacked")
	usesound = 'sound/items/crowbar.ogg'
	drop_sound = 'sound/items/drop/crowbar.ogg'
	pickup_sound = 'sound/items/pickup/crowbar.ogg'
	tool_qualities = list(TOOL_CROWBAR = TOOL_QUALITY_STANDARD)

/obj/item/weapon/tool/crowbar/red
	icon = 'icons/obj/tools.dmi'
	icon_state = "red_crowbar"
	item_state = "crowbar_red"


/datum/category_item/catalogue/anomalous/precursor_a/alien_crowbar
	name = "Precursor Alpha Object - Hard Light Pry Tool"
	desc = "An object which bears striking resemblence to the common crowbar. \
	It appears to also serve a similar purpose, being used for prying. Unlike \
	a crowbar, however, this object is made of some form of 'hard light'.\
	<br><br>\
	There is a visible switch on the base of the tool, which controls the \
	hard light side of the tool. When the switch is used, the shape of \
	the tool changes, with the hard light moving and making a prying motion. \
	This allows the user to pry something with no physical effort beyond keeping \
	the tool aligned while in use."
	value = CATALOGUER_REWARD_EASY

/obj/item/weapon/tool/crowbar/alien
	name = "alien crowbar"
	desc = "A hard-light crowbar. It appears to pry by itself, without any effort required."
	catalogue_data = list(/datum/category_item/catalogue/anomalous/precursor_a/alien_crowbar)
	icon = 'icons/obj/abductor.dmi'
	usesound = 'sound/weapons/sonic_jackhammer.ogg'
	icon_state = "crowbar"
	tool_qualities = list(TOOL_CROWBAR = TOOL_QUALITY_BEST)
	origin_tech = list(TECH_COMBAT = 4, TECH_ENGINEERING = 4)

/obj/item/weapon/tool/crowbar/hybrid
	name = "strange crowbar"
	desc = "A crowbar whose head seems to phase in and out of view."
	catalogue_data = list(/datum/category_item/catalogue/anomalous/precursor_a/alien_crowbar)
	icon_state = "hybcrowbar"
	usesound = 'sound/weapons/sonic_jackhammer.ogg'
	tool_qualities = list(TOOL_CROWBAR = TOOL_QUALITY_DECENT)
	origin_tech = list(TECH_COMBAT = 4, TECH_ENGINEERING = 3)
	reach = 2

/obj/item/weapon/tool/crowbar/cyborg
	name = "hydraulic crowbar"
	desc = "A hydraulic prying tool, compact but powerful. Designed to replace crowbars in industrial synthetics."
	usesound = 'sound/items/jaws_pry.ogg'
	force = 10
	tool_qualities = list(TOOL_CROWBAR = TOOL_QUALITY_DECENT)

/obj/item/weapon/tool/hydraulic_cutter
	name = "jaws of life"
	desc = "A set of jaws of life, compressed through the magic of science."
	icon = 'icons/obj/tools.dmi'
	icon_state = "jaws_pry"
	item_state = "jawsoflife"
	matter = list(MAT_METAL=150, MAT_SILVER=50)
	origin_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
	usesound = 'sound/items/jaws_pry.ogg'
	force = 15
	var/state = 0 // Technically boolean, but really a state machine
	tool_qualities = list(TOOL_CROWBAR = TOOL_QUALITY_GOOD)

/obj/item/weapon/tool/hydraulic_cutter/attack_self(mob/user)
	playsound(src, 'sound/items/change_jaws.ogg', 50, 1)
	set_tool_quality(TOOL_CROWBAR,    state ? TOOL_QUALITY_GOOD : TOOL_QUALITY_NONE)
	set_tool_quality(TOOL_WIRECUTTER, state ? TOOL_QUALITY_NONE : TOOL_QUALITY_GOOD)
	icon_state = state ? "jaws_pry" : "jaws_cutter"
	to_chat(user, "<span class='notice'>You attach the [state ? "prying" : "cutting"] jaws to [src].</span>")
	state = !state
