/datum/trait/negative
	category = TRAIT_TYPE_NEGATIVE

/datum/trait/negative/speed_slow
	name = "Slowdown"
	desc = "Allows you to move slower on average than baseline."
	cost = -2
	var_changes = list("slowdown" = 0.5)
	banned_species = list(SPECIES_ALRAUNE, SPECIES_SHADEKIN_CREW, SPECIES_DIONA, SPECIES_UNATHI) //These are already this slow.
	custom_only = FALSE

/datum/trait/negative/speed_slow_plus
	name = "Slowdown, Major"
	desc = "Allows you to move MUCH slower on average than baseline."
	cost = -3
	var_changes = list("slowdown" = 1.0)
	custom_only = FALSE
	banned_species = list(SPECIES_DIONA) //Diona are even slower than this

/datum/trait/negative/weakling
	name = "Weakling"
	desc = "Causes heavy equipment to slow you down more when carried."
	cost = -1
	var_changes = list("item_slowdown_mod" = 1.5)
	custom_only = FALSE
	banned_species = list(SPECIES_SHADEKIN_CREW, SPECIES_TESHARI) //These are already this weak.

/datum/trait/negative/weakling_plus
	name = "Weakling, Major"
	desc = "Allows you to carry heavy equipment with much more slowdown."
	cost = -2
	var_changes = list("item_slowdown_mod" = 2.0)
	custom_only = FALSE
	banned_species = list(SPECIES_TESHARI) //These are already this weak.
	//Traitgenes
	is_genetrait = TRUE
	hidden = FALSE

	activation_message="Everything feels so much heavier"
	primitive_expression_messages=list("hunches forwards")

/datum/trait/negative/endurance_low
	name = "Low Endurance"
	desc = "Reduces your maximum total hitpoints to 75."
	cost = -2
	var_changes = list("total_health" = 75)
	custom_only = FALSE
	banned_species = list(SPECIES_TESHARI, SPECIES_SHADEKIN_CREW) //These are already this weak.

/datum/trait/negative/endurance_low/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	H.setMaxHealth(S.total_health)

/datum/trait/negative/endurance_very_low
	name = "Low Endurance, Major"
	desc = "Reduces your maximum total hitpoints to 50."
	cost = -3 //Teshari HP. This makes the person a lot more suseptable to getting stunned, killed, etc.
	var_changes = list("total_health" = 50)
	custom_only = FALSE
	banned_species = list(SPECIES_TESHARI) //These are already this weak.

/datum/trait/negative/endurance_very_low/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	H.setMaxHealth(S.total_health)

/datum/trait/negative/minor_brute_weak
	name = "Brute Weakness, Minor"
	desc = "Increases damage from brute damage sources by 15%"
	cost = -1
	custom_only = FALSE
	var_changes = list("brute_mod" = 1.15)
	banned_species = list(SPECIES_TESHARI, SPECIES_TAJARAN, SPECIES_ZADDAT, SPECIES_SHADEKIN_CREW) //These are already this weak.

/datum/trait/negative/brute_weak
	name = "Brute Weakness"
	desc = "Increases damage from brute damage sources by 25%"
	cost = -2
	custom_only = FALSE
	var_changes = list("brute_mod" = 1.25)
	banned_species = list(SPECIES_TESHARI, SPECIES_SHADEKIN_CREW) //These are already this weak.

/datum/trait/negative/brute_weak_plus
	name = "Brute Weakness, Major"
	desc = "Increases damage from brute damage sources by 50%"
	cost = -3
	custom_only = FALSE
	var_changes = list("brute_mod" = 1.5)

/datum/trait/negative/minor_burn_weak
	name = "Burn Weakness, Minor"
	desc = "Increases damage from burn damage sources by 15%"
	cost = -1
	var_changes = list("burn_mod" = 1.15)

