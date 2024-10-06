#define DEFIB_TIME_LIMIT (10 MINUTES) //VOREStation addition- past this many seconds, defib is useless.

/obj/item/healthanalyzer
	name = "health analyzer"
	desc = "A hand-held body scanner able to distinguish vital signs of the subject."
	icon = 'icons/obj/device.dmi'
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
	var/guide = FALSE

/obj/item/healthanalyzer/New()
	if(advscan >= 1)
		verbs += /obj/item/healthanalyzer/proc/toggle_adv
	..()

/obj/item/healthanalyzer/examine(mob/user)
	. = ..()
	if(guide)
		. += span_notice("Guidance is currently enabled.")
	else
		. += span_notice("Guidance is currently disabled.")

/obj/item/healthanalyzer/do_surgery(mob/living/M, mob/living/user)
	if(user.a_intent != I_HELP) //in case it is ever used as a surgery tool
		return ..()
	scan_mob(M, user) //default surgery behaviour is just to scan as usual
	return 1

/obj/item/healthanalyzer/attack(mob/living/M, mob/living/user)
	scan_mob(M, user)

/obj/item/healthanalyzer/proc/scan_mob(mob/living/M, mob/living/user)
	var/dat = ""
	if ((CLUMSY in user.mutations) && prob(50))
		user.visible_message(span_warning("\The [user] has analyzed the floor's vitals!"), span_warning("You try to analyze the floor's vitals!"))
		dat += "Analyzing Results for the floor:<br>"
		dat += "Overall Status: Healthy<br>"
		dat += "\tDamage Specifics: 0-0-0-0<br>"
		dat += "Key: Suffocation/Toxin/Burns/Brute<br>"
		dat += "Body Temperature: ???"
		user.show_message(span_notice("[dat]"), 1)
		return
	if (!user.IsAdvancedToolUser())
		to_chat(user, span_warning("You don't have the dexterity to do this!"))
		return

	flick("[icon_state]-scan", src)	//makes it so that it plays the scan animation on a succesful scan
	user.visible_message(span_notice("[user] has analyzed [M]'s vitals."),span_notice("You have analyzed [M]'s vitals."))

	if (!ishuman(M) || M.isSynthetic())
		//these sensors are designed for organic life
		dat += "<span class='notice'>Analyzing Results for ERROR:\n\tOverall Status: ERROR<br>"
		dat += "\tKey: [span_cyan("Suffocation")]/[span_green("Toxin")]/[span_orange("Burns")]/[span_red("Brute")]<br>"
		dat += "\tDamage Specifics: [span_cyan("?")] - [span_green("?")] - [span_orange("?")] - [span_red("?")]<br>"
		dat += "Body Temperature: [M.bodytemperature-T0C]&deg;C ([M.bodytemperature*1.8-459.67]&deg;F)</span><br>"
		dat += "[span_warning("Warning: Blood Level ERROR: --% --cl.")] [span_notice("Type: ERROR")]<br>"
		dat += span_notice("Subject's pulse: [span_red("-- bpm.")]")
		user.show_message(dat, 1)
		return

	var/fake_oxy = max(rand(1,40), M.getOxyLoss(), (300 - (M.getToxLoss() + M.getFireLoss() + M.getBruteLoss())))
	var/OX = M.getOxyLoss() > 50 	? 	"<b>[M.getOxyLoss()]</b>" 		: M.getOxyLoss()
	var/TX = M.getToxLoss() > 50 	? 	"<b>[M.getToxLoss()]</b>" 		: M.getToxLoss()
	var/BU = M.getFireLoss() > 50 	? 	"<b>[M.getFireLoss()]</b>" 		: M.getFireLoss()
	var/BR = M.getBruteLoss() > 50 	? 	"<b>[M.getBruteLoss()]</b>" 	: M.getBruteLoss()
	if(M.status_flags & FAKEDEATH)
		OX = fake_oxy > 50 			? 	"<b>[fake_oxy]</b>" 			: fake_oxy
		dat += span_notice("Analyzing Results for [M]:")
		dat += "<br>"
		dat += span_notice("Overall Status: dead")
		dat += "<br>"
	else
		dat += 	"<span class='notice'>Analyzing Results for [M]:\n\t Overall Status: [M.stat > 1 ? "dead" : "[round((M.health/M.getMaxHealth())*100) ]% healthy"]<br>"
	dat += 		"\tKey: [span_cyan("Suffocation")]/[span_green("Toxin")]/[span_orange("Burns")]/[span_red("Brute")]<br>"
	dat += 		"\tDamage Specifics: [span_cyan("[OX]")] - [span_green("[TX]")] - [span_orange("[BU]")] - [span_red("[BR]")]<br>"
	dat +=		"Body Temperature: [M.bodytemperature-T0C]&deg;C ([M.bodytemperature*1.8-459.67]&deg;F)</span><br>"
	//VOREStation edit/addition starts
	if(M.timeofdeath && (M.stat == DEAD || (M.status_flags & FAKEDEATH)))
		dat += 	span_notice("Time of Death: [worldtime2stationtime(M.timeofdeath)]")
		dat += "<br>"
		var/tdelta = round(world.time - M.timeofdeath)
		if(tdelta < (DEFIB_TIME_LIMIT * 10))
			dat += span_notice("<b>Subject died [DisplayTimeText(tdelta)] ago - resuscitation may be possible!</b>")
			dat += "<br>"
	//VOREStation edit/addition ends
	if(istype(M, /mob/living/carbon/human) && mode == 1)
		var/mob/living/carbon/human/H = M
		var/list/damaged = H.get_damaged_organs(1,1)
		dat += 	span_notice("Localized Damage, Brute/Burn:")
		dat += "<br>"
		if(length(damaged)>0)
			for(var/obj/item/organ/external/org in damaged)
				if(org.robotic >= ORGAN_ROBOT)
					continue
				else
					dat += "<span class='notice'>     [capitalize(org.name)]: [(org.brute_dam > 0) ? span_warning("[org.brute_dam]") : 0]"
					dat += "[(org.status & ORGAN_BLEEDING)?span_danger("\[Bleeding\]"):""] - "
					dat += "[(org.burn_dam > 0) ? "[span_orange("[org.burn_dam]")]" : 0]</span><br>"
		else
			dat += span_notice("    Limbs are OK.")
			dat += "<br>"

	OX = M.getOxyLoss() > 50 ? 	 "[span_cyan("<b>Severe oxygen deprivation detected</b>")]" 			: 	"Subject bloodstream oxygen level normal"
	TX = M.getToxLoss() > 50 ? 	 "[span_green("<b>Dangerous amount of toxins detected</b>")]" 	: 	"Subject bloodstream toxin level minimal"
	BU = M.getFireLoss() > 50 ?  "[span_orange("<b>Severe burn damage detected</b>")]" 			:	"Subject burn injury status O.K"
	BR = M.getBruteLoss() > 50 ? "[span_red("<b>Severe anatomical damage detected</b>")]"		 		: 	"Subject brute-force injury status O.K"
	if(M.status_flags & FAKEDEATH)
		OX = fake_oxy > 50 ? 		span_warning("Severe oxygen deprivation detected") 	: 	"Subject bloodstream oxygen level normal"
	dat += "[OX] | [TX] | [BU] | [BR]<br>"
	if(M.radiation)
		if(advscan >= 2 && showadvscan == 1)
			var/severity = ""
			if(M.radiation >= 1500)
				severity = "Lethal"
			else if(M.radiation >= 600)
				severity = "Critical"
			else if(M.radiation >= 400)
				severity = "Severe"
			else if(M.radiation >= 300)
				severity = "Moderate"
			else if(M.radiation >= 100)
				severity = "Low"
			dat += span_warning("[severity] levels of acute radiation sickness detected. [round(M.radiation/50)]Gy. [(severity == "Critical" || severity == "Lethal") ? " Immediate treatment advised." : ""]")
			dat += "<br>"
		else
			dat += span_warning("Acute radiation sickness detected.")
			dat += "<br>"
	if(M.accumulated_rads)
		if(advscan >= 2 && showadvscan == 1)
			var/severity = ""
			if(M.accumulated_rads >= 1500)
				severity = "Critical"
			else if(M.accumulated_rads >= 600)
				severity = "Severe"
			else if(M.accumulated_rads >= 400)
				severity = "Moderate"
			else if(M.accumulated_rads >= 300)
				severity = "Mild"
			else if(M.accumulated_rads >= 100)
				severity = "Low"
			dat += span_warning("[severity] levels of chronic radiation sickness detected. [round(M.accumulated_rads/50)]Gy.")
			dat += "<br>"
		else
			dat += span_warning("Chronic radiation sickness detected.")
			dat += "<br>"
	if(iscarbon(M))
		var/mob/living/carbon/C = M
		if(C.reagents.total_volume)
			var/unknown = 0
			var/reagentdata[0]
			var/unknownreagents[0]
			for(var/datum/reagent/R as anything in C.reagents.reagent_list)
				if(R.scannable)
					reagentdata["[R.id]"] = span_notice("\t[round(C.reagents.get_reagent_amount(R.id), 1)]u [R.name][(R.overdose && R.volume > R.overdose) ? " - [span_danger("Overdose")]" : ""]")
					reagentdata["[R.id]"] += "<br>"
				else
					unknown++
					unknownreagents["[R.id]"] = span_notice("\t[round(C.reagents.get_reagent_amount(R.id), 1)]u [R.name][(R.overdose && R.volume > R.overdose) ? " - [span_danger("Overdose")]" : ""]")
					unknownreagents["[R.id]"] += "<br>"
			if(reagentdata.len)
				dat += span_notice("Beneficial reagents detected in subject's blood:")
				dat += "<br>"
				for(var/d in reagentdata)
					dat += reagentdata[d]
			if(unknown)
				if(advscan >= 3 && showadvscan == 1)
					dat += span_warning("Warning: Non-medical reagent[(unknown>1)?"s":""] detected in subject's blood:")
					dat += "<br>"
					for(var/d in unknownreagents)
						dat += unknownreagents[d]
				else
					dat += span_warning("Warning: Unknown substance[(unknown>1)?"s":""] detected in subject's blood.")
					dat += "<br>"
		if(C.ingested && C.ingested.total_volume)
			var/unknown = 0
			var/stomachreagentdata[0]
			var/stomachunknownreagents[0]
			for(var/datum/reagent/R as anything in C.ingested.reagent_list)
				if(R.scannable)
					stomachreagentdata["[R.id]"] = span_notice("\t[round(C.ingested.get_reagent_amount(R.id), 1)]u [R.name][(R.overdose && R.volume > R.overdose) ? " - [span_danger("Overdose")]" : ""]")
					stomachreagentdata["[R.id]"] += "<br>"
					if (advscan == 0 || showadvscan == 0)
						dat += span_notice("[R.name] found in subject's stomach.")
						dat += "<br>"
				else
					++unknown
					stomachunknownreagents["[R.id]"] = span_notice("\t[round(C.ingested.get_reagent_amount(R.id), 1)]u [R.name][(R.overdose && R.volume > R.overdose) ? " - [span_danger("Overdose")]" : ""]")
					stomachunknownreagents["[R.id]"] += "<br>"
			if(advscan >= 1 && showadvscan == 1)
				dat += span_notice("Beneficial reagents detected in subject's stomach:")
				dat += "<br>"
				for(var/d in stomachreagentdata)
					dat += stomachreagentdata[d]
			if(unknown)
				if(advscan >= 3 && showadvscan == 1)
					dat += span_warning("Warning: Non-medical reagent[(unknown > 1)?"s":""] found in subject's stomach:")
					dat += "<br>"
					for(var/d in stomachunknownreagents)
						dat += stomachunknownreagents[d]
				else
					dat += span_warning("Unknown substance[(unknown > 1)?"s":""] found in subject's stomach.")
					dat += "<br>"
		if(C.touching && C.touching.total_volume)
			var/unknown = 0
			var/touchreagentdata[0]
			var/touchunknownreagents[0]
			for(var/datum/reagent/R as anything in C.touching.reagent_list)
				if(R.scannable)
					touchreagentdata["[R.id]"] = span_notice("\t[round(C.touching.get_reagent_amount(R.id), 1)]u [R.name][(R.overdose && R.can_overdose_touch && R.volume > R.overdose) ? " - [span_danger("Overdose")]" : ""]")
					touchreagentdata["[R.id]"] += "<br>"
					if (advscan == 0 || showadvscan == 0)
						dat += span_notice("[R.name] found in subject's dermis.")
						dat += "<br>"
				else
					++unknown
					touchunknownreagents["[R.id]"] = span_notice("\t[round(C.ingested.get_reagent_amount(R.id), 1)]u [R.name][(R.overdose && R.can_overdose_touch && R.volume > R.overdose) ? " - [span_danger("Overdose")]" : ""]")
					touchunknownreagents["[R.id]"] += "<br>"
			if(advscan >= 1 && showadvscan == 1)
				dat += span_notice("Beneficial reagents detected in subject's dermis:")
				dat += "<br>"
				for(var/d in touchreagentdata)
					dat += touchreagentdata[d]
			if(unknown)
				if(advscan >= 3 && showadvscan == 1)
					dat += span_warning("Warning: Non-medical reagent[(unknown > 1)?"s":""] found in subject's dermis:")
					dat += "<br>"
					for(var/d in touchunknownreagents)
						dat += touchunknownreagents[d]
				else
					dat += span_warning("Unknown substance[(unknown > 1)?"s":""] found in subject's dermis.")
					dat += "<br>"
		if(C.virus2.len)
			for (var/ID in C.virus2)
				if (ID in virusDB)
					var/datum/data/record/V = virusDB[ID]
					dat += span_warning("Warning: Pathogen [V.fields["name"]] detected in subject's blood. Known antigen : [V.fields["antigen"]]")
					dat += "<br>"
				else
					dat += span_warning("Warning: Unknown pathogen detected in subject's blood.")
					dat += "<br>"
	if (M.getCloneLoss())
		dat += span_warning("Subject appears to have been imperfectly cloned.")
		dat += "<br>"
