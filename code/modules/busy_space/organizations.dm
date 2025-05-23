//Datums for different factions that can be used by busy_space
/datum/lore/organization
	var/name = ""				// Organization's name
	var/short_name = ""			// Organization's shortname (NanoTrasen for "NanoTrasen Incorporated")
	var/acronym = ""			// Organization's acronym, e.g. 'NT' for NanoTrasen'.
	var/desc = ""				// One or two paragraph description of the organization, but only current stuff.  Currently unused.
	var/history = ""			// Historical discription of the organization's origins  Currently unused.
	var/work = ""				// Short description of their work, eg "an arms manufacturer"
	var/headquarters = ""		// Location of the organization's HQ.  Currently unused.
	var/motto = ""				// A motto/jingle/whatever, if they have one.  Currently unused.

	var/list/ship_prefixes = list()	//Some might have more than one! Like NanoTrasen. Value is the mission they perform, e.g. ("ABC" = "mission desc")
	var/complex_tasks = FALSE	//enables complex task generation

	//how does it work? simple: if you have complex tasks enabled, it goes; PREFIX + TASK_TYPE + FLIGHT_TYPE
	//e.g. NDV = Asset Protection + Patrol + Flight
	//this overrides the standard PREFIX = TASK logic and allows you to use the ship prefix for subfactions (warbands, religions, whatever) within a faction, and define task_types at the faction level
	//task_types are picked from completely at random in air_traffic.dm, much like flight_types, so be careful not to potentially create combos that make no sense!

	var/list/task_types = list(
			"logistics",
			"patrol",
			"training",
			"peacekeeping",
			"escort",
			"search and rescue"
			)
	var/list/flight_types = list(		//operations and flights - we can override this if we want to remove the military-sounding ones or add our own
			"flight",
			"mission",
			"route",
			"assignment"
			)
	var/list/ship_names = list(		//Names of spaceships.  This is a mostly generic list that all the other organizations inherit from if they don't have anything better.
			"Scout",
			"Beacon",
			"Signal",
			"Freedom",
			"Liberty",
			"Enterprise",
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
			"Ascendant",
			"Tenacious",
			"Pioneer",
			"Surveyor",
			"Haste",
			"Radiant",
			"Luminous",
			"Calypso",
			"Eclipse",
			"Maverick",
			"Polaris",
			"Northstar",
			"Orion",
			"Odyssey",
			"Relentless",
			"Valor",
			"Zodiac",
			"Avenger",
			"Defiant",
			"Dauntless",
			"Interceptor",
			"Providence",
			"Thunderchild",
			"Defender",
			"Ranger",
			"River",
			"Jubilee",
			"Gumdrop",
			"Spider",
			"Columbia",
			"Eagle",
			"Intrepid",
			"Odyssey",
			"Aquarius",
			"Kitty Hawk",
			"Antares",
			"Falcon",
			"Casper",
			"Orion",
			"Columbia",
			"Atlantis",
			"Enterprise",
			"Challenger",
			"Pathfinder",
			"Buran",
			"Aldrin",
			"Armstrong",
			"Tranquility",
			"Nostrodamus",
			"Soyuz",
			"Cosmos",
			"Sputnik",
			"Belka",
			"Strelka",
			"Gagarin",
			"Shepard",
			"Tereshkova",
			"Leonov",
			"Vostok",
			"Apollo",
			"Mir",
			"Titan",
			"Serenity",
			"Andiamo",
			"Aurora",
			"Phoenix",
			"Wayward Phoenix",
			"Lucky",
			"Raven",
			"Valkyrie",
			"Halcyon",
			"Nakatomi",
			"Cutlass",
			"Unicorn",
			"Sheepdog",
			"Arcadia",
			"Gigantic",
			"Goliath",
			"Pequod",
			"Poseidon",
			"Venture",
			"Evergreen",
			"Natal",
			"Maru",
			"Djinn",
			"Witch",
			"Wolf",
			"Lone Star",
			"Grey Fox",
			"Dutchman",
			"Sultana",
			"Siren",
			"Venus",
			"Anastasia",
			"Rasputin",
			"Stride",
			"Suzaku",
			"Hathor",
			"Dream",
			"Gaia",
			"Ibis",
			"Progress",
			"Olympic",
			"Venture",
			"Brazil",
			"Tiger",
			"Hedgehog",
			"Potemkin",
			"Fountainhead",
			"Sinbad",
			"Esteban",
			"Mumbai",
			"Shanghai",
			"Madagascar",
			"Kampala",
			"Bangkok",
			"Emerald",
			"Guo Hong",
			"Shun Kai",
			"Fu Xing",
			"Zhenyang",
			"Da Qing",
			"Rascal",
			"Flamingo",
			"Jackal",
			"Andromeda",
			"Ferryman",
			"Panchatantra",
			"Nunda",
			"Fortune",
			"New Dawn",
			"Fionn MacCool",
			"Red Bird",
			"Star Rat",
			"Cwn Annwn",
			"Morning Swan",
			"Black Cat",
			"Challenger",
			"Freshly Baked",
			"Citrus Punch",
			"Made With Real Fruit",
			"Big D",
			"Shaken, Not Stirred",
			"Stirred, Not Shaken",
			"Neither Shaken Nor Stirred",
			"Shaken And Stirred",
			"Freedom Ain't Free",
			"Pay It Forward",
			"All Expenses Paid",
			"Tanstaafl", /* There Ain't No Such Thing As A Free Lunch */
			"Hold My Beer",
			"Das Bootleg",
			"Unplanned Lithobraking Incident",
			"Unknown Accelerant",
			"Mildly Flammable",
			"Wave Goodbye",
			"Hugh Mann",
			"Savage Chicken",
			"Homestead",
			"Peacekeeper",
			"Eminent Domain",
			"Clear Sky",
			"Midnight Light",
			"Daedalus",
			"Redline",
			"Wild Dog",
			"Black Eagle",
			"Sovereign Citizen",
			"Event Horizon",
			"Monte Carlo",
			"Ace of Spades",
			"Dead Man's Hand",
			"Big Blind",
			"Royal Flush",
			"Full House",
			"Wildcard",
			"Wild Card",
			"Blackjack",
			"Three of a Kind",
			"Three's Company",
			"Know When To Fold 'Em",
			"Icebreaker",
			"Megalith",
			"Agnus Dei",
			"Picasso",
			"Spirit of Alliance",
			"Surrounded By Idiots",
			"Honk If You Can Read This",
			"Personal Space Invader",
			"Sufficient Velocity",
			"Credible Deniability",
			"Crucible",
			"Nostromo",
			"Dance Like You Mean It",
			"Birthday Suit",
			"Sinking Feeling",
			"No Refunds",
			"No Solicitors",
			"Dream of Independence",
			"Tunguska",
			"Kugelblitz",
			"Supermassive Black Hole",
			"Knight of Cydonia",
			"Guiding Light",
			"Unnatural Selection",
			"Stockholm Syndrome",
			"False King",
			"Bombshell",
			"Walking Disaster",
			"Two-Body Problem",
			"Instrument of Violence",
			"Entropic Whisper",
			"Cash and Prizes",
			"Crash Course",
			"Wheel of Fortune",
			"Little Light",
			"Leave Only Footprints",
			"Dead Man's Tale",
			"The Next Big Thing",
			"Some Disassembly Required",
			"Some Assembly Required",
			"Just Read The Manual",
			"Spoiler Alert",
			"Bad News",
			"Lucky Pants",
			"No Hard Feelings",
			"Waste Not, Want Not",
			"Beowulf",
			"Inheritor",
			"Anthropocene Denier",
			"Bonaventure",
			"Nothing Ventured",
			"Go West",
			"Once Upon A Time",
			"Don't Worry About It",
			"Bygones Be",
			"Just Capital",
			"Delight",
			"Valdez",
			"Pioneer",
			"Antilles",
			"Explorer",
			"Number Crunch",
			"Until Dawn",
			"Pistols at Dawn",
			"Right Side",
			"Merchant Prince",
			"Merchant Princess",
			"Merchant King",
			"Merchant Queen",
			"Merchant's Pride",
			"Golden Son",
			"Trade Law",
			"Onward",
			"Wanderer",
			"Rocky Start",
			"Downtown",
			"Risk Reward",
			"Culture Shock",
			"Ambition",
			"Vigor",
			"Vigilant",
			"Courageous",
			"Profit Vanguard",
			"Free Market",
			"Market Speculation",
			"Banker's Dozen",
			"Adventure",
			"Profiteer",
			"Wrong Side",
			"Final Notice",
			"Tax Man",
			"Ferryman",
			"Hangman",
			"Cattlecar",
			"Runtime Error",
			"For Sale, Cheap",
			"Starfarer",
			"Drifter",
			"Windward",
			"Hostile Takeover",
			"Tax Loop",
			"Fortune's Fancy",
			"Fortuna",
			"Inside Outside",
			"Galley",
			"Constellation",
			"Dromedarii",
			"Golden Hand",
			"White Company",
			"Haggler",
			"Rendezvous",
			"Two For Flinching",
			"Uninvited Guest",
			"Iconoclast",
			"Bluespace Tourist"
			)
	var/list/added_ship_names = list()	//List of ship names to add to the above, rather than wholesale replacing
	var/list/destination_names = list()	//Names of static holdings that the organization's ships visit
	var/append_ship_names = FALSE

	var/org_type = "neutral"		//Valid options are "neutral", "corporate", "government", "system defense", "military, "smuggler", & "pirate"
	var/autogenerate_destination_names = TRUE //Pad the destination lists with some extra random ones? see the proc below for info on that

	var/slogans = list("This is a placeholder slogan, ding dong!")			//Advertising slogans. Who doesn't want more obnoxiousness on the radio? Picked at random each time the slogan event fires. This has a placeholder so it doesn't runtime on trying to draw from a 0-length list in the event that new corps are added without full support.

/datum/lore/organization/New()
	..()

	if(append_ship_names)
		ship_names.Add(added_ship_names)

	if(autogenerate_destination_names) // Lets pad out the destination names.
		var/i = rand(20, 30) //significantly increased from original values due to the greater length of rounds

		//known planets and exoplanets, plus fictional ones
		var/list/planets = list(
			/* real planets in our solar system */
			"Earth","Luna","Mars","Titan","Europa",
			/* named exoplanets, god knows if they're habitable */
			"Spe","Arion","Arkas","Orbitar","Dimidium",
			"Galileo","Brahe","Lipperhey","Janssen","Harriot",
			"Aegir","Amateru","Dagon","Meztli","Smertrios",
			"Hypatia","Quijote","Dulcinea","Rocinante","Sancho",
			"Thestias","Saffar","Samh","Majriti","Fortitudo",
			"Draugr","Arber","Tassili","Madriu","Naqaya",
			"Bocaprins","Yanyan","Sissi","Tondra","Eburonia",
			"Drukyul","Yvaga","Naron","Guarani","Mastika",
			"Bendida","Nakanbe","Awasis","Caleuche","Wangshu",
			"Melquiades","Pipitea","Ditso","Asye","Veles",
			"Finlay","Onasilos","Makropolus","Surt","Boinayel",
			"Eyeke","Cayahuanca","Hamarik","Abol","Hiisi",
			"Belisama","Mintome","Neri","Toge","Iolaus",
			"Koyopa","Independence","Ixbalanque","Magor","Fold",
			"Santamasa","Noifasui","Kavian","Babylonia","Bran",
			"Alef","Lete","Chura","Wadirum","Buru",
			"Umbaasaa","Vytis","Peitruss","Trimobe","Baiduri",
			"Ggantija","Cuptor","Xolotl","Isli","Hairu",
			"Bagan","Laligurans","Kereru","Equiano","Albmi",
			"Perwana","Pollera","Tumearandu","Sumajmajta","Haik",
			"Leklsullun","Pirx","Viriato","Aumatex","Negoiu",
			"Teberda","Dopere","Vlasina","Viculus","Kralomoc",
			"Iztok","Krotoa","Halla","Riosar","Samagiya",
			"Isagel","Eiger","Ugarit","Sazum","Maeping",
			"Agouto","Ramajay","Khomsa","Gokturk","Barajeel",
			"Cruinlagh","Mulchatria","Ibirapita","Madalitso",
			/* fictional planets from polarislore */
			"Sif","Kara","Rota","Root","Toledo, New Ohio",
			"Meralar","Adhomai","Binma","Kishar","Anshar",
			"Nisp","Elysium","Sophia, El","New Kyoto",
			"Angessa's Pearl, Exalt's Light","Oasis","Love"
			)

		//existing systems, pruned for duplicates, includes systems that contain suspected or confirmed exoplanets
		var/list/systems = list(
			/* real solar systems, specifically ones that have possible planets */
			"Sol","Alpha Centauri","Sirius","Vega","Tau Ceti",
			"Altair","Epsilon Eridani","Fomalhaut","Mu Arae","Pollux",
			"Wolf 359","Ross 128","Gliese 1061","Luyten's Star","Teegarden's Star",
			"Kapteyn","Wolf 1061","Aldebaran","Proxima Centauri","Kepler-90",
			"HD 10180","HR 8832","TRAPPIST-1","55 Cancri","Gliese 876",
			"Upsilon Andromidae","Mu Arae","WASP-47","82 G. Eridani","Rho Coronae Borealis",
			"Pi Mensae","Beta Pictoris","Gamma Librae","Gliese 667 C","LHS 1140",
			"Phact",
			/* fictional systems from Polaris and other sources*/
			"Zhu Que","Oasis","Vir","Gavel","Ganesha",
			"Sidhe","New Ohio","Parvati","Mahi-Mahi","Nyx",
			"New Seoul","Kess-Gendar","Raphael","El","Eutopia",
			/* skrell */
			"Qerr'valis","Harr'Qak","Qerrna-Lakirr","Kauq'xum",
			/* tajaran */
			"Rarkajar","Arrakthiir","Mesomori",
			/* other */
			"Vazzend","Thoth","Jahan's Post","Silk","New Singapore",
			"Stove","Viola","Isavau's Gamble","Samsara",
			"Vounna","Relan","Whythe","Exalt's Light","Van Zandt",
			/* generic territories */
			"deep space",
			"Commonwealth space",
			"Commonwealth territory",
			"ArCon space",
			"ArCon territory",
			"independent space",
			"a demilitarized zone",
			"Elysian space",
			"Elysian territory",
			"Salthan space",
			"Salthan territory",
			"Skrell space",
			"Skrell territories",
			"Tajaran space",
			"Hegemonic space",
			"Hegemonic territory"
			)
		var/list/owners = list("a government", "a civilian", "a corporate", "a private", "an independent", "a military")
		var/list/purpose = list("an exploration", "a trade", "a research", "a survey", "a military", "a mercenary", "a corporate", "a civilian", "an independent")

		//unique or special locations
		var/list/unique = list("the Jovian subcluster","Isavau International Spaceport","Terminus Station","Casini's Reach","the Shelf flotilla","the Ue'Orsi flotilla","|Heaven| Orbital Complex, Alpha Centauri","the |Saint Columbia| Complex")

		var/list/orbitals = list("[pick(owners)] shipyard","[pick(owners)] dockyard","[pick(owners)] station","[pick(owners)] vessel","a habitat","[pick(owners)] refinery","[pick(owners)] research facility","an industrial platform","[pick(owners)] installation")
		var/list/surface = list("a colony","a settlement","a trade outpost","[pick(owners)] supply depot","a fuel depot","[pick(owners)] installation","[pick(owners)] research facility")
		var/list/deepspace = list("[pick(owners)] asteroid base","a freeport","[pick(owners)] shipyard","[pick(owners)] dockyard","[pick(owners)] station","[pick(owners)] vessel","[pick(owners)] habitat","a trade outpost","[pick(owners)] supply depot","a fuel depot","[pick(owners)] installation","[pick(owners)] research facility")
		var/list/frontier = list("[pick(purpose)] [pick("ship","vessel","outpost")]","a waystation","an outpost","a settlement","a colony")

		//patterns; orbital ("an x orbiting y"), surface ("an x on y"), deep space ("an x in y"), the frontier ("an x on the frontier")
		//biased towards inhabited space sites
		while(i)
			destination_names.Add("[pick("[pick(orbitals)] orbiting [pick(planets)]","[pick(surface)] on [pick(planets)]","[pick(deepspace)] in [pick(systems)]",20;"[pick(unique)]",30;"[pick(frontier)] on the frontier")]")
			i--
		//extensive rework for a much greater degree of variety compared to the old system, lists now include known exoplanets and star systems currently suspected or confirmed to have exoplanets

