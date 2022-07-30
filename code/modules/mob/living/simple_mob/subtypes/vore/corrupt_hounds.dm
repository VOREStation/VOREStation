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

	melee_damage_lower = 10
	melee_damage_upper = 20
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

	loot_list = list(/obj/item/borg/upgrade/syndicate = 6, /obj/item/borg/upgrade/vtec = 6, /obj/item/material/knife/ritual = 6, /obj/item/disk/nifsoft/compliance = 6)

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
	movement_cooldown = 3

/mob/living/simple_mob/vore/aggressive/corrupthound/MouseDrop_T(mob/living/M, mob/living/user)
	return

/mob/living/simple_mob/vore/aggressive/corrupthound/space/Process_Spacemove(var/check_drift = 0)
	return TRUE

/mob/living/simple_mob/vore/aggressive/corrupthound/init_vore()
	..()
	var/obj/belly/B = vore_selected
	B.name = "fuel processor"
	B.desc = "Uttering distorted growls and fragmented voice clips all the while, the corrupted hound gulps the rest of your squirming figure past its jaws... which snap shut with an audible click of metal on metal. Your trip down its slickly lubricated, rubbery gullet is a tight and efficient one... and once you spill out into the machine's fuel processor, your weight making it sag slightly, hot-and-thick slime begins oozing all over your form. Only time will tell if you're destined to become fuel for its next bout of rampaging... be it days, hours, or just mere minutes..."

	B.emote_lists[DM_HOLD] = list(
		"Abruptly, your corrupt captor takes off at an unsteady gallop, sloshing and swaying your snugly kneading surroundings as it pursues something unseen.",
		"A distorted, potentially content-sounding growl rumbles in through the all-encompassing, soft rubber, drowned out by the occasional gllrsh.",
		"The corrupt hound takes a brief moment to lie down and rest its actuators, pressing and squishing its hanging belly down against the floor as it pants robotically.",
		"A juicy slosh fills your senses as the slick rubber walls squeeze inwards, wrapping you up utterly in a strange, claustrophobic type of hug.",
		"Over time, the constant kneading and massaging the processor's synth-flesh gives you, along with its humid warmth, relaxes the strength right out of your muscles.",
		"'MIn3 m1NE, Al1 MInE', the corrupted canine growls, over and over, as its synthetic stomach possessively clenches and grips at your ooze-coated figure, the stretchy walls hesitant to let go again.")

	B.emote_lists[DM_DIGEST] = list(
		"Your rubbery surroundings suddenly pitch all about as the corrupted hound takes off at an uneven gallop, hunting future prey while processing its current intake of meat!",
		"A muffled, garbled howl, a victorious and maddened sound, pierces through the thick, flexible walls that work incessantly to churn you down!",
		"The mechanical canine's panting occasionally turns into a sordid belch, more and more breatheable air escaping that already acidic, dizziness-inducing chamber!",
		"The all-encapsulating, rubber-like walls churning over you momentarily let up on their assault, only to clench and squeeze inwards twice as intensely afterwards!",
		"The longer you spend stewing away in the pool of hot, clingy juices surrounding you, the weaker and weaker you seem to feel!",
		"'FU3L mE A1RE@Dy, S0 sO SORrY!?', your corrupted captor growls as its synthetic innards begin oozing more potent juices, grinding down into your body with increasing fervor!")

/mob/living/simple_mob/vore/aggressive/corrupthound/prettyboi/init_vore()
	..()
	var/obj/belly/B = vore_selected
	B.name = "fuel processor"
	B.desc = "The twice-corrupted hound takes a moment to lather over the rest of your figure in heated, slimy synth-slobber before gulping you the rest of the way down its lubricated, rubbery throat. After a short string of slick-sounding, autonomous swallows, you spill out into its awaiting processor, your body immediately making its synth-flesh sag down slightly... and, as an oddly distorted rumble vibrates into the chamber, so too does a slowly accumulating pool of hot, viscous ooze. Only time will tell if whatever extra programming the hound has will spare you from being processed..."

	B.emote_lists[DM_HOLD] = list(
		"Suddenly, your corrupted captor yowls robotically before bounding off at an unsteady gallop, its repeated footfalls vigorously sloshing and swinging its hammock-like stomach.",
		"A distorted growl breaks away into an oddly content-sounding purring, the sound rumbling inwards through your all-encompassing, soft rubber trappings.",
		"The extra-corrupted hound flops over onto its side with a muted clank, the initial jostle drowned out in a following, snug clench as it curls up to nuzzle its metal snout into its belly-bulge.",
		"The pool of warm, slick fluids surrounding you wetly slosh inwards as the hound's synthetic belly walls squeeze you, nearly smothering you in a strange, almost affectionate 'hug'.",
		"With time, the hound's staticky rumbling, the constant inward kneading of its processor's synth-flesh, and the humid warmth filling the chamber all combine to relax the strength right out of you.",
		"'SO s0FT, CUDD1E Me', the twice-corrupted hound growl-purrs, the soft rubber lining of its synthetic stomach snugly clenching to and vibrating over your oozed-up figure in a voracious cuddle of its own design.")

	B.emote_lists[DM_DIGEST] = list(
		"Your rubbery confines suddenly toss and tumble you about, the twice-corrupted hound unevenly galloping off in search of more edible cuddle partners as its current one processes away!",
		"A harsh, high-pitched attempt of a bark escapes your captor, a cheerily mad sound, as its thick, flexible stomach walls relentlessly churn you down!",
		"The mechanical canine's content panting cuts away into a pleased 'rurr...' before being interrupted by a reverberating, acrid belch, yet more breatheable air slipping away!",
		"The all-encapsulating, rubber-like walls churning over you seem to feel softer than before, though, on the outside, the broken hound's belly slowly rounds out!",
		"The longer you spend stewing away in the pool of hot, clingy juices, constantly rumbled into by the hound's attempted purr, the weaker and more distracted you feel!",
		"'I FEEL SOFT. Y*U FEEL SOFT', the twice-corrupted canine states as its plush, rubbery interior grinds down over your curled-up body, squeezing inwards more and more easily with each repetition!")

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
