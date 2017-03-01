//Datums for different companies that can be used by busy_space
/datum/lore/org
	var/name = ""				//Organization's name
	var/sname = ""				//Org's shortname (NanoTrasen for "NanoTrasen Incorporated")
	var/desc = ""				//Long description of org, but only current stuff, see 'history'
	var/history = ""			//Historical discription of org's origins
	var/work = ""				//Short description of their work, eg "an arms manufacturer"
	var/headquarters = ""		//Location of Org's HQ
	var/motto = ""				//A motto, if they have one

	var/org_flags = 0			//Flags for the org

	var/list/ship_prefixes = list()//Some might have more than one! Like NanoTrasen. Value is the mission they perform.
	var/list/ship_names = list()//Names of spaceships
	var/list/holding_names = list()//Names of static holdings (planets, bases)

//////////////////////////////////////////////////////////////////////////////////

/datum/lore/org/nanotrasen
	name = "NanoTrasen Incorporated"
	sname = "NanoTrasen"
	desc = "A megacorporation specializing in genetic and phoron research. The founder, Xavier Trasen, set the company \
			up to be a powerhouse of buying up smaller companies, and turning a profit on the backs of it's workers. \
			It's not known to be the most controversy-free company, nor the best to work for, though millions are employed \
			nonetheless by NanoTrasen."
	history = "Originally founded on Mars in 23rd Century by a man named Xavier Trasen, NanoTrasen started \
				out as a small company, whose research was mostly based around gene-therapy. After a controversy over \
				cloning, and buying many smaller companies, Xavier Trasen aggressively pursued phoron research \
				as soon as it was discovered, bringing NanoTrasen to the forefront of the field."
	work = "mega-conglomerate"
	headquarters = "Mars"
	motto = ""

	org_flags = ORG_HAS_NAVY|ORG_HAS_TECH|ORG_HAS_HUGENESS

	//Generic ship names!
	ship_prefixes = list("NSV" = "exploration", "NTV" = "hauling", "NDV" = "patrol", "NRV" = "emergency response")
	ship_names = list("Profit",
					"Discovery",
					"Endeavour",
					"Desire",
					"Gains",
					"Torch II",
					"Columbia",
					"Leyte Gulf",
					"Exeter",
					"Zhukov",
					"Xavier",
					"Liteon",
					"Fanatic",
					"Slow Boat",
					"Listing",
					"Even Faster",
					"Likely Story",
					"Looking Glass",
					"Witchcraft")
	holding_names = list("NSS Phi Gamma",
						"NSB Adelphia",
						"NSS Vertigo",
						"NSB Checkmate",
						"NSS Lampour",
						"NSB Adelade",
						"NSS Indiana",
						"NSB Memory Alpha",
						"NSS Memory Beta")

/datum/lore/org/federation
	name = "United Federation of Planets"
	sname = "Federation"
	desc = "The United Federation is a federation of planets that have agreed to exist semi-autonomously \
			under a single central hybrid government, sharing the ideals of liberty, equality, and rights \
			for all. It is one of the larger known interstellar powers in known space and is seen as being \
			the fastest building power. The core planet of Gaia is known for having a proud military culture \
			that, ironically, tends to stomp out any idea of warmongering from their cadets due to their \
			scarred history and the Federation's ideals."
	history = "Before the United Federation, there was a simple alliance with no name between core planet \
				members. The United Federation itself found its roots in the aftermath of the Bloody \
				Valentine Civil War, a racially motivated war that occurred in 2550 during the last year of \
				the Federation Alliance of Gaia between the Genetically Modified and so-called Naturalists. \
				Neutral nations in Gaia's political sphere, encouraged by alien observers, formed the United \
				Federation when the indiscriminate loss of life became intolerable. 2555 saw the official \
				signing of the Federation Charter between the core planet members."
	work = "governing body"
	headquarters = ""
	motto = ""

	org_flags = ORG_HAS_NAVY|ORG_HAS_TRADERS|ORG_HAS_TECH|ORG_HAS_DIPLO

	//Star Trek ship names!
	ship_prefixes = list("SCV" = "military", "STV" = "trading", "SDV" = "diplomatic")
	ship_names = list("Kestrel",
						"Beacon",
						"Signal",
						"Flying Freedom",
						"Los Canas",
						"Ixiom",
						"Falken",
						"Marigold",
						"White Valley",
						"Eternal",
						"Arkbird",
						"Akira",
						"Kongou",
						"Maki",
						"Kagero",
						"Nishiki",
						"Icarus",
						"Yuudachi",
						"Tiki",
						"Lucina",
						"Tenryu",
						"Spirit of Koni",
						"Lady of Onoilph")
	holding_names = list("Ruins of Chani City on Quarri III",
						"Ruins of Kreely City on Ocan II",
						"Ruins of Mishi City on Lucida IV",
						"Ruins of Posloo City on Pi Cephei Prime",
						"Molten Plains of Anarakis VII",
						"Living City of Shani",
						"Floating City of Nuni Vanni",
						"Crystalline City of Delve Tile",
						"New Iapetus Colony",
						"Onul Colony",
						"Ahemait Colony",
						"New Amasia Colony",
						"New Vesta Colony",
						"Amaus Research Facility on Azaleh III",
						"Living City of Na'me L'Tauri",
						"Living City of Fithpa",
						"Resource Mines of Lyra III",
						"Resource Mines of Chi Cerberi III",
						"Ceani Military Outpost on Rily VII",
						"Naro Industrial Complex on Scheddi III",
						"Mari Industrial Complex on Furlou Prime",
						"Runni Crystal Mines of Keid V")

