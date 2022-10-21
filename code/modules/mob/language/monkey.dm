/datum/language/human/monkey
	name = "Chimpanzee"
	desc = "Ook ook ook."
	speech_verb = "chimpers"
	ask_verb = "chimpers"
	exclaim_verb = "screeches"
	key = "C"
	syllables = list("ook","eek")
	machine_understands = 0

/datum/language/skrell/monkey
	name = "Neaera"
	desc = "Squik squik squik."
	key = "8"
	syllables = list("hiss","gronk")
	machine_understands = 0

/datum/language/unathi/monkey
	name = "Stok"
	desc = "Hiss hiss hiss."
	key = "S"
	syllables = list("squick","croak")
	machine_understands = 0

/datum/language/tajaran/monkey
	name = "Farwa"
	desc = "Meow meow meow."
	key = "9"
	syllables = list("meow","mew")
	machine_understands = 0

/datum/language/corgi
	name = "Dog"
	desc = "Woof woof woof."
	speech_verb = "barks"
	ask_verb = "woofs"
	exclaim_verb = "howls"
	key = "n"
	flags = RESTRICTED
	machine_understands = 0
	space_chance = 100
	syllables = list("bark", "woof", "bowwow", "yap", "arf")

/datum/language/cat
	name = "Cat"
	desc = "Meow meow meow."
	speech_verb = "meows"
	ask_verb = "mrowls"
	exclaim_verb = "yowls"
	key = "c"
	flags = RESTRICTED
	machine_understands = 0
	space_chance = 100
	syllables = list("meow", "mrowl", "purr", "meow", "meow", "meow")

/datum/language/mouse
	name = "Mouse"
	desc = "Squeak squeak. *Nibbles on cheese*"
	speech_verb = "squeaks"
	ask_verb = "squeaks"
	exclaim_verb = "squeaks"
	key = "m"
	flags = RESTRICTED
	machine_understands = 0
	space_chance = 100
	syllables = list("squeak")	// , "gripes", "oi", "meow")

/datum/language/bird
	name = "Bird"
	desc = "Chirp chirp, give me food"
	speech_verb = "chirps"
	ask_verb = "tweets"
	exclaim_verb = "squawks"
	key = "B"
	flags = RESTRICTED
	machine_understands = 0
	space_chance = 100
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
