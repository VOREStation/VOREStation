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

	var/datum/changeling/changeling = changeling_power(0,0,100)
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

	if(HUSK in T.mutations) //Lings can always absorb other lings, unless someone beat them to it first.
		if(!T.mind.changeling || T.mind.changeling && T.mind.changeling.geneticpoints < 0)
			to_chat(src, span_warning("This creature's DNA is ruined beyond useability!"))
			return

	if(G.state != GRAB_KILL)
		to_chat(src, span_warning("We must have a tighter grip to absorb this creature."))
		return

	if(changeling.isabsorbing)
		to_chat(src, span_warning("We are already absorbing!"))
		return

	changeling.isabsorbing = 1
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
				add_attack_logs(src,T,"Absorbed (changeling)")
				var/obj/item/organ/external/affecting = T.get_organ(src.zone_sel.selecting)
				if(affecting.take_damage(39,0,1,0,"large organic needle"))
					T:UpdateDamageIcon()

		feedback_add_details("changeling_powers","A[stage]")
		if(!do_mob(src, T, 150) || G.state != GRAB_KILL)
			to_chat(src, span_warning("Our absorption of [T] has been interrupted!"))
			changeling.isabsorbing = 0
			return

	to_chat(src, span_notice("We have absorbed [T]!"))
	src.visible_message(span_danger("[src] sucks the fluids from [T]!"))
	to_chat(T, span_danger("You have been absorbed by the changeling!"))
	adjust_nutrition(T.nutrition)
	changeling.chem_charges += 10
	if(changeling.readapts <= 0)
		changeling.readapts = 0 //SANITYYYYYY
	changeling.readapts++
	if(changeling.readapts > changeling.max_readapts)
		changeling.readapts = changeling.max_readapts

	to_chat(src, span_notice("We can now re-adapt, reverting our evolution so that we may start anew, if needed."))

	var/datum/absorbed_dna/newDNA = new(T.real_name, T.dna, T.species.name, T.languages, T.identifying_gender, T.flavor_texts, T.modifiers)
	absorbDNA(newDNA)

	if(T.mind && T.mind.changeling)
		if(T.mind.changeling.absorbed_dna)
			for(var/datum/absorbed_dna/dna_data in T.mind.changeling.absorbed_dna)	//steal all their loot
				if(dna_data in changeling.absorbed_dna)
					continue
				absorbDNA(dna_data)
				changeling.absorbedcount++

			T.mind.changeling.absorbed_dna.len = 1

		// This is where lings get boosts from eating eachother
		if(T.mind.changeling.lingabsorbedcount)
			for(var/a = 1 to T.mind.changeling.lingabsorbedcount)
				changeling.lingabsorbedcount++
				changeling.geneticpoints += 4
				changeling.max_geneticpoints += 4

		to_chat(src, span_notice("We absorbed another changeling, and we grow stronger.  Our genomes increase."))

		T.mind.changeling.chem_charges = 0
		T.mind.changeling.geneticpoints = -1
		T.mind.changeling.max_geneticpoints = -1 //To prevent revival.
		T.mind.changeling.absorbedcount = 0
		T.mind.changeling.lingabsorbedcount = 0

	changeling.absorbedcount++
	changeling.isabsorbing = 0

	T.death(0)
	T.Drain()
	return 1
