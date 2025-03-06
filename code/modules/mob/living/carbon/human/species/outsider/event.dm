/*
This species is meant to be used both as a base for Event species and possible future per-round RNG'd species, hence the proc var-ization in some places.

IF YOU ARE USING THIS SPECIES:

Variables you may want to make use of are:

	icobase and deform				Set both to the same thing, unless you have special deformed sprites.
	mobtemplate						The blank bounding box used by your species.
	mob_size						The size class of the species. 20 is human.
	show_ssd						What is shown when they're SSD?
	virus_immune					Immune to viruses? 1/0
	short_sighted					Permanent weldervision. 1/0
	blood_volume					Initial blood volume.
	bloodloss_rate					Multiplier for how fast a species bleeds out. Higher = Faster
	hunger_factor					Multiplier for hunger.
	active_regen_mult				Multiplier for 'Regenerate' power speed, in human_powers.dm

	scream_verb						The text descriptor of the scream. Default screams.
	male_scream_sound				Sound played when a male *scream s.
	female_scream_sound				Sound played when a female *scream s.
	male_cough_sounds				List of cough sounds for males.
	female_cough_sounds				List of cough sounds for females.
	male_sneeze_sound				Sound played when a male *sneeze s..
	female_sneeze_sound				Sound played when a female *sneeze s.

	speech_sounds					A list of sounds used randomly when the species talks.
	speech_chance					Percentile chance to do the above.

	total_health					How much damage can they take before entering crit? Default 100.

	brute_mod						Physical damage multiplier.
	burn_mod						Burn damage multiplier.
	oxy_mod							Oxyloss modifier
	toxins_mod						Toxloss modifier
	radiation_mod					Radiation modifier
	flash_mod						Stun from blindness modifier.
	sound_mod						Stun from sounds, I.E. flashbangs.
	chemOD_mod						Damage modifier for overdose
	siemens_coefficient				The lower, the thicker the skin and better the insulation.
	darksight						Native darksight distance.

	meat_type						The food given when they are turned into meat.
	remains_type					The effect left behind when they are ashed.
	death_sound						The sound played when they die.
	death_message					The deathgasp.
	knockout_message				The message when someone gets a lucky shot on the head.
	cloning_modifier				The modifier given when they are by chance cloned.

	Any 'heat' or 'pressure' vars.	Environmental survivability.

	speech_bubble_appearance		Part of icon_state to use for speech bubbles when talking.	See talk.dmi for available icons.

	slowdown						Passive movement speed malus (or boost, if negative)
	move_trail						What effect marks are left when walking
	has_floating_eyes				Whether the eyes can be shown above other icons
	has_glowing_eyes				Whether the eyes are shown above all lighting
	water_movement					How much faster or slower the species is in water
	snow_movement					How much faster or slower the species is on snow
	item_slowdown_mod				How affected by item slowdown the species is. Multiplier.

 */

/datum/species/event1 //Essentially, by default a 'better' human.
	name = SPECIES_EVENT1
	name_plural = SPECIES_EVENT1
	primitive_form = SPECIES_MONKEY
	unarmed_types = list(/datum/unarmed_attack/stomp/event1, /datum/unarmed_attack/kick/event1, /datum/unarmed_attack/punch/event1, /datum/unarmed_attack/bite/event1)
	blurb = "We're not quite sure where these things came from. Are you?"
	num_alternate_languages = 3
	species_language = LANGUAGE_GALCOM
	secondary_langs = list()
	assisted_langs = list()
	name_language = null // Use the first-name last-name generator rather than a language scrambler

	min_age = 0
	max_age = 999

	health_hud_intensity = 1.5

	flags = NO_MINOR_CUT | NO_HALLUCINATION | NO_INFECT

	vision_flags = SEE_SELF
	darksight = 7

	brute_mod = 0.9
	burn_mod = 0.9
	oxy_mod = 0.9
	toxins_mod = 0.9
	radiation_mod = 0.9
	flash_mod = 0.9
	sound_mod = 0.9
	chemOD_mod = 0.9
	siemens_coefficient = 0.9

	spawn_flags = SPECIES_IS_RESTRICTED
	appearance_flags = HAS_SKIN_TONE | HAS_EYE_COLOR

	//Far more organs, due to the issues with adding them and their respective verbs mid round, I'll include them here.
	//Colormatch organs will change to match the blood color of the species.
	has_organ = list(
		O_HEART =    /obj/item/organ/internal/heart/grey/colormatch,
		O_LUNGS =    /obj/item/organ/internal/lungs/grey/colormatch,
		O_LIVER =    /obj/item/organ/internal/liver/grey/colormatch,
		O_KIDNEYS =  /obj/item/organ/internal/kidneys/grey/colormatch,
		O_BRAIN =    /obj/item/organ/internal/brain/grey/colormatch,
		O_EYES =     /obj/item/organ/internal/eyes/grey/colormatch,
		O_PLASMA =   /obj/item/organ/internal/xenos/plasmavessel/grey/colormatch,
		O_ACID =     /obj/item/organ/internal/xenos/acidgland/grey/colormatch,
		O_HIVE =     /obj/item/organ/internal/xenos/hivenode/grey/colormatch,
		O_RESIN =    /obj/item/organ/internal/xenos/resinspinner/grey/colormatch
		)

	var/use_bodyshape = SPECIES_HUMAN
	var/overcome_gravity = 0
	var/hover = 0

