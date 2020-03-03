#define PROCESS_ACCURACY 10

/obj/item/organ/internal/lungs
	name = "lungs"
	icon_state = "lungs"
	gender = PLURAL
	organ_tag = O_LUNGS
	parent_organ = BP_TORSO

/obj/item/organ/internal/lungs/process()
	..()

	if(!owner)
		return

	if(is_bruised())
		if(prob(4))
			spawn owner.emote("me", 1, "coughs up blood!")
			owner.drip(10)
		if(prob(8))
			spawn owner.emote("me", 1, "gasps for air!")
			owner.AdjustLosebreath(15)

	if(owner.internal_organs_by_name[O_BRAIN]) // As the brain starts having Trouble, the lungs start malfunctioning.
		var/obj/item/organ/internal/brain/Brain = owner.internal_organs_by_name[O_BRAIN]
		if(Brain.get_control_efficiency() <= 0.8)
			if(prob(4 / max(0.1,Brain.get_control_efficiency())))
				spawn owner.emote("me", 1, "gasps for air!")
				owner.AdjustLosebreath(round(3 / max(0.1,Brain.get_control_efficiency())))

/obj/item/organ/internal/lungs/proc/rupture()
	var/obj/item/organ/external/parent = owner.get_organ(parent_organ)
	if(istype(parent))
		owner.custom_pain("You feel a stabbing pain in your [parent.name]!", 50)
	bruise()

/obj/item/organ/internal/lungs/handle_germ_effects()
	. = ..() //Up should return an infection level as an integer
	if(!.) return

	//Bacterial pneumonia
	if (. >= 1)
		if(prob(5))
			owner.emote("cough")
	if (. >= 2)
		if(prob(1))
			owner.custom_pain("You suddenly feel short of breath and take a sharp, painful breath!",1)
			owner.adjustOxyLoss(30) //Look it's hard to simulate low O2 perfusion okay

/obj/item/organ/internal/lungs/grey
	icon_state = "lungs_grey"

/obj/item/organ/internal/lungs/grey/colormatch/New()
	..()
	var/mob/living/carbon/human/H = null
	spawn(15)
		if(ishuman(owner))
			H = owner
			color = H.species.blood_color
