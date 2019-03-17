//50-stacks as their own type was too buggy, we're doing it a different way
/obj/fiftyspawner //this doesn't need to do anything but make the stack and die so it's light
	name = "50-stack spawner"
	desc = "This item spawns stack of 50 of a given material."
	icon = 'icons/misc/mark.dmi'
	icon_state = "x4"
//	var/material = ""
	var/obj/item/stack/type_to_spawn = null

/obj/fiftyspawner/New()
	spawn()
		//spawns the 50-stack and qdels self
		..()
		if(istype(src.loc, /obj/structure/loot_pile)) //Spawning from a lootpile is weird, need to wait until we're out of it to do our work.
			while(istype(src.loc, /obj/structure/loot_pile))
				sleep(1)
	//	var/obj_path = text2path("/obj/item/stack/[material]")
		var/obj/item/stack/M = new type_to_spawn(src.loc)
		M.amount = M.max_amount //some stuff spawns with 60, we're still calling it fifty
		M.update_icon() // Some stacks have different sprites depending on how full they are.
		qdel(src)

/obj/fiftyspawner/rods
	name = "stack of rods" //this needs to be defined for cargo
	type_to_spawn = /obj/item/stack/rods