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

	if(is_broken())
		if(prob(4))
			owner.automatic_custom_emote(VISIBLE_MESSAGE, "coughs up a large amount of blood!", check_stat = TRUE)
			var/bleeding_rng = rand(3,5)
			owner.drip(bleeding_rng)
		if(prob(8)) //This is a medical emergency. Will kill within minutes unless exceedingly lucky.
			owner.automatic_custom_emote(VISIBLE_MESSAGE, "gasps for air!", check_stat = TRUE)
			owner.AdjustLosebreath(15)

	else if(is_bruised()) //Only bruised? That's an annoyance and can cause some more damage (via brainloss due to oxyloss)
		if(prob(2)) //But let's not kill people too quickly.
			owner.automatic_custom_emote(VISIBLE_MESSAGE, "coughs up a small amount of blood!", check_stat = TRUE)
			var/bleeding_rng = rand(1,2)
			owner.drip(bleeding_rng)
		if(prob(4)) //Get to medical quickly. but shouldn't kill without exceedingly bad RNG.
			owner.automatic_custom_emote(VISIBLE_MESSAGE, "gasps for air!", check_stat = TRUE)
			owner.AdjustLosebreath(10) //Losebreath is a DoT that does 1:1 damage and prevents oxyloss healing via breathing.

	if(owner.internal_organs_by_name[O_BRAIN]) // As the brain starts having Trouble, the lungs start malfunctioning.
		var/obj/item/organ/internal/brain/Brain = owner.internal_organs_by_name[O_BRAIN]
		if(Brain.get_control_efficiency() <= 0.8)
			if(prob(4 / max(0.1,Brain.get_control_efficiency())))
				owner.automatic_custom_emote(VISIBLE_MESSAGE, "gasps for air!", check_stat = TRUE)
				owner.AdjustLosebreath(round(3 / max(0.1,Brain.get_control_efficiency())))

/obj/item/organ/internal/lungs/proc/rupture()
	if(owner && damage < min_bruised_damage) //Anti spam prevention.
		var/obj/item/organ/external/parent = owner.get_organ(parent_organ)
		if(istype(parent))
			owner.custom_pain("You feel a stabbing pain in your [parent.name]!", 50)
	bruise()

/obj/item/organ/internal/lungs/handle_germ_effects()
	. = ..() //Up should return an infection level as an integer
	if(!. || !owner) return

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

/obj/item/organ/internal/lungs/grey/colormatch/Initialize(mapload, internal)
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/item/organ/internal/lungs/grey/colormatch/LateInitialize()
	. = ..()
	if(owner && ishuman(loc))
		var/mob/living/carbon/human/H = loc
		color = H.species.blood_color
