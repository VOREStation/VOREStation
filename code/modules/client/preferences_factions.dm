var/global/list/seen_citizenships = list()
var/global/list/seen_systems = list()
var/global/list/seen_factions = list()
var/global/list/seen_antag_factions = list()
var/global/list/seen_religions = list()

//Commenting this out for now until I work the lists it into the event generator/journalist/chaplain.
/proc/UpdateFactionList(mob/living/human/M)
	/*if(M && M.client && M.client.prefs)
		seen_citizenships |= M.client.prefs.citizenship
		seen_systems      |= M.client.prefs.home_system
		seen_factions     |= M.client.prefs.faction
		seen_religions    |= M.client.prefs.religion*/
	return

// VOREStation Edits Start
var/global/list/citizenship_choices = list(
	"Earth",
	"Mars",
	"Sif",
	"Binma",
	"Moghes",
	"Meralar",
	"Qerr'balak",
	"Virgo 3b Colony",
	"Virgo 4 NT Compound",
	"Venus",
	"Tiamat",
	"An-Tahk-Et"
	)

var/global/list/home_system_choices = list(
	"Virgo-Erigone",
	"Sol",
	"Proxima Centauri",
	"Procyon",
	"Vir",
	"Nyx",
	"Tau Ceti",
	"Qerr'valis",
	"Epsilon Ursae Minoris",
	"Rarkajar"
	)


var/global/list/faction_choices = list(
	"Commonwealth of Sol-Procyon",
	"United Fyrds",
	"Elysian Colonies",
	"Ares Confederation",
	"Vey Med",
	"Einstein Engines",
	"Free Trade Union",
	"NanoTrasen",
	"Ward-Takahashi GMB",
	"Gilthari Exports",
	"Grayson Manufactories Ltd.",
	"Aether Atmospherics",
	"Zeng-Hu Pharmaceuticals",
	"Hephaestus Industries",
	"Morpheus Cyberkinetics",
	"Xion Manufacturing Group"
	)
// VOREStation Edits Stop

var/global/list/antag_faction_choices = list()	//Should be populated after brainstorming. Leaving as blank in case brainstorming does not occur.

var/global/list/antag_visiblity_choices = list(
	"Hidden",
	"Shared",
	"Known"
	)

var/global/list/religion_choices = list(
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
	)