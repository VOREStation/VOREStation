// Data written to each organ on creation for appearance and blood, this WAS originally done by sending the full dna datum.
// However sending the whole dna datum through Clone() is extremely expensive, and a memory leak if its a hardref instead.
/datum/organ_data
	var/unique_enzymes
	var/b_type
	var/body_gender
	var/digitigrade
	// Colorsets
	var/skin_tone
	var/list/skin_color
	var/list/hair_color

/datum/organ_data/setup_from_dna(var/datum/dna/dna)
	// Prosfab uses default dna to get vars, lets respect that still
	var/self_clear = FALSE
	if(!dna)
		dna = new()
		dna.ResetUI()
		self_clear = TRUE

	unique_enzymes = dna.unique_enzymes
	body_gender = dna.GetUIState(DNA_UI_GENDER)
	if(!isnull(dna.GetUIValue(DNA_UI_SKIN_TONE)))
		skin_tone = dna.GetUIValue(DNA_UI_SKIN_TONE)
	skin_color = list(dna.GetUIValue(DNA_UI_SKIN_R), dna.GetUIValue(DNA_UI_SKIN_G), dna.GetUIValue(DNA_UI_SKIN_B))
	hair_color = list(dna.GetUIValue(DNA_UI_HAIR_R),dna.GetUIValue(DNA_UI_HAIR_G),dna.GetUIValue(DNA_UI_HAIR_B))
	digitigrade = dna.digitigrade

	// Cleanup for synthfab default dna
	if(self_clear)
		qdel(dna)
