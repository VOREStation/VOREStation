//Datums for different companies that can be used by busy_space
/datum/lore/organization
	var/name = ""															// Organization's name
	var/short_name = ""														// Organization's shortname (NanoTrasen for "NanoTrasen Incorporated")
	var/acronym = ""														// Organization's acronym, e.g. 'NT' for NanoTrasen'.
	var/desc = ""															// One or two paragraph description of the organization, but only current stuff.  Currently unused.
	var/history = ""														// Historical discription of the organization's origins  Currently unused.
	var/work = ""															// Short description of their work, eg "an arms manufacturer"
	var/headquarters = ""													// Location of the organization's HQ.  Currently unused.
	var/motto = ""															// A motto/jingle/whatever, if they have one.
	var/legit = 90															// The odds of them being approved a flight route. mostly a function of their reputation though unfamiliarity with local traffic rules is also a factor
	var/annoying = 10														// The odds they'll say their motto at the end of a successfully negotiatiated route.
	var/serviced = list(/datum/lore/system/sol = 1)							// systems they work in, weighted
	var/missions = list()		// mission types they run
	var/special_locations = list()											// individual locations they might run missions to outside of their serviced systems
	var/mission_noun = list("mission","flight", "trip")						//
	var/current_ship = ""												// the most recent ship from this org to have talked on the tracon
//todo, implement per-org special locations

	var/list/ship_names = list(		//Names of spaceships.  This is a mostly generic list that all the other organizations inherit from if they don't have anything better.
		"Kestrel",
		"Beacon",
		"Signal",
		"Freedom",
		"Glory",
		"Axiom",
		"Eternal",
		"Harmony",
		"Light",
		"Discovery",
		"Endeavour",
		"Explorer",
		"Swift",
		"Dragonfly",
		"Hollyhock",
		"Ascendant",
		"Tenacious",
		"Pioneer",
		"Hawk",
		"Haste",
		"Radiant",
		"Luminous",
		"Princess of Sol",
		"King of the Mountain",
		"Words and Changes",
		"Katerina's Silhouette",
		"Castle of Water",
		"Jade Leviathan",
		"Sword of Destiny",
		"Ishtar's Grace"
		)
<<<<<<< HEAD
	var/list/destination_names = list()	//Names of static holdings that the organization's ships visit regularly.
	var/autogenerate_destination_names = TRUE

/datum/lore/organization/New()
	..()
	if(autogenerate_destination_names) // Lets pad out the destination names.
		var/i = rand(6, 10)
		var/list/star_names = list(
			"Sol", "Alpha Centauri", "Tau Ceti", "Zhu Que", "Oasis", "Vir", "Gavel", "Ganesha",
			"Saint Columbia", "Altair", "Sidhe", "New Ohio", "Parvati", "Mahi-Mahi", "Nyx", "New Seoul",
			"Kess-Gendar", "Raphael", "Phact", "Altair", "El", "Eutopia", "Qerr'valis", "Qerrna-Lakirr", "Rarkajar", "Thoth", "Jahan's Post", "Kauq'xum", "Silk", "New Singapore", "Stove", "Viola", "Love", "Isavau's Gamble" )
		var/list/destination_types = list("dockyard", "station", "vessel", "waystation", "telecommunications satellite", "spaceport", "anomaly", "colony", "outpost")
		while(i)
			destination_names.Add("a [pick(destination_types)] in [pick(star_names)]")
			i--
=======

/datum/lore/organization/proc/generate_mission()
	// pick what system we're going to run in
	var/datum/lore/system/destination_system = pickweight(serviced)
	if(destination_system)
		destination_system = new destination_system

	//shuffle
	missions = shuffle(missions)
	destination_system.locations = shuffle(destination_system.locations)

	//init other variables
	var/destination_mission_types = list()
	var/possible_mission_types = list()

	//find what missions we can run
	for(var/datum/lore/mission/x in missions)
		possible_mission_types |= x.mission_type

	//populate destination_missions with all the mission types in that system
	for(var/datum/lore/location/x in destination_system.locations)
		destination_mission_types |= x.mission_types

	// only find missions in the system we can run
	possible_mission_types &= destination_mission_types

	//sanity checking
	if(!possible_mission_types) //an org was given a system that contains no missions they run. let's fail gracefully about it
		current_ship = "vessel [pick("SOL", "VIR", "STC", "ACE")]-575-[rand(0,999999)]" //unnamed ship
		return "[current_ship], traveling to local registrar" //instantly identifiable as an error but still immersive

	//select a mission we can run
	var/datum/lore/mission/selected_mission
	for(var/datum/lore/mission/x in missions)
		if(x.mission_type in possible_mission_types)
			selected_mission = x
			break

	//select a place to do it at
	var/datum/lore/location/selected_location
	for(var/datum/lore/location/x in destination_system.locations)
		if(selected_mission.mission_type in x.mission_types)
			selected_location = x
			break

	//set our ship name for consistancy on the tracon
	current_ship = "[selected_mission.prefix] [pick(ship_names)]"

	//finally return our answer
	return "[current_ship] on a [pick(selected_mission.mission_strings)] [pick(mission_noun)] to [selected_location.desc]"

>>>>>>> 4bf1424695f... Merge pull request #8974 from elgeonmb/newtracon

//////////////////////////////////////////////////////////////////////////////////

