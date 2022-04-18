/obj/item/implant/neural
	name = "neural framework implant"
	desc = "A small metal casing with numerous wires stemming off of it."
	initialize_loc = BP_HEAD
	var/obj/item/organ/internal/brain/my_brain = null
	var/target_state = null
	var/robotic_brain = FALSE

/obj/item/implant/neural/post_implant(var/mob/source)
	if(ishuman(source))
		var/mob/living/carbon/human/H = source
		if(H.species.has_organ[O_BRAIN])
			var/obj/item/organ/internal/brain/possible_brain = H.internal_organs_by_name[O_BRAIN]
			my_brain = possible_brain //Organs will take damage all the same.
			if(istype(possible_brain) && my_brain.can_assist())		//If the brain is infact a brain, and not something special like an MMI.
				my_brain.implant_assist(target_state)
		if(H.isSynthetic() && H.get_FBP_type() != FBP_CYBORG)		//If this on an FBP, it's just an extra inefficient attachment to whatever their brain is.
			robotic_brain = TRUE
	if(istype(my_brain) && my_brain.can_assist())
		START_PROCESSING(SSobj, src)

/obj/item/implant/neural/Destroy()
	if(my_brain)
		if(my_brain.owner)
			to_chat(my_brain.owner, "<span class='critical'>You feel a pressure in your mind as something is ripped away.</span>")
	STOP_PROCESSING(SSobj, src)
	my_brain = null
	return ..()

/obj/item/implant/neural/process()
	if(my_brain && part)
		if(my_brain.loc != part.loc)
			to_chat(my_brain.owner, "<span class='critical'>You feel a pressure in your mind as something is ripped away.</span>")
			meltdown()
	return 1

/obj/item/implant/neural/get_data()
	var/dat = {"<b>Implant Specifications:</b><BR>
<b>Name:</b> Neural Framework Implant<BR>
<b>Life:</b> Duration of Brain Function<BR>
<b>Important Notes:</b> None<BR>
<HR>
<b>Implant Details:</b> <BR>
<b>Function:</b> Maintains some function or structure of the target's brain.<BR>
<b>Special Features:</b><BR>
<i>Neuro-Safe</i>- Specialized shell absorbs excess voltages self-destructing the chip if
a malfunction occurs thereby attempting to secure the safety of subject.<BR>
<b>Integrity:</b> Gradient creates slight risk of being overcharged and frying the
circuitry. Resulting faults can cause damage to the host's brain.<HR>
Implant Specifics:<BR>"}
	return dat

/obj/item/implant/neural/emp_act(severity)
	if(!my_brain)
		return
	if(malfunction)	//Don't malfunction while malfunctioning.
		return
	malfunction = MALFUNCTION_TEMPORARY

	var/delay = 10 //Don't let it just get emped twice in a second to kill someone.
	var/brain_location = my_brain.owner.organs_by_name[my_brain.parent_organ]
	var/mob/living/L = my_brain.owner
	switch(severity)
		if(1)
			if(prob(10))
				meltdown()
			else if(prob(80))
				my_brain.take_damage(5)
				if(!robotic_brain)
					to_chat(L, "<span class='critical'>Something in your [brain_location] burns!</span>")
				else
					to_chat(L, "<span class='warning'>Severe fault detected in [brain_location].</span>")
		if(2)
			if(prob(80))
				my_brain.take_damage(3)
				if(!robotic_brain)
					to_chat(L, "<span class='danger'>It feels like something is digging into your [brain_location]!</span>")
				else
					to_chat(L, "<span class='warning'>Fault detected in [brain_location].</span>")
		if(3)
			if(prob(60))
				my_brain.take_damage(2)
				if(!robotic_brain)
					to_chat(L, "<span class='warning'>There is a stabbing pain in your [brain_location]!</span>")
		if(4)
			if(prob(40))
				my_brain.take_damage(1)
				if(!robotic_brain)
					to_chat(L, "<span class='warning'>Your [brain_location] aches.</span>")

	spawn(delay)
		malfunction--

/obj/item/implant/neural/meltdown()
	..()
	STOP_PROCESSING(SSobj, src)
	var/mob/living/carbon/human/H = null
	if(my_brain && my_brain.owner)
		if(ishuman(my_brain.owner))
			H = my_brain.owner
			if(robotic_brain)
				to_chat(H, "<span class='critical'>WARNING. Fault dete-ct-- in the \the [src].</span>")
			H.Confuse(30)
			H.AdjustBlinded(5)
		my_brain.take_damage(15)
		my_brain = null
	return
