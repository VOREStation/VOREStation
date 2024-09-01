/mob/living/simple_mob/vore/raptor
	name = "raptor"
	desc = "A massive raptor with piercing yellow eyes. Long sharp claws and huge pointy teeth, I wouldn't want to upset this thing."
	tt_desc = "Velociraptor voroliensis"
	icon = 'icons/mob/vore_raptor.dmi'
	icon_dead = "raptorpurple_dead"
	icon_living = "raptorpurple"
	icon_state = "raptorpurple"
	icon_rest = "raptorpurple"
	faction = "raptor"
	meat_amount = 40 //Big dog, lots of meat
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat
	old_x = -48
	old_y = 0
	vis_height = 92
	friendly = list("nudges", "sniffs on", "rumbles softly at", "slobberlicks")
	default_pixel_x = -48
	pixel_x = -48
	pixel_y = 0
	response_help = "pets"
	response_disarm = "shoves"
	response_harm = "smacks"
	movement_cooldown = -1
	harm_intent_damage = 10
	melee_damage_lower = 10
	melee_damage_upper = 15
	maxHealth = 500
	attacktext = list("chomped")
	see_in_dark = 8
	minbodytemp = 0
	ai_holder_type = /datum/ai_holder/simple_mob/retaliate
	max_buckled_mobs = 1
	mount_offset_y = 32
	mount_offset_x = -16
	can_buckle = TRUE
	buckle_movable = TRUE
	buckle_lying = FALSE
	var/initial_icon = "raptorpurple"
	var/wg_state = 0

	var/random_skin = 1
	var/list/skins = list(
		"raptorpurple",
		"raptorgreen",
		"raptorred",
		"raptorblue",
		"raptorblack",
		"raptorwhite"
	)

	allow_mind_transfer = TRUE

/mob/living/simple_mob/vore/raptor

	vore_bump_chance = 25
	vore_digest_chance = 5
	vore_escape_chance = 5
	vore_pounce_chance = 50
	vore_active = 1
	vore_icons = SA_ICON_LIVING | SA_ICON_REST
	vore_capacity = 1
	swallowTime = 50
	vore_ignores_undigestable = TRUE
	vore_default_mode = DM_DIGEST
	vore_pounce_maxhealth = 125
	vore_bump_emote = "tries to snap up"

/mob/living/simple_mob/vore/raptor/New()
	..()
	if(random_skin)
		icon_living = pick(skins)
		initial_icon = icon_living
		icon_rest = "[icon_living]"
		icon_dead = "[icon_living]_dead"
		update_icon()

/mob/living/simple_mob/vore/raptor/Login()
	. = ..()
	if(!riding_datum)
		riding_datum = new /datum/riding/simple_mob(src)
	verbs |= /mob/living/simple_mob/proc/animal_mount
	verbs |= /mob/living/proc/toggle_rider_reins
	movement_cooldown = -1

/mob/living/simple_mob/vore/raptor/init_vore()
	. = ..()
	var/obj/belly/B = vore_selected
	B.name = "stomach"
	B.desc = "The raptor pounces atop you, pinning you under sharp taloned feet, a heavy weight on your chest. Unable to do much more than look up at the reptilian face, looking back down at you with a curious bird-like expression, you're helpless in the moment. With little more warning, the jaws lunge open and dive down towards your head. Engulfing you in the wet maw, tongue pushing against your face, a cage of jagged teeth hold you in place. Pulling you upwards roughly, the creature begins to chomp it's way down your body, and you're steadily transferred down the rippling, tight tunnel of its gullet. The beast throws its head backwards, sending you spiralling down toward's its stomach, where you land with a wet splash. The walls of the gut immediately clamp down on you, wrinkled flesh grinding the gastric slurry of acids and enzymes into your trapped form. A cacophony of bodily functions, groans, gurgles and heart beats overwhelm your hearing. This creature's body has clearly decided you're little more than meat to it now."
	B.vore_sound = "Tauric Swallow"
	B.release_sound = "Pred Escape"
	B.mode_flags = DM_FLAG_THICKBELLY
	B.fancy_vore = 1
	B.selective_preference = DM_DIGEST
	B.vore_verb = "devour"
	B.digest_brute = 3
	B.digest_burn = 2
	B.digest_oxy = 0
	B.digestchance = 50
	B.absorbchance = 0
	B.escapechance = 5
	B.escape_stun = 5
	B.contamination_color = "grey"
	B.contamination_flavor = "Wet"
	B.emote_lists[DM_DIGEST] = list(
		"The raptor growls in annoyance before clenching those wrinkled walls tight against your form, grinding away at you!",
		"As the beast wanders about, you're forced to slip and slide around amidst a pool of thick digestive goop, sinking briefly into the thick, heavy walls!",
		"You can barely hear the drake let out a pleased rumble as its stomach eagerly gurgles around its newfound meal!",
		"As the thinning air begins to make you feel dizzy, menacing bworps and grumbles fill that dark, constantly shifting organ!",
		"The constant, rhythmic kneading and massaging starts to take its toll along with the muggy heat, making you feel weaker and weaker!",
		"The raptor happily wanders around while digesting its meal, almost like it is trying to show off the hanging gut you've given it. Not like it made much of a difference on his already borderline obese form anyway~")

/mob/living/simple_mob/vore/raptor/adjust_nutrition()
	..()
	consider_wg()

/mob/living/simple_mob/vore/raptor/proc/consider_wg()
  var/past_state = wg_state
  if(nutrition >= 900)
    wg_state = 1
  else
    wg_state = 0
  if(past_state != wg_state)
    update_icon()

/mob/living/simple_mob/vore/raptor/update_icon()
	if(wg_state == 1)
		icon_living = "[initial_icon]_fat"
		icon_state = icon_living
	else
		icon_living = "[initial_icon]"
		icon_state = icon_living
	. = ..()
	if(vore_active)
		var/voremob_awake = FALSE
		if(icon_state == icon_living)
			voremob_awake = TRUE
		update_fullness()
		if(!vore_fullness)
			update_transform()
			return 0
		else if((stat == CONSCIOUS) && (!icon_rest || !resting || !incapacitated(INCAPACITATION_DISABLED)) && (vore_icons & SA_ICON_LIVING))
			icon_state = "[icon_living]-[vore_fullness]"
		else if(stat >= DEAD && (vore_icons & SA_ICON_DEAD))
			icon_state = "[icon_dead]-[vore_fullness]"
		else if(((stat == UNCONSCIOUS) || resting || incapacitated(INCAPACITATION_DISABLED) ) && icon_rest && (vore_icons & SA_ICON_REST))
			icon_state = "[icon_rest]-[vore_fullness]"
		if(vore_eyes && voremob_awake) //Update eye layer if applicable.
			remove_eyes()
			add_eyes()
	update_transform()

/mob/living/simple_mob/vore/raptor/yellow
	name = "raptor"
	desc = "A massive yellow raptor with piercing blue eyes and a feathered tail. Long sharp claws and huge pointy teeth, I wouldn't want to upset this thing."
	icon_dead = "raptoryellow_dead"
	icon_living = "raptoryellow"
	icon_state = "raptoryellow"
	icon_rest = "raptoryellow_rest"
	random_skin = 0
	initial_icon = "raptoryellow"
