/mob/living/simple_animal/retaliate/awoo
	name = "wolfgirl"
	desc = "AwooOOOOoooo!"
	tt_desc = "Homo lupus"
	icon = 'icons/mob/vore.dmi'
	icon_state = "awoo"
	icon_living = "awoo"
	icon_dead = "awoo-dead"

	faction = "awoo"
	maxHealth = 30
	health = 30

	run_at_them = 0
	cooperative = 1
	investigates = 1
	firing_lines = 1
	returns_home = 1
	reacts = 1

	response_help = "pats the"
	response_disarm = "gently pushes aside the"
	response_harm = "hits the"

	harm_intent_damage = 8
	melee_damage_lower = 15
	melee_damage_upper = 15
	attacktext = list("slashed")

	speak_chance = 1
	speak = list("AwoooOOOOoooo!",
				"Awoo~",
				"I'll protect the forest! ... Where's the forest again?",
				"All I need is my sword!",
				"Awoo?",
				"Anyone else smell that?")
	emote_hear = list("awoooos!","hmms to herself","plays with her sword")
	emote_see = list("narrows her eyes","sniffs the air")
	say_understood = list()
	say_cannot = list()
	say_maybe_target = list("An enemy!?","What was that?","Is that...?","Hmm?")
	say_got_target = list("You won't get away!","I've had it!","I'll vanquish you!","AWOOOOO!")
	reactions = list("Are you a dog?" = "Who, me?! No! Stop saying that!",
					"Awoo!" = "AwooooOOOOooo!",
					"Awoo?" = "Awoo.",
					"Awoo." = "Awoo?",)

	var/loopstop = 0 //To prevent circular awoooos.

/mob/living/simple_animal/retaliate/awoo/hear_say()
	if(world.time - loopstop < 5 SECONDS)
		return
	else
		loopstop = world.time
		..()

// Activate Noms!
/mob/living/simple_animal/retaliate/awoo
	vore_active = 1
	vore_pounce_chance = 40
	vore_icons = SA_ICON_LIVING