/datum/trait/negative/burn_weak
	name = "Burn Weakness"
	desc = "Increases damage from burn damage sources by 25%"
	cost = -2
	var_changes = list("burn_mod" = 1.25)

/datum/trait/negative/burn_weak_plus
	name = "Burn Weakness, Major"
	desc = "Increases damage from burn damage sources by 50%"
	cost = -3
	var_changes = list("burn_mod" = 1.5)

/datum/trait/negative/conductive
	name = "Conductive"
	desc = "Increases your susceptibility to electric shocks by 50%"
	cost = -1
	var_changes = list("siemens_coefficient" = 1.5) //This makes you a lot weaker to tasers.

/datum/trait/negative/conductive_plus
	name = "Conductive, Major"
	desc = "Increases your susceptibility to electric shocks by 100%"
	cost = -1
	var_changes = list("siemens_coefficient" = 2.0) //This makes you extremely weak to tasers.
	custom_only = FALSE
	varchange_type = TRAIT_VARCHANGE_LESS_BETTER

	//Traitgenes
	is_genetrait = TRUE
	hidden = FALSE

	activation_message="You recieve a sudden shock of static."
	primitive_expression_messages=list("shudders as their hair stands on end")

/datum/trait/negative/haemophilia
	name = "Haemophilia - Organics only"
	desc = "When you bleed, you bleed a LOT."
	cost = -2
	var_changes = list("bloodloss_rate" = 2)
	can_take = ORGANICS
	custom_only = FALSE
	varchange_type = TRAIT_VARCHANGE_LESS_BETTER

/datum/trait/negative/hollow
	name = "Hollow Bones/Aluminum Alloy"
	desc = "Your bones and robot limbs are much easier to break."
	cost = -2 //I feel like this should be higher, but let's see where it goes
	excludes = list(/datum/trait/negative/boneless)

/datum/trait/negative/hollow/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	for(var/obj/item/organ/external/O in H.organs)
		O.min_broken_damage *= 0.5
		O.min_bruised_damage *= 0.5

/datum/trait/negative/lightweight
	name = "Lightweight"
	desc = "Your light weight and poor balance make you very susceptible to unhelpful bumping. Think of it like a bowling ball versus a pin."
	cost = -2
	var_changes = list("lightweight" = 1)
	custom_only = FALSE

	//Traitgenes
	is_genetrait = TRUE
	hidden = FALSE

	activation_message="You feel off balance..."
	primitive_expression_messages=list("staggers")

/datum/trait/negative/neural_hypersensitivity
	name = "Neural Hypersensitivity"
	desc = "Your nerves are particularly sensitive to physical changes, leading to experiencing twice the intensity of pain and pleasure alike. Makes all pain effects twice as strong, and occur at half as much damage."
	cost = -1
	var_changes = list("trauma_mod" = 2)
	can_take = ORGANICS
	custom_only = FALSE

/datum/trait/negative/breathes
	cost = -2
	can_take = ORGANICS

	//Traitgenes
	is_genetrait = TRUE
	hidden = FALSE

	activation_message="You feel like breathing is more difficult..."
	primitive_expression_messages=list("gasps")

/datum/trait/negative/breathes/phoron
	name = "Phoron Breather"
	desc = "You breathe phoron instead of oxygen (which is poisonous to you), much like a Vox."
	var_changes = list("breath_type" = GAS_PHORON, "poison_type" = GAS_O2, "ideal_air_type" = /datum/gas_mixture/belly_air/vox)

/datum/trait/negative/breathes/nitrogen
	name = "Nitrogen Breather"
	desc = "You breathe nitrogen instead of oxygen (which is poisonous to you). Incidentally, phoron isn't poisonous to breathe to you."
	var_changes = list("breath_type" = GAS_N2, "poison_type" = GAS_O2, "ideal_air_type" = /datum/gas_mixture/belly_air/nitrogen_breather)

