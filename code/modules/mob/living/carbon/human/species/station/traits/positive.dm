/datum/trait/positive
	category = TRAIT_TYPE_POSITIVE

/datum/trait/positive/speed_fast
	name = "Haste"
	desc = "Allows you to move faster on average than baseline."
	cost = 4
	var_changes = list("slowdown" = -0.5)
//	banned_species = list(SPECIES_ALRAUNE, SPECIES_SHADEKIN_CREW, SPECIES_TESHARI, SPECIES_TAJARAN, SPECIES_DIONA, SPECIES_UNATHI) //Either not applicable or buffs ruin species flavour/balance
//	custom_only = FALSE //Keeping these in comments in case we decide to open them up in future, so the species are already organised.

	// Traitgenes Replaces /datum/trait/positive/superpower_increaserun, made into a genetrait
	is_genetrait = TRUE
	hidden = FALSE

	activation_message="Your leg muscles pulsate."
	primitive_expression_messages=list("dances around.")
	excludes = list(/datum/trait/positive/unusual_running) // you best not be naruto running in this house

/datum/trait/positive/unusual_running
	name = "Unusual Gait"
	desc = "Your method of running is unorthodox, you move faster when not holding things in your hands."
	cost = 2

	custom_only = FALSE //I think this is probably fine since it's half RP trait and half mechanical trait. also you can't have speed and use your hands so this is kinda niche outside of travel time reduction.
	banned_species = list(SPECIES_ALRAUNE, SPECIES_SHADEKIN_CREW, SPECIES_TESHARI, SPECIES_TAJARAN, SPECIES_DIONA, SPECIES_UNATHI, SPECIES_VASILISSAN, SPECIES_XENOCHIMERA, SPECIES_VOX) //i assume if a dev made your base slowdown different then you shouldn't have this.
	excludes = list(/datum/trait/positive/speed_fast) // olympic sprinters don't naruto run

/datum/trait/positive/unusual_running/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	ADD_TRAIT(H, UNUSUAL_RUNNING, ROUNDSTART_TRAIT)

/datum/trait/positive/punchdamage
	name = "Strong Attacks"
	desc = "Your unarmed attacks deal more damage. (+5 per attack)"
	cost = 1
	custom_only = FALSE
	hidden = TRUE //Disabled on Virgo.
	var_changes = list("unarmed_bonus" = 5)
	excludes = list(/datum/trait/positive/punchdamageplus)
	banned_species = list(SPECIES_TESHARI)

/datum/trait/positive/punchdamageplus
	name = "Crushing Attacks"
	desc = "Your unarmed attacks deal high damage. (+10 per attack)"
	cost = 2
	custom_only = FALSE
	hidden = TRUE //Disabled on Virgo.
	var_changes = list("unarmed_bonus" = 10)
	excludes = list(/datum/trait/positive/punchdamage)
	banned_species = list(SPECIES_TESHARI, SPECIES_VOX)

/datum/trait/positive/shredding_attacks //Variant of plus
	name = "Shredding Attacks"
	desc = "Your unarmed attacks can break windows, APCs, deal massive damage to synthetics, and you can break out of restraints 24 times faster."
	cost = 6
	custom_only = FALSE
	hidden = TRUE
	var_changes = list("shredding" = TRUE)
	banned_species = list(SPECIES_TESHARI, SPECIES_VOX)

/datum/trait/positive/strength //combine effects of hardy + strong punches, for if someone wants a generally "strong" character. Exists for the purposes of the trait limit
	name = "High Strength"
	desc = "Your unarmed attacks deal more damage (+5), and you can carry heavy equipment with 50% less slowdown."
	cost = 2
	custom_only = FALSE
	hidden = TRUE //Disabled on Virgo.
	var_changes = list("unarmed_bonus" = 5, "item_slowdown_mod" = 0.5)
	excludes = list(/datum/trait/positive/punchdamage, /datum/trait/positive/hardy, /datum/trait/positive/hardy_plus)
	banned_species = list(SPECIES_ALRAUNE, SPECIES_TESHARI, SPECIES_UNATHI, SPECIES_DIONA, SPECIES_PROMETHEAN, SPECIES_PROTEAN)

/datum/trait/positive/strengthplus //see above comment
	name = "Inhuman Strength"
	desc = "You are unreasonably strong. Your unarmed attacks do high damage (+10), you experience much less slowdown from heavy equipment (75% less)."
	cost = 4
	custom_only = FALSE
	hidden = TRUE //Disabled on Virgo.
	var_changes = list("unarmed_bonus" = 10, "item_slowdown_mod" = 0.25)
	excludes = list(/datum/trait/positive/punchdamage, /datum/trait/positive/hardy, /datum/trait/positive/punchdamageplus, /datum/trait/positive/hardy_plus)
	banned_species = list(SPECIES_ALRAUNE, SPECIES_TESHARI, SPECIES_UNATHI, SPECIES_DIONA, SPECIES_PROMETHEAN, SPECIES_PROTEAN, SPECIES_VOX)

/datum/trait/positive/hardy
	name = "Hardy"
	desc = "Allows you to carry heavy equipment with less slowdown."
	cost = 1
	var_changes = list("item_slowdown_mod" = 0.5)
	custom_only = FALSE
	banned_species = list(SPECIES_ALRAUNE, SPECIES_TESHARI, SPECIES_UNATHI, SPECIES_DIONA, SPECIES_PROMETHEAN, SPECIES_PROTEAN) //Either not applicable or buffs are too strong

/datum/trait/positive/hardy_plus
	name = "Hardy, Major"
	desc = "Allows you to carry heavy equipment with almost no slowdown."
	cost = 2
	var_changes = list("item_slowdown_mod" = 0.25)
	banned_species = list(SPECIES_ALRAUNE, SPECIES_TESHARI, SPECIES_UNATHI, SPECIES_DIONA, SPECIES_PROMETHEAN, SPECIES_PROTEAN) //Either not applicable or buffs are too strong
	custom_only = FALSE

/datum/trait/positive/endurance_high
	name = "High Endurance"
	desc = "Increases your maximum total hitpoints to 125. You require 250 damage in total to die, compared to 200 normally. You will still go into crit after losing 125 HP, compared to crit at 100 HP."
	cost = 3
	var_changes = list("total_health" = 125)
	custom_only = FALSE
	excludes = list(/datum/trait/positive/endurance_very_high, /datum/trait/positive/endurance_extremely_high)
	banned_species = list(SPECIES_TESHARI, SPECIES_UNATHI, SPECIES_SHADEKIN_CREW) //Either not applicable or buffs are too strong