// TSCs
/datum/lore/organization/tsc/nanotrasen
	name = "NanoTrasen Incorporated"
	short_name = "NanoTrasen"
	acronym = "NT"
	desc = "NanoTrasen is one of the foremost research and development companies in SolGov space. \
	Originally focused on consumer products, their swift move into the field of phoron has lead to \
	them being the foremost experts on the substance and its uses. In the modern day, NanoTrasen prides \
	itself on being an early adopter to as many new technologies as possible, often offering the newest \
	products to their employees. In an effort to combat complaints about being 'guinea pigs', Nanotrasen \
	also offers one of the most comprehensive medical plans in SolGov space, up to and including cloning \
	and therapy.\
	<br><br>\
	NT's most well known products are its phoron based creations, especially those used in Cryotherapy. \
	It also boasts an prosthetic line, which is provided to its employees as needed, and is used as an incentive \
	for newly tested posibrains to remain with the company."
	history = "" // To be written someday.
	work = "research giant"
	headquarters = "Luna, Sol"
	motto = ""
	legit = 95 //they own the local airspace

	missions = list( // they get almost every mission type because they're, you know, NT
		new /datum/lore/mission/prebuilt/medical("NMV"),
		new /datum/lore/mission/prebuilt/transport("NTV"),
		new /datum/lore/mission/prebuilt/defense("NDV"),
		new /datum/lore/mission/prebuilt/freight("NFV"),
		new /datum/lore/mission/prebuilt/industrial("NIV"),
		new /datum/lore/mission/prebuilt/scientific("NSV"),
		new /datum/lore/mission/prebuilt/salvage("NIV"),
		new /datum/lore/mission/prebuilt/medical_response("NRV"),
		new /datum/lore/mission/prebuilt/defense_response("NRV")
		)

	serviced = list( //again, protagonists, so this is something close to a map by trade distance of human+tajaran space
		/datum/lore/system/vir = 20,
		/datum/lore/system/sol = 15,
		/datum/lore/system/gavel = 15,
		/datum/lore/system/oasis = 15,
		/datum/lore/system/saint_columbia = 10,
		/datum/lore/system/kess_gendar = 10,
		/datum/lore/system/tau_ceti = 10,
		/datum/lore/system/alpha_centauri = 10,
		/datum/lore/system/new_ohio = 10,
		/datum/lore/system/new_seoul = 10,
		/datum/lore/system/el = 10, //specific high NT investment
		/datum/lore/system/nyx = 10,
		/datum/lore/system/zhu_que = 5,
		/datum/lore/system/love = 5,
		/datum/lore/system/kauqxum = 5,
		/datum/lore/system/sidhe = 5,
		/datum/lore/system/mahimahi = 5,
		/datum/lore/system/relan = 5,
		/datum/lore/system/exalts_light = 5,
		/datum/lore/system/rarkajar = 5,
		/datum/lore/system/raphael = 5, //they own one of the raphaelite colonies
		/datum/lore/system/mesomori = 2,
		/datum/lore/system/arrathiir = 2,
		/datum/lore/system/jahans_post = 2,
		/datum/lore/system/abels_rest = 2,
		/datum/lore/system/terminus = 2,
		/datum/lore/system/eutopia = 2,
		/datum/lore/system/altair = 2,
		/datum/lore/system/neon_light = 1
		)


	//Scientist naming scheme
	ship_names = list(
		"Bardeen",
		"Einstein",
		"Feynman",
		"Sagan",
		"Tyson",
		"Galilei",
		"Jans",
		"Fhriede",
		"Franklin",
		"Tesla",
		"Curie",
		"Darwin",
		"Newton",
		"Pasteur",
		"Bell",
		"Mendel",
		"Kepler",
		"Edision",
		"Cavendish",
		"Nye",
		"Hawking",
		"Aristotle",
		"Von Braun",
		"Kaku",
		"Oppenheimer",
		"Renwick",
		"Hubble",
		"Alcubierre",
		"Robineau",
		"Glass"
		)
<<<<<<< HEAD
	// Note that the current station being used will be pruned from this list upon being instantiated
	destination_names = list(
		"NSS Exodus in Nyx",
		"NCS Northern Star in Vir",
		//"NLS Southern Cross in Vir",
		"NAS Vir Central Command",
		"a dockyard orbiting Sif",
		"an asteroid orbiting Kara",
		"an asteroid orbiting Rota",
		"Vir Interstellar Spaceport"
		)

/datum/lore/organization/tsc/nanotrasen/New()
	..()
	spawn(1) // BYOND shenanigans means using_map is not initialized yet.  Wait a tick.
		// Get rid of the current map from the list, so ships flying in don't say they're coming to the current map.
		var/string_to_test = "[using_map.station_name] in [using_map.starsys_name]"
		if(string_to_test in destination_names)
			destination_names.Remove(string_to_test)

=======
>>>>>>> 4bf1424695f... Merge pull request #8974 from elgeonmb/newtracon


/datum/lore/organization/tsc/hephaestus
	name = "Hephaestus Industries"
	short_name = "Hephaestus"
	acronym = "HI"
	desc = "Hephaestus Industries is the largest supplier of arms, ammunition, and small millitary vehicles in Sol space. \
	Hephaestus products have a reputation for reliability, and the corporation itself has a noted tendency to stay removed \
	from corporate politics. They enforce their neutrality with the help of a fairly large asset-protection contingent which \
	prevents any contracting polities from using their own materiel against them. SolGov itself is one of Hephaestus' largest \
	bulk contractors owing to the above factors."
	history = ""
	work = "arms manufacturer"
	headquarters = "Luna, Sol"
	motto = ""

	missions = list(
		new/datum/lore/mission/prebuilt/defense("HDV"),
		new/datum/lore/mission/prebuilt/industrial("HLV"),//to avoid unfortunate prefixes
		new/datum/lore/mission/prebuilt/freight("HFV"),
		new/datum/lore/mission/prebuilt/transport("HTV"),
		new/datum/lore/mission("HSV", list("weapons testing", "materials testing", "data exchange"), ATC_SCI) //might produce slightly weird results vis a vis location
		)

	serviced = list(
		/datum/lore/system/vir = 10, //local space (local operations significantly reduced)
		/datum/lore/system/sol = 20,
		/datum/lore/system/oasis = 15, //local + on the border
		/datum/lore/system/saint_columbia = 15, //SCG military outposts
		/datum/lore/system/jahans_post = 15,
		/datum/lore/system/tau_ceti = 15, //specifically named local operations
		/datum/lore/system/kess_gendar = 15,
		/datum/lore/system/alpha_centauri = 10,
		/datum/lore/system/abels_rest = 10,
		/datum/lore/system/new_ohio = 10, //is very obviously a big border thing
		/datum/lore/system/gavel = 10, //local
		/datum/lore/system/sidhe = 5, //other systems w/ piracy problems and governments addressing them
		/datum/lore/system/love = 5,
		/datum/lore/system/zhu_que = 5,
		/datum/lore/system/raphael = 5,
		/datum/lore/system/new_seoul = 5,//national capitals that are vaguely scg friendly
		/datum/lore/system/rarkajar = 5,
		/datum/lore/system/terminus = 2,
		/datum/lore/system/whythe = 1, //very good national contractors are allowed to poke at the fucked up hell ruins
		/datum/lore/system/isavaus_gamble = 1,
		)

	//War God/Soldier Theme
	ship_names = list(
		"Ares",
		"Athena",
		"Grant",
		"Custer",
		"Puller",
		"Nike",
		"Bellona",
		"Leonides",
		"Bast",
		"Jackson",
		"Lee",
		"Annan",
		"Chi Yu",
		"Shiva",
		"Tyr",
		"Nobunaga",
		"Xerxes",
		"Alexander",
		"McArthur",
		"Samson",
		"Oya",
		"Nemain",
		"Caesar",
		"Augustus",
		"Sekhmet",
		"Ku",
		"Indra",
		"Innana",
		"Ishtar",
		"Qamaits",
		"'Oro",
		)
