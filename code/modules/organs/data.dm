// Data written to each organ on creation for appearance and blood, this WAS originally done by sending the full dna datum.
// However sending the whole dna datum through Clone() is extremely expensive, and a memory leak if its a hardref instead.
/datum/organ_data
	VAR_PRIVATE/datum/weakref/species
	VAR_PRIVATE/species_name // Fallback
	// Species currently uses a cache system, if the species datum deletes, these are used as fallbacks for the last obtained state from the species datum
	// In the future, transforming species need to be refactored to not need this, as it's the only thing holding it back from proper isolation.
	VAR_PRIVATE/cached_species_vars = list()
	// Dna
	var/unique_enzymes
	var/b_type
	var/body_gender
	var/digitigrade
	// Colorsets
	var/skin_tone
	var/list/skin_color
	var/list/hair_color

/datum/organ_data/proc/setup_from_dna(var/datum/dna/dna)
	SHOULD_NOT_OVERRIDE(TRUE)
	// Prosfab uses default dna to get vars, lets respect that still
	var/self_clear = FALSE
	if(!dna)
		dna = new()
		dna.ResetUI()
		self_clear = TRUE

	// Setup cached dna data, as storing the entire DNA cloned is horrifically laggy
	unique_enzymes = dna.unique_enzymes
	body_gender = dna.GetUIState(DNA_UI_GENDER)
	if(!isnull(dna.GetUIValue(DNA_UI_SKIN_TONE)))
		skin_tone = dna.GetUIValue(DNA_UI_SKIN_TONE)
	skin_color = list(dna.GetUIValue(DNA_UI_SKIN_R), dna.GetUIValue(DNA_UI_SKIN_G), dna.GetUIValue(DNA_UI_SKIN_B))
	hair_color = list(dna.GetUIValue(DNA_UI_HAIR_R), dna.GetUIValue(DNA_UI_HAIR_G), dna.GetUIValue(DNA_UI_HAIR_B))
	digitigrade = dna.digitigrade

	// Cleanup for synthfab default dna
	if(self_clear)
		qdel(dna)

/datum/organ_data/proc/setup_from_species(var/datum/species/S) // This needs a full rework, but can't be done unless all of transformating species code is refactored
	SHOULD_NOT_OVERRIDE(TRUE)
	species = WEAKREF(S)
	species_name = S.name

/datum/organ_data/proc/get_species_datum()
	RETURN_TYPE(/datum/species)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)
	return species?.resolve()


// All accessed vars need to be cached during read.
// Get data from species, if this fails use cached data
/datum/organ_data/proc/get_species_name()
	SHOULD_NOT_OVERRIDE(TRUE)
	var/datum/species/SP = get_species_datum()
	if(SP)
		cached_species_vars["name"] = SP.name
	return cached_species_vars["name"]

/datum/organ_data/proc/get_species_race_key(var/owner)
	SHOULD_NOT_OVERRIDE(TRUE)
	var/datum/species/SP = get_species_datum()
	if(SP)
		cached_species_vars["race_key"] = SP.get_race_key(owner)
	return cached_species_vars["race_key"]

/datum/organ_data/proc/get_species_bodytype(var/mob/living/carbon/human/H)
	SHOULD_NOT_OVERRIDE(TRUE)
	var/datum/species/SP = get_species_datum()
	if(SP)
		cached_species_vars["bodytype"] = SP.get_bodytype(H)
	return cached_species_vars["bodytype"]

/datum/organ_data/proc/get_species_icobase(var/mob/living/carbon/human/H, var/get_deform)
	SHOULD_NOT_OVERRIDE(TRUE)
	var/datum/species/SP = get_species_datum()
	if(SP)
		cached_species_vars["icobase"] = SP.get_icobase(H,get_deform)
	return cached_species_vars["icobase"]

/datum/organ_data/proc/get_species_appearance_flags()
	SHOULD_NOT_OVERRIDE(TRUE)
	var/datum/species/SP = get_species_datum()
	if(SP)
		cached_species_vars["appearance_flags"] = SP.appearance_flags
	return cached_species_vars["appearance_flags"]

/datum/organ_data/proc/get_species_health_hud_intensity()
	SHOULD_NOT_OVERRIDE(TRUE)
	var/datum/species/SP = get_species_datum()
	if(SP)
		cached_species_vars["health_hud_intensity"] = SP.health_hud_intensity
	return cached_species_vars["health_hud_intensity"]

/datum/organ_data/proc/get_species_color_mult()
	SHOULD_NOT_OVERRIDE(TRUE)
	var/datum/species/SP = get_species_datum()
	if(SP)
		cached_species_vars["color_mult"] = SP.color_mult
	return cached_species_vars["color_mult"]

/datum/organ_data/proc/get_species_mob_size()
	SHOULD_NOT_OVERRIDE(TRUE)
	var/datum/species/SP = get_species_datum()
	if(SP)
		cached_species_vars["mob_size"] = SP.mob_size
	return cached_species_vars["mob_size"]

/datum/organ_data/proc/get_species_flesh_colour(var/owner)
	SHOULD_NOT_OVERRIDE(TRUE)
	var/datum/species/SP = get_species_datum()
	if(SP)
		cached_species_vars["flesh_colour"] = SP.get_flesh_colour(owner) || "#C80000"
	return cached_species_vars["flesh_colour"]

/datum/organ_data/proc/get_species_blood_colour(var/owner)
	SHOULD_NOT_OVERRIDE(TRUE)
	var/datum/species/SP = get_species_datum()
	if(SP)
		cached_species_vars["blood_colour"] = SP.get_blood_colour(owner) || "#C80000"
	return cached_species_vars["blood_colour"]

/datum/organ_data/proc/get_species_icodigi()
	SHOULD_NOT_OVERRIDE(TRUE)
	var/datum/species/SP = get_species_datum()
	if(SP)
		cached_species_vars["icodigi"] = SP.icodigi
	return cached_species_vars["icodigi"]
