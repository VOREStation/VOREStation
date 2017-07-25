//This is in the material folder because it's used by them...
//Actual name may need to change
//All of the important code is in material_weapons.dm
/obj/item/weapon/whetstone
	name = "whetstone"
	desc = "A simple, fine grit stone, useful for sharpening dull edges and polishing out dents."
	icon_state = "whetstone"
	force = 3
	w_class = ITEMSIZE_SMALL
	var/repair_amount = 5
	var/repair_time = 40