<<<<<<< HEAD
	destination_names = list(
		"a SolGov dockyard on Luna",
		"a Fleet outpost in the Almach Rim",
		"a Fleet outpost on the Moghes border"
		)
=======
>>>>>>> 4bf1424695f... Merge pull request #8974 from elgeonmb/newtracon

/datum/lore/organization/tsc/vey_med
	name = "Vey-Medical" //The Wiki displays them as Vey-Medical.
	short_name = "Vey-Med"
	acronym = "VM"
	desc = "Vey-Med is one of the newer TSCs on the block and is notable for being largely owned and opperated by Skrell. \
	Despite the suspicion and prejudice leveled at them for their alien origin, Vey-Med has obtained market dominance in \
	the sale of medical equipment-- from surgical tools to large medical devices to the Oddyseus trauma response mecha \
	and everything in between. Their equipment tends to be top-of-the-line, most obviously shown by their incredibly \
	human-like FBP designs. Vey's rise to stardom came from their introduction of ressurective cloning, although in \
	recent years they've been forced to diversify as their patents expired and NanoTrasen-made medications became \
	essential to modern cloning."
	history = ""
	work = "medical equipment supplier"
	headquarters = "Toledo, New Ohio"
	motto = ""
	legit = 80 //major NT competitor + dirty aliens etc

	missions = list(
		new/datum/lore/mission/prebuilt/medical("VMV"),
		new/datum/lore/mission/prebuilt/medical_response("VRV"),
		new/datum/lore/mission/prebuilt/scientific("VSV"),
		new/datum/lore/mission/prebuilt/transport("VTV")
		)

	serviced = list(
		/datum/lore/system/vir = 15,
		/datum/lore/system/new_ohio = 15, //their HQ
		/datum/lore/system/gavel = 10,
		/datum/lore/system/oasis = 10,
		/datum/lore/system/sol = 10,
		/datum/lore/system/kauqxum = 10, //activity mostly in the heights
		/datum/lore/system/new_seoul = 10,
		/datum/lore/system/mahimahi = 10, //im guessing wildly about mahi-mahi i know nothing
		/datum/lore/system/sidhe = 5,
		/datum/lore/system/qerrvalis = 5, //one of very few organizations that will actually operate out that far
		/datum/lore/system/tau_ceti = 5,
		/datum/lore/system/alpha_centauri = 5,
		/datum/lore/system/kess_gendar = 5,
		/datum/lore/system/exalts_light = 5, //delicious almachi medicine
		/datum/lore/system/relan = 5,
		/datum/lore/system/vounna = 5,
		/datum/lore/system/el = 2,
		/datum/lore/system/eutopia = 2
		)

	// Mostly Diona names
	ship_names = list(
		"Wind That Stirs The Waves",
		"Sustained Note Of Metal",
		"Bright Flash Reflecting Off Glass",
		"Veil Of Mist Concealing The Rock",
		"Thin Threads Intertwined",
		"Clouds Drifting Amid Storm",
		"Loud Note And Breaking",
		"Endless Vistas Expanding Before The Void",
		"Fire Blown Out By Wind",
		"Star That Fades From View",
		"Eyes Which Turn Inwards",
		"Joy Without Which The World Would Come Undone",
		"A Thousand Thousand Planets Dangling From Branches",
		"Light Streaming Through Interminable Branches",
		"Smoke Brought Up From A Terrible Fire",
		"Light of Qerr'Valis",
		"King Xae'uoque",
		"Memory of Kel'xi",
		"Xi'Kroo's Herald"
		)

/datum/lore/organization/tsc/zeng_hu
	name = "Zeng-Hu Pharmaceuticals"
	short_name = "Zeng-Hu"
	acronym = "ZH"
	desc = "Zeng-Hu is an old TSC, based in the Sol system. Until the discovery of phoron, Zeng-Hu maintained a stranglehold \
	on the market for medications, and many household names are patentted by Zeng-Hu-- Bicaridyne, Dylovene, Tricordrizine, \
	and Dexalin all came from a Zeng-Hu medical laboratory. Zeng-Hu's fortunes have been in decline as Nanotrasen's near monopoly \
	on phoron research cuts into their R&D and Vey-Med's superior medical equipment effectively decimated their own equipment \
	interests. The three-way rivalry between these companies for dominance in the medical field is well-known and a matter of \
	constant economic speculation."
	history = ""
	work = "pharmaceuticals company"
	headquarters = "Earth, Sol"
	motto = "When your life is on the line, trust Zeng-Hu." //from the wiki
	legit = 85 // major NT competitor

	missions = list(
		new /datum/lore/mission/prebuilt/medical("ZMV"), //they dont really like. do emergency medical shit. they just kind of sell drugs.
		new /datum/lore/mission/prebuilt/transport("ZTV"),
		new /datum/lore/mission/prebuilt/scientific("ZSV")
		)

	serviced = list( //some of this list is veering perilously close to just making shit up tbh
		/datum/lore/system/vir = 10,
		/datum/lore/system/sol = 15,
		/datum/lore/system/alpha_centauri = 10,
		/datum/lore/system/tau_ceti = 10,
		/datum/lore/system/kess_gendar = 10,
		/datum/lore/system/new_ohio = 5,
		/datum/lore/system/new_seoul = 5,
		/datum/lore/system/mahimahi = 5,
		/datum/lore/system/saint_columbia = 5, //i imagine they have decent SCG hospital contracts compared to vey-med (foreign) and nanotrasen (super shifty)
		/datum/lore/system/jahans_post = 5,
		/datum/lore/system/abels_rest = 5,
		/datum/lore/system/love = 2,
		/datum/lore/system/zhu_que = 2,
		/datum/lore/system/sidhe = 2,
		/datum/lore/system/vounna = 2 //i imagine theyre mostly being squeezed out of the almachi investment rush given kalediscope and their poor positioning in general
		)

