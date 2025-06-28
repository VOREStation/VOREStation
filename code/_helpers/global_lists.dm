//Since it didn't really belong in any other category, I'm putting this here
//This is for procs to replace all the goddamn 'in world's that are chilling around the code

GLOBAL_LIST_EMPTY(player_list)						//List of all mobs **with clients attached**. Excludes /mob/new_player
GLOBAL_LIST_EMPTY(human_mob_list)					//List of all human mobs and sub-types, including clientless
GLOBAL_LIST_EMPTY(silicon_mob_list)					//List of all silicon mobs, including clientless
GLOBAL_LIST_EMPTY(ai_list)							//List of all AIs, including clientless
GLOBAL_LIST_EMPTY(living_mob_list)					//List of all alive mobs, including clientless. Excludes /mob/new_player
GLOBAL_LIST_EMPTY(dead_mob_list)					//List of all dead mobs, including clientless. Excludes /mob/new_player
GLOBAL_LIST_EMPTY(observer_mob_list)				//List of all /mob/observer/dead, including clientless.
GLOBAL_LIST_EMPTY(listening_objects)				//List of all objects which care about receiving messages (communicators, radios, etc)
GLOBAL_LIST_EMPTY(cleanbot_reserved_turfs)			//List of all turfs currently targeted by some cleanbot

GLOBAL_LIST_EMPTY(cable_list)						//Index for all cables, so that powernets don't have to look through the entire world all the time
GLOBAL_LIST_EMPTY(landmarks_list)					//list of all landmarks created
GLOBAL_LIST_EMPTY(event_triggers)					//Associative list of creator_ckey:list(landmark references) for event triggers
GLOBAL_LIST_EMPTY(surgery_steps)					//list of all surgery steps  |BS12
GLOBAL_LIST_EMPTY(joblist)							//list of all jobstypes, minus borg and AI

//cursed lists that are used by sortAtom.
//AKA, these crash the server without /tg/ sortAtom
GLOBAL_LIST_EMPTY(mob_list)							//List of all mobs, including clientless
GLOBAL_LIST_EMPTY(mechas_list)						//list of all mechs. Used by hostile mobs target tracking.
var/global/list/obj/item/pda/PDAs = list()
var/global/list/obj/item/communicator/all_communicators = list() //Don't change this to GLOBAL_LIST_EMPTY_TYPED(all_communicators, /obj/item/communicator) for now. Sortatoms goes berserk.


#define all_genders_define_list list(MALE,FEMALE,PLURAL,NEUTER,HERM)
#define all_genders_text_list list("Male","Female","Plural","Neuter","Herm")
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

// Times that players are allowed to respawn ("ckey" = world.time)
GLOBAL_LIST_EMPTY(respawn_timers)

// Holomaps
GLOBAL_LIST_EMPTY(holomap_markers)
GLOBAL_LIST_EMPTY(mapping_units)
GLOBAL_LIST_EMPTY(mapping_beacons)

//Preferences stuff
	//Hairstyles
GLOBAL_LIST_EMPTY(hair_styles_list)			//stores /datum/sprite_accessory/hair indexed by name
GLOBAL_LIST_EMPTY(hair_styles_male_list)
GLOBAL_LIST_EMPTY(hair_styles_female_list)
GLOBAL_LIST_EMPTY(facial_hair_styles_list)	//stores /datum/sprite_accessory/facial_hair indexed by name
GLOBAL_LIST_EMPTY(facial_hair_styles_male_list)
GLOBAL_LIST_EMPTY(facial_hair_styles_female_list)
GLOBAL_LIST_EMPTY(body_marking_styles_list)		//stores /datum/sprite_accessory/marking indexed by name
GLOBAL_LIST_EMPTY(body_marking_nopersist_list)	// Body marking styles, minus non-genetic markings and augments
GLOBAL_LIST_EMPTY(ear_styles_list)	// Stores /datum/sprite_accessory/ears indexed by type
GLOBAL_LIST_EMPTY(tail_styles_list)	// Stores /datum/sprite_accessory/tail indexed by type
GLOBAL_LIST_EMPTY(wing_styles_list)	// Stores /datum/sprite_accessory/wing indexed by type

GLOBAL_LIST_INIT(custom_species_bases, new) // Species that can be used for a Custom Species icon base
	//Underwear
