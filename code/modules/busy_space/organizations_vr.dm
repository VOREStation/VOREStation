//Datums for different companies that can be used by busy_space, VR edition

// Some of these intentionally copy from busy_space/organizations.dm, which is disabled in our server.
//////////////////////////////////////////////////////////////////////////////////

//Datums for different companies that can be used by busy_space
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
		"Ascendant",
		"Tenacious",
		"Pioneer",
		"Hawk",
		"Haste",
		"Radiant",
		"Luminous"
		)
	var/list/destination_names = list()	//Names of static holdings that the organization's ships visit regularly.
	var/autogenerate_destination_names = TRUE

/datum/lore/organization/New()
	..()
	if(autogenerate_destination_names) // Lets pad out the destination names.
		var/i = rand(6, 10)
		var/list/star_names = list(
			"Sol", "Alpha Centauri", "Sirius", "Vega", "Regulus", "Vir", "Algol", "Aldebaran", "Vilous", "Sanctum", "Qerr'Vallis", "Kataigal", "Antares",
			"Delta Doradus", "Menkar", "Geminga", "Elnath", "Gienah", "Mu Leporis", "Nyx", "Tau Ceti", "Virgo-Erigone", "Uueoa-Esa", "Vazzend", "Kastra-71",
			"Wazn", "Alphard", "Phact", "Altair", "El", "Eutopia", "Qerr'valis", "Qerrna-Lakirr", "Rarkajar", "the Almach Rim")
		var/list/destination_types = list("dockyard", "station", "vessel", "waystation", "telecommunications satellite", "spaceport", "distress beacon", "anomaly", "colony", "outpost")
		while(i)
			destination_names.Add("a [pick(destination_types)] in [pick(star_names)]")
			i--

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
	also offers one of the most comprehensive medical plans in Commonwealth space, up to and including cloning \
	and therapy.\
	<br><br>\
	NT's most well known products are its phoron based creations, especially those used in Cryotherapy. \
	It also boasts an prosthetic line, which is provided to its employees as needed, and is used as an incentive \
	for newly tested posibrains to remain with the company."
	history = "" // To be written someday.
	work = "research giant"
	headquarters = "Luna"
	motto = ""

	ship_prefixes = list("NSV" = "exploration", "NTV" = "hauling", "NDV" = "patrol", "NRV" = "emergency response")
	//Scientist or Greek mythology naming scheme
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
		"Oppenheimer"
		)
	// Note that the current station being used will be pruned from this list upon being instantiated
	destination_names = list(
		"NSS Exodus in Nyx",
		"NCS Northern Star in Vir",
		"NAB Smythside Central Headquarters in Sol",
		"NAS Zeus orbiting Virgo-Prime",
		"NIB Posideon in Alpha Centauri",
		"NTB Anur on Virgo-Prime",
		"the colony at Virgo-3B",
		"the phoron refinery in Vilous",
		"a dockyard orbiting Virgo-Prime",
		"an asteroid orbiting Virgo 3",
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
	desc = "Hephaestus Industries is the largest supplier of arms, ammunition, and small millitary vehicles in Sol space. \
	Hephaestus products have a reputation for reliability, and the corporation itself has a noted tendency to stay removed \
	from corporate politics. They enforce their neutrality with the help of a fairly large asset-protection contingent which \
	prevents any contracting polities from using their own materiel against them. The Terran Commonwealth and the Salthan Fyrds are of Hephastusâ€™ largest \
	bulk contractors owing to the above factors."
	history = ""
	work = "arms manufacturer"
	headquarters = ""
	motto = ""

	ship_prefixes = list("HTV" = "freight", "HTV" = "munitions resupply")
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
		"Tyr"
		)
	destination_names = list(
		"a SolCom dockyard on Luna",
		"a Fleet outpost in the Almach Rim",
		"a Fleet outpost on the Moghes border"
		)