//	if (M.reagents && M.reagents.get_reagent_amount("inaprovaline"))
//		user.show_message(span_notice("Bloodstream Analysis located [M.reagents:get_reagent_amount("inaprovaline")] units of rejuvenation chemicals."))
	if (M.has_brain_worms())
		dat += span_warning("Subject suffering from aberrant brain activity. Recommend further scanning.")
		dat += "<br>"
	else if (M.getBrainLoss() >= 60 || !M.has_brain())
		dat += span_warning("Subject is brain dead.")
		dat += "<br>"
	else if (M.getBrainLoss() >= 25)
		dat += span_warning("Severe brain damage detected. Subject likely to have a traumatic brain injury.")
		dat += "<br>"
	else if (M.getBrainLoss() >= 10)
		dat += span_warning("Significant brain damage detected. Subject may have had a concussion.")
		dat += "<br>"
	else if (M.getBrainLoss() >= 1)
		dat += span_warning("Minor brain damage detected.")
		dat += "<br>"
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
				dat += span_warning("[severity] inflammation detected in subject [a.name].")
				dat += "<br>"
		if(HUSK in H.mutations)
			dat += span_danger("Anatomical structure lost, resuscitation not possible!")
			dat += "<br>"
		// Infections, fractures, and IB
		var/basic_fracture = 0	// If it's a basic scanner
		var/basic_ib = 0		// If it's a basic scanner
		var/fracture_dat = ""	// All the fractures
		var/infection_dat = ""	// All the infections
		var/ib_dat = ""			// All the IB
		var/int_damage_acc = 0  // For internal organs
		for(var/obj/item/organ/internal/i in H.internal_organs)
			if(!i || i.robotic >= ORGAN_ROBOT || istype(i, /obj/item/organ/internal/brain))
				continue 		// not there or robotic or brain which is handled separately
			if(i.damage || i.status & ORGAN_DEAD)
				int_damage_acc += (i.damage + ((i.status & ORGAN_DEAD) ? 30 : 0))
				if(advscan >= 2 && showadvscan == 1)
					if(advscan >= 3)
						var/dam_adj
						if(i.damage >= i.min_broken_damage || i.status & ORGAN_DEAD)
							dam_adj = "Severe"
						else if(i.damage >= i.min_bruised_damage)
							dam_adj = "Moderate"
						else
							dam_adj = "Mild"
						dat += span_warning("[dam_adj] damage detected to subject's [i.name].")
						dat += "<br>"
					else
						dat += span_warning("Damage detected to subject's [i.name].")
						dat += "<br>"
		if(int_damage_acc >= 1 && (advscan < 2 || !showadvscan))
			dat += span_warning("Damage detected to subject's internal organs.")
			dat += "<br>"
		for(var/obj/item/organ/external/e in H.organs)
			if(!e)
				continue
			// Broken limbs
			if(e.status & ORGAN_BROKEN)
				if((e.name in list(BP_L_ARM, BP_R_ARM, BP_L_LEG, BP_R_LEG, BP_HEAD, BP_TORSO, BP_GROIN)) && (!e.splinted))
					fracture_dat += span_warning("Unsecured fracture in subject [e.name]. Splinting recommended for transport.")
					fracture_dat += "<br>"
				else if(advscan >= 1 && showadvscan == 1)
					fracture_dat += span_warning("Bone fractures detected in subject [e.name].")
					fracture_dat += "<br>"
				else
					basic_fracture = 1
			// Infections
			if(e.has_infected_wound())
				dat += span_warning("Infected wound detected in subject [e.name]. Disinfection recommended.")
				dat += "<br>"
			// IB
			for(var/datum/wound/W in e.wounds)
				if(W.internal)
					if(advscan >= 1 && showadvscan == 1)
						ib_dat += span_warning("Internal bleeding detected in subject [e.name].")
						ib_dat += "<br>"
					else
						basic_ib = 1
		if(basic_fracture)
			fracture_dat += span_warning("Bone fractures detected. Advanced scanner required for location.")
			fracture_dat += "<br>"
		if(basic_ib)
			ib_dat += span_warning("Internal bleeding detected. Advanced scanner required for location.")
			ib_dat += "<br>"
		dat += fracture_dat
		dat += infection_dat
		dat += ib_dat

		// Blood level
		if(M:vessel)
			var/blood_volume = H.vessel.get_reagent_amount("blood")
			var/blood_percent =  round((blood_volume / H.species.blood_volume)*100)
			var/blood_type = H.dna.b_type
			var/blood_reagent = H.species.blood_reagents
			if(blood_volume <= H.species.blood_volume*H.species.blood_level_danger)
				dat += span_danger("<i>Warning: Blood Level CRITICAL: [blood_percent]% [blood_volume]cl. Type: [blood_type]. Basis: [blood_reagent].</i>")
				dat += "<br>"
			else if(blood_volume <= H.species.blood_volume*H.species.blood_level_warning)
				dat += span_danger("<i>Warning: Blood Level VERY LOW: [blood_percent]% [blood_volume]cl. Type: [blood_type]. Basis: [blood_reagent].</i>")
				dat += "<br>"
			else if(blood_volume <= H.species.blood_volume*H.species.blood_level_safe)
				dat += span_danger("Warning: Blood Level LOW: [blood_percent]% [blood_volume]cl. Type: [blood_type]. Basis: [blood_reagent].")
				dat += "<br>"
			else
				dat += span_notice("Blood Level Normal: [blood_percent]% [blood_volume]cl. Type: [blood_type]. Basis: [blood_reagent].")
				dat += "<br>"
		dat += span_notice("Subject's pulse: [H.pulse == PULSE_THREADY || H.pulse == PULSE_NONE ? span_red(H.get_pulse(GETPULSE_TOOL) + " bpm") : span_blue(H.get_pulse(GETPULSE_TOOL) + " bpm")].") // VORE Edit: Missed a linebreak here.
		dat += "<br>"
		if(istype(H.species, /datum/species/xenochimera)) // VOREStation Edit Start: Visible feedback for medmains on Xenochimera.
			if(H.stat == DEAD && H.revive_ready == REVIVING_READY && !H.hasnutriment())
				dat += span_danger("WARNING: Protein levels low. Subject incapable of reconstitution.")
			else if(H.revive_ready == REVIVING_NOW)
				dat += span_warning("Subject is undergoing form reconstruction. Estimated time to finish is in: [round((H.revive_finished - world.time) / 10)] seconds.")
			else if(H.revive_ready == REVIVING_DONE)
				dat += span_notice("Subject is ready to hatch. Transfer to dark room for holding with food available.")
			else if(H.stat == DEAD)
				dat+= span_danger("WARNING: Defib will cause extreme pain and set subject feral. Sedation recommended prior to defibrillation.")
			else // If they bop them and they're not dead or reviving, give 'em a little notice.
				dat += span_notice("Subject is a Xenochimera. Treat accordingly.")
		// VOREStation Edit End
	user.show_message(dat, 1)
	if(guide)
		guide(M, user)

