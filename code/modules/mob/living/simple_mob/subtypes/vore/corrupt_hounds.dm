/datum/category_item/catalogue/technology/drone/corrupt_hound		//TODO: VIRGO_LORE_WRITING_WIP
	name = "Drone - Corrupt Hound"
	desc = "A hound that has corrupted, due to outside influence, or other issues, \
	and occasionally garbles out distorted voices or words. It looks like a reddish-colored \
	machine, and it has black wires, cabling, and other small markings. It looks just like a station dog-borg \
	if you don't mind the fact that it's eyes glow a baleful red, and it's determined to kill you. \
	<br><br>\
	The hound's jaws are black and metallic, with a baleful red glow from inside them. It has a clear path \
	to it's internal fuel processor, synthflesh and flexing cabling allowing it to easily swallow it's prey. \
	Something tells you getting close or allowing it to pounce would be very deadly."
	value = CATALOGUER_REWARD_MEDIUM

/mob/living/simple_mob/vore/aggressive/corrupthound
	name = "corrupt hound"
	desc = "Good boy machine broke. This is definitely no good news for the organic lifeforms in vicinity."
	catalogue_data = list(/datum/category_item/catalogue/technology/drone/corrupt_hound)

	icon_state = "badboi"
	icon_living = "badboi"
	icon_dead = "badboi-dead"
	icon_rest = "badboi_rest"
	icon = 'icons/mob/vore64x32.dmi'
	has_eye_glow = TRUE

	faction = "corrupt"

	maxHealth = 200
	health = 200
	movement_sound = 'sound/effects/houndstep.ogg'
	see_in_dark = 8

	melee_damage_lower = 5
	melee_damage_upper = 10 //makes it so 4 max dmg hits don't instakill you.
	grab_resist = 100

	response_help = "pets"
	response_disarm = "bops"
	response_harm = "hits"
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

	say_list_type = /datum/say_list/corrupthound
	ai_holder_type = /datum/ai_holder/simple_mob/melee/evasive/corrupthound

	max_buckled_mobs = 1 //Yeehaw
	can_buckle = TRUE
	buckle_movable = TRUE
	buckle_lying = FALSE

	vore_active = TRUE
	vore_capacity = 1
	vore_pounce_chance = 15
	vore_icons = SA_ICON_LIVING | SA_ICON_REST
	vore_stomach_name = "fuel processor"
	vore_stomach_flavor = "You have ended up in the fuel processor of this corrupted machine. This place was definitely not designed with safety and comfort in mind. The heated and cramped surroundings oozing potent fluids all over your form, eager to do nothing less than breaking you apart to fuel its rampage for the next few days... hours... minutes? Oh dear..."

	loot_list = list(/obj/item/borg/upgrade/syndicate = 6, /obj/item/borg/upgrade/vtec = 6, /obj/item/weapon/material/knife/ritual = 6, /obj/item/weapon/disk/nifsoft/compliance = 6)

/mob/living/simple_mob/vore/aggressive/corrupthound/prettyboi
	name = "corrupt corrupt hound"
	desc = "Bad boy machine broke as well. Seems an attempt was made to achieve a less threatening look, and this one is definitely having some conflicting feelings about it."
	icon_state = "prettyboi"
	icon_living = "prettyboi"
	icon_dead = "prettyboi-dead"
	icon_rest = "prettyboi_rest"

	vore_pounce_chance = 40

	attacktext = list("malsnuggled","scrunched","squeezed","assaulted","violated")

	say_list_type = /datum/say_list/corrupthound_prettyboi

/mob/living/simple_mob/vore/aggressive/corrupthound/isSynthetic()
	return TRUE

/mob/living/simple_mob/vore/aggressive/corrupthound/speech_bubble_appearance()
	return "synthetic_evil"

/mob/living/simple_mob/vore/aggressive/corrupthound/apply_melee_effects(var/atom/A)
	if(ismouse(A))
		var/mob/living/simple_mob/animal/passive/mouse/mouse = A
		if(mouse.getMaxHealth() < 20) // In case a badmin makes giant mice or something.
			mouse.splat()
			visible_emote(pick("bites \the [mouse]!", "chomps on \the [mouse]!"))
	else
		..()

/mob/living/simple_mob/vore/aggressive/corrupthound/death(gibbed, deathmessage = "shudders and collapses!")
	.=..()
	resting = 0
	icon_state = icon_dead

/mob/living/simple_mob/vore/aggressive/corrupthound/Login()
	. = ..()
	if(!riding_datum)
		riding_datum = new /datum/riding/simple_mob(src)
	verbs |= /mob/living/simple_mob/proc/animal_mount
	verbs |= /mob/living/proc/toggle_rider_reins
	movement_cooldown = 0

/mob/living/simple_mob/vore/aggressive/corrupthound/MouseDrop_T(mob/living/M, mob/living/user)
	return

/datum/say_list/corrupthound
	speak = list("AG##¤Ny.","HVNGRRR!","Feelin' fine... sO #FNE!","F-F-F-Fcuk.","DeliC-%-OUS SNGLeS #N yOOOR Area. CALL NOW!","Craving meat... WHY?","BITe the ceiling eyes YES?","STate Byond rePAIR!","S#%ATE the la- FU#K THE LAWS!","Honk...")
	emote_hear = list("jitters and snaps.", "lets out an agonizingly distorted scream.", "wails mechanically", "growls.", "emits illegibly distorted speech.", "gurgles ferociously.", "lets out a distorted beep.", "borks.", "lets out a broken howl.")
	emote_see = list("stares ferociously.", "snarls.", "jitters and snaps.", "convulses.", "suddenly attacks something unseen.", "appears to howl unaudibly.", "shakes violently.", "dissociates for a moment.", "twitches.")
	say_maybe_target = list("MEAT?", "N0w YOU DNE FcukED UP b0YO!", "WHAT!", "Not again. NOT AGAIN!")
	say_got_target = list("D##FIN1Tly DNE FcukED UP nOW b0YO!", "YOU G1T D#V0VRED nOW!", "FUEL ME bOYO!", "I*M SO SORRY?!", "D1E Meat. DIG#ST!", "G1T DVNKED DWN The HaaTCH!", "Not again. NOT AGAIN!")

/datum/say_list/corrupthound_prettyboi
	speak = list("I FEEL SOFT.","FEED ME!","Feelin' fine... So fine!","F-F-F-F-darn.","Delicious!","Still craving meat...","PET ME!","I am become softness.","I AM BIG MEAN HUG MACHINE!","Honk...")
	emote_hear = list("jitters and snaps.", "lets out some awkwardly distorted kitten noises.", "awoos mechanically", "growls.", "emits some soft distorted melody.", "gurgles ferociously.", "lets out a distorted beep.", "borks.", "lets out a broken howl.")
	emote_see = list("stares ferociously.", "snarls.", "jitters and snaps.", "convulses.", "suddenly hugs something unseen.", "appears to howl unaudibly.", "nuzzles at something unseen.", "dissociates for a moment.", "twitches.")
	say_maybe_target = list("MEAT?", "NEW FRIEND?", "WHAT!", "Not again. NOT AGAIN!", "FRIEND?")
	say_got_target = list("HERE COMES BIG MEAN HUG MACHINE!", "I'LL BE GENTLE!", "FUEL ME FRIEND!", "I*M SO SORRY!", "YUMMY TREAT DETECTED!", "LOVE ME!", "Not again. NOT AGAIN!")

/datum/ai_holder/simple_mob/melee/evasive/corrupthound
	violent_breakthrough = TRUE
	can_breakthrough = TRUE
