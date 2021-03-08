/**
* DNA 2: The Spaghetti Strikes Back
*
* @author N3X15 <nexisentertainment@gmail.com>
*/

// What each index means:
#define DNA_OFF_LOWERBOUND 0
#define DNA_OFF_UPPERBOUND 1
#define DNA_ON_LOWERBOUND  2
#define DNA_ON_UPPERBOUND  3

// Define block bounds (off-low,off-high,on-low,on-high)
// Used in setupgame.dm
#define DNA_DEFAULT_BOUNDS list(1,2049,2050,4095)
#define DNA_HARDER_BOUNDS  list(1,3049,3050,4095)
#define DNA_HARD_BOUNDS    list(1,3490,3500,4095)

// UI Indices (can change to mutblock style, if desired)
#define DNA_UI_HAIR_R      1
#define DNA_UI_HAIR_G      2
#define DNA_UI_HAIR_B      3
#define DNA_UI_BEARD_R     4
#define DNA_UI_BEARD_G     5
#define DNA_UI_BEARD_B     6
#define DNA_UI_SKIN_TONE   7
#define DNA_UI_SKIN_R      8
#define DNA_UI_SKIN_G      9
#define DNA_UI_SKIN_B      10
#define DNA_UI_EYES_R      11
#define DNA_UI_EYES_G      12
#define DNA_UI_EYES_B      13
#define DNA_UI_GENDER      14
#define DNA_UI_BEARD_STYLE 15
#define DNA_UI_HAIR_STYLE  16
#define DNA_UI_EAR_STYLE   17 // VOREStation snippet.
#define DNA_UI_TAIL_STYLE  18
#define DNA_UI_PLAYERSCALE 19
#define DNA_UI_TAIL_R      20
#define DNA_UI_TAIL_G      21
#define DNA_UI_TAIL_B      22
#define DNA_UI_TAIL2_R     23
#define DNA_UI_TAIL2_G     24
#define DNA_UI_TAIL2_B     25
#define DNA_UI_TAIL3_R     26
#define DNA_UI_TAIL3_G     27
#define DNA_UI_TAIL3_B     28
#define DNA_UI_EARS_R      29
#define DNA_UI_EARS_G      30
#define DNA_UI_EARS_B      31
#define DNA_UI_EARS2_R     32
#define DNA_UI_EARS2_G     33
#define DNA_UI_EARS2_B     34
#define DNA_UI_EARS3_R     35
#define DNA_UI_EARS3_G     36
#define DNA_UI_EARS3_B     37
#define DNA_UI_WING_STYLE  38
#define DNA_UI_WING_R      39
#define DNA_UI_WING_G      40
#define DNA_UI_WING_B      41
#define DNA_UI_WING2_R     42
#define DNA_UI_WING2_G     43
#define DNA_UI_WING2_B     44
#define DNA_UI_WING3_R     45
#define DNA_UI_WING3_G     46
#define DNA_UI_WING3_B     47 // VOREStation snippet end.
#define DNA_UI_LENGTH      47 // VOREStation Edit - Needs to match the highest number above.

#define DNA_SE_LENGTH 49 // VOREStation Edit (original was UI+11)
// For later:
//#define DNA_SE_LENGTH 50 // Was STRUCDNASIZE, size 27. 15 new blocks added = 42, plus room to grow.


// Defines which values mean "on" or "off".
//  This is to make some of the more OP superpowers a larger PITA to activate,
//  and to tell our new DNA datum which values to set in order to turn something
//  on or off.
var/global/list/dna_activity_bounds[DNA_SE_LENGTH]

// Used to determine what each block means (admin hax and species stuff on /vg/, mostly)
var/global/list/assigned_blocks[DNA_SE_LENGTH]

var/global/list/datum/dna/gene/dna_genes[0]

/////////////////
// GENE DEFINES
/////////////////
// Skip checking if it's already active.
// Used for genes that check for value rather than a binary on/off.
#define GENE_ALWAYS_ACTIVATE 1

// Skip checking if it's already active.
// Used for genes that check for value rather than a binary on/off.
#define GENE_ALWAYS_ACTIVATE 1

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
	var/custom_say
	var/custom_ask
	var/custom_whisper
	var/custom_exclaim
	// VOREStation

	// New stuff
	var/species = SPECIES_HUMAN
	var/list/body_markings = list()
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
	new_dna.base_species=base_species //VOREStation Edit
	new_dna.custom_species=custom_species //VOREStaton Edit
	new_dna.species_traits=species_traits.Copy() //VOREStation Edit
	new_dna.blood_color=blood_color //VOREStation Edit
	new_dna.custom_say=custom_say //VOREStaton Edit
	new_dna.custom_ask=custom_ask //VOREStaton Edit
	new_dna.custom_whisper=custom_whisper //VOREStaton Edit
	new_dna.custom_exclaim=custom_exclaim //VOREStaton Edit
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
	src.species_traits = character.species.traits.Copy()
	src.custom_say = character.custom_say
	src.custom_ask = character.custom_ask
	src.custom_whisper = character.custom_whisper
	src.custom_exclaim = character.custom_exclaim

	// +1 to account for the none-of-the-above possibility
	SetUIValueRange(DNA_UI_EAR_STYLE,	ear_style + 1,     ear_styles_list.len  + 1,  1)
	SetUIValueRange(DNA_UI_TAIL_STYLE,	tail_style + 1,    tail_styles_list.len + 1,  1)
	SetUIValueRange(DNA_UI_PLAYERSCALE,	size_multiplier,   player_sizes_list.len,     1)
	SetUIValueRange(DNA_UI_WING_STYLE,	wing_style + 1,    wing_styles_list.len + 1,  1)

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

	// VORE Station Edit End

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
	if(value == 0) //VOREStation Edit
		SetUIValue(block,0,defer)
		return
	if(value)
		SetUIValue(block,round(value * range),defer)

// Getter version of above.
/datum/dna/proc/GetUIValueRange(var/block,var/maxvalue)
	if (block<=0) return 0
	var/value = ((GetUIValue(block) / 4095) * maxvalue)
	return round(0.5 + value)

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
	var/value = ((GetSEValue(block) / 4095) * maxvalue)
	return round(0.5 + value)

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