/datum/trait/positive/endurance_high/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	H.setMaxHealth(S.total_health)

/datum/trait/positive/nonconductive
	name = "Non-Conductive"
	desc = "Decreases your susceptibility to electric shocks by 25%."
	cost = 2
	var_changes = list("siemens_coefficient" = 0.75)

/datum/trait/positive/nonconductive_plus
	name = "Non-Conductive, Major"
	desc = "Decreases your susceptibility to electric shocks by 50%."
	cost = 3
	var_changes = list("siemens_coefficient" = 0.5)

/datum/trait/positive/darksight
	name = "Darksight"
	desc = "Allows you to see significantly further in the dark and be 10% more susceptible to flashes."
	cost = 1
	var_changes = list("darksight" = 5, "flash_mod" = 1.1)
	custom_only = FALSE
	banned_species = list(SPECIES_TAJARAN, SPECIES_SHADEKIN_CREW, SPECIES_SHADEKIN, SPECIES_XENOHYBRID, SPECIES_VULPKANIN, SPECIES_XENO, SPECIES_XENOCHIMERA, SPECIES_VASILISSAN, SPECIES_WEREBEAST) //These species already have strong darksight by default.
	excludes = list(/datum/trait/positive/darksight_plus)

/datum/trait/positive/darksight_plus
	name = "Darksight, Major"
	desc = "Allows you to see in the dark for the whole screen and be 20% more susceptible to flashes."
	cost = 2
	var_changes = list("darksight" = 8, "flash_mod" = 1.2)
	custom_only = FALSE
	banned_species = list(SPECIES_TAJARAN, SPECIES_SHADEKIN_CREW, SPECIES_SHADEKIN, SPECIES_XENOHYBRID, SPECIES_VULPKANIN, SPECIES_XENO, SPECIES_XENOCHIMERA, SPECIES_VASILISSAN, SPECIES_WEREBEAST) //These species already have strong darksight by default.
	excludes = list(/datum/trait/positive/darksight)

/datum/trait/positive/melee_attack
	name = "Special Attack: Sharp Melee" // Trait Organization for easier browsing. TODO: Proper categorization of 'health/ability/resist/etc'
	desc = "Provides sharp melee attacks which can inflict bleeding."
	cost = 1
	var_changes = list("unarmed_types" = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/claws, /datum/unarmed_attack/bite/sharp))

/datum/trait/positive/melee_attack_fangs
	name = "Special Attack: Sharp Melee & Numbing Fangs" // Trait Organization for easier browsing. TODO: Proper categorization of 'health/ability/resist/etc'
	desc = "Provides sharp melee attacks which can inflict bleeding, along with fangs that makes the person bit unable to feel their body or pain."
	cost = 2
	var_changes = list("unarmed_types" = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/claws, /datum/unarmed_attack/bite/sharp, /datum/unarmed_attack/bite/sharp/numbing))

/datum/trait/positive/fangs
	name = "Special Attack: Numbing Fangs" // Trait Organization for easier browsing. TODO: Proper categorization of 'health/ability/resist/etc'
	desc = "Provides fangs that makes the person bit unable to feel their body or pain."
	cost = 1
	var_changes = list("unarmed_types" = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/punch, /datum/unarmed_attack/bite/sharp/numbing))

/datum/trait/positive/minor_brute_resist
	name = "Brute Resist, Minor"
	desc = "Adds 15% resistance to brute damage sources."
	cost = 2
	var_changes = list("brute_mod" = 0.85)
	custom_only = FALSE
	banned_species = list(SPECIES_TESHARI, SPECIES_UNATHI, SPECIES_XENOCHIMERA, SPECIES_VASILISSAN, SPECIES_WEREBEAST) //Most of these are already this resistant or stronger, or it'd be way too much of a boost for tesh.
	excludes = list(/datum/trait/positive/brute_resist, /datum/trait/positive/brute_resist_plus)

/datum/trait/positive/brute_resist
	name = "Brute Resist"
	desc = "Adds 25% resistance to brute damage sources."
	cost = 3
	var_changes = list("brute_mod" = 0.75)
	excludes = list(/datum/trait/positive/minor_brute_resist, /datum/trait/positive/brute_resist_plus)

/datum/trait/positive/minor_burn_resist
	name = "Burn Resist, Minor"
	desc = "Adds 15% resistance to burn damage sources."
	cost = 2
	var_changes = list("burn_mod" = 0.85)
	excludes = list(/datum/trait/positive/burn_resist, /datum/trait/positive/burn_resist_plus)

/datum/trait/positive/burn_resist
	name = "Burn Resist"
	desc = "Adds 25% resistance to burn damage sources."
	cost = 3
	var_changes = list("burn_mod" = 0.75)
	excludes = list(/datum/trait/positive/minor_burn_resist, /datum/trait/positive/burn_resist_plus)

/datum/trait/positive/photoresistant
	name = "Photoresistant"
	desc = "Decreases stun duration from flashes and other light-based stuns and disabilities by 20%"
	cost = 1
	var_changes = list("flash_mod" = 0.8)

/datum/trait/positive/winged_flight
	name = "Winged Flight"
	desc = "Allows you to fly by using your wings. Don't forget to bring them!"
	cost = 0
	custom_only = FALSE
	has_preferences = list("flight_vore" = list(TRAIT_PREF_TYPE_BOOLEAN, "Flight Vore enabled on spawn", TRAIT_VAREDIT_TARGET_MOB, FALSE))

/datum/trait/positive/winged_flight/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	add_verb(H, /mob/living/proc/flying_toggle)
	add_verb(H, /mob/living/proc/flying_vore_toggle)
	add_verb(H, /mob/living/proc/start_wings_hovering)

/datum/trait/positive/soft_landing
	name = "Soft Landing"
	desc = "You can fall from certain heights without suffering any injuries, be it via wings, lightness of frame or general dexterity."
	cost = 1
	var_changes = list("soft_landing" = TRUE)
	custom_only = FALSE
	excludes = list(/datum/trait/negative/heavy_landing)

