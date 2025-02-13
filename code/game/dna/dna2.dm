// What each index means:
#define DNA_OFF_LOWERBOUND 1
#define DNA_OFF_UPPERBOUND 2
#define DNA_ON_LOWERBOUND  3
#define DNA_ON_UPPERBOUND  4

//  Defines which values mean "on" or "off".
//  This is to make some of the more OP superpowers a larger PITA to activate,
//  and to tell our new DNA datum which values to set in order to turn something
//  on or off.
var/global/list/dna_activity_bounds[DNA_SE_LENGTH]

// Used to determine what each block means (admin hax and species stuff on /vg/, mostly)
var/global/list/assigned_blocks[DNA_SE_LENGTH]

// Traitgenes Genes accessible by global VV, and lists for good and bad mutations for quick randomized selection of traitgenes. Removed dna from gene's path
GLOBAL_LIST_EMPTY_TYPED(dna_genes, /datum/gene)
GLOBAL_LIST_EMPTY(trait_to_dna_genes) // Reverse lookup genes, use get_gene_from_trait(var/trait_path) to read this
GLOBAL_LIST_EMPTY_TYPED(dna_genes_good, /datum/gene/trait)
GLOBAL_LIST_EMPTY_TYPED(dna_genes_neutral, /datum/gene/trait)
GLOBAL_LIST_EMPTY_TYPED(dna_genes_bad, /datum/gene/trait)

/proc/get_gene_from_trait(var/trait_path) // ALWAYS USE THIS
	RETURN_TYPE(/datum/gene/trait)
	var/G = GLOB.trait_to_dna_genes[trait_path]
	#ifndef UNIT_TEST
	if(!G) // This SHOULD NOT HAPPEN, be sure any viruses or injectors that give trait paths are actually traitgenes.
		stack_trace("[trait_path] was used as a traitgene, without being flagged as one.")
	#endif
	return G

/datum/dna
	// READ-ONLY, GETS OVERWRITTEN
	// DO NOT FUCK WITH THESE OR BYOND WILL EAT YOUR FACE
	var/uni_identity="" // Encoded UI
	var/struc_enzymes="" // Encoded SE
	var/unique_enzymes="" // MD5 of player name

	// Internal dirtiness checks
	var/dirtyUI=0
	var/dirtySE=0

	// Okay to read, but you're an idiot if you do.
	// BLOCK = VALUE
	var/list/SE[DNA_SE_LENGTH]
	var/list/UI[DNA_UI_LENGTH]

	// From old dna.
	var/b_type = "A+"  // Should probably change to an integer => string map but I'm lazy.
	var/real_name          // Stores the real name of the person who originally got this dna datum. Used primarily for changelings,

	// VOREStation
	var/custom_species
	var/base_species = "Human"
	var/list/species_traits = list()
	var/blood_color = "#A10808"
	var/blood_reagents = "iron"
	var/scale_appearance = 0
	var/offset_override = 0
	var/synth_markings = 0
	var/custom_speech_bubble = "default"
	var/species_sounds = "None"
	var/gender_specific_species_sounds = FALSE
	var/species_sounds_male = "None"
	var/species_sounds_female = "None"
	var/grad_style = 0
	var/r_grad = 0
	var/g_grad = 0
	var/b_grad = 0
	var/custom_say
	var/custom_ask
	var/custom_whisper
	var/custom_exclaim
	var/list/custom_heat = list()
	var/list/custom_cold = list()
	var/digitigrade = 0 //0, Not FALSE, for future use as indicator for digitigrade types

	// New stuff
	var/species = SPECIES_HUMAN
	var/list/body_markings = list()
	var/list/body_markings_genetic = list()
	var/list/body_descriptors = null
	var/list/genetic_modifiers = list() // Modifiers with the MODIFIER_GENETIC flag are saved.  Note that only the type is saved, not an instance.