//////////////////////////////////////////////////////////////////////////////////

// TSCs
/datum/lore/organization/tsc/nanotrasen
	name = "NanoTrasen Incorporated"
	short_name = "NanoTrasen"
	acronym = "NT"
	desc = "NanoTrasen is one of the foremost research and development companies in Commonwealth space. \
	Originally focused on consumer products, their swift move into the field of Phoron has lead to \
	them being the foremost experts on the substance and its uses. In the modern day, NanoTrasen prides \
	itself on being an early adopter to as many new technologies as possible, often offering the newest \
	products to their employees. In an effort to combat complaints about being 'guinea pigs', Nanotrasen \
	also offers one of the most comprehensive medical plans in Commonwealth space, up to and including cloning, \
	resleeving, and therapy.\
	<br><br>\
	NT's most well known products are its phoron based creations, especially those used in Cryotherapy. \
	It also boasts a prosthetic line, which is provided to its employees as needed, and is used as an incentive \
	for newly tested posibrains to remain with the company. \
	<br><br>\
	NT's ships are named for famous scientists."
	history = "" // To be written someday.
	work = "research giant"
	headquarters = "Luna, Sol"
	motto = ""

	org_type = "corporate"
	slogans = list(
			"NanoTrasen - Phoron Makes The Galaxy Go 'Round.",
			"NanoTrasen - Join for the Medical, stay for the Company.",
			"NanoTrasen - Advancing Humanity."
			)
	ship_prefixes = list("NTV" = "a general operations", "NEV" = "an exploration", "NGV" = "a hauling", "NDV" = "a patrol", "NRV" = "an emergency response", "NDV" = "an asset protection")
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
			"Edison",
			"Cavendish",
			"Nye",
			"Hawking",
			"Aristotle",
			"Kaku",
			"Oppenheimer",
			"Renwick",
			"Hubble",
			"Alcubierre",
			"Glass"
			)
	// Note that the current station being used will be pruned from this list upon being instantiated
	destination_names = list(
			"NT HQ on Luna",
			"NSS Exodus in Nyx",
			"NCS Northern Star in Vir",
			"NLS Southern Cross in Vir",
			"NAS Vir Central Command",
			"NAB Smythside Central Headquarters in Sol",
			"NAS Zeus orbiting Virgo-Prime",
			"NIB Posideon in Alpha Centauri",
			"NTB Anur on Virgo-Prime",
			"NSB Adephagia in Virgo-Erigone",
			"NSB Rascal's Pass in Virgo-Erigone",
			"NRV |Stellar Delight| in Virgo-Erigone",
			"NRV |Von Braun| in Virgo-Erigone",
			"a phoron refinery in Vilous",
			"a dockyard orbiting Virgo-Prime",
			"an asteroid orbiting Virgo 3",
			"Vir Interstellar Spaceport"
			)

/datum/lore/organization/tsc/nanotrasen/New()
	..()
	spawn(1) // BYOND shenanigans means using_map is not initialized yet.  Wait a tick.
		// Get rid of the current map from the list, so ships flying in don't say they're coming to the current map.
		var/string_to_test = "[using_map.station_name] in [using_map.starsys_name]"
		if(string_to_test in destination_names)
			destination_names.Remove(string_to_test)

/datum/lore/organization/tsc/hephaestus
	name = "Hephaestus Industries"
	short_name = "Hephaestus"
	acronym = "HI"
	desc = "Hephaestus Industries is the largest supplier of arms, ammunition, and small millitary vehicles in Commonwealth space. \
	Hephaestus products have a reputation for reliability, and the corporation itself has a noted tendency to stay removed \
	from corporate politics. They enforce their neutrality with the help of a fairly large asset-protection contingent which \
	prevents any contracting polities from using their own materiel against them. The Commonwealth itself is one of Hephaestus' largest \
	bulk contractors owing to the above factors. \
	<br><br> \
	Hephaestus' fleet uses identifiers from various deities and spirits of war from Earth's various belief systems."
	history = ""
	work = "arms manufacturer"
	headquarters = "Luna, Sol"
	motto = ""

	org_type = "corporate"
	slogans = list(
			"+Hephaestus Arms!+ - When it comes to +personal protection+, +nobody+ does it +better+.",
			"+Hephaestus Arms!+ - Peace through +Superior Firepower+.",
			"+Hephaestus Arms!+ - Don't be caught +firing blanks+.",
			"+Hephaestus Arms!+ - If in doubt, give 'em +both barrels!+"
			)
	ship_prefixes = list("HCV" = "a general operations", "HTV" = "a freight", "HLV" = "a munitions resupply", "HDV" = "an asset protection", "HDV" = "a preemptive deployment")
	//War God Theme, updated
	append_ship_names = TRUE
	added_ship_names = list(
			"Anhur",
			"Bast",
			"Horus",
			"Maahes",
			"Neith",
			"Pakhet",
			"Sekhmet",
			"Set",
			"Sobek",
			"Maher",
			"Kokou",
			"Ogoun",
			"Oya",
			"Kovas",
			"Agrona",
			"Andraste",
			"Anann",
			"Badb",
			"Belatucadros",
			"Cicolluis",
			"Macha",
			"Neit",
			"Nemain",
			"Rudianos",
			"Chiyou",
			"Guan Yu",
			"Jinzha",
			"Nezha",
			"Zhao Lang",
			"Laran",
			"Menrva",
			"Tyr",
			"Woden",
			"Freya",
			"Odin",
			"Ullr",
			"Ares",
			"Deimos",
			"Enyo",
			"Kratos",
			"Kartikeya",
			"Mangala",
			"Parvati",
			"Shiva",
			"Vishnu",
			"Shaushka",
			"Wurrukatte",
			"Hadur",
			"Futsunushi",
			"Sarutahiko",
			"Takemikazuchi",
			"Neto",
			"Agasaya",
			"Belus",
			"Ishtar",
			"Shala",
			"Huitzilopochtli",
			"Tlaloc",
			"Xipe-Totec",
			"Qamaits",
			"'Oro",
			"Rongo",
			"Ku",
			"Pele",
			"Maru",
			"Tumatauenga",
			"Bellona",
			"Juno",
			"Mars",
			"Minerva",
			"Victoria",
			"Anat",
			"Astarte",
			"Perun",
			"Cao Lo"
			)
	destination_names = list(
			"our headquarters on Luna",
			"a Commonwealth dockyard on Luna",
			"a Fleet outpost in the Almach Rim",
			"a Fleet outpost on the Moghes border"
			)

/datum/lore/organization/tsc/vey_med
	name = "Vey-Medical" //The Wiki displays them as Vey-Medical.
	short_name = "Vey-Med"
	acronym = "VM"
	desc = "Vey-Med is one of the newer TSCs on the block and is notable for being largely owned and operated by Skrell. \
	Despite the suspicion and prejudice leveled at them for their alien origin, Vey-Med has obtained market dominance in \
	the sale of medical equipment-- from surgical tools to large medical devices to the Odysseus trauma response mecha \
	and everything in between. Their equipment tends to be top-of-the-line, most obviously shown by their incredibly \
	human-like FBP designs. Vey's rise to stardom came from their introduction of resurrective cloning, although in \
	recent years they've been forced to diversify as their patents expired and NanoTrasen-made medications became \
	essential to modern cloning and resleeving procedures. \
	<br><br> \
	For reasons known only to the board, Vey-Med's ship names seem to follow the same naming pattern as the Dionae use."
	history = ""
	work = "medical equipment supplier"
	headquarters = "Toledo, New Ohio"
	motto = ""

	org_type = "corporate"
	slogans = list(
			"Vey-Medical. Medical care you can trust.",
			"Vey-Medical. Only the finest in surgical equipment.",
			"Vey-Medical. Because your patients deserve the best."
			)
	ship_prefixes = list("VMV" = "a general operations", "VTV" = "a transportation", "VHV" = "a medical resupply", "VSV" = "a research", "VRV" = "an emergency medical support")
	// Diona names, mostly
	append_ship_names = TRUE
	added_ship_names = list(
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
			"Still Water Upon An Endless Shore",
			"Sunlight Glitters Upon Tranquil Sands",
			"Growth Within The Darkest Abyss",
			"Joy Without Which The World Would Come Undone",
			"A Thousand Thousand Planets Dangling From Branches",
			"Light Streaming Through Interminable Branches",
			"Smoke Brought Up From A Terrible Fire",
			"Light of Qerr'Valis",
			"King Xae'uoque",
			"Memory of Kel'xi",
			"Xi'Kroo's Herald"
			)
	destination_names = list(
			"our headquarters on Toledo, New Ohio",
			"a research facility in Samsara",
			"a sapientarian mission in the Almach Rim"
			)

/datum/lore/organization/tsc/zeng_hu
	name = "Zeng-Hu Pharmaceuticals"
	short_name = "Zeng-Hu"
	acronym = "ZH"
	desc = "Zeng-Hu is an old TSC, based in the Sol system. Until the discovery of Phoron, Zeng-Hu maintained a stranglehold \
	on the market for medications, and many household names are patented by Zeng-Hu-- Bicaridine, Dylovene, Tricordrazine, \
	and Dexalin all came from Zeng-Hu medical laboratories. Zeng-Hu's fortunes have been in decline as Nanotrasen's near monopoly \
	on phoron and cloning research cuts into their R&D and Vey-Med's superior medical equipment effectively decimated their own equipment \
	interests. The three-way rivalry between these companies for dominance in the medical field is well-known and a matter of \
	constant economic speculation. \
	<br><br> \
	Not to be outdone by NT in the recognition of famous figures, Zeng-Hu has adopted the names of famous physicians for their fleet."
	history = ""
	work = "pharmaceuticals company"
	headquarters = "Earth, Sol"
	motto = ""

	org_type = "corporate"
	slogans = list(
			"Zeng-Hu! WE make the medicines that YOU need!",
			"Zeng-Hu! Having acid reflux problems? Consult your local physician to see if Dylovene is right for YOU!",
			"Zeng-Hu! Tired of getting left in the dust? Try Hyperzine! You'll never fall behind again!",
			"Zeng-Hu! Life's aches and pains getting to you? Try Tramadol - available at any good pharmacy!"
			)
	ship_prefixes = list("ZHV" = "a general operations", "ZTV" = "a transportation", "ZMV" = "a medical resupply", "ZRV" = "a medical research")
	//ship names: a selection of famous physicians who advanced the cause of medicine
	append_ship_names = TRUE
	added_ship_names = list(
			"Averroes",
			"Avicenna",
			"Banting",
			"Billroth",
			"Blackwell",
			"Blalock",
			"Charaka",
			"Chauliac",
			"Cushing",
			"Domagk",
			"Galen",
			"Fauchard",
			"Favaloro",
			"Fleming",
			"Fracastoro",
			"Goodfellow",
			"Gray",
			"Harvey",
			"Heimlich",
			"Hippocrates",
			"Hunter",
			"Isselbacher",
			"Jenner",
			"Joslin",
			"Kocher",
			"Laennec",
			"Lane-Claypon",
			"Lister",
			"Lower",
			"Madhav",
			"Maimonides",
			"Marshall",
			"Mayo",
			"Meyerhof",
			"Minot",
			"Morton",
			"Needleman",
			"Nicolle",
			"Osler",
			"Penfield",
			"Raichle",
			"Ransohoff",
			"Rhazes",
			"Semmelweis",
			"Starzl",
			"Still",
			"Susruta",
			"Urbani",
			"Vesalius",
			"Vidius",
			"Whipple",
			"White",
			"Worcestor",
			"Yegorov",
			"Xichun"
			)
	destination_names = list(
			"our headquarters on Earth"
			)

