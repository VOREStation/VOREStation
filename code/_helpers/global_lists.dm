//Since it didn't really belong in any other category, I'm putting this here
//This is for procs to replace all the goddamn 'in world's that are chilling around the code

var/global/list/player_list = list()				//List of all mobs **with clients attached**. Excludes /mob/new_player
var/global/list/mob_list = list()					//List of all mobs, including clientless
var/global/list/human_mob_list = list()				//List of all human mobs and sub-types, including clientless
var/global/list/silicon_mob_list = list()			//List of all silicon mobs, including clientless
var/global/list/ai_list = list()					//List of all AIs, including clientless
var/global/list/living_mob_list = list()			//List of all alive mobs, including clientless. Excludes /mob/new_player
var/global/list/dead_mob_list = list()				//List of all dead mobs, including clientless. Excludes /mob/new_player
var/global/list/observer_mob_list = list()			//List of all /mob/observer/dead, including clientless.
var/global/list/listening_objects = list()			//List of all objects which care about receiving messages (communicators, radios, etc)
var/global/list/cleanbot_reserved_turfs = list()	//List of all turfs currently targeted by some cleanbot

var/global/list/cable_list = list()					//Index for all cables, so that powernets don't have to look through the entire world all the time
var/global/list/landmarks_list = list()				//list of all landmarks created
var/global/list/event_triggers = list()				//Associative list of creator_ckey:list(landmark references) for event triggers
var/global/list/surgery_steps = list()				//list of all surgery steps  |BS12
var/global/list/side_effects = list()				//list of all medical sideeffects types by thier names |BS12
var/global/list/mechas_list = list()				//list of all mechs. Used by hostile mobs target tracking.
var/global/list/joblist = list()					//list of all jobstypes, minus borg and AI

#define all_genders_define_list list(MALE,FEMALE,PLURAL,NEUTER,HERM) //VOREStaton Edit
#define all_genders_text_list list("Male","Female","Plural","Neuter","Herm") //VOREStation Edit
#define pronoun_set_to_genders list(\
			"He/Him" = MALE,\
			"She/Her" = FEMALE,\
			"It/Its" = NEUTER,\
			"They/Them" = PLURAL,\
			"Shi/Hir" = HERM\
			)
#define genders_to_pronoun_set list(\
			MALE = "He/Him",\
			FEMALE = "She/Her",\
			NEUTER = "It/Its",\
			PLURAL = "They/Them",\
			HERM = "Shi/Hir"\
			)

var/list/mannequins_

// Times that players are allowed to respawn ("ckey" = world.time)
GLOBAL_LIST_EMPTY(respawn_timers)

// Holomaps
var/global/list/holomap_markers = list()
var/global/list/mapping_units = list()
var/global/list/mapping_beacons = list()

//Preferences stuff
	//Hairstyles
var/global/list/hair_styles_list = list()			//stores /datum/sprite_accessory/hair indexed by name
var/global/list/hair_styles_male_list = list()
var/global/list/hair_styles_female_list = list()
var/global/list/facial_hair_styles_list = list()	//stores /datum/sprite_accessory/facial_hair indexed by name
var/global/list/facial_hair_styles_male_list = list()
var/global/list/facial_hair_styles_female_list = list()
var/global/list/skin_styles_female_list = list()		//unused
var/global/list/body_marking_styles_list = list()		//stores /datum/sprite_accessory/marking indexed by name
var/global/list/body_marking_nopersist_list = list()	// Body marking styles, minus non-genetic markings and augments
var/global/list/ear_styles_list = list()	// Stores /datum/sprite_accessory/ears indexed by type
var/global/list/tail_styles_list = list()	// Stores /datum/sprite_accessory/tail indexed by type
var/global/list/wing_styles_list = list()	// Stores /datum/sprite_accessory/wing indexed by type

GLOBAL_LIST_INIT(custom_species_bases, new) // Species that can be used for a Custom Species icon base
	//Underwear
var/datum/category_collection/underwear/global_underwear = new()

	//Customizables
