//formerly meat things

/datum/category_item/catalogue/fauna/woof
	name = "Wildlife - Dog"
	desc = "It's a relatively ordinary looking canine. \
	It has an ominous aura..."
	value = CATALOGUER_REWARD_TRIVIAL

/mob/living/simple_mob/vore/alienanimals/teppi
	name = "teppi"
	desc = "It is a relatively ordinary looking canine mutt! It radiates mischief!"
	tt_desc = "E Canis lupus softus"

	icon_state = "woof"
	icon_living = "woof"
	icon_dead = "woof_dead"
	icon_rest = "woof_rest"
	icon = 'icons/mob/alienanimals_x64.dmi'

	faction = "teppi"
	maxHealth = 600
	health = 600
	movement_cooldown = 2

	response_help = "pets"
	response_disarm = "rudely paps"
	response_harm = "punches"

	harm_intent_damage = 2
	melee_damage_lower = 2
	melee_damage_upper = 10

	var/knockdown_chance = 20

	min_oxy = 2
	max_oxy = 0
	min_tox = 0
	max_tox = 15
	min_co2 = 0
	max_co2 = 50
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 150
	maxbodytemp = 400
    unsuitable_atoms_damage = .5 

	attacktext = list("nipped", "chomped", "bonked", "stamped on")
	//attack_sound = 'sound/voice/bork.ogg' // make a better one idiot
	friendly = list("snoofs", "nuzzles", "nibbles", "smooshes on")

	ai_holder_type = /datum/ai_holder/simple_mob/teppi

	mob_size = MOB_LARGE

	has_langs = list("Teppi", "Galactic Common")
	say_list_type = /datum/say_list/teppi
// Vore stuff
	swallowTime = 1 SECONDS
   	vore_active = 1
	vore_capacity = 3
	vore_bump_chance = 5
	vore_bump_emote	= "greedily homms at"
	vore_digest_chance = 1
	vore_absorb_chance = 5
	vore_escape_chance = 10
	vore_pounce_chance = 5
	vore_ignores_undigestable = 0
	vore_default_mode = DM_HOLD
	vore_icons = SA_ICON_LIVING
	vore_stomach_name = "Stomach"
	vore_stomach_flavor = "You have found yourself pumping on down, down, down into this extremely soft dog. The slick touches of pulsing walls roll over you in greedy fashion as you're swallowed away, the flesh forms to your figure as in an instant the world is replaced by the hot squeeze of canine gullet. And in another moment a heavy GLLRMMPTCH seals you away, the dog tossing its head eagerly, the way forward stretching to accommodate your shape as you are greedily guzzled down. The wrinkled, doughy walls pulse against you in time to the creature's steady heartbeat. The sounds of the outside world muffled into obscure tones as the wet, grumbling rolls of this soft creature's gut hold you, churning you tightly such that no part of you is spared from these gastric affections."
	vore_default_contamination_flavor = "Wet"
	vore_default_contamination_color = "grey"
	vore_default_item_mode = IM_DIGEST


/mob/living/simple_mob/vore/woof/New()
	..()

	verbs += /mob/living/proc/ventcrawl
	verbs += /mob/living/proc/hide

/datum/say_list/teppi
	speak = list("Woof~", "Woof!", "Yip!", "Yap!", "Yip~", "Yap~", "Awoooooo~", "Awoo!", "AwooooooooooOOOOOOoOooOoooOoOOoooo!")
	emote_hear = list("barks", "woofs", "yaps", "yips","pants", "snoofs")
	emote_see = list("wags its tail", "stretches", "yawns", "swivels its ears")
	say_maybe_target = list("Whuff?")
	say_got_target = list("Grrrr YIP YAP!!!")

/datum/ai_holder/simple_mob/woof
	hostile = FALSE
	cooperative = TRUE
	retaliate = TRUE
	speak_chance = 1
	wander = TRUE

/datum/language/teppi
	name = "Teppi"
	desc = "The language of the meat things."
	speech_verb = "barks"
	ask_verb = "woofs"
	exclaim_verb = "howls"
	key = "n"
	flags = RESTRICTED
	machine_understands = 0
	space_chance = 100
	syllables = list("bark", "woof", "bowwow", "yap", "arf")



/mob/living/simple_mob/vore/woof/init_vore()
	..()
	var/obj/belly/B = vore_selected
	B.name = "stomach"
	B.desc = "Soft should write a tummy message."
	B.mode_flags = 8
	B.belly_fullscreen = "a_tumby"