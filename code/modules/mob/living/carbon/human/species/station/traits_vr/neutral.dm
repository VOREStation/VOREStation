/datum/trait/neutral
	category = TRAIT_TYPE_NEUTRAL

/datum/trait/neutral/metabolism_up
	name = "Metabolism, Fast"
	desc = "You process ingested and injected reagents faster, but get hungry faster (Teshari speed)."
	cost = 0
	var_changes = list("metabolic_rate" = 1.2, "hunger_factor" = 0.2, "metabolism" = 0.06) // +20% rate and 4x hunger (Teshari level)
	excludes = list(/datum/trait/neutral/metabolism_down, /datum/trait/neutral/metabolism_apex)
	custom_only = FALSE

/datum/trait/neutral/metabolism_down
	name = "Metabolism, Slow"
	desc = "You process ingested and injected reagents slower, but get hungry slower."
	cost = 0
	var_changes = list("metabolic_rate" = 0.8, "hunger_factor" = 0.04, "metabolism" = 0.0012) // -20% of default.
	excludes = list(/datum/trait/neutral/metabolism_up, /datum/trait/neutral/metabolism_apex)
	custom_only = FALSE

/datum/trait/neutral/metabolism_apex
	name = "Metabolism, Apex"
	desc = "Finally a proper excuse for your predatory actions. Essentially doubles the fast trait rates. Good for characters with big appetites."
	cost = 0
	var_changes = list("metabolic_rate" = 1.4, "hunger_factor" = 0.4, "metabolism" = 0.012) // +40% rate and 8x hunger (Double Teshari)
	excludes = list(/datum/trait/neutral/metabolism_up, /datum/trait/neutral/metabolism_down)
	custom_only = FALSE

/datum/trait/neutral/coldadapt
	name = "Temp. Adapted, Cold"
	desc = "You are able to withstand much colder temperatures than other species, and can even be comfortable in extremely cold environments. You are also more vulnerable to hot environments, and have a lower body temperature as a consequence of these adaptations."
	cost = 0
	var_changes = list("cold_level_1" = 200,  "cold_level_2" = 150, "cold_level_3" = 90, "breath_cold_level_1" = 180, "breath_cold_level_2" = 100, "breath_cold_level_3" = 60, "cold_discomfort_level" = 210, "heat_level_1" = 330, "heat_level_2" = 380, "heat_level_3" = 700, "breath_heat_level_1" = 360, "breath_heat_level_2" = 400, "breath_heat_level_3" = 850, "heat_discomfort_level" = 295, "body_temperature" = 290)
	can_take = ORGANICS
	excludes = list(/datum/trait/neutral/hotadapt)

	// Traitgenes Replaces /datum/trait/positive/superpower_cold_resist, made into a genetrait
	is_genetrait = TRUE
	hidden = FALSE

	activation_message="Your body is filled with warmth."
	primitive_expression_messages=list("pants, sweat dripping down their head.")

/datum/trait/neutral/hotadapt
	name = "Temp. Adapted, Heat"
	desc = "You are able to withstand much hotter temperatures than other species, and can even be comfortable in extremely hot environments. You are also more vulnerable to cold environments, and have a higher body temperature as a consequence of these adaptations."
	cost = 0
	var_changes = list("heat_level_1" = 420, "heat_level_2" = 460, "heat_level_3" = 1100, "breath_heat_level_1" = 440, "breath_heat_level_2" = 510, "breath_heat_level_3" = 1500, "heat_discomfort_level" = 390, "cold_level_1" = 280, "cold_level_2" = 220, "cold_level_3" = 140, "breath_cold_level_1" = 260, "breath_cold_level_2" = 240, "breath_cold_level_3" = 120, "cold_discomfort_level" = 280, "body_temperature" = 330)
	can_take = ORGANICS // negates the need for suit coolers entirely for synths, so no
	excludes = list(/datum/trait/neutral/coldadapt)

	// Traitgenes Made into a genetrait
	is_genetrait = TRUE
	hidden = FALSE

	activation_message="Your body feels chilly."
	primitive_expression_messages=list("shivers.")


/datum/trait/neutral/autohiss_unathi
	name = "Autohiss (Unathi)"
	desc = "You roll your S's and x's"
	cost = 0
	var_changes = list(
	autohiss_basic_map = list(
			"s" = list("ss", "sss", "ssss")
		),
	autohiss_extra_map = list(
			"x" = list("ks", "kss", "ksss")
		),
	autohiss_exempt = list(LANGUAGE_UNATHI))
	excludes = list(/datum/trait/neutral/autohiss_tajaran, /datum/trait/neutral/autohiss_zaddat)
	custom_only = FALSE

/datum/trait/neutral/autohiss_tajaran
	name = "Autohiss (Tajaran)"
	desc = "You roll your R's."
	cost = 0
	var_changes = list(
	autohiss_basic_map = list(
			"r" = list("rr", "rrr", "rrrr")
		),
	autohiss_exempt = list(LANGUAGE_SIIK,LANGUAGE_AKHANI,LANGUAGE_ALAI))
	excludes = list(/datum/trait/neutral/autohiss_unathi, /datum/trait/neutral/autohiss_zaddat)
	custom_only = FALSE

/datum/trait/neutral/autohiss_zaddat
	name = "Autohiss (Zaddat)"
	desc = "You buzz your S's and F's."
	cost = 0
	var_changes = list(
	autohiss_basic_map = list(
			"f" = list("v","vh"),
			"ph" = list("v", "vh")
		),
	autohiss_extra_map = list(
			"s" = list("z", "zz", "zzz"),
			"ce" = list("z", "zz"),
			"ci" = list("z", "zz"),
			"v" = list("vv", "vvv")
		),
	autohiss_exempt = list(LANGUAGE_ZADDAT,LANGUAGE_VESPINAE))
	excludes = list(/datum/trait/neutral/autohiss_tajaran, /datum/trait/neutral/autohiss_unathi)
	custom_only = FALSE

/datum/trait/neutral/bloodsucker
	name = "Bloodsucker, Obligate"
	desc = "Makes you unable to gain nutrition from anything but blood. To compenstate, you get fangs that can be used to drain blood from prey."
	tutorial = "This trait forces you to only consume blood - you cannot have normal food anymore. Vore is, of course, an exception! <br> \
		You can satisfy this by clicking bloodbags in your hand on harm intent, drinking from glasses, blood tomatoes \
		or finding a (un)willing donor for your appropriate appendage! <br><br> \
		Controls for taking blood from your victim can be changed at will by trying to drink from yourself. <br>\
		Intent-based control scheme: <br> \
		HELP - Loud, No Bleeding <br> \
		DISARM - Subtle, Causes bleeding <br> \
		GRAB - Subtle, No Bleeding <br> \
		HARM - Loud, Causes Bleeding"

	cost = 0
	custom_only = FALSE
	var_changes = list("organic_food_coeff" = 0, "bloodsucker" = TRUE) //The verb is given in human.dm
	excludes = list(/datum/trait/neutral/bloodsucker_freeform)

/datum/trait/neutral/bloodsucker/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	add_verb(H, /mob/living/carbon/human/proc/bloodsuck)

/datum/trait/neutral/bloodsucker_freeform
	name = "Bloodsucker"
	desc = "You get fangs that can be used to drain blood from prey."
	tutorial = "This trait allows you to consume blood on top of normal food! <br> \
		You can do this by clicking bloodbags in your hand on harm intent, drinking from glasses, blood tomatoes \
		or finding a (un)willing donor for your appropriate appendage! <br><br> \
		Controls for taking blood from your victim can be changed at will by trying to drink from yourself. <br>\
		Intent-based control scheme: <br> \
		HELP - Loud, No Bleeding <br> \
		DISARM - Subtle, Causes bleeding <br> \
		GRAB - Subtle, No Bleeding <br> \
		HARM - Loud, Causes Bleeding"
	cost = 0
	custom_only = FALSE
	var_changes = list("bloodsucker" = TRUE)
	excludes = list(/datum/trait/neutral/bloodsucker)

/datum/trait/neutral/bloodsucker_freeform/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	add_verb(H, /mob/living/carbon/human/proc/bloodsuck)

/datum/trait/neutral/succubus_drain
	name = "Succubus Drain"
	desc = "Makes you able to gain nutrition from draining prey in your grasp."
	cost = 0
	custom_only = FALSE