GLOBAL_LIST_INIT(headsetlist, list("Standard","Bowman","Earbud"))
var/global/list/backbaglist = list("Nothing", "Backpack", "Satchel", "Satchel Alt", "Messenger Bag", "Sports Bag", "Strapless Satchel")
var/global/list/pdachoicelist = list("Default", "Slim", "Old", "Rugged", "Holographic", "Wrist-Bound","Slider", "Vintage")
var/global/list/exclude_jobs = list(/datum/job/ai,/datum/job/cyborg)

// Visual nets
var/list/datum/visualnet/visual_nets = list()
var/datum/visualnet/camera/cameranet = new()
var/datum/visualnet/cult/cultnet = new()
var/datum/visualnet/ghost/ghostnet = new()

// Runes
var/global/list/rune_list = new()
var/global/list/escape_list = list()
var/global/list/endgame_exits = list()
var/global/list/endgame_safespawns = list()

var/global/list/syndicate_access = list(access_maint_tunnels, access_syndicate, access_external_airlocks)

// Ores (for mining)
GLOBAL_LIST_EMPTY(ore_data)
GLOBAL_LIST_EMPTY(alloy_data)

// Strings which corraspond to bodypart covering flags, useful for outputting what something covers.
var/global/list/string_part_flags = list(
	"head" = HEAD,
	"face" = FACE,
	"eyes" = EYES,
	"upper body" = UPPER_TORSO,
	"lower body" = LOWER_TORSO,
	"legs" = LEGS,
	"feet" = FEET,
	"arms" = ARMS,
	"hands" = HANDS
)

// Strings which corraspond to slot flags, useful for outputting what slot something is.
var/global/list/string_slot_flags = list(
	"back" = SLOT_BACK,
	"face" = SLOT_MASK,
	"waist" = SLOT_BELT,
	"ID slot" = SLOT_ID,
	"ears" = SLOT_EARS,
	"eyes" = SLOT_EYES,
	"hands" = SLOT_GLOVES,
	"head" = SLOT_HEAD,
	"feet" = SLOT_FEET,
	"exo slot" = SLOT_OCLOTHING,
	"body" = SLOT_ICLOTHING,
	"uniform" = SLOT_TIE,
	"holster" = SLOT_HOLSTER
)

GLOBAL_LIST_EMPTY(mannequins)
/proc/get_mannequin(var/ckey = "NULL")
	var/mob/living/carbon/human/dummy/mannequin/M = GLOB.mannequins[ckey]
	if(!istype(M))
		GLOB.mannequins[ckey] = new /mob/living/carbon/human/dummy/mannequin(null)
		M = GLOB.mannequins[ckey]
	return M

/proc/del_mannequin(var/ckey = "NULL")
	GLOB.mannequins-= ckey

//////////////////////////
/////Initial Building/////
//////////////////////////

