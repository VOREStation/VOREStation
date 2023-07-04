/obj/item/device/healthanalyzer
	var/guide = FALSE

/obj/item/device/healthanalyzer/verb/toggle_guide()
	guide = !guide
	to_chat(usr, "<span class='notice'>You toggle \the [src]'s guidance system.</span>")


/obj/item/device/healthanalyzer/guide
	name = "Instructional health analyzer"
	desc = "It shows extra information to medical personel!"
	guide = TRUE

/obj/item/device/healthanalyzer/proc/guide(var/mob/living/carbon/human/M, mob/living/user)

	var/obj/item/weapon/card/id/ourid = user?.GetIdCard()
	if(!ourid)
		return
	if(access_change_ids in ourid.access)
		playsound(src, 'sound/machines/defib_failed.ogg', 50, 0)
		return
	if(access_medical in ourid.access)
		playsound(src, 'sound/effects/pop.ogg', 50, FALSE)
	else
		playsound(src, 'sound/machines/defib_failed.ogg', 50, 0)

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

	for(var/obj/item/organ/org in M.organs)
		if(org.robotic >= ORGAN_ROBOT)
			robotparts = TRUE
			continue
		if(istype(org,/obj/item/organ/external))
			var/obj/item/organ/external/e = org
			if(e.status & ORGAN_BLEEDING)
				bleeding_external = TRUE
			if(e.status & ORGAN_BROKEN && (!e.splinted))
				bone = TRUE
		if(istype(org,/obj/item/organ/internal))
			if(org.status & ORGAN_BLEEDING)
				bleeding_internal = TRUE
			if(org.damage)
				organ = TRUE
		if(org.germ_level > INFECTION_LEVEL_ONE)
			infection = TRUE

	var/blood_volume = M.vessel.get_reagent_amount("blood")
	if(blood_volume <= M.species.blood_volume*M.species.blood_level_safe)
		bloodloss = TRUE

	if(bleeding_external)
		dat += "<b>Surface bleeding</b> - Bandage immediately or apply brute-damage fixing chemicals (i.e. Bicaridine) if no bandages available.<br>"
	if(bleeding_internal && (advscan >= 1 && showadvscan == 1))
		dat += "<b>Internal bleeding</b> - Commence internal vein repair surgery or apply clotting chemicals (i.e. Myelamine).<br>"
	if(M.getOxyLoss())
		dat += "<b>Suffociation</b> - Give Dexalin or Dexaline Plus. Check for heart or lung damage.<br>"
	if(infection)
		dat += "<b>Infection</b> - Give Spaceacilin. If severe, overdose on Spaceacilin and monitor until well.<br>"
	if((M.getBrainLoss() >= 1 && advscan >= 2 && showadvscan == 1) || M.getBrainLoss() >= 10)
			dat += "<b>Brain damage</b> - Commence brain repair surgery, apply Alkysine, or universal organ-repair chemicals. (i.e. Peridaxon)<br>"
	if(M.radiation || M.accumulated_rads)
		dat += "<b>Radiation</b> - Give Hyroanlin or Arithazine. Monitor for genetic damage.<br>"
	if(organ && (advscan >= 1 && showadvscan == 1))
		dat += "<b>Organ damage</b> - Give Peridaxon. Perform full body scan for targetted organ repair surgery.<br>"
	if(bloodloss)
		dat += "<b>Low blood volume</b> - Commence blood transfusion via IV drip or provide blood-restorative chemicals (i.e. Iron)."
	if(M.getToxLoss())
		dat += "<b>Toxins</b> - Give Dylovene or Cartholine. Vomitting is normal and helpful. Tends to be a symptom of larger issues, such as infection.<br>"
	if(M.getBruteLoss())
		dat += "<b>Brute Trauma</b> - Bandage wounded body part. Give Bicaridine or Vermicetol.<br>"
	if(M.getFireLoss())
		dat += "<b>Surface burn</b> - Salve wounded body part in ointment. Give Kelotane or Dermaline. Check for infections.<br>"
	if(M.getCloneLoss())
		dat += "<b>Genetic damage</b> - Utilize cryogenic pod with appropriate chemicals (i.e. Cryoxadone) and below 70 K, or give Rezadone.<br>"
	if(bone)
		dat += "<b>Bone fracture</b> - Splint damaged area. Treat with bone repair surgery or Osteodaxon after treating brute damage.<br>"
	if(M.virus2.len)
		dat += "<b>Viral infection</b> - Proceed with virology pathogen curing procedures or apply antiviral chemicals (i.e. Corophizine)<br>"
	if(robotparts)
		dat += "<b>Robotic body parts</b> - Should not be repaired by medical personnel, refer to robotics if damaged."

	var/peeb
	if(dat)
		peeb +="<span class='notice'><b>GUIDANCE SYSTEM BEGIN</b></span><br>"
		peeb += dat


	user.show_message(peeb, 1)