var/datum/category_collection/underwear/global_underwear = new()

	//Customizables
GLOBAL_LIST_INIT(headsetlist, list("Standard","Bowman","Earbud"))
GLOBAL_LIST_INIT(backbaglist, list("Nothing", "Backpack", "Satchel", "Satchel Alt", "Messenger Bag", "Sports Bag", "Strapless Satchel"))
GLOBAL_LIST_INIT(pdachoicelist, list("Default", "Slim", "Old", "Rugged", "Holographic", "Wrist-Bound","Slider", "Vintage"))
GLOBAL_LIST_INIT(exclude_jobs, list(/datum/job/ai,/datum/job/cyborg))

// Visual nets
var/list/datum/visualnet/visual_nets = list()
var/datum/visualnet/camera/cameranet = new()
var/datum/visualnet/cult/cultnet = new()
var/datum/visualnet/ghost/ghostnet = new()

// Runes
GLOBAL_LIST_EMPTY(rune_list)
GLOBAL_LIST_EMPTY(escape_list)
GLOBAL_LIST_EMPTY(endgame_exits)
GLOBAL_LIST_EMPTY(endgame_safespawns)

GLOBAL_LIST_INIT(syndicate_access, list(access_maint_tunnels, access_syndicate, access_external_airlocks))

// Ores (for mining)
GLOBAL_LIST_EMPTY(ore_data)
GLOBAL_LIST_EMPTY(alloy_data)

// Strings which corraspond to bodypart covering flags, useful for outputting what something covers.
GLOBAL_LIST_INIT(string_part_flags, list(
	"head" = HEAD,
	"face" = FACE,
	"eyes" = EYES,
	"upper body" = UPPER_TORSO,
	"lower body" = LOWER_TORSO,
	"legs" = LEGS,
	"feet" = FEET,
	"arms" = ARMS,
	"hands" = HANDS
))

// Strings which corraspond to slot flags, useful for outputting what slot something is.
GLOBAL_LIST_INIT(string_slot_flags, list(
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
))

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
		GLOB.hair_styles_list[H.name] = H
		switch(H.gender)
			if(MALE)	GLOB.hair_styles_male_list += H.name
			if(FEMALE)	GLOB.hair_styles_female_list += H.name
			else
				GLOB.hair_styles_male_list += H.name
				GLOB.hair_styles_female_list += H.name

	//Facial Hair - Initialise all /datum/sprite_accessory/facial_hair into an list indexed by facialhair-style name
	paths = subtypesof(/datum/sprite_accessory/facial_hair)
	for(var/path in paths)
		var/datum/sprite_accessory/facial_hair/H = new path()
		GLOB.facial_hair_styles_list[H.name] = H
		switch(H.gender)
			if(MALE)	GLOB.facial_hair_styles_male_list += H.name
			if(FEMALE)	GLOB.facial_hair_styles_female_list += H.name
			else
				GLOB.facial_hair_styles_male_list += H.name
				GLOB.facial_hair_styles_female_list += H.name

	//Body markings - Initialise all /datum/sprite_accessory/marking into an list indexed by marking name
	paths = subtypesof(/datum/sprite_accessory/marking)
	for(var/path in paths)
		var/datum/sprite_accessory/marking/M = new path()
		GLOB.body_marking_styles_list[M.name] = M
		if(!M.genetic)
			GLOB.body_marking_nopersist_list[M.name] = M

	//Surgery Steps - Initialize all /datum/surgery_step into a list
	paths = subtypesof(/datum/surgery_step)
	for(var/T in paths)
		var/datum/surgery_step/S = new T
		GLOB.surgery_steps += S
	sort_surgeries()

	//List of job. I can't believe this was calculated multiple times per tick!
	paths = subtypesof(/datum/job)
	paths -= GLOB.exclude_jobs
	for(var/T in paths)
		var/datum/job/J = new T
		GLOB.joblist[J.title] = J

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
		GLOB.ear_styles_list[path] = instance

	// Custom Tails
	paths = subtypesof(/datum/sprite_accessory/tail) - /datum/sprite_accessory/tail/taur
	for(var/path in paths)
		var/datum/sprite_accessory/tail/instance = new path()
		GLOB.tail_styles_list[path] = instance

	// Custom Wings
	paths = subtypesof(/datum/sprite_accessory/wing)
	for(var/path in paths)
		var/datum/sprite_accessory/wing/instance = new path()
		GLOB.wing_styles_list[path] = instance

	paths = typesof(/datum/digest_mode)
	for(var/T in paths)
		var/datum/digest_mode/DM = new T
		GLOB.digest_modes[DM.id] = DM
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
	///These are icons that you DO NOT want to be selectable!
	var/list/blacklisted_icons = list(SPECIES_CUSTOM,SPECIES_PROMETHEAN)
	///These are icons that you WANT to be selectable, even if they're a whitelist species!
	var/list/whitelisted_icons = list(SPECIES_FENNEC,SPECIES_XENOHYBRID,SPECIES_VOX)
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
GLOBAL_LIST_INIT(hexNums, list("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F"))