/datum/species/event1/proc/set_limbset(var/setnum = 1) //Will require existing ones to be respawned for changes to take effect.
	switch(setnum)
		if(1) //Normal.
			has_limbs = list(
				BP_TORSO =	list("path" = /obj/item/organ/external/chest),
				BP_GROIN =	list("path" = /obj/item/organ/external/groin),
				BP_HEAD =	list("path" = /obj/item/organ/external/head),
				BP_L_ARM =	list("path" = /obj/item/organ/external/arm),
				BP_R_ARM =	list("path" = /obj/item/organ/external/arm/right),
				BP_L_LEG =	list("path" = /obj/item/organ/external/leg),
				BP_R_LEG =	list("path" = /obj/item/organ/external/leg/right),
				BP_L_HAND = list("path" = /obj/item/organ/external/hand),
				BP_R_HAND = list("path" = /obj/item/organ/external/hand/right),
				BP_L_FOOT = list("path" = /obj/item/organ/external/foot),
				BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right)
				)
		if(2) //No broken bones.
			has_limbs = list(
				BP_TORSO =  list("path" = /obj/item/organ/external/chest/unbreakable),
				BP_GROIN =  list("path" = /obj/item/organ/external/groin/unbreakable),
				BP_HEAD =   list("path" = /obj/item/organ/external/head/unbreakable),
				BP_L_ARM =  list("path" = /obj/item/organ/external/arm/unbreakable),
				BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right/unbreakable),
				BP_L_LEG =  list("path" = /obj/item/organ/external/leg/unbreakable),
				BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right/unbreakable),
				BP_L_HAND = list("path" = /obj/item/organ/external/hand/unbreakable),
				BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/unbreakable),
				BP_L_FOOT = list("path" = /obj/item/organ/external/foot/unbreakable),
				BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right/unbreakable)
				)
		if(3) //No removing from the body.
			has_limbs = list(
				BP_TORSO =  list("path" = /obj/item/organ/external/chest/unseverable),
				BP_GROIN =  list("path" = /obj/item/organ/external/groin/unseverable),
				BP_HEAD =   list("path" = /obj/item/organ/external/head/unseverable),
				BP_L_ARM =  list("path" = /obj/item/organ/external/arm/unseverable),
				BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right/unseverable),
				BP_L_LEG =  list("path" = /obj/item/organ/external/leg/unseverable),
				BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right/unseverable),
				BP_L_HAND = list("path" = /obj/item/organ/external/hand/unseverable),
				BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/unseverable),
				BP_L_FOOT = list("path" = /obj/item/organ/external/foot/unseverable),
				BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right/unseverable)
				)
		if(4) //No breaking, OR removing from the body. For things that are more monsterous.
			has_limbs = list(
				BP_TORSO =  list("path" = /obj/item/organ/external/chest/indestructible),
				BP_GROIN =  list("path" = /obj/item/organ/external/groin/indestructible),
				BP_HEAD =   list("path" = /obj/item/organ/external/head/indestructible),
				BP_L_ARM =  list("path" = /obj/item/organ/external/arm/indestructible),
				BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right/indestructible),
				BP_L_LEG =  list("path" = /obj/item/organ/external/leg/indestructible),
				BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right/indestructible),
				BP_L_HAND = list("path" = /obj/item/organ/external/hand/indestructible),
				BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/indestructible),
				BP_L_FOOT = list("path" = /obj/item/organ/external/foot/indestructible),
				BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right/indestructible)
				)
	return

/datum/species/event1/proc/choose_limbset()
	var/list/limb_sets = list("Normal" = 1, "Unbreakable" = 2, "Unseverable" = 3, "Indestructible" = 4)
	var/choice = tgui_input_list(usr, "Choose limb set to use for future spawns.", "Limb types.", limb_sets)
	set_limbset(limb_sets[choice])
	return limb_sets[choice]

/datum/species/event1/proc/toggle_thermal()
	vision_flags ^= SEE_MOBS

/datum/species/event1/proc/toggle_meson()
	vision_flags ^= SEE_TURFS

/datum/species/event1/proc/toggle_material()
	vision_flags ^= SEE_OBJS

/datum/species/event1/proc/toggle_infection()
	flags ^= NO_INFECT

/datum/species/event1/proc/toggle_noslip()
	flags ^= NO_SLIP

/datum/species/event1/proc/toggle_cloning()
	flags ^= NO_SLEEVE

/datum/species/event1/proc/toggle_dna()
	flags ^= NO_DNA

/datum/species/event1/proc/toggle_defibbing()
	flags ^= NO_DEFIB

/datum/species/event1/proc/toggle_pain()
	flags ^= NO_PAIN

/datum/species/event1/proc/toggle_embedding()
	flags ^= NO_EMBED

/datum/species/event1/proc/toggle_plant() //Maybe it's a distant cousin of the Venus Fly Trap.
	flags ^= IS_PLANT

/datum/species/event1/get_bodytype(var/mob/living/carbon/human/H) //Default to human sprites, if they're based on another species, var edit use_bodyshape to the correct thing in _defines/mobs.dm of the species you want to use.
	return use_bodyshape

/datum/species/event1/can_overcome_gravity(var/mob/living/carbon/human/H)
	return overcome_gravity

/datum/species/event1/can_fall(var/mob/living/carbon/human/H)
	return hover

/datum/species/event1/sub1
	name = SPECIES_EVENT2
	name_plural = SPECIES_EVENT2

/datum/species/event1/sub2
	name = SPECIES_EVENT3
	name_plural = SPECIES_EVENT3