/datum/trait/neutral/succubus_drain/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	add_verb(H, /mob/living/carbon/human/proc/succubus_drain)
	add_verb(H, /mob/living/carbon/human/proc/succubus_drain_finalize)
	add_verb(H, /mob/living/carbon/human/proc/succubus_drain_lethal)

/datum/trait/neutral/venom_bite
	name = "Venomous Injection"
	desc = "Allows for injecting prey through one method or another to inject them with a variety of chemicals with varying effects!"
	tutorial = "This trait allows you to bite prey with varying effects! <br> \
		Options for venoms: <br> \
		=====Size Chemicals ===== <br> \
		Microcillin: Will make someone shrink. (This is 1% per 0.01 units. So 1 unit = 100% size change) <br> \
		Macrocillin: Will make someone grow. (This is 1% per 0.01 units. So 1 unit = 100% size change) <br> \
		Normalcillin: Will make someone normal size. (This is 1% per 0.01 units. So 1 unit = 100% size change) Stops at 100% size. <br> \
		===== Gender Chemicals ===== <br> \
		Androrovir: Will transform someone's sex to male. <br> \
		Gynorovir: Will transform someone's sex to female. <br> \
		Androgynorovir: Will transform someone's sex to pleural. <br> \
		===== Special Chemicals ===== <br> \
		Stoxin: Will make someone drowsy. <br> \
		Rainbow Toxin: Will make someone see rainbows. <br> \
		Paralysis Toxin: Will make someone paralyzed. <br> \
		Numbing Enzyme: Will make someone unable to feel pain. <br> \
		Pain Enzyme: Will make someone feel pain, amplifieed <br> \
		===== Side Notes ===== <br> \
		You aren't required to inject anything if you prefer to just use it as a normal bite!"
	cost = 0
	custom_only = FALSE

/datum/trait/neutral/venom_bite/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	add_verb(H, /mob/living/proc/injection)
	H.trait_injection_reagents += REAGENT_ID_MICROCILLIN		// get small
	H.trait_injection_reagents += REAGENT_ID_MACROCILLIN		// get BIG
	H.trait_injection_reagents += REAGENT_ID_NORMALCILLIN	// normal
	H.trait_injection_reagents += REAGENT_ID_NUMBENZYME		// no feelings
	H.trait_injection_reagents += REAGENT_ID_ANDROROVIR 		// -> MALE
	H.trait_injection_reagents += REAGENT_ID_GYNOROVIR 		// -> FEMALE
	H.trait_injection_reagents += REAGENT_ID_ANDROGYNOROVIR 	// -> PLURAL
	H.trait_injection_reagents += REAGENT_ID_STOXIN			// night night chem
	H.trait_injection_reagents += REAGENT_ID_RAINBOWTOXIN 	// Funny flashing lights.
	H.trait_injection_reagents += REAGENT_ID_PARALYSISTOXIN 	// Paralysis!
	H.trait_injection_reagents += REAGENT_ID_PAINENZYME		// Pain INCREASER

/datum/trait/neutral/long_vore
	name = "Long Predatorial Reach"
	desc = "Makes you able to use an unspecified appendage to grab creatures."
	tutorial = "This trait allows you to change its colour and functionality in-game as well as on the trait panel. <br> \
	The trait panel persists between rounds, whereas the in-game modifications are temporary.<br><br> \
	Two functionalities exist: Reach out with the appendage towards prey (default, 'Disabled' option on character setup \
	for the 'Throw Yourself' entry), or fling yourself at the prey and devour them with a pounce! <br> \
	Maximum range: 5 tiles<br>\
	Governed by: Throw Vore preferences (both prey and pred must enable it!) <br> \
	Governed by: Drop Vore (both prey and pred must enable it!) <br> \
	Governed by: Spontaneous Pred/Prey (Both sides must have appropriate one enabled.) <br> \
	If both sides have both pred/prey enabled, favours the character being thrown as prey."
	cost = 0
	has_preferences = list("appendage_color" = list(TRAIT_PREF_TYPE_COLOR, "Appendage Colour", TRAIT_VAREDIT_TARGET_MOB, "#e03997"),
	"appendage_alt_setting" = list(TRAIT_PREF_TYPE_BOOLEAN, "Throw yourself?", TRAIT_VAREDIT_TARGET_MOB, FALSE),)
	custom_only = FALSE

/datum/trait/neutral/long_vore/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	add_verb(H, /mob/living/proc/long_vore)

/datum/trait/neutral/feeder
	name = "Feeder"
	desc = "Allows you to feed your prey using your own body."
	cost = 0
	custom_only = FALSE

/datum/trait/neutral/feeder/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	add_verb(H, /mob/living/carbon/human/proc/slime_feed)

/datum/trait/neutral/stuffing_feeder
	name = "Food Stuffer"
	desc = "Allows you to feed food to other people whole, rather than bite by bite."
	cost = 0
	custom_only = FALSE
	has_preferences = list("stuffing_feeder" = list(TRAIT_PREF_TYPE_BOOLEAN, "Default", TRAIT_VAREDIT_TARGET_MOB, FALSE))

/datum/trait/neutral/stuffing_feeder/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	add_verb(H, /mob/living/proc/toggle_stuffing_mode)

/datum/trait/neutral/hard_vore
	name = "Hard Vore"
	desc = "Allows you to tear off limbs & tear out internal organs."
	cost = 0
	custom_only = FALSE

/datum/trait/neutral/hard_vore/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	add_verb(H, /mob/living/proc/shred_limb)

/datum/trait/neutral/trashcan
	name = "Trash Can"
	desc = "Allows you to dispose of some garbage on the go instead of having to look for a bin or littering like an animal."
	cost = 0
	custom_only = FALSE
	var_changes = list("trashcan" = 1)

	// Traitgenes made into a genetrait
	is_genetrait = TRUE
	hidden = FALSE

	activation_message="Your stomach feels strange."
	primitive_expression_messages=list("eats something off the ground.")

/datum/trait/neutral/trashcan/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	add_verb(H, /mob/living/proc/eat_trash)
	add_verb(H, /mob/living/proc/toggle_trash_catching)

// Traitgenes made into a genetrait
/datum/trait/neutral/trashcan/unapply(datum/species/S, mob/living/carbon/human/H, trait_prefs)
	..()
	if(!(/mob/living/proc/eat_trash in S.inherent_verbs))
		remove_verb(H,/mob/living/proc/eat_trash)
	if(!(/mob/living/proc/toggle_trash_catching in S.inherent_verbs))
		remove_verb(H,/mob/living/proc/toggle_trash_catching)

/datum/trait/neutral/gem_eater
	name = "Expensive Taste"
	desc = "You only gain nutrition from raw ore and refined minerals. There's nothing that sates the appetite better than precious gems, exotic or rare minerals and you have damn fine taste. Anything else is beneath you."
	cost = 0
	custom_only = FALSE
	var_changes = list("organic_food_coeff" = 0, "eat_minerals" = 1)

	// Traitgenes made into a genetrait
	is_genetrait = TRUE
	hidden = FALSE

	activation_message="Your stomach feels strange."
	primitive_expression_messages=list("picks up and eats something shiny off the ground.")

/datum/trait/neutral/gem_eater/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	add_verb(H, /mob/living/proc/eat_minerals)

// Traitgenes made into a genetrait
/datum/trait/neutral/gem_eater/unapply(datum/species/S, mob/living/carbon/human/H, trait_prefs)
	..()
	if(!(/mob/living/proc/eat_minerals in S.inherent_verbs))
		remove_verb(H,/mob/living/proc/eat_minerals)

/datum/trait/neutral/synth_chemfurnace
	name = "Biofuel Processor"
	desc = "You are able to gain energy through consuming and processing normal food, at the cost of significantly slower recharging via cyborg chargers. Energy-dense foods such as protein bars and survival food will yield the best results."
	cost = 0
	custom_only = FALSE
	can_take = SYNTHETICS
	var_changes = list("organic_food_coeff" = 0.75, "synthetic_food_coeff" = 1)
	excludes = list(/datum/trait/neutral/biofuel_value_down)