// Many global vars aren't GLOB type. This puts them there to be more easily inspected.
GLOBAL_LIST_EMPTY(legacy_globals)

/proc/populate_legacy_globals()
	//Note: these lists cannot be changed to a new list anywhere in code! //Lies. TG doesn't use any var/global/list so neither will we!
	//If they are, these will cause the old list to stay around!
	//Check by searching for "<GLOBAL_NAME> =" in the entire codebase
	//visual nets
	GLOB.legacy_globals["visual_nets"] = visual_nets
	GLOB.legacy_globals["cameranet"] = cameranet
	GLOB.legacy_globals["cultnet"] = cultnet

GLOBAL_LIST_INIT(selectable_footstep, list(
	"Default" = FOOTSTEP_MOB_HUMAN,
	"Claw" = FOOTSTEP_MOB_CLAW,
	"Light Claw" = FOOTSTEP_MOB_TESHARI,
	"Slither" = FOOTSTEP_MOB_SLITHER,
))

// Put any artifact effects that are duplicates, unique, or otherwise unwated in here! This prevents them from spawning via RNG.
GLOBAL_LIST_INIT(blacklisted_artifact_effects, list(
	/datum/artifact_effect/gas/sleeping,
	/datum/artifact_effect/gas/oxy,
	/datum/artifact_effect/gas/carbondiox,
	/datum/artifact_effect/gas/fuel,
	/datum/artifact_effect/gas/nitro,
	/datum/artifact_effect/gas/phoron,
	/datum/artifact_effect/extreme
))

//stuff that only synths can eat
GLOBAL_LIST_INIT(edible_tech, list(/obj/item/cell,
				/obj/item/circuitboard,
				/obj/item/integrated_circuit,
				/obj/item/broken_device,
				/obj/item/brokenbug,
				))

GLOBAL_LIST_INIT(item_digestion_blacklist, list(
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
		/obj/item/rig/protean))

///A list of chemicals that are banned from being obtainable through means that generate chemicals. These chemicals are either lame, annoying, pref-breaking, or OP (This list does NOT include reactions)
GLOBAL_LIST_INIT(obtainable_chemical_blacklist, list(
	REAGENT_ID_ADMINORDRAZINE,
	REAGENT_ID_NUTRIMENT,
	REAGENT_ID_MACROCILLIN,
	REAGENT_ID_MICROCILLIN,
	REAGENT_ID_NORMALCILLIN,
	REAGENT_ID_MAGICDUST,
	REAGENT_ID_SUPERMATTER
	))

GLOBAL_LIST_EMPTY(item_tf_spawnpoints) // Global variable tracking which items are item tf spawnpoints

// Options for transforming into a different mob in virtual reality.
GLOBAL_LIST_INIT(vr_mob_tf_options, list(
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
	))

GLOBAL_LIST_INIT(vr_mob_spawner_options, list(
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
	))

//global lists I found in various files and moved here for housekeeping
GLOBAL_LIST_EMPTY(stool_cache) //haha stool
GLOBAL_LIST_EMPTY(emotes_by_key)
GLOBAL_LIST_EMPTY(random_maps)
GLOBAL_LIST_EMPTY(map_count)
GLOBAL_LIST_EMPTY(narsie_list)
GLOBAL_LIST_EMPTY(id_card_states)
GLOBAL_LIST_EMPTY(allocated_gamma)
GLOBAL_LIST_EMPTY(semirandom_mob_spawner_decisions)