/datum/lore/organization/tsc/vey_med
	name = "Vey-Medical"
	short_name = "Vey-Med"
	acronym = "VM"
	desc = "Vey-Med is one of the newer TSCs on the block and is notable for being largely owned and opperated by Skrell and Elysians. \
	Despite the suspicion and prejudice leveled at them for their origin, Vey-Med has obtained market dominance in \
	the sale of medical equipment-- from surgical tools to large medical devices to the Oddyseus trauma response mecha \
	and everything in between. Their equipment tends to be top-of-the-line, most obviously shown by their incredibly \
	human-like FBP designs. Veyâ€™s rise to stardom came from their introduction of ressurective cloning, although in \
	recent years theyâ€™ve been forced to diversify as their patents expired and NanoTrasen-made medications became \
	essential in bulk cloning."
	history = ""
	work = "medical equipment supplier"
	headquarters = ""
	motto = ""

	ship_prefixes = list("VTV" = "transportation", "VMV" = "medical resupply")
	// Diona names
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
		"A Thousand Thousand Planets Dangling From Branches"
		)
	destination_names = list(
		"a research facility in Samsara",
		"a SDTF near Ue-Orsi",
		"a sapientarian mission in the Almach Rim"
		)

/datum/lore/organization/tsc/zeng_hu
	name = "Zeng-Hu pharmaceuticals"
	short_name = "Zeng-Hu"
	acronym = "ZH"
	desc = "Zeng-Hu is an old TSC, based in the Sol system. Until the discovery of Phoron, Zeng-Hu maintained a stranglehold \
	on the market for medications, and many household names are patentted by Zeng-Hu-- Bicaridyne, Dylovene, Tricordrizine, \
	and Dexalin all came from a Zeng-Hu medical laboratory. Zeng-Huâ€™s fortunes have been in decline as Nanotrasenâ€™s development of \
	mass cloning medication cuts into their R&D and Vey-Medâ€™s superior medical equipment effectively decimated their own equipment \
	interests. The three-way rivalry between these companies for dominance in the medical field is well-known and a matter of \
	constant economic speculation."
	history = ""
	work = "pharmaceuticals company"
	headquarters = ""
	motto = ""

	ship_prefixes = list("ZTV" = "transportation", "ZMV" = "medical resupply")
	destination_names = list()

/datum/lore/organization/tsc/ward_takahashi
	name = "Ward-Takahashi General Manufacturing Conglomerate"
	short_name = "Ward-Takahashi"
	acronym = "WT"
	desc = "Ward-Takahashi focuses on the sale of small consumer electronics, with its computers, communicators, \
	and even mid-class automobiles a fixture of many households. Less famously, Ward-Takahashi also supplies most \
	of the AI cores on which vital control systems are mounted, and it is this branch of their industry that has \
	led to their tertiary interest in the development and sale of high-grade AI systems. Ward-Takahashiâ€™s economies \
	of scale frequently steal market share from Nanotrasenâ€™s high-price products, leading to a bitter rivalry in the \
	consumer electronics market."
	history = ""
	work = "electronics manufacturer"
	headquarters = ""
	motto = ""

	ship_prefixes = list("WTV" = "freight")
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
		"Asteroid"
		)
	destination_names = list()

/datum/lore/organization/tsc/bishop
	name = "Bishop Cybernetics"
	short_name = "Bishop"
	acronym = "BC"
	desc = "Bishop's focus is on high-class, stylish cybernetics. A favorite among transhumanists (and a byte noire for \
	bioconservatives), Bishop manufactures not only prostheses but also brain augmentation, synthetic organ replacements, \
	and odds and ends like implanted wrist-watches. Their business model tends towards smaller, boutique operations, giving \
	it a reputation for high price and luxury, with Bishop cyberware often rivalling Vey-Medâ€™s for cost. Bishopâ€™s reputation \
	for catering towards the interests of human augmentation enthusiasts instead of positronics have earned it ire from the \
	Positronic Rights Group and puts it in ideological (but not economic) comptetition with Morpheus Cyberkinetics."
	history = ""
	work = "cybernetics and augmentation manufacturer"
	headquarters = ""
	motto = ""

	ship_prefixes = list("BTV" = "transportation")
	destination_names = list()