// Make a copy of this strand.
// USE THIS WHEN COPYING STUFF OR YOU'LL GET CORRUPTION!
/datum/dna/proc/Clone()
	var/datum/dna/new_dna = new()
	new_dna.unique_enzymes=unique_enzymes
	new_dna.b_type=b_type
	new_dna.real_name=real_name
	new_dna.species=species
	new_dna.body_markings=body_markings.Copy()
	new_dna.base_species=base_species
	new_dna.custom_species=custom_species
	new_dna.species_traits=species_traits.Copy()
	new_dna.blood_color=blood_color
	new_dna.blood_reagents=blood_reagents
	new_dna.scale_appearance = scale_appearance
	new_dna.offset_override = offset_override
	new_dna.synth_markings = synth_markings
	new_dna.custom_speech_bubble = custom_speech_bubble
	new_dna.species_sounds = species_sounds
	new_dna.gender_specific_species_sounds = gender_specific_species_sounds
	new_dna.species_sounds_male = species_sounds_male
	new_dna.species_sounds_female = species_sounds_female
	new_dna.grad_style = grad_style
	new_dna.r_grad = r_grad
	new_dna.g_grad = g_grad
	new_dna.b_grad = b_grad
	new_dna.custom_say=custom_say
	new_dna.custom_ask=custom_ask
	new_dna.custom_whisper=custom_whisper
	new_dna.custom_exclaim=custom_exclaim
	new_dna.custom_heat=custom_heat
	new_dna.custom_cold=custom_cold
	new_dna.digitigrade=src.digitigrade
	var/list/body_markings_genetic = (body_markings - body_marking_nopersist_list)
	new_dna.body_markings=body_markings_genetic.Copy()
	for(var/b=1;b<=DNA_SE_LENGTH;b++)
		new_dna.SE[b]=SE[b]
		if(b<=DNA_UI_LENGTH)
			new_dna.UI[b]=UI[b]
	new_dna.UpdateUI()
	new_dna.UpdateSE()
	return new_dna
///////////////////////////////////////
// UNIQUE IDENTITY
///////////////////////////////////////

// Create random UI.
/datum/dna/proc/ResetUI(var/defer=0)
	for(var/i=1,i<=DNA_UI_LENGTH,i++)
		switch(i)
			if(DNA_UI_SKIN_TONE)
				SetUIValueRange(DNA_UI_SKIN_TONE,rand(1,220),220,1) // Otherwise, it gets fucked
			else
				UI[i]=rand(0,4095)
	if(!defer)
		UpdateUI()

