#define ECO_MODIFIER 10

/* //Can we refractor to this??
// Appearance change flags
#define APPEARANCE_UPDATE_DNA 1
#define APPEARANCE_RACE	2|APPEARANCE_UPDATE_DNA
#define APPEARANCE_GENDER 4|APPEARANCE_UPDATE_DNA
#define APPEARANCE_SKIN 8
#define APPEARANCE_HAIR 16
#define APPEARANCE_HAIR_COLOR 32
#define APPEARANCE_SECONDARY_HAIR_COLOR 64
#define APPEARANCE_FACIAL_HAIR 128
#define APPEARANCE_FACIAL_HAIR_COLOR 256
#define APPEARANCE_SECONDARY_FACIAL_HAIR_COLOR 512
#define APPEARANCE_EYE_COLOR 1024
#define APPEARANCE_HEAD_ACCESSORY 2048
#define APPEARANCE_MARKINGS 4096
#define APPEARANCE_BODY_ACCESSORY 8192
#define APPEARANCE_ALT_HEAD 16384
#define APPEARANCE_ALL 32767*/
#define APPEARANCE_SECONDARY_HAIR_COLOR 0x200
#define APPEARANCE_SECONDARY_FACIAL_HAIR_COLOR 0x400
#define APPEARANCE_ALL_HAIR APPEARANCE_HAIR|APPEARANCE_HAIR_COLOR|APPEARANCE_SECONDARY_HAIR_COLOR|APPEARANCE_FACIAL_HAIR|APPEARANCE_FACIAL_HAIR_COLOR|APPEARANCE_SECONDARY_FACIAL_HAIR_COLOR
#define APPEARANCE_HEAD_ACCESSORY 0x800
#define APPEARANCE_MARKINGS 0x1600
#define APPEARANCE_BODY_ACCESSORY 0x3200
#define APPEARANCE_ALT_HEAD 0x6400
#define APPEARANCE_ALL_BODY APPEARANCE_ALL_HAIR|APPEARANCE_HEAD_ACCESSORY|APPEARANCE_MARKINGS|APPEARANCE_BODY_ACCESSORY|APPEARANCE_ALT_HEAD


//Mob attribute defaults.
#define DEFAULT_MARKING_STYLES list("head" = "None", "body" = "None", "tail" = "None") //Marking styles. Use instead of initial() for m_styles.
#define DEFAULT_MARKING_COLOURS list("head" = "#000000", "body" = "#000000", "tail" = "#000000") //Marking colours. Use instead of initial() for m_colours.

//Species Body Flags
#define FEET_CLAWS			1
#define FEET_PADDED			2
#define FEET_NOSLIP			4
#define HAS_HEAD_ACCESSORY	8
#define HAS_TAIL 			16
#define TAIL_OVERLAPPED		32
#define HAS_SKIN_TONE 		64
#define HAS_ICON_SKIN_TONE	128
#define HAS_SKIN_COLOR		256
#define HAS_HEAD_MARKINGS	512
#define HAS_BODY_MARKINGS	1024
#define HAS_TAIL_MARKINGS	2048
#define HAS_MARKINGS		HAS_HEAD_MARKINGS|HAS_BODY_MARKINGS|HAS_TAIL_MARKINGS
#define TAIL_WAGGING    	4096
#define NO_EYES				8192
#define HAS_FUR				16384
#define HAS_ALT_HEADS		32768

	//Head accessory styles
var/global/list/head_accessory_styles_list = list() //stores /datum/sprite_accessory/head_accessory indexed by name
	//Marking styles
var/global/list/marking_styles_list = list() //stores /datum/sprite_accessory/body_markings indexed by name


proc/random_head_accessory(species = "Human")
	var/ha_style = "None"
	var/list/valid_head_accessories = list()
	for(var/head_accessory in head_accessory_styles_list)
		var/datum/sprite_accessory/S = head_accessory_styles_list[head_accessory]

		if(!(species in S.species_allowed))
			continue
		valid_head_accessories += head_accessory

	if(valid_head_accessories.len)
		ha_style = pick(valid_head_accessories)

	return ha_style

proc/random_marking_style(var/location = "body", species = "Human", var/robot_head, var/body_accessory, var/alt_head)
	var/m_style = "None"
	var/list/valid_markings = list()
	for(var/marking in marking_styles_list)
		var/datum/sprite_accessory/body_markings/S = marking_styles_list[marking]
		if(S.name == "None")
			valid_markings += marking
			continue
		if(S.marking_location != location) //If the marking isn't for the location we desire, skip.
			continue
		if(!(species in S.species_allowed)) //If the user's head is not of a species the marking style allows, skip it. Otherwise, add it to the list.
			continue
		if(location == "tail")
			if(!body_accessory)
				if(S.tails_allowed)
					continue
			else
				if(!S.tails_allowed || !(body_accessory in S.tails_allowed))
					continue
		if(location == "head")
			var/datum/sprite_accessory/body_markings/head/M = marking_styles_list[S.name]
			if(species == "Machine")//If the user is a species that can have a robotic head...
				var/datum/robolimb/robohead = all_robolimbs[robot_head]
				if(!(S.models_allowed && (robohead.company in S.models_allowed))) //Make sure they don't get markings incompatible with their head.
					continue
			else if(alt_head && alt_head != "None") //If the user's got an alt head, validate markings for that head.
				if(!(alt_head in M.heads_allowed))
					continue
			else
				if(M.heads_allowed)
					continue
		valid_markings += marking

	if(valid_markings.len)
		m_style = pick(valid_markings)

	return m_style

proc/random_body_accessory(species = "Vulpkanin")
	var/body_accessory = null
	var/list/valid_body_accessories = list()
	for(var/B in body_accessory_by_name)
		var/datum/body_accessory/A = body_accessory_by_name[B]
		if(!istype(A))
			valid_body_accessories += "None" //The only null entry should be the "None" option.
			continue
		if(species in A.allowed_species) //If the user is not of a species the body accessory style allows, skip it. Otherwise, add it to the list.
			valid_body_accessories += B

	if(valid_body_accessories.len)
		body_accessory = pick(valid_body_accessories)

	return body_accessory

proc/GetOppositeDir(var/dir)
	switch(dir)
		if(NORTH)     return SOUTH
		if(SOUTH)     return NORTH
		if(EAST)      return WEST
		if(WEST)      return EAST
		if(SOUTHWEST) return NORTHEAST
		if(NORTHWEST) return SOUTHEAST
		if(NORTHEAST) return SOUTHWEST
		if(SOUTHEAST) return NORTHWEST
	return 0