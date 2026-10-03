/mob/living/silicon/can_slip(lube) //Kinda copied from carbon, but applies here.
	// Slip Godmode
	if(HAS_TRAIT(src, TRAIT_NO_SLIP_ALL))
		return FALSE
	// Not standing on a surface to slip on...
	if(flying || hovering)
		return FALSE
	// Not on this plane of existance (and also not able to touch whatever would be slipping them, probably.)
	if(is_incorporeal())
		return FALSE
	if(lube & PUZZLE_ICE) //Ice puzzle slips. No blocking these with gear
		return TRUE
	// Checks module antislip, neat.
	if(Check_Shoegrip())
		return FALSE
	if(!(lube & GALOSHES_DONT_HELP)) //Non-lube slippery (water, soap) //Borgs dont slip on anything below lube.
		return FALSE
	if(HAS_TRAIT(src, TRAIT_NO_SLIP_GREATER))
		return FALSE
	return TRUE