/datum/trait/neutral/synth_ethanolburner
	name = "Ethanol Burner"
	desc = "You are able to gain energy through consuming and processing alcohol. The more alcoholic it is, the more energy you gain. Doesn't allow you to get drunk by itself (for that, take Ethanol Simulator)."
	cost = 0
	custom_only = FALSE
	can_take = SYNTHETICS
	var_changes = list("robo_ethanol_proc" = 1)

/datum/trait/neutral/synth_ethanol_sim
	name = "Ethanol Simulator"
	desc = "An unusual modification allows your synthetic body to simulate all but the lethal effects of ingested alcohols. You'll get dizzy, slur your speech, suffer temporary loss of vision and even pass out! But hey, at least you don't have a liver to destroy."
	cost = 0
	custom_only = FALSE
	can_take = SYNTHETICS
	var_changes = list("robo_ethanol_drunk" = 1)

/datum/trait/neutral/glowing_eyes
	name = "Glowing Eyes"
	desc = "Your eyes show up above darkness. SPOOKY! And kinda edgey too."
	cost = 0
	custom_only = FALSE
	var_changes = list("has_glowing_eyes" = 1)
	has_preferences = list("has_glowing_eyes" = list(TRAIT_PREF_TYPE_BOOLEAN, "Glowing on spawn", TRAIT_VAREDIT_TARGET_SPECIES))

	// Traitgenes Made into a genetrait
	is_genetrait = TRUE
	hidden = FALSE

	activation_message="Your eyes feel brighter."
	primitive_expression_messages=list("eyes twinkle.")

/datum/trait/neutral/glowing_eyes/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	add_verb(H, /mob/living/carbon/human/proc/toggle_eye_glow)

// Traitgenes Made into a genetrait
/datum/trait/neutral/glowing_eyes/unapply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	if(!(/mob/living/carbon/human/proc/toggle_eye_glow in S.inherent_verbs))
		remove_verb(H,/mob/living/carbon/human/proc/toggle_eye_glow)

/datum/trait/neutral/glowing_body
	name = "Glowing Body"
	desc = "Your body glows about as much as a PDA light! Settable color and toggle in Abilities tab ingame."
	cost = 0
	custom_only = FALSE
	has_preferences = list("glow_toggle" = list(TRAIT_PREF_TYPE_BOOLEAN, "Glowing on spawn", TRAIT_VAREDIT_TARGET_MOB, FALSE), \
							"glow_color" = list(TRAIT_PREF_TYPE_COLOR, "Glow color", TRAIT_VAREDIT_TARGET_MOB))

	// Traitgenes Made into a genetrait
	is_genetrait = TRUE
	hidden = FALSE

	activation_message="You feel enlightened."
	primitive_expression_messages=list("shines and sparkles.")

/datum/trait/neutral/glowing_body/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	add_verb(H, /mob/living/proc/glow_toggle)
	add_verb(H, /mob/living/proc/glow_color)

// Traitgenes Made into a genetrait
/datum/trait/neutral/glowing_body/unapply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	if(!(/mob/living/proc/glow_toggle in S.inherent_verbs))
		remove_verb(H,/mob/living/proc/glow_toggle)
	if(!(/mob/living/proc/glow_color in S.inherent_verbs))
		remove_verb(H,/mob/living/proc/glow_color)

//Allergen traits! Not available to any species with a base allergens var.
/datum/trait/neutral/allergy
	name = "Allergy: Gluten"
	desc = "You're highly allergic to gluten proteins, which are found in most common grains. NB: By taking this trait, you acknowledge there is a significant risk your character may suffer a fatal reaction if exposed to this substance."
	cost = 0
	custom_only = FALSE
	var/allergen = ALLERGEN_GRAINS

	// Traitgenes Made ALL ALLERGYS into gene traits
	is_genetrait = TRUE
	hidden = FALSE

	activation_message="Something feels odd..."

/datum/trait/neutral/allergy/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	S.allergens |= allergen
	..()

// Traitgenes edit begin - Made ALL ALLERGYS into gene traits
/datum/trait/neutral/allergy/unapply(var/datum/species/S,var/mob/living/carbon/human/H)
	S.allergens &= ~allergen
	..()
// Traitgenes edit end

/datum/trait/neutral/allergy/meat
	name = "Allergy: Meat"
	desc = "You're highly allergic to just about any form of meat. You're probably better off just sticking to vegetables. NB: By taking this trait, you acknowledge there is a significant risk your character may suffer a fatal reaction if exposed to this substance."
	cost = 0
	custom_only = FALSE
	allergen = ALLERGEN_MEAT

/datum/trait/neutral/allergy/fish
	name = "Allergy: Fish"
	desc = "You're highly allergic to fish. It's probably best to avoid seafood in general. NB: By taking this trait, you acknowledge there is a significant risk your character may suffer a fatal reaction if exposed to this substance."
	cost = 0
	custom_only = FALSE
	allergen = ALLERGEN_FISH

/datum/trait/neutral/allergy/fruit
	name = "Allergy: Fruit"
	desc = "You're highly allergic to fruit. Vegetables are fine, but you should probably read up on how to tell the difference. Remember, tomatoes are a fruit. NB: By taking this trait, you acknowledge there is a significant risk your character may suffer a fatal reaction if exposed to this substance."
	cost = 0
	custom_only = FALSE
	allergen = ALLERGEN_FRUIT

/datum/trait/neutral/allergy/vegetable
	name = "Allergy: Vegetable"
	desc = "You're highly allergic to vegetables. Fruit are fine, but you should probably read up on how to tell the difference. NB: By taking this trait, you acknowledge there is a significant risk your character may suffer a fatal reaction if exposed to this substance."
	cost = 0
	custom_only = FALSE
	allergen = ALLERGEN_VEGETABLE

/datum/trait/neutral/allergy/nuts
	name = "Allergy: Nuts"
	desc = "You're highly allergic to hard-shell seeds, such as peanuts. NB: By taking this trait, you acknowledge there is a significant risk your character may suffer a fatal reaction if exposed to this substance."
	cost = 0
	custom_only = FALSE
	allergen = ALLERGEN_SEEDS

/datum/trait/neutral/allergy/soy
	name = "Allergy: Soy"
	desc = "You're highly allergic to soybeans, and some other kinds of bean. NB: By taking this trait, you acknowledge there is a significant risk your character may suffer a fatal reaction if exposed to this substance."
	cost = 0
	custom_only = FALSE
	allergen = ALLERGEN_BEANS

/datum/trait/neutral/allergy/dairy
	name = "Allergy: Lactose"
	desc = "You're highly allergic to lactose, and consequently, just about all forms of dairy. NB: By taking this trait, you acknowledge there is a significant risk your character may suffer a fatal reaction if exposed to this substance."
	cost = 0
	custom_only = FALSE
	allergen = ALLERGEN_DAIRY

/datum/trait/neutral/allergy/fungi
	name = "Allergy: Fungi"
	desc = "You're highly allergic to fungi such as mushrooms. NB: By taking this trait, you acknowledge there is a significant risk your character may suffer a fatal reaction if exposed to this substance."
	cost = 0
	custom_only = FALSE
	allergen = ALLERGEN_FUNGI

/datum/trait/neutral/allergy/coffee
	name = "Allergy: Coffee"
	desc = "You're highly allergic to coffee in specific. NB: By taking this trait, you acknowledge there is a significant risk your character may suffer a fatal reaction if exposed to this substance."
	cost = 0
	custom_only = FALSE
	allergen = ALLERGEN_COFFEE

/datum/trait/neutral/allergy/chocolate
	name = "Allergy: Chocolate"
	desc = "You're highly allergic to coco and chocolate in specific. NB: By taking this trait, you acknowledge there is a significant risk your character may suffer a fatal reaction if exposed to this substance."
	cost = 0
	custom_only = FALSE
	allergen = ALLERGEN_CHOCOLATE

/datum/trait/neutral/allergy_reaction
	name = "Allergy Reaction: Disable Toxicity"
	desc = "Take this trait to disable the toxic damage effect of being exposed to one of your allergens. Combine with the Disable Suffocation trait to have purely nonlethal reactions."
	cost = 0
	custom_only = FALSE
	var/reaction = AG_TOX_DMG

/datum/trait/neutral/allergy_reaction/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	S.allergen_reaction ^= reaction
	..()

