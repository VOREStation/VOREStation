/obj/item/healthanalyzer/verb/toggle_guide()
	set name = "Toggle Guidance"
	set desc = "Toggles whether or not the health analyzer will provide guidance and instruction in addition to scanning."
	set category = "Object"
	guide = !guide
	to_chat(usr, span_notice("You toggle \the [src]'s guidance system [guide ? "on" : "off"]."))


/obj/item/healthanalyzer/guide
	name = "Instructional health analyzer"
	desc = "A hand-held body scanner able to distinguish vital signs of the subject. It shows extra information to medical personnel!"
	guide = TRUE
	icon_state = "health-g"

/obj/item/healthanalyzer/proc/guide(var/mob/living/carbon/human/M, mob/living/user)

/* Enable this if you want non-medical users to be blocked from the guide. Kind of pointless, since the only ones that would really NEED the guide are non-medical users.
	var/obj/item/card/id/ourid = user?.GetIdCard()
	if(!ourid)
		return
	if(access_change_ids in ourid.GetAccess())
		playsound(src, 'sound/machines/defib_failed.ogg', 50, 0)
		return
	if(access_medical in ourid.GetAccess())
		playsound(src, 'sound/effects/pop.ogg', 50, FALSE)
	else
		playsound(src, 'sound/machines/defib_failed.ogg', 50, 0)
		return
	if(!ishuman(M))
		return
*/

	var/dat = ""

	var/bleeding_external = FALSE
	var/bleeding_internal = FALSE
	var/infection = FALSE
	var/organ = FALSE
	var/bone = FALSE
	var/bloodloss = FALSE
	var/robotparts = FALSE

	for(var/obj/item/organ/external/org in M.organs)
		if(!istype(org))		//how?
			continue
		if(org.robotic >= ORGAN_ROBOT)
			robotparts = TRUE
			continue
		for(var/datum/wound/W in org.wounds)
			if(W.internal)
				bleeding_internal = TRUE
				break
		if(org.status & ORGAN_BLEEDING)
			bleeding_external = TRUE
		if(org.status & ORGAN_BROKEN && (!org.splinted))
			bone = TRUE
		if(org.has_infected_wound())
			infection = TRUE


	for(var/obj/item/organ/org in M.internal_organs)
		if(!istype(org))		//how?
			continue
		if(org.robotic >= ORGAN_ROBOT)
			robotparts = TRUE
			continue
		if(org.status & ORGAN_BLEEDING)
			bleeding_internal = TRUE
		if(org.damage >= 1 && !istype(org, /obj/item/organ/internal/brain))
			organ = TRUE

	var/blood_volume = M.vessel.get_reagent_amount(REAGENT_ID_BLOOD)
	if(blood_volume <= M.species.blood_volume*M.species.blood_level_safe)
		bloodloss = TRUE

	if(bleeding_external)
		dat += span_bold("Surface Bleeding") + " - Apply bandages or administer Bicaridine.<br>"
	if(bleeding_internal)
		dat += span_bold("Internal Bleeding") + " - Commence an internal vein repair operation or administer coagulants, such as Myelamine.<br>"
	if(M.getOxyLoss())
		dat += span_bold("Suffocation") + " - Administer Dexalin or Dexalin Plus. Check for heart or lung damage.<br>"
	if(infection)
		dat += span_bold("Infection") + " - Administer Spaceacillin. If severe, use Corophizine or overdose on Spaceacillin and monitor until well.<br>"
	if(M.getBrainLoss() >= 1)
		dat += span_bold("Traumatic Brain Injury") + " - Commence brain repair surgery, administer Alkysine or universal organ-repair chemicals such as Peridaxon.<br>"
	if(M.radiation || M.accumulated_rads)
		dat += span_bold("Radiation Exposure") + " - Administer Hyronalin or Arithrazine. Monitor for genetic damage.<br>"
	if(organ)
		dat += span_bold("Organ Damage") + " - Administer Peridaxon. Perform a full body scan for targeted organ repair surgery.<br>"
	if(bloodloss)
		dat += span_bold("Low blood volume") + " - Commence blood transfusion via IV drip or provide blood-restorative chemicals (e.g.: Copper for zorren and skrell, iron for the rest)."
	if(M.getToxLoss())
		dat += span_bold("Toxin Buildup") + " - Inject Dylovene or Carthatoline. Monitor for damage to the liver or kidneys.<br>"
	if(M.getBruteLoss())
		dat += span_bold("Physical Trauma") + " - Bandage the wounded body part. Administer Bicaridine or Vermicetol depending on the severity.<br>"
	if(M.getFireLoss())
		dat += span_bold("Burn Wounds") + " - Salve the wounded body part in ointment. Administer Kelotane or Dermaline. Check for infections.<br>"
	if(M.getCloneLoss())
		dat += span_bold("Genetic Damage") + " - Utilize cryogenic pod with appropriate chemicals (i.e. Cryoxadone) and below 70 K, or give Rezadone.<br>"
	if(bone)
		dat += span_bold("Bone fracture") + " - Splint damaged area. Treat with bone repair surgery or Osteodaxon after treating brute damage.<br>"
	if(M.IsInfected())
		for(var/datum/disease/D in M.GetViruses())
			if(D.visibility_flags & HIDDEN_SCANNER)
				continue
			else
				dat += span_bold("Viral Infection") + " - Inform a Virologist or the Chief Medical Officer and administer antiviral chemicals such as Spaceacillin. Limit exposure to other personnel.<br>"
	if(robotparts)
		dat += span_bold("Robotic Body Parts") + " - Inform the Robotics department."

	var/peeb
	if(dat)
		peeb += span_notice(span_bold("GUIDANCE SYSTEM BEGIN"))
		peeb += "<br>"
		peeb += dat
		peeb += span_notice("For more detailed information on the patient's condition, utilize a body scanner at the closest medical bay.")

	user.show_message(peeb, 1)