/datum/lore/organization/tsc/morpheus
	name = "Morpheus Cyberkinetics"
	short_name = "Morpheus"
	acronym = "MC"
	desc = "The only large corporation run by positronic intelligences, Morpheus caters almost exclusively to their sensibilities \
	and needs. A product of the synthetic colony of Shelf, Morpheus eschews traditional advertising to keep their prices low and \
	relied on word of mouth among positronics to reach their current economic dominance. Morpheus in exchange lobbies heavily for \
	positronic rights, sponsors positronics through their Jans-Fhriede test, and tends to other positronic concerns to earn them \
	the good-will of the positronics, and the ire of those who wish to exploit them."
	history = ""
	work = "cybernetics manufacturer"
	headquarters = ""
	motto = ""

	ship_prefixes = list("MTV" = "freight")
	// Culture names, because Anewbe told me so.
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
		"Please Don't Explode II"
		)
	destination_names = list(
		"a trade outpost in Shelf"
		)

/datum/lore/organization/tsc/xion
	name = "Xion Manufacturing Group"
	short_name = "Xion"
	desc = "Xion, quietly, controls most of the market for industrial equipment on the frontier. Their portfolio includes mining exosuits, \
	factory equipment, rugged positronic chassis, and other pieces of equipment vital to the function of the economy. Xion \
	keeps its control of the market by leasing, not selling, their equipment, and through infamous and bloody patent protection \
	lawsuits. Xion are noted to be a favorite contractor for Rim engineers, owing to their low cost and rugged design."
	history = ""
	work = "industrial equipment manufacturer"
	headquarters = ""
	motto = ""

	ship_prefixes = list("XTV" = "hauling")
	destination_names = list()

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

	ship_prefixes = list("TTV" = "transport", "TTV" = "luxury transit")
	destination_names = list()

/datum/lore/organization/tsc/independent
	name = "Free Traders"
	short_name = "Free Trader"
	desc = "Though less common now than they were in the decades before the Sol Economic Organization took power, independent traders remain an important part of the galactic economy, owing in no small part to protective tarrifs established by the Free Trade Union in the late twenty-forth century."
	history = ""
	work = "trade and transit"
	headquarters = "N/A"
	motto = "N/A"

	ship_prefixes = list("IEV" = "prospecting", "IEC" = "prospecting", "IFV" = "bulk freight", "ITV" = "passenger transport", "ITC" = "just-in-time delivery")
	destination_names = list()

/datum/lore/organization/gov/solgov
	name = "Commonwealth of Sol-Procyon"
	short_name = "SolCom"
	acronym = "CWS"
	desc = "The Commonwealth of Sol-Procyon is the evolution of the many nation states of Earth and the outlying colonies \
			having spread amongst the stars. While not quite the hegemon of all Humanity, a narrow majority of them follow \
			the flag of the Commonwealth. The constant tug and pull of government versus corporation, democracy and power \
			troubles this federation of deeply entrenched human colonies much like it did in the 21st century. Some things \
			never change. However, they are economically and culturally quite dominant, although not everyone likes that fact."
	history = ""
	work = "rump state of humanity's colonies"
	headquarters = "Paris, Earth"
	motto = ""
	autogenerate_destination_names = TRUE

	ship_prefixes = list("CWS-T" = "transportation", "CWS-D" = "diplomatic", "CWS-F" = "freight")
	destination_names = list(
						"Mercury",
						"Venus",
						"Earth",
						"Luna",
						"Mars",
						"Titan",
						"Europa",
						"the SolCom embassy in Virgo-Erigone",
						"the SolCom embassy in Vilous"
						)// autogen will add a lot of other places as well.
