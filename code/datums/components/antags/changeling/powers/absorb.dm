//Updated
/datum/power/changeling/absorb_dna
	name = "Absorb DNA"
	desc = "Permits us to syphon the DNA from a human. They become one with us, and we become stronger if they were of our kind."
	ability_icon_state = "ling_absorb_dna"
	genomecost = 0
	verbpath = /mob/living/proc/changeling_absorb_dna

//Absorbs the victim's DNA. Requires a strong grip on the victim.
//Doesn't cost anything as it's the most basic ability.
/mob/living/proc/changeling_absorb_dna()
	set category = "Changeling"
	set name = "Absorb DNA"

	var/datum/component/antag/changeling/changeling = changeling_power(0,0,100) //Our changeling power
	if(!changeling)	return

	var/obj/item/grab/G = src.get_active_hand()
	if(!istype(G))
		to_chat(src, span_warning("We must be grabbing a creature in our active hand to absorb them."))
		return

	var/mob/living/carbon/human/T = G.affecting
	if(!istype(T) || T.isSynthetic())
		to_chat(src, span_warning("\The [T] is not compatible with our biology."))
		return

	if(T.species.flags & (NO_DNA|NO_SLEEVE))
		to_chat(src, span_warning("We do not know how to parse this creature's DNA!"))
		return

	var/datum/component/antag/changeling/target_changeling = is_changeling(T) //If the target is a changeling

	if(HUSK in T.mutations) //Lings can always absorb other lings, unless someone beat them to it first.
		if(!target_changeling || target_changeling && target_changeling.geneticpoints < 0)
			to_chat(src, span_warning("This creature's DNA is ruined beyond useability!"))
			return

	if(G.state != GRAB_KILL)
		to_chat(src, span_warning("We must have a tighter grip to absorb this creature."))
		return

	if(changeling.isabsorbing)
		to_chat(src, span_warning("We are already absorbing!"))
		return

	changeling.isabsorbing = TRUE
	for(var/stage = 1, stage<=3, stage++)
		switch(stage)
			if(1)
				to_chat(src, span_notice("This creature is compatible. We must hold still..."))
			if(2)
				to_chat(src, span_notice("We extend a proboscis."))
				src.visible_message(span_warning("[src] extends a proboscis!"))
			if(3)
				to_chat(src, span_notice("We stab [T] with the proboscis."))
				src.visible_message(span_danger("[src] stabs [T] with the proboscis!"))
				to_chat(T, span_danger("You feel a sharp stabbing pain!"))
				var/obj/item/organ/external/affecting = T.get_organ(src.zone_sel.selecting)
				if(affecting.take_damage(39,0,1,0,"large organic needle"))
					T.UpdateDamageIcon()

		feedback_add_details("changeling_powers","A[stage]")
		if(!do_mob(src, T, 150) || G.state != GRAB_KILL)
			to_chat(src, span_warning("Our absorption of [T] has been interrupted!"))
			changeling.isabsorbing = FALSE
			return

	to_chat(src, span_notice("We have absorbed [T]!"))
	add_attack_logs(src,T,"Absorbed (changeling)")
	visible_message(span_danger("[src] sucks the fluids from [T]!"))
	to_chat(T, span_danger("You have been absorbed by the changeling!"))
	changeling_obtain_dna(T, changeling, target_changeling)

	changeling.isabsorbing = FALSE
	T.death(FALSE)
	T.Drain()
	return 1

///Proc that does the actual 'obtaining DNA' part for changelings. Has four arguments: Our victim, our changeling component, the target's changeling component, and if we drain the victim's nutrition or not.
/mob/living/proc/changeling_obtain_dna(mob/living/carbon/human/victim, datum/component/antag/changeling/changeling, datum/component/antag/changeling/target_changeling, drain = TRUE)
	if(!victim || !ishuman(victim)) //There MUST be a victim and it MUST be a human and NOT a monkey!
		return
	if(!target_changeling)
		target_changeling = is_changeling(victim) //Let's see if the victim is a changeling or not.
	if(!target_changeling && isMonkey(victim)) //No absorbing non-changeling monkeys.
		return

	//If we weren't fed a changeling component, we get it ourselves. If that fails, we see if the target is a changeling. If so, they get the DNA of the person predding them. Preyling!
	if(!changeling)
		changeling = is_changeling(src)
		if(!changeling && target_changeling) //Prey is a ling but owner is not.
			changeling_obtain_dna(src, target_changeling, drain = FALSE) //Flip the tables!~ Don't steal the pred's nutrition, though!
			return
		else if(!changeling) //Neither pred or prey are owner.
			return

	var/saved_dna = victim.dna.Clone()
	var/datum/absorbed_dna/newDNA = new(victim.real_name, saved_dna, victim.species.name, victim.languages, victim.identifying_gender, victim.flavor_texts, victim.modifiers)
	if(changeling.GetDNA(newDNA.name))
		qdel(newDNA)
		return //No double dipping! You already ate or absorbed them once this shift, glutton!
	absorbDNA(newDNA)
	if(drain)
		adjust_nutrition(victim.nutrition)
	changeling.chem_charges += 10
	if(changeling.readapts <= 0)
		changeling.readapts = 0 //SANITYYYYYY
	changeling.readapts++
	//Let's give them a genetic point for absorbing someone...Because honestly if you absorb people you SHOULD get stronger.
	changeling.max_geneticpoints++
	changeling.geneticpoints++
	if(changeling.readapts > changeling.max_readapts)
		changeling.readapts = changeling.max_readapts

	to_chat(src, span_notice("We can now re-adapt, reverting our evolution so that we may start anew, if needed."))

	if(victim.mind && target_changeling)
		if(target_changeling.absorbed_dna)
			for(var/datum/absorbed_dna/dna_data in target_changeling.absorbed_dna)	//steal all their loot
				if(dna_data in changeling.absorbed_dna)
					continue
				absorbDNA(dna_data)
				changeling.absorbedcount++

			target_changeling.absorbed_dna.len = 1

		// This is where lings get boosts from eating eachother
		if(target_changeling.lingabsorbedcount)
			for(var/a = 1 to target_changeling.lingabsorbedcount)
				changeling.lingabsorbedcount++
				changeling.geneticpoints += 4
				changeling.max_geneticpoints += 4

		to_chat(src, span_notice("We absorbed another changeling, and we grow stronger.  Our genomes increase."))

		target_changeling.chem_charges = 0
		target_changeling.geneticpoints = -1
		target_changeling.max_geneticpoints = -1 //To prevent revival.
		target_changeling.absorbedcount = 0
		target_changeling.lingabsorbedcount = 0
	changeling.absorbedcount++