/datum/trait/positive/antiseptic_saliva
	name = "Antiseptic Saliva"
	desc = "Your saliva has especially strong antiseptic properties that can be used to heal small wounds."
	cost = 1

/datum/trait/positive/antiseptic_saliva/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	add_verb(H, /mob/living/carbon/human/proc/lick_wounds)

/datum/trait/positive/traceur
	name = "Traceur"
	desc = "You're capable of parkour and can *flip over low objects (most of the time)."
	cost = 2
	var_changes = list("agility" = 90)
	custom_only = FALSE
	varchange_type = TRAIT_VARCHANGE_MORE_BETTER

/datum/trait/positive/snowwalker
	name = "Snow Walker"
	desc = "You are able to move unhindered on snow."
	cost = 1
	var_changes = list("snow_movement" = -2)

/datum/trait/positive/weaver
	name = "Weaver"
	desc = "You can produce silk and create various articles of clothing and objects."
	cost = 2
	allowed_species = list(SPECIES_HANNER, SPECIES_CUSTOM) //So it only shows up for custom species and hanner
	custom_only = FALSE
	has_preferences = list("silk_production" = list(TRAIT_PREF_TYPE_BOOLEAN, "Silk production on spawn", TRAIT_NO_VAREDIT_TARGET), \
							"silk_color" = list(TRAIT_PREF_TYPE_COLOR, "Silk color", TRAIT_NO_VAREDIT_TARGET))
	added_component_path = /datum/component/weaver
	excludes = list(/datum/trait/positive/cocoon_tf)

/datum/trait/positive/weaver/apply(var/datum/species/S,var/mob/living/carbon/human/H, var/list/trait_prefs)
	..()
	var/datum/component/weaver/W = H.GetComponent(added_component_path)
	if(S.get_bodytype() == SPECIES_VASILISSAN)
		W.silk_reserve = 500
		W.silk_max_reserve = 1000
	if(trait_prefs)
		W.silk_production = trait_prefs["silk_production"]
		W.silk_color = lowertext(trait_prefs["silk_color"])

/datum/trait/positive/aquatic
	name = "Aquatic"
	desc = "You can breathe under water and can traverse water more efficiently. Additionally, you can eat others in the water."
	cost = 1
	custom_only = FALSE
	var_changes = list("water_breather" = 1, "water_movement" = -4) //Negate shallow water. Half the speed in deep water.
	allowed_species = list(SPECIES_HANNER, SPECIES_CUSTOM, SPECIES_REPLICANT_CREW) //So it only shows up for custom species, hanner, and Gamma replicants
	custom_only = FALSE
	excludes = list(/datum/trait/positive/good_swimmer, /datum/trait/negative/bad_swimmer, /datum/trait/positive/aquatic/plus)

/datum/trait/positive/aquatic/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	add_verb(H, /mob/living/carbon/human/proc/water_stealth)
	add_verb(H, /mob/living/carbon/human/proc/underwater_devour)

/datum/trait/positive/aquatic/plus
	name = "Aquatic 2"
	desc = "You can breathe under water and can traverse water more efficiently than most aquatic humanoids. Additionally, you can eat others in the water."
	cost = 2
	custom_only = FALSE
	var_changes = list("water_breather" = 1, "water_movement" = -4, "swim_mult" = 0.5) //Negate shallow water. Half the speed in deep water.
	allowed_species = list(SPECIES_HANNER, SPECIES_CUSTOM, SPECIES_REPLICANT_CREW) //So it only shows up for custom species, hanner, and Gamma replicants
	custom_only = FALSE
	excludes = list(/datum/trait/positive/good_swimmer, /datum/trait/negative/bad_swimmer, /datum/trait/positive/aquatic)

/datum/trait/positive/cocoon_tf
	name = "Cocoon Spinner"
	desc = "Allows you to build a cocoon around yourself, using it to transform your body if you desire."
	cost = 1
	allowed_species = list(SPECIES_HANNER, SPECIES_CUSTOM) //So it only shows up for custom species and hanner
	custom_only = FALSE
	excludes = list(/datum/trait/positive/weaver)

/datum/trait/positive/cocoon_tf/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	add_verb(H, /mob/living/carbon/human/proc/enter_cocoon)

/datum/trait/positive/linguist
	name = "Linguist"
	desc = "Allows you to have more languages."
	cost = 1
	var_changes = list("num_alternate_languages" = 6)
	var_changes_pref = list("extra_languages" = 3)
	custom_only = FALSE
	varchange_type = TRAIT_VARCHANGE_MORE_BETTER

/datum/trait/positive/good_shooter
	name = "Eagle Eye"
	desc = "You are better at aiming than most."
	cost = 2
	var_changes = list("gun_accuracy_mod" = 25)
	custom_only = FALSE
	varchange_type = TRAIT_VARCHANGE_MORE_BETTER

/datum/trait/positive/trauma_tolerance
	name = "Grit"
	desc = "You can keep going a little longer, a little harder when you get hurt, Injuries only inflict 85% as much pain, and slowdown from pain is 85% as effective."
	cost = 2
	var_changes = list("trauma_mod" = 0.85)
	excludes = list(/datum/trait/negative/neural_hypersensitivity)
	can_take = ORGANICS
	custom_only = FALSE

/datum/trait/positive/throw_resistance
	name = "Firm Body"
	desc = "Your body is firm enough that small thrown items can't do anything to you."
	cost = 1
	var_changes = list("throwforce_absorb_threshold" = 10)

/datum/trait/positive/wall_climber
	name = "Climber, Amateur"
	desc = "You can climb certain walls without tools! This is likely a personal skill you developed. You can also climb lattices and ladders a little bit faster than everyone else."
	tutorial = "You must approach a wall and right click it and select the \
	'climb wall' verb to climb it. You suffer from a movement delay of 1.5 with this trait.\n \
	Your total climb time is expected to be 17.5 seconds. Tools may reduce this. \n\n \
	This likewise allows descending walls, provided you're facing an empty space and standing on \
	a climbable wall. To climbe like so, use the verb 'Climb Down Wall' in IC tab!"
	cost = 1
	custom_only = FALSE
	banned_species = list(SPECIES_TAJARAN, SPECIES_VASILISSAN)	// They got unique climbing delay.
	var_changes = list("can_climb" = TRUE, "climb_mult" = 0.75)
	excludes = list(/datum/trait/positive/wall_climber_pro, /datum/trait/positive/wall_climber_natural)

