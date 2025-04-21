/datum/symptom/light
	name = "Photosensitive muscle condensation"
	desc = "The virus will cause muscles to contract when exposed to light, resulting in lowered speed, but increased durability. Muscles will become more malleable in the darkness, resulting in the host moving faster, but being more easily bruised."
	stealth = 0
	resistance = 2
	stage_speed = -3
	transmission = 0
	level = 8
	severity = -2
	var/currenthealthmodifier
	threshold_descs = list(
		"Stealth 3" = "The virus causes a wider disparity between light and dark."
	)

/datum/symptom/light/severityset(datum/disease/advance/A)
	. = ..()
	if(A.stealth >= 3)
		severity -= 1

/datum/symptom/light/Start(datum/disease/advance/A)
	if(!..())
		return
	if(A.stealth >= 3)
		power = 2

/datum/symptom/light/Activate(datum/disease/advance/A)
	if(!..())
		return
	var/mob/living/carbon/human/H = A.affected_mob
	if(H.stat >= DEAD)
		return
	var/realpower = power
	var/healthchange = min(1 * realpower, (10 * realpower) - currenthealthmodifier)
	if(isturf(H.loc))
		var/turf/T = H.loc
		var/light_amount = min(1, T.get_lumcount()) - 0.5
		if(light_amount < 0.5)
			realpower = power * -1
			healthchange = max(1 * realpower, (10 * realpower) - currenthealthmodifier)
			if(prob(5))
				to_chat(H, span_warning(pick("You feel vulnerable.", "Your limbs feel loose and limber.", "The dark makes you feel realxed.")))
		else if(prob(5))
			to_chat(H, span_warning(pick("Your muscles feel tight.", "You feel lethargic.", "Your muscles feel hard and tough.")))
	if(A.stage >= 5)
		currenthealthmodifier += healthchange
		H.maxHealth += healthchange
		H.health += healthchange

/datum/symptom/light/End(datum/disease/advance/A)
	. = ..()
	var/mob/living/carbon/human/H = A.affected_mob
	H.maxHealth -= currenthealthmodifier
	H.health -= currenthealthmodifier
