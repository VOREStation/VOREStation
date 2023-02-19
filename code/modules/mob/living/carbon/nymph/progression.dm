/mob/living/carbon/diona/proc/confirm_evolution()
	if(!is_alien_whitelisted(src, GLOB.all_species[SPECIES_DIONA]))
		alert(src, "You are currently not whitelisted to play as a full diona.")
		return null

	if(amount_grown < max_grown)
		to_chat(src, "You are not yet ready for your growth...")
		return null

	src.split()

	if(istype(loc,/obj/item/holder/diona))
		var/obj/item/holder/diona/L = loc
		src.loc = L.loc
		qdel(L)

	src.visible_message(
		SPAN_WARNING("[src] begins to shift and quiver, and erupts in a shower of shed bark as it splits into a tangle of nearly a dozen new dionaea."),
		SPAN_WARNING("You begin to shift and quiver, feeling your awareness splinter. All at once, we consume our stored nutrients to surge with growth, splitting into a tangle of at least a dozen new dionaea. We have attained our gestalt form.")
	)
	return SPECIES_DIONA


/mob/living/carbon/diona/verb/evolve()
	set name = "Evolve"
	set desc = "Evolve into your adult form."
	set category = "Abilities"

	if(stat != CONSCIOUS)
		return

	if(handcuffed || legcuffed)
		to_chat(src, SPAN_WARNING("You cannot evolve when you are cuffed."))
		return

	if(amount_grown < max_grown)
		to_chat(src, SPAN_WARNING("You are not fully grown."))
		return

	// confirm_evolution() handles choices and other specific requirements.
	var/new_species = confirm_evolution()
	if(!new_species)
		return

	var/mob/living/carbon/human/adult = new /mob/living/carbon/human(get_turf(src))
	adult.set_species(new_species)

	transfer_languages(src, adult)

	if(src.faction != "neutral")
		adult.faction = src.faction

	if(mind)
		mind.transfer_to(adult)
		if(can_namepick_as_adult)
			var/newname = sanitize(input(adult, "You have become an adult. Choose a name for yourself.", "Adult Name") as null|text, MAX_NAME_LEN)

			if(!newname)
				adult.fully_replace_character_name(name, "[src.adult_name] ([instance_num])")
			else
				adult.fully_replace_character_name(name, newname)
	else
		adult.key = src.key

	for (var/obj/item/W in src.contents)
		src.drop_from_inventory(W)

	qdel(src)


/mob/living/carbon/diona/proc/update_progression()
	if(amount_grown < max_grown)
		amount_grown++
	return
