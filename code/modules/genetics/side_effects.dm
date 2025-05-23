/datum/genetics/side_effect
	var/name 				// name of the side effect, to use as a header in the manual
	var/duration = 0 		// delay between start() and finish()
	var/antidote_reagent 	// What type of reagent we require to stop the specific side effect from happening

/proc/trigger_side_effect(mob/living/carbon/human/H)
	if(!ishuman(H)) return
	var/tp = pick(subtypesof(/datum/genetics/side_effect))
	var/datum/genetics/side_effect/S = new tp

	S.start(H)
	addtimer(CALLBACK(H, TYPE_PROC_REF(/mob/living/carbon/human, Weaken), 4), 2 SECONDS, TIMER_DELETE_ME)
	addtimer(CALLBACK(S, TYPE_PROC_REF(/datum/genetics/side_effect, finish), WEAKREF(H)), S.duration, TIMER_DELETE_ME)
	//above is doing: Call S.finish(H) in S.duration

/datum/genetics/side_effect/proc/start(mob/living/carbon/human/H)
	if(H && ishuman(H))
		H.genetic_side_effects += src
	// start the side effect, this should give some cue as to what's happening,
	// such as gasping. These cues need to be unique among side-effects.

/datum/genetics/side_effect/proc/finish(var/datum/weakref/WR)
	var/mob/living/carbon/human/H = WR.resolve()
	if(!H || !ishuman(H)) return FALSE
	H.genetic_side_effects -= src
	if(antidote_reagent && (H.reagents.has_reagent(antidote_reagent)|| H.ingested.has_reagent(antidote_reagent) || H.touching.has_reagent(antidote_reagent)))
		return TRUE
	return FALSE
	// Finish the side-effect. This should first check whether the cure has been
	// applied, and if not, cause bad things to happen.

/datum/genetics/side_effect/genetic_burn
	name = "Genetic Burn"
	duration = 30 SECONDS
	antidote_reagent = REAGENT_ID_DEXALIN

/datum/genetics/side_effect/genetic_burn/start(mob/living/carbon/human/H)
	..()
	H.automatic_custom_emote(VISIBLE_MESSAGE, "starts turning very red..", check_stat = TRUE)

/datum/genetics/side_effect/genetic_burn/finish(datum/weakref/WR)
	if(..()) return
	var/mob/living/carbon/human/H = WR.resolve()
	for(var/organ_name in BP_ALL)
		var/obj/item/organ/external/E = H.get_organ(organ_name)
		E.take_damage(0, 5, 0)

/datum/genetics/side_effect/bone_snap
	name = "Genetic Bone Snap"
	duration = 60 SECONDS
	antidote_reagent = REAGENT_ID_BICARIDINE

/datum/genetics/side_effect/bone_snap/start(mob/living/carbon/human/H)
	..()
	H.automatic_custom_emote(VISIBLE_MESSAGE, "'s limbs start shivering uncontrollably.", check_stat = TRUE)

/datum/genetics/side_effect/bone_snap/finish(datum/weakref/WR)
	if(..()) return
	var/mob/living/carbon/human/H = WR.resolve()
	var/organ_name = pick(BP_ALL)
	var/obj/item/organ/external/E = H.get_organ(organ_name)
	E.take_damage(20, 0, 0)
	E.fracture()

/datum/genetics/side_effect/confuse
	name = "Genetic Confusion"
	duration = 30 SECONDS
	antidote_reagent = REAGENT_ID_ANTITOXIN

/datum/genetics/side_effect/confuse/start(mob/living/carbon/human/H)
	..()
	var/datum/gender/T = gender_datums[H.get_visible_gender()]
	H.automatic_custom_emote(VISIBLE_MESSAGE, "has drool running down from [T.his] mouth.", check_stat = TRUE)

/datum/genetics/side_effect/confuse/finish(datum/weakref/WR)
	if(..()) return
	var/mob/living/carbon/human/H = WR.resolve()
	H.Confuse(100)