/datum/dna/proc/ResetUIFrom(var/mob/living/carbon/human/character)
	// INITIALIZE!
	ResetUI(1)
	// Hair
	// FIXME:  Species-specific defaults pls
	if(!character.h_style)
		character.h_style = "Skinhead"
	var/hair = hair_styles_list.Find(character.h_style)

	// Facial Hair
	if(!character.f_style)
		character.f_style = "Shaved"
	var/beard	= facial_hair_styles_list.Find(character.f_style)


	// VOREStation Edit Start

	// Demi Ears
	var/ear_style = 0
	if(character.ear_style)
		ear_style = ear_styles_list.Find(character.ear_style.type)

	var/ear_secondary_style = 0
	if(character.ear_secondary_style)
		ear_secondary_style = ear_styles_list.Find(character.ear_secondary_style.type)

	// Demi Tails
	var/tail_style = 0
	if(character.tail_style)
		tail_style = tail_styles_list.Find(character.tail_style.type)

	// Demi Wings
	var/wing_style = 0
	if(character.wing_style)
		wing_style = wing_styles_list.Find(character.wing_style.type)

	// Playerscale (This assumes list is sorted big->small)
	var/size_multiplier = player_sizes_list.len // If fail to find, take smallest
	for(var/N in player_sizes_list)
		if(character.size_multiplier >= player_sizes_list[N])
			size_multiplier = player_sizes_list.Find(N)
			break

	// Technically custom_species is not part of the UI, but this place avoids merge problems.
	src.custom_species = character.custom_species
	src.base_species = character.species.base_species
	src.blood_color = character.species.blood_color
	src.blood_reagents = character.species.blood_reagents
	src.scale_appearance = character.fuzzy
	src.offset_override = character.offset_override
	src.synth_markings = character.synth_markings
	src.custom_speech_bubble = character.custom_speech_bubble
	/* Currently not implemented on virgo
	src.species_sounds = character.species.species_sounds
	src.gender_specific_species_sounds = character.species.gender_specific_species_sounds
	src.species_sounds_male = character.species.species_sounds_male
	src.species_sounds_female = character.species.species_sounds_female
	*/
	src.grad_style = character.grad_style
	src.r_grad = character.r_grad
	src.g_grad = character.g_grad
	src.b_grad = character.b_grad
	src.species_traits = character.species.traits.Copy()
	src.custom_say = character.custom_say
	src.custom_ask = character.custom_ask
	src.custom_whisper = character.custom_whisper
	src.custom_exclaim = character.custom_exclaim
	src.custom_heat = character.custom_heat
	src.custom_cold = character.custom_cold
	src.digitigrade = character.digitigrade

	// +1 to account for the none-of-the-above possibility
	SetUIValueRange(DNA_UI_EAR_STYLE,             ear_style + 1,               ear_styles_list.len  + 1,  1)
	SetUIValueRange(DNA_UI_EAR_SECONDARY_STYLE,	  ear_secondary_style + 1,     ear_styles_list.len  + 1,  1)
	SetUIValueRange(DNA_UI_TAIL_STYLE,	          tail_style + 1,              tail_styles_list.len + 1,  1)
	SetUIValueRange(DNA_UI_PLAYERSCALE,           size_multiplier,             player_sizes_list.len,     1)
	SetUIValueRange(DNA_UI_WING_STYLE,            wing_style + 1,              wing_styles_list.len + 1,  1)

	SetUIValueRange(DNA_UI_TAIL_R,    character.r_tail,    255,    1)
	SetUIValueRange(DNA_UI_TAIL_G,    character.g_tail,    255,    1)
	SetUIValueRange(DNA_UI_TAIL_B,    character.b_tail,    255,    1)

	SetUIValueRange(DNA_UI_TAIL2_R,   character.r_tail2,   255,    1)
	SetUIValueRange(DNA_UI_TAIL2_G,   character.g_tail2,   255,    1)
	SetUIValueRange(DNA_UI_TAIL2_B,   character.b_tail2,   255,    1)

	SetUIValueRange(DNA_UI_TAIL3_R,   character.r_tail3,   255,    1)
	SetUIValueRange(DNA_UI_TAIL3_G,   character.g_tail3,   255,    1)
	SetUIValueRange(DNA_UI_TAIL3_B,   character.b_tail3,   255,    1)

	SetUIValueRange(DNA_UI_WING_R,    character.r_wing,    255,    1)
	SetUIValueRange(DNA_UI_WING_G,    character.g_wing,    255,    1)
	SetUIValueRange(DNA_UI_WING_B,    character.b_wing,    255,    1)

	SetUIValueRange(DNA_UI_WING2_R,    character.r_wing2,  255,    1)
	SetUIValueRange(DNA_UI_WING2_G,    character.g_wing2,  255,    1)
	SetUIValueRange(DNA_UI_WING2_B,    character.b_wing2,  255,    1)

	SetUIValueRange(DNA_UI_WING3_R,    character.r_wing3,  255,    1)
	SetUIValueRange(DNA_UI_WING3_G,    character.g_wing3,  255,    1)
	SetUIValueRange(DNA_UI_WING3_B,    character.b_wing3,  255,    1)

	SetUIValueRange(DNA_UI_EARS_R,    character.r_ears,    255,    1)
	SetUIValueRange(DNA_UI_EARS_G,    character.g_ears,    255,    1)
	SetUIValueRange(DNA_UI_EARS_B,    character.b_ears,    255,    1)

	SetUIValueRange(DNA_UI_EARS2_R,   character.r_ears2,   255,    1)
	SetUIValueRange(DNA_UI_EARS2_G,   character.g_ears2,   255,    1)
	SetUIValueRange(DNA_UI_EARS2_B,   character.b_ears2,   255,    1)

	SetUIValueRange(DNA_UI_EARS3_R,   character.r_ears3,   255,    1)
	SetUIValueRange(DNA_UI_EARS3_G,   character.g_ears3,   255,    1)
	SetUIValueRange(DNA_UI_EARS3_B,   character.b_ears3,   255,    1)

	for(var/channel in 1 to DNA_UI_EARS_SECONDARY_COLOR_CHANNEL_COUNT)
		var/offset = DNA_UI_EARS_SECONDARY_START + (channel - 1) * 3
		var/list/read_rgb = ReadRGB(LAZYACCESS(character.ear_secondary_colors, channel) || "#ffffff")
		var/red = read_rgb[1]
		var/green = read_rgb[2]
		var/blue = read_rgb[3]
		SetUIValueRange(offset, red, 255, 1)
		SetUIValueRange(offset + 1, green, 255, 1)
		SetUIValueRange(offset + 2, blue, 255, 1)

	SetUIValueRange(DNA_UI_HAIR_R,    character.r_hair,    255,    1)
	SetUIValueRange(DNA_UI_HAIR_G,    character.g_hair,    255,    1)
	SetUIValueRange(DNA_UI_HAIR_B,    character.b_hair,    255,    1)

	SetUIValueRange(DNA_UI_BEARD_R,   character.r_facial,  255,    1)
	SetUIValueRange(DNA_UI_BEARD_G,   character.g_facial,  255,    1)
	SetUIValueRange(DNA_UI_BEARD_B,   character.b_facial,  255,    1)

	SetUIValueRange(DNA_UI_EYES_R,    character.r_eyes,    255,    1)
	SetUIValueRange(DNA_UI_EYES_G,    character.g_eyes,    255,    1)
	SetUIValueRange(DNA_UI_EYES_B,    character.b_eyes,    255,    1)

	SetUIValueRange(DNA_UI_SKIN_R,    character.r_skin,    255,    1)
	SetUIValueRange(DNA_UI_SKIN_G,    character.g_skin,    255,    1)
	SetUIValueRange(DNA_UI_SKIN_B,    character.b_skin,    255,    1)

	SetUIValueRange(DNA_UI_SKIN_TONE, 35-character.s_tone, 220,    1) // Value can be negative.

	SetUIState(DNA_UI_GENDER,         character.gender!=MALE,        1)

	SetUIValueRange(DNA_UI_HAIR_STYLE,  hair,  hair_styles_list.len,       1)
	SetUIValueRange(DNA_UI_BEARD_STYLE, beard, facial_hair_styles_list.len,1)

	body_markings.Cut()
	for(var/obj/item/organ/external/E in character.organs)
		if(E.markings.len)
			body_markings[E.organ_tag] = E.markings.Copy()

	UpdateUI()

