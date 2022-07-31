/datum/gear/cosmetic/nailpolish
	display_name = "nail polish (colorable)"
	description = "Nail polish, available in every color of the rainbow! Doesn't come with nail polish remover."
	path = /obj/item/nailpolish

/datum/gear/cosmetic/nailpolish/Initialize()
	. = ..()
	// can't set description, it'll look funny
	gear_tweaks = list(gear_tweak_free_color_choice, gear_tweak_free_name)

/datum/gear/cosmetic/nailpolish/spawn_item(var/location, var/metadata)
	var/obj/item/nailpolish/polish = ..()
	polish.set_colour(polish.color)
	polish.color = null
	return polish

/datum/gear/cosmetic/nailpolish_remover
	display_name = "nail polish remover"
	description = "Nail polish remover, for when the fun's over. Doesn't come with nail polish."
	path = /obj/item/nailpolish_remover