/proc/makeDatumRefLists()
	var/list/paths

	//Hair - Initialise all /datum/sprite_accessory/hair into an list indexed by hair-style name
	paths = subtypesof(/datum/sprite_accessory/hair)
	for(var/path in paths)
		var/datum/sprite_accessory/hair/H = new path()
		hair_styles_list[H.name] = H
		switch(H.gender)
			if(MALE)	hair_styles_male_list += H.name
			if(FEMALE)	hair_styles_female_list += H.name
			else
				hair_styles_male_list += H.name
				hair_styles_female_list += H.name

	//Facial Hair - Initialise all /datum/sprite_accessory/facial_hair into an list indexed by facialhair-style name
	paths = subtypesof(/datum/sprite_accessory/facial_hair)
	for(var/path in paths)
		var/datum/sprite_accessory/facial_hair/H = new path()
		facial_hair_styles_list[H.name] = H
		switch(H.gender)
			if(MALE)	facial_hair_styles_male_list += H.name
			if(FEMALE)	facial_hair_styles_female_list += H.name
			else
				facial_hair_styles_male_list += H.name
				facial_hair_styles_female_list += H.name

	//Body markings - Initialise all /datum/sprite_accessory/marking into an list indexed by marking name
	paths = subtypesof(/datum/sprite_accessory/marking)
	for(var/path in paths)
		var/datum/sprite_accessory/marking/M = new path()
		body_marking_styles_list[M.name] = M
		if(!M.genetic)
			body_marking_nopersist_list[M.name] = M

	//Surgery Steps - Initialize all /datum/surgery_step into a list
	paths = subtypesof(/datum/surgery_step)
	for(var/T in paths)
		var/datum/surgery_step/S = new T
		surgery_steps += S
	sort_surgeries()

	//List of job. I can't believe this was calculated multiple times per tick!
	paths = subtypesof(/datum/job)
	paths -= exclude_jobs
	for(var/T in paths)
		var/datum/job/J = new T
		joblist[J.title] = J

	//Languages
	paths = subtypesof(/datum/language)
	for(var/T in paths)
		var/datum/language/L = new T
		if (isnull(GLOB.all_languages[L.name]))
			GLOB.all_languages[L.name] = L
		else
			log_debug("Language name conflict! [T] is named [L.name], but that is taken by [GLOB.all_languages[L.name].type]")
			if(isnull(GLOB.language_name_conflicts[L.name]))
				GLOB.language_name_conflicts[L.name] = list(GLOB.all_languages[L.name])
			GLOB.language_name_conflicts[L.name] += L

	for (var/language_name in GLOB.all_languages)
		var/datum/language/L = GLOB.all_languages[language_name]
		if(!(L.flags & NONGLOBAL))
			if(isnull(GLOB.language_keys[L.key]))
				GLOB.language_keys[L.key] = L
			else
				log_debug("Language key conflict! [L] has key [L.key], but that is taken by [(GLOB.language_keys[L.key])]")
				if(isnull(GLOB.language_key_conflicts[L.key]))
					GLOB.language_key_conflicts[L.key] = list(GLOB.language_keys[L.key])
				GLOB.language_key_conflicts[L.key] += L

	//Species
	var/rkey = 0
	paths = subtypesof(/datum/species)
	for(var/T in paths)

		rkey++

		var/datum/species/S = T
		if(!initial(S.name))
			continue

		S = new T
		S.race_key = rkey //Used in mob icon caching.
		GLOB.all_species[S.name] = S

	//Shakey shakey shake
	sortTim(GLOB.all_species, GLOBAL_PROC_REF(cmp_species), associative = TRUE)

	//Split up the rest
	for(var/speciesname in GLOB.all_species)
		var/datum/species/S = GLOB.all_species[speciesname]
		if(!(S.spawn_flags & SPECIES_IS_RESTRICTED))
			GLOB.playable_species += S.name
		if(S.spawn_flags & SPECIES_IS_WHITELISTED)
			GLOB.whitelisted_species += S.name

	// Suit cyclers
	paths = subtypesof(/datum/suit_cycler_choice/department)
	for(var/datum/suit_cycler_choice/SCC as anything in paths)
		if(!initial(SCC.name))
			continue
		GLOB.suit_cycler_departments += new SCC()
	paths = subtypesof(/datum/suit_cycler_choice/species)
	for(var/datum/suit_cycler_choice/SCC as anything in paths)
		if(!initial(SCC.name))
			continue
		GLOB.suit_cycler_species += new SCC()
	paths = subtypesof(/datum/suit_cycler_choice/department/emag)
	for(var/datum/suit_cycler_choice/SCC as anything in paths)
		if(!initial(SCC.name))
			continue
		GLOB.suit_cycler_emagged += new SCC()

	//Ores
	paths = subtypesof(/ore)
	for(var/oretype in paths)
		var/ore/OD = new oretype()
		GLOB.ore_data[OD.name] = OD

	paths = subtypesof(/datum/alloy)
	for(var/alloytype in paths)
		GLOB.alloy_data += new alloytype()

	//Closet appearances
	GLOB.closet_appearances = decls_repository.get_decls_of_type(/decl/closet_appearance)

	paths = subtypesof(/datum/sprite_accessory/ears)
	for(var/path in paths)
		var/obj/item/clothing/head/instance = new path()
		ear_styles_list[path] = instance

	// Custom Tails
	paths = subtypesof(/datum/sprite_accessory/tail) - /datum/sprite_accessory/tail/taur
	for(var/path in paths)
		var/datum/sprite_accessory/tail/instance = new path()
		tail_styles_list[path] = instance

	// Custom Wings
	paths = subtypesof(/datum/sprite_accessory/wing)
	for(var/path in paths)
		var/datum/sprite_accessory/wing/instance = new path()
		wing_styles_list[path] = instance

	// VOREStation Add - Vore Modes!
	paths = typesof(/datum/digest_mode)
	for(var/T in paths)
		var/datum/digest_mode/DM = new T
		GLOB.digest_modes[DM.id] = DM
	// VOREStation Add End
	init_crafting_recipes(GLOB.crafting_recipes)