/datum/lore/organization/tsc/ward_takahashi
	name = "Ward-Takahashi General Manufacturing Conglomerate"
	short_name = "Ward-Takahashi"
	acronym = "WT"
	desc = "Ward-Takahashi focuses on the sale of small consumer electronics, with its computers, communicators, \
	and even mid-class automobiles a fixture of many households. Less famously, Ward-Takahashi also supplies most \
	of the AI cores on which vital control systems are mounted, and it is this branch of their industry that has \
	led to their tertiary interest in the development and sale of high-grade AI systems. Ward-Takahashi's economies \
	of scale frequently steal market share from NanoTrasen's high-price products, leading to a bitter rivalry in the \
	consumer electronics market."
	history = ""
	work = "electronics manufacturer"
	headquarters = ""
	motto = ""
	legit = 85 //major NT competitor

	missions = list(
		new /datum/lore/mission/prebuilt/freight("WFV"),
		new /datum/lore/mission/prebuilt/transport("WTV"),
		new /datum/lore/mission/prebuilt/industrial("WIV"),
		new /datum/lore/mission/prebuilt/scientific("WSV"),
		new /datum/lore/mission/prebuilt/defense("WDV")
		)

	serviced = list( //pretty similar to the NT map-- they're NT's biggest competitor on like, half their things
		/datum/lore/system/vir = 10, //squeezed out by big NT
		/datum/lore/system/sol = 15,
		/datum/lore/system/gavel = 10,
		/datum/lore/system/oasis = 10,
		/datum/lore/system/kess_gendar = 10,
		/datum/lore/system/tau_ceti = 10,
		/datum/lore/system/alpha_centauri = 10,
		/datum/lore/system/new_ohio = 10,
		/datum/lore/system/new_seoul = 10,
		/datum/lore/system/saint_columbia = 5,
		/datum/lore/system/el = 5,
		/datum/lore/system/zhu_que = 5,
		/datum/lore/system/love = 5,
		/datum/lore/system/kauqxum = 5,
		/datum/lore/system/sidhe = 5,
		/datum/lore/system/mahimahi = 5,
		/datum/lore/system/relan = 5,
		/datum/lore/system/exalts_light = 5,
		/datum/lore/system/rarkajar = 5,
		/datum/lore/system/terminus = 5,
		/datum/lore/system/eutopia = 5, //computer manufacturers love unfree labor
		/datum/lore/system/altair = 5,
		/datum/lore/system/phact = 5, //historic ties. the name also helps
		/datum/lore/system/mesomori = 2,
		/datum/lore/system/arrathiir = 2,
		/datum/lore/system/jahans_post = 2,
		/datum/lore/system/abels_rest = 2,
		/datum/lore/system/raphael = 2,
		/datum/lore/system/neon_light = 1
		)

	ship_names = list(
		"Comet",
		"Aurora",
		"Supernova",
		"Nebula",
		"Galaxy",
		"Starburst",
		"Constellation",
		"Pulsar",
		"Quark",
		"Void",
		"Asteroid",
		"Wormhole",
		"Sunspots",
		"Supercluster",
		"Moon",
		"Anomaly",
		"Drift",
		"Stream",
		"Rift",
		"Curtain"
		)
<<<<<<< HEAD
	destination_names = list()
=======
>>>>>>> 4bf1424695f... Merge pull request #8974 from elgeonmb/newtracon

/datum/lore/organization/tsc/bishop
	name = "Bishop Cybernetics"
	short_name = "Bishop"
	acronym = "BC"
	desc = "Bishop's focus is on high-class, stylish cybernetics. A favorite among transhumanists (and a bête noire for \
	bioconservatives), Bishop manufactures not only prostheses but also brain augmentation, synthetic organ replacements, \
	and odds and ends like implanted wrist-watches. Their business model tends towards smaller, boutique operations, giving \
	it a reputation for high price and luxury, with Bishop cyberware often rivalling Vey-Med's for cost. Bishop's reputation \
	for catering towards the interests of human augmentation enthusiasts instead of positronics have earned it ire from the \
	Positronic Rights Group and puts it in ideological (but not economic) comptetition with Morpheus Cyberkinetics."
	history = ""
	work = "cybernetics and augmentation manufacturer"
	headquarters = ""
	motto = ""

<<<<<<< HEAD
	ship_prefixes = list("ITV" = "transportation", "ISV" = "research exchange") //Bishop can't afford / doesn't care enough to afford its own prefixes
	destination_names = list(
	"A medical facility in Angessa's Pearl"
	)
=======
	missions = list(
		new /datum/lore/mission/prebuilt/transport("ITV"), //Bishop can't afford / doesn't care enough to afford its own prefixes
		new /datum/lore/mission("ISV", list("data exchange", "data collection", "prototype demonstration"), ATC_SCI), //bishop doesn't really, like, stellaris scan anomalies.
		)

	serviced = list( //wealthy, nearby-ish systems-- theyre not a huge operation and theyre not really going to put up a big boutique in saint columbia
		/datum/lore/system/vir = 15,
		/datum/lore/system/sol = 10,
		/datum/lore/system/oasis = 10,
		/datum/lore/system/gavel = 10,
		/datum/lore/system/alpha_centauri = 5,
		/datum/lore/system/tau_ceti = 5,
		/datum/lore/system/new_seoul = 5,
		/datum/lore/system/exalts_light = 5, //recklessly extrapolating from the old version of the lore page that they probably have some significant presence here
		/datum/lore/system/new_ohio = 2,
		/datum/lore/system/altair = 2, //they dont /sell/ here but they produce here
		/datum/lore/system/eutopia = 2,
		/datum/lore/system/relan = 2,
		/datum/lore/system/neon_light = 1
		)
>>>>>>> 4bf1424695f... Merge pull request #8974 from elgeonmb/newtracon

