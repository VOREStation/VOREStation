// Ripper tool. This is only for harming the patient or (in organs_internal.dm) ripping out an organ.
// This means if you want to torture someone, do medical malpractice, or harm a fresh sleeve for teaching medical, you can.

/datum/surgery_step/generic/ripper //This is the base which should never be seen.
	surgery_name = "Ripper Tool"

	priority = 3

	blood_level = 99 //Ripper sugery gets you super bloody.

	min_duration = 60
	max_duration = 80
	excludes_steps = list(/datum/surgery_step/generic/cut_open) //These things can already do the first step!

/datum/surgery_step/generic/ripper/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/weapon/surgical/scalpel/ripper/tool)

	if (!..())
		return 0

	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	if(!istype(tool)) //Only rippers can use the ripper!
		return 0

	if(affected.robotic >= ORGAN_ROBOT) //You can't damage robutts.
		return 0

	return affected && affected.open != 0 && target_zone != O_MOUTH //Have to cut them open at a minimum.

/datum/surgery_step/generic/ripper/tear_vessel
	surgery_name = "Tear Blood Vessel"
	allowed_tools = list(
	/obj/item/weapon/surgical/scalpel/ripper = 100
	)

/datum/surgery_step/generic/ripper/tear_vessel/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("[user] starts ripping into [target] with \the [tool].", \
	"You start ripping into [target] with \the [tool].")
	target.custom_pain("[user] is  ripping into your [target.op_stage.current_organ]!", 100)
	..()

/datum/surgery_step/generic/ripper/tear_vessel/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='notice'>[user] has ripped [target]'s [affected] \the [tool], blood and viscera spraying everywhere!</span>", \
	"<span class='notice'>You have ripped [target]'s [target.op_stage.current_organ] out with \the [tool], spraying blood all through the room!</span>")
	var/datum/wound/internal_bleeding/I = new (30) //splurt. New severed artery.
	affected.wounds += I
	affected.owner.custom_pain("You feel something rip in your [affected.name]!", 1)
	target.drip(30) //Lose a lot of blood.
	new /obj/effect/gibspawner/human(target.loc,target.dna,target.species.flesh_color,target.species.blood_color) //SPLAT.
	target.emote("scream") //Hope you put them under...

/datum/surgery_step/generic/ripper/tear_vessel/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='warning'>[user]'s hand slips, damaging [target]'s [affected.name] with \the [tool]!</span>", \
	"<span class='warning'>Your hand slips, damaging [target]'s [affected.name] with \the [tool]!</span>")
	affected.createwound(BRUISE, 20) //Only bruised...Sad.


//Break Bone
/datum/surgery_step/generic/ripper/break_bone
	surgery_name = "Break Skeletal Structure"
	allowed_tools = list(
	/obj/item/weapon/surgical/scalpel/ripper = 100
	)

/datum/surgery_step/generic/ripper/break_bone/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("[user] starts violently shifting \the [tool] in [target]'s [affected.name]!", \
	"You start violently moving the [tool] in [target]'s [affected.name]!")
	target.custom_pain("[user] is ripping into your [target.op_stage.current_organ]!", 100)
	..()

/datum/surgery_step/generic/ripper/break_bone/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='notice'>[user] has destroyed the bones within [target]'s [affected] with \the [tool]</span>", \
	"<span class='notice'>You have destroyed the bones in [target]'s [affected] with \the [tool]!</span>")
	affected.fracture()
	affected.createwound(BRUISE, 20)
	target.emote("scream") //Hope you put them under...

/datum/surgery_step/generic/ripper/tear_vessel/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='warning'>[user]'s hand slips, damaging [target]'s [affected.name] with \the [tool]!</span>", \
	"<span class='warning'>Your hand slips, damaging [target]'s [affected.name] with \the [tool]!</span>")
	affected.createwound(BRUISE, 20)

//Mutilate Organ

/datum/surgery_step/generic/ripper/destroy_organ
	surgery_name = "Mutilate Organ"
	allowed_tools = list(
	/obj/item/weapon/surgical/scalpel/ripper = 100
	)

/datum/surgery_step/generic/ripper/destroy_organ/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (!..())
		return 0

	var/list/removable_organs = list()
	for(var/organ in target.internal_organs_by_name)
		var/obj/item/organ/internal/I = target.internal_organs_by_name[organ]
		if(istype(I) && I.parent_organ == target_zone)
			removable_organs |= organ

	if(!removable_organs.len)
		return 0
	return ..()

/datum/surgery_step/generic/ripper/destroy_organ/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)

	var/list/removable_organs = list()
	for(var/organ in target.internal_organs_by_name)
		var/obj/item/organ/internal/I = target.internal_organs_by_name[organ]
		if(istype(I) && I.parent_organ == target_zone)
			removable_organs |= organ

	var/organ_to_destroy = tgui_input_list(user, "Which organ do you want to mutilate?", "Organ Choice", removable_organs)

	if(!organ_to_destroy) //They decided to cancel. Let's slowly pull the tool back...
		to_chat(user, "<span class='warning'>You decide against mutilating any organs.</span>")
		user.visible_message("[user] starts pulling their [tool] out from [target]'s [affected.name] with \the [tool].", \
		"You start pulling your \the [tool] out of [target]'s [affected.name].")
		target.custom_pain("Someone's moving something around in your [affected.name]!", 100)
	else if(organ_to_destroy)
		target.op_stage.current_organ = organ_to_destroy
		user.visible_message("[user] starts ripping into [target]'s [target.op_stage.current_organ] with \the [tool].", \
		"You start ripping [target]'s [target.op_stage.current_organ] with \the [tool].")
		target.custom_pain("Someone's ripping out your [target.op_stage.current_organ]!", 100)
	..()


