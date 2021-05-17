/**
 * Ensure a list of atoms/reagents exists inside this atom
 *
 * Goes throught he list of passed in parts, if they're reagents, adds them to our reagent holder
 * creating the reagent holder if it exists.
 *
 * If the part is a moveable atom and the  previous location of the item was a mob/living,
 * it calls the inventory handler transferItemToLoc for that mob/living and transfers the part
 * to this atom
 *
 * Otherwise it simply forceMoves the atom into this atom
 */
/atom/proc/CheckParts(list/parts_list, datum/crafting_recipe/R)
	SEND_SIGNAL(src, COMSIG_ATOM_CHECKPARTS, parts_list, R)
	if(parts_list)
		for(var/A in parts_list)
			if(istype(A, /datum/reagent))
				if(!reagents)
					reagents = new()
				reagents.reagent_list.Add(A)
				reagents.conditional_update()
			else if(ismovable(A))
				var/atom/movable/M = A
				if(isliving(M.loc))
					var/mob/living/L = M.loc
					L.unEquip(M, target = src)
				else
					M.forceMove(src)
				SEND_SIGNAL(M, COMSIG_ATOM_USED_IN_CRAFT, src)
		parts_list.Cut()

/obj/machinery/CheckParts(list/parts_list)
	..()
	RefreshParts()