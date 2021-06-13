/*

Hyenas are any feliform carnivoran mammals of the family Hyaenidae. With only four extant species (in three genera), it is the fifth-smallest biological family in the Carnivora, and one of the smallest in the class Mammalia.
They're also cool, and Rykka/Nyria wrote this uwu

*/

// Cataloguer data here
/datum/category_item/catalogue/fauna/hyena
	name = "Desert Fauna - Hyena"
	desc = "Classification: Crocuta crocuta \
	<br><br>\
	It is primarily a hunter but may also scavenge, with the capacity to eat and digest skin, bone and other animal waste. \
	The spotted hyena displays greater plasticity in its hunting and foraging behaviour than other similar carnivores; \
	it hunts alone, in small parties of 2–5 individuals or in large groups. \
	During a hunt, spotted hyenas often run through ungulate herds in order to select an individual to attack. \
	Once selected, their prey is chased over a long distance, often several kilometres, at speeds of up to 60 km/h."
	value = CATALOGUER_REWARD_MEDIUM

// Start Defining the mob here
/mob/living/simple_mob/animal/hyena
	name = "Hyena"
	desc = "Yeen! Its fur is a dusty yellow-brown color with black spots, and it has rounded ears... and SHARP TEETH! You inexplicably want to pet it, though."
	tt_desc = "Crocuta crocuta"
	catalogue_data = list(/datum/category_item/catalogue/fauna/hyena)

	icon = 'icons/mob/animals48x32_ch.dmi'
	icon_state = "yeen"
	icon_living = "yeen"
	icon_dead = "yeen_dead"
	has_eye_glow = TRUE // Change this to true for fun spooky eye glow in darkness. <3
	minbodytemp = 175 // Make hyenas able to survive freezing cold. Someone criticize me later uwu
	faction = "yeen" // gon fight any other mobs. grr
	maxHealth = 125 // not as tanky as a spider for obvious reasons, but not a pushover.
	health = 125
	pass_flags = PASSTABLE
	movement_cooldown = 0 // Yeen go fast - nah, yeen still slower. gottagofast.
	// movement_sound = null - TODO: find good animal pawb sounds
	poison_resist = 0.1

	see_in_dark = 25 // Hyenas are nocturnal, they should be able to see anything in the dark. <3

	response_help = "rubrubs"
	response_disarm = "boops aside"
	response_harm = "smacks"

	melee_damage_lower = 1 // hyenas go for the legs/lower bits
	melee_damage_upper = 2 // not as high damage, but faster bites. nomnomnom <3
	attack_sharp = 1
	attack_edge = 1
	base_attack_cooldown = 5
	attacktext = list("bit", "nipped", "chomped", "clawed", "scratched", "lewded")
	attack_sound = 'sound/weapons/bite.ogg' // placeholder till I find a better bite

	vore_active = 1 // nom settings. <3
	vore_capacity = 3 // yeens can eat something like 85% of their weight in meat. nom~
	vore_bump_chance = 25
	vore_bump_emote = "nomfs!"
	vore_pounce_chance = 35
	vore_pounce_maxhealth = 90
	vore_standing_too = 1 // nomf people while they're standing, yus.
	swallowsound = 'sound/vore/sunesound/pred/insertion_01.ogg'

	vore_default_mode = DM_HOLD // yeengut takes a sec to kick in :3
	vore_digest_chance = 95 // you move, yeengut is gonna kick in~
	vore_escape_chance = 8 // 8% chance to escape a hot, slimy, kneading gut. Why would you want to leave~?

	vore_stomach_name = "gut"
	vore_stomach_flavor = "Hot, slimy, and kneading constantly around you, as the hyena's heartbeat thuds away above. All you can see are pink, slimy walls, \
	kneading all over your entire form, and what looks like digestive acids pooling along the bottom of it's gut. \
	You can hear cackling laughter and yaps, as well as the lurid sloshing of the hyena's belly as you're rocked around. Best not squirm, since it's belly isn't digesting you... yet."

	vore_default_contamination_flavor = "Acrid"
	vore_default_contamination_color = "yellow"

	ai_holder_type = /datum/ai_holder/simple_mob/melee/pack_mob // Define here what type of enemy hyena is.

	heat_damage_per_tick = 20
	cold_damage_per_tick = 20

	speak_emote = list("yaps")

	say_list_type = /datum/say_list/hyena

/datum/say_list/hyena
	speak = list("Huff.", "|R|rr?", "Yap.", "Grr.", "Yip.", "SCREM!")
	emote_see = list("sniffs", "looks around", "grooms itself", "rolls around")
	emote_hear = list("yawns", "cackles", "playfully yaps")

// Start Defining the mob here
/mob/living/simple_mob/animal/hyena/Nyria
	name = "Nyria"
	desc = "Yeen! This one seems familiar. Its fur is a dark, dusty reddish-brown color with black spots, and it has rounded ears... and SHARP TEETH! You inexplicably want to pet it, though."
	tt_desc = "Crocuta crocuta"

	icon_state = "nyria_yeen"
	icon_living = "nyria_yeen"
	icon_dead = "nyria_yeen_dead"

	maxHealth = 225 // tuff yeen. <3
	health = 225 // tuff yeen. <3

	ai_holder_type = /datum/ai_holder/simple_mob/melee/pack_mob/nyria // Define here what type of enemy hyena is. Nyria is non-hostile.