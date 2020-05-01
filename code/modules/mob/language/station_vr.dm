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
	key = "G"
	syllables = list ("cheep", "peep", "tweet")

/datum/language/sergal
	name = LANGUAGE_SAGARU
	desc = "The dominant language of the Sergal homeworld, Vilous. It consists of aggressive low-pitched hissing and throaty growling."
	speech_verb = "snarls"
	colour = "sergal"
	key = "t"
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
	colour = "changeling"
	key = "M"
	machine_understands = FALSE
	flags = WHITELISTED | HIVEMIND

/datum/language/slavic
	name = LANGUAGE_SLAVIC
	desc = "The official language of the Independent Colonial Confederation of Gilgamesh, originally established in 2122 by the short-lived United Slavic Confederation on Earth."
	speech_verb = "govorit" // All Russian for "says" "asks" and "shouts". Mostly here as a joke.
	ask_verb = "sprashivaet"
	exclaim_verb = "krichit"
	whisper_verb = "shepchet"
	colour = "attack" // Red for slav!
	key = "P"
	syllables = list(
		"rus", "zem", "ave", "blyat", "cyk", "groz", "ski", "ska", "ven", "konst", "pol", "lin", "svy",
		"danya", "da", "mied", "kuz,", "zan", "das", "krem", "myka", "to", "st", "no", "na", "ni",
		"ko", "ne", "en", "po", "tro", "ra", "li", "on", "byl", "cto", "eni", "ost", "ol", "ego",
		"ver", "stv", "pro", "ski"
	)

/datum/language/mantid
	name = LANGUAGE_MANTID_VOCAL
	desc = "A curt, sharp language developed by the insectoid Ascent for use over comms."
	speech_verb = "clicks"
	ask_verb = "chirps"
	exclaim_verb = "rasps"
	colour = "alien"
	syllables = list("-","=","+","_","|","/")
	space_chance = 0
	key = "|"
	flags = RESTRICTED
	var/list/can_speak_properly = list(
		SPECIES_MANTID_ALATE
	)

/datum/language/mantid/broadcast(var/mob/living/speaker,var/message,var/speaker_mask)
	. = ..(speaker, message, speaker.real_name)

/datum/language/mantid/nonvocal
	key = "n"
	name = LANGUAGE_MANTID_NONVOCAL
	desc = "A complex visual language of bright bio-luminescent flashes, 'spoken' natively by the Kharmaani of the Ascent."
	colour = "alien"
	speech_verb = "flashes"
	ask_verb = "gleams"
	exclaim_verb = "flares"
	flags = RESTRICTED | NO_STUTTER | NONVERBAL

#define MANTID_SCRAMBLE_CACHE_LEN 20
/datum/language/mantid/nonvocal/scramble(var/input)
	if(input in scramble_cache)
		var/n = scramble_cache[input]
		scramble_cache -= input
		scramble_cache[input] = n
		return n
	var/i = length(input)
	var/scrambled_text = ""
	while(i)
		i--
		scrambled_text += "<font color='[get_random_colour(1)]'>*</font>"
	scramble_cache[input] = scrambled_text
	if(scramble_cache.len > MANTID_SCRAMBLE_CACHE_LEN)
		scramble_cache.Cut(1, scramble_cache.len-MANTID_SCRAMBLE_CACHE_LEN-1)
	return scrambled_text
#undef MANTID_SCRAMBLE_CACHE_LEN

/datum/language/mantid/nonvocal/can_speak_special(var/mob/living/speaker)
	if(istype(speaker) && speaker.isSynthetic())
		return TRUE
	else if(ishuman(speaker))
		var/mob/living/carbon/human/H = speaker
		return (H.species.name == SPECIES_MANTID_ALATE)
	return FALSE

/datum/language/unathi
	flags = 0
/datum/language/tajaran
	flags = 0
/datum/language/skrell
	flags = 0
/datum/language/seromi
	flags = 0
/datum/language/zaddat
	flags = 0
/datum/language/human
	flags = 0
/datum/language/gutter
	flags = WHITELISTED
	machine_understands = FALSE
/datum/language/human/monkey
	flags = RESTRICTED
/datum/language/skrell/monkey
	flags = RESTRICTED
/datum/language/unathi/monkey
	flags = RESTRICTED
/datum/language/tajaran/monkey
	flags = RESTRICTED