/datum/trait/negative/breathes/methane
	name = "Methane Breather"
	desc = "You breathe methane instead of oxygen (which is poisonous to you)."
	var_changes = list("breath_type" = GAS_CH4, "poison_type" = GAS_O2, "ideal_air_type" = /datum/gas_mixture/belly_air/methane_breather)

/datum/trait/negative/monolingual
	name = "Monolingual"
	desc = "You are not good at learning languages."
	cost = -1
	var_changes = list("num_alternate_languages" = 0)
	var_changes_pref = list("extra_languages" = -3)
	custom_only = FALSE
	varchange_type = TRAIT_VARCHANGE_MORE_BETTER

/datum/trait/negative/dark_blind
	name = "Nyctalopia"
	desc = "You cannot see in dark at all."
	cost = -1
	var_changes = list("darksight" = 0)
	custom_only = FALSE
	varchange_type = TRAIT_VARCHANGE_MORE_BETTER

	//Traitgenes
	is_genetrait = TRUE
	hidden = FALSE

	activation_message="The dark seems darker than usual."
	primitive_expression_messages=list("looks towards the light")

/datum/trait/negative/bad_shooter
	name = "Bad Shot"
	desc = "You are terrible at aiming."
	cost = -1
	var_changes = list("gun_accuracy_mod" = -35)
	custom_only = FALSE
	varchange_type = TRAIT_VARCHANGE_MORE_BETTER

	//Traitgenes
	is_genetrait = TRUE
	hidden = FALSE

	activation_message="Your hands quiver"
	primitive_expression_messages=list("hands quiver uncontrollably")

/datum/trait/negative/bad_swimmer
	name = "Bad Swimmer"
	desc = "You can't swim very well, all water slows you down a lot and you drown in deep water. You also swim up and down 25% slower."
	cost = -1
	custom_only = FALSE
	var_changes = list("bad_swimmer" = 1, "water_movement" = 4, "swim_mult" = 1.25)
	varchange_type = TRAIT_VARCHANGE_LESS_BETTER
	excludes = list(/datum/trait/positive/good_swimmer)

/datum/trait/negative/less_blood
	name = "Low Blood Volume"
	desc = "You have 33.3% less blood volume compared to most species, making you more prone to blood loss issues."
	cost = -2
	var_changes = list("blood_volume" = 375)
	excludes = list(/datum/trait/negative/less_blood_extreme)
	can_take = ORGANICS

/datum/trait/negative/less_blood_extreme
	name = "Low Blood Volume, Extreme"
	desc = "You have 60% less blood volume compared to most species, making you much more prone to blood loss issues."
	cost = -3
	var_changes = list("blood_volume" = 224)
	excludes = list(/datum/trait/negative/less_blood)
	can_take = ORGANICS

/datum/trait/negative/extreme_slowdown
	name = "Slowdown, Extreme"
	desc = "You move EXTREMELY slower than baseline"
	cost = -8
	var_changes = list("slowdown" = 4.0)

	//Traitgenes
	is_genetrait = TRUE
	hidden = FALSE

	activation_message="You feel like moving is more difficult..."
	primitive_expression_messages=list("moves sluggishly")

/datum/trait/negative/low_blood_sugar
	name = "Low Blood Sugar"
	desc = "If you let your nutrition get too low, you will start to experience adverse affects including hallucinations, unconsciousness, and weakness"
	cost = -1
	special_env = TRUE

	// Traitgenes Made into a gene trait
	is_genetrait = TRUE
	hidden = FALSE

	activation_message="You feel drowsy..."
	primitive_expression_messages=list("looks drowsy")

