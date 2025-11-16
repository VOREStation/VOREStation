/obj/item/fusion_coil
	name = "fusion coil"
	desc = "A special heavy-duty battery used to recharge SMES units. It dumps its entire power reserve into the SMES unit at once, and cannot be recharged locally. Safety systems on the coil itself mean it can't be used on charged SMES units if it would put them over their capacity."
	icon = 'icons/obj/power_cells.dmi'
	icon_state = "fc_charged"
	var/spent_icon = "fc_spent"	//icon state used after a fusion coil is "burned out"
	item_state = "egg6"
	drop_sound = 'sound/items/drop/metalboots.ogg'
	pickup_sound = 'sound/items/pickup/gascan.ogg'

	//these things are big and heavy, they're awkward to transport, and you can't throw them very far
	w_class = ITEMSIZE_LARGE
	force = 15
	throw_speed = 4
	throw_range = 4
	slowdown = 0.5

	var/spent = FALSE	//have we been discharged into something yet?
	var/coil_charge = 4800000	//how much power do we dump into the SMES on use? restores the main (if unupgraded) by 20%, or engine by 80%
	matter = list(MAT_STEEL = 6000, MAT_COPPER = 4000, MAT_PLASTIC = 2000)