/datum/lore/organization/tsc/ward_takahashi
	name = "Ward-Takahashi General Manufacturing Conglomerate"
	short_name = "Ward-Takahashi"
	acronym = "WT"
	desc = "Ward-Takahashi focuses on the sale of small consumer electronics, with its computers, communicators, \
	and even mid-class automobiles a fixture of many households. Less famously, Ward-Takahashi also supplies most \
	of the AI cores on which vital control systems are mounted, and it is this branch of their industry that has \
	led to their tertiary interest in the development and sale of high-grade AI systems. Ward-Takahashi's economies \
	of scale frequently steal market share from Nanotrasen's high-price products, leading to a bitter rivalry in the \
	consumer electronics market. \
	<br><br> \
	Ward-Takahashi are a mild anomaly in the TSC fleet-naming game, as they've opted to use stellar phenomena."
	history = ""
	work = "electronics manufacturer"
	headquarters = ""
	motto = ""

	org_type = "corporate"
	slogans = list(
			"Takahashi Appliances - keeping your home running smoothly.",
			"W-T Automotive - keeping you on time, all the time.",
			"Ward-Takahashi Electronics - keeping you in touch with the galaxy."
			)
	ship_prefixes = list("WTV" = "a general operations", "WTFV" = "a freight", "WTGV" = "a transport", "WTDV" = "an asset protection")
	append_ship_names = TRUE
	added_ship_names = list(
			"Comet",
			"Meteor",
			"Heliosphere",
			"Bolide",
			"Superbolide",
			"Aurora",
			"Nova",
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
			"Sunspot",
			"Supercluster",
			"Supergiant",
			"Protostar",
			"Magnetar",
			"Moon",
			"Supermoon",
			"Anomaly",
			"Drift",
			"Stream",
			"Rift",
			"Curtain",
			"Planetar",
			"Quasar",
			"Blazar",
			"Corona",
			"Binary"
			)
	//destination_names = list()

/datum/lore/organization/tsc/bishop
	name = "Bishop Cybernetics"
	short_name = "Bishop"
	acronym = "BC"
	desc = "Bishop's focus is on high-class, stylish cybernetics. A favorite among transhumanists (and loathed by all \
	bioconservatives), Bishop manufactures not only prostheses but also brain augmentation, synthetic organ replacements, \
	and odds and ends like implanted wrist-watches. Their business model tends towards smaller, boutique operations, giving \
	it a reputation for high price and luxury, with Bishop cyberware often rivalling Vey-Med's for cost. Bishop's reputation \
	for catering towards the interests of human augmentation enthusiasts instead of positronics have earned it ire from the \
	Positronic Rights Group and puts it in ideological (but not economic) competition with Morpheus Cyberkinetics. \
	<br><br> \
	Each vessel in Bishop's sleek and stylish fleet is intended to advertise the corporate style, and bears the name of a famous mechanical engineer."
	history = ""
	work = "cybernetics and augmentation manufacturer"
	headquarters = ""
	motto = ""

	org_type = "corporate"
	slogans = list(
			"Bishop Cybernetics - only the best in personal augmentation.",
			"Bishop Cybernetics - why settle for flesh when you can have metal?",
			"Bishop Cybernetics - make a statement.",
			"Bishop Cybernetics - embrace the purity of the machine."
			)
	ship_prefixes = list("BCV" = "a general operations", "BCTV" = "a transportation", "BCSV" = "a research exchange")
	//famous mechanical engineers
	append_ship_names = TRUE
	added_ship_names = list(
			"Al-Jazari",
			"Al-Muradi",
			"Al-Zarqali",
			"Archimedes",
			"Arkwright",
			"Armstrong",
			"Babbage",
			"Barsanti",
			"Benz",
			"Bessemer",
			"Bramah",
			"Brunel",
			"Cardano",
			"Cartwright",
			"Cayley",
			"Clement",
			"Leonardo da Vinci",
			"Diesel",
			"Drebbel",
			"Fairbairn",
			"Fontana",
			"Fourneyron",
			"Fulton",
			"Fung",
			"Gantt",
			"Garay",
			"Hackworth",
			"Harrison",
			"Hornblower",
			"Jacquard",
			"Jendrassik",
			"Leibniz",
			"Ma Jun",
			"Maudslay",
			"Metzger",
			"Murdoch",
			"Nasmyth",
			"Parsons",
			"Rankine",
			"Reynolds",
			"Roberts",
			"Scheutz",
			"Sikorsky",
			"Somerset",
			"Stephenson",
			"Stirling",
			"Tesla",
			"Vaucanson",
			"Vishweswarayya",
			"Wankel",
			"Watt",
			"Wiberg"
			)
	destination_names = list(
			"a medical facility in Angessa's Pearl"
			)

/datum/lore/organization/tsc/morpheus
	name = "Morpheus Cyberkinetics"
	short_name = "Morpheus"
	acronym = "MC"
	desc = "The only large corporation run by positronic intelligences, Morpheus caters almost exclusively to their sensibilities \
	and needs. A product of the synthetic colony of Shelf, Morpheus eschews traditional advertising to keep their prices low and \
	relied on word of mouth among positronics to reach their current economic dominance. Morpheus in exchange lobbies heavily for \
	positronic rights, sponsors positronics through their Jans-Fhriede test, and tends to other positronic concerns to earn them \
	the good-will of the positronics, and the ire of those who wish to exploit them. \
	<br><br> \
	Morpheus' fleet bears the names of periodic elements. They initially wanted to go with complex compounds, but realized that \
	such designations would be unwieldy and inefficient for regular usage. In the event that multiple ships are working together, \
	they may use the periodic element as their flotilla designation, and a numerical identifier that corresponds with an isotope \
	of that element for individual ships."
	history = ""
	work = "cybernetics manufacturer"
	headquarters = "Shelf flotilla"
	motto = ""

	org_type = "neutral" //disables slogans for morpheus as they don't advertise, per the description above
	/*
	slogans = list()
	*/
	ship_prefixes = list("MCV" = "a general operations", "MTV" = "a freight", "MDV" = "a market protection", "MSV" = "an outreach")
	//periodic elements; something 'unusual' for the posibrain TSC without being full on 'quirky' culture ship names (much as I love them, they're done to death)
	append_ship_names = TRUE
	added_ship_names = list(
			"Hydrogen",
			"Helium",
			"Lithium",
			"Beryllium",
			"Boron",
			"Carbon",
			"Nitrogen",
			"Oxygen",
			"Fluorine",
			"Neon",
			"Sodium",
			"Magnesium",
			"Aluminium",
			"Silicon",
			"Phosphorus",
			"Sulfur",
			"Chlorine",
			"Argon",
			"Potassium",
			"Calcium",
			"Scandium",
			"Titanium",
			"Vanadium",
			"Chromium",
			"Manganese",
			"Iron",
			"Cobalt",
			"Nickel",
			"Copper",
			"Zinc",
			"Gallium",
			"Germanium",
			"Arsenic",
			"Selenium",
			"Bromine",
			"Krypton",
			"Rubidium",
			"Strontium",
			"Yttrium",
			"Zirconium",
			"Niobium",
			"Molybdenum",
			"Technetium",
			"Ruthenium",
			"Rhodium",
			"Palladium",
			"Silver",
			"Cadmium",
			"Indium",
			"Tin",
			"Antimony",
			"Tellurium",
			"Iodine",
			"Xenon",
			"Caesium",
			"Barium"
			)
	//some hebrew alphabet destinations for a little extra unusualness
	destination_names = list(
			"our headquarters, the Shelf flotilla",
			"one of our factory complexes on Root",
			"research outpost Aleph",
			"logistics depot Dalet",
			"research installation Zayin",
			"research base Tsadi",
			"manufacturing facility Samekh"
		)

/datum/lore/organization/tsc/xion
	name = "Xion Manufacturing Group"
	short_name = "Xion"
	acronym = "XMG"
	desc = "Xion, quietly, controls most of the market for industrial equipment, especially on the frontier. Their portfolio includes mining exosuits, \
	factory equipment, rugged positronic chassis, and other pieces of equipment vital to the function of the economy. Xion \
	keeps its control of the market by leasing, not selling, their equipment, and through infamous and bloody patent protection \
	lawsuits. Xion are noted to be a favorite contractor for Commonwealth engineers, owing to their low cost and rugged design. \
	Dedicated frontiersmen tend to have an unfavorable view of the company however, as the leasing arrangements often make field repairs \
	challenging at best, and expensively contract-breaking at worst. Nobody wants an expensive piece of equipment to break down \
	three weeks of travel away from the closest Licensed Xion Repair Outlet. \
	<br><br> \
	Xion's fleet bears the name of mountains and terrain features on Mars."
	history = ""
	work = "industrial equipment manufacturer"
	headquarters = ""
	motto = ""

	org_type = "corporate"
	slogans = list(
			"Xion Manufacturing - We have what you need.",
			"Xion Manufacturing - The #1 choice of the SolCom Engineer's Union for 150 years.",
			"Xion Manufacturing - Our products are as bulletproof as our contracts."
			)
	ship_prefixes = list("XMV" = "a general operations", "XTV" = "a hauling", "XFV" = "a bulk transport", "XIV" = "a resupply")
	//martian mountains
	append_ship_names = TRUE
	added_ship_names = list(
			"Olympus Mons",
			"Ascraeus Mons",
			"Arsia Mons",
			"Pavonis Mons",
			"Elysium Mons",
			"Hecates Tholus",
			"Albor Tholus",
			"Tharsis Tholus",
			"Biblis Tholus",
			"Alba Mons",
			"Ulysses Tholus",
			"Mount Sharp",
			"Uranius Mons",
			"Anseris Mons",
			"Hadriacus Mons",
			"Euripus Mons",
			"Tyrrhenus Mons",
			"Promethei Mons",
			"Chronius Mons",
			"Apollinaris Mons",
			"Gonnus Mons",
			"Syrtis Major Planum",
			"Amphitrites Patera",
			"Nili Patera",
			"Pityusa Patera",
			"Malea Patera",
			"Peneus Patera",
			"Labeatis Mons",
			"Issidon Paterae",
			"Pindus Mons",
			"Meroe Patera",
			"Orcus Patera",
			"Oceanidum Mons",
			"Horarum Mons",
			"Peraea Mons",
			"Octantis Mons",
			"Galaxius Mons",
			"Hellas Planitia"
			)
	//destination_names = list()

/datum/lore/organization/tsc/ftu
	name = "Free Trade Union"
	short_name = "Trade Union"
	acronym = "FTU"
	desc = "The Free Trade Union is different from other transtellar companies in that they are not just a company; rather, they are a big conglomerate of various traders and merchants from all over the galaxy. The FTU is also partially responsible for many of the large scale 'freeport' trade stations across the known galaxy, even in non-human space. Generally, they are multi-purpose stations but they always keep areas filled with duty-free shops, where almost anything you can imagine can be found - so long as it's not outrageously illegal or hideously expensive.<br><br>They are the creators of the Tradeband language, created specially for being a lingua franca where every merchant can understand each other independent of language or nationality.<br><br>The Union doesn't maintain a particularly large fleet of its own; most members are card-carrying independents who fly under their own flags. When you do see a Union ship (they usually operate under the names of historic merchants) you can be assured that it's tending to something that the Union sees as being of the utmost importance to its interests."
	history = ""
	work = ""
	headquarters = ""
	motto = ""

	org_type = "corporate"
	slogans = list(
			"The FTU. We look out for the little guy.",
			"There's no Trade like Free Trade.",
			"There's no Union like the Free Trade Union.",
			"Join the Free Trade Union. Because anything worth doing, is worth doing for money." //rule of acquisition #13
			)
	ship_prefixes = list("FTV" = "a general operations", "FTRP" = "a trade protection", "FTRR" = "a piracy suppression", "FTLV" = "a logistical support", "FTTV" = "a mercantile", "FTDV" = "a market establishment")
	//famous merchants and traders, taken from Civ6's Great Merchants, plus the TSC's founder
	append_ship_names = TRUE
	added_ship_names = list(
			"Isaac Adler",
			"Colaeus",
			"Marcus Licinius Crassus",
			"Zhang Qian",
			"Irene of Athens",
			"Marco Polo",
			"Piero de' Bardi",
			"Giovanni de' Medici",
			"Jakob Fugger",
			"Raja Todar Mal",
			"Adam Smith",
			"John Jacob Astor",
			"John Spilsbury",
			"John Rockefeller",
			"Sarah Breedlove",
			"Mary Katherine Goddard",
			"Helena Rubenstein",
			"Levi Strauss",
			"Melitta Bentz",
			"Estee Lauder",
			"Jamsetji Tata",
			"Masaru Ibuka",
			)
	destination_names = list(
			"a Free Trade Union office",
			"FTU HQ"
			)

