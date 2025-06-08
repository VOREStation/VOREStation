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
	var/b_type = DEFAULT_BLOOD_TYPE  // Should probably change to an integer => string map but I'm lazy.
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
	var/custom_say
	var/custom_ask
	var/custom_whisper
	var/custom_exclaim
	var/list/custom_heat = list()
	var/list/custom_cold = list()
	var/digitigrade = 0 //0, Not FALSE, for future use as indicator for digitigrade types
	var/custom_footstep = FOOTSTEP_MOB_SHOE

	// New stuff
	var/species = SPECIES_HUMAN
	var/list/body_markings = list()
	var/list/genetic_modifiers = list() // Modifiers with the MODIFIER_GENETIC flag are saved.  Note that only the type is saved, not an instance.

// Make a copy of this strand.
// USE THIS WHEN COPYING STUFF OR YOU'LL GET CORRUPTION!
// Can you imagine, this used to be done manually, var by var?
/datum/dna/proc/Clone()
	var/datum/dna/new_dna = new()
	for(var/A in vars)
		switch(A)
			if(BLACKLISTED_COPY_VARS)
				continue
			if("dirtyUI")
				dirtyUI=1
				continue
			if("dirtySE")
				dirtySE=1
				continue
			if("body_markings")
				var/list/body_markings_genetic = body_markings.Copy()
				body_markings_genetic -= body_marking_nopersist_list
				new_dna.vars[A] = body_markings_genetic
				continue
		if(islist(vars[A]))
			var/list/L = vars[A]
			new_dna.vars[A] = L.Copy()
			continue
		new_dna.vars[A] = vars[A]
	// Finish up by updating enzymes/identity from our UI/SEs
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

