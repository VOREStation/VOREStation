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
		for(var/datum/reagent/R as anything in reagent_list)
			if(SSchemistry.distilled_reactions_by_reagent[R.id])
				eligible_reactions |= SSchemistry.distilled_reactions_by_reagent[R.id]

		for(var/decl/chemical_reaction/C as anything in eligible_reactions)
			if(C.can_happen(src) && C.process(src))
				effect_reactions |= C
				reaction_occurred = TRUE
		eligible_reactions.len = 0
	while(reaction_occurred)
	for(var/decl/chemical_reaction/C as anything in effect_reactions)
		C.post_reaction(src)
	update_total()
