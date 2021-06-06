#define ORGANICS	1
#define SYNTHETICS	2

/datum/trait/positive
	category = 1

/datum/trait/positive/speed_fast
	name = "Haste"
	desc = "Allows you to move faster on average than baseline."
	cost = 4
	var_changes = list("slowdown" = -0.5)

/datum/trait/positive/hardy
	name = "Hardy"
	desc = "Allows you to carry heavy equipment with less slowdown."
	cost = 1
	var_changes = list("item_slowdown_mod" = 0.5)

/datum/trait/positive/hardy_plus
	name = "Major Hardy"
	desc = "Allows you to carry heavy equipment with almost no slowdown."
	cost = 2
	var_changes = list("item_slowdown_mod" = 0.25)

/datum/trait/positive/endurance_high
	name = "High Endurance"
	desc = "Increases your maximum total hitpoints to 125"
	cost = 4
	var_changes = list("total_health" = 125)

	apply(var/datum/species/S,var/mob/living/carbon/human/H)
		..(S,H)
		H.setMaxHealth(S.total_health)

/datum/trait/positive/nonconductive
	name = "Non-Conductive"
	desc = "Decreases your susceptibility to electric shocks by a 10% amount."
	cost = 1 //This effects tasers!
	var_changes = list("siemens_coefficient" = 0.9)

/datum/trait/positive/nonconductive_plus
	name = "Major Non-Conductive"
	desc = "Decreases your susceptibility to electric shocks by a 25% amount."
	cost = 2 //Let us not forget this effects tasers!
	var_changes = list("siemens_coefficient" = 0.75)

/datum/trait/positive/darksight
	name = "Darksight"
	desc = "Allows you to see a short distance in the dark."
	cost = 1
	var_changes = list("darksight" = 5, "flash_mod" = 1.1)

/datum/trait/positive/darksight_plus
	name = "Darksight (Major)"
	desc = "Allows you to see in the dark for the whole screen."
	cost = 2
	var_changes = list("darksight" = 8, "flash_mod" = 1.2)

/datum/trait/positive/melee_attack
	name = "Sharp Melee"
	desc = "Provides sharp melee attacks that do slightly more damage."
	cost = 1
	var_changes = list("unarmed_types" = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/claws, /datum/unarmed_attack/bite/sharp))

/datum/trait/positive/melee_attack_fangs
	name = "Sharp Melee & Numbing Fangs"
	desc = "Provides sharp melee attacks that do slightly more damage, along with fangs that makes the person bit unable to feel their body or pain."
	cost = 2
	var_changes = list("unarmed_types" = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/claws, /datum/unarmed_attack/bite/sharp, /datum/unarmed_attack/bite/sharp/numbing))

/datum/trait/positive/fangs
	name = "Numbing Fangs"
	desc = "Provides fangs that makes the person bit unable to feel their body or pain."
	cost = 1
	var_changes = list("unarmed_types" = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/punch, /datum/unarmed_attack/bite/sharp/numbing))

/datum/trait/positive/minor_brute_resist
	name = "Minor Brute Resist"
	desc = "Adds 15% resistance to brute damage sources."
	cost = 2
	var_changes = list("brute_mod" = 0.85)

/datum/trait/positive/brute_resist
	name = "Brute Resist"
	desc = "Adds 25% resistance to brute damage sources."
	cost = 3
	var_changes = list("brute_mod" = 0.75)
	excludes = list(/datum/trait/positive/minor_burn_resist,/datum/trait/positive/burn_resist)

/datum/trait/positive/minor_burn_resist
	name = "Minor Burn Resist"
	desc = "Adds 15% resistance to burn damage sources."
	cost = 2
	var_changes = list("burn_mod" = 0.85)

/datum/trait/positive/burn_resist
	name = "Burn Resist"
	desc = "Adds 25% resistance to burn damage sources."
	cost = 3
	var_changes = list("burn_mod" = 0.75)
	excludes = list(/datum/trait/positive/minor_brute_resist,/datum/trait/positive/brute_resist)

/datum/trait/positive/photoresistant
	name = "Photoresistant"
	desc = "Decreases stun duration from flashes and other light-based stuns and disabilities by 20%"
	cost = 1
	var_changes = list("flash_mod" = 0.8)

/datum/trait/positive/winged_flight
	name = "Winged Flight"
	desc = "Allows you to fly by using your wings. Don't forget to bring them!"
	cost = 0

/datum/trait/positive/winged_flight/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..(S,H)
	H.verbs |= /mob/living/proc/flying_toggle
	H.verbs |= /mob/living/proc/start_wings_hovering

/datum/trait/positive/hardfeet
	name = "Hard Feet"
	desc = "Makes your nice clawed, scaled, hooved, armored, or otherwise just awfully calloused feet immune to glass shards."
	cost = 0
	var_changes = list("flags" = NO_MINOR_CUT) //Checked the flag is only used by shard stepping.

/datum/trait/positive/antiseptic_saliva
	name = "Antiseptic Saliva"
	desc = "Your saliva has especially strong antiseptic properties that can be used to heal small wounds."
	cost = 1