/datum/trait/negative/low_blood_sugar/handle_environment_special(var/mob/living/carbon/human/H)
	if(H.nutrition > 200 || isbelly(H.loc))
		return
	if((H.nutrition < 200) && prob(5))
		if(H.nutrition > 100)
			to_chat(H,span_warning("You start to feel noticeably weak as your stomach rumbles, begging for more food. Maybe you should eat something to keep your blood sugar up"))
		else if(H.nutrition > 50)
			to_chat(H,span_warning("You begin to feel rather weak, and your stomach rumbles loudly. You feel lightheaded and it's getting harder to think. You really need to eat something."))
		else if(H.nutrition > 25)
			to_chat(H,span_danger("You're feeling very weak and lightheaded, and your stomach continously rumbles at you. You really need to eat something!"))
		else
			to_chat(H,span_critical("You're feeling extremely weak and lightheaded. You feel as though you might pass out any moment and your stomach is screaming for food by now! You should really find something to eat!"))
	if((H.nutrition < 100) && prob(10))
		H.Confuse(10)
	if((H.nutrition < 50) && prob(25))
		H.hallucination = max(30,H.hallucination+8)
	if((H.nutrition < 25) && prob(5))
		H.drowsyness = max(100,H.drowsyness+30)


/datum/trait/negative/blindness
	name = "Permanently blind"
	desc = "You are blind. For whatever reason, nothing is able to change this fact, not even surgery. WARNING: YOU WILL NOT BE ABLE TO SEE ANY POSTS USING THE ME VERB, ONLY SUBTLE AND DIALOGUE ARE VIEWABLE TO YOU, YOU HAVE BEEN WARNED."
	cost = -12
	special_env = TRUE
	custom_only = FALSE

	// Traitgenes Replaces /datum/trait/negative/disability_blind, made into a gene trait
	is_genetrait = TRUE
	hidden = TRUE //Making this so people can't pick it in character select. While a blind character makes senese, not being able to see posts is a massive issue that needs to be addressed some other time.

	sdisability=BLIND
	activation_message="You can't seem to see anything."
	primitive_expression_messages=list("stumbles aimlessly.")

/datum/trait/negative/blindness/handle_environment_special(var/mob/living/carbon/human/H)
	H.sdisabilities |= sdisability 		//no matter what you do, the blindess still comes for you // Traitgenes tweaked to be consistant with other gene traits by using var

/datum/trait/negative/agoraphobia
	name = "Agoraphobia"
	desc = "You very much dislike being in crowded places. When in the company of more than two other people, you start to panic and experience adverse effects."
	cost = -3
	excludes = list(/datum/trait/negative/lonely,/datum/trait/negative/lonely/major)
	added_component_path = /datum/component/crowd_detection/agoraphobia

	//Traitgenes
	is_genetrait = TRUE
	hidden = FALSE

	activation_message="You feel like you need some space"
	primitive_expression_messages=list("keeps their distance from others")

/datum/trait/negative/lonely
	name = "Minor loneliness vulnerability"
	desc = "You're very prone to loneliness! Being alone for extended periods of time causes adverse effects. Most mobs will cure this loneliness as long as they aren't hostile."
	cost = -1
	excludes = list(/datum/trait/negative/lonely/major,/datum/trait/negative/agoraphobia)
	added_component_path = /datum/component/crowd_detection/lonely

/datum/trait/negative/lonely/major
	name = "Major loneliness vulnerability"
	desc = "You're extremely prone to loneliness! Being alone for extended periods of time causes adverse effects. Most mobs won't be enough to cure this loneliness, you need other social beings."
	cost = -3
	excludes = list(/datum/trait/negative/lonely,/datum/trait/negative/agoraphobia)
	added_component_path = /datum/component/crowd_detection/lonely/major

	//Traitgenes
	is_genetrait = TRUE
	hidden = FALSE

	activation_message="You feel like you are in desperate need of company..."
	primitive_expression_messages=list("Looks up at you pleadingly")

/datum/trait/negative/endurance_glass // Glass Cannon
	name = "Glass Endurance"
	desc = "Your body is very fragile. Reduces your maximum hitpoints to 25. Beware sneezes. You require only 50 damage in total to die, compared to 200 normally. You will go into crit after losing 25 HP, compared to crit at 100 HP."
	cost = -12 // Similar to Very Low Endurance, this straight up will require you NEVER getting in a fight. This is extremely crippling. I salute the madlad that takes this.
	var_changes = list("total_health" = 25)