// Set a DNA UI block's raw value.
/datum/dna/proc/SetUIValue(var/block,var/value,var/defer=0)
	if (block<=0) return
	ASSERT(value>=0)
	ASSERT(value<=4095)
	UI[block]=value
	dirtyUI=1
	if(!defer)
		UpdateUI()

// Get a DNA UI block's raw value.
/datum/dna/proc/GetUIValue(var/block)
	if (block<=0) return 0
	return UI[block]

// Set a DNA UI block's value, given a value and a max possible value.
// Used in hair and facial styles (value being the index and maxvalue being the len of the hairstyle list)
/datum/dna/proc/SetUIValueRange(var/block,var/value,var/maxvalue,var/defer=0)
	if (block<=0) return
	ASSERT(maxvalue<=4095)
	var/range = (4095 / maxvalue)
	if(value!=null)
		SetUIValue(block,round(value * range),defer)

// Getter version of above.
/datum/dna/proc/GetUIValueRange(var/block,var/maxvalue)
	if (block<=0) return 0
	var/value = GetUIValue(block)
	return round(0.5 + (value / 4095) * maxvalue)

// Is the UI gene "on" or "off"?
// For UI, this is simply a check of if the value is > 2050.
/datum/dna/proc/GetUIState(var/block)
	if (block<=0) return
	return UI[block] > 2050