/datum/trait/positive/antiseptic_saliva/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	H.verbs |= /mob/living/carbon/human/proc/lick_wounds

/datum/trait/positive/traceur
	name = "Traceur"
	desc = "You're capable of parkour and can *flip over low objects (most of the time)."
	cost = 2
	var_changes = list("agility" = 90)

/datum/trait/positive/snowwalker
	name = "Snow Walker"
	desc = "You are able to move unhindered on snow."
	cost = 1
	var_changes = list("snow_movement" = -2)

/datum/trait/positive/weaver
	name = "Weaver"
	desc = "You can produce silk and create various articles of clothing and objects."
	cost = 2
	var_changes = list("is_weaver" = 1)

/datum/trait/positive/weaver/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	H.verbs |= /mob/living/carbon/human/proc/check_silk_amount
	H.verbs |= /mob/living/carbon/human/proc/toggle_silk_production
	H.verbs |= /mob/living/carbon/human/proc/weave_structure
	H.verbs |= /mob/living/carbon/human/proc/weave_item
	H.verbs |= /mob/living/carbon/human/proc/set_silk_color

///chompers stuff
/datum/trait/positive/improved_biocompat
	name = "Improved Biocompatibility"
	desc = "Your body is naturally (or artificially) more receptive to healing chemicals without being vulnerable to the 'bad stuff'. You heal more efficiently from most chemicals, with no other drawbacks. Remember to note this down in your medical records!"
	cost = 2
	var_changes = list("chem_strength_heal" = 1.2)

/datum/trait/positive/pain_tolerance_advanced
	name = "High Pain Tolerance"
	desc = "You are noticeably more resistant to pain than most, and experience 20% less pain from all sources."
	cost = 2
	var_changes = list("pain_mod" = 0.8)

/datum/trait/positive/linguist
	name = "Master Linguist"
	desc = "You are a master of languages! For whatever reason you might have, you are able to learn many more languages than others."
	cost = 0
	var_changes = list("num_alternate_languages" = 12)

/datum/trait/negative/hollow
	name = "Strong Bones"
	desc = "Your bones and robot limbs are much harder to break."
	cost = 2

/datum/trait/negative/hollow/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..(S,H)
	for(var/obj/item/organ/external/O in H.organs)
		O.min_broken_damage *= 1.5
		O.min_bruised_damage *= 1.5


/datum/trait/positive/lowpressureres
	name = "Low Pressure Resistance"
	desc = "Your body is more resistant to low pressures. Pretty simple."
	cost = 1
	var_changes = list("hazard_low_pressure" = HAZARD_LOW_PRESSURE*0.66, "warning_low_pressure" = WARNING_LOW_PRESSURE*0.66, "minimum_breath_pressure" = 16*0.66)

/datum/trait/positive/highpressureres
	name = "High Pressure Resistance"
	desc = "Your body is more resistant to high pressures. Pretty simple."
	cost = 1
	var_changes = list("hazard_high_pressure" = HAZARD_HIGH_PRESSURE*1.5, "warning_high_pressure" = WARNING_HIGH_PRESSURE*1.5)

/datum/trait/positive/rad_resistance
	name = "Radiation Resistance"
	desc = "You are generally more resistant to radiation, and it dissipates faster from your body."
	cost = 2
	var_changes = list("radiation_mod" = 0.65, "rad_removal_mod" = 3.5, "rad_levels" = list("safe" = 20, "danger_1" = 75, "danger_2" = 100, "danger_3" = 200))

/datum/trait/positive/rad_resistance_extreme
	name = "Extreme Radiation Resistance"
	desc = "You are much more resistant to radiation, and it dissipates much faster from your body."
	cost = 4
	var_changes = list("radiation_mod" = 0.5, "rad_removal_mod" = 5, "rad_levels" = list("safe" = 40, "danger_1" = 100, "danger_2" = 150, "danger_3" = 250))

/datum/trait/positive/more_blood
	name = "High blood volume"
	desc = "You have much 50% more blood than most other people"
	cost = 2
	var_changes = list("blood_volume" = 840)
	excludes = list(/datum/trait/positive/more_blood_extreme,/datum/trait/negative/less_blood)
	can_take = ORGANICS

/datum/trait/positive/more_blood_extreme
	name = "Very high blood volume"
	desc = "You have much 150% more blood than most other people"
	cost = 4
	var_changes = list("blood_volume" = 1400)
	can_take = ORGANICS


/datum/trait/positive/table_passer
	name = "Table passer"
	desc = "You move over or under tables with ease of a Teshari."
	cost = 2

/datum/trait/positive/table_passer/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	H.pass_flags = PASSTABLE

/datum/trait/positive/photosynth
	name = "Photosynthesis"
	desc = "Your body is able to produce nutrition from being in light."
	cost = 0
	var_changes = list("photosynthesizing" = TRUE)
	can_take = ORGANICS|SYNTHETICS //Synths actually use nutrition, just with a fancy covering.