GLOBAL_LIST_INIT(unique_gamma, list(
	/obj/item/perfect_tele,
	/obj/item/bluespace_harpoon,
	/obj/item/clothing/glasses/thermal/syndi,
	/obj/item/gun/energy/netgun,
	/obj/item/gun/projectile/dartgun,
	/obj/item/clothing/gloves/black/bloodletter,
	/obj/item/gun/energy/mouseray/metamorphosis
	))

GLOBAL_LIST_INIT(newscaster_standard_feeds, list(/datum/news_announcement/bluespace_research, /datum/news_announcement/lotus_tree, /datum/news_announcement/random_junk,  /datum/news_announcement/food_riots))

GLOBAL_LIST_INIT(changeling_fabricated_clothing, list(
	"w_uniform" = /obj/item/clothing/under/chameleon/changeling,
	"head" = /obj/item/clothing/head/chameleon/changeling,
	"wear_suit" = /obj/item/clothing/suit/chameleon/changeling,
	"shoes" = /obj/item/clothing/shoes/chameleon/changeling,
	"gloves" = /obj/item/clothing/gloves/chameleon/changeling,
	"wear_mask" = /obj/item/clothing/mask/chameleon/changeling,
	"glasses" = /obj/item/clothing/glasses/chameleon/changeling,
	"back" = /obj/item/storage/backpack/chameleon/changeling,
	"belt" = /obj/item/storage/belt/chameleon/changeling,
	"wear_id" = /obj/item/card/id/syndicate/changeling
	))

//  Defines which values mean "on" or "off".
//  This is to make some of the more OP superpowers a larger PITA to activate,
//  and to tell our new DNA datum which values to set in order to turn something
//  on or off.
var/global/list/dna_activity_bounds[DNA_SE_LENGTH]

// Used to determine what each block means (admin hax and species stuff on /vg/, mostly)
var/global/list/assigned_blocks[DNA_SE_LENGTH]

GLOBAL_LIST_EMPTY(gear_distributed_to)
GLOBAL_LIST_EMPTY(overlay_cache) //cache recent overlays

var/global/list/all_technomancer_gambit_spells = typesof(/obj/item/spell) - list(
	/obj/item/spell,
	/obj/item/spell/gambit,
	/obj/item/spell/projectile,
	/obj/item/spell/aura,
//	/obj/item/spell/insert,
	/obj/item/spell/spawner,
	/obj/item/spell/summon,
	/obj/item/spell/modifier)

var/global/list/image/splatter_cache=list()
var/global/list/obj/cortical_stacks = list() //Stacks for 'leave nobody behind' objective. Clumsy, rewrite sometime.
var/global/list/obj/machinery/telecomms/telecomms_list = list()

// color-dir-dry
var/global/list/image/fluidtrack_cache=list()

var/global/list/datum/stack_recipe/sandbag_recipes = list( \
	new/datum/stack_recipe("barricade", /obj/structure/barricade/sandbag, 3, time = 5 SECONDS, one_per_turf = 1, on_floor = 1, pass_stack_color = TRUE))

GLOBAL_LIST_INIT(possible_plants, list(
	"plant-1",
	"plant-10",
	"plant-09",
	"plant-15",
	"plant-13"
))

GLOBAL_LIST_INIT(radio_channels_by_freq, list(
	num2text(PUB_FREQ) = CHANNEL_COMMON,
	num2text(AI_FREQ)  = CHANNEL_AI_PRIVATE,
	num2text(ENT_FREQ) = CHANNEL_ENTERTAINMENT,
	num2text(ERT_FREQ) = CHANNEL_RESPONSE_TEAM,
	num2text(COMM_FREQ)= CHANNEL_COMMAND,
	num2text(ENG_FREQ) = CHANNEL_ENGINEERING,
	num2text(MED_FREQ) = CHANNEL_MEDICAL,
	num2text(MED_I_FREQ)=CHANNEL_MEDICAL_1,
	num2text(SEC_FREQ) = CHANNEL_SECURITY,
	num2text(SEC_I_FREQ)=CHANNEL_SECURITY_1,
	num2text(SCI_FREQ) = CHANNEL_SCIENCE,
	num2text(SUP_FREQ) = CHANNEL_SUPPLY,
	num2text(SRV_FREQ) = CHANNEL_SERVICE,
	num2text(EXP_FREQ) = CHANNEL_EXPLORATION
	))

