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
	name = "Mouse"
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
	name = "Teppi"
	desc = "A set of gyohs that only teppi can understand."
	speech_verb = "rumbles"
	ask_verb = "tilts"
	exclaim_verb = "roars"
	key = "i"
	flags = WHITELISTED
	machine_understands = 0
	space_chance = 100
<<<<<<< HEAD
	syllables = list("gyoh", "snoof", "gyoooooOOOooh", "iuuuuh", "gyuuuuh")
=======
	syllables = list("chirp", "squawk", "tweet")

/datum/language/drake
	name = "Drake"
	desc = "Hiss hiss, feed me siffets."
	speech_verb = "hisses"
	ask_verb = "chirps"
	exclaim_verb = "rumbles"
	key = "D"
	flags = RESTRICTED
	machine_understands = 0
	space_chance = 30
	syllables = list("hss", "ssh", "khs", "hrr", "rrr", "rrn")
>>>>>>> 94cbe4de8dd... Merge pull request #8679 from MistakeNot4892/doggo
