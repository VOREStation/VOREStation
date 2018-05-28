
// Phoron shards have been moved to code/game/objects/items/weapons/shards.dm

//legacy crystal
/obj/machinery/crystal
	name = "Crystal"
	icon = 'icons/obj/mining.dmi'
	icon_state = "crystal"
	density = TRUE
	anchored = TRUE

/obj/machinery/crystal/New()
	if(prob(30))
		icon_state = "crystal2"
		set_light(3, 3, "#CC00CC")
	else if(prob(30))
		icon_state = "crystal3"
		set_light(3, 3, "#FF003B")
	else
		set_light(3, 3, "#33CC33")

/obj/machinery/crystal/alt
	name = "Crystal"
	icon = 'icons/obj/mining.dmi'
	icon_state = "crystal"
	density = TRUE
	anchored = TRUE

/obj/machinery/crystal/alt/New()
	if(prob(50))
		icon_state = "crystal2"
		set_light(3, 3, "#CC00CC")
	else
		set_light(3, 3, "#33CC33")

/obj/machinery/crystal/ice //slightly more thematic crystals
	name = "ice crystal"
	desc = "A large crystalline ice formation."
	icon_state = "icecrystal2"

/obj/machinery/crystal/ice/New()
	if(prob(10))
		icon_state = "crystal"
		set_light(5, 5, "#33CC33")
	if(prob(10))
		icon_state = "crystal2"
		set_light(5, 5, "#CC00CC")
	if(prob(30))
		icon_state = "icecrystal1"
		set_light(5, 5, "#C4FFFF")
	else
		set_light(5, 5, "#C4FFFF")

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