/*
	// Custom species traits
	paths = subtypesof(/datum/trait)
	for(var/path in paths)
		var/datum/trait/instance = new path()
		if(!instance.name)
			continue //A prototype or something
		var/cost = instance.cost
		traits_costs[path] = cost
		all_traits[path] = instance
		switch(cost)
			if(-INFINITY to -0.1)
				negative_traits[path] = instance
			if(0)
				neutral_traits[path] = instance
			if(0.1 to INFINITY)
				positive_traits[path] = instance
*/

	// Custom species icon bases
	var/list/blacklisted_icons = list(SPECIES_CUSTOM,SPECIES_PROMETHEAN) //VOREStation Edit
	var/list/whitelisted_icons = list(SPECIES_FENNEC,SPECIES_XENOHYBRID,SPECIES_VOX) //VOREStation Edit
	for(var/species_name in GLOB.playable_species)
		if(species_name in blacklisted_icons)
			continue
		var/datum/species/S = GLOB.all_species[species_name]
		if(S.spawn_flags & SPECIES_IS_WHITELISTED)
			continue
		GLOB.custom_species_bases += species_name
	for(var/species_name in whitelisted_icons)
		GLOB.custom_species_bases += species_name

	return 1 // Hooks must return 1


/// Inits the crafting recipe list, sorting crafting recipe requirements in the process.
/proc/init_crafting_recipes(list/crafting_recipes)
	for(var/path in subtypesof(/datum/crafting_recipe))
		var/datum/crafting_recipe/recipe = new path()
		recipe.reqs = sortList(recipe.reqs, GLOBAL_PROC_REF(cmp_crafting_req_priority))
		crafting_recipes += recipe
	return crafting_recipes
/* // Uncomment to debug chemical reaction list.
/client/verb/debug_chemical_list()

	for (var/reaction in chemical_reactions_list)
		. += "chemical_reactions_list\[\"[reaction]\"\] = \"[chemical_reactions_list[reaction]]\"\n"
		if(islist(chemical_reactions_list[reaction]))
			var/list/L = chemical_reactions_list[reaction]
			for(var/t in L)
				. += "    has: [t]\n"
	to_world(.)
*/
//Hexidecimal numbers
var/global/list/hexNums = list("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F")

// Many global vars aren't GLOB type. This puts them there to be more easily inspected.
GLOBAL_LIST_EMPTY(legacy_globals)

/proc/populate_legacy_globals()
	//Note: these lists cannot be changed to a new list anywhere in code!
	//If they are, these will cause the old list to stay around!
	//Check by searching for "<GLOBAL_NAME> =" in the entire codebase
	GLOB.legacy_globals["player_list"] = player_list
	GLOB.legacy_globals["mob_list"] = mob_list
	GLOB.legacy_globals["human_mob_list"] = human_mob_list
	GLOB.legacy_globals["silicon_mob_list"] = silicon_mob_list
	GLOB.legacy_globals["ai_list"] = ai_list
	GLOB.legacy_globals["living_mob_list"] = living_mob_list
	GLOB.legacy_globals["dead_mob_list"] = dead_mob_list
	GLOB.legacy_globals["observer_mob_list"] = observer_mob_list
	GLOB.legacy_globals["listening_objects"] = listening_objects
	GLOB.legacy_globals["cleanbot_reserved_turfs"] = cleanbot_reserved_turfs
	GLOB.legacy_globals["cable_list"] = cable_list
	GLOB.legacy_globals["landmarks_list"] = landmarks_list
	GLOB.legacy_globals["event_triggers"] = event_triggers
	GLOB.legacy_globals["side_effects"] = side_effects
	GLOB.legacy_globals["mechas_list"] = mechas_list
	GLOB.legacy_globals["mannequins_"] = mannequins_
	//visual nets
	GLOB.legacy_globals["visual_nets"] = visual_nets
	GLOB.legacy_globals["cameranet"] = cameranet
	GLOB.legacy_globals["cultnet"] = cultnet
	GLOB.legacy_globals["existing_solargrubs"] = existing_solargrubs