/datum/trait/neutral/allergy_reaction/oxy
	name = "Allergy Reaction: Disable Suffocation"
	desc = "Take this trait to disable the oxygen deprivation damage effect of being exposed to one of your allergens. Combine with the Disable Toxicity trait to have purely nonlethal reactions."
	cost = 0
	custom_only = FALSE
	reaction = AG_OXY_DMG

/datum/trait/neutral/allergy_reaction/brute
	name = "Allergy Reaction: Spontaneous Trauma"
	desc = "When exposed to one of your allergens, your skin develops unnatural bruises and other 'stigmata'-like injuries. Be aware that untreated wounds may become infected."
	cost = 0
	custom_only = FALSE
	reaction = AG_PHYS_DMG

/datum/trait/neutral/allergy_reaction/burn
	name = "Allergy Reaction: Blistering"
	desc = "When exposed to one of your allergens, your skin develops unnatural blisters and burns, as if exposed to fire. Be aware that untreated burns are very susceptible to infection!"
	cost = 0
	custom_only = FALSE
	reaction = AG_BURN_DMG

/datum/trait/neutral/allergy_reaction/pain
	name = "Allergy Reaction: Disable Pain"
	desc = "Take this trait to disable experiencing pain after being exposed to one of your allergens."
	cost = 0
	custom_only = FALSE
	reaction = AG_PAIN

/datum/trait/neutral/allergy_reaction/weaken
	name = "Allergy Reaction: Knockdown"
	desc = "When exposed to one of your allergens, you will experience sudden and abrupt loss of muscle control and tension, resulting in immediate collapse and immobility. Does nothing if you have no allergens."
	cost = 0
	custom_only = FALSE
	reaction = AG_WEAKEN

/datum/trait/neutral/allergy_reaction/blurry
	name = "Allergy Reaction: Disable Blurring"
	desc = "Take this trait to disable the blurred/impeded vision effect of allergens."
	cost = 0
	custom_only = FALSE
	reaction = AG_BLURRY

/datum/trait/neutral/allergy_reaction/sleepy
	name = "Allergy Reaction: Fatigue"
	desc = "When exposed to one of your allergens, you will experience fatigue and tiredness, and may potentially pass out entirely. Does nothing if you have no allergens."
	cost = 0
	custom_only = FALSE
	reaction = AG_SLEEPY

/datum/trait/neutral/allergy_reaction/confusion
	name = "Allergy Reaction: Disable Confusion"
	desc = "Take this trait to disable the confusion/disorientation effect of allergens."
	cost = 0
	custom_only = FALSE
	reaction = AG_CONFUSE

/datum/trait/neutral/allergen_reduced_effect
	name = "Allergen Reaction: Reduced Intensity"
	desc = "This trait drastically reduces the effects of allergen reactions. If you don't have any allergens set, it does nothing. It does not apply to special reactions (such as unathi drowsiness from sugars)."
	cost = 0
	custom_only = FALSE
	var_changes = list("allergen_damage_severity" = 1.25, "allergen_disable_severity" = 5)
	excludes = list(/datum/trait/neutral/allergen_increased_effect)

/datum/trait/neutral/allergen_increased_effect
	name = "Allergen Reaction: Increased Intensity"
	desc = "This trait drastically increases the effects of allergen reactions, enough that even a small dose can be lethal. If you don't have any allergens set, it does nothing. It does not apply to special reactions (such as unathi drowsiness from sugars)."
	cost = 0
	custom_only = FALSE
	var_changes = list("allergen_damage_severity" = 5, "allergen_disable_severity" = 20)
	excludes = list(/datum/trait/neutral/allergen_reduced_effect)

// Spicy Food Traits, from negative to positive.
/datum/trait/neutral/spice_intolerance_extreme
	name = "Spice Intolerance, Extreme"
	desc = "Spicy (and chilly) peppers are three times as strong. (This does not affect pepperspray.)"
	cost = 0
	custom_only = FALSE
	var_changes = list("spice_mod" = 3) // 300% as effective if spice_mod is set to 1. If it's not 1 in species.dm, update this!

	// Traitgenes Made into a gene trait
	is_genetrait = TRUE
	hidden = FALSE

	activation_message="Your belly feels strange..."

/datum/trait/neutral/spice_intolerance_basic
	name = "Spice Intolerance, Heavy"
	desc = "Spicy (and chilly) peppers are twice as strong. (This does not affect pepperspray.)"
	cost = 0
	custom_only = FALSE
	var_changes = list("spice_mod" = 2) // 200% as effective if spice_mod is set to 1. If it's not 1 in species.dm, update this!

/datum/trait/neutral/spice_intolerance_slight
	name = "Spice Intolerance, Slight"
	desc = "You have a slight struggle with spicy foods. Spicy (and chilly) peppers are one and a half times stronger. (This does not affect pepperspray.)"
	cost = 0
	custom_only = FALSE
	var_changes = list("spice_mod" = 1.5) // 150% as effective if spice_mod is set to 1. If it's not 1 in species.dm, update this!

/datum/trait/neutral/spice_tolerance_basic
	name = "Spice Tolerance"
	desc = "Spicy (and chilly) peppers are only three-quarters as strong. (This does not affect pepperspray.)"
	cost = 0
	custom_only = FALSE
	var_changes = list("spice_mod" = 0.75) // 75% as effective if spice_mod is set to 1. If it's not 1 in species.dm, update this!

/datum/trait/neutral/spice_tolerance_advanced
	name = "Spice Tolerance, Strong"
	desc = "Spicy (and chilly) peppers are only half as strong. (This does not affect pepperspray.)"
	cost = 0
	custom_only = FALSE
	var_changes = list("spice_mod" = 0.5) // 50% as effective if spice_mod is set to 1. If it's not 1 in species.dm, update this!

/datum/trait/neutral/spice_immunity
	name = "Spice Tolerance, Extreme"
	desc = "Spicy (and chilly) peppers are basically ineffective! (This does not affect pepperspray.)"
	cost = 0
	custom_only = FALSE
	var_changes = list("spice_mod" = 0.25) // 25% as effective if spice_mod is set to 1. If it's not 1 in species.dm, update this!

	// Traitgenes Made into a gene trait
	is_genetrait = TRUE
	hidden = FALSE

	activation_message="Your belly feels strange..."

// Alcohol Traits Start Here, from negative to positive.
/datum/trait/neutral/alcohol_intolerance_advanced
	name = "Liver of Air"
	desc = "The only way you can hold a drink is if it's in your own two hands, and even then you'd best not inhale too deeply near it. Alcohol hits you three times as hard as they do other people."
	cost = 0
	custom_only = FALSE
	var_changes = list("chem_strength_alcohol" = 0.33)

	// Traitgenes Made into a gene trait
	is_genetrait = TRUE
	hidden = FALSE

	activation_message="Your belly feels strange..."

/datum/trait/neutral/alcohol_intolerance_basic
	name = "Liver of Lilies"
	desc = "You have a hard time with alcohol. Maybe you just never took to it, or maybe it doesn't agree with your system... either way, alcohol hits you twice as hard."
	cost = 0
	custom_only = FALSE
	var_changes = list("chem_strength_alcohol" = 0.5)

/datum/trait/neutral/alcohol_intolerance_slight
	name = "Liver of Tulips"
	desc = "You are what some might call 'a bit of a lightweight', but you can still keep your drinks down... most of the time. Alcohol hits you fifty percent harder."
	cost = 0
	custom_only = FALSE
	var_changes = list("chem_strength_alcohol" = 0.75)

/datum/trait/neutral/alcohol_tolerance_reset
	name = "Liver of Unremarkableness"
	desc = "This trait exists to reset alcohol (in)tolerance for non-custom species to baseline normal. It can only be taken by Skrell, Tajara, Unathi, Diona, and Prometheans, as it would have no effect on other species."
	cost = 0
	custom_only = FALSE
	var_changes = list("chem_strength_alcohol" = 1)
	allowed_species = list(SPECIES_SKRELL,SPECIES_TAJARAN,SPECIES_UNATHI,SPECIES_DIONA,SPECIES_PROMETHEAN)

/datum/trait/neutral/alcohol_tolerance_basic
	name = "Liver of Iron"
	desc = "You can hold drinks much better than those lily-livered land-lubbers! Arr! Alcohol's effects on you are reduced by about a quarter."
	cost = 0
	custom_only = FALSE
	var_changes = list("chem_strength_alcohol" = 1.25)