/datum/trait/positive/wall_climber_natural
	name = "Climber, Natural"
	desc = "You can climb certain walls without tools! This is likely due to the unique anatomy of your species. You can climb lattices and ladders slightly faster than everyone else. CUSTOM AND XENOCHIM ONLY"
	tutorial = "You must approach a wall and right click it and select the \
	'climb wall' verb to climb it. You suffer from a movement delay of 1.5 with this trait.\n \
	Your total climb time is expected to be 17.5 seconds. Tools may reduce this. \n\n \
	This likewise allows descending walls, provided you're facing an empty space and standing on \
	a climbable wall. To climbe like so, use the verb 'Climb Down Wall' in IC tab!"
	cost = 0
	custom_only = FALSE
	var_changes = list("can_climb" = TRUE, "climb_mult" = 0.75)
	allowed_species = list(SPECIES_XENOCHIMERA, SPECIES_CUSTOM)	//So that we avoid needless bloat for xenochim
	excludes = list(/datum/trait/positive/wall_climber_pro, /datum/trait/positive/wall_climber)

/datum/trait/positive/wall_climber_pro
	name = "Climber, Professional"
	desc = "You can climb certain walls without tools! You are a professional rock climber at this, letting you climb almost twice as fast! You can also climb lattices and ladders a fair bit faster than everyone else!"
	tutorial = "You must approach a wall and right click it and select the \
	'climb wall' verb to climb it. Your movement delay is just 1.25 with this trait.\n \
	Your climb time is expected to be 9 seconds. Tools may reduce this. \n\n \
	This likewise allows descending walls, provided you're facing an empty space and standing on \
	a climbable wall. To climbe like so, use the verb 'Climb Down Wall' in IC tab!"
	cost = 2
	custom_only = FALSE
	var_changes = list("climbing_delay" = 1.25, "climb_mult" = 0.5)
	varchange_type = TRAIT_VARCHANGE_LESS_BETTER
	excludes = list(/datum/trait/positive/wall_climber,/datum/trait/positive/wall_climber_natural)

// This feels jank, but it's the cleanest way I could do TRAIT_VARCHANGE_LESS_BETTER while having a boolean var change
// Alternate would've been banned_species = list(SPECIES_TAJARAN, SPECIES_VASSILISIAN)
// Opted for this as it's "future proof"
/datum/trait/positive/wall_climber_pro/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	S.can_climb = TRUE

/datum/trait/positive/good_swimmer
	name = "Pro Swimmer"
	desc = "You were top of your group in swimming class! This is of questionable usefulness on most planets, but hey, maybe you'll get to visit a nice beach world someday?"
	tutorial = "You move faster in water, and can move up and down z-levels faster than other swimmers!"
	cost = 1
	custom_only = FALSE
	var_changes = list("water_movement" = -2, "swim_mult" = 0.5)
	varchange_type = TRAIT_VARCHANGE_LESS_BETTER
	excludes = list(/datum/trait/negative/bad_swimmer)
	banned_species = list(SPECIES_AKULA)	// They already swim better than this

/datum/trait/positive/table_passer
	name = "Table Passer"
	desc = "You move over or under tables with ease of a Teshari."
	cost = 2

	// Traitgenes Replacement for /datum/trait/positive/superpower_midget, made into a genetrait
	is_genetrait = TRUE
	hidden = FALSE
	activation_message="Your skin feels rubbery."

	has_preferences = list("pass_table" = list(TRAIT_PREF_TYPE_BOOLEAN, "On spawn", TRAIT_NO_VAREDIT_TARGET, TRUE))

/datum/trait/positive/table_passer/apply(var/datum/species/S,var/mob/living/carbon/human/H, var/list/trait_prefs)
	..()
	if(trait_prefs?["pass_table"] || !trait_prefs)
		H.pass_flags |= PASSTABLE
	add_verb(H,/mob/living/proc/toggle_pass_table)

// Traitgenes All genetraits need an unapply proc if they do anything special
/datum/trait/positive/table_passer/unapply(datum/species/S, mob/living/carbon/human/H)
	. = ..()
	if (H.pass_flags & PASSTABLE)
		H.pass_flags ^= PASSTABLE
	if(!(/mob/living/proc/toggle_pass_table in S.inherent_verbs)) // Teshari shouldn't lose agility
		remove_verb(H,/mob/living/proc/toggle_pass_table)

/datum/trait/positive/photosynth
	name = "Photosynthesis"
	desc = "Your body is able to produce nutrition from being in light."
	cost = 3
	can_take = ORGANICS|SYNTHETICS //Synths actually use nutrition, just with a fancy covering.
	added_component_path = /datum/component/photosynth

/datum/trait/positive/rad_resistance
	name = "Radiation Resistance"
	desc = "You are generally more resistant to radiation, and it dissipates faster from your body."
	cost = 1
	var_changes = list("radiation_mod" = 0.65, "rad_removal_mod" = 3.5, "rad_levels" = RESISTANT_RADIATION_RESISTANCE)

/datum/trait/positive/rad_resistance_extreme
	name = "Radiation Resistance, Major"
	desc = "You are much more resistant to radiation, and it dissipates much faster from your body."
	cost = 2
	var_changes = list("radiation_mod" = 0.5, "rad_removal_mod" = 5, "rad_levels" = MAJOR_RESISTANT_RADIATION_RESISTANCE)

/datum/trait/positive/rad_immune
	name = "Radiation Immunity"
	desc = "For whatever reason, be it a more dense build or some quirk of your genetic code, your body is completely immune to radiation."
	cost = 3
	var_changes = list("radiation_mod" = 0.0, "rad_removal_mod" = 10, "rad_levels" = IMMUNITY_RADIATION_RESISTANCE)

	// Traitgenes
	is_genetrait = TRUE
	hidden = FALSE
	activation_message="Your body feels mundane."

/datum/trait/positive/vibration_sense
	name = "Vibration Sense"
	desc = "Allows you to sense subtle vibrations nearby, even if the source cannot be seen."
	cost = 2
	var_changes = list("has_vibration_sense" = TRUE)

	// Traitgenes edit begin - Made into a gene trait
	is_genetrait = TRUE
	hidden = FALSE

	activation_message="Your ears ring, and hear everything..."
	// Traitgenes edit end

