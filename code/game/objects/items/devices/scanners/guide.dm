/obj/item/healthanalyzer/verb/toggle_guide()
	set name = "Toggle Guidance"
	set desc = "Toggles whether or not \the [src] will provide guidance and instruction in addition to scanning."
	set category = "Object"
	guide = !guide
	to_chat(usr, span_notice("You toggle \the [src]'s guidance system [guide ? "on" : "off"]."))


/obj/item/healthanalyzer/guide
	name = "Instructional health analyzer"
	desc = "A hand-held body scanner able to distinguish vital signs of the subject. It shows extra information to medical personnel!"
	guide = TRUE
	icon_state = "health-g"

/obj/item/healthanalyzer/proc/guide(var/mob/living/carbon/human/M, mob/living/user)

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

	var/blood_volume = M.vessel.get_reagent_amount("blood")
	if(blood_volume <= M.species.blood_volume*M.species.blood_level_safe)
		bloodloss = TRUE

	if(bleeding_external)
		dat += "<b>Surface bleeding</b> - Bandage immediately or apply brute-damage fixing chemicals (i.e. Bicaridine) if no bandages available.<br>"
	if(bleeding_internal)
		dat += "<b>Internal bleeding</b> - Commence internal vein repair surgery or apply clotting chemicals (i.e. Myelamine).<br>"
	if(M.getOxyLoss())
		dat += "<b>Suffociation</b> - Give Dexalin or Dexalin Plus. Check for heart or lung damage.<br>"
	if(infection)
		dat += "<b>Infection</b> - Give Spaceacillin. If severe, use Corophizine or overdose on Spaceacillin and monitor until well.<br>"
	if(M.getBrainLoss() >= 1)
		dat += "<b>Brain damage</b> - Commence brain repair surgery, apply Alkysine, or universal organ-repair chemicals. (i.e. Peridaxon).<br>"
	if(M.radiation || M.accumulated_rads)
		dat += "<b>Radiation</b> - Give Hyronalin or Arithrazine. Monitor for genetic damage.<br>"
	if(organ)
		dat += "<b>Organ damage</b> - Give Peridaxon. Perform full body scan for targeted organ repair surgery.<br>"
	if(bloodloss)
		dat += "<b>Low blood volume</b> - Commence blood transfusion via IV drip or provide blood-restorative chemicals (e.g.: Copper for zorren and skrell, iron for the rest)."
	if(M.getToxLoss())
		dat += "<b>Toxins</b> - Give Dylovene or Carthatoline. Vomitting is normal and helpful. Tends to be a symptom of larger issues, such as infection.<br>"
	if(M.getBruteLoss())
		dat += "<b>Brute trauma</b> - Bandage wounded body part. Give Bicaridine or Vermicetol.<br>"
	if(M.getFireLoss())
		dat += "<b>Surface burn</b> - Salve wounded body part in ointment. Give Kelotane or Dermaline. Check for infections.<br>"
	if(M.getCloneLoss())
		dat += "<b>Genetic damage</b> - Utilize cryogenic pod with appropriate chemicals (i.e. Cryoxadone) and below 70 K, or give Rezadone.<br>"
	if(bone)
		dat += "<b>Bone fracture</b> - Splint damaged area. Treat with bone repair surgery or Osteodaxon after treating brute damage.<br>"
	if(M.virus2.len)
		dat += "<b>Viral infection</b> - Proceed with virology pathogen curing procedures or apply antiviral chemicals (i.e. Corophizine).<br>"
	if(robotparts)
		dat += "<b>Robotic body parts</b> - Should not be repaired by medical personnel, refer to robotics if damaged."

	var/peeb
	if(dat)
		peeb +="<span class='notice'><b>GUIDANCE SYSTEM BEGIN</b></span><br>"
		peeb += dat
		peeb += span_notice("For more detailed information about patient condition, use the stationary scanner in medbay.")

	user.show_message(peeb, 1)
