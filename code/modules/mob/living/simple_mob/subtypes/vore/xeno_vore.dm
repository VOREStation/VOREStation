// Basically xenos that have been more or less neutered to be balanced as maintenance preds.

/datum/category_item/catalogue/fauna/xeno_defanged		//TODO: VIRGO_LORE_WRITING_WIP
	name = "Creature - \"Defanged\" Xenomorph"
	desc = "Under normal circumstances, a xenomorph is more than capable of parasitic reproduction, discharging \
	digestive acid at high velocities, and utilizing the blade at the blade at the end of its long tail as a \
	far-reaching melee weapon. However, this particular instance of xenomorph is capable of none of these things. \
	\"Defanged\" is not used literally in this case when referring to these types of xenomorphs since their fangs, \
	ironically, are still intact. What it does mean is that the creature's other more lethal components have been \
	surgically removed, usually for the purposes of keeping it in captivity in the same way that one may de-claw a \
	lion in for keeping it in a zoo. This xenomorph has had its reproductive organs, as well as its acid-spitting \
	glands, and the blade at the end of its tail removed. Its claws and fangs however are left intact. The ethicality \
	of this practice on captive xenomorphs has been frequently challenged by animal activists."
	value = CATALOGUER_REWARD_MEDIUM

/mob/living/simple_mob/vore/xeno_defanged
	name = "defanged xenomorph"
	desc = "A chitin-covered bipedal creature who appears to have had its means of reproduction and acid-spitting \
	removed. It still looks nasty all the same though!"

	icon_dead = "xeno_dead"
	icon_living = "xeno"
	icon_state = "xeno"
	icon = 'icons/mob/vore64x64.dmi'
	vis_height = 64

	faction = "xeno"
	maxHealth = 150
	health = 150
	see_in_dark = 10

	//Something something, phoron mutation.
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

	melee_damage_lower = 8
	melee_damage_upper = 16
	grab_resist = 50 // they're still slippery buggers!

	vore_active = 1
	vore_capacity = 2
	vore_pounce_chance = 50
	vore_icons = SA_ICON_LIVING

	response_help = "pats"
	response_disarm = "tries to shove"
	response_harm = "hits"
	attacktext = list("slashed")
	friendly = list("nuzzles", "caresses", "headbumps against", "leans against", "nibbles affectionately on")

	old_x = -16
	old_y = 0
	default_pixel_x = -16
	pixel_x = -16
	pixel_y = 0

	ai_holder_type = /datum/ai_holder/simple_mob/melee
	say_list_type = /datum/say_list/xeno_defanged

	allow_mind_transfer = TRUE

/datum/say_list/xeno_defanged
	say_got_target = list("hisses angrily!")