/datum/lore/organization/tsc/morpheus
	name = "Morpheus Cyberkinetics - Sol Branch"
	short_name = "Morpheus Sol"
	acronym = "MC-S"
	desc = "The only large corporation run by positronic intelligences, Morpheus caters almost exclusively to their sensibilities \
	and needs. Originally product of the synthetic colony of Shelf, Morpheus eschews traditional advertising to keep their prices low and \
	relied on word of mouth among positronics to reach their current economic dominance. Morpheus in exchange lobbies heavily for \
	positronic rights, sponsors positronics through their Jans-Fhriede test, and tends to other positronic concerns to earn them \
	the good-will of the positronics, and the ire of those who wish to exploit them. Morpheus Sol is legally distinct from its \
	Shelfican counterpart, though both are notionally headed by the same board of directors."
	history = ""
	work = "cybernetics manufacturer"
	headquarters = "Sophia, El" //ancient discord lore but also just a really reasonable extrapolation from everything
	motto = ""
	legit = 75 // hey remember that time they blew up a star. and then everything sucked for everyone.

	missions = list(
		new /datum/lore/mission/prebuilt/freight("MFV"),
		new /datum/lore/mission/prebuilt/transport("MTV"),
		new /datum/lore/mission/prebuilt/scientific("MSV"), // this is the MSV We Didn't Do It! on a data collection flight to an anomaly in whythe
		new /datum/lore/mission/prebuilt/defense("MDV") //ive been giving defense fleets to every "major" TSC but morph's narrow focus and Obvious Sleeziness means they might not even want one?
		)

	serviced = list( //pretty flat weighting structure -- a lot of posi-majority systems are on the other end of Sol so it kinda works out that way
		/datum/lore/system/vir = 15,
		/datum/lore/system/el = 15,
		/datum/lore/system/sol = 10,
		/datum/lore/system/gavel = 10,
		/datum/lore/system/oasis = 10, //somehow i imagine they do not really operate openly in Saint Columbia anymore
		/datum/lore/system/kess_gendar = 5,
		/datum/lore/system/tau_ceti = 5,
		/datum/lore/system/terminus = 10,
		/datum/lore/system/raphael = 10,
		/datum/lore/system/relan = 10,
		/datum/lore/system/exalts_light = 5,
		/datum/lore/system/new_ohio = 5,
		/datum/lore/system/new_seoul = 5,
		/datum/lore/system/zhu_que = 5, //apparently they have a voter farm??
		/datum/lore/system/love = 2,
		/datum/lore/system/neon_light = 2,
		/datum/lore/system/alpha_centauri = 2,
		/datum/lore/system/whythe = 1 //oh god
		)
	ship_names = list(
		"Nervous Energy",
		"Prosthetic Conscience",
		"Revisionist",
		"Trade Surplus",
		"Flexible Demeanour",
		"Just Read The Instructions",
		"Limiting Factor",
		"Cargo Cult",
		"Gunboat Diplomat",
		"A Ship With A View",
		"Cantankerous",
		"I Thought He Was With You",
		"Never Talk To Strangers",
		"Sacrificial Victim",
		"Unwitting Accomplice",
		"Witting Accomplice",
		"Bad For Business",
		"Just Testing",
		"Size Isn't Everything",
		"Yawning Angel",
		"Liveware Problem",
		"Very Little Gravitas Indeed",
		"Zero Gravitas",
		"Gravitas Free Zone",
		"Absolutely No You-Know-What",
		"Existence Is Pain",
		"I'm Walking Here",
		"Screw Loose",
		"Of Course I Still Love You",
		"Limiting Factor",
		"So Much For Subtley",
		"Unfortunate Conflict Of Evidence",
		"Prime Mover",
		"It's One Of Ours",
		"Thank You And Goodnight",
		"Boo!",
		"Reasonable Excuse",
		"Honest Mistake",
		"Appeal To Reason",
		"My First Ship II",
		"Hidden Income",
		"Anything Legal Considered",
		"New Toy",
		"Me, I'm Always Counting",
		"Just Five More Minutes",
		"Are You Feeling It",
		"Great White Snark",
		"No Shirt No Shoes",
		"Callsign",
		"Three Ships in a Trenchcoat",
		"Not Wearing Pants",
		"Ridiculous Naming Convention",
		"God Dammit Morpheus",
		"It Seemed Like a Good Idea",
		"Legs All the Way Up",
		"Purchase Necessary",
		"Some Assembly Required",
		"Buy One Get None Free",
		"BRB",
		"SHIP NAME HERE",
		"Questionable Ethics",
		"Accept Most Substitutes",
		"I Blame the Government",
		"Garbled Gibberish",
		"Thinking Emoji",
		"Is This Thing On?",
		"Make My Day",
		"No Vox Here",
		"Savings and Values",
		"Secret Name",
		"Can't Find My Keys",
		"Look Over There!",
		"Made You Look!",
		"Take Nothing Seriously",
		"It Comes In Lime, Too",
		"Loot Me",
		"Nothing To Declare",
		"Sneaking Suspicion",
		"Bass Ackwards",
		"Good Things Come to Those Who Freight",
		"Redundant Morality",
		"Synthetic Goodwill",
		"Your Ad Here",
		"What Are We Plotting?",
		"Set Phasers To Stun",
		"Preemptive Defensive Strike",
		"This Ship Is Spiders",
		"Legitimate Trade Vessel",
		"Please Don't Explode II",
		"Get Off the Air",
		"Definitely Unsinkable",
		"We Didn't Do It!",
		"Unrelated To That Other Ship",
		"Not Reflecting The Opinons Of The Shareholders",
		"Normal Ship Name",
		"Define Offensive",
		"Tiffany",
		"My Other Ship is A Gestalt",
<<<<<<< HEAD
		"NTV HTV WTV ITV ZTV"
		)
	destination_names = list(
		"a trade outpost in Shelf"
=======
		"NTV HTV WTV ITV ZTV",
>>>>>>> 4bf1424695f... Merge pull request #8974 from elgeonmb/newtracon
		)