/datum/trait/neutral/alcohol_tolerance_advanced
	name = "Liver of Steel"
	desc = "Drinks tremble before your might! You can hold your alcohol twice as well as those blue-bellied barnacle boilers! Alcohol has just half the effect on you as it does on others."
	cost = 0
	custom_only = FALSE
	var_changes = list("chem_strength_alcohol" = 2)

/datum/trait/neutral/alcohol_immunity
	name = "Liver of Durasteel"
	desc = "You've drunk so much that most booze doesn't even faze you. It takes something like a Pan-Galactic or a pint of Deathbell for you to even get slightly buzzed."
	cost = 0
	custom_only = FALSE
	var_changes = list("chem_strength_alcohol" = 4)

	// Traitgenes Made into a gene trait
	is_genetrait = TRUE
	hidden = FALSE

	activation_message="Your belly feels strange..."
// Alcohol Traits End Here.

/datum/trait/neutral/colorblind/mono
	name = "Colorblindness (Monochromancy)"
	desc = "You simply can't see colors at all, period. You are 100% colorblind."
	cost = 0
	custom_only = FALSE

	// Traitgenes Made into a gene trait
	is_genetrait = TRUE
	hidden = FALSE

	activation_message="Your eyes feel strange..."

/datum/trait/neutral/colorblind/mono/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	H.add_modifier(/datum/modifier/trait/colorblind_monochrome)

// Traitgenes Made into a gene trait
/datum/trait/neutral/colorblind/mono/unapply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	H.remove_a_modifier_of_type(/datum/modifier/trait/colorblind_monochrome)

/datum/trait/neutral/colorblind/para_vulp
	name = "Colorblindness (Para Vulp)"
	desc = "You have a severe issue with green colors and have difficulty recognizing them from red colors."
	cost = 0
	custom_only = FALSE

	// Traitgenes Made into a gene trait
	is_genetrait = TRUE
	hidden = FALSE

	activation_message="Your eyes feel strange..."

/datum/trait/neutral/colorblind/para_vulp/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	H.add_modifier(/datum/modifier/trait/colorblind_vulp)

// Traitgenes Made into a gene trait
/datum/trait/neutral/colorblind/para_vulp/unapply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	H.remove_a_modifier_of_type(/datum/modifier/trait/colorblind_vulp)

/datum/trait/neutral/colorblind/para_taj
	name = "Colorblindness (Para Taj)"
	desc = "You have a minor issue with blue colors and have difficulty recognizing them from red colors."
	cost = 0
	custom_only = FALSE

	// Traitgenes - Made into a gene trait
	is_genetrait = TRUE
	hidden = FALSE

	activation_message="Your eyes feel strange..."

/datum/trait/neutral/colorblind/para_taj/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	H.add_modifier(/datum/modifier/trait/colorblind_taj)

// Traitgenes Made into a gene trait
/datum/trait/neutral/colorblind/para_taj/unapply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	H.remove_a_modifier_of_type(/datum/modifier/trait/colorblind_taj)

// Body shape traits
/datum/trait/neutral/taller
	name = "Tall"
	desc = "Your body is taller than average."
	sort = TRAIT_SORT_BODYTYPE
	cost = 0
	custom_only = FALSE
	var_changes = list("icon_scale_y" = 1.09)
	excludes = list(/datum/trait/neutral/tall, /datum/trait/neutral/tallest, /datum/trait/neutral/short, /datum/trait/neutral/shorter, /datum/trait/neutral/shortest)

/datum/trait/neutral/taller/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	H.update_transform()

/datum/trait/neutral/tall
	name = "Tall, Minor"
	desc = "Your body is a bit taller than average."
	sort = TRAIT_SORT_BODYTYPE
	cost = 0
	custom_only = FALSE
	var_changes = list("icon_scale_y" = 1.05)
	excludes = list(/datum/trait/neutral/taller, /datum/trait/neutral/tallest, /datum/trait/neutral/short, /datum/trait/neutral/shorter, /datum/trait/neutral/shortest)

/datum/trait/neutral/tall/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	H.update_transform()

/datum/trait/neutral/tallest
	name = "Tall, Major"
	desc = "Your body is way taller than average."
	sort = TRAIT_SORT_BODYTYPE
	cost = 0
	custom_only = FALSE
	var_changes = list("icon_scale_y" = 1.15)
	excludes = list(/datum/trait/neutral/tall, /datum/trait/neutral/taller, /datum/trait/neutral/short, /datum/trait/neutral/shorter, /datum/trait/neutral/shortest)

/datum/trait/neutral/tallest/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	H.update_transform()

/datum/trait/neutral/short
	name = "Short, Minor"
	desc = "Your body is a bit shorter than average."
	sort = TRAIT_SORT_BODYTYPE
	cost = 0
	custom_only = FALSE
	var_changes = list("icon_scale_y" = 0.95)
	excludes = list(/datum/trait/neutral/taller, /datum/trait/neutral/tall, /datum/trait/neutral/tallest, /datum/trait/neutral/shorter, /datum/trait/neutral/shortest)

/datum/trait/neutral/short/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	H.update_transform()

/datum/trait/neutral/shorter
	name = "Short"
	desc = "Your body is shorter than average."
	sort = TRAIT_SORT_BODYTYPE
	cost = 0
	custom_only = FALSE
	var_changes = list("icon_scale_y" = 0.915)
	excludes = list(/datum/trait/neutral/taller, /datum/trait/neutral/tall, /datum/trait/neutral/tallest, /datum/trait/neutral/short, /datum/trait/neutral/shortest)

/datum/trait/neutral/shorter/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	H.update_transform()

/datum/trait/neutral/shortest
	name = "Short, Major"
	desc = "Your body is way shorter than average."
	sort = TRAIT_SORT_BODYTYPE
	cost = 0
	custom_only = FALSE
	var_changes = list("icon_scale_y" = 0.85)
	excludes = list(/datum/trait/neutral/taller, /datum/trait/neutral/tall, /datum/trait/neutral/tallest, /datum/trait/neutral/short, /datum/trait/neutral/shorter)

/datum/trait/neutral/shortest/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	H.update_transform()

/datum/trait/neutral/obese
	name = "Bulky, Major"
	desc = "Your body is much wider than average."
	sort = TRAIT_SORT_BODYTYPE
	cost = 0
	custom_only = FALSE
	var_changes = list("icon_scale_x" = 1.095)
	excludes = list(/datum/trait/neutral/fat, /datum/trait/neutral/thin, /datum/trait/neutral/thinner)

/datum/trait/neutral/obese/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	H.update_transform()

/datum/trait/neutral/fat
	name = "Bulky"
	desc = "Your body is wider than average."
	sort = TRAIT_SORT_BODYTYPE
	cost = 0
	custom_only = FALSE
	var_changes = list("icon_scale_x" = 1.054)
	excludes = list(/datum/trait/neutral/obese, /datum/trait/neutral/thin, /datum/trait/neutral/thinner)

/datum/trait/neutral/fat/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	H.update_transform()

/datum/trait/neutral/thin
	name = "Thin"
	desc = "Your body is thinner than average."
	sort = TRAIT_SORT_BODYTYPE
	cost = 0
	custom_only = FALSE
	var_changes = list("icon_scale_x" = 0.945)
	excludes = list(/datum/trait/neutral/fat, /datum/trait/neutral/obese, /datum/trait/neutral/thinner)

/datum/trait/neutral/thin/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	H.update_transform()

/datum/trait/neutral/thinner
	name = "Thin, Major"
	desc = "Your body is much thinner than average."
	sort = TRAIT_SORT_BODYTYPE
	cost = 0
	custom_only = FALSE
	var_changes = list("icon_scale_x" = 0.905)
	excludes = list(/datum/trait/neutral/fat, /datum/trait/neutral/obese, /datum/trait/neutral/thin)

/datum/trait/neutral/thinner/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	H.update_transform()

/datum/trait/neutral/dominate_predator
	name = "Dominate Predator"
	desc = "Allows you to attempt to take control of a predator while inside of their belly."
	cost = 0
	custom_only = FALSE

	// Traitgenes made into a genetrait
	is_genetrait = TRUE
	hidden = FALSE

	activation_message="Your mind feels more powerful."

/datum/trait/neutral/dominate_predator/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	add_verb(H, /mob/proc/dominate_predator)