GLOBAL_LIST_BOILERPLATE(all_pai_cards, /obj/item/paicard)

// Access check is of the type requires one. These have been carefully selected to avoid allowing the janitor to see channels he shouldn't
GLOBAL_LIST_INIT(default_internal_channels, list(
	num2text(PUB_FREQ) = list(),
	num2text(AI_FREQ)  = list(access_synth),
	num2text(ENT_FREQ) = list(),
	num2text(ERT_FREQ) = list(access_cent_specops),
	num2text(COMM_FREQ)= list(access_heads),
	num2text(ENG_FREQ) = list(access_engine_equip, access_atmospherics),
	num2text(MED_FREQ) = list(access_medical_equip),
	num2text(MED_I_FREQ)=list(access_medical_equip),
	num2text(SEC_FREQ) = list(access_security),
	num2text(SEC_I_FREQ)=list(access_security),
	num2text(SCI_FREQ) = list(access_tox, access_robotics, access_xenobiology),
	num2text(SUP_FREQ) = list(access_cargo, access_mining_station),
	num2text(SRV_FREQ) = list(access_janitor, access_library, access_hydroponics, access_bar, access_kitchen),
	num2text(EXP_FREQ) = list(access_explorer)
))

GLOBAL_LIST_INIT(default_medbay_channels, list(
	num2text(PUB_FREQ) = list(),
	num2text(MED_FREQ) = list(),
	num2text(MED_I_FREQ) = list()
))

GLOBAL_LIST_INIT(valid_ringtones, list(
		"beep",
		"boom",
		"slip",
		"honk",
		"SKREE",
		"xeno",
		"spark",
		"rad",
		"servo",
		"buh-boop",
		"trombone",
		"whistle",
		"chirp",
		"slurp",
		"pwing",
		"clack",
		"bzzt",
		"chimes",
		"prbt",
		"bark",
		"bork",
		"roark",
		"chitter",
		"squish"
		))

GLOBAL_LIST_EMPTY(seen_citizenships)
GLOBAL_LIST_EMPTY(seen_systems)
GLOBAL_LIST_EMPTY(seen_factions)
GLOBAL_LIST_EMPTY(seen_religions)

GLOBAL_LIST_INIT(citizenship_choices, list(
	"Greater Human Diaspora",
	"Commonwealth of Sol-Procyon",
	"Skrell Consensus",
	"Moghes Hegemony",
	"Tajaran Diaspora",
	"Unitary Alliance of Salthan Fyrds",
	"Elysian Colonies",
	"Third Ares Confederation",
	"Teshari Union",
	"Altevian Hegemony",
	"Kosaky Fleets"
	))

GLOBAL_LIST_INIT(home_system_choices, list(
	"Virgo-Erigone",
	"Sol",
	"Earth, Sol",
	"Luna, Sol",
	"Mars, Sol",
	"Venus, Sol",
	"Titan, Sol",
	"Toledo, New Ohio",
	"The Pact, Myria",
	"Kishar, Alpha Centauri",
	"Anshar, Alpha Centauri",
	"Heaven Complex, Alpha Centauri",
	"Procyon",
	"Altair",
	"Kara, Vir",
	"Sif, Vir",
	"Brinkburn, Nyx",
	"Binma, Tau Ceti",
	"Qerr'balak, Qerr'valis",
	"Epsilon Ursae Minoris",
	"Meralar, Rarkajar",
	"Tal, Vilous",
	"Menhir, Alat-Hahr",
	"Altam, Vazzend",
	"Uh'Zata, Kelezakata",
	"Moghes, Uuoea-Esa",
	"Xohok, Uuoea-Esa",
	"Varilak, Antares",
	"Sanctorum, Sanctum",
	"Infernum, Sanctum",
	"Abundance in All Things Serene, Beta-Carnelium Ventrum",
	"Jorhul, Barkalis",
	"Shelf Flotilla",
	"Ue-Orsi Flotilla",
	"AH-CV Prosperity",
	"AH-CV Migrant",
	"Altevian Colony Ship"
	))

