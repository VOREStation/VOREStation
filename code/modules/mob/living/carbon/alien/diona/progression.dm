/mob/living/carbon/alien/diona/Stat() //Specified where progression is at, doesn't work right for some things in carbon/alien
	. = ..()
	if(. && statpanel("Status"))
		stat("Growth", "[round(amount_grown)]/[max_grown]")

/mob/living/carbon/alien/diona/confirm_evolution()

	if(!is_alien_whitelisted(src, GLOB.all_species[SPECIES_DIONA]))
		tgui_alert(src, "You are currently not whitelisted to play as a full diona.")
		return null

	if(amount_grown < max_grown)
		to_chat(src, "You are not yet ready for your growth...")
		return null

	src.split()

	if(istype(loc,/obj/item/holder/diona))
		var/obj/item/holder/diona/L = loc
		src.loc = L.loc
		qdel(L)

	src.visible_message(span_red("[src] begins to shift and quiver, and erupts in a shower of shed bark as it splits into a tangle of nearly a dozen new dionaea."),span_red("You begin to shift and quiver, feeling your awareness splinter. All at once, we consume our stored nutrients to surge with growth, splitting into a tangle of at least a dozen new dionaea. We have attained our gestalt form."))
	return SPECIES_DIONA
