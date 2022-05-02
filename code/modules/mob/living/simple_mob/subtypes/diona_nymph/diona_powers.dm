//Verbs after this point.
/mob/living/simple_mob/diona_nymph/proc/merge()
	set category = "Abilities"
	set name = "Merge with gestalt"
	set desc = "Merge with another diona."

	if(stat == DEAD || paralysis || weakened || stunned || restrained())
		return

	if(ishuman(src.loc))
		src.verbs -= /mob/living/simple_mob/diona_nymph/proc/merge
		return

	var/list/choices = list()
	for(var/mob/living/human/H in view(1))
		if(!(Adjacent(H)) || !(H.client))
			continue

		if(H?.species?.name == SPECIES_DIONA)
			choices += H

	var/mob/living/M = input(src,"Who do you wish to merge with?") in null|choices

	if(!M)
		to_chat(src, "There is nothing nearby to merge with.")
	else if(!do_merge(M))
		to_chat(src, "You fail to merge with \the [M]...")

/mob/living/simple_mob/diona_nymph/proc/do_merge(var/mob/living/human/H)
	if(!istype(H) || !src || !(src.Adjacent(H)))
		return FALSE
	to_chat(H, "You feel your being twine with that of \the [src] as it merges with your biomass.")
	to_chat(src, "You feel your being twine with that of \the [H] as you merge with its biomass.")
	loc = H
	verbs += /mob/living/simple_mob/diona_nymph/proc/split
	verbs -= /mob/living/simple_mob/diona_nymph/proc/merge
	return TRUE

/mob/living/simple_mob/diona_nymph/proc/split()

	set category = "Abilities"
	set name = "Split from gestalt"
	set desc = "Split away from your gestalt as a lone nymph."

	if(stat == DEAD || paralysis || weakened || stunned || restrained())
		return

	if(!(ishuman(src.loc)))
		src.verbs -= /mob/living/simple_mob/diona_nymph/proc/split
		return

	var/mob/living/human/H = src.loc
	if(H.species?.name != SPECIES_DIONA)
		src.verbs -= /mob/living/simple_mob/diona_nymph/proc/split
		return

	to_chat(src.loc, "You feel a pang of loss as [src] splits away from your biomass.")
	to_chat(src, "You wiggle out of the depths of [src.loc]'s biomass and plop to the ground.")

	src.forceMove(get_turf(src))
	src.verbs -= /mob/living/simple_mob/diona_nymph/proc/split
	src.verbs += /mob/living/simple_mob/diona_nymph/proc/merge

/mob/living/simple_mob/diona_nymph/proc/confirm_evolution()
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

	src.visible_message("<font color='red'>[src] begins to shift and quiver, and erupts in a shower of shed bark as it splits into a tangle of nearly a dozen new dionaea.</font>","<font color='red'>You begin to shift and quiver, feeling your awareness splinter. All at once, we consume our stored nutrients to surge with growth, splitting into a tangle of at least a dozen new dionaea. We have attained our gestalt form.</font>")
	return SPECIES_DIONA

/mob/living/simple_mob/diona_nymph/verb/evolve()
	set name = "Evolve"
	set desc = "Evolve into your adult form."
	set category = "Abilities"

	if(stat != CONSCIOUS)
		return

	if(!adult_form)
		verbs -= /mob/living/simple_mob/diona_nymph/verb/evolve
		return

	if(amount_grown < max_grown)
		to_chat(src, "<font color='red'>You are not fully grown.</font>")
		return

	// confirm_evolution() handles choices and other specific requirements.
	var/new_species = confirm_evolution()
	if(!new_species || !adult_form )
		return

	var/mob/living/human/adult = new adult_form(get_turf(src))
	adult.set_species(new_species)

	transfer_languages(src, adult)

	if(src.faction != "neutral")
		adult.faction = src.faction

	if(mind)
		mind.transfer_to(adult)
		if (can_namepick_as_adult)
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

/mob/living/simple_mob/diona_nymph/proc/update_progression()
	if(amount_grown < max_grown)
		amount_grown++