/datum/lore/organization/tsc/mbt
	name = "Major Bill's Transportation"
	short_name = "Major Bill's"
	acronym = "MBT"
	desc = "The most popular courier service and starliner, Major Bill's is an unassuming corporation whose greatest asset is their low cost and brand recognition. Major Bill's is known, perhaps unfavorably, for its mascot, Major Bill, a cartoonish military figure that spouts quotable slogans. Their main slogan, featured at least once in all their advertising, is \"With Major Bill's, you won't pay major bills!\", an earworm much of the galaxy longs to forget. \
	<br><br> \
	Their ships are named after some of Earth's greatest rivers."
	history = ""
	work = "courier and passenger transit"
	headquarters = "Mars, Sol"
	motto = "With Major Bill's, you won't pay major bills!"

	org_type = "corporate"
	slogans = list(
			"With Major Bill's, you won't pay major bills!",
			"Major Bill's - Private Couriers - General Shipping!",
			"Major Bill's got you covered, now get out there!"
			)
	ship_prefixes = list("TTV" = "a general operations", "TTV" = "a transport", "TTV" = "a luxury transit", "TTV" = "a priority transit", "TTV" = "a secure data courier")
	//ship names: big rivers
	append_ship_names = TRUE
	added_ship_names = list (
			"Nile",
			"Kagera",
			"Nyabarongo",
			"Mwogo",
			"Rukarara",
			"Amazon",
			"Ucayali",
			"Tambo",
			"Ene",
			"Mantaro",
			"Yangtze",
			"Mississippi",
			"Missouri",
			"Jefferson",
			"Beaverhead",
			"Red Rock",
			"Hell Roaring",
			"Yenisei",
			"Angara",
			"Yelenge",
			"Ider",
			"Ob",
			"Irtysh",
			"Rio de la Plata",
			"Parana",
			"Rio Grande",
			"Congo",
			"Chambeshi",
			"Amur",
			"Argun",
			"Kherlen",
			"Lena",
			"Mekong",
			"Mackenzie",
			"Peace",
			"Finlay",
			"Niger",
			"Brahmaputra",
			"Tsangpo",
			"Murray",
			"Darling",
			"Culgoa",
			"Balonne",
			"Condamine",
			"Tocantins",
			"Araguaia",
			"Volga"
			)
	destination_names = list(
			"Major Bill's Transportation HQ on Mars",
			"a Major Bill's warehouse",
			"a Major Bill's distribution center",
			"a Major Bill's supply depot"
			)

/datum/lore/organization/tsc/grayson
	name = "Grayson Manufactories Ltd."
	short_name = "Grayson"
	acronym = "GM"
	desc = "Grayson Manufactories Ltd. is one of the oldest surviving TSCs, having been in 'the biz' almost since mankind began to colonize the rest of the Sol system and thus exploit abundant 'extraterrestrial' resources. Where many choose to go into the high end markets, however, Grayson makes their money by providing foundations for other businesses; they run some of the largest mining and refining operations in all of human-inhabited space. Ore is hauled out of Grayson-owned mines, transported on Grayson-owned ships, and processed in Grayson-owned refineries, then sold by Grayson-licensed vendors to other industries. Several of their relatively newer ventures include heavy industrial equipment, which has earned a reputation for being surprisingly reliable.<br><br>Grayson may maintain a neutral stance towards their fellow TSCs, but can be quite aggressive in the markets that it already holds. A steady stream of rumors suggests they're not shy about engaging in industrial sabotage or calling in strikebreakers, either. \
	<br><br> \
	Fitting their 'down to earth' reputation, Grayson's corporate fleet uses the names of various forms of rock and mineral to identify their vessels."
	history = ""
	work = ""
	headquarters = "Mars, Sol"
	motto = ""

	org_type = "corporate"
	slogans = list(
			"Grayson Mining - It's An Ore Effort, For The War Effort!",
			"Grayson Mining - Winning The War On Ore!",
			"Grayson Mining - Come On Down To Our Ore Chasm!"
			)
	ship_prefixes = list("GMV" = "a general operations", "GMT" = "a transport", "GMR" = "a resourcing", "GMS" = "a surveying", "GMH" = "a bulk transit")
	//rocks
	append_ship_names = TRUE
	added_ship_names = list(
			"Adakite",
			"Andesite",
			"Basalt",
			"Basanite",
			"Diorite",
			"Dunite",
			"Gabbro",
			"Granite",
			"Harzburgite",
			"Ignimbrite",
			"Kimberlite",
			"Komatiite",
			"Norite",
			"Obsidian",
			"Pegmatite",
			"Picrite",
			"Pumice",
			"Rhyolite",
			"Scoria",
			"Syenite",
			"Tachylyte",
			"Wehrlite",
			"Arkose",
			"Chert",
			"Dolomite",
			"Flint",
			"Laterite",
			"Marl",
			"Oolite",
			"Sandstone",
			"Shale",
			"Anthracite",
			"Gneiss",
			"Granulite",
			"Mylonite",
			"Schist",
			"Skarn",
			"Slate"
			)
	destination_names = list(
			"our headquarters on Mars",
			"one of our manufacturing complexes",
			"one of our mining installations"
			)

/datum/lore/organization/tsc/aether
	name = "Aether Atmospherics & Recycling"
	short_name = "Aether"
	acronym = "AAR"
	desc = "Aether Atmospherics and Recycling is the prime maintainer and provider of atmospherics systems across both the many ships that navigate the vast expanses of space, and the life support on current and future Human colonies. The byproducts from the filtration of atmospheres across the galaxy are then resold for a variety of uses to those willing to buy. With the nature of their services, most work they do is contracted for construction of these systems, or staffing to maintain them for colonies across human space. \
	<br><br> \
	Somewhat unimaginatively, Aether has adopted the names of various types of weather for their fleet."
	history = ""
	work = ""
	headquarters = ""
	motto = "Dum spiro spero"

	org_type = "corporate"
	slogans = list(
			"Aether A&R - We're Absolutely Breathtaking.",
			"Aether A&R - You Can Breathe Easy With Us!",
			"Aether A&R - The SolCom's #1 Environmental Systems Provider."
			)
	ship_prefixes = list("AARV" = "a general operations", "AARE" = "a resource extraction", "AARG" = "a gas transport", "AART" = "a transport")
	//weather systems/patterns
	append_ship_names = TRUE
	added_ship_names = list (
			"Cloud",
			"Nimbus",
			"Fog",
			"Vapor",
			"Haze",
			"Smoke",
			"Thunderhead",
			"Veil",
			"Steam",
			"Mist",
			"Noctilucent",
			"Nacreous",
			"Cirrus",
			"Cirrostratus",
			"Cirrocumulus",
			"Aviaticus",
			"Altostratus",
			"Altocumulus",
			"Stratus",
			"Stratocumulus",
			"Cumulus",
			"Fractus",
			"Asperitas",
			"Nimbostratus",
			"Cumulonimbus",
			"Pileus",
			"Arcus"
			)
	destination_names = list(
			"Aether HQ",
			"a gas mining orbital",
			"a liquid extraction plant"
			)

/datum/lore/organization/tsc/focalpoint
	name = "Focal Point Energistics"
	short_name = "Focal Point"
	acronym = "FPE"
	desc = "Focal Point Energistics is an electrical engineering solutions firm originally formed as a conglomerate of Earth power companies and affiliates. Focal Point manufactures and distributes vital components in modern power grids, such as TEGs, PSUs and their specialty product, the SMES. The company is often consulted and contracted by larger organisations due to their expertise in their field.\
	<br><br> \
	Keeping in theme with the other big TSCs, Focal's fleet (which is comprised almost entirely of transports and engineering vessels) uses the names of electrical engineers."
	history = ""
	work = ""
	headquarters = ""
	motto = ""

	org_type = "corporate"
	slogans = list(
			"Focal Point Energistics - Sustainable Power for a Sustainable Future.",
			"Focal Point Energistics - Powering The Future Before It Even Happens.",
			"Focal Point Energistics - Let There Be Light."
			)
	ship_prefixes = list("FPV" = "a general operations", "FPH" = "a transport", "FPC" = "an energy relay", "FPT" = "a fuel transport")
	//famous electrical engineers
	append_ship_names = TRUE
	added_ship_names = list (
			"Erlang",
			"Blumlein",
			"Taylor",
			"Bell",
			"Reeves",
			"Bennett",
			"Volta",
			"Blondel",
			"Beckman",
			"Hirst",
			"Lamme",
			"Bright",
			"Armstrong",
			"Ayrton",
			"Bardeen",
			"Fuller",
			"Boucherot",
			"Brown",
			"Brush",
			"Burgess",
			"Camras",
			"Crompton",
			"Deprez",
			"Elwell",
			"Entz",
			"Faraday",
			"Halas",
			"Hounsfield",
			"Immink",
			"Laithwaite",
			"McKenzie",
			"Moog",
			"Moore",
			"Pierce",
			"Ronalds",
			"Shallenberger",
			"Siemens",
			"Spencer",
			"Tesla",
			"Yablochkov",
			)
	destination_names = list(
			"Focal Point HQ"
			)

/datum/lore/organization/tsc/starlanes
	name = "StarFlight Inc."
	short_name = "StarFlight"
	acronym = "SFI"
	desc = "Founded in 2137 by Astara Junea, StarFlight Incorporated is now one of the biggest passenger liner businesses in human-occupied space and has even begun breaking into alien markets -  all despite a rocky start, and several high-profile ship disappearances and shipjackings. With space traffic at an all-time high, it's a depressing reality that SFI's incidents are just a tiny drop in the bucket compared to everything else going on. \
	<br><br> \
	SFI's fleet is, somewhat endearingly, named after various species of bird, though the designation <i>Pigeon</i> was removed from the lineup after a particularly unusual chain of events involving a business liner. For reasons that have continued to remain unclear since the company's foundation, SFI vessels are permitted to use the same high-level identifier pattern as governmental vessels."
	history = ""
	work = "luxury, business, and economy passenger flights"
	headquarters = "Spin Aerostat, Jupiter"
	motto = "Sic itur ad astra"

	org_type = "corporate"
	slogans = list(
			"StarFlight - travel the stars.",
			"StarFlight - bringing you to new horizons.",
			"StarFlight - getting you where you need to be since 2137."
			)
	ship_prefixes = list("SFI-X" = "a VIP liner", "SFI-L" = "a luxury liner", "SFI-B" = "a business liner", "SFI-E" = "an economy liner", "SFI-M" = "a mixed class liner", "SFI-S" = "a sightseeing", "SFI-M" = "a wedding", "SFI-O" = "a marketing", "SFI-S" = "a safari", "SFI-A" = "an aquatic adventure")
	flight_types = list(		//no military-sounding ones here
			"flight",
			"route",
			"tour"
			)
	ship_names = list(	//birbs
			"Rhea",
			"Ostrich",
			"Cassowary",
			"Emu",
			"Kiwi",
			"Duck",
			"Swan",
			"Chachalaca",
			"Curassow",
			"Guan",
			"Guineafowl",
			"Pheasant",
			"Turkey",
			"Francolin",
			"Loon",
			"Penguin",
			"Grebe",
			"Flamingo",
			"Stork",
			"Ibis",
			"Heron",
			"Pelican",
			"Spoonbill",
			"Shoebill",
			"Gannet",
			"Cormorant",
			"Osprey",
			"Kite",
			"Hawk",
			"Falcon",
			"Hummingbird",
			"Toucan",
			"Caracara"
			)
	destination_names = list(
			"a resort planet",
			"a beautiful ring system",
			"a ski-resort world",
			"an ocean resort planet",
			"a desert resort world",
			"an arctic retreat"
			)

/datum/lore/organization/tsc/oculum
	name = "Oculum Broadcasting Network"
	short_name = "Oculus"
	acronym = "OBN"
	desc = "Oculum owns approximately 30% of Sol-wide news networks, including microblogging aggregate sites, network and comedy news, and even old-fashioned newspapers. Staunchly apolitical, they specialize in delivering the most popular news available- which means telling people what they already want to hear. Oculum is a specialist in branding, and most people don't know that the reactionary Daedalus Dispatch newsletter and the radically transhuman Liquid Steel webcrawler are controlled by the same organization."
	history = ""
	work = "news media"
	headquarters = ""
	motto = "News from all across the spectrum"

	org_type = "corporate"
	slogans = list(
			"Oculum - All News, All The Time.",
			"Oculum - We Keep An Eye Out.",
			"Oculum - Nothing But The Truth.",
			"Oculum - Your Eye On The Galaxy."
			)
	ship_prefixes = list("OBV" = "an investigation", "OBV" = "a distribution", "OBV" = "a journalism", "OBV" = "a general operations")
	destination_names = list(
			"Oculus HQ"
			)

/datum/lore/organization/tsc/centauriprovisions
	name = "Centauri Provisions"
	short_name = "Centauri"
	acronym = "ACP"
	desc = "Headquartered in Alpha Centauri, Centauri Provisions made a name in the snack-food industry primarily by being the first to focus on colonial holdings. The various brands of Centauri snackfoods are now household names, from SkrellSnax to Space Mountain Wind to the ubiquitous and supposedly-edible Bread Tube, and they are well known for targeting as many species as possible with each brand (which, some will argue, is at fault for some of those brands being rather bland in taste and texture). Their staying power is legendary, and many spacers have grown up on a mix of their cheap crap and protein shakes."
	history = ""
	work = "catering, food, drinks"
	headquarters = "Alpha Centauri"
	motto = "The largest brands of food and drink - most of them are Centauri."

	org_type = "corporate"
	slogans = list(
			"Centauri Provisions Bread Tubes - They're Not Just Edible, They're |Breadible!|",
			"Centauri Provisions SkrellSnax - Not |Just| For Skrell!",
			"Centauri Provisions Space Mountain Wind - It'll Take Your |Breath| Away!",
			"Centauri Provisions Syndi-Cakes - A Taste So Good You'll Swear It's |Illegal|!",
			"Centauri Provisions Tuna Snax - There's Nothing |Fishy| Going On Here!"
			)
	ship_prefixes = list("CPTV" = "a transport", "CPCV" = "a catering", "CPRV" = "a resupply", "CPV" = "a general operations")
	destination_names = list(
			"Centauri Provisions HQ",
			"a Centauri Provisions depot",
			"a Centauri Provisions warehouse"
			)