/datum/trait/positive/vibration_sense/apply(datum/species/S, mob/living/carbon/human/H, trait_prefs)
	. = ..()
	H.motiontracker_subscribe()
	add_verb(H,/mob/living/carbon/human/proc/sonar_ping)

/datum/trait/positive/vibration_sense/unapply(datum/species/S, mob/living/carbon/human/H, trait_prefs)
	. = ..()
	H.motiontracker_unsubscribe()
	remove_verb(H,/mob/living/carbon/human/proc/sonar_ping)

/datum/trait/positive/stable_genetics
	name = "Stable Genetics"
	desc = "Your genetics are extraordinarily stable, with your DNA being immune to any changes, including slimes!"
	cost = 2
	custom_only = TRUE
	var_changes = list("flags" = NO_DNA)

/datum/trait/positive/weaver/xenochimera
	sort = TRAIT_SORT_SPECIES
	allowed_species = list(SPECIES_XENOCHIMERA)
	name = "Xenochimera: Weaver"
	desc = "You've evolved your body to produce silk that you can fashion into articles of clothing and other objects."
	cost = 0
	category = 0
	custom_only = FALSE

/datum/trait/positive/hardfeet/xenochimera
	sort = TRAIT_SORT_SPECIES
	allowed_species = list(SPECIES_XENOCHIMERA)
	name = "Xenochimera: Hard Feet"
	desc = "Your body has adapted to make your feet immune to glass shards, whether by developing hooves, chitin, or just horrible callous."
	cost = 0
	category = 0
	custom_only = FALSE

/datum/trait/positive/melee_attack_fangs/xenochimera
	sort = TRAIT_SORT_SPECIES
	allowed_species = list(SPECIES_XENOCHIMERA)
	name = "Xenochimera: Sharp Melee & Numbing Fangs"
	desc = "Your hunting instincts manifest in earnest! You have grown numbing fangs alongside your naturally grown hunting weapons."
	cost = 0
	category = 0
	custom_only = FALSE
	var_changes = list("unarmed_types" = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/claws/chimera, /datum/unarmed_attack/bite/sharp, /datum/unarmed_attack/bite/sharp/numbing)) // Fixes the parent forgetting to add 'chimera-specific claws

/datum/trait/positive/snowwalker/xenochimera
	sort = TRAIT_SORT_SPECIES
	allowed_species = list(SPECIES_XENOCHIMERA)
	name = "Xenochimera: Snow Walker"
	desc = "You've adapted to traversing snowy terrain. Snow does not slow you down!"
	cost = 0
	category = 0
	custom_only = FALSE

/datum/trait/positive/aquatic/xenochimera
	sort = TRAIT_SORT_SPECIES
	allowed_species = list(SPECIES_XENOCHIMERA)
	name = "Xenochimera: Aquatic"
	desc = "You can breathe under water and can traverse water more efficiently. Additionally, you can eat others in the water."
	cost = 0
	category = 0
	excludes = list(/datum/trait/positive/winged_flight/xenochimera)
	custom_only = FALSE

/datum/trait/positive/winged_flight/xenochimera
	sort = TRAIT_SORT_SPECIES
	allowed_species = list(SPECIES_XENOCHIMERA)
	name = "Xenochhimera: Winged Flight"
	desc = "Allows you to fly by using your wings. Don't forget to bring them!"
	cost = 0
	excludes = list(/datum/trait/positive/aquatic/xenochimera)
	custom_only = FALSE

/datum/trait/positive/cocoon_tf/xenochimera
	sort = TRAIT_SORT_SPECIES
	allowed_species = list(SPECIES_XENOCHIMERA)
	custom_only = FALSE
	name = "Xenochimera: Cocoon Spinner"
	desc = "Allows you to build a cocoon around yourself, using it to transform your body if you desire."
	cost = 0
	category = 0

/datum/trait/positive/virus_immune
	name = "Virus Immune"
	desc = "You are immune to viruses."
	cost = 3

	can_take = ORGANICS
	var_changes = list("virus_immune" = TRUE)

/datum/trait/positive/linguist/master
	name = "Master Linguist"
	desc = "You are a master of languages! For whatever reason you might have, you are able to learn many more languages than others. Your language cap is 12 slots."
	cost = 2
	var_changes = list("num_alternate_languages" = 15)
	var_changes_pref = list("extra_languages" = 12)

/datum/trait/positive/densebones
	name = "Dense Bones"
	desc = "Your bones (or robotic limbs) are more dense or stronger then what is considered normal. It is much harder to fracture your bones, yet pain from fractures is much more intense. Bones require 50% more damage to break, and deal 2x pain on break."
	cost = 3
	excludes = list(/datum/trait/negative/hollow)

/datum/trait/positive/densebones/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	for(var/obj/item/organ/external/organ in H.organs)
		if(istype(organ))
			organ.min_broken_damage *= 1.5

/datum/trait/positive/lowpressureresminor // Same as original trait with cost reduced, much more useful as filler.
	name = "Low Pressure Resistance, Minor"
	desc = "Your body is more resistant to low pressures and you can breathe better in those conditions. Pretty simple."
	cost = 1
	var_changes = list("hazard_low_pressure" = HAZARD_LOW_PRESSURE*0.66, "warning_low_pressure" = WARNING_LOW_PRESSURE*0.66, "minimum_breath_pressure" = 16*0.66)
	excludes = list(/datum/trait/positive/lowpressureresmajor,/datum/trait/positive/pressureres,/datum/trait/positive/pressureresmajor)

/datum/trait/positive/lowpressureresmajor // Still need an oxygen tank, otherwise you'll suffocate.
	name = "Low Pressure Resistance, Major"
	desc = "Your body is immune to low pressures and you can breathe significantly better in low-pressure conditions, though you'll still need an oxygen supply."
	cost = 2
	var_changes = list("hazard_low_pressure" = HAZARD_LOW_PRESSURE*0, "warning_low_pressure" = WARNING_LOW_PRESSURE*0, "minimum_breath_pressure" = 16*0.33)
	excludes = list(/datum/trait/positive/lowpressureresminor,/datum/trait/positive/pressureres,/datum/trait/positive/pressureresmajor)

