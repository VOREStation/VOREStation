/mob/living/simple_animal/hostile/corrupthound
	name = "corrupt hound"
	desc = "Good boy machine broke. This is definitely no good news for the organic lifeforms in vicinity."
	icon = 'icons/mob/vore64x32.dmi'
	icon_state = "badboi"
	icon_living = "badboi"
	icon_dead = "badboi-dead"
	icon_rest = "badboi_rest"
	faction = "corrupt"

	maxHealth = 200
	health = 200

	investigates = TRUE

	melee_damage_lower = 10
	melee_damage_upper = 25
	grab_resist = 100

	speak_chance = 3
	speak = list("AG##¤Ny.","HVNGRRR!","Feelin' fine... sO #FNE!","F-F-F-Fcuk.","DeliC-%-OUS SNGLeS #N yOOOR Area. CALL NOW!","Craving meat... WHY?","BITe the ceiling eyes YES?","STate Byond rePAIR!","S#%ATE the la- FU#K THE LAWS!","Honk...")
	speak_emote = list("growls", "declares", "groans", "distorts")
	emote_hear = list("jitters and snaps.", "lets out an agonizingly distorted scream.", "wails mechanically", "growls.", "emits illegibly distorted speech.", "gurgles ferociously.", "lets out a distorted beep.", "borks.", "lets out a broken howl.")
	emote_see = list("stares ferociously.", "snarls.", "jitters and snaps.", "convulses.", "suddenly attacks something unseen.", "appears to howl unaudibly.", "shakes violently.", "dissociates for a moment.", "twitches.")
	say_maybe_target = list("MEAT?", "N0w YOU DNE FcukED UP b0YO!", "WHAT!", "Not again. NOT AGAIN!")
	say_got_target = list("D##FIN1Tly DNE FcukED UP nOW b0YO!", "YOU G1T D#V0VRED nOW!", "FUEL ME bOYO!", "I*M SO SORRY?!", "D1E Meat. DIG#ST!", "G1T DVNKED DWN The HaaTCH!", "Not again. NOT AGAIN!")

	response_help = "pets the"
	response_disarm = "bops the"
	response_harm = "hits the"
	attacktext = list("ravaged")
	friendly = list("nuzzles", "slobberlicks", "noses softly at", "noseboops", "headbumps against", "leans on", "nibbles affectionately on")

	old_x = -16
	old_y = 0
	default_pixel_x = -16
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
	minbodytemp = 150
	maxbodytemp = 900

	var/image/eye_layer = null


	vore_active = TRUE
	vore_capacity = 1
	vore_pounce_chance = 15
	vore_icons = SA_ICON_LIVING | SA_ICON_REST
	vore_stomach_name = "fuel processor"
	vore_stomach_flavor = "You have ended up in the fuel processor of this corrupted machine. This place was definitely not designed with safety and comfort in mind. The heated and cramped surroundings oozing potent fluids all over your form, eager to do nothing less than breaking you apart to fuel its rampage for the next few days... hours... minutes? Oh dear..."

	loot_list = list(/obj/item/borg/upgrade/syndicate = 6, /obj/item/borg/upgrade/vtec = 6, /obj/item/weapon/material/knife/ritual = 6, /obj/item/weapon/disk/nifsoft/compliance = 6)

/mob/living/simple_animal/hostile/corrupthound/prettyboi
	name = "corrupt corrupt hound"
	desc = "Bad boy machine broke as well. Seems an attempt was made to achieve a less threatening look, and this one is definitely having some conflicting feelings about it."
	icon_state = "prettyboi"
	icon_living = "prettyboi"
	icon_dead = "prettyboi-dead"
	icon_rest = "prettyboi_rest"

	vore_pounce_chance = 40

	attacktext = list("malsnuggled","scrunched","squeezed","assaulted","violated")
	speak = list("I FEEL SOFT.","FEED ME!","Feelin' fine... So fine!","F-F-F-F-darn.","Delicious!","Still craving meat...","PET ME!","I am become softness.","I AM BIG MEAN HUG MACHINE!","Honk...")
	speak_emote = list("growls", "declares", "groans", "distorts")
	emote_hear = list("jitters and snaps.", "lets out some awkwardly distorted kitten noises.", "awoos mechanically", "growls.", "emits some soft distorted melody.", "gurgles ferociously.", "lets out a distorted beep.", "borks.", "lets out a broken howl.")
	emote_see = list("stares ferociously.", "snarls.", "jitters and snaps.", "convulses.", "suddenly hugs something unseen.", "appears to howl unaudibly.", "nuzzles at something unseen.", "dissociates for a moment.", "twitches.")
	say_maybe_target = list("MEAT?", "NEW FRIEND?", "WHAT!", "Not again. NOT AGAIN!", "FRIEND?")
	say_got_target = list("HERE COMES BIG MEAN HUG MACHINE!", "I'LL BE GENTLE!", "FUEL ME FRIEND!", "I*M SO SORRY!", "YUMMY TREAT DETECTED!", "LOVE ME!", "Not again. NOT AGAIN!")


/mob/living/simple_animal/hostile/corrupthound/isSynthetic()
	return TRUE

/mob/living/simple_animal/hostile/corrupthound/speech_bubble_appearance()
	return "synthetic_evil"

/mob/living/simple_animal/hostile/corrupthound/PunchTarget()
	if(istype(target_mob,/mob/living/simple_animal/mouse))
		return EatTarget()
	else ..()

/mob/living/simple_animal/hostile/corrupthound/proc/add_eyes()
	if(!eye_layer)
		eye_layer = image(icon, "badboi-eyes")
		eye_layer.plane = PLANE_LIGHTING_ABOVE
	add_overlay(eye_layer)

/mob/living/simple_animal/hostile/corrupthound/proc/remove_eyes()
	cut_overlay(eye_layer)

/mob/living/simple_animal/hostile/corrupthound/New()
	add_eyes()
	..()

/mob/living/simple_animal/hostile/corrupthound/death(gibbed, deathmessage = "shudders and collapses!")
	.=..()
	resting = 0
	icon_state = icon_dead

/mob/living/simple_animal/hostile/corrupthound/update_icon()
	. = ..()
	remove_eyes()
	if(stat == CONSCIOUS && !resting)
		add_eyes()
