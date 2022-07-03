/datum/language/human/monkey
	name = "Chimpanzee"
	desc = "A collection of ooking noises made by monkeys"
	speech_verb = "chimpers"
	ask_verb = "chimpers"
	exclaim_verb = "screeches"
	key = "C"
	syllables = list("ook","eek")
	machine_understands = 0

/datum/language/skrell/monkey
	name = "Neaera"
	desc = "A collection of squiking noises made by naera."
	key = "8"
	syllables = list("squick","croak")
	machine_understands = 0

/datum/language/unathi/monkey
	name = "Stok"
	desc = "A collection of hissing noises made by stok."
	key = "7"
	syllables = list("hiss","gronk")
	machine_understands = 0

/datum/language/tajaran/monkey
	name = "Farwa"
	desc = "A collection of meowing noises made by farwa."
	key = "9"
	syllables = list("meow","mew")
	machine_understands = 0

/datum/language/corgi
	name = "Dog"
	desc = "A set of barks and woofs that only dogs can understand."
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
	desc = "A set of meows and mrowls that only cats can understand."
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
	desc = "A set of squeaks that only mice can understand."
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
	desc = "A set of chirps and squawks that only birds can understand."
	speech_verb = "chirps"
	ask_verb = "tweets"
	exclaim_verb = "squawks"
	key = "B"
	flags = RESTRICTED
	machine_understands = 0
	space_chance = 100
	syllables = list("chirp", "squawk", "tweet")