/datum/trait/positive/highpressureresminor // Increased high pressure cap as previous amount was neglible.
	name = "High Pressure Resistance, Minor"
	desc = "Your body is more resistant to high pressures. Pretty simple."
	cost = 1
	var_changes = list("hazard_high_pressure" = HAZARD_HIGH_PRESSURE*2, "warning_high_pressure" = WARNING_HIGH_PRESSURE*2)
	excludes = list(/datum/trait/positive/highpressureresmajor,/datum/trait/positive/pressureres,/datum/trait/positive/pressureresmajor)

/datum/trait/positive/highpressureresmajor
	name = "High Pressure Resistance, Major"
	desc = "Your body is significantly more resistant to high pressures. Pretty simple."
	cost = 2
	var_changes = list("hazard_high_pressure" = HAZARD_HIGH_PRESSURE*4, "warning_high_pressure" = WARNING_HIGH_PRESSURE*4)
	excludes = list(/datum/trait/positive/highpressureresminor,/datum/trait/positive/pressureres,/datum/trait/positive/pressureresmajor)

/datum/trait/positive/pressureres
	name = "General Pressure Resistance"
	desc = "Your body is much more resistant to both high and low pressures. Pretty simple."
	cost = 3
	var_changes = list("hazard_high_pressure" = HAZARD_HIGH_PRESSURE*3,
					   "warning_high_pressure" = WARNING_HIGH_PRESSURE*3,
					   "hazard_low_pressure" = HAZARD_LOW_PRESSURE*0.33,
					   "warning_low_pressure" = WARNING_LOW_PRESSURE*0.33,
					   "minimum_breath_pressure" = 16*0.33
					   )
	excludes = list(/datum/trait/positive/lowpressureresminor,/datum/trait/positive/lowpressureresmajor,/datum/trait/positive/highpressureresminor,/datum/trait/positive/highpressureresmajor,/datum/trait/positive/pressureresmajor)

/datum/trait/positive/pressureresmajor // If they have the points and want more freedom with atmos, let them.
	name = "General Pressure Resistance, Major"
	desc = "Your body is significantly more resistant to high pressures and immune to low pressures, though you'll still need an oxygen supply."
	cost = 4
	var_changes = list("hazard_high_pressure" = HAZARD_HIGH_PRESSURE*4,
					   "warning_high_pressure" = WARNING_HIGH_PRESSURE*4,
					   "hazard_low_pressure" = HAZARD_LOW_PRESSURE*0,
					   "warning_low_pressure" = WARNING_LOW_PRESSURE*0,
					   "minimum_breath_pressure" = 16*0.33
					   )
	excludes = list(/datum/trait/positive/lowpressureresminor,/datum/trait/positive/lowpressureresmajor,/datum/trait/positive/highpressureresminor,/datum/trait/positive/highpressureresmajor,/datum/trait/positive/pressureres)

/datum/trait/positive/more_blood
	name = "Blood Volume, High"
	desc = "You have 50% more blood."
	cost = 2
	var_changes = list("blood_volume" = 840)
	excludes = list(/datum/trait/positive/more_blood_extreme,/datum/trait/negative/less_blood,/datum/trait/negative/less_blood_extreme)
	can_take = ORGANICS
	custom_only = FALSE

/datum/trait/positive/more_blood_extreme
	name = "Blood Volume, Very High"
	desc = "You have 150% more blood."
	cost = 4
	var_changes = list("blood_volume" = 1400)
	excludes = list(/datum/trait/positive/more_blood,/datum/trait/negative/less_blood,/datum/trait/negative/less_blood_extreme)
	can_take = ORGANICS

/datum/trait/positive/heavyweight
	name = "Heavyweight"
	desc = "You are more heavyweight or otherwise more sturdy than most species, and as such, more resistant to knockdown effects and stuns. Stuns are only half as effective on you, and neither players nor mobs can trade places with you or bump you out of the way."
	cost = 2
	var_changes = list("stun_mod" = 0.5, "weaken_mod" = 0.5) // Stuns are 50% as effective - a stun of 3 seconds will be 2 seconds due to rounding up. Set to 0.5 to be in-line with the trait's description. (Weaken is used alongside stun to prevent aiming.)

/datum/trait/positive/heavyweight/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	H.mob_size = MOB_LARGE
	H.mob_bump_flag = HEAVY

/datum/trait/positive/grappling_expert
	name = "Grappling Expert"
	desc = "Your grabs are much harder to escape from, and you are better at escaping from other's grabs!"
	cost = 3
	var_changes = list("grab_resist_divisor_victims" = 1.5, "grab_resist_divisor_self" = 0.5, "grab_power_victims" = -1, "grab_power_self" = 1)

/datum/trait/positive/absorbent
	name = "Absorbent"
	desc = "You are able to clean messes just by walking over them, and gain nutrition from doing so!"
	cost = 1
	excludes = list(/datum/trait/negative/slipperydirt)
	added_component_path = /datum/component/absorbent

/datum/trait/positive/adrenaline_rush
	name = "Adrenaline Rush"
	desc = "When you get critically damaged, you'll have an adrenaline rush before going down, giving you another chance to finish the fight, or get to safety."
	cost = 6
	special_env = TRUE
	can_take = ORGANICS
	var/last_adrenaline_rush

/datum/trait/positive/adrenaline_rush/handle_environment_special(var/mob/living/carbon/human/H)
	if(!(H.health<0))
		return
	if(last_adrenaline_rush && last_adrenaline_rush + (30 MINUTES) > world.time)
		return
	last_adrenaline_rush = world.time
	log_and_message_admins("[H]'s adrenaline rush trait just activated!", H)
	H.add_modifier(/datum/modifier/adrenaline, 30 SECONDS)

/datum/modifier/adrenaline
	name = "Adrenaline Rush"
	desc = "A rush of adrenaline, usually caused by near death in situations."
	on_created_text = span_danger("You suddenly feel adrenaline pumping through your veins as your body refuses to give up! You feel stronger, and faster, and the pain fades away quickly.")
	on_expired_text = span_danger("You feel your body finally give in once more as the adrenaline subsides. The pain returns in full blast, along with your strength fading once more.")

	disable_duration_percent = 0		//Immune to being disabled.
	pain_immunity = TRUE				//Immune to pain
	max_health_flat = 25				//Temporary health boost.
	incoming_damage_percent = 0.8		//Slight damage immunity
	incoming_oxy_damage_percent = 0.1	//Temporary oxyloss slowdown

	outgoing_melee_damage_percent = 2	//Muscles are in overdrive
	attack_speed_percent = 0.5			//Muscles are in overdrive
	slowdown = -11						//Muscles are in overdrive
	evasion = 20						//Increased focus
	accuracy = 25						//Increased focus
	accuracy_dispersion = -25			//Increased focus
	pulse_modifier = 2					//Heart is in overdrive
	bleeding_rate_percent = 1.25		//Bleed more with higher blood pressure.
	metabolism_percent = 2.5			//Metabolism in overdrive

	var/original_length
	var/list/original_values

