
// Phoron shards have been moved to code/game/objects/items/weapons/shards.dm

/datum/category_item/catalogue/material/crystals
	name = "Collection - Crystals"
	desc = "Occasionally found deep underground are clusters of luminescent crystals, which emit \
	a fair amount of light. The type of crystal appears to match the environment they are \
	found at, such as regions with very low temperatures having blue, icy crystals.\
	<br><br>\
	The crystals themselves are completely inert, suggesting that they do not adjust the climate they \
	are found in, instead being acted on by their local surroundings at the time of formation. Crystals \
	retain their characteristics when moved, even to a location with an 'opposite' environment to the one \
	it was found in, suggesting that locations where clusters are found have had a fairly consistant environment \
	for a very long time.\
	<br><br>\
	Unfortunately, no useful purpose has been found so far for the crystals, beyond being visually pleasing \
	to observe. They would likely be valued by jewelers, if it wasn't very difficult to work with the crystal."
	value = CATALOGUER_REWARD_MEDIUM
	unlocked_by_all = list(
		/datum/category_item/catalogue/material/regular_crystal,
		/datum/category_item/catalogue/material/ice_crystal,
		/datum/category_item/catalogue/material/magma_crystal
		)


/datum/category_item/catalogue/material/regular_crystal
	name = "Crystal - Subterranean"
	desc = "This is a luminescent crystalline mass, colored green or purple, and is sometimes found \
	in average subterranean environments. It does not appear to be able to serve any useful purpose."
	value = CATALOGUER_REWARD_EASY

//legacy crystal
/obj/machinery/crystal
	name = "crystal"
	desc = "A shiny looking crystal formation."
	icon = 'icons/obj/mining.dmi'
	icon_state = "crystal"
	density = TRUE
	anchored = TRUE
	catalogue_data = list(/datum/category_item/catalogue/material/regular_crystal)

/obj/machinery/crystal/Initialize()
	randomize_color()
	return ..()

/obj/machinery/crystal/proc/randomize_color()
	if(prob(30))
		icon_state = "crystal2"
		set_light(3, 3, "#CC00CC")
	else
		set_light(3, 3, "#33CC33")

// Icy crystals.
/datum/category_item/catalogue/material/ice_crystal
	name = "Crystal - Ice"
	desc = "This is a luminescent crystalline mass with a blue, icy appearance, and is sometimes found \
	in very cold, subterranean environments. It does not appear to be able to serve any useful purpose."
	value = CATALOGUER_REWARD_EASY

/obj/machinery/crystal/ice //slightly more thematic crystals
	name = "ice crystal"
	desc = "A large crystalline ice formation."
	icon_state = "icecrystal2"
	catalogue_data = list(/datum/category_item/catalogue/material/ice_crystal)

/obj/machinery/crystal/ice/randomize_color()
	if(prob(30))
		icon_state = "icecrystal1"
	set_light(3, 3, "#C4FFFF")

// Magma crystals.
/datum/category_item/catalogue/material/magma_crystal
	name = "Crystal - Magma"
	desc = "This is a luminescent crystalline mass, colored orange and red, and is sometimes found \
	in very hot, subterranean environments. It does not appear to be able to serve any useful purpose, \
	beyond heralding dangerous magma."
	value = CATALOGUER_REWARD_EASY

/obj/machinery/crystal/lava
	name = "magma crystal"
	desc = "A large crystalline formation found near extreme heat."
	icon_state = "grey_crystal"
	color = "#FCCF64"
	catalogue_data = list(/datum/category_item/catalogue/material/magma_crystal)

/obj/machinery/crystal/lava/randomize_color()
	if(prob(50))
		icon_state = "grey_crystal2"

	if(prob(30))
		color = "#E03131"

	set_light(3, 3, color)

//large finds
				/*
				obj/machinery/syndicate_beacon
				obj/machinery/wish_granter
			if(18)
				item_type = "jagged green crystal"
				additional_desc = pick("It shines faintly as it catches the light.","It appears to have a faint inner glow.","It seems to draw you inward as you look it at.","Something twinkles faintly as you look at it.","It's mesmerizing to behold.")
				icon_state = "crystal"
				apply_material_decorations = 0
				if(prob(10))
					apply_image_decorations = 1
			if(19)
				item_type = "jagged pink crystal"
				additional_desc = pick("It shines faintly as it catches the light.","It appears to have a faint inner glow.","It seems to draw you inward as you look it at.","Something twinkles faintly as you look at it.","It's mesmerizing to behold.")
				icon_state = "crystal2"
				apply_material_decorations = 0
				if(prob(10))
					apply_image_decorations = 1
				*/
			//machinery type artifacts?