var/global/list/selectable_footstep = list(
	"Default" = FOOTSTEP_MOB_HUMAN,
	"Claw" = FOOTSTEP_MOB_CLAW,
	"Light Claw" = FOOTSTEP_MOB_TESHARI,
	"Slither" = FOOTSTEP_MOB_SLITHER,
)

// Put any artifact effects that are duplicates, unique, or otherwise unwated in here! This prevents them from spawning via RNG.
var/global/list/blacklisted_artifact_effects = list(
	/datum/artifact_effect/gas/sleeping,
	/datum/artifact_effect/gas/oxy,
	/datum/artifact_effect/gas/carbondiox,
	/datum/artifact_effect/gas/fuel,
	/datum/artifact_effect/gas/nitro,
	/datum/artifact_effect/gas/phoron,
	/datum/artifact_effect/extreme
)

//stuff that only synths can eat
var/global/list/edible_tech = list(/obj/item/cell,
				/obj/item/circuitboard,
				/obj/item/integrated_circuit,
				/obj/item/broken_device,
				/obj/item/brokenbug,
				)

var/global/list/item_digestion_blacklist = list(
		/obj/item/hand_tele,
		/obj/item/card/id,
		/obj/item/gun,
		/obj/item/pinpointer,
		/obj/item/clothing/shoes/magboots,
		/obj/item/areaeditor/blueprints,
		/obj/item/disk/nuclear,
		/obj/item/perfect_tele_beacon,
		/obj/item/organ/internal/brain/slime,
		/obj/item/mmi/digital/posibrain,
		/obj/item/mmi/digital/robot,
		/obj/item/rig/protean)

var/global/list/item_tf_spawnpoints = list() // Global variable tracking which items are item tf spawnpoints