/obj/item/healthanalyzer/verb/toggle_mode()
	set name = "Switch Verbosity"
	set category = "Object"

	mode = !mode
	switch (mode)
		if(1)
			to_chat(usr, "The scanner now shows specific limb damage.")
		if(0)
			to_chat(usr, "The scanner no longer shows limb damage.")

/obj/item/healthanalyzer/proc/toggle_adv()
	set name = "Toggle Advanced Scan"
	set category = "Object"

	showadvscan = !showadvscan
	switch (showadvscan)
		if(1)
			to_chat(usr, "The scanner will now perform an advanced analysis.")
		if(0)
			to_chat(usr, "The scanner will now perform a basic analysis.")

/obj/item/healthanalyzer/improved //reports bone fractures, IB, quantity of beneficial reagents in stomach; also regular health analyzer stuff
	name = "improved health analyzer"
	desc = "A miracle of medical technology, this handheld scanner can produce an accurate and specific report of a patient's biosigns."
	advscan = 1
	origin_tech = list(TECH_MAGNET = 5, TECH_BIO = 6)
	icon_state = "health1"

/obj/item/healthanalyzer/advanced //reports all of the above, as well as radiation severity and minor brain damage
	name = "advanced health analyzer"
	desc = "An even more advanced handheld health scanner, complete with a full biosign monitor and on-board radiation and neurological analysis suites."
	advscan = 2
	origin_tech = list(TECH_MAGNET = 6, TECH_BIO = 7)
	icon_state = "health2"

/obj/item/healthanalyzer/phasic //reports all of the above, as well as name and quantity of nonmed reagents in stomach
	name = "phasic health analyzer"
	desc = "Possibly the most advanced health analyzer to ever have existed, utilising bluespace technology to determine almost everything worth knowing about a patient."
	advscan = 3
	origin_tech = list(TECH_MAGNET = 7, TECH_BIO = 8)
	icon_state = "health3"

#undef DEFIB_TIME_LIMIT //VOREStation addition
