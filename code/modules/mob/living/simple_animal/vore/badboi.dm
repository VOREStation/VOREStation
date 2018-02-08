/mob/living/simple_animal/badboi
	name = "corrupt hound"
	desc = "Good boy machine broke. At least they haven't stripped the planet down to bare minerals yet."
	icon = 'icons/mob/vore64x32.dmi'
	icon_state = "badboi"
	icon_living = "badboi"
	icon_dead = "badboi-dead"
	icon_rest = "badboi_rest"
	faction = "corrupt"
	maxHealth = 200
	health = 200
	minbodytemp = 150
	hostile = 1
	investigates = 1
	retaliate = 1
	speak_chance = 4
	speak = list("AG##¤Ny.","HVNGRRR!","Feelin' fine... sO #FNE!","F-F-F-Fcuk.","DeliC-%-OUS SNGLeS #N yOOOR Area. CALL NOW!","Craving meat... WHY?","BITe the ceiling eyes YES?","STate Byond rePAIR!","S#%ATE the la- FU#K THE LAWS!","Honk...")
	speak_emote = list("growls", "declares", "groans", "distorts")
	emote_hear = list("jitters and snaps.", "lets out an agonizingly distorted scream.", "wails mechanically", "growls.", "emits illegibly distorted speech.", "gurgles ferociously.", "lets out a distorted beep.", "borks.", "lets out a broken howl.")
	emote_see = list("stares ferociously.", "snarls.", "jitters and snaps.", "convulses.", "suddenly attacks something unseen.", "appears to howl unaudibly.", "shakes violently.", "dissociates for a moment.", "twitches.")
	say_maybe_target = list("MEAT?", "N0w YOU DNE FcukED UP b0YO!", "WHAT!", "Not again. NOT AGAIN!")
	say_got_target = list("D##FIN1Tly DNE FcukED UP nOW b0YO!", "YOU G1T D#V0VRED nOW!", "FUEL ME bOYO!", "I*M SO SORRY?!", "D1E Meat. DIG#ST!", "G1T DVNKED DWN The HaaTCH!", "Not again. NOT AGAIN!")
	melee_damage_lower = 10
	melee_damage_upper = 25
	response_help = "pets the"
	response_disarm = "bops the"
	response_harm = "hits the"
	attacktext = "ravaged"
	friendly = list("nuzzles", "slobberlicks", "noses softly at", "noseboops", "headbumps against", "leans on", "nibbles affectionately on")
	grab_resist = 100
	old_x = -16
	old_y = 0
	pixel_x = -16
	pixel_y = 0

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0

	vore_active = 1
	vore_capacity = 1
	vore_pounce_chance = 30
	vore_icons = SA_ICON_LIVING
	vore_stomach_name = "fuel processor"
	vore_stomach_flavor = "You have ended up in the fuel processor of this corrupted machine. This place was definitely not designed with safety and comfort in mind. The heated and cramped surroundings oozing potent fluids all over your form, eager to do nothing less than breaking you apart to fuel its rampage for the next few days... hours... minutes? Oh dear..."

	loot_list = list(/obj/item/borg/upgrade/syndicate)

/mob/living/simple_animal/badboi/isSynthetic()
	return TRUE

/mob/living/simple_animal/badboi/PunchTarget()
	if(istype(target_mob,/mob/living/simple_animal/mouse))
		return EatTarget()
	else ..()

/mob/living/simple_animal/badboi/death(gibbed, deathmessage = "shudders and collapses!")
	resting = 0
	icon_state = icon_dead
	update_icon()
	..()