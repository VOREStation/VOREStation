//Updated
//Augmented Eyesight: Gives you thermal vision. Also, higher DNA cost because of how powerful it is.
/datum/power/changeling/augmented_eyesight
	name = "Augmented Eyesight"
	desc = "Creates heat receptors in our eyes and dramatically increases light sensing ability."
	helptext = "Grants us thermal vision. It may be toggled on or off. We will become more vulnerable to flash-based devices while active."
	ability_icon_state = "ling_augmented_eyesight"
	genomecost = 2
	verbpath = /mob/proc/changeling_augmented_eyesight

/mob/proc/changeling_augmented_eyesight()
	set category = "Changeling"
	set name = "Augmented Eyesight (5)"
	set desc = "We evolve our eyes to sense the infrared."
	var/datum/component/antag/changeling/comp = changeling_power(5,0,100,CONSCIOUS)
	if(!comp)
		return 0

	var/mob/living/carbon/human/C = src

	comp.thermal_sight = !comp.thermal_sight

	var/active = comp.thermal_sight

	if(active)
		comp.chem_charges -= 5
		to_chat(C, span_notice("We feel a minute twitch in our eyes, and a hidden layer to the world is revealed."))
		C.add_modifier(/datum/modifier/changeling/thermal_sight, 0, src)
	else
		to_chat(C, span_notice("Our vision dulls."))
		C.remove_modifiers_of_type(/datum/modifier/changeling/thermal_sight)
	return 1