/* // Waiting for Joan to do their thing.
/datum/lore/organization/gov/federation
	name = "United Federation of Planets"
	short_name = "Federation"
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
	destination_names = list("Ruins of Chani City on Quarri III",
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
*/

/datum/lore/organization/mil/usdf
	name = "United Sol Defense Force"
	short_name = "" // This is blank on purpose. Otherwise they call the ships "USDF USDF Name"
	desc = "The USDF is the dedicated military force of the Commonwealth of Sol-Procyon, originally formed by a council of the Supranations. It is a \
			considerable tool of military power projection, and is able to effectively police a vast amount of space within the Orion Spur. \
			However, regions beyond that are too far for the USDF to be a major player."
	history = ""
	work = "peacekeeping and piracy suppression"
	headquarters = "Paris, Earth"
	motto = "pax in terra et astra" // Peace on Earth and Stars
	ship_prefixes = list("USDF" = "military", "USDF" = "anti-piracy", "USDF" = "escort", "USDF" = "humanitarian", "USDF" = "peacekeeping", "USDF" = "search-and-rescue", "USDF" = "war game") // It's all USDF but let's mix up what missions they do.
	ship_names = list("Aegis Fate",
					"Ain't No Sunshine",
					"All Under Heaven",
					"Allegiance",
					"Andraste",
					"Anjou",
					"Barracuda",
					"Bastion",
					"Buenos Aires",
					"Bum Rush",
					"Callisto",
					"Charon",
					"Colorado",
					"Commonwealth",
					"Corsair",
					"DeGaulle",
					"Devestator",
					"Dust of Snow",
					"Euphrates",
					"Fair Weather",
					"Finite Hearts",
					"Forward Unto Dawn",
					"Gettysburg",
					"Glamorgan",
					"Grafton",
					"Great Wall",
					"Hammerhead",
					"Herakles",
					"Hoenir",
					"In Amber Clad",
					"Iwo Jima",
					"Jolly Roger",
					"Jormungandr",
					"Leonidas",
					"Meriwether Lewis",
					"Mona Lisa",
					"Olympus",
					"Paris",
					"Pony Express",
					"Providence",
					"Prydwen",
					"Purpose",
					"Ready or Not",
					"Redoubtable",
					"Rising Sun",
					"Saratoga",
					"Savannah",
					"Shanxi",
					"Song of the East",
					"Stalwart Dawn",
					"Strident",
					"Tannenberg",
					"Tokugawa",
					"Totem Lake",
					"Tripping Light",
					"Two for Flinching")
	destination_names = list("San Francisco on Earth",
						"Gateway One above Luna",
						"SolCom Headquarters on Earth",
						"Olympus City on Mars",
						"Hermes Naval Shipyard above Mars",
						"Cairo Station above Earth",
						"a rendezvous point in the Cyprus Arm",
						"a settlement on Titan",
						"a settlement on Europa",
						"Aleph Grande on Ganymede",
						"a colony in Proxima II",
						"a settlement on Ceti IV-B",
						"a colony ship around Ceti IV-B",
						"a naval station above Ceti IV-B",
						"a classified location in SolCom territory",
						"a classified location in uncharted space",
						"an emergency nav bouy",
						"the USDF Naval Academy on Earth",
						"Fort Rain on Tal")