GLOBAL_LIST_INIT(faction_choices, list(
	"NanoTrasen Incorporated",
	"Hephaestus Industries",
	"Vey-Medical",
	"Zeng-Hu Pharmaceuticals",
	"Ward-Takahashi GMC",
	"Bishop Cybernetics",
	"Morpheus Cyberkinetics",
	"Xion Manufacturing Group",
	"Free Trade Union",
	"Major Bill's Transportation",
	"Ironcrest Transport Group",
	"Grayson Manufactories Ltd.",
	"Aether Atmospherics",
	"Focal Point Energistics",
	"StarFlight Inc.",
	"Oculum Broadcasting Network",
	"Periphery Post",
	"Free Anur Tribune",
	"Centauri Provisions",
	"Einstein Engines",
	"Wulf Aeronautics",
	"Gilthari Exports",
	"Coyote Salvage Corp.",
	"Chimera Genetics Corp.",
	"Independent Pilots Association",
	"Local System Defense Force",
	"United Solar Defense Force",
	"Proxima Centauri Risk Control",
	"HIVE Security",
	"Stealth Assault Enterprises",
	"Teshari Union"
	))

GLOBAL_LIST_EMPTY(antag_faction_choices)	//Should be populated after brainstorming. Leaving as blank in case brainstorming does not occur.

GLOBAL_LIST_INIT(antag_visiblity_choices, list(
	"Hidden",
	"Shared",
	"Known"
	))

GLOBAL_LIST_INIT(religion_choices, list(
	"Unitarianism",
	"Neopaganism",
	"Islam",
	"Christianity",
	"Judaism",
	"Hinduism",
	"Buddhism",
	"Pleromanism",
	"Spectralism",
	"Phact Shintoism",
	"Kishari Faith",
	"Hauler Faith",
	"Nock",
	"Singulitarian Worship",
	"Xilar Qall",
	"Tajr-kii Rarkajar",
	"Agnosticism",
	"Deism",
	"Neo-Moreauism",
	"Orthodox Moreauism"
	))

GLOBAL_LIST_INIT(xenoChemList, list(REAGENT_ID_MUTATIONTOXIN,
						REAGENT_ID_PSILOCYBIN,
						REAGENT_ID_MINDBREAKER,
						REAGENT_ID_IMPEDREZENE,
						REAGENT_ID_CRYPTOBIOLIN,
						REAGENT_ID_BLISS,
						REAGENT_ID_CHLORALHYDRATE,
						REAGENT_ID_STOXIN,
						REAGENT_ID_MUTAGEN,
						REAGENT_ID_LEXORIN,
						REAGENT_ID_PACID,
						REAGENT_ID_CYANIDE,
						REAGENT_ID_PHORON,
						REAGENT_ID_PLASTICIDE,
						REAGENT_ID_AMATOXIN,
						REAGENT_ID_CARBON,
						REAGENT_ID_RADIUM,
						REAGENT_ID_SACID,
						REAGENT_ID_SUGAR,
						REAGENT_ID_KELOTANE,
						REAGENT_ID_DERMALINE,
						REAGENT_ID_ANTITOXIN,
						REAGENT_ID_DEXALIN,
						REAGENT_ID_SYNAPTIZINE,
						REAGENT_ID_ALKYSINE,
						REAGENT_ID_IMIDAZOLINE,
						REAGENT_ID_PERIDAXON,
						REAGENT_ID_REZADONE))

