/obj/item/organ/internal/liver
	name = "liver"
	icon_state = "liver"
	organ_tag = "liver"
	parent_organ = BP_GROIN

/obj/item/organ/internal/liver/process()
	..()
	if(!iscarbon(owner)) return

	if(owner.life_tick % PROCESS_ACCURACY == 0)

		//High toxins levels are dangerous
		if(owner.getToxLoss() >= 50 && !owner.reagents.has_reagent(REAGENT_ID_ANTITOXIN))
			//Healthy liver suffers on its own
			if (src.damage < min_broken_damage)
				src.damage += 0.2 * PROCESS_ACCURACY
			//Damaged one shares the fun
			else
				var/obj/item/organ/internal/O = pick(owner.internal_organs)
				if(O)
					O.damage += 0.2  * PROCESS_ACCURACY

		//Detox can heal small amounts of damage
		if (src.damage && src.damage < src.min_bruised_damage && owner.reagents.has_reagent(REAGENT_ID_ANTITOXIN))
			src.damage -= 0.2 * PROCESS_ACCURACY

		if(src.damage < 0)
			src.damage = 0

		// Get the effectiveness of the liver.
		var/filter_effect = 3
		if(is_bruised())
			filter_effect -= 1
		if(is_broken())
			filter_effect -= 2

		// Do some reagent processing.
		if(owner.chem_effects[CE_ALCOHOL_TOXIC])
			take_damage(owner.chem_effects[CE_ALCOHOL_TOXIC] * 0.1 * PROCESS_ACCURACY, prob(1)) // Chance to warn them
			if(filter_effect < 2)	//Liver is badly damaged, you're drinking yourself to death
				owner.adjustToxLoss(owner.chem_effects[CE_ALCOHOL_TOXIC] * 0.2 * PROCESS_ACCURACY)
			if(filter_effect < 3)
				owner.adjustToxLoss(owner.chem_effects[CE_ALCOHOL_TOXIC] * 0.1 * PROCESS_ACCURACY)

/obj/item/organ/internal/liver/handle_germ_effects()
	. = ..() //Up should return an infection level as an integer
	if(!.) return

	//Pyogenic Abscess
	if (. >= 1)
		if(prob(1))
			owner.custom_pain("There's a sharp pain in your upper-right abdomen!",1)
	if (. >= 2)
		if(prob(1) && owner.getToxLoss() < owner.getMaxHealth()*0.3)
			//to_chat(owner, "") //Toxins provide their own messages for pain
			owner.adjustToxLoss(5) //Not realistic to PA but there are basically no 'real' liver infections

/obj/item/organ/internal/liver/grey
	icon_state = "liver_grey"

/obj/item/organ/internal/liver/grey/colormatch/Initialize(mapload, internal)
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/item/organ/internal/liver/grey/colormatch/LateInitialize()
	. = ..()
	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		color = H.species.blood_color