/datum/lore/organization/gov/ares
	name = "Ares Confederation"
	short_name = "ArCon"
	desc = "A loose coalition of socialist and communist movements on the fringes of the human diaspora \
			the Ares Confederation is a government-in-exile from the original uprisings of Mars to stop \
			the government of corporations and capitalist interests over Humanity. While they failed twice \
			they have made their own home far beyond the reach of an effective military response by the \
			Commonwealth. They have become renowned engineers and terraforming experts, mostly due to necessity."
	history = ""
	work = "idealist socialist government"
	headquarters = "Paraiso a Ã€strea"
	motto = "Liberty to the Stars!"

	ship_prefixes = list("UFHV" = "military", "FFHV" = "shady")
	ship_names = list("Bulwark of the Free",
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
					"One Of Ours, Captain!",
					"Is This Thing On?",
					"Front Toward Enemy",
					"Path of Prosperity",
					"Freedom Cry",
					"Rebel Yell",
					"We Will Return To Mars",
					"According To Our Abilities",
					"Posadism Gang",
					"Accelerationism Doesn't Work In A Vaccuum",
					"Don't Shoot, We're Unarmed I Think",
					"The Big Stick For Speaking Softly",
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
					"She Is One Of Ours Sir",
					"Star of Tiamat",
					"Torch of Freedom",
					"Torch")
	destination_names = list("Drydocks of the Ares Confederation",
						"a classified location",
						"a Homestead on Paraiso a Ã€strea",
						"a contested sector of ArCon space",
						"one of our free colonies",
						"the Gateway 98-C at Ares",
						"Sars Mara on Ares",
						"Listening Post Maryland-Sigma",
						"an emergency nav bouy",
						"New Berlin on Nov-Ferrum",
						"a settlement needing our help",
						"Forward Base Sigma-Alpha in ArCon space")

/datum/lore/organization/gov/elysian
	name = "The Elysian Colonies"
	short_name = "Demi-Monde"
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

	ship_prefixes = list("ECS" = "military", "ECS" = "Transport", "ECS" = "Special Transport", "ECS" = "Diplomat")	//The Special Transport is SLAAAAVES.
	ship_names = list("Bring Me Wine!",
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
					"The Unconquered CCXXII"

		)
	destination_names = list("Cygnus",
									"The Ultra Dome of Brutal Kill Death",
									"Sanctum",
									"Infernum",
									"The Most Esteemed Estates of Fred Fredson, Heir of the Fred Throne and All its illustrious Fredpendencies",
									"Priory Melana",
									"The Clone Pits of Meridiem Five",
									"Forward Base Mara Alpha",
									"a very tasty looking distress call",
									"a liberation intervention",
									"a nav bouy within Cygnus Space",
									"a Elysian only refuel outpost",
									"to a killer party the Fredperor is holding right now")


/datum/lore/organization/gov/fyrds
	name = "Unitary Alliance of Salthan Fyrds"
	short_name = "Fyrds"
	acronym = "SMS"
	desc = "Born out of neglect, the Salthan Fyrds are cast-off colonies of the Commonwealth after giving up on \
				pacifying the wartorn region and fighting off the stray Unathi Raiders after the Hegemony War. \
				In the end they self-organized into military pacts and have formed a militaristic society, in which \
				every person, be it organic or robot, is a soldier for the continued cause in serving as aegis against \
				another Unathi Incursion. They are very no-nonsense."
	history = ""
	work = "human stratocracy"
	headquarters = "The Pact,Myria"
	motto = ""

	ship_prefixes = list("SMS" = "Military")	 // The Salthans don't do anything else.
	ship_names = list("Yi Sun-sin",
							"Horatio Nelson",
							"Scipio Africanus",
							"Hannibal Barca",
							"Hamilcar Barca",
							"Caesar",
							"Belisarius",
							"Aggripa",
							"Pericles",
							"Alexander",
							"Napoleon Bonaparte",
							"Charles XI",
							"Blas de Lezo",
							"Ivan Sirko",
							"Frederick the Great",
							"William of Normandy",
							"Shaka Zulu",
							"Patton",
							"MacArthur",
							"Rommel")
	destination_names = list("Base Alpha-Romero",
									"Base Zeta-Xray",
									"Base Epsilon-Epsilon",
									"Base Xray-Beta",
									"Base Gamma-Delta",
									"Base Yotta-Epsilon")
