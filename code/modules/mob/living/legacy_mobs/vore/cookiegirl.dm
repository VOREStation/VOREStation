/mob/living/simple_animal/cookiegirl
	name = "cookiegirl"
	desc = "A woman made with a combination of, well... Whatever you put in a cookie. What were the chefs thinking?"
	icon = 'icons/mob/vore.dmi'
	icon_state = "cookiegirl"
	icon_living = "cookiegirl"
	icon_rest = "cookiegirl_rest"
	icon_dead = "cookiegirl-dead"

	maxHealth = 10
	health = 10

	speed = 5

	run_at_them = 0
	cooperative = 1
	investigates = 1
	reacts = 1

	harm_intent_damage = 2
	melee_damage_lower = 5
	melee_damage_upper = 10

	speak_chance = 1.5 //I have no idea what to give them for speech. I'll get back to this sometime in the future to add more.
	speak = list("Hi!","Are you hungry?","Got milk~?","What to do, what to do...")
	speak_emote = list("hums","whistles")
	emote_see = list("shakes her head","shivers", "picks a bit of crumb off of her body and sticks it in her mouth.")
	reactions = list("Can I eat you?" = "Do you really wanna eat someone as sweet as me~?",
					"You look tasty." = "Awww, thank you~!",
					"Can I serve you to the crew?" = "If I have a backup, sure!",)
	attacktext = list("smacked")

	// Activate Noms!
/mob/living/simple_animal/cookiegirl
	vore_active = 1
	vore_bump_chance = 2
	vore_pounce_chance = 25
	vore_standing_too = 1
	vore_ignores_undigestable = 0 // Do they look like they care?
	vore_default_mode = DM_HOLD // They're cookiepeople, what do you expect?
	vore_digest_chance = 10 // Gonna become as sweet as sugar, soon.
	vore_icons = SA_ICON_LIVING | SA_ICON_REST

/mob/living/simple_animal/cookiegirl/retaliate
	retaliate = 1
