/obj/item/fusion_coil
	name = "fusion coil"
	desc = "A special heavy-duty battery used to recharge SMES units. It dumps its entire power reserve into the SMES unit at once, and cannot be recharged locally. Safety systems on the coil itself mean it can't be used on charged SMES units if it would put them over their capacity."
	icon = 'icons/obj/power_cells.dmi'
	icon_state = "fc_spent"
	light_color = "#30B5E6"
	var/light_color_danger = "#D04E4C"
	item_state = "egg6"
	drop_sound = 'sound/items/drop/metalboots.ogg'
	pickup_sound = 'sound/items/pickup/gascan.ogg'

	//these things are big and heavy, they're awkward to transport, and you can't throw them very far
	w_class = ITEMSIZE_LARGE
	force = 15
	throw_speed = 4
	throw_range = 4
	slowdown = 1 //0.5 was not very much in practice, let's make this a bit more meaningful

	var/coil_charged = TRUE	//have we been discharged into something yet?
	var/coil_damaged = FALSE	//have we been damaged? one hit is fine, but two direct hits will explode us if we're charged
	var/coil_charge = 4800000	//how much power do we dump into the SMES on use? restores the main (if unupgraded) by 20%, or engine by 80%
	matter = list(MAT_STEEL = 6000, MAT_COPPER = 4000, MAT_PLASTIC = 2000)

/obj/item/fusion_coil/Initialize(mapload)
	. = ..()

	update_icon()

/obj/item/fusion_coil/update_icon()
	icon_state = "fc_spent"

	cut_overlays()

	. = list()

	if(coil_damaged)
		. += mutable_appearance(icon, "fc_unstable")
		. += emissive_appearance(icon, "fc_unstable")
		set_light(1, 3, light_color_danger)
		return add_overlay(.)
	else if(coil_charged)
		. += mutable_appearance(icon, "fc_charged")
		. += emissive_appearance(icon, "fc_charged")
		set_light(1, 2, light_color)
		return add_overlay(.)
	else
		set_light(0)
		return

/obj/item/fusion_coil/bullet_act(obj/item/projectile/P, def_zone)
	. = ..()

	if(P.nodamage) //the projectile does no damage, abort!
		return

	if(!coil_charged)
		return

	if(coil_damaged)
		visible_message(span_danger("\The [src] explodes in a blinding flash!"))
		explosion(src.loc, 0, 1, 3)
		qdel(src)
		return

	visible_message(span_danger("\The [src] sparks and sputters!"))
	var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
	spark_system.set_up(5, 0, src.loc)
	spark_system.start()
	playsound(src, "sparks", 50, 1)
	coil_damaged = TRUE
	coil_charge = (coil_charge / 2)
	update_icon()