/datum/modifier/adrenaline/on_applied()
	original_length = expire_at - world.time
	original_values = list("stun" = holder.halloss*1.5, "weaken" = holder.weakened*1.5, "paralyze" = holder.paralysis*1.5, "stutter" = holder.stuttering*1.5, "eye_blur" = holder.eye_blurry*1.5, "drowsy" = holder.drowsyness*1.5, "agony" = holder.halloss*1.5, "confuse" = holder.confused*1.5)

/datum/modifier/adrenaline/tick()
	holder.halloss = 0
	holder.weakened = 0
	holder.paralysis = 0
	holder.stuttering = 0
	holder.eye_blurry = 0
	holder.drowsyness = 0
	holder.halloss = 0
	holder.confused = 0
	holder.stunned = 0

/datum/modifier/adrenaline/on_expire()	//Your time is up, time to suffer the consequences.
	holder.apply_effects(original_values["stun"] + 30,original_values["weaken"] + 20,original_values["paralyze"] + 15,0,original_values["stutter"] + 40,original_values["eye_blur"] + 20,original_values["drowsy"] + 75,original_values["agony"])
	holder.Confuse(original_values["confused"])
	holder.add_modifier(/datum/modifier/adrenaline_recovery,original_length*17.5)

/datum/modifier/adrenaline_recovery
	name = "Adrenaline detox"
	desc = "After an adrenaline rush, one will find themselves suffering from adrenaline detox, which is their body recovering from an intense adrenaline rush."
	on_created_text = span_danger("Your body aches and groans, forcing you into a period of rest as it recovers from the intense adrenaline rush.")
	on_expired_text = span_notice("You finally recover from your adrenaline rush, your body returning to its normal state.")

	disable_duration_percent = 1.35
	outgoing_melee_damage_percent = 0.75
	attack_speed_percent = 2
	slowdown = 2
	evasion = -20
	bleeding_rate_percent = 0.8
	pulse_modifier = 0.5
	metabolism_percent = 0.5
	accuracy = -25
	accuracy_dispersion = 25
	incoming_hal_damage_percent = 1.75
	incoming_oxy_damage_percent = 1.25

/datum/trait/positive/insect_sting
	name = "Insect Sting"
	desc = "Allows you to sting your victim with a smalll amount of poison"
	cost = 1

/datum/trait/positive/insect_sting/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	add_verb(H,/mob/living/proc/insect_sting)

/datum/trait/positive/burn_resist_plus // Equivalent to Burn Weakness Major, cannot be taken at the same time.
	name = "Burn Resist, Major"
	desc = "Adds 40% resistance to burn damage sources."
	cost = 4 // Exact Opposite of Burn Weakness Major, except Weakness Major is 50% incoming, this is -40% incoming.
	var_changes = list("burn_mod" = 0.6)
	excludes = list(/datum/trait/positive/burn_resist, /datum/trait/positive/minor_burn_resist)

/datum/trait/positive/brute_resist_plus // Equivalent to Brute Weakness Major, cannot be taken at the same time.
	name = "Brute Resist, Major"
	desc = "Adds 40% resistance to brute damage sources."
	cost = 4 // Exact Opposite of Brute Weakness Major, except Weakness Major is 50% incoming, this is -40% incoming.
	var_changes = list("brute_mod" = 0.6)
	excludes = list(/datum/trait/positive/brute_resist, /datum/trait/positive/minor_brute_resist)

/datum/trait/positive/endurance_very_high
	name = "High Endurance, Major"
	desc = "Increases your maximum total hitpoints to 150. You require 300 damage in total to die, compared to 200 normally. You will still go into crit after losing 150 HP, compared to crit at 100 HP."
	cost = 6 // This should cost a LOT, because your total health becomes 300 to be fully dead, rather than 200 normally, or 250 for High Endurance. HE costs 3, double it here.
	var_changes = list("total_health" = 150)
	excludes = list(/datum/trait/positive/endurance_high, /datum/trait/positive/endurance_extremely_high)

/datum/trait/positive/endurance_very_high/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	H.setMaxHealth(S.total_health)

/datum/trait/positive/endurance_extremely_high
	name = "High Endurance, Extreme"
	desc = "Increases your maximum total hitpoints to 175. You require 350 damage in total to die, compared to 200 normally. You will still go into crit after losing 175 HP, compared to crit at 100 HP."
	cost = 9 // This should cost a LOT, because your total health becomes 350 to be fully dead, rather than 200 normally, or 250 for High Endurance. HE costs 3, this costs 3x it.
	var_changes = list("total_health" = 175)
	excludes = list(/datum/trait/positive/endurance_high, /datum/trait/positive/endurance_very_high)

/datum/trait/positive/endurance_extremely_high/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	H.setMaxHealth(S.total_health)

/datum/trait/positive/pain_tolerance_minor // Minor Pain Tolerance, 10% reduced pain
	name = "Pain Tolerance, Minor"
	desc = "You are slightly more resistant to pain than most, and experience 10% less pain from all sources."
	cost = 1
	custom_only = FALSE
	var_changes = list("pain_mod" = 0.9)

/datum/trait/positive/pain_tolerance
	name = "Pain Tolerance"
	desc = "You are noticeably more resistant to pain than most, and experience 20% less pain from all sources."
	cost = 2
	custom_only = FALSE
	var_changes = list("pain_mod" = 0.8)

/datum/trait/positive/pain_tolerance_advanced // High Pain Intolerance is 50% incoming pain, but this is 40% reduced incoming pain.
	name = "Pain Tolerance, Major"
	desc = "You are extremely resistant to pain sources, and experience 40% less pain from all sources."
	cost = 3 // Equivalent to High Pain Intolerance, but less pain resisted for balance reasons.
	custom_only = FALSE
	var_changes = list("pain_mod" = 0.6)

