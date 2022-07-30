#define DEFIB_TIME_LIMIT (10 MINUTES) //VOREStation addition- past this many seconds, defib is useless.

/obj/item/device/healthanalyzer
	name = "health analyzer"
	desc = "A hand-held body scanner able to distinguish vital signs of the subject."
	icon_state = "health"
	item_state = "healthanalyzer"
	slot_flags = SLOT_BELT
	throwforce = 3
	w_class = ITEMSIZE_SMALL
	throw_speed = 5
	throw_range = 10
	matter = list(MAT_STEEL = 200)
	origin_tech = list(TECH_MAGNET = 1, TECH_BIO = 1)
	var/mode = 1;
	var/advscan = 0
	var/showadvscan = 1

/obj/item/device/healthanalyzer/New()
	if(advscan >= 1)
		verbs += /obj/item/device/healthanalyzer/proc/toggle_adv
	..()

/obj/item/device/healthanalyzer/do_surgery(mob/living/M, mob/living/user)
	if(user.a_intent != I_HELP) //in case it is ever used as a surgery tool
		return ..()
	scan_mob(M, user) //default surgery behaviour is just to scan as usual
	return 1

/obj/item/device/healthanalyzer/attack(mob/living/M, mob/living/user)
	scan_mob(M, user)

/obj/item/device/healthanalyzer/proc/scan_mob(mob/living/M, mob/living/user)
	var/dat = ""
	if ((CLUMSY in user.mutations) && prob(50))
		user.visible_message("<span class='warning'>\The [user] has analyzed the floor's vitals!</span>", "<span class='warning'>You try to analyze the floor's vitals!</span>")
		dat += "Analyzing Results for the floor:<br>"
		dat += "Overall Status: Healthy<br>"
		dat += "\tDamage Specifics: 0-0-0-0<br>"
		dat += "Key: Suffocation/Toxin/Burns/Brute<br>"
		dat += "Body Temperature: ???"
		user.show_message("<span class='notice'>[dat]</span>", 1)
		return
	if (!(ishuman(user) || ticker) && ticker.mode.name != "monkey")
		to_chat(user, "<span class='warning'>You don't have the dexterity to do this!</span>")
		return

	flick("[icon_state]-scan", src)	//makes it so that it plays the scan animation on a succesful scan
	user.visible_message("<span class='notice'>[user] has analyzed [M]'s vitals.</span>","<span class='notice'>You have analyzed [M]'s vitals.</span>")

	if (!ishuman(M) || M.isSynthetic())
		//these sensors are designed for organic life
		dat += "<span class='notice'>Analyzing Results for ERROR:\n\tOverall Status: ERROR<br>"
		dat += "\tKey: <font color='cyan'>Suffocation</font>/<font color='green'>Toxin</font>/<font color='#FFA500'>Burns</font>/<font color='red'>Brute</font><br>"
		dat += "\tDamage Specifics: <font color='cyan'>?</font> - <font color='green'>?</font> - <font color='#FFA500'>?</font> - <font color='red'>?</font><br>"
		dat += "Body Temperature: [M.bodytemperature-T0C]&deg;C ([M.bodytemperature*1.8-459.67]&deg;F)</span><br>"
		dat += "<span class='warning'>Warning: Blood Level ERROR: --% --cl.</span> <span class='notice'>Type: ERROR</span><br>"
		dat += "<span class='notice'>Subject's pulse: <font color='red'>-- bpm.</font></span>"
		user.show_message(dat, 1)
		return

	var/fake_oxy = max(rand(1,40), M.getOxyLoss(), (300 - (M.getToxLoss() + M.getFireLoss() + M.getBruteLoss())))
	var/OX = M.getOxyLoss() > 50 	? 	"<b>[M.getOxyLoss()]</b>" 		: M.getOxyLoss()
	var/TX = M.getToxLoss() > 50 	? 	"<b>[M.getToxLoss()]</b>" 		: M.getToxLoss()
	var/BU = M.getFireLoss() > 50 	? 	"<b>[M.getFireLoss()]</b>" 		: M.getFireLoss()
	var/BR = M.getBruteLoss() > 50 	? 	"<b>[M.getBruteLoss()]</b>" 	: M.getBruteLoss()
	if(M.status_flags & FAKEDEATH)
		OX = fake_oxy > 50 			? 	"<b>[fake_oxy]</b>" 			: fake_oxy
		dat += "<span class='notice'>Analyzing Results for [M]:</span><br>"
		dat += "<span class='notice'>Overall Status: dead</span><br>"
	else
		dat += 	"<span class='notice'>Analyzing Results for [M]:\n\t Overall Status: [M.stat > 1 ? "dead" : "[round((M.health/M.getMaxHealth())*100) ]% healthy"]<br>"
	dat += 		"\tKey: <font color='cyan'>Suffocation</font>/<font color='green'>Toxin</font>/<font color='#FFA500'>Burns</font>/<font color='red'>Brute</font><br>"
	dat += 		"\tDamage Specifics: <font color='cyan'>[OX]</font> - <font color='green'>[TX]</font> - <font color='#FFA500'>[BU]</font> - <font color='red'>[BR]</font><br>"
	dat +=		"Body Temperature: [M.bodytemperature-T0C]&deg;C ([M.bodytemperature*1.8-459.67]&deg;F)</span><br>"
	//VOREStation edit/addition starts
	if(M.timeofdeath && (M.stat == DEAD || (M.status_flags & FAKEDEATH)))
		dat += 	"<span class='notice'>Time of Death: [worldtime2stationtime(M.timeofdeath)]</span><br>"
		var/tdelta = round(world.time - M.timeofdeath)
		if(tdelta < (DEFIB_TIME_LIMIT * 10))
			dat += "<span class='notice'><b>Subject died [DisplayTimeText(tdelta)] ago - resuscitation may be possible!</b></span><br>"
	//VOREStation edit/addition ends
	if(istype(M, /mob/living/carbon/human) && mode == 1)
		var/mob/living/carbon/human/H = M
		var/list/damaged = H.get_damaged_organs(1,1)
		dat += 	"<span class='notice'>Localized Damage, Brute/Burn:</span><br>"
		if(length(damaged)>0)
			for(var/obj/item/organ/external/org in damaged)
				if(org.robotic >= ORGAN_ROBOT)
					continue
				else
					dat += "<span class='notice'>     [capitalize(org.name)]: [(org.brute_dam > 0) ? "<span class='warning'>[org.brute_dam]</span>" : 0]"
					dat += "[(org.status & ORGAN_BLEEDING)?"<span class='danger'>\[Bleeding\]</span>":""] - "
					dat += "[(org.burn_dam > 0) ? "<font color='#FFA500'>[org.burn_dam]</font>" : 0]</span><br>"
		else
			dat += "<span class='notice'>    Limbs are OK.</span><br>"

	OX = M.getOxyLoss() > 50 ? 	 "<font color='cyan'><b>Severe oxygen deprivation detected</b></font>" 		: 	"Subject bloodstream oxygen level normal"
	TX = M.getToxLoss() > 50 ? 	 "<font color='green'><b>Dangerous amount of toxins detected</b></font>" 	: 	"Subject bloodstream toxin level minimal"
	BU = M.getFireLoss() > 50 ?  "<font color='#FFA500'><b>Severe burn damage detected</b></font>" 			:	"Subject burn injury status O.K"
	BR = M.getBruteLoss() > 50 ? "<font color='red'><b>Severe anatomical damage detected</b></font>" 		: 	"Subject brute-force injury status O.K"
	if(M.status_flags & FAKEDEATH)
		OX = fake_oxy > 50 ? 		"<span class='warning'>Severe oxygen deprivation detected</span>" 	: 	"Subject bloodstream oxygen level normal"
	dat += "[OX] | [TX] | [BU] | [BR]<br>"
	if(M.radiation)
		if(advscan >= 2 && showadvscan == 1)
			var/severity = ""
			if(M.radiation >= 75)
				severity = "Critical"
			else if(M.radiation >= 50)
				severity = "Severe"
			else if(M.radiation >= 25)
				severity = "Moderate"
			else if(M.radiation >= 1)
				severity = "Low"
			dat += "<span class='warning'>[severity] levels of radiation detected. [(severity == "Critical") ? " Immediate treatment advised." : ""]</span><br>"
		else
			dat += "<span class='warning'>Radiation detected.</span><br>"
	if(iscarbon(M))
		var/mob/living/carbon/C = M
		if(C.reagents.total_volume)
			var/unknown = 0
			var/reagentdata[0]
			var/unknownreagents[0]
			for(var/datum/reagent/R as anything in C.reagents.reagent_list)
				if(R.scannable)
					reagentdata["[R.id]"] = "<span class='notice'>\t[round(C.reagents.get_reagent_amount(R.id), 1)]u [R.name][(R.overdose && R.volume > R.overdose) ? " - <span class='danger'>Overdose</span>" : ""]</span><br>"
				else
					unknown++
					unknownreagents["[R.id]"] = "<span class='notice'>\t[round(C.reagents.get_reagent_amount(R.id), 1)]u [R.name][(R.overdose && R.volume > R.overdose) ? " - <span class='danger'>Overdose</span>" : ""]</span><br>"
			if(reagentdata.len)
				dat += "<span class='notice'>Beneficial reagents detected in subject's blood:</span><br>"
				for(var/d in reagentdata)
					dat += reagentdata[d]
			if(unknown)
				if(advscan >= 3 && showadvscan == 1)
					dat += "<span class='warning'>Warning: Non-medical reagent[(unknown>1)?"s":""] detected in subject's blood:</span><br>"
					for(var/d in unknownreagents)
						dat += unknownreagents[d]
				else
					dat += "<span class='warning'>Warning: Unknown substance[(unknown>1)?"s":""] detected in subject's blood.</span><br>"
		if(C.ingested && C.ingested.total_volume)
			var/unknown = 0
			var/stomachreagentdata[0]
			var/stomachunknownreagents[0]
			for(var/datum/reagent/R as anything in C.ingested.reagent_list)
				if(R.scannable)
					stomachreagentdata["[R.id]"] = "<span class='notice'>\t[round(C.ingested.get_reagent_amount(R.id), 1)]u [R.name][(R.overdose && R.volume > R.overdose) ? " - <span class='danger'>Overdose</span>" : ""]</span><br>"
					if (advscan == 0 || showadvscan == 0)
						dat += "<span class='notice'>[R.name] found in subject's stomach.</span><br>"
				else
					++unknown
					stomachunknownreagents["[R.id]"] = "<span class='notice'>\t[round(C.ingested.get_reagent_amount(R.id), 1)]u [R.name][(R.overdose && R.volume > R.overdose) ? " - <span class='danger'>Overdose</span>" : ""]</span><br>"
			if(advscan >= 1 && showadvscan == 1)
				dat += "<span class='notice'>Beneficial reagents detected in subject's stomach:</span><br>"
				for(var/d in stomachreagentdata)
					dat += stomachreagentdata[d]
			if(unknown)
				if(advscan >= 3 && showadvscan == 1)
					dat += "<span class='warning'>Warning: Non-medical reagent[(unknown > 1)?"s":""] found in subject's stomach:</span><br>"
					for(var/d in stomachunknownreagents)
						dat += stomachunknownreagents[d]
				else
					dat += "<span class='warning'>Unknown substance[(unknown > 1)?"s":""] found in subject's stomach.</span><br>"
		if(C.touching && C.touching.total_volume)
			var/unknown = 0
			var/touchreagentdata[0]
			var/touchunknownreagents[0]
			for(var/datum/reagent/R as anything in C.touching.reagent_list)
				if(R.scannable)
					touchreagentdata["[R.id]"] = "<span class='notice'>\t[round(C.touching.get_reagent_amount(R.id), 1)]u [R.name][(R.overdose && R.can_overdose_touch && R.volume > R.overdose) ? " - <span class='danger'>Overdose</span>" : ""]</span><br>"
					if (advscan == 0 || showadvscan == 0)
						dat += "<span class='notice'>[R.name] found in subject's dermis.</span><br>"
				else
					++unknown
					touchunknownreagents["[R.id]"] = "<span class='notice'>\t[round(C.ingested.get_reagent_amount(R.id), 1)]u [R.name][(R.overdose && R.can_overdose_touch && R.volume > R.overdose) ? " - <span class='danger'>Overdose</span>" : ""]</span><br>"
			if(advscan >= 1 && showadvscan == 1)
				dat += "<span class='notice'>Beneficial reagents detected in subject's dermis:</span><br>"
				for(var/d in touchreagentdata)
					dat += touchreagentdata[d]
			if(unknown)
				if(advscan >= 3 && showadvscan == 1)
					dat += "<span class='warning'>Warning: Non-medical reagent[(unknown > 1)?"s":""] found in subject's dermis:</span><br>"
					for(var/d in touchunknownreagents)
						dat += touchunknownreagents[d]
				else
					dat += "<span class='warning'>Unknown substance[(unknown > 1)?"s":""] found in subject's dermis.</span><br>"
		if(C.virus2.len)
			for (var/ID in C.virus2)
				if (ID in virusDB)
					var/datum/data/record/V = virusDB[ID]
					dat += "<span class='warning'>Warning: Pathogen [V.fields["name"]] detected in subject's blood. Known antigen : [V.fields["antigen"]]</span><br>"
				else
					dat += "<span class='warning'>Warning: Unknown pathogen detected in subject's blood.</span><br>"
	if (M.getCloneLoss())
		dat += "<span class='warning'>Subject appears to have been imperfectly cloned.</span><br>"
