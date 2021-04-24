/datum/reagents/distilling/handle_reactions()
	if(QDELETED(my_atom))
		return FALSE
	if(my_atom.flags & NOREACT)
		return FALSE
	var/reaction_occurred
	var/list/eligible_reactions = list()
	var/list/effect_reactions = list()
	do
		reaction_occurred = FALSE
		for(var/i in reagent_list)
			var/datum/reagent/R = i
			if(SSchemistry.distilled_reactions_by_reagent[R.id])
				eligible_reactions |= SSchemistry.distilled_reactions_by_reagent[R.id]

		for(var/i in eligible_reactions)
			var/decl/chemical_reaction/C = i
			if(C.can_happen(src) && C.process(src))
				effect_reactions |= C
				reaction_occurred = TRUE
		eligible_reactions.len = 0
	while(reaction_occurred)
	for(var/i in effect_reactions)
		var/decl/chemical_reaction/C = i
		C.post_reaction(src)
	update_total()