/datum/trait/positive/improved_biocompat
	name = "Improved Biocompatibility"
	desc = "Your body is naturally (or artificially) more receptive to healing chemicals without being vulnerable to the 'bad stuff'. You heal more efficiently from most chemicals, with no other drawbacks. Remember to note this down in your medical records! Chems heal for 20% more."
	cost = 2
	custom_only = FALSE
	var_changes = list("chem_strength_heal" = 1.2)

/datum/trait/positive/photoresistant_plus // YW added Trait
	name = "Photoresistance, Major"
	desc = "Decreases stun duration from flashes and other light-based stuns and disabilities by 50%."
	cost = 2
	var_changes = list("flash_mod" = 0.5)

/datum/trait/positive/hardy_extreme
	name = "Hardy, Extreme"
	desc = "Allows you to carry heavy equipment with no slowdown at all."
	cost = 3
	var_changes = list("item_slowdown_mod" = 0.0)
	excludes = list(/datum/trait/positive/speed_fast,/datum/trait/positive/hardy,/datum/trait/positive/hardy_plus)

/datum/trait/positive/bloodsucker_plus
	name = "Evolved Bloodsucker"
	desc = "Makes you able to gain nutrition by draining blood as well as eating food. To compensate, you get fangs that can be used to drain blood from prey."
	cost = 1
	var_changes = list("organic_food_coeff" = 0.5) // Hopefully this works???
	excludes = list(/datum/trait/neutral/bloodsucker)

/datum/trait/positive/bloodsucker_plus/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	add_verb(H,/mob/living/carbon/human/proc/bloodsuck)

/datum/trait/positive/toxin_gut
	name ="Robust Gut"
	desc = "You are immune to most ingested toxins. Does not protect from possible harm caused by other drugs, meds, allergens etc."
	cost = 1
	custom_only = FALSE

/datum/trait/positive/toxin_gut/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	ADD_TRAIT(H, INGESTED_TOXIN_IMMUNE, ROUNDSTART_TRAIT)

/datum/trait/positive/nobreathe
	name = "Breathless"
	desc = "You or your species have adapted to no longer require lungs, and as such no longer need to breathe!"
	cost = 6
	can_take = ORGANICS

	var_changes = list("breath_type" = "null", "poison_type" = "null", "exhale_type" = "null")
	excludes = list(/datum/trait/negative/breathes/phoron,
					/datum/trait/negative/breathes/nitrogen,
					/datum/trait/negative/breathes/carbon_dioxide,
					/datum/trait/positive/light_breather,
					/datum/trait/negative/deep_breather
)

/datum/trait/positive/nobreathe/apply(var/datum/species/S, var/mob/living/carbon/human/H)
	..()
	H.does_not_breathe = 1
	var/obj/item/organ/internal/breathy = H.internal_organs_by_name[O_LUNGS]
	if(!breathy)
		return
	H.internal_organs -= breathy
	qdel(breathy)

/datum/trait/positive/light_breather
	name ="Light Breather"
	desc = "You need less air for your lungs to properly work.."
	cost = 1

	custom_only = FALSE
	can_take = ORGANICS
	var_changes = list("minimum_breath_pressure" = 12)
	excludes = list(/datum/trait/negative/deep_breather)

/datum/trait/positive/emp_resist
	name = "EMP Resistance"
	desc = "You are resistant to EMPs"
	cost = 3

	can_take = SYNTHETICS
	custom_only = FALSE
	var_changes = list("emp_dmg_mod" = 0.7, "emp_stun_mod" = 0.7)
	excludes = list(/datum/trait/negative/faultwires, /datum/trait/negative/poorconstruction, /datum/trait/positive/emp_resist_major)

/datum/trait/positive/emp_resist/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	H.add_modifier(/datum/modifier/trait/empresist)

/datum/trait/positive/emp_resist_major
	name = "Major EMP Resistance"
	desc = "You are very resistant to EMPs"
	cost = 5

	can_take = SYNTHETICS
	custom_only = FALSE
	var_changes = list("emp_dmg_mod" = 0.5, "emp_stun_mod" = 0.5)
	excludes = list(/datum/trait/negative/faultwires, /datum/trait/negative/poorconstruction, /datum/trait/positive/emp_resist)

/datum/trait/positive/emp_resist_major/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	H.add_modifier(/datum/modifier/trait/empresistb)

/datum/trait/positive/radioactive_heal
	name = "Radioactive Heal"
	desc = "You heal when exposed to radiation instead of becoming ill. You can also choose to emit a glow when irradiated."
	cost = 6
	is_genetrait = TRUE
	hidden = FALSE
	has_preferences = list("glow_color" = list(TRAIT_PREF_TYPE_COLOR, "Glow color", TRAIT_NO_VAREDIT_TARGET, "#c3f314",),
	"glow_enabled" = list(TRAIT_PREF_TYPE_BOOLEAN, "Glow enabled on spawn", TRAIT_NO_VAREDIT_TARGET, FALSE))

	added_component_path = /datum/component/radiation_effects
	excludes = list(/datum/trait/neutral/glowing_radiation, /datum/trait/positive/rad_resistance, /datum/trait/positive/rad_resistance_extreme, /datum/trait/positive/rad_immune, /datum/trait/negative/rad_weakness)

/datum/trait/positive/radioactive_heal/apply(var/datum/species/S,var/mob/living/carbon/human/H, var/list/trait_prefs)
	..()
	var/datum/component/radiation_effects/G = H.GetComponent(added_component_path)
	if(trait_prefs)
		G.radiation_color = trait_prefs["glow_color"]
		G.glows = trait_prefs["glow_enabled"]
	G.radiation_healing = TRUE
	G.radiation_nutrition = TRUE

/datum/trait/positive/radioactive_heal/unapply(var/datum/species/S,var/mob/living/carbon/human/H, var/list/trait_prefs)
	..() //Does all the removal stuff
	//We then check to see if we still have the radiation component (such as we have a species componennt of it)
	//If so, we remove the healing effect.
	var/datum/component/radiation_effects/G = H.GetComponent(added_component_path)
	if(G)
		G.radiation_healing = initial(G.radiation_healing)
		G.radiation_nutrition = initial(G.radiation_nutrition)
