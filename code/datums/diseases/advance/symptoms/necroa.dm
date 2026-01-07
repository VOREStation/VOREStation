/*
//////////////////////////////////////

Cytopathic Reanimation

	Stealthy.
	Has no innate resistance.
	Decreases stage speed massively.
	Massively reduced transmission.
	Critical Level.

Bonus
	Allows spread and processing in the dead.
	Allows resurrection of the dead.

//////////////////////////////////////
*/

/datum/symptom/necroa
	name = "Cytopathic Reanimation"
	desc = "Allows for reanimation of dead tissue and corpses. The virus can infect and spread through corpses."
	stealth = 3
	resistance = 0
	stage_speed = -4
	transmission = -3
	level = 8
	severity = 3

	///Time since we last revived
	var/time_since_revival = 0

	///Cooldown on how often we can revive.
	var/revival_cooldown = 60 SECONDS

	///When did we last do a 'heal tick' ?
	var/heal_tick = 0

	///How often do we do a 'heal tick' ? This saves CPU by doing it every so often instead of every tick.
	var/heal_tick_cooldown = 5 SECONDS

	///Have we been revived by the virus?
	var/been_revived = FALSE

/datum/symptom/necroa/OnAdd(datum/disease/advance/A)
	A.virus_modifiers |= SPREAD_DEAD

/datum/symptom/necroa/OnRemove(datum/disease/advance/A)
	A.virus_modifiers &= ~SPREAD_DEAD

/datum/symptom/necroa/Start(datum/disease/advance/A)
	if(!..())
		return

/datum/symptom/necroa/Activate(var/datum/disease/advance/A)
	if(!..())
		return
	var/mob/living/carbon/human/infectee = A.affected_mob
	if(!istype(infectee))
		return

	if(been_revived && prob(0.25)) //If we've been revived, we have permanent damage.
		infectee.emote(pick("drool", "twitch", "collapse", "twitch_v", "choke"))

	if(infectee.stat != DEAD)
		return
	if(A.stage < 5)
		return

	if(heal_tick + heal_tick_cooldown > world.time)
		return

	heal_tick = world.time

	// Slow tissue rejuvination while dead.
	infectee.heal_overall_damage(0.5, 0.5)
	infectee.adjustCloneLoss(-0.25)
	infectee.adjustToxLoss(-0.5)
	infectee.adjustOxyLoss(-0.5)
	var/obj/item/organ/internal/brain/sponge = infectee.internal_organs_by_name[O_BRAIN]
	if(sponge && sponge.damage < sponge.max_damage * 0.95)
		infectee.adjustBrainLoss(0.5) //Minor brain damage. Guaranteed minimum of 15 (0.5 x 30) brain damage per death. Can go up to 95% of the brain's max damage.
	if(infectee.vessel.total_volume < infectee.vessel.maximum_volume)
		infectee.vessel.add_reagent(REAGENT_ID_BLOOD, 1)
	for(var/obj/item/organ/external/limb in infectee.bad_external_organs)
		limb.germ_level = max(0, limb.germ_level - 25)
		if(limb.status & ORGAN_DEAD && (limb.damage < limb.is_broken()) && (limb.germ_level < INFECTION_LEVEL_ONE)) //If we have any dead organs, try to revive them.
			limb.status = 0

	//Big checks to see if there's a reason we CAN'T revive.
	if(!check_for_valid_revival(infectee))
		return
	//If we pass our checks, let's go ahead and revive!
	revive(infectee)

///Revive proc shamelessly stolen from /datum/modifier/redspace_corruption
/datum/symptom/necroa/proc/revive(mob/living/carbon/human/M)
	//Force us back into the body.
	M.grab_ghost(TRUE)

	//Defib stuff here.
	GLOB.dead_mob_list.Remove(M)
	if((M in GLOB.living_mob_list) || (M in GLOB.dead_mob_list))
		WARNING("Mob [M] was revived but already in the living or dead list still!")
	GLOB.living_mob_list += M
	M.reagents.add_reagent(REAGENT_ID_ZOMBIEPOWDER, 4, can_dialysis = FALSE) //So we don't immediately give away we revived.
	M.set_stat(UNCONSCIOUS) //Life() can bring them back to consciousness if it needs to.
	M.failed_last_breath = 0 //So mobs that died of oxyloss don't revive and have perpetual out of breath.
	M.reload_fullscreen()

	//Awaken!
	M.timeofdeath = 0
	M.tod = null
	M.updatehealth()
	time_since_revival = world.time
	been_revived = TRUE

///Returns TRUE if we can be revived, FALSE if we can not.
/datum/symptom/necroa/proc/check_for_valid_revival(mob/living/carbon/human/infectee)
	if(time_since_revival + revival_cooldown > world.time) //On cooldown.
		return FALSE
	if(infectee.timeofdeath + revival_cooldown > world.time) //Don't immediately revive.
		return FALSE
	if(infectee.health <= -(infectee.getMaxHealth() * 0.33)) //Too injured to revive. We want to be a bit JUST before hardcrit.
		return FALSE
	if(infectee.check_vital_organs()) //Missing a vital organ.
		return FALSE
	if(infectee.teleop) //Aghosted or the sort.
		return FALSE
	if(!infectee.mind) //Mind is gone.
		return FALSE
	return TRUE
