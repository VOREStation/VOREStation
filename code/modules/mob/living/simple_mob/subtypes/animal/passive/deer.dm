//Prepare to have your lawns trampled on and your veggies munched
/mob/living/simple_mob/animal/passive/deer
	name = "Deer"
	desc = "An animal with impressive antlers and skittish personality, though this one seems domesticated."
	tt_desc = "Cervus elaphus"
	faction = "neutral"

	icon = 'icons/mob/animal_ch.dmi'
	icon_state = "Deer"
	icon_living = "Deer"
	icon_rest = "Deer"
	icon_dead = "Deer_dead"

	health = 150
	maxHealth = 150


	density = 0
	movement_cooldown = 0.75 //roughly a bit faster than a person due to their skittish nature
	see_in_dark = 6

	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "gores"

	melee_damage_lower = 1
	melee_damage_upper = 1
	attacktext = list("stomps", "head bumps", "scratches")

	vore_taste = "Venison"

	min_oxy = 16 //Require atleast 16kPA oxygen
	minbodytemp = 223		//Below -50 Degrees Celcius
	maxbodytemp = 523	//Above 80 Degrees Celcius
	heat_damage_per_tick = 3
	cold_damage_per_tick = 3

	meat_amount = 5
	ai_holder_type = /datum/ai_holder/simple_mob/deer

	speak_emote = list("bellows","bellows loudly")

	say_list_type = /datum/say_list/deer

/datum/say_list/deer

	speak = list("meer?","meer","MEEEEER")
	emote_hear = list("bellows")
	emote_see = list("wiggles its tail", "suddenly pauses trying to listen for something")

// Start Defining the mob here
/mob/living/simple_mob/animal/passive/deer/kyle

	name = "Kyle" //Extra stresso with a mix of aaaa
	desc = "A deer with no antlers and a very skittish personality, it seems to be a male even though its a doe."
	tt_desc = "Cervus flailicus"
	icon_state = "Kyle"
	icon_living = "Kyle"
	icon_rest = "Kyle"
	icon_dead = "Kyle_dead"


	response_help  = "softly pets"
	response_disarm = "barely manages to push aside
	response_harm   = "smacks"

	melee_damage_lower = 1
	melee_damage_upper = 1
	attacktext = list("nibbled")

	speak_emote = list("Bleats","Bleats loudly","Wh-s","Flails","Flails a lot")

	say_list_type = /datum/say_list/kyle

/datum/say_list/kyle

	speak = list("wh-?","wh-!","WH-?!","aaaaa","HELP MAINTS","SPOHGJPDFHDFH!","EEP","!!!!!","gposdjafgpmgd","y e e t")
	emote_hear = list("Bleats", "Bleats loudly","Wh-s")
	emote_see = list("wiggles his tail","Flails around","Flails","Runs around in a circle")

	// Vore tags
	vore_active = 1
	vore_capacity = 3
	vore_bump_chance = 12
	vore_bump_emote = "meekly engulf"
	vore_icons = 0
	vore_pounce_chance = 35
	vore_pounce_maxhealth = 90
	vore_standing_too = 1 // no need to graze
	swallowsound = 'sound/vore/sunesound/pred/taurswallow.ogg'

	vore_default_mode = DM_HOLD
	vore_digest_chance = 10
	vore_escape_chance = 8 // He's not used to eating living creatures, so it's a bit of a chore to get them back out

	vore_stomach_name = "Stomach"
	vore_stomach_flavor = "You somehow managed to wind up curled inside Kyle's belly, and he doesnt seem very quite eager about the idea judging from all the bleating... Best not squirm around too much, since your bashful pred isn't digesting you... yet."

	vore_default_contamination_flavor = "Acrid"
	vore_default_contamination_color = "green"
	B.emote_lists[DM_HOLD] = list(
		"The tight belly rubs your body as the panicking deer runs around.",
		"You hear the sounds of his stomach squishing your form and his heart thundering away nearby.",
		"Kyle doesnt seem to know where to go. The constant turning around in place is pressing you against the walls, its a miracle your not getting dizzy.",
		"All the moving about is making you a little sleepy, its like a tight and warm hammock that you constantly swing back and forth in thanks to your unwilling predator.",
		"Kyle tries again to cough you up and fails, one has to wonder if you will ever get out.")

	B.emote_lists[DM_DIGEST] = list(
		"His herbivore belly isnt suited for a meal like you, but he moves so much that fresh stomach juices are always kneaded into your form to break you down.",
		"While the distressed deer is trying to get his unwelcome guest out of his stomach, his stomach is busy claiming its food by tightening around you to grind you into mush.",
		"Its hard to see inside the dark and damp belly, but the sound of sloshing liquids grows louder by every minute, and the same goes for the ominous gurgling noises.",
		"Everytime Kyle stops to bleat nervously his belly tightens around you, forcing you to curl up tighter than before. Will you get out before its to late, get digested first, or even crushed into a paste?",
		"The deer tries his best to regurgitate you, but all it does is excite his stomach even more and fill up the organ with more liquids to churn you up with.")

