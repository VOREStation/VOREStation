/datum/symptom/robotic_adaptation
	name = "Biometallic Replication"
	desc = "The virus can manipulate metal and silicate compounds, becoming able to infect robotic beings."
	stealth = 0
	resistance = 1
	stage_speed = 4
	transmission = -1
	level = 9
	severity = 0
	symptom_delay_min = 20 SECONDS
	symptom_delay_max = 50 SECONDS
	prefixes = list("Robo")
	bodies = list("Robot")
	suffixes = list("-217")

	var/replaceorgans = FALSE
	var/replacebody = FALSE
	//var/robustbits = FALSE

	threshold_descs = list(
		"Stage Speed 4" = "The virus will replace the host's organic organs with mundane, biometallic versions.",
		"Resistance 4" = "The virus will eventually convert the host's entire body to biometallic materials, and maintain its cellular integrity.",
		//"Stage Speed 12" = "Biometallic mass created by the virus will be superior to typical organic mass." TODO: Some fancy organs.
	)

/datum/symptom/robotic_adaptation/OnAdd(datum/disease/advance/A)
	A.virus_modifiers |= INFECT_SYNTHETICS

/datum/symptom/robotic_adaptation/severityset(datum/disease/advance/A)
	. = ..()
	if(A.stage_rate >= 4)
		severity += 1
		/*
		if(A.stage_rate >= 12)
			severity -= 3
		*/
	if(A.resistance >= 4)
		severity += 1

/datum/symptom/robotic_adaptation/Start(datum/disease/advance/A)
	. = ..()
	if(A.stage_rate >= 4)
		replaceorgans = TRUE
	if(A.resistance >= 4)
		replacebody = TRUE
	/*
	if(A.stage_rate >= 12)
		robustbits = TRUE
	*/

/datum/symptom/robotic_adaptation/Activate(datum/disease/advance/A)
	if(!..())
		return
	var/mob/living/carbon/human/H = A.affected_mob
	switch(A.stage)
		if(3, 4)
			if(replaceorgans && H.stat != DEAD)
				to_chat(H, span_warning("[pick("You feel a grinding pain in your abdomen.", "You exhale a jet of steam.")]"))
		if(5)
			if(replaceorgans || replacebody)
				Replace(H)
	return

/datum/symptom/robotic_adaptation/proc/Replace(mob/living/carbon/human/H)
	if(!H.allow_spontaneous_tf) // Bwomp.
		return FALSE

	if(replaceorgans)
		var/obj/item/organ/internal/O = pick(H.internal_organs)
		if(O.robotic >= ORGAN_ROBOT)
			return FALSE
		switch(O)
			if(/obj/item/organ/internal/brain)
				var/obj/item/organ/internal/brain/brain = O
				brain.robotize()
				return TRUE
			if(/obj/item/organ/internal/eyes)
				var/obj/item/organ/internal/eyes/eyes = O
				if(prob(40) && H.stat != DEAD)
					to_chat(H, span_userdanger("You feel a stabbing pain in your eyeballs!"))
					H.emote("scream")
				eyes.robotize()
				return TRUE
			if(/obj/item/organ/internal/heart)
				var/obj/item/organ/internal/heart/heart = O
				heart.robotize()
				if(prob(40) && H.stat != DEAD)
					to_chat(H, span_userdanger("You feel a stabbing pain in your chest!"))
					H.emote("scream")
				return TRUE
			if(/obj/item/organ/internal/stomach)
				var/obj/item/organ/internal/stomach/stomach = O
				stomach.robotize()
				if(prob(40) && H.stat != DEAD)
					to_chat(H, span_userdanger("You feel a stabbing pain in your abdomen!"))
					H.emote("scream")
				return TRUE
			if(/obj/item/organ/internal/lungs)
				var/obj/item/organ/internal/lungs/lungs = O
				lungs.robotize()
				return TRUE
			if(/obj/item/organ/internal/liver)
				var/obj/item/organ/internal/liver/liver = O
				liver.robotize()
				if(prob(40) && H.stat != DEAD)
					to_chat(H, span_userdanger("You feel a stabbing pain in your abdomen!"))
					H.emote("scream")
				return TRUE
			if(/obj/item/organ/internal/intestine)
				var/obj/item/organ/internal/intestine/intestine = O
				intestine.robotize()
				return TRUE
			if(/obj/item/organ/internal/spleen)
				var/obj/item/organ/internal/spleen/spleen = O
				spleen.robotize()
				return TRUE
			if(/obj/item/organ/internal/kidneys)
				var/obj/item/organ/internal/kidneys/kidneys = O
				kidneys.robotize()
				return TRUE
	if(replacebody) // No need to overcomplicate this one
		var/obj/item/organ/external/O = pick(H.organs)
		if(O.robotic >= ORGAN_ROBOT)
			return FALSE
		if(O)
			O.robotize()
			H.visible_message(span_danger("[H]'s \the [O] shifts, and becomes metal before your very eyes."), span_userdanger("Your \the [O] feels numb, and cold."))
			return TRUE
	return FALSE

/datum/symptom/robotic_adaptation/End(datum/disease/advance/A)
	if(!..())
		return
	var/mob/living/carbon/human/H = A.affected_mob
	if(A.stage >= 5 && (replaceorgans || replacebody))
		if(H.stat != DEAD)
			to_chat(H, span_userdanger("You feel lighter and metallic, as your innards lose their silicon facade."))

/datum/symptom/robotic_adaptation/OnRemove(datum/disease/advance/A)
	A.virus_modifiers &= ~INFECT_SYNTHETICS