/**
 * Beginning of mob to dna, and dna to mob transfer procs.
 * Ensure that ResetUIFrom() and ApplyToMob() mirror each other. All vars should be read FROM the mob, and written back to it!
 * ALL dna logic for reading from the mob, storing the dna data, and writing that dna data back to the mob should be here, and ONLY here.
 */
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

	// Hairgrad
	var/grad_style = 0
	if(character.grad_style)
		grad_style = GLOB.hair_gradients.Find(character.grad_style)

	// Playerscale (This assumes list is sorted big->small)
	var/size_multiplier = GLOB.player_sizes_list.len // If fail to find, take smallest
	for(var/N in GLOB.player_sizes_list)
		if(character.size_multiplier >= GLOB.player_sizes_list[N])
			size_multiplier = GLOB.player_sizes_list.Find(N)
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
	src.species_sounds = character.species.species_sounds
	src.gender_specific_species_sounds = character.species.gender_specific_species_sounds
	src.species_sounds_male = character.species.species_sounds_male
	src.species_sounds_female = character.species.species_sounds_female
	src.species_traits = character.species.traits.Copy()
	src.custom_say = character.custom_say
	src.custom_ask = character.custom_ask
	src.custom_whisper = character.custom_whisper
	src.custom_exclaim = character.custom_exclaim
	src.custom_heat = character.custom_heat
	src.custom_cold = character.custom_cold
	src.digitigrade = character.digitigrade
	src.custom_footstep = character.custom_footstep

	// +1 to account for the none-of-the-above possibility
	SetUIValueRange(DNA_UI_EAR_STYLE,             ear_style + 1,               ear_styles_list.len  + 1,  1)
	SetUIValueRange(DNA_UI_EAR_SECONDARY_STYLE,	  ear_secondary_style + 1,     ear_styles_list.len  + 1,  1)
	SetUIValueRange(DNA_UI_TAIL_STYLE,	          tail_style + 1,              tail_styles_list.len + 1,  1)
	SetUIValueRange(DNA_UI_PLAYERSCALE,           size_multiplier,             GLOB.player_sizes_list.len,     1)
	SetUIValueRange(DNA_UI_WING_STYLE,            wing_style + 1,              wing_styles_list.len + 1,  1)
	SetUIValueRange(DNA_UI_GRAD_STYLE,            grad_style,			  	   GLOB.hair_gradients.len,  1)

	SetUIValueRange(DNA_UI_TAIL_R,    character.r_tail,    255,    1)
	SetUIValueRange(DNA_UI_TAIL_G,    character.g_tail,    255,    1)
	SetUIValueRange(DNA_UI_TAIL_B,    character.b_tail,    255,    1)

	SetUIValueRange(DNA_UI_TAIL2_R,   character.r_tail2,   255,    1)
	SetUIValueRange(DNA_UI_TAIL2_G,   character.g_tail2,   255,    1)
	SetUIValueRange(DNA_UI_TAIL2_B,   character.b_tail2,   255,    1)

	SetUIValueRange(DNA_UI_TAIL3_R,   character.r_tail3,   255,    1)
	SetUIValueRange(DNA_UI_TAIL3_G,   character.g_tail3,   255,    1)
	SetUIValueRange(DNA_UI_TAIL3_B,   character.b_tail3,   255,    1)
	SetUIValueRange(DNA_UI_TAIL_ALPHA,character.a_tail,    255,    1)

	SetUIValueRange(DNA_UI_WING_R,    character.r_wing,    255,    1)
	SetUIValueRange(DNA_UI_WING_G,    character.g_wing,    255,    1)
	SetUIValueRange(DNA_UI_WING_B,    character.b_wing,    255,    1)

	SetUIValueRange(DNA_UI_WING2_R,    character.r_wing2,  255,    1)
	SetUIValueRange(DNA_UI_WING2_G,    character.g_wing2,  255,    1)
	SetUIValueRange(DNA_UI_WING2_B,    character.b_wing2,  255,    1)

	SetUIValueRange(DNA_UI_WING3_R,    character.r_wing3,  255,    1)
	SetUIValueRange(DNA_UI_WING3_G,    character.g_wing3,  255,    1)
	SetUIValueRange(DNA_UI_WING3_B,    character.b_wing3,  255,    1)
	SetUIValueRange(DNA_UI_WING_ALPHA, character.a_wing,   255,    1)

	SetUIValueRange(DNA_UI_EARS_R,    character.r_ears,    255,    1)
	SetUIValueRange(DNA_UI_EARS_G,    character.g_ears,    255,    1)
	SetUIValueRange(DNA_UI_EARS_B,    character.b_ears,    255,    1)

	SetUIValueRange(DNA_UI_EARS2_R,   character.r_ears2,   255,    1)
	SetUIValueRange(DNA_UI_EARS2_G,   character.g_ears2,   255,    1)
	SetUIValueRange(DNA_UI_EARS2_B,   character.b_ears2,   255,    1)

	SetUIValueRange(DNA_UI_EARS3_R,   character.r_ears3,   255,    1)
	SetUIValueRange(DNA_UI_EARS3_G,   character.g_ears3,   255,    1)
	SetUIValueRange(DNA_UI_EARS3_B,   character.b_ears3,   255,    1)
	SetUIValueRange(DNA_UI_EARS_ALPHA,character.a_ears,    255,    1)

	SetUIValueRange(DNA_UI_GRAD_R,    character.r_grad,    255,    1)
	SetUIValueRange(DNA_UI_GRAD_G,    character.g_grad,    255,    1)
	SetUIValueRange(DNA_UI_GRAD_B,    character.b_grad,    255,    1)

	for(var/channel in 1 to DNA_UI_EARS_SECONDARY_COLOR_CHANNEL_COUNT)
		var/offset = DNA_UI_EARS_SECONDARY_START + (channel - 1) * 3
		var/list/read_rgb = ReadRGB(LAZYACCESS(character.ear_secondary_colors, channel) || "#ffffff")
		var/red = read_rgb[1]
		var/green = read_rgb[2]
		var/blue = read_rgb[3]
		SetUIValueRange(offset, red, 255, 1)
		SetUIValueRange(offset + 1, green, 255, 1)
		SetUIValueRange(offset + 2, blue, 255, 1)
	SetUIValueRange(DNA_UI_EARS_SECONDARY_ALPHA, character.a_ears2, 255, 1)

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