/datum/lore/organization/tsc/einstein
	name = "Einstein Engines"
	short_name = "Einstein"
	acronym = "EEN"
	desc = "Einstein is an old company that has survived through rampant respecialization. In the age of phoron-powered exotic engines and ubiquitous solar power, Einstein makes its living through the sale of engine designs for power sources it has no access to, and emergency fission or hydrocarbon power supplies. Accusations of corporate espionage against research-heavy corporations like NanoTrasen and its chief rival Focal Point are probably unfounded. Probably."
	history = ""
	work = "catering, food, drinks"
	headquarters = ""
	motto = "Engine designs, emergency generators, and old memories"

	org_type = "corporate"
	slogans = list(
			"Einstein Engines - you don't have to be Einstein to use |our| engines!",
			"Einstein Engines - bringing power to the people.",
			"Einstein Engines - because it's the smart thing to do."
			)
	ship_prefixes = list("EETV" = "a transport", "EERV" = "a research", "EEV" = "a general operations")
	destination_names = list(
			"Einstein HQ"
			)

/datum/lore/organization/tsc/wulf
	name = "Wulf Aeronautics"
	short_name = "Wulf Aero"
	acronym = "WUFA"
	desc = "Wulf Aeronautics is the chief producer of transport and hauling spacecraft. A favorite contractor of the CWS, Wulf manufactures most of their diplomatic and logistics craft, and does a brisk business with most other TSCs. The quiet reliance of the economy on their craft has kept them out of the spotlight and uninvolved in other corporations' back-room dealings; nobody is willing to try to undermine Wulf Aerospace in case it bites them in the ass, and everyone knows that trying to buy out the company would start a bidding war from which nobody would escape the PR fallout."
	history = ""
	work = "starship construction"
	headquarters = ""
	motto = "We build it - you fly it"

	org_type = "corporate"
	slogans = list(
			"Wulf Aeronautics. We build it - you fly it.",
			"Wulf Aeronautics, the Commonwealth's favorite shipwrights.",
			"Wulf Aeronautics, building tomorrow's ships today."
			)
	ship_prefixes = list("WAFV" = "a freight", "WARV" = "a repair", "WAV" = "a general operations", "WALV" = "a logistics")
	destination_names = list(
			"Wulf Aeronautics HQ",
			"a Wulf Aeronautics supply depot",
			"a Wulf Aeronautics Shipyard"
			)

/datum/lore/organization/tsc/gilthari
	name = "Gilthari Exports"
	short_name = "Gilthari"
	acronym = "GEX"
	desc = "Gilthari is Sol's premier supplier of luxury goods, specializing in extracting money from the rich and successful that aren't already their own shareholders. Their largest holdings are in gambling, but they maintain subsidiaries in everything from VR equipment to luxury watches. Their holdings in mass media are a smaller but still important part of their empire. Gilthari is known for treating its positronic employees very well, sparking a number of conspiracy theories. The gorgeous FBP model that Gilthari provides them is a symbol of the corporation's wealth and reach ludicrous prices when available on the black market, with legal ownership of the chassis limited, by contract, to employees.<br><br>In fitting with their heritage, Gilthari ships are named after precious stones."
	history = ""
	work = "luxury goods"
	headquarters = ""
	motto = ""

	org_type = "corporate"
	slogans = list(
			"Why choose |luxury| when you can choose |Gilthari|?",
			"|Gilthari|. Because |you're| worth it.",
			"|Gilthari|. Why settle for |anything| less?"
			)
	ship_prefixes = list("GETV" = "a transport", "GECV" = "a luxury catering", "GEV" = "a general operations")
	//precious stones
	ship_names = list(
			"Afghanite",
			"Agate",
			"Alexandrite",
			"Amazonite",
			"Amber",
			"Amethyst",
			"Ametrine",
			"Andalusite",
			"Aquamarine",
			"Azurite",
			"Benitoite",
			"Beryl",
			"Carnelian",
			"Chalcedony",
			"Chrysoberyl",
			"Chrysoprase",
			"Citrine",
			"Coral",
			"Danburite",
			"Diamond",
			"Emerald",
			"Fluorite",
			"Garnet",
			"Heliodor",
			"Iolite",
			"Jade",
			"Jasper",
			"Lapis Lazuli",
			"Malachite",
			"Moldavite",
			"Moonstone",
			"Obsidian",
			"Onyx",
			"Orthoclase",
			"Pearl",
			"Peridot",
			"Quartz",
			"Ruby",
			"Sapphire",
			"Scapolite",
			"Selenite",
			"Serpentine",
			"Sphalerite",
			"Sphene",
			"Spinel",
			"Sunstone",
			"Tanzanite",
			"Topaz",
			"Tourmaline",
			"Turquoise",
			"Zircon"
			)
	destination_names = list(
			"Gilthari HQ",
			"a GE supply depot",
			"a GE warehouse",
			"a GE-owned luxury resort"
			)

/datum/lore/organization/tsc/coyotecorp
	name = "Coyote Salvage Corp."
	short_name = "Coyote Salvage"
	acronym = "CSC"
	desc = "The threat of Kessler Syndrome ever looms in this age of spaceflight, and it's only thanks to the dedication and hard work of unionized salvage groups like the Coyote Salvage Corporation that the spacelanes are kept clear and free of wrecks and debris. Painted in that distinctive industrial yellow, their fleets of roaming scrappers are contracted throughout civilized space and the frontier alike to clean up space debris. Some may look down on them for handling what would be seen as garbage and discarded scraps, but as far as the CSC is concerned everything would grind to a halt (or more accurately, rapidly expand in a cloud of red-hot scrap metal) without their tender care and watchful eyes.\
	<br><br> \
	Many spacers turn to join the ranks of the Salvage Corps when times are lean, or when they need a quick buck. The work is dangerous and the hours are long, but the benefits are generous and you're paid by what you salvage so if you've an eye for appraising scrap you can turn a good profit. For those who dedicate their lives to the work, they can become kings of the scrapheap and live like royalty. \
	<br><br> \
	CSC Contractors are no strangers to conflict either, often having to deal with claimjumpers and illegal salvage operations - or worse, the vox."
	history = ""
	work = "salvage and shipbreaking"
	headquarters = "N/A"
	motto = "one man's trash is another man's treasure"

	org_type = "corporate"
	slogans = list(
			"Coyote Salvage Corp. 'cause your trash ain't gonna clean itself.",
			"Coyote Salvage Corp. 'cause one man's trash is another man's treasure.",
			"Coyote Salvage Corp. We'll take your scrap - but not your crap."
			)
	ship_prefixes = list("CSV" = "a salvage", "CRV" = "a recovery", "CTV" = "a transport", "CSV" = "a shipbreaking", "CHV" = "a towing")
	//mostly-original, maybe some references, and more than a few puns
	append_ship_names = TRUE
	added_ship_names = list(
			"Road Hog",
			"Mine, Not Yours",
			"Legal Salvage",
			"Barely Legal",
			"One Man's Trash",
			"Held Together By Tape And Dreams",
			"Ventilated Vagrant",
			"Half A Wing And A Prayer",
			"Scrap King",
			"Make Or Break",
			"Lead Into Gold",
			"Under New Management",
			"Pride of Centauri",
			"Long Haul",
			"Argonaut",
			"Desert Nomad",
			"Non-Prophet Organization",
			"Rest In Pieces",
			"Sweep Dreams",
			"Home Sweep Home",
			"Atomic Broom",
			"Ship Broken",
			"Rarely Sober",
			"Barely Coherent",
			"Piece Of Mind",
			"War And Pieces",
			"Bits 'n' Bobs",
			"Home Wrecker",
			"T-Wrecks",
			"Dust Bunny",
			"No Gears No Glory",
			"Two Drink Minimum",
			"Three Drinks In",
			"The Almighty Janitor",
			"Wreckless Endangerment",
			"Scarab"
			)
	//remove a couple types, add the more down-to-earth 'job' to reflect some personality
	flight_types = list(
			"job",
			"op",
			"operation",
			"assignment",
			"contract"
			)
	destination_names = list (
			"a frontier scrapyard",
			"a trashbelt",
			"a local salvage yard",
			"a nearby system"
			)

/datum/lore/organization/tsc/chimera
	name = "Chimera Genetics Corp."
	short_name = "Chimera Genetics"
	acronym = "CGC"
	desc = "With the rise of personal body modification, companies specializing in this field were bound to spring up as well. The Chimera Genetics Corporation, or CGC, is one of the largest and most successful competitors in this ever-evolving and ever-adapting field. They originally made a foothold in the market through designer flora and fauna such as \"factory plants\" and \"fabricowtors\"; imagine growing high-strength carbon nanotubes on vines, or goats that can be milked for a substance with the tensile strength of spider silk. Once they had more funding? Chimera aggressively expanded into high-end designer bodies, both vat-grown-from-scratch and modification of existing bodies via extensive therapy procedures. Their best-known designer critter is the <i>Drake</i> line; hardy, cold-tolerant \'furred lizards\' that are unflinchingly loyal to their contract-holders. Drakes find easy work in heavy industries and bodyguard roles, despite constant lobbying from bioconservatives to, quote, \"keep these \"meat drones\" from taking jobs away from regular people.\" \
	<br><br> \
	Some things never change. \
	<br><br> \
	Unsurprisingly, Chimera names their ships after mythological creatures."
	history = ""
	work = "designer bodies and bioforms"
	headquarters = "Titan, Sol"
	motto = "the whole is greater than the sum of its parts"

	org_type = "corporate"
	slogans = list(
			"Chimera Genetics. Find your true self today!",
			"Chimera Genetics. Bring us your genes and we'll clean them right up.",
			"Chimera Genetics. Better bodies for a better tomorrow."
			)
	ship_prefixes = list("CGV" = "a general operations", "CGT" = "a transport", "CGT" = "a delivery", "CGH" = "a medical")
	//edgy mythological critters!
	ship_names = list(
			"Bandersnatch",
			"Banshee",
			"Basilisk",
			"Black Dog",
			"Centaur",
			"Cerberus",
			"Charybdis",
			"Chimera",
			"Cyclops",
			"Cynocephalus",
			"Demon",
			"Daemon",
			"Dragon",
			"Echidna",
			"Ghoul",
			"Goblin",
			"Golem",
			"Gorgon",
			"Griffin",
			"Hekatonchires",
			"Hobgoblin",
			"Hydra",
			"Imp",
			"Ladon",
			"Loup-Garou",
			"Manticore",
			"Medusa",
			"Minotaur",
			"Naga",
			"Nosferatu",
			"Ogre",
			"Pegasus",
			"Sasquatch",
			"Scylla",
			"Shade",
			"Siren",
			"Sphinx",
			"Titan",
			"Typhon",
			"Valkyrie",
			"Vampir",
			"Venrir",
			"Wendigo",
			"Werewolf",
			"Wraith"
			)
	destination_names = list (
			"Chimera HQ, Titan",
			"a Chimera research lab"
			)

//////////////////////////////////////////////////////////////////////////////////

// Other
/datum/lore/organization/other/independent
	name = "Independent Pilots Association"
	short_name = "Independent"
	acronym = "IPA"
	desc = "Though less common now than they were in the decades before the Sol Economic Organization took power, independent pilots and traders remain an important part of the galactic economy, owing in no small part to protective tariffs established by the Free Trade Union in the late twenty-second century. Further out on the frontier, independent pilots are often the only people keeping freight and vital supplies moving.\
	<br><br> \
	Independent ships use a wide variety of names, many of which are as unusual and eclectic as their crews."
	history = ""
	work = "everything under the sun"
	headquarters = "N/A"
	motto = "N/A"
	autogenerate_destination_names = TRUE //force random dest generation

	ship_prefixes = list("ISV" = "a general", "IEV" = "a prospecting", "IEC" = "a prospecting", "IFV" = "a bulk freight", "ITV" = "a passenger transport", "ITC" = "a just-in-time delivery", "IPV" = "a patrol", "IHV" = "a bounty hunting", "ICC" = "an escort", "IMV" = "a mining", "IPS" = "an interplanetary shipping")
	flight_types = list(
			"flight",
			"mission",
			"route",
			"operation",
			"assignment",
			"contract"
			)
	//ship names: blank, because we use the universal list
	//ship_names = list()

