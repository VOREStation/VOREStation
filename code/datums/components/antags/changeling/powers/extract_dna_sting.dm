//Updated
/datum/power/changeling/extract_dna
	name = "Extract DNA"
	desc = "We stealthily sting a target and extract the DNA from them."
	helptext = "Will give you the DNA of your target, allowing you to transform into them. Does not count towards absorb objectives."
	ability_icon_state = "ling_sting_extract"
	genomecost = 0
	allowduringlesserform = TRUE
	verbpath = /mob/proc/changeling_extract_dna_sting

/mob/proc/changeling_extract_dna_sting()
	set category = "Changeling"
	set name = "Extract DNA Sting (40)"
	set desc="Stealthily sting a target to extract their DNA."

	var/datum/component/antag/changeling/changeling = null
	if(src.mind && changeling)
		changeling = changeling
	if(!changeling)
		return FALSE

	var/mob/living/carbon/human/T = changeling_sting(40, /mob/proc/changeling_extract_dna_sting)

	if(!T)
		return

	if(!istype(T) || T.isSynthetic())
		to_chat(src, span_warning("\The [T] is not compatible with our biology."))
		return FALSE

	if(T.species.flags & (NO_DNA|NO_SLEEVE))
		to_chat(src, span_warning("We do not know how to parse this creature's DNA!"))
		return FALSE

	if(HUSK in T.mutations)
		to_chat(src, span_warning("This creature's DNA is ruined beyond useability!"))
		return FALSE

	add_attack_logs(src,T,"DNA extraction sting (changeling)")

	var/saved_dna = T.dna.Clone() /// Prevent transforming bugginess.
	var/datum/absorbed_dna/newDNA = new(T.real_name, saved_dna, T.species.name, T.languages, T.identifying_gender, T.flavor_texts, T.modifiers)
	absorbDNA(newDNA)

	feedback_add_details("changeling_powers","ED")
	return TRUE
