//This is in the material folder because it's used by them...
//Actual name may need to change
//All of the important code is in material_weapons.dm
/obj/item/whetstone
	name = "whetstone"
	desc = "A simple, fine grit stone, useful for sharpening dull edges and polishing out dents."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "whetstone"
	force = 3
	w_class = ITEMSIZE_SMALL
	var/repair_amount = 5
	var/repair_time = 40
	
/obj/item/whetstone/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/stack/material))
		var/obj/item/stack/material/M = I
		if(M.get_amount() >= 5)
			to_chat(user, "You begin to refine the [src] with [M]...")
			if(do_after(user, 70))
				M.use(5)
				var/obj/item/SK
				SK = new /obj/item/material/sharpeningkit(get_turf(user), M.material.name)
				to_chat(user, "You sharpen and refine the [src] into \a [SK].")
				qdel(src)
				if(SK)
					user.put_in_hands(SK)
		else
			to_chat(user, "You need 5 [src] to refine it into a sharpening kit.")

/obj/item/material/sharpeningkit
	name = "sharpening kit"
	desc = "A refined, fine grit whetstone, useful for sharpening dull edges, polishing out dents, and, with extra material, replacing an edge."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "sharpener"
	hitsound = 'sound/weapons/genhit3.ogg'
	force_divisor = 0.7
	thrown_force_divisor = 1
	var/repair_amount = 5
	var/repair_time = 40
	var/sharpen_time = 100
	var/uses = 0

/obj/item/material/sharpeningkit/examine(mob/user, distance)
	. = ..()
	. += "There [uses == 1 ? "is" : "are"] [uses] [material] [uses == 1 ? src.material.sheet_singular_name : src.material.sheet_plural_name] left for use."

/obj/item/material/sharpeningkit/Initialize()
	. = ..()
	setrepair()

/obj/item/material/sharpeningkit/proc/setrepair()
	repair_amount = material.hardness * 0.1
	repair_time = material.weight * 0.5
	sharpen_time = material.weight * 3

/obj/item/material/sharpeningkit/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/stack/material))
		var/obj/item/stack/material/S = W
		if(S.material == material)
			S.use(1)
			uses += 1
			to_chat(user, "You add a [S.material.name] [S.material.sheet_singular_name] to [src].")
			return

<<<<<<< HEAD
	if(istype(W, /obj/item/weapon/material))
		if(istype(W, /obj/item/weapon/material/sharpeningkit))
			to_chat(user, "As much as you'd like to sharpen [W] with [src], the logistics just don't work out.")
=======
	if(istype(W, /obj/item/material))
		if(istype(W, /obj/item/material/sharpeningkit))
			to_chat(user, "Really? Sharpening a [W] with [src]? You goofball.")
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
			return
		var/obj/item/material/M = W
		if(uses >= M.w_class*2)
			if(M.sharpen(src.material.name, sharpen_time, src, user))
				uses -= M.w_class*2
				return
		else
			to_chat(user, "There's not enough spare sheets to sharpen [M]. You need [M.w_class*2] [M.material.sheet_plural_name].")
			return
	else
		to_chat(user, "You can't sharpen [W] with [src]!") 
