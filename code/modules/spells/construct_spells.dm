//////////////////////////////Construct Spells/////////////////////////
/*
 * Moved to game/gamemodes/cult/construct_spells.dm. Here for posterity.
 */
/*
/proc/findNullRod(var/atom/target)
	if(istype(target,/obj/item/nullrod))
		return 1
	else if(target.contents)
		for(var/atom/A in target.contents)
			if(findNullRod(A))
				return 1
	return 0
*/
