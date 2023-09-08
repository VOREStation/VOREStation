/datum/language/human/animal
	name = LANGUAGE_ANIMAL
	desc = "A collection of ooking noises made by monkeys"
	speech_verb = "says"
	ask_verb = "inquires"
	exclaim_verb = "yells"
	key = "C"
	syllables = list("chrp","tweet","squick","croak","hiss","gronk","meow","mew","bark", "woof", "bowwow", "yap", "arf") //This is a generalized animal language. If spoken by an animal, it comes out with the mob noises. This only occurs when spoken by a carbon (human).
	machine_understands = 0

/datum/language/mouse
	name = LANGUAGE_MOUSE
	desc = "A set of squeaks that only mice can understand."
	speech_verb = "squeaks"
	ask_verb = "squeaks"
	exclaim_verb = "squeaks"
	key = "m"
	flags = RESTRICTED
	machine_understands = 0
	space_chance = 100
	syllables = list("squeak")	// , "gripes", "oi", "meow")

/datum/language/teppi
	name = LANGUAGE_TEPPI
	desc = "A set of gyohs that only teppi can understand."
	speech_verb = "rumbles"
	ask_verb = "tilts"
	exclaim_verb = "roars"
	key = "i"
	flags = WHITELISTED
	machine_understands = 0
	space_chance = 100
	syllables = list("gyoh", "snoof", "gyoooooOOOooh", "iuuuuh", "gyuuuuh", "groah", "gyooh", "giouh", "puff", "huff", "ghom", "gyuh", "rrrr", "ghh", "uuah", "groh", "gyaah")
	colour = "teppi"
