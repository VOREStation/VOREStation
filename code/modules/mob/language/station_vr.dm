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
	desc = "A tweety language primarily spoken by Nevreans."
	speech_verb = "chirps"
	colour = "birdsongc"
	key = "G"
	syllables = list ("chee", "pee", "twee", "hoo", "ee", "oo", "ch", "ts", "sch", "twe", "too", "pha", "ewe", "shee", "shoo", "p", "tw", "aw", "caw", "c")

/datum/language/sergal
	name = LANGUAGE_SAGARU
	desc = "The dominant language of the Sergal homeworld, Vilous. It consists of aggressive low-pitched hissing and throaty growling."
	speech_verb = "snarls"
	colour = "sergal"
	key = "T"
	syllables = list ("grr", "gah", "woof", "arf", "arra", "rah", "wor", "sarg")

/datum/language/vulpkanin
	name = LANGUAGE_CANILUNZT
	desc = "The guttural language spoken and utilized by the inhabitants of Vazzend system, composed of growls, barks, yaps, and heavy utilization of ears and tail movements. Vulpkanin speak this language with ease."
	speech_verb = "rrrfts"
	ask_verb = "rurs"
	exclaim_verb = "barks"
	colour = "vulpkanin"
	key = "V"
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
	key = "S"
	syllables = list("sque","sqah","boo","beh","nweh","boopa","nah","wah","een","sweh")

/datum/language/demon
	name = LANGUAGE_DAEMON
	desc = "The language spoken by the demons of Infernum, it's composed of deep chanting. It's rarely spoken off of Infernum due to the volume one has to exert."
	speech_verb = "chants"
	ask_verb = "croons"
	exclaim_verb = "incants"
	colour = "daemon" //So fancy
	key = "D"
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
	key = "I"
	syllables = list("salve","sum","loqui","operatur","iusta","et","permittit","facere","effercio","pluribus","enim","hoc",
	"mihi","wan","six","tartu")
	machine_understands = FALSE

/datum/language/bug
	name = LANGUAGE_VESPINAE
	desc = "A jarring and clicky language developed and used by Vasilissans, it is designed for use with mouthparts and as a result has become a common language for various arthropod species."
	speech_verb = "clicks"
	ask_verb = "chitters"
	exclaim_verb = "rasps"
	colour = "bug"
	key = "X"
	syllables = list("vaur","uyek","uyit","avek","sc'theth","k'ztak","teth","wre'ge","lii","dra'","zo'","ra'","kax'","zz","vh","ik","ak",
    "uhk","zir","sc'orth","sc'er","thc'yek","th'zirk","th'esk","k'ayek","ka'mil","sc'","ik'yir","yol","kig","k'zit","'","'","zrk","krg","isk'yet","na'k",
    "sc'azz","th'sc","nil","n'ahk","sc'yeth","aur'sk","iy'it","azzg","a'","i'","o'","u'","a","i","o","u","zz","kr","ak","nrk","tzzk","bz","xic'","k'lax'","histh")

/datum/language/shadekin
	name = LANGUAGE_SHADEKIN
	desc = "Shadekin seem to always know what the others are thinking. This is probably why."
	speech_verb = "mars"
	ask_verb = "mars"
	exclaim_verb = "MARS"
	colour = "shadekin"
	key = "M"
	machine_understands = FALSE
	flags = WHITELISTED | HIVEMIND

/datum/language/drudakar
	name = LANGUAGE_DRUDAKAR
	desc = "The native language of the D'Rudak'Ar, a loosely tied together community of dragons and demi-dragons based in the Diul system. Features include many hard consonants and rolling 'r's."
	speech_verb = "gaos"
	ask_verb = "gaos"
	exclaim_verb = "GAOS"
	whisper_verb = "gaos"
	colour = "drudakar"
	key = "K"
	syllables = list(
		"gok", "rha", "rou", "gao", "do", "ra", "bo", "lah", "draz", "khi", "zah", "lah", "ora", "ille",
		"ghlas", "ghlai", "tyur", "vah", "bao", "raag", "drag", "zhi", "dahl", "tiyr", "vahl", "nyem",
		"roar", "hyaa", "ma", "ha", "ya", "shi", "yo", "go"
	)

/datum/language/spacer
	name = LANGUAGE_SPACER
	desc = "A rough pidgin-language comprised of Tradeband, Gutter, and Sol Common used by various space-born communities unique to Humanity."
	key = "J"
	syllables = list(
		"ada", "zir", "bian", "ach", "usk", "ado", "ich", "cuan", "iga", "qing", "le", "que", "ki", "qaf", "dei", "eta"
	)
	colour = "spacer"
	machine_understands = TRUE

/datum/language/tavan
	name = LANGUAGE_TAVAN
	desc = "A language native to the rat-like Altevians, it has been adopted by other rodent faring species over time."
	key = "E"
	speech_verb = "squeaks"
	whisper_verb = "squiks"
	exclaim_verb = "squeaks loudly"
	syllables = list ("sque", "uik", "squeak", "squee", "eak", "eek", "uek", "squik",
			"squeek", "sq", "squee", "ee", "ek", "ak", "ueak", "squea")
	colour = "tavan"

/datum/language/echosong
	name = LANGUAGE_ECHOSONG
	desc = "An ultrasound-based language, inaudible to those unable to understand it, spoken by few species capable of actually hearing it."
	key = "U"
	signlang_verb = list("opens their mouth soundlessly", "mouthes something silently")
	signlang_verb_understood = list("squeaks")
	colour = "echosong"
	flags = INAUDIBLE
	ignore_adverb = TRUE

/datum/language/echosong/scramble(var/input, var/list/known_languages)
	return stars(input)

/datum/language/lleill
	name = LANGUAGE_LLEILL
	desc = "An ancient, gutteral language involving a lot of spitting."
	speech_verb = "speaks"
	ask_verb = "ponders"
	exclaim_verb = "calls"
	colour = "echosong"
	key = "L"
	syllables = list(
		"llyn", "bren", "gwyn", "gwyr", "ddys", "dath", "llio", "cym", "ddrai", "ffyr", "lle", "dy", "eto", "uno", "dydno", "llego", "bryth", "ffair",
		"ynys", "ed", "fore", "oe", "hen", "wladd", "ty", "nha", "dwy", "mae", "dros", "pob", "ia", "wyll", "gwdd", "fi"
	)
	machine_understands = FALSE
	flags = WHITELISTED

/datum/language/echosong/broadcast(var/mob/living/speaker, var/message, var/speaker_mask)
	log_say("(INAUDIBLE) [message]", speaker)
	speaker.say_signlang(format_message(message), pick(signlang_verb), pick(signlang_verb_understood), src, 2)

/datum/language/unathi
	flags = 0
/datum/language/tajaran
	flags = 0
/datum/language/skrell
	flags = 0
/datum/language/teshari
	flags = 0
/datum/language/zaddat
	flags = 0
/datum/language/human
	flags = 0
/datum/language/gutter
	machine_understands = FALSE
	desc = "A dialect of Tradeband not uncommon amongst traders in the Free Trade Union. The language is often difficult to translate due to changing frequently and being highly colloquial."
	partial_understanding = list(LANGUAGE_TRADEBAND = 30, LANGUAGE_SOL_COMMON = 10)
/datum/language/human/animal
	flags = RESTRICTED