/datum/lore/org/solgov
	name = "Solar Confederate Government"
	sname = "SolGov"
	desc = "SolGov is the entity in which many human states are members. Though SolGov has a dedicated miltiary force in the UNSC, \
			it also claims the use of the forces of the member states when it needs to affect a \
			military goal. Many if not most human states are members of SolGov, including all entities in Sol."
	history = "Originally a military/economic pact between Earth and Mars in the early days of human colonization, \
				the SolGov body of member states has grown over the years to be quite large, and hold a sizable \
				amount of power compared to similar bodies."
	work = "government of Sol"
	headquarters = "Luna"
	motto = ""

	org_flags = ORG_HAS_TRADERS|ORG_HAS_DIPLO

	//Random ship names!
	ship_prefixes = list("SOL" = "SolGov") //Don't ask questions!
	ship_names = list("Torch",
					"Phoenix",
					"Majesty",
					"Duke",
					"King",
					"Mandrake",
					"Foxglove",
					"Prompt",
					"Regal",
					"Lordship",
					"Highness",
					"Rapido",
					"Paperwork",
					"Arthur",
					"Durandal",
					"Roland")
	holding_names = list("San Francisco on Earth",
						"SolGov Fleet Academy on Earth",
						"Gateway One above Luna",
						"SolGov Command on Luna",
						"Olympus City on Mars",
						"Hermes Naval Shipyard above Mars",
						"a settlement on Titan",
						"a settlement on Europa",
						"Aleph Grande on Ganymede",
						"a new colony in Proxima II",
						"a new settlement on Ceti IV-B",
						"a colony ship around Ceti IV-B",
						"a classified location in SolGov territory")

/datum/lore/org/unsc
	name = "United Nations Space Command"
	sname = "Navy" //Otherwise they call the ships UNSC UNSC Name
	desc = "The dedicated military force of SolGov, formed from the remnants of the United Nations, is the might of SolGov. \
			While it is greater in military strength than most alien polities, it is not by much."
	history = ""
	work = ""
	headquarters = "Earth"
	motto = ""

	org_flags = ORG_HAS_NAVY|ORG_HAS_TECH

	//Halo ship names!
	ship_prefixes = list("UNSC" = "military")
	ship_names = list("Colorado",
						"Anjou",
						"Shanxi",
						"Hammerhead",
						"Piranha",
						"Barracuda",
						"DeGaulle",
						"Leonidas",
						"Tokugawa",
						"Halcyon",
						"Bastion",
						"Adjudicator",
						"Devestator",
						"Corsair",
						"Herakles",
						"Ain't No Sunshine",
						"Dust of Snow",
						"Finite Hearts")
	holding_names = list("San Francisco on Earth",
						"SolGov Fleet Academy on Earth",
						"Gateway One above Luna",
						"SolGov Command on Luna",
						"Olympus City on Mars",
						"Hermes Naval Shipyard above Mars",
						"a settlement on Titan",
						"a settlement on Europa",
						"Aleph Grande on Ganymede",
						"a new colony in Proxima II",
						"a new settlement on Ceti IV-B",
						"a colony ship around Ceti IV-B",
						"a classified location in SolGov territory")