/datum/trait/negative/endurance_glass/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	H.setMaxHealth(S.total_health)

/datum/trait/negative/reduced_biocompat_minor
	name = "Reduced Biocompatibility, Minor"
	desc = "For whatever reason, you're one of the unlucky few who don't get as much benefit from modern-day chemicals. Remember to note this down in your medical records! Chems are only 80% as effective on you!"
	cost = -1
	var_changes = list("chem_strength_heal" = 0.8)
	can_take = ORGANICS

/datum/trait/negative/reduced_biocompat
	name = "Reduced Biocompatibility"
	desc = "For whatever reason, you're one of the unlucky few who don't get as much benefit from modern-day chemicals. Remember to note this down in your medical records! Chems are only 60% as effective on you!"
	cost = -2
	var_changes = list("chem_strength_heal" = 0.6)
	can_take = ORGANICS

/datum/trait/negative/reduced_biocompat_extreme
	name = "Reduced Biocompatibility, Major"
	desc = "For whatever reason, you're one of the unlucky few who don't get as much benefit from modern-day chemicals. Remember to note this down in your medical records! Chems are only 30% as effective on you!"
	cost = -4
	var_changes = list("chem_strength_heal" = 0.3)
	can_take = ORGANICS

	//Traitgenes
	is_genetrait = TRUE
	hidden = FALSE

	activation_message="You feel no different"
	primitive_expression_messages=list("blinks")

// Rykkanote: Relocated these here as we're no longer a YW downstream.
/datum/trait/negative/light_sensitivity
	name = "Photosensitivity"
	desc = "You have trouble dealing with sudden flashes of light, taking some time for you to recover. The effects of flashes from cameras and security equipment leaves you stunned for some time. 50% increased stun duration from flashes."
	cost = -1
	var_changes = list("flash_mod" = 1.5)

/datum/trait/negative/light_sensitivity_plus
	name = "Photosensitivity, Major"
	desc = "You have trouble dealing with sudden flashes of light, taking quite a long time for you to be able to recover. The effects of flashes from cameras and security equipment leave you stunned for some time. 100% (2x) stun duration from flashes."
	cost = -2
	var_changes = list("flash_mod" = 2.0)

	//Traitgenes
	is_genetrait = TRUE
	hidden = FALSE

	activation_message="Lights feel painful to look at..."
	primitive_expression_messages=list("holds a hand up to their eyes")

/datum/trait/negative/haemophilia_plus
	name = "Haemophilia, Major"
	desc = "Some say that when it rains, it pours.  Unfortunately, this is also true for yourself if you get cut. You bleed much faster than average, at 3x the normal rate."
	cost = -3
	can_take = ORGANICS

	activation_message="You feel "
	primitive_expression_messages=list("bumps their toe, screaming in pain")

/datum/trait/negative/haemophilia_plus/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	H.add_modifier(/datum/modifier/trait/haemophilia)

/datum/trait/negative/haemophilia_plus/unapply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	H.remove_modifiers_of_type(/datum/modifier/trait/haemophilia)

/datum/trait/negative/pain_intolerance_basic
	name = "Pain Intolerance"
	desc = "You are frail and sensitive to pain. You experience 25% more pain from all sources."
	cost = -2
	var_changes = list("pain_mod" = 1.2)

/datum/trait/negative/pain_intolerance_advanced
	name = "Pain Intolerance, Major"
	desc = "You are highly sensitive to all sources of pain, and experience 50% more pain."
	cost = -3
	var_changes = list("pain_mod" = 1.5) //this makes you extremely vulnerable to most sources of pain, a stunbaton bop or shotgun beanbag will do around 90 agony, almost enough to drop you in one hit.

	//Traitgenes
	is_genetrait = TRUE
	hidden = FALSE

	activation_message="You feel as though the airflow around you is painful..."
	primitive_expression_messages=list("bumps their toe, screaming in pain")