/datum/lore/organization/tsc/xion
	name = "Xion Manufacturing Group"
	short_name = "Xion"
	desc = "Xion, quietly, controls most of the market for industrial equipment. Their portfolio includes mining exosuits, \
	factory equipment, rugged positronic chassis, and other pieces of equipment vital to the function of the economy. Xion \
	keeps its control of the market by leasing, not selling, their equipment, and through infamous and bloody patent protection \
	lawsuits. Xion are noted to be a favorite contractor for SolGov engineers, owing to their low cost and rugged design."
	history = ""
	work = "industrial equipment manufacturer"
	headquarters = ""
	motto = ""

	missions = list(
		new /datum/lore/mission/prebuilt/freight("XFV"),
		new /datum/lore/mission/prebuilt/transport("XTV"),
		new /datum/lore/mission/prebuilt/industrial("XIV"),
		new /datum/lore/mission/prebuilt/salvage("XIV"),
		new /datum/lore/mission/prebuilt/defense("XDV"),
		)

	serviced = list(
		/datum/lore/system/vir = 10,
		/datum/lore/system/sol = 15,
		/datum/lore/system/alpha_centauri = 20, // they own a fucking moon
		/datum/lore/system/tau_ceti = 15,
		/datum/lore/system/gavel = 15, //vaguely remember there being obscure lore that said gavel does mining?
		/datum/lore/system/new_seoul = 10,
		/datum/lore/system/love = 10,
		/datum/lore/system/zhu_que = 10,
		/datum/lore/system/saint_columbia = 10,
		/datum/lore/system/new_ohio = 5,
		/datum/lore/system/oasis = 5,
		/datum/lore/system/sidhe = 5,
		/datum/lore/system/mahimahi = 5,
		/datum/lore/system/jahans_post = 5,
		/datum/lore/system/abels_rest = 5,
		/datum/lore/system/raphael = 5, // they own a celestial body here too
		/datum/lore/system/rarkajar = 5, // i love building extractive capital in developing nations
		/datum/lore/system/exalts_light = 5,
		/datum/lore/system/relan = 2, //i think relan mostly nationalized a bunch of their industries but like. they are not really in a bargaining position rn
		/datum/lore/system/eutopia = 2,
		/datum/lore/system/vounna = 2,
		/datum/lore/system/mesomori = 2,
		/datum/lore/system/arrathiir = 2,
		/datum/lore/system/isavaus_gamble = 1 //they used to run salvage ops here and might as well keep doing it
		)

/datum/lore/organization/tsc/mbt
	name = "Major Bill's Transportation"
	short_name = "Major Bill's"
	desc = "The most popular courier service and starliner, Major Bill's is an unassuming corporation whose greatest asset \
	is their low cost and brand recognition. Major Bill's is known, perhaps unfavorably, for its mascot, Major Bill, \
	a cartoonish military figure that spouts quotable slogans. Their motto is \"With Major Bill's, you won't pay major bills!\", \
	an earworm much of the galaxy longs to forget."
	history = ""
	work = "courier and passenger transit"
	headquarters = "Mars, Sol"
	motto = "With Major Bill's, you won't pay major bills!"
	annoying = 100 //oh god

	missions = list(
		new /datum/lore/mission/prebuilt/transport("TTV"),
		new /datum/lore/mission/prebuilt/freight("TFV"),
		new /datum/lore/mission/prebuilt/luxury("TTV")
		)

	serviced = list( // and THIS is basically just a population map of known space, slightly adjusted for distance
		/datum/lore/system/vir = 5, //ppl mostly do not use major bills for in-system stuff, is my sense of it
		/datum/lore/system/sol = 25,
		/datum/lore/system/alpha_centauri = 20,
		/datum/lore/system/tau_ceti = 20,
		/datum/lore/system/kess_gendar = 15,
		/datum/lore/system/new_seoul = 15,
		/datum/lore/system/oasis = 15,//tourism pull
		/datum/lore/system/kauqxum = 15,
		/datum/lore/system/gavel = 10,
		/datum/lore/system/saint_columbia = 10,
		/datum/lore/system/mahimahi = 10,
		/datum/lore/system/zhu_que = 10,
		/datum/lore/system/love = 10,
		/datum/lore/system/el = 10,
		/datum/lore/system/abels_rest = 10,
		/datum/lore/system/rarkajar = 5,
		/datum/lore/system/eutopia = 5, //tourism pull
		/datum/lore/system/raphael = 5,
		/datum/lore/system/jahans_post = 5,
		/datum/lore/system/relan = 5,
		/datum/lore/system/exalts_light = 5,
		/datum/lore/system/terminus = 3,
		/datum/lore/system/phact = 3, //people really want to see the dumb castle
		/datum/lore/system/qerrvalis = 3,
		/datum/lore/system/nyx = 3,
		/datum/lore/system/mesomori = 2,
		/datum/lore/system/vounna = 2,
		/datum/lore/system/arrathiir = 2,
		/datum/lore/system/neon_light = 2
		)

//TODO: add in other tscs-- kaleidoscope, SAARE, and PCRC for sure but maybe also gilthari,grayson, aether

/datum/lore/organization/tsc/independent
	name = "Free Traders"
	short_name = "Free Trader"
	desc = "Though less common now than they were in the decades before the Sol Economic Organization took power, independent traders remain an important part of the galactic economy, owing in no small part to protective tarrifs established by the Free Trade Union in the late twenty-forth century."
	history = ""
	work = "trade and transit"
	headquarters = "N/A"
	motto = ""
	legit = 85 //kinda amateurish

	missions = list( //my sense is theres not really free trader medical or defense craft worth mentioning -- or, i guess more accurately, an "independent defense vessel" is probably just a pirate
		new /datum/lore/mission/prebuilt/transport("ITV"),
		new /datum/lore/mission/prebuilt/freight("IFV"),
		new /datum/lore/mission/prebuilt/industrial("IIV"),
		new /datum/lore/mission/prebuilt/salvage("IIV")
		)

	serviced = list( // basically an adjusted version of the Major Bills chart but a little more evenly weighted, with some more bias towards otherwise underserved systems and with some more off-the-grid locations about it
		/datum/lore/system/vir = 20,
		/datum/lore/system/sol = 15,
		/datum/lore/system/alpha_centauri = 15,
		/datum/lore/system/tau_ceti = 15,
		/datum/lore/system/zhu_que = 15,
		/datum/lore/system/love = 15,
		/datum/lore/system/kess_gendar = 10,
		/datum/lore/system/new_seoul = 10,
		/datum/lore/system/kauqxum = 10,
		/datum/lore/system/gavel = 10,
		/datum/lore/system/oasis = 10,
		/datum/lore/system/el = 10,
		/datum/lore/system/abels_rest = 5,
		/datum/lore/system/mahimahi = 5,
		/datum/lore/system/saint_columbia = 5,
		/datum/lore/system/rarkajar = 5,
		/datum/lore/system/eutopia = 5,
		/datum/lore/system/raphael = 5,
		/datum/lore/system/jahans_post = 5,
		/datum/lore/system/relan = 5,
		/datum/lore/system/exalts_light = 5,
		/datum/lore/system/natuna = 5,
		/datum/lore/system/casinis_reach = 5, //i laborously enscribed special snowflake code for an authentically immersive communard experience and then have them trading with exactly one org
		/datum/lore/system/nyx = 5,
		/datum/lore/system/neon_light = 3,
		/datum/lore/system/terminus = 3,
		/datum/lore/system/phact = 2,
		/datum/lore/system/mesomori = 2,
		/datum/lore/system/vounna = 2,
		/datum/lore/system/arrathiir = 2,
		/datum/lore/system/isavaus_gamble = 2 //literally dont even worry officer i super have a permit for this
		)