// Set UI gene "on" (1) or "off" (0)
/datum/dna/proc/SetUIState(var/block,var/on,var/defer=0)
	if (block<=0) return
	var/val
	if(on)
		val=rand(2050,4095)
	else
		val=rand(1,2049)
	SetUIValue(block,val,defer)

// Get a hex-encoded UI block.
/datum/dna/proc/GetUIBlock(var/block)
	return EncodeDNABlock(GetUIValue(block))

// Do not use this unless you absolutely have to.
// Set a block from a hex string.  This is inefficient.  If you can, use SetUIValue().
// Used in DNA modifiers.
/datum/dna/proc/SetUIBlock(var/block,var/value,var/defer=0)
	if (block<=0) return
	return SetUIValue(block,hex2num(value),defer)

// Get a sub-block from a block.
/datum/dna/proc/GetUISubBlock(var/block,var/subBlock)
	return copytext(GetUIBlock(block),subBlock,subBlock+1)

// Do not use this unless you absolutely have to.
// Set a block from a hex string.  This is inefficient.  If you can, use SetUIValue().
// Used in DNA modifiers.
/datum/dna/proc/SetUISubBlock(var/block,var/subBlock, var/newSubBlock, var/defer=0)
	if (block<=0) return
	var/oldBlock=GetUIBlock(block)
	var/newBlock=""
	for(var/i=1, i<=length(oldBlock), i++)
		if(i==subBlock)
			newBlock+=newSubBlock
		else
			newBlock+=copytext(oldBlock,i,i+1)
	SetUIBlock(block,newBlock,defer)

///////////////////////////////////////
// STRUCTURAL ENZYMES
///////////////////////////////////////

// "Zeroes out" all of the blocks.
/datum/dna/proc/ResetSE()
	for(var/i = 1, i <= DNA_SE_LENGTH, i++)
		SetSEValue(i,rand(1,1024),1)
	UpdateSE()

// Set a DNA SE block's raw value.
/datum/dna/proc/SetSEValue(var/block,var/value,var/defer=0)
	if (block<=0) return
	ASSERT(value>=0)
	ASSERT(value<=4095)
	SE[block]=value
	dirtySE=1
	if(!defer)
		UpdateSE()

// Get a DNA SE block's raw value.
/datum/dna/proc/GetSEValue(var/block)
	if (block<=0) return 0
	return SE[block]

// Set a DNA SE block's value, given a value and a max possible value.
// Might be used for species?
/datum/dna/proc/SetSEValueRange(var/block,var/value,var/maxvalue)
	if (block<=0) return
	ASSERT(maxvalue<=4095)
	var/range = round(4095 / maxvalue)
	if(value)
		SetSEValue(block, value * range - rand(1,range-1))

// Getter version of above.
/datum/dna/proc/GetSEValueRange(var/block,var/maxvalue)
	if (block<=0) return 0
	var/value = GetSEValue(block)
	return round(1 +(value / 4095)*maxvalue)

// Is the block "on" (1) or "off" (0)? (Un-assigned genes are always off.)
/datum/dna/proc/GetSEState(var/block)
	if (block<=0) return 0
	var/list/BOUNDS=GetDNABounds(block)
	var/value=GetSEValue(block)
	return (value > BOUNDS[DNA_ON_LOWERBOUND])

// Set a block "on" or "off".
/datum/dna/proc/SetSEState(var/block,var/on,var/defer=0)
	if (block<=0) return
	var/list/BOUNDS=GetDNABounds(block)
	var/val
	if(on)
		val=rand(BOUNDS[DNA_ON_LOWERBOUND],BOUNDS[DNA_ON_UPPERBOUND])
	else
		val=rand(1,BOUNDS[DNA_OFF_UPPERBOUND])
	SetSEValue(block,val,defer)

// Get hex-encoded SE block.
/datum/dna/proc/GetSEBlock(var/block)
	return EncodeDNABlock(GetSEValue(block))