// Options for transforming into a different mob in virtual reality.
var/global/list/vr_mob_tf_options = list(
	"Borg" = /mob/living/silicon/robot,
	"Cortical borer" = /mob/living/simple_mob/animal/borer/non_antag,
	//"Hyena" = /mob/living/simple_mob/animal/hyena, //TODO: Port from Downstream
	"Giant spider" = /mob/living/simple_mob/animal/giant_spider/thermic,
	//"Armadillo" = /mob/living/simple_mob/animal/passive/armadillo, //TODO: Port from Downstream
	"Parrot" = /mob/living/simple_mob/animal/passive/bird/parrot,
	"Cat" = /mob/living/simple_mob/animal/passive/cat,
	"Corgi" = /mob/living/simple_mob/animal/passive/dog/corgi,
	"Squirrel" = /mob/living/simple_mob/vore/squirrel,
	"Frog" = /mob/living/simple_mob/vore/aggressive/frog,
	"Seagull" =/mob/living/simple_mob/vore/seagull,
	"Fox" = /mob/living/simple_mob/animal/passive/fox,
	//"Racoon" = /mob/living/simple_mob/animal/passive/raccoon_ch, //TODO: Port from Downstream
	"Shantak" = /mob/living/simple_mob/animal/sif/shantak,
	"Goose" = /mob/living/simple_mob/animal/space/goose,
	"Space shark" = /mob/living/simple_mob/animal/space/shark,
	//"Synx" = /mob/living/simple_mob/animal/synx, //TODO: Port from Downstream
	"Dire wolf" = /mob/living/simple_mob/vore/wolf/direwolf,
	"Construct Artificer" = /mob/living/simple_mob/construct/artificer,
	"Tech golem" = /mob/living/simple_mob/mechanical/technomancer_golem,
	//"Metroid" = /mob/living/simple_mob/metroid/juvenile/baby, //TODO: Port from Downstream
	"Otie" = /mob/living/simple_mob/vore/otie/cotie/chubby,
	"Red-eyed Shadekin" = /mob/living/simple_mob/shadekin/red,
	"Blue-eyed Shadekin" = /mob/living/simple_mob/shadekin/blue,
	"Purple-eyed Shadekin" = /mob/living/simple_mob/shadekin/purple,
	"Green-eyed Shadekin" = /mob/living/simple_mob/shadekin/green,
	"Yellow-eyed Shadekin" = /mob/living/simple_mob/shadekin/yellow,
	"Slime" = /mob/living/simple_mob/slime/xenobio/metal,
	"Corrupt hound" = /mob/living/simple_mob/vore/aggressive/corrupthound,
	"Deathclaw" = /mob/living/simple_mob/vore/aggressive/deathclaw, //Downstream uses /den variant here.
	"Weretiger" = /mob/living/simple_mob/vore/weretiger,
	"Mimic" = /mob/living/simple_mob/vore/aggressive/mimic, //Downstream uses /floor/plating variant here
	"Giant rat" = /mob/living/simple_mob/vore/aggressive/rat,
	"Catslug" = /mob/living/simple_mob/vore/alienanimals/catslug,
	"Dust jumper" = /mob/living/simple_mob/vore/alienanimals/dustjumper,
	"Space ghost" = /mob/living/simple_mob/vore/alienanimals/spooky_ghost,
	"Teppi" = /mob/living/simple_mob/vore/alienanimals/teppi,
	"Bee" = /mob/living/simple_mob/vore/bee,
	"Dragon" = /mob/living/simple_mob/vore/bigdragon/friendly,
	"Riftwalker" = /mob/living/simple_mob/vore/demon, //Downstream uses /wendigo variant here
	"Horse" = /mob/living/simple_mob/vore/horse/big,
	"Morph" = /mob/living/simple_mob/vore/morph,
	"Leopardmander" = /mob/living/simple_mob/vore/leopardmander,
	"Rabbit" = /mob/living/simple_mob/vore/rabbit,
	"Red panda" = /mob/living/simple_mob/vore/redpanda,
	"Sect drone" = /mob/living/simple_mob/vore/sect_drone,
	//"Armalis vox" = /mob/living/simple_mob/vox/armalis, //TODO: Port from Downstream
	//"Xeno hunter" = /mob/living/simple_mob/xeno_ch/hunter, //TODO: Port from Downstream
	//"Xeno queen" = /mob/living/simple_mob/xeno_ch/queen/maid, //TODO: Port from Downstream
	//"Xeno sentinel" = /mob/living/simple_mob/xeno_ch/sentinel, //TODO: Port from Downstream
	"Space carp" = /mob/living/simple_mob/animal/space/carp,
	"Jelly blob" = /mob/living/simple_mob/vore/jelly,
	//"SWOOPIE XL" = /mob/living/simple_mob/vore/aggressive/corrupthound/swoopie, //TODO: Port from Downstream
	"Abyss lurker" = /mob/living/simple_mob/vore/vore_hostile/abyss_lurker,
	"Abyss leaper" = /mob/living/simple_mob/vore/vore_hostile/leaper,
	"Gelatinous cube" = /mob/living/simple_mob/vore/vore_hostile/gelatinous_cube,
	//"Gryphon" = /mob/living/simple_mob/vore/gryphon //TODO: Port from Downstream
	)