//Chemlist of what was banned in xenobio2. Kept for legacy purposes.
GLOBAL_LIST_INIT(xeno2ChemList, list(REAGENT_ID_INAPROVALINE,
						REAGENT_ID_BICARIDINE,
						REAGENT_ID_DEXALINP,
						REAGENT_ID_TRICORDRAZINE,
						REAGENT_ID_CRYOXADONE,
						REAGENT_ID_CLONEXADONE,
						REAGENT_ID_PARACETAMOL,
						REAGENT_ID_TRAMADOL,
						REAGENT_ID_OXYCODONE,
						REAGENT_ID_RYETALYN,
						REAGENT_ID_HYPERZINE,
						REAGENT_ID_ETHYLREDOXRAZINE,
						REAGENT_ID_HYRONALIN,
						REAGENT_ID_ARITHRAZINE,
						REAGENT_ID_SPACEACILLIN,
						REAGENT_ID_STERILIZINE,
						REAGENT_ID_LEPORAZINE,
						REAGENT_ID_METHYLPHENIDATE,
						REAGENT_ID_CITALOPRAM,
						REAGENT_ID_PAROXETINE,
						REAGENT_ID_MACROCILLIN,
						REAGENT_ID_MICROCILLIN,
						REAGENT_ID_NORMALCILLIN,
						REAGENT_ID_SIZEOXADONE,
						REAGENT_ID_ICKYPAK,
						REAGENT_ID_UNSORBITOL,
						REAGENT_ID_TOXIN,
						REAGENT_ID_CARPOTOXIN,
						REAGENT_ID_POTASSIUMCHLORIDE,
						REAGENT_ID_POTASSIUMCHLOROPHORIDE,
						REAGENT_ID_ZOMBIEPOWDER,
						REAGENT_ID_FERTILIZER,
						REAGENT_ID_EZNUTRIENT,
						REAGENT_ID_LEFT4ZED,
						REAGENT_ID_ROBUSTHARVEST,
						REAGENT_ID_PLANTBGONE,
						REAGENT_ID_SEROTROTIUM,
						REAGENT_ID_NICOTINE,
						REAGENT_ID_URANIUM,
						REAGENT_ID_SILVER,
						REAGENT_ID_GOLD,
						REAGENT_ID_ADRENALINE,
						REAGENT_ID_HOLYWATER,
						REAGENT_ID_AMMONIA,
						REAGENT_ID_DIETHYLAMINE,
						REAGENT_ID_FLUOROSURFACTANT,
						REAGENT_ID_FOAMINGAGENT,
						REAGENT_ID_THERMITE,
						REAGENT_ID_CLEANER,
						REAGENT_ID_LUBE,
						REAGENT_ID_SILICATE,
						REAGENT_ID_GLYCEROL,
						REAGENT_ID_COOLANT,
						REAGENT_ID_LUMINOL,
						REAGENT_ID_NUTRIMENT,
						REAGENT_ID_CORNOIL,
						REAGENT_ID_LIPOZINE,
						REAGENT_ID_SODIUMCHLORIDE,
						REAGENT_ID_FROSTOIL,
						REAGENT_ID_CAPSAICIN,
						REAGENT_ID_CONDENSEDCAPSAICIN,
						REAGENT_ID_NEUROTOXIN))

//keep synced with the defines BE_* in setup.dm --rastaf
//some autodetection here.
//Change these to 0 if the equivalent mode is disabled for whatever reason!
GLOBAL_LIST_INIT(special_roles, list(
	"traitor" = 0,										// 0
	"operative" = 0,									// 1
	"changeling" = 0,									// 2
	"wizard" = 0,										// 3
	"malf AI" = 0,										// 4
	"revolutionary" = 0,								// 5
	"alien candidate" = 0,								// 6
	"positronic brain" = 1,								// 7
	"cultist" = 0,										// 8
	"renegade" = 0,										// 9
	"ninja" = 0,										// 10
	"raider" = 0,										// 11
	"diona" = 0,										// 12
	"mutineer" = 0,										// 13
	"loyalist" = 0,										// 14
	"pAI candidate" = 1,								// 15
	"lost drone" = 1,									// 16
	"maint pred" = 1,									// 17
	"maint lurker" = 1,									// 18
	"morph" = 1,										// 19
	"corgi" = 1,										// 20
	"cursed sword" = 1,									// 21
	"Ship Survivor" = 1,								// 22
))


// GLOB.alldirs in global.dm is the same list of directions, but since
//  the specific order matters to get a usable icon_state, it is
//  copied here so that, in the unlikely case that GLOB.alldirs is changed, transit_tube.dm
//  continues to work.
GLOBAL_LIST_INIT(tube_dir_list, list(
	NORTH,
	SOUTH,
	EAST,
	WEST,
	NORTHEAST,
	NORTHWEST,
	SOUTHEAST,
	SOUTHWEST))

GLOBAL_LIST_INIT(valid_bloodreagents, list("default",REAGENT_ID_IRON,REAGENT_ID_COPPER,REAGENT_ID_PHORON,REAGENT_ID_SILVER,REAGENT_ID_GOLD,REAGENT_ID_SLIMEJELLY))	//allowlist-based so people don't make their blood restored by alcohol or something really silly. use reagent IDs!

GLOBAL_LIST_EMPTY(monitor_states)

GLOBAL_LIST_EMPTY(random_junk)
GLOBAL_LIST_EMPTY(random_junk_)
GLOBAL_LIST_EMPTY(random_useful_)