//	if (M.reagents && M.reagents.get_reagent_amount("inaprovaline"))
//		user.show_message("<span class='notice'>Bloodstream Analysis located [M.reagents:get_reagent_amount("inaprovaline")] units of rejuvenation chemicals.</span>")
	if (M.has_brain_worms())
		dat += "<span class='warning'>Subject suffering from aberrant brain activity. Recommend further scanning.</span><br>"
	else if (M.getBrainLoss() >= 60 || !M.has_brain())
		dat += "<span class='warning'>Subject is brain dead.</span><br>"
	else if (M.getBrainLoss() >= 25)
		dat += "<span class='warning'>Severe brain damage detected. Subject likely to have a traumatic brain injury.</span><br>"
	else if (M.getBrainLoss() >= 10)
		dat += "<span class='warning'>Significant brain damage detected. Subject may have had a concussion.</span><br>"
	else if (M.getBrainLoss() >= 1 && advscan >= 2 && showadvscan == 1)
		dat += "<span class='warning'>Minor brain damage detected.</span><br>"
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		for(var/obj/item/organ/internal/appendix/a in H.internal_organs)
			var/severity = ""
			if(a.inflamed > 3)
				severity = "Severe"
			else if(a.inflamed > 2)
				severity = "Moderate"
			else if(a.inflamed >= 1)
				severity = "Mild"
			if(severity)
				dat += "<span class='warning'>[severity] inflammation detected in subject [a.name].</span><br>"
		// Infections, fractures, and IB
		var/basic_fracture = 0	// If it's a basic scanner
		var/basic_ib = 0		// If it's a basic scanner
		var/fracture_dat = ""	// All the fractures
		var/infection_dat = ""	// All the infections
		var/ib_dat = ""			// All the IB
		for(var/obj/item/organ/external/e in H.organs)
			if(!e)
				continue
			// Broken limbs
			if(e.status & ORGAN_BROKEN)
				if((e.name in list(BP_L_ARM, BP_R_ARM, BP_L_LEG, BP_R_LEG, BP_HEAD, BP_TORSO, BP_GROIN)) && (!e.splinted))
					fracture_dat += "<span class='warning'>Unsecured fracture in subject [e.name]. Splinting recommended for transport.</span><br>"
				else if(advscan >= 1 && showadvscan == 1)
					fracture_dat += "<span class='warning'>Bone fractures detected in subject [e.name].</span><br>"
				else
					basic_fracture = 1
			// Infections
			if(e.has_infected_wound())
				dat += "<span class='warning'>Infected wound detected in subject [e.name]. Disinfection recommended.</span><br>"
			// IB
			for(var/datum/wound/W in e.wounds)
				if(W.internal)
					if(advscan >= 1 && showadvscan == 1)
						ib_dat += "<span class='warning'>Internal bleeding detected in subject [e.name].</span><br>"
					else
						basic_ib = 1
		if(basic_fracture)
			fracture_dat += "<span class='warning'>Bone fractures detected. Advanced scanner required for location.</span><br>"
		if(basic_ib)
			ib_dat += "<span class='warning'>Internal bleeding detected. Advanced scanner required for location.</span><br>"
		dat += fracture_dat
		dat += infection_dat
		dat += ib_dat

		// Blood level
		if(M:vessel)
			var/blood_volume = H.vessel.get_reagent_amount("blood")
			var/blood_percent =  round((blood_volume / H.species.blood_volume)*100)
			var/blood_type = H.dna.b_type
			if(blood_volume <= H.species.blood_volume*H.species.blood_level_danger)
				dat += "<span class='danger'><i>Warning: Blood Level CRITICAL: [blood_percent]% [blood_volume]cl. Type: [blood_type]</i></span><br>"
			else if(blood_volume <= H.species.blood_volume*H.species.blood_level_warning)
				dat += "<span class='danger'><i>Warning: Blood Level VERY LOW: [blood_percent]% [blood_volume]cl. Type: [blood_type]</i></span><br>"
			else if(blood_volume <= H.species.blood_volume*H.species.blood_level_safe)
				dat += "<span class='danger'>Warning: Blood Level LOW: [blood_percent]% [blood_volume]cl. Type: [blood_type]</span><br>"
			else
				dat += "<span class='notice'>Blood Level Normal: [blood_percent]% [blood_volume]cl. Type: [blood_type]</span><br>"
		dat += "<span class='notice'>Subject's pulse: <font color='[H.pulse == PULSE_THREADY || H.pulse == PULSE_NONE ? "red" : "blue"]'>[H.get_pulse(GETPULSE_TOOL)] bpm.</font></span><br>" // VORE Edit: Missed a linebreak here.
		if(istype(H.species, /datum/species/xenochimera)) // VOREStation Edit Start: Visible feedback for medmains on Xenochimera.
			if(H.stat == DEAD && H.revive_ready == REVIVING_READY && !H.hasnutriment())
				dat += "<span class='danger'>WARNING: Protein levels low. Subject incapable of reconstitution.</span>"
			else if(H.revive_ready == REVIVING_NOW)
				dat += "<span class='warning'>Subject is undergoing form reconstruction. Estimated time to finish is in: [round((H.revive_finished - world.time) / 10)] seconds.</span>"
			else if(H.revive_ready == REVIVING_DONE)
				dat += "<span class='notice'>Subject is ready to hatch. Transfer to dark room for holding with food available.</span>"
			else if(H.stat == DEAD)
				dat+= "<span class='danger'>WARNING: Defib will cause extreme pain and set subject feral. Sedation recommended prior to defibrillation.</span>"
			else // If they bop them and they're not dead or reviving, give 'em a little notice.
				dat += "<span class='notice'>Subject is a Xenochimera. Treat accordingly.</span>"
		// VOREStation Edit End
	user.show_message(dat, 1)