// Traitgenes made into a genetrait
/datum/trait/neutral/dominate_predator/unapply(datum/species/S, mob/living/carbon/human/H, trait_prefs)
	..()
	if(!(/mob/proc/dominate_predator in S.inherent_verbs))
		remove_verb(H,/mob/proc/dominate_predator)

/datum/trait/neutral/dominate_prey
	name = "Dominate Prey"
	desc = "Connect to and dominate the brain of your prey."
	cost = 0
	custom_only = FALSE

	// Traitgenes made into a genetrait
	is_genetrait = TRUE
	hidden = FALSE

	activation_message="Your mind feels more powerful."

/datum/trait/neutral/dominate_prey/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	add_verb(H, /mob/living/proc/dominate_prey)

// Traitgenes made into a genetrait
/datum/trait/neutral/dominate_prey/unapply(datum/species/S, mob/living/carbon/human/H, trait_prefs)
	..()
	if(!(/mob/living/proc/dominate_prey in S.inherent_verbs))
		remove_verb(H,/mob/living/proc/dominate_prey)

/datum/trait/neutral/submit_to_prey
	name = "Submit To Prey"
	desc = "Allow prey's mind to control your own body."
	cost = 0
	custom_only = FALSE

	// Traitgenes made into a genetrait
	is_genetrait = TRUE
	hidden = FALSE

	activation_message="Your mind feels more fluid."

/datum/trait/neutral/submit_to_prey/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	add_verb(H, /mob/living/proc/lend_prey_control)

// Traitgenes made into a genetrait
/datum/trait/neutral/submit_to_prey/unapply(datum/species/S, mob/living/carbon/human/H, trait_prefs)
	..()
	if(!(/mob/living/proc/lend_prey_control in S.inherent_verbs))
		remove_verb(H,/mob/living/proc/lend_prey_control)

/datum/trait/neutral/vertical_nom
	name = "Vertical Nom"
	desc = "Allows you to consume people from up above."
	cost = 0
	custom_only = FALSE

/datum/trait/neutral/vertical_nom/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	add_verb(H, /mob/living/proc/vertical_nom)

/datum/trait/neutral/micro_size_down
	name = "Light Frame"
	desc = "You are considered smaller than you are for micro interactions."
	cost = 0
	custom_only = FALSE
	var_changes = list("micro_size_mod" = -0.15)

/datum/trait/neutral/micro_size_down_plus
	name = "Light Frame, Major"
	desc = "You are considered much smaller than you are for micro interactions."
	cost = 0
	custom_only = FALSE
	var_changes = list("micro_size_mod" = -0.30)

/datum/trait/neutral/micro_size_up
	name = "Heavy Frame"
	desc = "You are considered bigger than you are for micro interactions."
	cost = 0
	custom_only = FALSE
	var_changes = list("micro_size_mod" = 0.15)

/datum/trait/neutral/micro_size_up_plus
	name = "Heavy Frame, Major"
	desc = "You are considered much bigger than you are for micro interactions."
	cost = 0
	custom_only = FALSE
	var_changes = list("micro_size_mod" = 0.30)

/datum/trait/neutral/digestion_value_up
	name = "Highly Filling"
	desc = "You provide notably more nutrition to anyone who makes a meal of you."
	cost = 0
	custom_only = FALSE
	var_changes = list("digestion_nutrition_modifier" = 2)

/datum/trait/neutral/digestion_value_up_plus
	name = "Extremely Filling"
	desc = "You provide a lot more nutrition to anyone who makes a meal of you."
	cost = 0
	custom_only = FALSE
	var_changes = list("digestion_nutrition_modifier" = 3)

/datum/trait/neutral/digestion_value_down
	name = "Slightly Filling"
	desc = "You provide notably less nutrition to anyone who makes a meal of you."
	cost = 0
	custom_only = FALSE
	var_changes = list("digestion_nutrition_modifier" = 0.5)

/datum/trait/neutral/digestion_value_down_plus
	name = "Barely Filling"
	desc = "You provide a lot less nutrition to anyone who makes a meal of you."
	cost = 0
	custom_only = FALSE
	var_changes = list("digestion_nutrition_modifier" = 0.25)


/datum/trait/neutral/food_value_down
	name = "Insatiable"
	desc = "You need to eat a third of a plate more to be sated."
	cost = 0
	custom_only = FALSE
	can_take = ORGANICS
	var_changes = list(organic_food_coeff = 0.67, digestion_efficiency = 0.66)
	excludes = list(/datum/trait/neutral/bloodsucker)

/datum/trait/neutral/food_value_down_plus
	name = "Insatiable, Greater"
	desc = "You need to eat three times as much to feel sated."
	cost = 0
	custom_only = FALSE
	can_take = ORGANICS
	var_changes = list(organic_food_coeff = 0.33, digestion_efficiency = 0.33)
	excludes = list(/datum/trait/neutral/bloodsucker, /datum/trait/neutral/food_value_down)

/datum/trait/neutral/biofuel_value_down
	name = "Discount Biofuel processor"
	desc = "You are able to gain energy through consuming and processing normal food. Unfortunately, it is half as effective as premium models. On the plus side, you still recharge from charging stations fairly efficiently."
	cost = 0
	custom_only = FALSE
	can_take = SYNTHETICS
	var_changes = list("organic_food_coeff" = 0, "synthetic_food_coeff" = 0.3, digestion_efficiency = 0.5)
	excludes = list(/datum/trait/neutral/synth_chemfurnace)

/datum/trait/neutral/synth_cosmetic_pain
	name = "Pain simulation"
	desc = "You have added modules in your synthetic shell that simulates the sensation of pain. You are able to turn this on and off for repairs as needed or convenience at will."
	cost = 0
	custom_only = FALSE
	can_take = SYNTHETICS
	has_preferences = list("pain" = list(TRAIT_PREF_TYPE_BOOLEAN, "Enabled on spawn", TRAIT_VAREDIT_TARGET_MOB, FALSE))

/datum/trait/neutral/synth_cosmetic_pain/apply(var/datum/species/S,var/mob/living/carbon/human/H, var/trait_prefs = null)
	..()
	add_verb(H, /mob/living/carbon/human/proc/toggle_pain_module)

//Food preferences ported from RogueStar

/datum/trait/neutral/food_pref
	name = "Food Preference - Carnivore"
	desc = "You prefer to eat meat, and gain extra nutrition for doing so!"
	cost = 0
	custom_only = FALSE
	can_take = ORGANICS
	var_changes = list("food_preference_bonus" = 5)
	excludes = list(
	/datum/trait/neutral/food_pref,
	/datum/trait/neutral/food_pref/herbivore,
	/datum/trait/neutral/food_pref/beanivore,
	/datum/trait/neutral/food_pref/omnivore,
	/datum/trait/neutral/food_pref/fungivore,
	/datum/trait/neutral/food_pref/piscivore,
	/datum/trait/neutral/food_pref/granivore,
	/datum/trait/neutral/food_pref/cocoavore,
	/datum/trait/neutral/food_pref/glycovore,
	/datum/trait/neutral/food_pref/lactovore,
	/datum/trait/neutral/food_pref/coffee,
	/datum/trait/neutral/food_pref/stimulant
	)
	var/list/our_allergens = list(ALLERGEN_MEAT)

/datum/trait/neutral/food_pref/apply(datum/species/S, mob/living/carbon/human/H, trait_prefs)
	. = ..()
	for(var/a in our_allergens)
		S.food_preference |= a

/datum/trait/neutral/food_pref/herbivore
	name = "Food Preference - Herbivore"
	desc = "You prefer to eat fruits and vegitables, and gain extra nutrition for doing so!"
	excludes = list(
	/datum/trait/neutral/food_pref,
	/datum/trait/neutral/food_pref/beanivore,
	/datum/trait/neutral/food_pref/omnivore,
	/datum/trait/neutral/food_pref/fungivore,
	/datum/trait/neutral/food_pref/piscivore,
	/datum/trait/neutral/food_pref/granivore,
	/datum/trait/neutral/food_pref/cocoavore,
	/datum/trait/neutral/food_pref/glycovore,
	/datum/trait/neutral/food_pref/lactovore,
	/datum/trait/neutral/food_pref/coffee,
	/datum/trait/neutral/food_pref/stimulant
	)
	our_allergens = list(ALLERGEN_VEGETABLE,ALLERGEN_FRUIT)

