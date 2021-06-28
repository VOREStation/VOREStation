/datum/gear/cosmetic/nailpolish
	display_name = "nail polish (colorable)"
	path = /obj/item/weapon/nailpolish

/datum/gear/cosmetic/nailpolish/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/cosmetic/nailpolish/spawn_item(var/location, var/metadata)
	var/obj/item/weapon/nailpolish/polish = ..()
	polish.set_colour(polish.color)
	polish.color = null
	return polish
	