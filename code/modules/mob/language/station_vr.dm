/* 'basic' language; spoken by default.
/datum/language/common
	name = "Galactic Common"
	desc = "The common galactic tongue."
	speech_verb = "says"
	whisper_verb = "whispers"
	key = "0"
	flags = RESTRICTED
	syllables = list("blah","blah","blah","bleh","meh","neh","nah","wah")
*/

/datum/language/birdsong
	name = LANGUAGE_BIRDSONG
	desc = "A language primarily spoken by Narvians"
	speech_verb = "chirps"
	colour = "birdsongc"
	key = "7"
	syllables = list ("cheep", "peep", "tweet")

/datum/language/sergal
	name = LANGUAGE_SAGARU
	desc = "The dominant language of the Sergal homeworld, Vilous. It consists of aggressive low-pitched hissing and throaty growling."
	speech_verb = "snarls"
	colour = "sergal"
	key = "z"
	syllables = list ("grr", "gah", "woof", "arf", "arra", "rah", "wor", "sarg")

/datum/language/vulpkanin
	name = LANGUAGE_CANILUNZT
	desc = "The guttural language spoken and utilized by the inhabitants of Vazzend system, composed of growls, barks, yaps, and heavy utilization of ears and tail movements. Vulpkanin speak this language with ease."
	speech_verb = "rrrfts"
	ask_verb = "rurs"
	exclaim_verb = "barks"
	colour = "vulpkanin"
	key = "8"
	syllables = list("rur","ya","cen","rawr","bar","kuk","tek","qat","uk","wu","vuh","tah","tch","schz","auch", \
	"ist","ein","entch","zwichs","tut","mir","wo","bis","es","vor","nic","gro","lll","enem","zandt","tzch","noch", \
	"hel","ischt","far","wa","baram","iereng","tech","lach","sam","mak","lich","gen","or","ag","eck","gec","stag","onn", \
	"bin","ket","jarl","vulf","einech","cresthz","azunein","ghzth")

/datum/language/squirrel
	name = LANGUAGE_ECUREUILIAN
	desc = "The native tongue of the inhabitants of Gaia. Squirrelkin and other beastkins of Gaia can use their ears and tails in addition to speech to communitcate."
	speech_verb = "squeaks"
	whisper_verb = "whispers"
	exclaim_verb = "chitters"
	key = "9"
	syllables = list("sque","sqah","boo","beh","nweh","boopa","nah","wah","een","sweh")

/datum/language/demon
	name = LANGUAGE_DAEMON
	desc = "The language spoken by the demons of Infernum, it's composed of deep chanting. It's rarely spoken off of Infernum due to the volume one has to exert."
	speech_verb = "chants"
	ask_verb = "croons"
	exclaim_verb = "incants"
	colour = "daemon" //So fancy
	key = "n"
	syllables = list("viepn","e","bag","docu","kar","xlaqf","raa","qwos","nen","ty","von","kytaf","xin","ty","ka","baak","hlafaifpyk","znu","agrith","na'ar","uah","plhu","six","fhler","bjel","scee","lleri",
	"dttm","aggr","uujl","hjjifr","wwuthaav",)
	machine_understands = FALSE

/datum/language/angel
	name = LANGUAGE_ENOCHIAN
	desc = "The graceful language spoken by angels, composed of quiet hymns. Formally, Angels sing it."
	speech_verb = "sings"
	ask_verb = "hums"
	exclaim_verb = "loudly sings"
	colour = "enochian" //So fancy
	key = "a"
	syllables = list("salve","sum","loqui","operatur","iusta","et","permittit","facere","effercio","pluribus","enim","hoc",
	"mihi","wan","six","salve","tartu")
	machine_understands = FALSE


/datum/language/unathi
	flags = 0
/datum/language/tajaran
	flags = 0
/datum/language/skrell
	flags = 0
/datum/language/human
	flags = 0
/datum/language/seromi
	flags = 0
/datum/language/gutter
	flags = WHITELISTED
	machine_understands = FALSE
