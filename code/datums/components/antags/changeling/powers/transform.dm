/datum/power/changeling/transform
	name = "Transform"
	desc = "We take on the appearance and voice of one we have absorbed."
	ability_icon_state = "ling_transform"
	genomecost = 0
	verbpath = /mob/proc/changeling_transform

//Change our DNA to that of somebody we've absorbed.
/mob/proc/changeling_transform()
	set category = "Changeling"
	set name = "Transform (5)"

	var/datum/component/antag/changeling/changeling = changeling_power(5,1,0)
	if(!changeling)
		return

	if(!isturf(loc))
		to_chat(src, span_warning("Transforming here would be a bad idea."))
		return 0

	var/list/names = list()
	for(var/datum/absorbed_dna/DNA in changeling.absorbed_dna)
		names += "[DNA.name]"

	var/S = tgui_input_list(src, "Select the target DNA:", "Target DNA", names)
	if(!S)
		return

	var/datum/absorbed_dna/chosen_dna = changeling.GetDNA(S)
	if(!chosen_dna)
		return

	changeling.chem_charges -= 5
	src.visible_message(span_warning("[src] transforms!"))
	changeling.geneticdamage = 5

	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		var/newSpecies = chosen_dna.speciesName
		H.set_species(newSpecies)

	qdel_swap(src.dna, chosen_dna.dna.Clone())
	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		H.identifying_gender = chosen_dna.identifying_gender
		H.flavor_texts = chosen_dna.flavour_texts ? chosen_dna.flavour_texts.Copy() : null
	real_name = chosen_dna.name
	UpdateAppearance()
	domutcheck(src, null)
	UpdateAppearance()
	changeling_update_languages(changeling.absorbed_languages)
	if(chosen_dna.genMods)
		var/mob/living/carbon/human/self = src
		for(var/datum/modifier/mod in self.modifiers)
			self.modifiers.Remove(mod.type)

		for(var/datum/modifier/mod in chosen_dna.genMods)
			self.modifiers.Add(mod.type)
	regenerate_icons()

	feedback_add_details("changeling_powers","TR")
	return TRUE