var/global/list/vr_mob_spawner_options = list(
	"Parrot" = /mob/living/simple_mob/animal/passive/bird/parrot,
	"Rabbit" = /mob/living/simple_mob/vore/rabbit,
	"Cat" = /mob/living/simple_mob/animal/passive/cat,
	"Fox" = /mob/living/simple_mob/animal/passive/fox,
	"Cow" = /mob/living/simple_mob/animal/passive/cow,
	"Dog" = /mob/living/simple_mob/vore/woof,
	"Horse" = /mob/living/simple_mob/vore/horse/big,
	"Hippo" = /mob/living/simple_mob/vore/hippo,
	"Sheep" = /mob/living/simple_mob/vore/sheep,
	"Squirrel" = /mob/living/simple_mob/vore/squirrel,
	"Red panda" = /mob/living/simple_mob/vore/redpanda,
	"Fennec" = /mob/living/simple_mob/vore/fennec,
	"Seagull" =/mob/living/simple_mob/vore/seagull,
	"Corgi" = /mob/living/simple_mob/animal/passive/dog/corgi,
	//"Armadillo" = /mob/living/simple_mob/animal/passive/armadillo, //TODO: Port from Downstream
	//"Racoon" = /mob/living/simple_mob/animal/passive/raccoon_ch, //TODO: Port from Downstream
	"Goose" = /mob/living/simple_mob/animal/space/goose,
	"Frog" = /mob/living/simple_mob/vore/aggressive/frog,
	"Dust jumper" = /mob/living/simple_mob/vore/alienanimals/dustjumper,
	"Dire wolf" = /mob/living/simple_mob/vore/wolf/direwolf,
	"Space bumblebee" = /mob/living/simple_mob/vore/bee,
	"Space bear" = /mob/living/simple_mob/animal/space/bear,
	"Otie" = /mob/living/simple_mob/vore/otie,
	"Mutated otie" =/mob/living/simple_mob/vore/otie/feral,
	"Red otie" = /mob/living/simple_mob/vore/otie/red,
	"Giant rat" = /mob/living/simple_mob/vore/aggressive/rat,
	"Giant snake" = /mob/living/simple_mob/vore/aggressive/giant_snake,
	//"Hyena" = /mob/living/simple_mob/animal/hyena, //TODO: Port from Downstream
	"Space shark" = /mob/living/simple_mob/animal/space/shark,
	"Shantak" = /mob/living/simple_mob/animal/sif/shantak,
	"Kururak" = /mob/living/simple_mob/animal/sif/kururak,
	"Teppi" = /mob/living/simple_mob/vore/alienanimals/teppi,
	//"Slug" = /mob/living/simple_mob/vore/slug, //TODO: Port from Downstream
	"Catslug" = /mob/living/simple_mob/vore/alienanimals/catslug,
	"Weretiger" = /mob/living/simple_mob/vore/weretiger,
	"Dust jumper" = /mob/living/simple_mob/vore/alienanimals/dustjumper,
	"Star treader" = /mob/living/simple_mob/vore/alienanimals/startreader,
	"Space ghost" = /mob/living/simple_mob/vore/alienanimals/spooky_ghost,
	"Space carp" = /mob/living/simple_mob/animal/space/carp,
	"Space jelly fish" = /mob/living/simple_mob/vore/alienanimals/space_jellyfish,
	"Abyss lurker" = /mob/living/simple_mob/vore/vore_hostile/abyss_lurker,
	"Abyss leaper" = /mob/living/simple_mob/vore/vore_hostile/leaper,
	"Gelatinous cube" = /mob/living/simple_mob/vore/vore_hostile/gelatinous_cube,
	"Panther" = /mob/living/simple_mob/vore/aggressive/panther,
	//"Lizard man" = /mob/living/simple_mob/vore/aggressive/lizardman, //TODO: Port from Downstream
	"Pakkun" = /mob/living/simple_mob/vore/pakkun,
	//"Synx" = /mob/living/simple_mob/animal/synx, //TODO: Port from Downstream
	"Jelly blob" = /mob/living/simple_mob/vore/jelly,
	"Voracious lizard" = /mob/living/simple_mob/vore/aggressive/dino,
	//"Baby metroid" = /mob/living/simple_mob/metroid/juvenile/baby, //TODO: Port from Downstream
	//"Super metroid" = /mob/living/simple_mob/metroid/juvenile/super, //TODO: Port from Downstream
	//"Alpha metroid" = /mob/living/simple_mob/metroid/juvenile/alpha, //TODO: Port from Downstream
	//"Gamma metroid" = /mob/living/simple_mob/metroid/juvenile/gamma, //TODO: Port from Downstream
	//"Zeta metroid" = /mob/living/simple_mob/metroid/juvenile/zeta, //TODO: Port from Downstream
	//"Omega metroid" = /mob/living/simple_mob/metroid/juvenile/omega, //TODO: Port from Downstream
	//"Queen metroid" = /mob/living/simple_mob/metroid/juvenile/queen, //TODO: Port from Downstream
	"Xeno hunter" = /mob/living/simple_mob/animal/space/alien,
	"Xeno sentinel" = /mob/living/simple_mob/animal/space/alien/sentinel,
	"Xeno Praetorian" = /mob/living/simple_mob/animal/space/alien/sentinel/praetorian,
	"Xeno queen" = /mob/living/simple_mob/animal/space/alien/queen,
	"Xeno Empress" = /mob/living/simple_mob/animal/space/alien/queen/empress,
	"Xeno Queen Mother" = /mob/living/simple_mob/animal/space/alien/queen/empress/mother,
	"Defanged xeno" = /mob/living/simple_mob/vore/xeno_defanged,
	"Sect drone" = /mob/living/simple_mob/vore/sect_drone,
	"Sect queen" = /mob/living/simple_mob/vore/sect_queen,
	"Deathclaw" = /mob/living/simple_mob/vore/aggressive/deathclaw,
	"Great White Wolf" = /mob/living/simple_mob/vore/greatwolf,
	"Great Black Wolf" = /mob/living/simple_mob/vore/greatwolf/black,
	"Solar grub" = /mob/living/simple_mob/vore/solargrub,
	//"Pitcher plant" = /mob/living/simple_mob/vore/pitcher_plant, //TODO: Port from Downstream
	//"Red gummy kobold" = /mob/living/simple_mob/vore/candy/redcabold, //TODO: Port from Downstream
	//"Blue gummy kobold" = /mob/living/simple_mob/vore/candy/bluecabold, //TODO: Port from Downstream
	//"Yellow gummy kobold" = /mob/living/simple_mob/vore/candy/yellowcabold, //TODO: Port from Downstream
	//"Marshmellow serpent" = /mob/living/simple_mob/vore/candy/marshmellowserpent, //TODO: Port from Downstream
	"Riftwalker" = /mob/living/simple_mob/vore/demon,
	//"Wendigo" = /mob/living/simple_mob/vore/demon/wendigo, //TODO: Port from Downstream
	"Shadekin" = /mob/living/simple_mob/shadekin,
	"Catgirl" = /mob/living/simple_mob/vore/catgirl,
	"Wolfgirl" = /mob/living/simple_mob/vore/wolfgirl,
	"Wolftaur" = /mob/living/simple_mob/vore/wolftaur,
	"Lamia" = /mob/living/simple_mob/vore/lamia,
	"Corrupt hound" = /mob/living/simple_mob/vore/aggressive/corrupthound,
	"Corrupt corrupt hound" = /mob/living/simple_mob/vore/aggressive/corrupthound/prettyboi,
	//"SWOOPIE XL" = /mob/living/simple_mob/vore/aggressive/corrupthound/swoopie, //TODO: Port from Downstream
	//"Cultist Teshari" = /mob/living/simple_mob/humanoid/cultist/tesh, //TODO: Port from Downstream
	//"Burning Mage" = /mob/living/simple_mob/humanoid/cultist/human/bloodjaunt/fireball, //TODO: Port from Downstream
	//"Converted" = /mob/living/simple_mob/humanoid/cultist/noodle, //TODO: Port from Downstream
	//"Cultist Teshari Mage" = /mob/living/simple_mob/humanoid/cultist/castertesh, //TODO: Port from Downstream
	"Monkey" = /mob/living/carbon/human/monkey,
	"Wolpin" = /mob/living/carbon/human/wolpin,
	"Sparra" = /mob/living/carbon/human/sparram,
	"Saru" = /mob/living/carbon/human/sergallingm,
	"Sobaka" = /mob/living/carbon/human/sharkm,
	"Farwa" = /mob/living/carbon/human/farwa,
	"Neaera" = /mob/living/carbon/human/neaera,
	"Stok" = /mob/living/carbon/human/stok,
	//"Gryphon" = /mob/living/simple_mob/vore/gryphon // Disabled until tested
	)