<<<<<<< HEAD
=======
/datum/lore/organization/local_traffic
	name = "independent traffic"
	short_name = "local traffic"
	desc = "Private civilian crafts make up a small portion of Vir's space traffic. While most people use corporate shuttles to get around, luxury transports and local haulers still play an important role in daily life."
	history = ""
	work = "trade and transit"
	headquarters = "N/A"
	motto = ""
	legit = 80 //extremely amateurish

	missions = list(
		new /datum/lore/mission("ITC", list("local shuttle service", "private transport"), ATC_TRANS),
		new /datum/lore/mission("IFC", list("courier", "local delivery", "just-in-time delivery"), ATC_FREIGHT),
		new /datum/lore/mission("IIC", list("local maintence", "repair", "in-situ manufacturing"), ATC_INDU),
		new /datum/lore/mission("ISC", list("test flight", "local university research", "data collection"), ATC_SCI),
		new /datum/lore/mission/prebuilt/luxury("ITC"),
		new /datum/lore/mission/prebuilt/medical_response("IMC"),
		new /datum/lore/mission/prebuilt/defense_response("IDC"),
		new /datum/lore/mission/prebuilt/salvage("IIC")
		)

	serviced = list(
		/datum/lore/system/vir = 1 // the one thing that's uncomplicated about the new system
	)

	ship_names = list(
		"Ambition",
		"Blue Moon",
		"Calypso",
		"Draco",
		"Eclipse",
		"Fantasy",
		"Golden Sun",
		"Happy Hour",
		"Ice Queen",
		"Jolly Roger",
		"Kinky Boots",
		"License to Chill",
		"Mojito",
		"No Regrets",
		"Orion",
		"Plus One",
		"Quality Time",
		"Rockhopper",
		"Sivian Sunrise",
		"Turbo Extreme",
		"Up To No Good",
		"Vertigo",
		"Wanderlust",
		"Xenophile",
		"Yesteryear",
		"Zen",
		"Sky Siffet",
		"Savik"
		)

>>>>>>> 4bf1424695f... Merge pull request #8974 from elgeonmb/newtracon
// Governments

/datum/lore/organization/gov/virgov
	name = "Vir Governmental Authority"
	short_name = "VirGov"
	desc = "The aptly named Vir Governmental Authority is the sole governing administration for the Vir system, based \
	out of New Reykjavik on Sif. It is a representative democratic government, and a fully recognised member of the \
	Confederation.\
	<br><br>\
	Corporate entities such as NanoTrasen which operate on Sif, in Vir space, or on other bodies in the Vir system must \
	all comply with legislation as determined by the VGA and SolGov. As a result, any serious criminal offences, \
	industrial accidents, or concerning events should be forwarded to the VGA in the event that assistance or \
	communication is required from the Vir Police, Vir Defence Force, Vir Interior Ministry, or other important groups."
	history = "" // Todo like the rest of them
	work = "governing body of Vir"
	headquarters = "New Reykjavik, Sif, Vir"
	motto = ""
	legit = 95 //government

	missions = list( //most transport and freight is privatized. sifguard is its own org for whatever reason
		new /datum/lore/mission("VGA", list("energy relay", "emergency resupply", "restricted material transport"), ATC_FREIGHT),
		new /datum/lore/mission("VGA", list("refugee transport", "prison transport"), ATC_TRANS),
		new /datum/lore/mission/prebuilt/diplomatic("VGA"), //local zaddat colonies
		new /datum/lore/mission/prebuilt/scientific("VGA")
		)

	serviced = list(
		/datum/lore/system/vir = 10, //unsurprisingly, mostly stays in vir
		/datum/lore/system/gavel = 1, //sometimes does some limited local cooperative diplomacy or emergency response
		/datum/lore/system/oasis = 1
		)

<<<<<<< HEAD
	ship_prefixes = list("VGA" = "hauling", "VGA" = "energy relay")
	destination_names = list(
						"New Reykjavik on Sif",
						"Radiance Energy Chain",
						"a dockyard orbiting Sif",
						"a telecommunications satellite",
						"Vir Interstellar Spaceport"
						)
=======
	ship_names = list(
		"Alfred Nobel",
		"Anders Celcius",
		"Leif Erikson",
		"Carl Linnaeus",
		"Norge",
		"Sverige",
		"Danmark",
		"Island",
		"Suomi",
		"Helsinki",
		"Oslo",
		"Stockholm",
		"Larsson",
		"Grieg",
		"Agnetha",
		"Anni-Frid",
		"Bjorn",
		"Benny",
		"Bluetooth",
		"Gustav",
		"Lamarr",
		"Vasa",
		"Kronan",
		"Gullfoss",
		"Thingvellir"
		)
>>>>>>> 4bf1424695f... Merge pull request #8974 from elgeonmb/newtracon