/datum/trait/neutral/food_pref/beanivore
	name = "Food Preference - Legumovore"
	desc = "You prefer to eat bean related foods, such as tofu, and gain extra nutrition for doing so!"
	excludes = list(
	/datum/trait/neutral/food_pref,
	/datum/trait/neutral/food_pref/herbivore,
	/datum/trait/neutral/food_pref/omnivore,
	/datum/trait/neutral/food_pref/fungivore,
	/datum/trait/neutral/food_pref/piscivore,
	/datum/trait/neutral/food_pref/granivore,
	/datum/trait/neutral/food_pref/cocoavore,
	/datum/trait/neutral/food_pref/glycovore,
	/datum/trait/neutral/food_pref/lactovore,
	/datum/trait/neutral/food_pref/coffee,
	/datum/trait/neutral/food_pref/stimulant
	)
	our_allergens = list(ALLERGEN_BEANS)

/datum/trait/neutral/food_pref/omnivore
	name = "Food Preference - Omnivore"
	desc = "You prefer to eat meat and vegitables, and gain extra nutrition for doing so!"
	excludes = list(
	/datum/trait/neutral/food_pref,
	/datum/trait/neutral/food_pref/herbivore,
	/datum/trait/neutral/food_pref/beanivore,
	/datum/trait/neutral/food_pref/fungivore,
	/datum/trait/neutral/food_pref/piscivore,
	/datum/trait/neutral/food_pref/granivore,
	/datum/trait/neutral/food_pref/cocoavore,
	/datum/trait/neutral/food_pref/glycovore,
	/datum/trait/neutral/food_pref/lactovore,
	/datum/trait/neutral/food_pref/coffee,
	/datum/trait/neutral/food_pref/stimulant
	)
	our_allergens = list(ALLERGEN_VEGETABLE,ALLERGEN_MEAT)

/datum/trait/neutral/food_pref/fungivore
	name = "Food Preference - Fungivore"
	desc = "You prefer to eat mushrooms and fungus, and gain extra nutrition for doing so!"
	excludes = list(
	/datum/trait/neutral/food_pref,
	/datum/trait/neutral/food_pref/herbivore,
	/datum/trait/neutral/food_pref/beanivore,
	/datum/trait/neutral/food_pref/omnivore,
	/datum/trait/neutral/food_pref/piscivore,
	/datum/trait/neutral/food_pref/granivore,
	/datum/trait/neutral/food_pref/cocoavore,
	/datum/trait/neutral/food_pref/glycovore,
	/datum/trait/neutral/food_pref/lactovore,
	/datum/trait/neutral/food_pref/coffee,
	/datum/trait/neutral/food_pref/stimulant
	)
	our_allergens = list(ALLERGEN_FUNGI)

/datum/trait/neutral/food_pref/piscivore
	name = "Food Preference - Piscivore"
	desc = "You prefer to eat fish, and gain extra nutrition for doing so!"
	excludes = list(
	/datum/trait/neutral/food_pref,
	/datum/trait/neutral/food_pref/herbivore,
	/datum/trait/neutral/food_pref/beanivore,
	/datum/trait/neutral/food_pref/omnivore,
	/datum/trait/neutral/food_pref/fungivore,
	/datum/trait/neutral/food_pref/granivore,
	/datum/trait/neutral/food_pref/cocoavore,
	/datum/trait/neutral/food_pref/glycovore,
	/datum/trait/neutral/food_pref/lactovore,
	/datum/trait/neutral/food_pref/coffee,
	/datum/trait/neutral/food_pref/stimulant
	)
	our_allergens = list(ALLERGEN_FISH)

/datum/trait/neutral/food_pref/granivore
	name = "Food Preference - Granivore"
	desc = "You prefer to eat grains and seeds, and gain extra nutrition for doing so!"
	excludes = list(
	/datum/trait/neutral/food_pref,
	/datum/trait/neutral/food_pref/herbivore,
	/datum/trait/neutral/food_pref/beanivore,
	/datum/trait/neutral/food_pref/omnivore,
	/datum/trait/neutral/food_pref/fungivore,
	/datum/trait/neutral/food_pref/piscivore,
	/datum/trait/neutral/food_pref/cocoavore,
	/datum/trait/neutral/food_pref/glycovore,
	/datum/trait/neutral/food_pref/lactovore,
	/datum/trait/neutral/food_pref/coffee,
	/datum/trait/neutral/food_pref/stimulant
	)
	our_allergens = list(ALLERGEN_GRAINS,ALLERGEN_SEEDS)

/datum/trait/neutral/food_pref/cocoavore
	name = "Food Preference - Cocoavore"
	desc = "You prefer to eat chocolate, and gain extra nutrition for doing so!"
	excludes = list(
	/datum/trait/neutral/food_pref,
	/datum/trait/neutral/food_pref/herbivore,
	/datum/trait/neutral/food_pref/beanivore,
	/datum/trait/neutral/food_pref/omnivore,
	/datum/trait/neutral/food_pref/fungivore,
	/datum/trait/neutral/food_pref/piscivore,
	/datum/trait/neutral/food_pref/granivore,
	/datum/trait/neutral/food_pref/glycovore,
	/datum/trait/neutral/food_pref/lactovore,
	/datum/trait/neutral/food_pref/coffee,
	/datum/trait/neutral/food_pref/stimulant
	)
	our_allergens = list(ALLERGEN_CHOCOLATE)

/datum/trait/neutral/food_pref/glycovore
	name = "Food Preference - Glycovore"
	desc = "You prefer to eat sugar, and gain extra nutrition for doing so!"
	excludes = list(
	/datum/trait/neutral/food_pref,
	/datum/trait/neutral/food_pref/herbivore,
	/datum/trait/neutral/food_pref/beanivore,
	/datum/trait/neutral/food_pref/omnivore,
	/datum/trait/neutral/food_pref/fungivore,
	/datum/trait/neutral/food_pref/piscivore,
	/datum/trait/neutral/food_pref/granivore,
	/datum/trait/neutral/food_pref/cocoavore,
	/datum/trait/neutral/food_pref/lactovore,
	/datum/trait/neutral/food_pref/coffee,
	/datum/trait/neutral/food_pref/stimulant
	)
	our_allergens = list(ALLERGEN_SUGARS)

/datum/trait/neutral/food_pref/lactovore
	name = "Food Preference - Lactovore"
	desc = "You prefer to eat and drink things with milk in them, and gain extra nutrition for doing so!"
	excludes = list(
	/datum/trait/neutral/food_pref,
	/datum/trait/neutral/food_pref/herbivore,
	/datum/trait/neutral/food_pref/beanivore,
	/datum/trait/neutral/food_pref/omnivore,
	/datum/trait/neutral/food_pref/fungivore,
	/datum/trait/neutral/food_pref/piscivore,
	/datum/trait/neutral/food_pref/granivore,
	/datum/trait/neutral/food_pref/cocoavore,
	/datum/trait/neutral/food_pref/glycovore,
	/datum/trait/neutral/food_pref/coffee,
	/datum/trait/neutral/food_pref/stimulant
	)
	our_allergens = list(ALLERGEN_DAIRY)

/datum/trait/neutral/food_pref/coffee
	name = "Food Preference - Coffee Dependant"
	desc = "You can get by on coffee alone if you have to, and you like it that way."
	excludes = list(
	/datum/trait/neutral/food_pref,
	/datum/trait/neutral/food_pref/herbivore,
	/datum/trait/neutral/food_pref/beanivore,
	/datum/trait/neutral/food_pref/omnivore,
	/datum/trait/neutral/food_pref/fungivore,
	/datum/trait/neutral/food_pref/piscivore,
	/datum/trait/neutral/food_pref/granivore,
	/datum/trait/neutral/food_pref/cocoavore,
	/datum/trait/neutral/food_pref/glycovore,
	/datum/trait/neutral/food_pref/lactovore,
	/datum/trait/neutral/food_pref/stimulant
	)
	our_allergens = list(ALLERGEN_COFFEE)