/datum/surgery_step/generic/ripper/destroy_organ/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(!target.op_stage.current_organ)
		user.visible_message("<span class='notice'>[user] has pulled their \the [tool] from [target]'s [affected.name].</span>", \
		"<span class='notice'>You have pulled your [tool] out from [target]'s [affected].</span>")

	// Damage the organ!
	if(target.op_stage.current_organ)
		user.visible_message("<span class='notice'>[user] has ripped [target]'s [target.op_stage.current_organ] out with \the [tool].</span>", \
		"<span class='notice'>You have ripped [target]'s [target.op_stage.current_organ] out with \the [tool].</span>")
		var/obj/item/organ/O = target.internal_organs_by_name[target.op_stage.current_organ]
		if(O && istype(O))
			O.take_damage(10)
		target.op_stage.current_organ = null
		new /obj/effect/gibspawner/human(target.loc,target.dna,target.species.flesh_color,target.species.blood_color)
		target.emote("scream")

/datum/surgery_step/generic/ripper/destroy_organ/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='warning'>[user]'s hand slips, damaging [target]'s [affected.name] with \the [tool]!</span>", \
	"<span class='warning'>Your hand slips, damaging [target]'s [affected.name] with \the [tool]!</span>")
	affected.createwound(BRUISE, 20)

///////////////////////////////////////////////////////////////
// Organ Ripping Surgery
///////////////////////////////////////////////////////////////

/datum/surgery_step/generic/ripper/rip_organ
	surgery_name = "Rip Out Organ"

	allowed_tools = list(
	/obj/item/weapon/surgical/scalpel/ripper = 100
	)

	priority = 3

	blood_level = 3

	min_duration = 60
	max_duration = 80
	excludes_steps = list(/datum/surgery_step/generic/cut_open)

/datum/surgery_step/generic/ripper/rip_organ/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (!..())
		return 0

	var/list/removable_organs = list()
	for(var/organ in target.internal_organs_by_name)
		var/obj/item/organ/internal/I = target.internal_organs_by_name[organ]
		if(istype(I) && I.parent_organ == target_zone)
			removable_organs |= organ

	if(!removable_organs.len)
		return 0

	return ..()

/datum/surgery_step/generic/ripper/rip_organ/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	var/list/removable_organs = list()
	for(var/organ in target.internal_organs_by_name)
		var/obj/item/organ/internal/I = target.internal_organs_by_name[organ]
		if(istype(I) && I.parent_organ == target_zone)
			removable_organs |= organ

	var/organ_to_remove = tgui_input_list(user, "Which organ do you want to tear out?", "Organ Choice", removable_organs)
	if(!organ_to_remove) //They decided to cancel. Let's slowly pull the tool back...
		to_chat(user, "<span class='warning'>You decide against ripping out any organs.</span>")
		user.visible_message("[user] starts pulling their [tool] out from [target]'s [affected.name] with \the [tool].", \
		"You start pulling your \the [tool] out of [target]'s [affected.name].")
		target.custom_pain("Someone's moving something around in your [affected.name]!", 100)
	else if(organ_to_remove)
		target.op_stage.current_organ = organ_to_remove
		user.visible_message("[user] starts ripping [target]'s [target.op_stage.current_organ] out with \the [tool].", \
		"You start ripping [target]'s [target.op_stage.current_organ] out with \the [tool].")
		target.custom_pain("Someone's ripping out your [target.op_stage.current_organ]!", 100)
	..()

/datum/surgery_step/generic/ripper/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(!target.op_stage.current_organ)
		user.visible_message("<span class='notice'>[user] has pulled their \the [tool] from [target]'s [affected.name].</span>", \
		"<span class='notice'>You have pulled your [tool] out from [target]'s [affected].</span>")

	if(target.op_stage.current_organ)
		user.visible_message("<span class='notice'>[user] has ripped [target]'s [target.op_stage.current_organ] out with \the [tool].</span>", \
		"<span class='notice'>You have ripped [target]'s [target.op_stage.current_organ] out with \the [tool].</span>")
		var/obj/item/organ/O = target.internal_organs_by_name[target.op_stage.current_organ]
		if(O && istype(O))
			O.removed(user)
		target.op_stage.current_organ = null
		new /obj/effect/gibspawner/human(target.loc,target.dna,target.species.flesh_color,target.species.blood_color)
		target.emote("scream")

/datum/surgery_step/internal/rip_organ/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='warning'>[user]'s hand slips, damaging [target]'s [affected.name] with \the [tool]!</span>", \
	"<span class='warning'>Your hand slips, damaging [target]'s [affected.name] with \the [tool]!</span>")
	affected.createwound(BRUISE, 20)