/datum/lore/org/kitsuhana
	name = "Kitsuhana Heavy Industries"
	sname = "Kitsuhana"
	desc = "A large post-scarcity amalgamation of races, Kitsuhana is no longer a company but rather a loose association of 'members' \
			who only share the KHI name and their ideals in common. Kitsuhana accepts interviews to join their ranks, and though they have no \
			formal structure with regards to government or law, the concept of 'consent' drives most of the large decision making. Kitsuhanans \
			pride themselves on their ability to avoid consequence. Their post-scarcity allows them to rebuild, regrow, and replenish almost any \
			lost asset or resource nearly instantly. It leads to many of the Kitsuhana 'members' treating everything with frivolity, \
			and lends them a care-free demeanor."
	history = "Originally a heavy industrial equipment and space mining company. During a forced evacuation of their homeworld, \
			they were they only organization with enough ship capacity to evacuate any of the population, starting with their employees. \
			After the resulting slowship travel to nearby starsystems, most of the population decided to keep the moniker of the \
			company name. Over the years, Kitsuhana developed into a post-scarcity anarchy where virtually nothing has consequences \
			and Kitsuhana 'members' can live their lives as they see fit, often in isolation."
	work = "utopian anarchy"
	headquarters = "Kitsuhana Prime"
	motto = "Do what you want. We know we will."

	org_flags = ORG_HAS_TRADERS|ORG_HAS_TECH|ORG_HAS_MERCS|ORG_HAS_ENTERTAIN

	//Culture ship names!
	ship_prefixes = list("KHI" = "personal") //Everybody's out for themselves, yanno.
	ship_names = list("Nervous Energy",
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
						"Bad For Business",
						"Just Testing",
						"Size Isn't Everything",
						"Yawning Angel",
						"Liveware Problem",
						"Very Little Gravitas Indeed",
						"Zero Gravitas",
						"Gravitas Free Zone",
						"Absolutely No You-Know-What")
	holding_names = list("Kitsuhana Prime",
						"Kitsuhana Beta",
						"Kitsuhana Gamma",
						"the Kitsuhana Forge",
						"a Kitsuhanan's home",
						"a Kitsuhana ringworld in Pleis Ceti V",
						"a Kitsuhana ringworld in Lund VI",
						"a Kitsuhana ringworld in Dais IX",
						"a Kitsuhana ringworld in Leibert II-b")

/datum/lore/org/ares
    name = "Ares Confederation"
    sname = "ArCon"
    desc = "A rebel faction on the fringes of human space that renounced the government of both SolGov and their corporate overlords. \
			The Confederation has two fleets, a regular United Fleet Host, comprised of professional crewmen and officers and the Free Host of the Confederation, \
			which are privateers, volunteers and former pirates. The Ares Confederation only holds a \
			dozen planets, but are fiercely defending any incursion on their territory."
    history = "Originally only a strike of miners on the dusty, arid planet of Ares in the year 2540, \
    			the Ares Confederation was quickly established under the leadership of \
	 			retired UNSC Colonel Rodrick Gellaume, who is now Prime Minister."
    work = "rebel fringe government"
    headquarters = "Paraiso a Àstrea"
    motto = "Liberty to the Stars!"

    org_flags = ORG_HAS_NAVY|ORG_HAS_SHADY

    ship_prefixes = list("UFHV" = "military", "FFHV" = "shady")
    ship_names = list("Liberty",
					"Charged Negotiation",
					"People's Fist",
					"Corporation Breaker",
					"Laughing Maniac",
					"Not Insured",
					"Prehensile Ethics",
					"Fist of Ares",
					"Gellaume",
					"Memory of Fallen",
					"Star of Tiamat",
					"Mostly Harmless",
					"Hero of the Revolution",
					"Dawnstar",
					"Freedom",
					"Fiery Justice",
					"Bulwark of the Free",
					"Pride of Liberty",
					"Gauntlet",
					"Petrov",
					"Miko",
					"Mahama",
					"Jerome",
					"Rodrick",
					"Torch",
					"Torch of Freedom",
					"She Is One Of Ours Sir",
					"Fuck The Captain",
					"None Of Your Business")
    holding_names = list("Drydocks of the Ares Confederation",
						"a classified location",
						"a Homestead on Paraiso a Àstrea",
						"a contested sector of ArCon space",
						"one of our free colonies",
						"the Gateway 98-C at Arest",
						"Sars Mara on Ares",
						"Listening Post Maryland-Sigma",
						"an emergency nav bouy",
						"New Berlin on Nov-Ferrum",
						"a settlement needing our help",
						"Forward Base Sigma-Alpha in ArCon space")

/*
/datum/lore/org
	name = ""
	sname = ""
	desc = ""
	history = ""
	work = ""
	headquarters = ""
	motto = ""

	org_flags = 0

	ship_prefixes = list()
	ship_names = list()
	holding_names = list()
*/