/datum/trait/negative/sensitive_biochem
	name = "Sensitive Biochemistry, Minor"
	desc = "Your biochemistry is a little delicate, rendering you more susceptible to the negative effects of some chemicals. You'll probably want to list this in your medical records, and perhaps in your exploitable info as well. Chemical toxin damage and negative drug effects are 25% stronger on you. Additionally, knockout drugs work 25% faster on you."
	cost = -1
	var_changes = list("chem_strength_tox" = 1.25)

	//Traitgenes
	can_take = ORGANICS
	is_genetrait = FALSE
	hidden = FALSE

/datum/trait/negative/sensitive_biochem/moderate
	name = "Sensitive Biochemistry, Moderate"
	desc = "Your biochemistry is a quite delicate, rendering you more susceptible to the negative effects of some chemicals. You'll probably want to list this in your medical records, and perhaps in your exploitable info as well. Chemical toxin damage and negative drug effects are 50% stronger on you. Additionally, knockout drugs work 50% faster on you."
	cost = -2
	var_changes = list("chem_strength_tox" = 1.5)

	//Traitgenes
	can_take = ORGANICS
	is_genetrait = FALSE

/datum/trait/negative/sensitive_biochem/major
	name = "Sensitive Biochemistry, Major"
	desc = "Your biochemistry is a much more delicate, rendering you more susceptible to the negative effects of some chemicals. You'll probably want to list this in your medical records, and perhaps in your exploitable info as well. Chemical toxin damage and negative drug effects are 100% stronger on you. Additionally, knockout drugs work 100% faster on you."
	cost = -3
	var_changes = list("chem_strength_tox" = 2)

	//Traitgenes
	can_take = ORGANICS
	is_genetrait = TRUE

/datum/trait/negative/slipperydirt
	name = "Dirt Vulnerability"
	desc = "Even the tiniest particles of dirt give you uneasy footing, even through several layers of footwear."
	cost = -5
	var_changes = list("dirtslip" = TRUE)

/datum/trait/negative/thick_digits
	name = "Thick Digits"
	desc = "Your hands are not shaped in a way that allows useage of guns."
	cost = -4
	custom_only = FALSE

/datum/trait/negative/thick_digits/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	H.add_modifier(/datum/modifier/trait/thickdigits)

/datum/trait/negative/nodefib
	name = "Unreviveable"
	desc = "For whatever strange genetic reason, defibs cannot restart your heart."
	cost = -1
	custom_only = FALSE
	var_changes = list("flags" = NO_DEFIB)
	can_take = ORGANICS
	excludes = list(/datum/trait/negative/noresleeve, /datum/trait/negative/onelife)

/datum/trait/negative/noresleeve
	name = "Unsleeveable"
	desc = "Your genetics have been ruined, to the point where resleeving can no longer bring you back. Your DNA is unappealing to slimes as a result." //The autoresleever still resleeves on Virgo as that section has been commented out, but eh, whatever. It's not really a big concern. -1+-1 = -2 is all I care about.
	cost = -1
	custom_only = TRUE
	var_changes = list("flags" = NO_SLEEVE)
	excludes = list(/datum/trait/negative/nodefib, /datum/trait/negative/onelife)

/datum/trait/negative/onelife
	name = "One Life"
	desc = "Once you are dead, you are incapable of being resleeved or revived using a defib."
	cost = -2
	custom_only = TRUE
	var_changes = list("flags" = NO_SLEEVE | NO_DEFIB)
	excludes = list(/datum/trait/negative/nodefib, /datum/trait/negative/noresleeve)

