/obj/item/weapon/material/star
	name = "shuriken"
	desc = "A sharp, perfectly weighted piece of metal."
	icon_state = "star"
	force_divisor = 0.1 // 6 with hardness 60 (steel)
	thrown_force_divisor = 0.75 // 15 with weight 20 (steel)
	throw_speed = 10
	throw_range = 15
	sharp = TRUE
	edge =  TRUE

/obj/item/weapon/material/star/New()
	..()
	src.pixel_x = rand(-12, 12)
	src.pixel_y = rand(-12, 12)

/obj/item/weapon/material/star/throw_impact(atom/hit_atom)
	..()
	if(material.radioactivity>0 && istype(hit_atom,/mob/living))
		var/mob/living/M = hit_atom
		M.adjustToxLoss(rand(20,40))

<<<<<<< HEAD
/obj/item/weapon/material/star/ninja
	default_material = "uranium"
=======
/obj/item/material/star/ninja
	default_material = "uranium"

// Hilariously, arrows are just darts, but bigger! ..The same can be said of spears. Thrown weapon.
/obj/item/material/arrow
	name = "arrow"
	desc = "A sharp, triangular head on a slender body. Yep, it's an arrow."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "arrowmetal"
	item_state = "bolt"
	force_divisor = 0.1 // 6 with hardness 60 (steel)
	thrown_force_divisor = 0.4 // 8 with weight 20 (steel)
	throw_speed = 10
	throw_range = 4
	sharp = 1
	edge =  1

	var/list/knock_point = list(7,7)

/obj/item/material/arrow/crude
	name = "crude arrow"
	desc = "An ancient device for stabbing someone at range."
	icon_state = "arrow"
	thrown_force_divisor = 0.3
	throw_range = 3
	edge = 0
>>>>>>> e072e147a41... Archery Tweaks (#8670)