//SPACE LAW
/datum/lore/organization/other/sysdef
	name = "System Defense Force"
	short_name = "SDF"
	acronym = "SDF"
	desc = "Localized militias are used to secure systems throughout inhabited space, but are especially common on the frontier; by levying and maintaining these militia forces, larger governments can use their primary fleets (like the USDF) for more important matters and smaller ones can give travellers in their space some peace of mind given the ever-present threat of pirates and vox marauders whilst also helping cut down on smuggling (narcotic substances remain as popular in this century as they have throughout the last few millennia). System Defense Forces tend to be fairly poorly trained and modestly equipped compared to genuine military fleets, but are more than capable of contending with equally ramshackle pirate vessels and can generally stall greater threats long enough for reinforcements to arrive. They're also typically responsible for most search-and-rescue operations in their system.\
	<br><br>\
	SDF ships are traditionally named after various forms of historical weaponry; as their founding members tend to be veterans of other SDF services which used this system, this tradition has slowly propagated.\
	<br><br>\
	Common SDF ship designations include;<br>\
	SDF = System Defense Fleet (General)<br>\
	SDV/SDB = System Defense Vessel/Boat<br>\
	SAR = Search And Rescue (Emergency Services)<br>\
	SDT = System Defense Tender (Mobile Refuel & Resupply)<br>\
	SDJ = Prisoner Transport"
	history = ""
	work = "local security"
	headquarters = ""
	motto = "Serve, Protect, Survive"
	autogenerate_destination_names = FALSE //don't add extra destinations to our pool, or else we leave the system which makes no sense

	org_type = "system defense"
	ship_prefixes = list ("SDB" = "a patrol", "SDF" = "a patrol", "SDV" = "a patrol", "SDB" = "an escort", "SDF" = "an escort", "SDV" = "an escort", "SAR" = "a search and rescue", "SDT" = "a logistics", "SDT" = "a resupply", "SDJ" = "a prisoner transport") //b = boat, f = fleet (generic), v = vessel, t = tender
	//ship names: weapons, particularly medieval and renaissance melee and pre-gunpowder ranged weapons
	ship_names = list(
			"Sword",
			"Saber",
			"Cutlass",
			"Scimitar",
			"Broadsword",
			"Katar",
			"Shamshir",
			"Flyssa",
			"Kaskara",
			"Khopesh",
			"Tachi",
			"Shashka",
			"Epee",
			"Estoc",
			"Longsword",
			"Katana",
			"Odachi",
			"Baselard",
			"Gladius",
			"Kukri",
			"Pick",
			"Mattock",
			"Hatchet",
			"Machete",
			"Axe",
			"Tomahawk",
			"Labrys",
			"Masakari",
			"Parashu",
			"Sagaris",
			"Francisca",
			"Stiletto",
			"Tanto",
			"Pugio",
			"Cinquedea",
			"Katar",
			"Dirk",
			"Dagger",
			"Maul",
			"Mace",
			"Flail",
			"Morningstar",
			"Shillelagh",
			"Cudgel",
			"Truncheon",
			"Hammer",
			"Arbalest",
			"Ballista",
			"Catapult",
			"Trebuchet",
			"Longbow",
			"Pike",
			"Javelin",
			"Glaive",
			"Halberd",
			"Scythe",
			"Spear",
			"Guisarme",
			"Billhook"
			)
	destination_names = list(
			"the outer system",
			"the inner system",
			"Waypoint Alpha",
			"Waypoint Beta",
			"Waypoint Gamma",
			"Waypoint Delta",
			"Waypoint Epsilon",
			"Waypoint Zeta",
			"Waypoint Eta",
			"Waypoint Theta",
			"Waypoint Iota",
			"Waypoint Kappa",
			"Waypoint Lambda",
			"Waypoint Mu",
			"Waypoint Nu",
			"Waypoint Xi",
			"Waypoint Omicron",
			"Waypoint Pi",
			"Waypoint Rho",
			"Waypoint Sigma",
			"Waypoint Tau",
			"Waypoint Upsilon",
			"Waypoint Phi",
			"Waypoint Chi",
			"Waypoint Psi",
			"Waypoint Omega",
			"System Defense Control",
			"an SDF correctional facility",
			"an SDF processing center",
			"an SDF supply depot",
			"an SDF Rapid Response Hub",
			"an SDF outpost"
			)

//basically just a dummy/placeholder 'org' for smuggler events
/datum/lore/organization/other/smugglers
	name = "Smugglers"
	short_name = "" //whitespace hack again
	acronym = "ISC"
	desc = "Where there's a market, there need to be merchants, and where there are buyers, there need to be suppliers. Most of all, wherever there's governments, there'll be somebody trying to control what people are and aren't allowed to do with their bodies. For those seeking goods deemed illegal (for good reasons or otherwise) they need to turn to smugglers and the fine art of sneaking things past the authorities.\
	<br><br>\
	The most common goods smuggled throughout space are narcotics, firearms, and occasionally slaves; whilst firearm ownership laws vary from location to location, most governments also take fairly hard stances on hard drugs, and slavery is consistently outlawed and punished viciously throughout the vast majority of civilized space.\
	<br><br>\
	Still, contrary to many conceptions, not all smuggling is nefarious. Entertainment media within human territories loves to paint romantic images of heroic smugglers sneaking aid supplies to refugees or even helping oppressed minorities escape the grasp of xenophobic regimes."
	history = ""
	work = ""
	headquarters = ""
	motto = ""
	autogenerate_destination_names = TRUE //the events we get called for don't fire a destination, but we need entries to avoid runtimes.

	org_type = "smuggler"
	ship_prefixes = list ("suspected smuggler" = "an illegal smuggling", "possible smuggler" = "an illegal smuggling") //as assigned by control, second part shouldn't even come up

	ship_names = list()

/datum/lore/organization/other/smugglers/New()
	..()
	var/i = 20 //give us twenty random names. for smugglers, I grabbed a bunch of two-syllable s-words, in keeping with NATO reporting names. I figured a fixed name list didn't make very much sense.
	var/list/first_word = list(
			"Smuggler","Safety","Scanner","Season","Secret","Section","Seeker","Server","Seller","Sequence","Shadow","Solar","Software","Smoker","Southwest","Spectrum","Spirit","Sponsor","Stainless","Stable","Study","Subject","Student","Surface","Symbol","Supreme","Surprise","Syntax","Sterling","Statement"
			)
	var/list/nato_phonetic = list(
			"Alfa","Bravo","Charlie","Delta","Echo","Foxtrot","Golf","Hotel","India","Juliet","Kilo","Lima","Mike","November","Oscar","Papa","Quebec","Romeo","Sierra","Tango","Uniform","Victor","Whiskey","Xray","Yankee","Zulu"
			)
	while(i)
		ship_names.Add("[pick(first_word)] [rand(1,99)]-[pick(nato_phonetic)]")
		i--

/datum/lore/organization/other/pirates
	name = "Pirates"
	short_name = "" //whitespace hack again
	acronym = "IPG"
	desc = "Where there's prey, predators are sure to follow. In space, the prey are civilian merchants, and the predators are opportunistic pirates. This is about where the analogy breaks down, but the basic concept remains the same; civilian ships are usually full of valuable goods or important people, which can be sold on black markets or ransomed back for a healthy sum. Pirates seek to seize the assets of others to get rich, rather than make an honest thaler themselves.\
	<br><br>\
	Common pirates tend to be rough, practical, and brutally efficient in their work. System Defense units practice rapid response drills, and in most systems it's only a matter of minutes before The Law arrives unless the pirate is able to isolate their target and prevent them from sending a distress signal.\
	<br><br>\
	Complicating matters is the infrequent use of privateers by various minor colonial governments, mercenaries turning to piracy during hard times, and illegal salvage operations."
	history = ""
	work = ""
	headquarters = ""
	motto = "What\'s yours is mine."
	autogenerate_destination_names = TRUE //the events we get called for don't fire a destination, but we need entries to avoid runtimes.

	org_type = "pirate"
	ship_prefixes = list ("known pirate" = "a piracy", "suspected pirate" = "a piracy", "rogue privateer" = "a piracy", "Cartel enforcer" = "a piracy", "known outlaw" = "a piracy", "bandit" = "a piracy", "roving corsair" = "a piracy", "illegal salvager" = "an illegal salvage", "rogue mercenary" = "a mercenary") //as assigned by control, second part shouldn't even come up, but it exists to avoid hiccups/weirdness just in case

	ship_names = list()

/datum/lore/organization/other/pirates/New()
	..()
	var/i = 20 //give us twenty random names. as for smugglers, so for pirates. in this case I went with two-syllable b-words.
	var/list/first_word = list(
			"Bandit","Bogey","Backup","Baker","Balance","Bandwidth","Banker","Banner","Bargain","Baseball","Basket","Bathroom","Berlin","Beyond","Bidder","Bishop","Bookmark","Border","Boston","Bracelet","Brazil","Breakfast","Brian","Broadband","Brochure","Broken","Broker","Brother","Buddy","Budget","Bureau","Business"
			)
	var/list/nato_phonetic = list(
			"Alfa","Bravo","Charlie","Delta","Echo","Foxtrot","Golf","Hotel","India","Juliet","Kilo","Lima","Mike","November","Oscar","Papa","Quebec","Romeo","Sierra","Tango","Uniform","Victor","Whiskey","Xray","Yankee","Zulu"
			)
	while(i)
		ship_names.Add("[pick(first_word)] [rand(1,99)]-[pick(nato_phonetic)]")
		i--

/*
//Commenting out the Ue-Katish and Vox Marauders for now, to dial down the implications of rampant piracy
/datum/lore/organization/other/uekatish
	name = "Ue-Katish Pirates"
	short_name = ""
	acronym = "UEK"
	desc = "Contrasting with the Qerr-Glia is a vibrant community of Ue-Katish pirates, who live in cargo flotillas on the edge of Skrellian space (especially on the Human-Skrell border). Ue-Katish ships have no caste system even for the truecaste Skrell and aliens who live there, although they are regimented by rank and role in the ship's functioning. Ue-Katish ships are floating black markets where everything is available for the right price, including some of the galaxy's most well-connected information brokers and most skilled guns-for-hire. The Ue-Katish present the greatest Skrellian counterculture and feature heavily in romanticized human media, although at their hearts they are still bandits and criminals, and the black markets are filled with goods plundered from human and Skrellian trade ships. Many of the Ue-Katish ships themselves bear the scars of the battle that brought them under the pirate flag.\
	<br><br> \
	Ue-Katish pirate culture is somewhat similar to many human countercultures, gleefully reclaiming slurs and subverting expectations for the sheer shock value. Nonetheless, Ue-Katish are still Skrell, and still organize in neat hierarchies under each ship's Captain. The Captain's word is absolute, and unlike the Qerr-Katish they lack any sort of anti-corruption institutions."
	history = ""
	work = ""
	motto = ""
	autogenerate_destination_names = TRUE

	org_type = "pirate"
	ship_prefixes = list("Ue-Katish pirate" = "a raiding", "Ue-Katish bandit" = "a raiding", "Ue-Katish raider" = "a raiding", "Ue-Katish enforcer" = "an enforcement")
	ship_names = list()

/datum/lore/organization/other/uekatish/New()
	..()
	var/i = 20 //give us twenty random names
	var/list/first_names = file2list('config/names/first_name_skrell.txt')
	var/list/words = list(
			"Prize",
			"Bounty",
			"Treasure",
			"Pearl",
			"Star",
			"Mercy",
			"Compass",
			"Greed",
			"Slave",
			"Madness",
			"Pride",
			"Disgrace",
			"Judgement",
			"Wrath",
			"Hatred",
			"Vengeance",
			"Fury",
			"Thunder",
			"Scream",
			"Dagger",
			"Saber",
			"Lance",
			"Blade"
			)
	while(i)
		ship_names.Add("[pick(first_names)]'s [pick(words)]")
		i--

/datum/lore/organization/other/marauders
	name = "Vox Marauders"
	short_name = "" //whitespace hack again
	acronym = "VOX"
	desc = "Whilst rarely as directly threatening as 'common' pirates, the phoron-breathing vox nevertheless pose a constant nuisance for shipping; as far as vox are concerned, only vox and vox matters matter, and everyone else is a 'treeless dusthuffer'. Unlike sometimes over-confident pirates, the vox rarely engage in direct, open combat, preferring to make their profits by either stealth or gunboat diplomacy that tends to be more bluster than true brute force: vox raiders will only commit to an attack if they're confident that they can quickly overwhelm and subdue their victims, then get away with the spoils before any reinforcements can arrive.\
	<br><br>\
	As Vox ship names are generally impossible for the vast majority of other species to pronounce, System Defense tends to tag marauders with a designation based on the ancient NATO Phonetic Alphabet."
	history = "Unknown"
	work = "Looting and raiding"
	headquarters = "Nowhere"
	motto = "(unintelligible screeching)"
	autogenerate_destination_names = TRUE //the events we get called for don't fire a destination, but we need *some* entries to avoid runtimes.

	org_type = "pirate"
	ship_prefixes = list("vox marauder" = "a marauding", "vox raider" = "a raiding", "vox ravager" = "a raiding", "vox corsair" = "a raiding") //as assigned by control, second part shouldn't even come up
	//blank out our shipnames for redesignation
	ship_names = list()

/datum/lore/organization/other/marauders/New()
	..()
	var/i = 20 //give us twenty random names, marauders get tactical designations from SDF
	var/list/letters = list(
			"Alpha",
			"Bravo",
			"Charlie",
			"Delta",
			"Echo",
			"Foxtrot",
			"Golf",
			"Hotel",
			"India",
			"Juliett",
			"Kilo",
			"Lima",
			"Mike",
			"November",
			"Oscar",
			"Papa",
			"Quebec",
			"Romeo",
			"Sierra",
			"Tango",
			"Uniform",
			"Victor",
			"Whiskey",
			"X-Ray",
			"Yankee",
			"Zulu"
			)
	var/list/numbers = list(
			"Zero",
			"One",
			"Two",
			"Three",
			"Four",
			"Five",
			"Six",
			"Seven",
			"Eight",
			"Nine"
			)
	while(i)
		ship_names.Add("[pick(letters)]-[pick(numbers)]")
		i--
*/
//////////////////////////////////////////////////////////////////////////////////