// Why put this on Xenochimera of all species? I have no idea, but someone may be enough of a lunatic to take it.
/datum/trait/negative/neural_hypersensitivity/xenochimera
	sort = TRAIT_SORT_SPECIES
	allowed_species = list(SPECIES_XENOCHIMERA)
	name = "Xenochimera: Neural Hypersensitivity"
	desc = "Despite your evolutionary efforts, you are unusually sensitive to pain. \
	Given your species' typical reactions to pain, this can only end well for you!"
	cost = 0
	category = 0
	custom_only = FALSE

/datum/trait/negative/photodegeneration
	name = "Photodegeneration"
	desc = "Without the protection of darkness or a suit your body quickly begins to break down when exposed to light."
	cost = -4
	is_genetrait = TRUE // There is no upside, a neat landmine for genetics
	hidden = TRUE //Disabled on Virgo
	can_take = ORGANICS
	added_component_path = /datum/component/burninlight // Literally just Zaddat, but you don't start with any suit. Good luck.

// Addictions
/datum/trait/neutral/addiction_alcohol
	name = "Addiction - Alcohol"
	desc = "You have become chemically dependant to any alcoholic drink, and need to regularly consume it or suffer withdrawals."
	addiction = REAGENT_ID_ETHANOL
	custom_only = FALSE
	hidden = TRUE //Disabled on Virgo

/datum/trait/neutral/addiction_bliss
	name = "Addiction - " + REAGENT_BLISS
	desc = "You have become chemically dependant to " + REAGENT_BLISS + ", and need to regularly consume it or suffer withdrawals."
	addiction = REAGENT_ID_BLISS
	custom_only = FALSE
	hidden = TRUE //Disabled on Virgo

/datum/trait/neutral/addiction_coffee
	name = "Addiction - " + REAGENT_COFFEE
	desc = "You have become chemically dependant to " + REAGENT_COFFEE + ", and need to regularly consume it or suffer withdrawals."
	addiction = REAGENT_ID_COFFEE
	custom_only = FALSE

/datum/trait/neutral/addiction_hyper
	name = "Addiction - " + REAGENT_HYPERZINE
	desc = "You have become chemically dependant to " + REAGENT_HYPERZINE + ", and need to regularly consume it or suffer withdrawals."
	addiction = REAGENT_ID_HYPERZINE
	custom_only = FALSE
	hidden = TRUE //Disabled on Virgo

/datum/trait/neutral/addiction_nicotine
	name = "Addiction - " + REAGENT_NICOTINE
	desc = "You have become chemically dependant to " + REAGENT_NICOTINE + ", and need to regularly consume it or suffer withdrawals."
	addiction = REAGENT_ID_NICOTINE
	custom_only = FALSE

/datum/trait/neutral/addiction_oxy
	name = "Addiction - " + REAGENT_OXYCODONE
	desc = "You have become chemically dependant to " + REAGENT_OXYCODONE + ", and need to regularly consume it or suffer withdrawals."
	addiction = REAGENT_ID_OXYCODONE
	custom_only = FALSE
	hidden = TRUE //Disabled on Virgo

/datum/trait/neutral/addiction_painkiller
	name = "Addiction - Pain Killers"
	desc = "You have become chemically dependant to " + REAGENT_TRAMADOL + ", and need to regularly consume it or suffer withdrawals."
	addiction = REAGENT_ID_TRAMADOL
	custom_only = FALSE
	hidden = TRUE //Disabled on Virgo

/datum/trait/neutral/addiction_asustenance
	name = "Unstable Vat Grown Body"
	desc = "You are chemically dependant to " + REAGENT_ASUSTENANCE + ", and need to regularly consume it or your body decays."
	addiction = REAGENT_ID_ASUSTENANCE
	custom_only = FALSE
	hidden = TRUE //Disabled on Virgo

