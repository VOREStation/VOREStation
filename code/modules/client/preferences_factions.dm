GLOBAL_LIST_EMPTY(seen_citizenships)
GLOBAL_LIST_EMPTY(seen_systems)
GLOBAL_LIST_EMPTY(seen_factions)
GLOBAL_LIST_EMPTY(seen_antag_factions)
GLOBAL_LIST_EMPTY(seen_religions)

//Commenting this out for now until I work the lists it into the event generator/journalist/chaplain.
/proc/UpdateFactionList(mob/living/carbon/human/M)
	/*if(M && M.client && M.client.prefs)
		seen_citizenships |= M.client.prefs.citizenship
		seen_systems      |= M.client.prefs.home_system
		seen_factions     |= M.client.prefs.faction
		seen_religions    |= M.client.prefs.religion*/
	return

// VOREStation Edits Start
GLOBAL_LIST_INIT(citizenship_choices, list(
	"Greater Human Diaspora",
	"Commonwealth of Sol-Procyon",
	"Skrell Consensus",
	"Moghes Hegemony",
	"Tajaran Diaspora",
	"Unitary Alliance of Salthan Fyrds",
	"Elysian Colonies",
	"Third Ares Confederation",
	"Teshari Expeditionary Fleet",
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
	"Stealth Assault Enterprises"
	))
// VOREStation Edits Stop

GLOBAL_LIST_EMPTY(antag_faction_choices) //Should be populated after brainstorming. Leaving as blank in case brainstorming does not occur.

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