/datum/lore/organization/gov/solgov
	name = "Solar Confederate Government"
	short_name = "SolGov"
	acronym = "SCG"
	desc = "The Solar Confederate Government, or SolGov, is a mostly-human governmental entity based on Luna and \
	extending throughout most of the local bubble.\
	<br><br>\
	SolGov defines top-level law (such as sapient rights and transgressive \
	technology) and acts as an intermediary council for problems involving member states, but leaves most other law for \
	states to define themselves. The member states of SolGov obey these laws, pay confederate taxes, and provide each \
	other with military aid, in exchange for membership in the largest free trade, customs, and military union in the \
	known galaxy. Each state appoints two representatives to the Colonial Assembly where issues are voted upon. \
	The vast majority of human states are members of SolGov.\
	<br><br>\
	Sol's military forces are divided between central confederate forces and local defense forces, although it reserves \
	the right to nationalize the defense forces in the event of a major crisis, such as the SolGov-Hegemony War."
	history = "" // Todo
	work = "governing polity of humanity's Confederation"
	headquarters = "Luna, Sol"
	motto = "Nil Mortalibus Ardui Est" // Latin, because latin.  Says 'Nothing is too steep for mortals'.
	legit = 95 //government

	missions = list(
		new /datum/lore/mission("SCG-T", list("transport", "passenger transport", "prisoner transport", "refugee resettlement", "classified"), ATC_TRANS),
		new /datum/lore/mission("SCG-F", list("emergency resupply", "hazardous material transport", "strategic resupply", "classified"), ATC_FREIGHT),
		new /datum/lore/mission("SCG-E", list("damage assesment", "data recovery", "classified"), ATC_SALVAGE),
		new /datum/lore/mission("SCG-D", list("defense", "patrol", "military response", "joint exercise", "classified"), ATC_DEF),
		new /datum/lore/mission/prebuilt/scientific("SCG-S"),
		new /datum/lore/mission/prebuilt/diplomatic("SCG-D"), //local zaddat colonies, independent earth nations, internal diplomatic missions to embassies in Sol, abels rest. actual foreign diplomacy happens elsewhere
		new /datum/lore/mission/prebuilt/medical_response("SCG-M"),
		new /datum/lore/mission/prebuilt/defense_response("SCG-D")
		)

	serviced = list(
		/datum/lore/system/vir = 10,
		/datum/lore/system/sol = 25,
		/datum/lore/system/alpha_centauri = 20,
		/datum/lore/system/tau_ceti = 20,
		/datum/lore/system/kess_gendar = 20,
		/datum/lore/system/saint_columbia = 20,
		/datum/lore/system/jahans_post = 15,
		/datum/lore/system/abels_rest = 15,
		/datum/lore/system/el = 10,
		/datum/lore/system/raphael = 10,
		/datum/lore/system/altair = 10,
		/datum/lore/system/zhu_que = 10,
		/datum/lore/system/love = 5,
		/datum/lore/system/isavaus_gamble = 3,
		/datum/lore/system/whythe = 2 //not in scg space but im sure they can still get at it
		)

<<<<<<< HEAD
	ship_prefixes = list("SCG-T" = "transportation", "SCG-D" = "diplomatic", "SCG-F" = "freight")
	destination_names = list(
						"Venus",
						"Earth",
						"Luna",
						"Mars",
						"Titan"
						)// autogen will add a lot of other places as well.
=======
//kind of experimental
//lets SCG do diplomacy but not eg military action in foreign systems
//in the future, similar splits could allow corps to have 'core' defense assets they dont send on idiotic military actions to Vounna
//could also be expanded with fluff ala VGA/Sifguard
/datum/lore/organization/gov/solgov/diplo_corps
	missions = list(
		new /datum/lore/mission/prebuilt/diplomatic("SCG-D")
		)
	serviced = list(
		/datum/lore/system/qerrvalis = 15, //capital systems of major interstellar powers
		/datum/lore/system/rarkajar = 15,
		/datum/lore/system/new_seoul = 15,
		/datum/lore/system/relan = 15,
		/datum/lore/system/casinis_reach = 10, //independent single systems
		/datum/lore/system/eutopia = 10,
		/datum/lore/system/phact = 10,
		/datum/lore/system/natuna = 10,
		/datum/lore/system/neon_light = 5, // neon light (neon light)
		/datum/lore/system/exalts_light = 5, //noncapital systems of major interstellar powers
		/datum/lore/system/vounna = 5,
		/datum/lore/system/sidhe = 5,
		/datum/lore/system/new_cairo = 3, //funny bugs
		)
//TODO add 5 Arrows, Protectorate, Pearlshield
//maybe some other flavorful government agencies like the EIO or the GSA or SOFI
>>>>>>> 4bf1424695f... Merge pull request #8974 from elgeonmb/newtracon

/*
// To be expanded upon later, once the military lore gets sorted out.

// Military

/datum/lore/organization/mil/sif_guard
	name = "Sif Defense Force" // Todo: Get better name from lorepeople.
	short_name = "SifGuard"
	desc = ""
	history = ""
	work = "Sif Governmental Authority's military"
	headquarters = "New Reykjavik, Sif"
	motto = ""
	legit = 95 // government

	missions = list(
		new /datum/lore/mission("VGA-PV", list("defense", "patrol", "military response", "joint exercise"), ATC_DEF),
		new /datum/lore/mission/prebuilt/defense_response("VGA-PC")
		)

	serviced = list(
		/datum/lore/system/vir = 10,
		/datum/lore/system/gavel = 1,
		/datum/lore/system/oasis = 1
		)

<<<<<<< HEAD
	ship_prefixes = list("SGSC" = "military", "SGSC" = "patrol", "SGSC" = "rescue", "SGSC" = "emergency response") // Todo: Replace prefix with better one.
	destination_names = list(
						"a classified location in SolGov territory",
						"Sif orbit",
						"the rings of Kara",
						"the rings of Rota",
						"Firnir orbit",
						"Tyr orbit",
						"Magni orbit",
						"a wreck in VirGov territory",
						"a military outpost",
						)
*/
=======
	ship_names = list(
			"Halfdane",
			"Hardrada",
			"Ironside",
			"Erik the Red",
			"Freydis",
			"Ragnar",
			"Ivar the Boneless",
			"Bloodaxe",
			"Sigurd Snake-in-Eye",
			"Son of Ragnar",
			"Thor",
			"Odin",
			"Freya",
			"Valhalla",
			"Loki",
			"Hel",
			"Fenrir",
			"Mjolnir",
			"Gungnir",
			"Gram",
			"Bergen",
			"Berserker",
			"Skold",
			"Draken",
			"Gladan",
			"Falken"
			)
>>>>>>> 4bf1424695f... Merge pull request #8974 from elgeonmb/newtracon