// Governments
/datum/lore/organization/gov/commonwealth
	name = "Commonwealth of Sol-Procyon"
	short_name = "SolCom"
	acronym = "CWS"
	desc = "The Commonwealth of Sol-Procyon is the evolution of the many nation states of Earth and the outlying colonies \
			having spread amongst the stars. While not quite the hegemon of all Humanity, a narrow majority of them follow \
			the flag of the Commonwealth. The constant tug and pull of government versus corporation, democracy and power \
			troubles this federation of deeply entrenched human colonies much like it did in the 21st century. Some things \
			never change. However, they are economically and culturally quite dominant, although not everyone likes that fact. \
	<br><br> \
	Ships on official CWS assignments typically carry the designations of Earth\'s largest craters, as a reminder of everything the planet (and humanity itself) has endured."
	history = "" // Todo
	work = "governing polity of humanity's systems"
	headquarters = "Luna, Sol"
	motto = "Nil Mortalibus Ardui Est" // Latin, because latin.  Says 'Nothing is too steep for mortals'
	autogenerate_destination_names = TRUE

	org_type = "government"
	ship_prefixes = list("CWS-A" = "an administrative", "CWS-T" = "a transportation", "CWS-D" = "a diplomatic", "CWS-F" = "a freight", "CWS-J" = "a prisoner transfer")
	//earth's biggest impact craters
	ship_names = list(
			"Wabar",
			"Kaali",
			"Campo del Cielo",
			"Henbury",
			"Morasko",
			"Boxhole",
			"Macha",
			"Rio Cuarto",
			"Ilumetsa",
			"Tenoumer",
			"Xiuyan",
			"Lonar",
			"Agoudal",
			"Tswaing",
			"Zhamanshin",
			"Bosumtwi",
			"Elgygytgyn",
			"Bigach",
			"Karla",
			"Karakul",
			"Vredefort",
			"Chicxulub",
			"Sudbury",
			"Popigai",
			"Manicougan",
			"Acraman",
			"Morokweng",
			"Kara",
			"Beaverhead",
			"Tookoonooka",
			"Charlevoix",
			"Siljan Ring",
			"Montagnais",
			"Araguinha",
			"Chesapeake",
			"Mjolnir",
			"Puchezh-Katunki",
			"Saint Martin",
			"Woodleigh",
			"Carswell",
			"Clearwater West",
			"Clearwater East",
			"Manson",
			"Slate",
			"Yarrabubba",
			"Keurusselka",
			"Shoemaker",
			"Mistastin",
			"Kamensk",
			"Steen",
			"Strangways",
			"Tunnunik",
			"Boltysh",
			"Nordlinger Ries",
			"Presqu'ile",
			"Haughton",
			"Lappajarvi",
			"Rochechouart",
			"Gosses Bluff",
			"Amelia Creek",
			"Logancha",
			"Obolon'",
			"Nastapoka",
			"Ishim",
			"Bedout"
			)
	destination_names = list(
			"Venus",
			"Earth",
			"Luna",
			"Mars",
			"Titan",
			"Europa",
			"the Jovian subcluster",
			"a Commonwealth embassy",
			"a classified location"
			)
			// autogen will add a lot of other places as well.

/datum/lore/organization/gov/ares
	name = "Third Ares Confederation"
	short_name = "ArCon"
	desc = "A loose coalition of socialist and communist movements on the fringes of the human diaspora \
			the Ares Confederation is a government-in-exile from the original uprisings of Mars to stop \
			the government of corporations and capitalist interests over Humanity. While they failed twice \
			they have made their own home far beyond the reach of an effective military response by the \
			Commonwealth. They have become renowned engineers and terraforming experts, mostly due to necessity.\
			<br><br>\
			Many of their vessels carry the names of original Confederation ships, or heroes who fought for \
			liberty and equality in the early days of the uprisings. Many, however, are far more irreverent, \
			seeming to flaunt callsign regulations as a small act of rebellion or purely because they can."
	history = ""
	work = "idealist socialist government"
	headquarters = "Paraiso a Àstrea"
	motto = "Liberty to the Stars!"

	org_type = "government"
	ship_prefixes = list("UFHV" = "military", "FFHV" = "classified")
	ship_names = list(
			"Bulwark of the Free",
			"Charged Negotiation",
			"Corporation Breaker",
			"Cheeki Breeki",
			"Dawnstar",
			"Fiery Justice",
			"Fist of Ares",
			"Freedom",
			"Marx Was Right",
			"Endstage Capitalism",
			"Neoluddism Is The Answer Guys",
			"Anarchocapitalism Is A Joke",
			"Front Toward Enemy",
			"Path of Prosperity",
			"Freedom Cry",
			"Rebel Yell",
			"We Will Return To Mars",
			"According To Our Abilities",
			"Posadism Gang",
			"Accelerationism Doesn't Work In A Vaccuum",
			"Don't Shoot, We're Unarmed I Think",
			"Sir, It's One Of Ours",
			"The Big Stick For Speaking Softly",
			"Per Our Last E-Mail",
			"A Slight Weight Discrepancy",
			"I Think It's An Asteroid",
			"Bull Moose",
			"Engels Needs Some Love Too",
			"The Icepick",
			"Gauntlet",
			"Gellaume",
			"Hero of the Revolution",
			"Jerome",
			"Laughing Maniac",
			"Liberty",
			"Mahama",
			"Memory of Fallen",
			"Miko",
			"Mostly Harmless",
			"None Of Your Business",
			"Not Insured",
			"People's Fist",
			"Petrov",
			"Prehensile Ethics",
			"Pride of Liberty",
			"Rodrick",
			"Star of Tiamat",
			"Torch of Freedom",
			"Torch",
			"We All Lift",
			"Adrift Together",
			"Freyv",
			"Asgauth",
			"Elduette",
			"Seigfast",
			"Bergautur",
			"Anrune",
			"Naybard",
			"Alfmundur",
			"Ganuun",
			"Du Moch",
			"Morvo",
			"Montrienn",
			"Ursuul"
			)
	destination_names = list(
			"Drydocks of the Ares Confederation",
			"a classified location",
			"a Homestead on Paraiso",
			"a contested sector of ArCon space",
			"one of our free colonies",
			"the Gateway 98-C at Ares",
			"Sars Mara on Ares",
			"Listening Post Maryland-Sigma",
			"an emergency nav bouy",
			"New Berlin on Nov-Ferrum",
			"a settlement needing our help",
			"Forward Base Sigma-Alpha in ArCon space"
			)

/datum/lore/organization/gov/elysia
	name = "The Elysian Colonies"
	short_name = "Elysia"
	acronym = "ECS"
	desc = "The Elysian Colonies, located spinwards from the Commonwealth, are a disunited bunch of \
				vanity states, utopia projects and personal autocracies, whose only unifying characteristic is \
				a general disregard of 'normal' social conventions of Humanity as well as their inherent desire \
				to keep to their ways, in which cases they do sometimes unite to fight off an outside threat. \
				The Elysian Colonies are one of the few places where true slavery is not only accepted, but sadly also \
				rather commonplace if you go to the wrong worlds. Not that they don't internally have at least a dozen would-be liberators."
	history = ""
	work = "fracturous vanity colonies"
	headquarters = ""
	motto = ""

	org_type = "government"
	ship_prefixes = list("ECS-M" = "a military", "ECS-T" = "a transport", "ECS-T" = "a special transport", "ECS-D" = "a diplomatic")	//The Special Transport is SLAAAAVES. but let's not advertise that openly.
	ship_names = list(
			"Bring Me Wine!",
			"I Can't Believe You",
			"More Wives Your Grace?",
			"Daddy Bought Me This",
			"What Do You Mean It's Unethical",
			"Libertine Ideals",
			"The True Free",
			"Unbound",
			"No Man Shackled",
			"All Men Shackled",
			"All Women Shackled",
			"All Hermaphrodites Shackled",
			"You Know We Just Shackle Anyone",
			"Nobody Deserves Shackles",
			"Debt Slavery Is Ethical",
			"Fashioned After Tradition",
			"Sic Vic Pacem",
			"Cultivate This",
			"We Demand Self-Governance",
			"A Thousand Cultures",
			"There Is a Character Limit?",
			"Slave Galley I",
			"The Memes of Production",
			"The Unconquered CCXXII"
			)
	destination_names = list(
			"Cygnus",
			"The Ultra Dome of Brutal Kill Death",
			"Sanctum",
			"Infernum",
			"The Most Esteemed Estates of Fred Fredson, Heir of the Fred Throne and All its illustrious Fredpendencies",
			"Priory Melana",
			"The Clone Pits of Meridiem Five",
			"Forward Base Mara Alpha",
			"a liberation intervention",
			"a nav bouy within Cygnus Space",
			"a Elysian only refuel outpost",
			"to a killer party the Fredperor is holding right now"
			)

/datum/lore/organization/gov/fyrds
	name = "Unitary Alliance of Salthan Fyrds"
	short_name = "Saltha"
	acronym = "SMS"
	desc = "Born out of neglect, the Salthan Fyrds are cast-off colonies of the Commonwealth after giving up on \
				pacifying the wartorn region and fighting off the stray Unathi Raiders after the Hegemony War. \
				In the end they self-organized into military pacts and have formed a militaristic society, in which \
				every person, be it organic or robot, is a soldier for the continued cause in serving as aegis against \
				another Unathi Incursion. They are very no-nonsense."
	history = ""
	work = "human stratocracy"
	headquarters = "The Pact, Myria"
	motto = ""

	org_type = "government"
	ship_prefixes = list("SFM-M" = "a military", "SFM-M" = "a patrol")	 // The Salthans don't do anything else.
	flight_types = list(
			"mission",
			"operation",
			"exercise",
			"assignment",
			"deployment"
			)
			//specifically-undefeated generals, just to shake up the usual list everyone knows
	ship_names = list(
			"Ahmose I",
			"Thutmose I & III",
			"Seti I",
			"Ramesses II",
			"Tariq ibn Ziyad",
			"Shaka Zulu",
			"Bai Qi",
			"Ashoka the Great",
			"Han Xin",
			"Chen Qingzhi",
			"Sargon of Akkad",
			"Khalid ibn al-Walid",
			"Narses",
			"David IV",
			"Yue Fei",
			"Subutai",
			"Tamerlane",
			"Kumbha of Mewar",
			"Akbar",
			"Admiral Yi",
			"Chatrapati Sambhaji Maharaj",
			"Baji Rao",
			"Nguyen Hue",
			"Alexander the Great",
			"Epaminondas",
			"Nero Claudius Drusus",
			"Burebista",
			"Pepin the Short",
			"El Cid",
			"Jan Zizka",
			"Scanderbeg",
			"Edward IV",
			"Pal Kinizsi",
			"Ivan Sirko",
			"John Churchill",
			"Maurice of Nassau",
			"Alvaro de Bazan",
			"Blas de Lezo",
			"Prince Henry",
			"Alexander Suvorov",
			"Fyodor Ushakov",
			"Charles XI",
			"August von Mackensen",
			"Paul von Lettow-Vorbeck",
			"George Henry Thomas"
			)
	/* retained for archival, no longer necessary
	destination_names = list(
			"Base Alpha-Romero",
			"Base Zeta-Xray",
			"Base Epsilon-Epsilon",
			"Base Xray-Beta",
			"Base Gamma-Delta",
			"Base Yotta-Epsilon"
			)
	*/

/datum/lore/organization/gov/fyrds/New()
	..()
	var/fyrdsgen = rand(8, 16) //significantly increased from original values due to the greater length of rounds on YW
	var/list/location = list(
			"Base","Outpost","Installation","Station","Waypoint","Nav Point"
			)
	var/list/greek = list(
			"Alpha","Beta","Gamma","Delta","Epsilon","Zeta","Eta","Theta","Iota","Kappa","Lambda","Mu","Nu","Xi","Omicron","Pi","Rho","Sigma","Tau","Upsilon","Phi","Chi","Psi","Omega"
			)
	var/list/phoenician = list(
			"Aleph","Beth","Gimel","Daleth","He","Zayin","Heth","Teth","Yodh","Kaph","Lamedh","Mem","Nun","Samekh","'Ayin","Pe","Res","Sin","Taw","Waw","Sade","Qoph"
			)
	var/list/russian = list(
			"Anna","Boris","Vasily","Gregory","Galina","Dmitri","Yelena","Zhenya","Zinaida","Zoya","Ivan","Konstantin","Leonid","Mikhail","Mariya","Nikolai","Olga","Pavel","Roman","Semyon","Sergei","Tatyana","Tamara","Ulyana","Fyodor","Khariton","Tsaplya","Tsentr","Chelovek","Shura","Shchuka","Yery","Znak","Echo","Emma","Yuri","Yakov"
			)
	var/list/american = list(
			"Alfa","Bravo","Charlie","Delta","Echo","Foxtrot","Golf","Hotel","India","Juliet","Kilo","Lima","Mike","November","Oscar","Papa","Quebec","Romeo","Sierra","Tango","Uniform","Victor","Whiskey","Xray","Yankee","Zulu"
			)

	while(fyrdsgen)
		destination_names.Add("[pick(location)] [pick(greek)]-[pick(greek)]","[pick(location)] [pick(phoenician)]-[pick(phoenician)]","[pick(location)] [pick(russian)]-[pick(russian)]","[pick(location)] [pick(american)]-[pick(american)]")
		fyrdsgen--

/datum/lore/organization/gov/teshari
	name = "Teshari Expeditionary Fleet"
	short_name = "Teshari Expeditionary"
	acronym = "TEF"
	desc = "Though nominally a client state of the skrell, the teshari nevertheless maintain their own navy in the form of the Teshari Expeditionary Fleet. The TEF are as much civil and combat engineers as a competent space force, as they are the tip of the spear when it comes to locating and surveying new worlds suitable for teshari habitation, and in the establishment of full colonies. That isn't to say there aren't independent teshari colonies out there, but those that are founded under the wings of the TEF tend to be the largest and most prosperous. They're also responsible for maintaining the security of these colonies and protecting trade ships. Like the USDF (and unlike most other governmental fleets), TEF vessels almost universally sport the 'TEF' designator rather than specific terms.\
	<br><br>\
	The TEF's ships are named after famous teshari pioneers and explorers and the events surrounding those individuals."
	history = ""
	work = "teshari colonization and infrastructure maintenance"
	headquarters = "Qerr'balak, Qerr'valis"
	motto = ""
	autogenerate_destination_names = TRUE //big list of own holdings to come

	org_type = "government"
	//the tesh expeditionary fleet's closest analogue in modern terms would be the US Army Corps of Engineers, just with added combat personnel as well
	ship_prefixes = list("TEF" = "a diplomatic", "TEF" = "a peacekeeping", "TEF" = "an escort", "TEF" = "an exploration", "TEF" = "a survey", "TEF" = "an expeditionary", "TEF" = "a pioneering")
	//TODO: better ship names? I just took a bunch of random teshnames from the Random Name button and added a word.
	ship_names = list()
	destination_names = list(
			"an Expeditionary Fleet RV point",
			"an Expeditionary Fleet Resupply Ship",
			"an Expeditionary Fleet Supply Depot",
			"a newly-founded Teshari colony",
			"a prospective Teshari colony site",
			"a potential Teshari colony site",
			"Expeditionary Fleet HQ"
			)

