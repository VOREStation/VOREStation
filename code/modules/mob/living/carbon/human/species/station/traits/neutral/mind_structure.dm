/* Used twofold:
 * One, for scenes where someone is using dominate-pred and they don't want to easily be detected who is in control at what time.
 * Two, for characters that aren't exactly 'normal' in the sense of a singular mind and their body structure would accompany this. (Think Diona)
 * Additionally, changelings will appear as though they have this trait.
*/
/datum/trait/abnormal_mind
	name = "Unique Mind-structure"
	desc = "Your body's neurological structure is unusual, causing sleevemates to have difficulty in identifying any minds within your body as a proper match!"
	cost = 0

	can_take = ORGANICS|SYNTHETICS
	category = TRAIT_TYPE_NEUTRAL


/datum/trait/abnormal_mind/apply(datum/species/S, mob/living/carbon/human/H, trait_prefs)
	..()
	ADD_TRAIT(H, UNIQUE_MINDSTRUCTURE, ROUNDSTART_TRAIT)
