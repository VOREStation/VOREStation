//50-stacks as their own type was too buggy, we're doing it a different way
/obj/fiftyspawner //this doesn't need to do anything but make the stack and die so it's light
	name = "50-stack spawner"
	desc = "This item spawns stack of 50 of a given material."
	icon = 'icons/misc/mark.dmi'
	icon_state = "x4"
	var/material = ""

/obj/fiftyspawner/New()
	//spawns the 50-stack and qdels self
	..()
	var/obj_path = text2path("/obj/item/stack/[material]")
	var/obj/item/stack/M = new obj_path(src.loc)
	M.amount = M.max_amount //some stuff spawns with 60, we're still calling it fifty
	qdel(src)

/obj/fiftyspawner/rods
	name = "stack of rods" //this needs to be defined for cargo
	material = "rods"