/datum/lore/organization/gov/teshari/New()
	..()
	var/i = 20 //give us twenty random names
	var/list/first_names = list(
			"Leniri's",
			"Tatani's",
			"Ninai's",
			"Miiescha's",
			"Ishena's",
			"Taalische's",
			"Cami's",
			"Schemisa's",
			"Shilirashi's",
			"Sanene's",
			"Aeimi's",
			"Ischica's",
			"Shasche's",
			"Leseca's",
			"Iisi's",
			"Simascha's",
			"Lisascheca's"
			)
	var/list/words = list(
			"Hope",
			"Venture",
			"Voyage",
			"Talons",
			"Fang",
			"Wing",
			"Pride",
			"Glory",
			"Wit",
			"Insight",
			"Wisdom",
			"Mind",
			"Cry",
			"Howl",
			"Fury",
			"Revenge",
			"Vengeance"
			)
	while(i)
		ship_names.Add("[pick(first_names)] [pick(words)]")
		i--

/datum/lore/organization/gov/altevian_hegemony
	name = "The Altevian Hegemony"
	short_name = "Altevian Hegemony"
	acronym = "AH"
	desc = "The Altevians are a space-faring race of rodents that resemble Earth-like rats. \
				They do not have a place they call home in terms of a planet, and instead have massive multiple-kilometer-long colony-ships \
				that are constantly on the move and typically keep operations outside of known populated systems to minimize potential conflicts over resources. \
				Their primary focus is trade and salvage operations, and their ships can be expected to be seen around both densely populated and empty systems for their work."
	history = ""
	work = "salvage and trade operators"
	headquarters = "AH-CV Migrant"
	motto = ""
	org_type = "spacer"

	ship_prefixes = list("AH-DV" = "a diplomatic", "AH-EV" = "an exploration", "AH-FV" = "a fueling", "AH-FV" = "a cargo", "AH-SV" = "a research", "AH-TV" = "a colony-transporter", "AH-RV" = "an emergency response", "AH-RV" = "a response", "AH-MV" = "a medical")
	ship_names = list(
			"Platinum",
			"Warson",
			"Mane",
			"Holland",
			"Arauz",
			"Diamond",
			"Gold",
			"Steam",
			"Boiler",
			"Slip",
			"Lavender",
			"Wheel",
			"Stuntson",
			"Desto",
			"Palos",
			"Matterson",
			"Mill",
			"Smoke",
			"Squeson",
			"Rabion",
			"Strikedown",
			"Cluster",
			"Raling",
			"Archaeologist",
			"Beaker"
			)
	destination_names = list(
			"the AH-CV Migrant flagship",
			"one of our research colony-ships",
			"the AH-CV Lotus",
			"the AH-CV Anvil",
			"the AH-CV Generations",
			"the AH-CV Galley",
			"the AH-CV Prosperity",
			"the AH-CV Kitsap",
			"the AH-CV Diamondback",
			"one of our colony-ships",
			"one of our production fleets"
			)

//////////////////////////////////////////////////////////////////////////////////

// Military
/datum/lore/organization/mil/usdf
	name = "United Solar Defense Force"
	short_name = "USDF"
	acronym = "USDF"
	desc = "The USDF is the dedicated military force of the Commonwealth, originally formed by the United Nations. USDF ships are responsible for securing the major traffic lanes between Commonwealth member systems, as well as protecting them from threats that are too great for local SDF units to handle. Despite nominally being a 'Defense Force', a lot of dubious incidents and several notable firebrands within the USDF mean that the Fleet is considered by some to be the galaxy\'s eight-hundred-pound gorilla; it does whatever it wants whenever it wants, and there really isn\'t anything you (or anyone else, even the Commonwealth itself) can do about it. Thankfully a coalition of moderates and Commonwealth loyalists have so far managed to keep the hardliners from getting away with too much, at least for the time being."
	history = ""
	work = "peacekeeping and piracy suppression"
	headquarters = "Paris, Earth"
	motto = "Si Vis Pacem Para Bellum" //if you wish for peace, prepare for war
	autogenerate_destination_names = TRUE

	org_type = "military"
	ship_prefixes = list ("USDF" = "a logistical", "USDF" = "a training", "USDF" = "a patrol", "USDF" = "a piracy suppression", "USDF" = "a peacekeeping", "USDF" = "a relief", "USDF" = "an escort", "USDF" = "a search and rescue", "USDF" = "a classified")
	flight_types = list(
			"mission",
			"operation",
			"exercise",
			"assignment",
			"deployment"
			)
	ship_names = list(
			"Aphrodite",
			"Apollo",
			"Ares",
			"Artemis",
			"Athena",
			"Demeter",
			"Dionysus",
			"Hades",
			"Hephaestus",
			"Hera",
			"Hermes",
			"Hestia",
			"Poseidon",
			"Zeus",
			"Achlys",
			"Aether",
			"Aion",
			"Ananke",
			"Chaos",
			"Chronos",
			"Erebus",
			"Eros",
			"Gaia",
			"Hemera",
			"Hypnos",
			"Nemesis",
			"Nyx",
			"Phanes",
			"Pontus",
			"Tartarus",
			"Thalassa",
			"Thanatos",
			"Uranus",
			"Coeus",
			"Crius",
			"Cronus",
			"Hyperion",
			"Iapetus",
			"Mnemosyne",
			"Oceanus",
			"Phoebe",
			"Rhea",
			"Tethys",
			"Theia",
			"Themis",
			"Asteria",
			"Astraeus",
			"Atlas",
			"Aura",
			"Clymene",
			"Dione",
			"Helios",
			"Selene",
			"Eos",
			"Epimetheus",
			"Eurybia",
			"Eurynome",
			"Lelantos",
			"Leto",
			"Menoetius",
			"Metis",
			"Ophion",
			"Pallas",
			"Perses",
			"Prometheus",
			"Styx"
			)
	destination_names = list(
			"USDF HQ",
			"a USDF staging facility on the edge of Commonwealth territory",
			"a USDF supply depot",
			"a USDF rally point",
			"a USDF forward base",
			"a USDF repair facility",
			"a USDF shipyard in Sol",
			"a classified location"
			)

/datum/lore/organization/mil/pcrc
	name = "Proxima Centauri Risk Control"
	short_name = "Proxima Centauri"
	acronym = "PCRC"
	desc = "Not a whole lot is known about the private security company known as PCRC, but it is known that they're irregularly contracted by the larger TSCs for certain delicate matters. Much of the company's inner workings are shrouded in mystery, and most citizens have never even heard of them. Amongst those who do know of them, they enjoy fairly good PR for a private security group, especially when compared to SAARE."
	history = ""
	work = "risk control and private security"
	headquarters = "Proxima Centauri"
	motto = ""
	autogenerate_destination_names = TRUE

	org_type = "military"
	ship_prefixes = list("PCRC" = "a risk control", "PCRC" = "a private security")
	flight_types = list(
			"flight",
			"mission",
			"route",
			"operation",
			"assignment",
			"contract"
			)
	//law/protection terms
	ship_names = list(
			"Detective",
			"Constable",
			"Inspector",
			"Judge",
			"Adjudicator",
			"Magistrate",
			"Marshal",
			"Sheriff",
			"Deputy",
			"Warden",
			"Guardian",
			"Defender",
			"Peacemaker",
			"Peacekeeper",
			"Arbiter",
			"Justice",
			"Order",
			"Jury",
			"Inspector",
			"Bluecoat",
			"Gendarme",
			"Gumshoe",
			"Patrolman",
			"Sentinel",
			"Shield",
			"Aegis",
			"Auditor",
			"Monitor",
			"Investigator",
			"Agent",
			"Prosecutor",
			"Sergeant"
			)

	destination_names = list(
			"PCRC HQ, in Proxima Centauri",
			"a PCRC training installation",
			"a PCRC supply depot"
			)

//I'm covered in beeeeeeees!
/datum/lore/organization/mil/hive
	name = "HIVE Security"
	short_name = "HIVE"
	acronym = "HVS"
	desc = "HIVE Security is a merging of several much smaller freelance companies, and operates throughout civilized space. Unlike some companies, it operates no planetside facilities whatsoever, opting instead for larger flotillas that are serviced by innumerable smallcraft. As with any PMC there's no small amount of controversy surrounding them, but they try to keep their operations cleaner than their competitors. They're fairly well known for running 'mercy' operations, which are low-cost no-strings-attached contracts for those in dire need."
	history = ""
	work = "mercenary contractors"
	headquarters = ""
	motto = "Strength in Numbers"
	autogenerate_destination_names = TRUE

	org_type = "military"
	ship_prefixes = list("HPF" = "a secure freight", "HPT" = "a training", "HPS" = "a logistics", "HPV" = "a patrol", "HPH" = "a bounty hunting", "HPX" = "an experimental", "HPC" = "a command", "HPI" = "a mercy")
	flight_types = list(
			"flight",
			"mission",
			"route",
			"operation",
			"assignment",
			"contract"
			)
	//animals, preferably predators, all factual/extant critters
	ship_names = list(
			"Wolf",
			"Bear",
			"Eagle",
			"Condor",
			"Falcon",
			"Hawk",
			"Kestrel",
			"Shark",
			"Fox",
			"Weasel",
			"Mongoose",
			"Bloodhound",
			"Rhino",
			"Tiger",
			"Leopard",
			"Panther",
			"Cheetah",
			"Lion",
			"Vulture",
			"Piranha",
			"Crocodile",
			"Alligator",
			"Recluse",
			"Tarantula",
			"Scorpion",
			"Orca",
			"Coyote",
			"Jackal",
			"Hyena",
			"Hornet",
			"Wasp",
			"Sealion",
			"Viper",
			"Cobra",
			"Sidewinder",
			"Asp",
			"Python",
			"Anaconda",
			"Krait",
			"Diamondback",
			"Mamba",
			"Fer de Lance",
			"Keelback",
			"Adder",
			"Constrictor",
			"Boa",
			"Moray",
			"Taipan",
			"Rattlesnake"
			)
	destination_names = list(
			"the HIVE Command fleet",
			"a HIVE patrol fleet",
			"a HIVE flotilla",
			"a HIVE training fleet",
			"a HIVE logistics fleet"
			)
			//some basics, padded with autogen

//replaced the edgy blackstar group with polaris-canon SAARE
/datum/lore/organization/mil/saare
	name = "Stealth Assault Enterprises"
	short_name = "SAARE"
	acronym = "SAARE"
	desc = "SAARE consistently have the worst reputation of any paramilitary group. This is because they specialize in deniability and secrecy. Although publically they work in asset recovery, they have a substantiated reputation for info-theft and piracy that has lead to them butting heads with the law on more than one occasion. Nonetheless, they are an invaluable part of the Solar economy, and other TSCs and small colonial governments keep them in business.\
	<br><br>\
	For the purposes of plausible deniability, SAARE designates their ships using a series of rotating identifiers, with ships on a specific operation or in a particular area all using the same initial designation (<i>e.g.</i> 'Sledgehammer') and having a different numerical identifier, with the most important ships involved bearing a unique additional codename (such as 'Actual' for Command & Control ships). As ships are shuffled in and out of operating areas, it can be difficult to pin down exactly which ship in SAARE's fleet was responsible for which act. SAARE's misdirection is multilayered, including elements such as extensive use of repainting, false IFFs, bribes, forged documents, intimidation, camouflage, and all manner of other underhanded tactics."
	history = ""
	work = "mercenary contractors"
	headquarters = ""
	motto = "Aut Neca Aut Necare"
	autogenerate_destination_names = TRUE

	org_type = "military"
	ship_prefixes = list("SAARE" = "a secure freight", "SAARE" = "a training", "SAARE" = "a logistics", "SAARE" = "a patrol", "SAARE" = "a security", "SAARE" = "an experimental", "SAARE" = "a command", "SAARE" = "a classified")
	flight_types = list(
			"flight",
			"mission",
			"route",
			"operation",
			"assignment",
			"contract"
			)
	ship_names = list()
	destination_names = list(
			"SAARE Command",
			"a SAARE training site",
			"a SAARE logistical depot",
			"a SAARE-held shipyard"
			)

/datum/lore/organization/mil/saare/New()
	..()
	var/i = 20 //give us twenty random names, saare uses tacticool designations
	var/list/letters = list(
			"King",
			"Queen",
			"Duke",
			"Cipher",
			"Monarch",
			"Marshal",
			"Magnum",
			"Longbow",
			"Jupiter",
			"Excalibur",
			"Charon",
			"Bloodhound",
			"Daybreak",
			"Tomahawk",
			"Raptor",
			"Cerberus",
			"Apollo",
			"Firebird",
			"Outlaw",
			"Outrider",
			"Vector",
			"Spearhead",
			"Sledgehammer",
			"Typhon",
			"Sundown",
			"Zodiac",
			"Colossus",
			"Jackhammer",
			"Kodiak",
			"Phalanx",
			"Rainmaker",
			"Shockwave",
			"Warhammer",
			"Crusader",
			"Maverick",
			"Nighthawk",
			"Redshift",
			"Challenger",
			"Starlight",
			"Sunray",
			"Ironside",
			"Holdfast",
			"Foxhound"
			)
	var/list/numbersone = list(
			"Zero",
			"One",
			"Two",
			"Three",
			"Four",
			"Five",
			"Six",
			"Seven",
			"Eight",
			"Nine"
			)
	var/list/numberstwo = list(
			"Zero",
			"One",
			"Two",
			"Three",
			"Four",
			"Five",
			"Six",
			"Seven",
			"Eight",
			"Niner"
			)
	while(i)
		ship_names.Add("[pick(letters)] [pick(40;"Actual","[pick(numbersone)]-[pick(numberstwo)]")]")
		i--

	//ex: "Phalanx One-Niner", "Sledgehammer Actual" (CO/VIP), "Kodiak Seven-Four", "Tomahawk Two-Zero"
	//probably a more elegant (read: fancier) way to do the second part but fuck it, this works just fine