// Get activation intensity, returns 0 to 1, you MUST check if the gene is active first! This is used for future expansion where genetraits can have multiple levels of activation/intensity
/datum/dna/proc/GetSEActivationIntensity(var/block)
	if (block<=0) return 0
	var/list/BOUNDS=GetDNABounds(block)
	var/value=GetSEValue(block)
	var/val = (value - BOUNDS[DNA_ON_LOWERBOUND]) / (BOUNDS[DNA_ON_UPPERBOUND] - BOUNDS[DNA_ON_LOWERBOUND])
	return val

// Gets the activation intensity index. ex: if a genetrait has 5 levels of activations, the gene will have 5 possible levels of activation. this is a future TODO.
/datum/dna/proc/GetSEActivationLevel(var/block,var/number_of_levels)
	var/raw_val = GetSEActivationIntensity(block)
	return round(raw_val * number_of_levels) // TODO - If this should be round/floor/ceil

// Do not use this unless you absolutely have to.
// Set a block from a hex string.  This is inefficient.  If you can, use SetUIValue().
// Used in DNA modifiers.
/datum/dna/proc/SetSEBlock(var/block,var/value,var/defer=0)
	if (block<=0) return
	var/nval=hex2num(value)
	//testing("SetSEBlock([block],[value],[defer]): [value] -> [nval]")
	return SetSEValue(block,nval,defer)

/datum/dna/proc/GetSESubBlock(var/block,var/subBlock)
	return copytext(GetSEBlock(block),subBlock,subBlock+1)

// Do not use this unless you absolutely have to.
// Set a sub-block from a hex character.  This is inefficient.  If you can, use SetUIValue().
// Used in DNA modifiers.
/datum/dna/proc/SetSESubBlock(var/block,var/subBlock, var/newSubBlock, var/defer=0)
	if (block<=0) return
	var/oldBlock=GetSEBlock(block)
	var/newBlock=""
	for(var/i=1, i<=length(oldBlock), i++)
		if(i==subBlock)
			newBlock+=newSubBlock
		else
			newBlock+=copytext(oldBlock,i,i+1)
	//testing("SetSESubBlock([block],[subBlock],[newSubBlock],[defer]): [oldBlock] -> [newBlock]")
	SetSEBlock(block,newBlock,defer)


/proc/EncodeDNABlock(var/value)
	return num2hex(value, 3)

/datum/dna/proc/UpdateUI()
	src.uni_identity=""
	for(var/block in UI)
		uni_identity += EncodeDNABlock(block)
	//testing("New UI: [uni_identity]")
	dirtyUI=0

/datum/dna/proc/UpdateSE()
	//var/oldse=struc_enzymes
	struc_enzymes=""
	for(var/block in SE)
		struc_enzymes += EncodeDNABlock(block)
	//testing("Old SE: [oldse]")
	//testing("New SE: [struc_enzymes]")
	dirtySE=0

// BACK-COMPAT!
//  Just checks our character has all the crap it needs.
/datum/dna/proc/check_integrity(var/mob/living/carbon/human/character)
	if(character)
		if(UI.len != DNA_UI_LENGTH)
			ResetUIFrom(character)

		if(length(struc_enzymes)!= 3*DNA_SE_LENGTH)
			ResetSE()

		if(length(unique_enzymes) != 32)
			unique_enzymes = md5(character.real_name)
	else
		if(length(uni_identity) != 3*DNA_UI_LENGTH)
			uni_identity = "00600200A00E0110148FC01300B0095BD7FD3F4"
		if(length(struc_enzymes)!= 3*DNA_SE_LENGTH)
			struc_enzymes = "43359156756131E13763334D1C369012032164D4FE4CD61544B6C03F251B6C60A42821D26BA3B0FD6"

// BACK-COMPAT!
//  Initial DNA setup.  I'm kind of wondering why the hell this doesn't just call the above.
/datum/dna/proc/ready_dna(mob/living/carbon/human/character)
	ResetUIFrom(character)

	ResetSE()

	unique_enzymes = md5(character.real_name)
	reg_dna[unique_enzymes] = character.real_name

#undef DNA_OFF_LOWERBOUND
#undef DNA_OFF_UPPERBOUND
#undef DNA_ON_LOWERBOUND
#undef DNA_ON_UPPERBOUND
