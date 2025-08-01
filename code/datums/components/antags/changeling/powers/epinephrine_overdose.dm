//Updated
/datum/power/changeling/epinephrine_overdose
	name = "Epinephrine Overdose"
	desc = "We evolve additional sacs of adrenaline throughout our body."
	helptext = "We can instantly recover from stuns and reduce the effect of future stuns, but we will suffer toxicity in the long term.  Can be used while unconscious."
	enhancedtext = "Immunity from most disabling effects for 30 seconds."
	ability_icon_state = "ling_epinepherine_overdose"
	genomecost = 2
	verbpath = /mob/proc/changeling_epinephrine_overdose

/datum/modifier/unstoppable
	name = "unstoppable"
	desc = "We feel limitless amounts of energy surge in our veins.  Nothing can stop us!"

	stacks = MODIFIER_STACK_EXTEND
	on_created_text = span_notice("We feel unstoppable!")
	on_expired_text = span_warning("We feel our newfound energy fade...")
	disable_duration_percent = 0

//Recover from stuns.
/mob/proc/changeling_epinephrine_overdose()
	set category = "Changeling"
	set name = "Epinephrine Overdose (30)"
	set desc = "Removes all stuns instantly, and reduces future stuns."

	var/datum/component/antag/changeling/changeling = changeling_power(30,0,100,UNCONSCIOUS)
	if(!changeling)
		return 0
	changeling.chem_charges -= 30

	var/mob/living/carbon/human/C = src
	to_chat(C, span_notice("Energy rushes through us.  [C.lying ? "We arise." : ""]"))
	C.set_stat(CONSCIOUS)
	C.SetParalysis(0)
	C.SetStunned(0)
	C.SetWeakened(0)
	C.lying = 0
	C.update_canmove()
	C.reagents.add_reagent("epinephrine", 20)

	if(changeling.recursive_enhancement)
		C.add_modifier(/datum/modifier/unstoppable, 30 SECONDS)

	feedback_add_details("changeling_powers","UNS")
	return 1

/datum/reagent/epinephrine
	name = REAGENT_EPINEPHRINE
	id = REAGENT_ID_EPINEPHRINE
	description = "A chemically naturally produced by the body while in fight-or-flight mode. Greatly increases one's strength."
	reagent_state = LIQUID
	color = "#C8A5DC"
	metabolism = REM * 2
	wiki_flag = WIKI_SPOILER
	supply_conversion_value = REFINERYEXPORT_VALUE_RARE
	industrial_use = REFINERYEXPORT_REASON_MATSCI

/datum/reagent/epinephrine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	M.add_chemical_effect(CE_SPEEDBOOST, 3)
	M.add_chemical_effect(CE_PAINKILLER, 60)
	M.adjustHalLoss(-30)
	M.AdjustParalysis(-2)
	M.AdjustStunned(-2)
	M.AdjustWeakened(-2)
	M.adjustToxLoss(removed * 2.5) //It gives you 20units of epinephrine. 50 toxins damage. 1 Toxin per tick.
	..()
	return
