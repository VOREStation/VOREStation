/obj/item/organ/internal/kidneys
	name = "kidneys"
	icon_state = "kidneys"
	gender = PLURAL
	organ_tag = O_KIDNEYS
	parent_organ = BP_GROIN

/obj/item/organ/internal/kidneys/process()
	..()

	if(!owner) return

	// Coffee is really bad for you with busted kidneys.
	// This should probably be expanded in some way, but fucked if I know
	// what else kidneys can process in our reagent list.
	var/datum/reagent/coffee = locate(/datum/reagent/drink/coffee) in owner.reagents.reagent_list
	if(coffee)
		if(is_bruised())
			owner.adjustToxLoss(0.1 * PROCESS_ACCURACY)
		else if(is_broken())
			owner.adjustToxLoss(0.3 * PROCESS_ACCURACY)

/obj/item/organ/internal/kidneys/handle_organ_proc_special()
	. = ..()

	if(owner && owner.getToxLoss() <= owner.getMaxHealth() * 0.1) // If you have less than 10 tox damage (for a human), your kidneys can help purge it.
		if(prob(owner.getToxLoss()))
			owner.adjustToxLoss(rand(-1,-3))

/obj/item/organ/internal/kidneys/handle_germ_effects()
	. = ..() //Up should return an infection level as an integer
	if(!.) return

	//Pyelonephritis
	if (. >= 1)
		if(prob(1))
			owner.custom_pain("There's a stabbing pain in your lower back!",1)
	if (. >= 2)
		if(prob(1))
			owner.custom_pain("You feel extremely tired, like you can't move!",1)
			owner.m_intent = I_WALK
			owner.hud_used.move_intent.icon_state = "walking"

/obj/item/organ/internal/kidneys/grey
	icon_state = "kidneys_grey"

/obj/item/organ/internal/kidneys/grey/colormatch/Initialize(mapload, internal)
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/item/organ/internal/kidneys/grey/colormatch/LateInitialize()
	. = ..()
	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		color = H.species.blood_color