/obj/item/device/healthanalyzer/verb/toggle_mode()
	set name = "Switch Verbosity"
	set category = "Object"

	mode = !mode
	switch (mode)
		if(1)
			to_chat(usr, "The scanner now shows specific limb damage.")
		if(0)
			to_chat(usr, "The scanner no longer shows limb damage.")

/obj/item/device/healthanalyzer/proc/toggle_adv()
	set name = "Toggle Advanced Scan"
	set category = "Object"

	showadvscan = !showadvscan
	switch (showadvscan)
		if(1)
			to_chat(usr, "The scanner will now perform an advanced analysis.")
		if(0)
			to_chat(usr, "The scanner will now perform a basic analysis.")

/obj/item/device/healthanalyzer/improved //reports bone fractures, IB, quantity of beneficial reagents in stomach; also regular health analyzer stuff
	name = "improved health analyzer"
	desc = "A miracle of medical technology, this handheld scanner can produce an accurate and specific report of a patient's biosigns."
	advscan = 1
	origin_tech = list(TECH_MAGNET = 5, TECH_BIO = 6)
	icon_state = "health1"

/obj/item/device/healthanalyzer/advanced //reports all of the above, as well as radiation severity and minor brain damage
	name = "advanced health analyzer"
	desc = "An even more advanced handheld health scanner, complete with a full biosign monitor and on-board radiation and neurological analysis suites."
	advscan = 2
	origin_tech = list(TECH_MAGNET = 6, TECH_BIO = 7)
	icon_state = "health2"

/obj/item/device/healthanalyzer/phasic //reports all of the above, as well as name and quantity of nonmed reagents in stomach
	name = "phasic health analyzer"
	desc = "Possibly the most advanced health analyzer to ever have existed, utilising bluespace technology to determine almost everything worth knowing about a patient."
	advscan = 3
	origin_tech = list(TECH_MAGNET = 7, TECH_BIO = 8)
	icon_state = "health3"

#undef DEFIB_TIME_LIMIT //VOREStation addition