/datum/trait/negative/unlucky
	name = "Unlucky"
	desc = "You are naturally unlucky and ill-events often befall you."
	cost = -2
	is_genetrait = FALSE
	hidden = FALSE
	custom_only = FALSE
	added_component_path = /datum/component/omen/trait
	excludes = list(/datum/trait/negative/unlucky/major)


/datum/trait/negative/unlucky/major
	name = "Unlucky, Major"
	desc = "Your luck is extremely awful and potentially fatal."
	cost = -5
	tutorial = "You should avoid disposal bins."
	is_genetrait = TRUE
	hidden = TRUE //VOREStation Note: Disabled
	added_component_path = /datum/component/omen/trait/major
	excludes = list(/datum/trait/negative/unlucky)
	activation_message= span_cult(span_bold("What a terrible night to have a curse!"))
	primitive_expression_messages=list("unluckily stubs their toe!")

/datum/trait/negative/heavy_landing
	name = "Heavy Landing"
	desc = "Your heavy frame causes you to crash heavily when falling from heights. The bigger they are, the harder they fall!"
	cost = -1
	var_changes = list("soft_landing" = FALSE) //override soft landing if the species would otherwise start with it
	custom_only = FALSE
	excludes = list(/datum/trait/positive/soft_landing)

/datum/trait/negative/heavy_landing/apply(datum/species/S, mob/living/carbon/human/H, trait_prefs)
	..()
	ADD_TRAIT(H, TRAIT_HEAVY_LANDING, ROUNDSTART_TRAIT)

/*
 * So, I know what you're thinking.
 * "Why is this a negative trait? It sounds like a positive one!"
 * In theory, yes. Being unable to have your limbs break DOES sound like a good thing!
 * However, that is where limb code comes into play.
 * Normally, with highly damaged limbs, you have a RNG(X)% chance for it to be sliced off if it takes a lot of damage and the damage from the blow is over a certain threshold.
 * Additionally, limbs have a 'maximum damage' it can reach in which it can't reach anymore. Your arm, for example, is 80 damage maximum. Head 75.
 * Trying to hit it more won't do any more damage, just constantly roll chances (if the hitting blow is strong enough) to cut it off/gib it.
 * With this trait, however, as soon as you reach that maximum damage, your limb IMMEDIATELY gibs. No RNG chance rolls. 'attack must be X strong to hit it off'. Nothing.
 * Additionally, normal limbloss code has one-shot protection and prevents bullets from gibbing limbs. This makes you forfeit that protection.
 */
/datum/trait/negative/boneless
	name = "Boneless"
	desc = "You have no bones! Though your limbs will gib once reaching their maximum limit in exchange."
	cost = -3
	custom_only = TRUE
	can_take = ORGANICS
	is_genetrait = FALSE //genetically removes your bones? nah.
	hidden = FALSE
	///How much our limbs max_damage is multiplied by.
	var/limb_health = 1
	excludes = list(/datum/trait/negative/hollow)

/datum/trait/negative/boneless/major
	name = "Boneless, Major"
	desc = "You have no bones! Your limbs are also much, much easier to gib in exchange. (Seriously this can result in one shot deaths and similar)"
	cost = -6 //For reference, getting hit in the head with a welder 3 times kills you. Head has 37.5 HP. Reaching that cap = instant death
	limb_health = 0.5

/datum/trait/negative/boneless/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	for(var/obj/item/organ/external/ex_organ in H.organs)
		ex_organ.cannot_break = TRUE
		ex_organ.dislocated = -1
		ex_organ.nonsolid = TRUE //ESSENTIAL for boneless. Otherwise it acts like a normal limb.
		ex_organ.spread_dam = TRUE
		ex_organ.max_damage = floor(ex_organ.max_damage * limb_health)

		if(istype(ex_organ, /obj/item/organ/external/head))
			ex_organ.encased = FALSE //you can just reach in and grab it
			ex_organ.cannot_gib = FALSE

		else if(istype(ex_organ, /obj/item/organ/external/chest))
			ex_organ.encased = FALSE