/datum/trait/neutral/food_pref/stimulant
	name = "Food Preference - Stimulant Dependant"
	desc = "You can get by on caffine alone if you have to, and you like it that way."
	excludes = list(
	/datum/trait/neutral/food_pref,
	/datum/trait/neutral/food_pref/herbivore,
	/datum/trait/neutral/food_pref/beanivore,
	/datum/trait/neutral/food_pref/omnivore,
	/datum/trait/neutral/food_pref/fungivore,
	/datum/trait/neutral/food_pref/piscivore,
	/datum/trait/neutral/food_pref/granivore,
	/datum/trait/neutral/food_pref/cocoavore,
	/datum/trait/neutral/food_pref/glycovore,
	/datum/trait/neutral/food_pref/lactovore,
	/datum/trait/neutral/food_pref/coffee
	)
	our_allergens = list(ALLERGEN_STIMULANT)


//////////////PHOBIAS/////////////////

/datum/trait/neutral/nyctophobia
	name = "Phobia: Nyctophobia"
	desc = "You are afraid of the dark. When in very dark conditions, you will become afraid."
	cost = 0
	custom_only = FALSE

/datum/trait/neutral/nyctophobia/apply(var/datum/species/S,var/mob/living/carbon/human/H, var/trait_prefs = null)
	..()
	H.phobias |= NYCTOPHOBIA

/datum/trait/neutral/arachnophobia
	name = "Phobia: Arachnophobia"
	desc = "You are afraid of spiders. When you can see a large spider, you will become afraid."
	cost = 0
	custom_only = FALSE

/datum/trait/neutral/arachnophobia/apply(var/datum/species/S,var/mob/living/carbon/human/H, var/trait_prefs = null)
	..()
	H.phobias |= ARACHNOPHOBIA

/datum/trait/neutral/hemophobia
	name = "Phobia: Hemophobia"
	desc = "You are afraid of blood. When you can see large amounts of blood, you will become afraid."
	cost = 0
	custom_only = FALSE

/datum/trait/neutral/hemophobia/apply(var/datum/species/S,var/mob/living/carbon/human/H, var/trait_prefs = null)
	..()
	H.phobias |= HEMOPHOBIA

/datum/trait/neutral/thalassophobia
	name = "Phobia: Thalassophobia"
	desc = "You are afraid of deep water. When in deep water, you will become afraid."
	cost = 0
	custom_only = FALSE

/datum/trait/neutral/thalassophobia/apply(var/datum/species/S,var/mob/living/carbon/human/H, var/trait_prefs = null)
	..()
	H.phobias |= THALASSOPHOBIA

/datum/trait/neutral/clasutrophobia_minor
	name = "Phobia: Claustrophobia (non-vore)"
	desc = "You are afraid of tight, enclosed spaces. When inside of another object, you will become afraid."
	cost = 0
	custom_only = FALSE

/datum/trait/neutral/clasutrophobia_minor/apply(var/datum/species/S,var/mob/living/carbon/human/H, var/trait_prefs = null)
	..()
	H.phobias |= CLAUSTROPHOBIA_MINOR

/datum/trait/neutral/clasutrophobia_major
	name = "Phobia: Claustrophobia (vore)"
	desc = "You are afraid of tight, enclosed spaces. When inside of another object, including vore bellies, you will become afraid."
	cost = 0
	custom_only = FALSE

/datum/trait/neutral/clasutrophobia_major/apply(var/datum/species/S,var/mob/living/carbon/human/H, var/trait_prefs = null)
	..()
	H.phobias |= CLAUSTROPHOBIA_MAJOR

/datum/trait/neutral/anatidaephobia
	name = "Phobia: Anatidaephobia"
	desc = "You are afraid of ducks. When you can see a duck (even rubber ones), you will become afraid."
	cost = 0
	custom_only = FALSE

/datum/trait/neutral/anatidaephobia/apply(var/datum/species/S,var/mob/living/carbon/human/H, var/trait_prefs = null)
	..()
	H.phobias |= ANATIDAEPHOBIA

/datum/trait/neutral/agraviaphobia
	name = "Phobia: Agraviaphobia"
	desc = "You are afraid of a lack of gravity. When you find yourself floating, you will become afraid."
	cost = 0
	custom_only = FALSE

/datum/trait/neutral/agraviaphobia/apply(var/datum/species/S,var/mob/living/carbon/human/H, var/trait_prefs = null)
	..()
	H.phobias |= AGRAVIAPHOBIA

/datum/trait/neutral/gargoyle
	name = "Gargoyle (Adjustable)"
	desc = "You turn into a statue (or similar) at will, but also whenever you run out of energy. Being a statue replenishes your energy slowly."
	cost = 0
	custom_only = FALSE //slimes, xenochimera, diona, proteans, etc, basically anything but custom doesn't make sense (as much as I wanna play a petrifying slime)
	//Nah makes perfect sense, they could just be gene modded, not to mention we can expand this to have the statue and description of it renameable as well as color adjustable, to support general petrification
	has_preferences = list("identifier" = list(TRAIT_PREF_TYPE_STRING, "Identifier", TRAIT_NO_VAREDIT_TARGET, "statue"),
							"material" = list(TRAIT_PREF_TYPE_STRING, "Material", TRAIT_NO_VAREDIT_TARGET, "stone"),
							"tint" = list(TRAIT_PREF_TYPE_COLOR, "Statue color", TRAIT_NO_VAREDIT_TARGET, "#FFFFFF"),
							"adjective" = list(TRAIT_PREF_TYPE_STRING, "Adjective", TRAIT_NO_VAREDIT_TARGET, "hardens")/*,
							"pickupable" = list(TRAIT_PREF_TYPE_BOOLEAN, "Can be picked up", TRAIT_NO_VAREDIT_TARGET, FALSE)*/)

/datum/trait/neutral/gargoyle/apply(var/datum/species/S,var/mob/living/carbon/human/H, var/list/trait_prefs)
	..()
	var/datum/component/gargoyle/G = H.LoadComponent(/datum/component/gargoyle)
	if (trait_prefs)
		G.tint = trait_prefs["tint"]
		G.material = lowertext(trait_prefs["material"])
		G.identifier = lowertext(trait_prefs["identifier"])
		G.adjective = lowertext(trait_prefs["adjective"])

/datum/trait/neutral/gargoyle/apply_sanitization_to_string(var/pref, var/input)
	if (has_preferences[pref][1] != TRAIT_PREF_TYPE_STRING || length(input) <= 0)
		return
	input = sanitizeSafe(input, 25)
	if (length(input) <= 0)
		return default_value_for_pref(pref)
	input = lowertext(input)
	if (pref == "adjective")
		if (copytext_char(input, -1) != "s")
			switch(copytext_char(input, -2))
				if ("ss")
					input += "es"
				if ("sh")
					input += "es"
				if ("ch")
					input += "es"
				else
					switch(copytext_char(input, -1))
						if("s", "x", "z")
							input += "es"
						else
							input += "s"
	return input

/datum/trait/neutral/drippy
	name = "Drippy"
	desc = "You cannot hold your form together, or produce a constant film of sludge that drips off of your body. Hope the station has a janitor."
	cost = 0
	var_changes = list("drippy" = 1)

	// Traitgenes Made into a genetrait
	is_genetrait = TRUE
	hidden = FALSE

	activation_message="You feel softer..."
	primitive_expression_messages=list("drips.")

/datum/trait/neutral/mudking
	name = "Mudking"
	desc = "Somehow you are so filthy that tiles get dirty four times as quick from you walking on them."
	cost = 0
	var_changes = list("mudking" = TRUE)
	custom_only = FALSE

/datum/trait/neutral/patting_defence
	name = "Reflexive Biting"
	desc = "You will reflexively bite hands that attempt to pat your head or boop your nose, this can be toggled off."
	cost = 0
	custom_only = FALSE

/datum/trait/neutral/patting_defence/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	H.touch_reaction_flags |= SPECIES_TRAIT_PATTING_DEFENCE
	add_verb(H, /mob/living/proc/toggle_patting_defence)

/datum/trait/neutral/personal_space
	name = "Personal Space Bubble"
	desc = "You are adept at avoiding unwanted physical contact and dodge it with ease. You will reflexively dodge any attempt to hug, pat, boop, lick, sniff you or even shake your hand, this can be toggled off."
	cost = 0
	custom_only = FALSE

/datum/trait/neutral/patting_defence/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	H.touch_reaction_flags |= SPECIES_TRAIT_PERSONAL_BUBBLE
	add_verb(H, /mob/living/proc/toggle_personal_space)