/datum/dna/proc/ApplyToMob(var/mob/living/carbon/human/H)
	////////////////////////////////////////////////////////////////////////////////
	// Apply UIs to character
	//Hair color
	H.r_hair   = GetUIValueRange(DNA_UI_HAIR_R,    255)
	H.g_hair   = GetUIValueRange(DNA_UI_HAIR_G,    255)
	H.b_hair   = GetUIValueRange(DNA_UI_HAIR_B,    255)

	//Facial hair color
	H.r_facial = GetUIValueRange(DNA_UI_BEARD_R,   255)
	H.g_facial = GetUIValueRange(DNA_UI_BEARD_G,   255)
	H.b_facial = GetUIValueRange(DNA_UI_BEARD_B,   255)

	//Skin color (Tone for humans is seperate)
	H.r_skin   = GetUIValueRange(DNA_UI_SKIN_R,    255)
	H.g_skin   = GetUIValueRange(DNA_UI_SKIN_G,    255)
	H.b_skin   = GetUIValueRange(DNA_UI_SKIN_B,    255)

	H.s_tone   = 35 - GetUIValueRange(DNA_UI_SKIN_TONE, 220) // Value can be negative.

	//Eye color
	H.r_eyes   = GetUIValueRange(DNA_UI_EYES_R,    255)
	H.g_eyes   = GetUIValueRange(DNA_UI_EYES_G,    255)
	H.b_eyes   = GetUIValueRange(DNA_UI_EYES_B,    255)
	H.update_eyes()

	//Hair gradient color
	H.r_grad   = GetUIValueRange(DNA_UI_GRAD_R,    255)
	H.g_grad   = GetUIValueRange(DNA_UI_GRAD_G,    255)
	H.b_grad   = GetUIValueRange(DNA_UI_GRAD_B,    255)

	//Sex... Needs future support for properly handling things other then just male/female. UIs have the capability to do so!
	if(H.gender != NEUTER)
		if (GetUIState(DNA_UI_GENDER))
			H.gender = FEMALE
		else
			H.gender = MALE

	//Body markings
	for(var/tag in body_markings)
		var/obj/item/organ/external/E = H.organs_by_name[tag]
		if(E)
			var/list/marklist = body_markings[tag]
			E.markings = marklist.Copy()

	//Hair style
	var/hair = GetUIValueRange(DNA_UI_HAIR_STYLE,hair_styles_list.len)
	if((0 < hair) && (hair <= hair_styles_list.len))
		H.h_style = hair_styles_list[hair]

	//Facial Hair
	var/beard = GetUIValueRange(DNA_UI_BEARD_STYLE,facial_hair_styles_list.len)
	if((0 < beard) && (beard <= facial_hair_styles_list.len))
		H.f_style = facial_hair_styles_list[beard]

	// Ears
	var/ears = GetUIValueRange(DNA_UI_EAR_STYLE, ear_styles_list.len + 1) - 1
	if(ears < 1)
		H.ear_style = null
	else if((0 < ears) && (ears <= ear_styles_list.len))
		H.ear_style = ear_styles_list[ear_styles_list[ears]]
	var/ears_secondary = GetUIValueRange(DNA_UI_EAR_SECONDARY_STYLE, ear_styles_list.len + 1) - 1
	if(ears_secondary < 1)
		H.ear_secondary_style = null
	else if((0 < ears_secondary) && (ears_secondary <= ear_styles_list.len))
		H.ear_secondary_style = ear_styles_list[ear_styles_list[ears_secondary]]

	// Ear Color
	H.r_ears  = GetUIValueRange(DNA_UI_EARS_R,    255)
	H.g_ears  = GetUIValueRange(DNA_UI_EARS_G,    255)
	H.b_ears  = GetUIValueRange(DNA_UI_EARS_B, 	  255)
	H.r_ears2 = GetUIValueRange(DNA_UI_EARS2_R,   255)
	H.g_ears2 = GetUIValueRange(DNA_UI_EARS2_G,   255)
	H.b_ears2 = GetUIValueRange(DNA_UI_EARS2_B,	  255)
	H.r_ears3 = GetUIValueRange(DNA_UI_EARS3_R,   255)
	H.g_ears3 = GetUIValueRange(DNA_UI_EARS3_G,   255)
	H.b_ears3 = GetUIValueRange(DNA_UI_EARS3_B,	  255)
	H.a_ears = GetUIValueRange(DNA_UI_EARS_ALPHA, 255)
	H.a_ears2 = GetUIValueRange(DNA_UI_EARS_SECONDARY_ALPHA, 255)

	LAZYINITLIST(H.ear_secondary_colors)
	H.ear_secondary_colors.len = max(length(H.ear_secondary_colors), DNA_UI_EARS_SECONDARY_COLOR_CHANNEL_COUNT)
	for(var/channel in 1 to DNA_UI_EARS_SECONDARY_COLOR_CHANNEL_COUNT)
		var/offset = DNA_UI_EARS_SECONDARY_START + (channel - 1) * 3
		H.ear_secondary_colors[channel] = rgb(
			GetUIValueRange(offset, 255),
			GetUIValueRange(offset + 1, 255),
			GetUIValueRange(offset + 2, 255),
		)

	//Tail
	var/tail = GetUIValueRange(DNA_UI_TAIL_STYLE, tail_styles_list.len + 1) - 1
	if(tail < 1)
		H.tail_style = null
	else if((0 < tail) && (tail <= tail_styles_list.len))
		H.tail_style = tail_styles_list[tail_styles_list[tail]]

	//Wing
	var/wing = GetUIValueRange(DNA_UI_WING_STYLE, wing_styles_list.len + 1) - 1
	if(wing < 1)
		H.wing_style = null
	else if((0 < wing) && (wing <= wing_styles_list.len))
		H.wing_style = wing_styles_list[wing_styles_list[wing]]

	//Wing Color
	H.r_wing   = GetUIValueRange(DNA_UI_WING_R,     255)
	H.g_wing   = GetUIValueRange(DNA_UI_WING_G,     255)
	H.b_wing   = GetUIValueRange(DNA_UI_WING_B,     255)
	H.r_wing2  = GetUIValueRange(DNA_UI_WING2_R,    255)
	H.g_wing2  = GetUIValueRange(DNA_UI_WING2_G,    255)
	H.b_wing2  = GetUIValueRange(DNA_UI_WING2_B,    255)
	H.r_wing3  = GetUIValueRange(DNA_UI_WING3_R,    255)
	H.g_wing3  = GetUIValueRange(DNA_UI_WING3_G,    255)
	H.b_wing3  = GetUIValueRange(DNA_UI_WING3_B,    255)
	H.a_wing = GetUIValueRange(DNA_UI_WING_ALPHA,	255)

	// Playerscale
	var/size = GetUIValueRange(DNA_UI_PLAYERSCALE, GLOB.player_sizes_list.len)
	if((0 < size) && (size <= GLOB.player_sizes_list.len))
		H.resize(GLOB.player_sizes_list[GLOB.player_sizes_list[size]], TRUE, ignore_prefs = TRUE)

	// Tail/Taur Color
	H.r_tail   = GetUIValueRange(DNA_UI_TAIL_R,    255)
	H.g_tail   = GetUIValueRange(DNA_UI_TAIL_G,    255)
	H.b_tail   = GetUIValueRange(DNA_UI_TAIL_B,    255)
	H.r_tail2  = GetUIValueRange(DNA_UI_TAIL2_R,   255)
	H.g_tail2  = GetUIValueRange(DNA_UI_TAIL2_G,   255)
	H.b_tail2  = GetUIValueRange(DNA_UI_TAIL2_B,   255)
	H.r_tail3  = GetUIValueRange(DNA_UI_TAIL3_R,   255)
	H.g_tail3  = GetUIValueRange(DNA_UI_TAIL3_G,   255)
	H.b_tail3  = GetUIValueRange(DNA_UI_TAIL3_B,   255)
	H.a_tail = GetUIValueRange(DNA_UI_TAIL_ALPHA,  255)

	// Hair gradiant
	var/grad = GetUIValueRange(DNA_UI_GRAD_STYLE,GLOB.hair_gradients.len)
	if((0 < grad) && (grad <= GLOB.hair_gradients.len))
		H.grad_style = GLOB.hair_gradients[grad]

	////////////////////////////////////////////////////////////////////////////////
	// Custom species and other cosmetic vars
	H.custom_species = custom_species
	H.custom_say = custom_say
	H.custom_ask = custom_ask
	H.custom_whisper = custom_whisper
	H.custom_exclaim = custom_exclaim
	H.custom_speech_bubble = custom_speech_bubble
	H.custom_heat = custom_heat
	H.custom_cold = custom_cold
	H.custom_footstep = custom_footstep
	H.digitigrade = digitigrade

	// If synths have character markings
	H.synth_markings = synth_markings

	// Scaling style
	H.fuzzy = scale_appearance
	H.offset_override = offset_override

	////////////////////////////////////////////////////////////////////////////////
	// Get a copy of the species datum to edit for ourselves
	// anything that sets stuff in species MUST be done beyond here!
	H.species.produceCopy(species_traits, H, base_species, FALSE) // Traitgenes edit - reset_dna flag required, or genes get reset on resleeve

	// Update species blood with our blood color from dna!
	H.species.blood_reagents = blood_reagents
	H.species.blood_color = blood_color
	H.species.species_sounds = species_sounds
	H.species.gender_specific_species_sounds = gender_specific_species_sounds
	H.species.species_sounds_male = species_sounds_male
	H.species.species_sounds_female = species_sounds_female
/**
 * End of mob to dna, and dna to mob transfer procs.
 */

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

#undef DNA_OFF_LOWERBOUND
#undef DNA_OFF_UPPERBOUND
#undef DNA_ON_LOWERBOUND
#undef DNA_ON_UPPERBOUND
