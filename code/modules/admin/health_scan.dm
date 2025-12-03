//// This is a detatched version of a phasic health analyser for admin use on command
// Mode dictates whether to include specific limb damage
// advscan is the strength of the scan required, 3 being similar to a phasic health analyser.
// showadvscan toggles whether to give additional scan information about chemicals in their body.
// By default this proc is set to it's most powerful scan.

/mob/living/proc/scan_mob(mob/user, var/mode = 1, var/advscan = 3, var/showadvscan = 1)
	var/mob/living/M = src
	var/dat = ""

	// Start with the cyborg analyser first
	if(isrobot(M))
		var/BU = M.getFireLoss() > 50 	? 	span_bold("[M.getFireLoss()]") 		: M.getFireLoss()
		var/BR = M.getBruteLoss() > 50 	? 	span_bold("[M.getBruteLoss()]") 	: M.getBruteLoss()
		user.show_message(span_blue("Analyzing Results for [M]:\n\t Overall Status: [M.stat > 1 ? "fully disabled" : "[M.health - M.halloss]% functional"]"))
		user.show_message("\t Key: [span_orange("Electronics")]/[span_red("Brute")]", 1)
		user.show_message("\t Damage Specifics: [span_orange("[BU]")] - [span_red("[BR]")]")
		if(M.tod && M.stat == DEAD)
			user.show_message(span_blue("Time of Disable: [M.tod]"))
		var/mob/living/silicon/robot/R = M
		var/obj/item/cell/cell = R.get_cell()
		if(cell)
			var/cell_charge = round(cell.percent())
			var/cell_text
			if(cell_charge > 60)
				cell_text = span_green("[cell_charge]")
			else if (cell_charge > 30)
				cell_text = span_yellow("[cell_charge]")
			else if (cell_charge > 10)
				cell_text = span_orange("[cell_charge]")
			else if (cell_charge > 1)
				cell_text = span_red("[cell_charge]")
			else
				cell_text = span_red(span_bold("[cell_charge]"))
			user.show_message("\t Power Cell Status: [span_blue("[capitalize(cell.name)]")] at [cell_text]% charge")
		var/list/damaged = R.get_damaged_components(1,1,1)
		user.show_message(span_blue("Localized Damage:"),1)
		if(length(damaged)>0)
			for(var/datum/robot_component/org in damaged)
				user.show_message(span_blue(text("\t []: [][] - [] - [] - []",	\
				span_blue(capitalize(org.name)),					\
				(org.installed == -1)	?	"[span_red(span_bold("DESTROYED"))] "					:"",\
				(org.electronics_damage > 0)	?	"[span_orange("[org.electronics_damage]")]"	:0,	\
				(org.brute_damage > 0)	?	"[span_red("[org.brute_damage]")]"					:0,	\
				(org.toggled)	?	"Toggled ON"	:	"[span_red("Toggled OFF")]",\
				(org.powered)	?	"Power ON"		:	"[span_red("Power OFF")]")),1)
		else
			user.show_message(span_blue("\t Components are OK."),1)
		if(R.emagged && prob(5))
			user.show_message(span_red("\t ERROR: INTERNAL SYSTEMS COMPROMISED"),1)
		user.show_message(span_blue("Operating Temperature: [M.bodytemperature-T0C]&deg;C ([M.bodytemperature*1.8-459.67]&deg;F)"), 1)
		return

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		to_chat(user, span_notice("Analyzing Results for \the [H]:"))
		if(H.isSynthetic())
			to_chat(user, "System instability: [span_green("[H.getToxLoss()]")]")
		to_chat(user, "Key: [span_orange("Electronics")]/[span_red("Brute")]")
		to_chat(user, span_notice("External prosthetics:"))
		var/organ_found
		if(H.internal_organs.len)
			for(var/obj/item/organ/external/E in H.organs)
				if(!(E.robotic >= ORGAN_ROBOT))
					continue
				organ_found = 1
				to_chat(user, "[E.name]: [span_red("[E.brute_dam] ")] [span_orange("[E.burn_dam]")]")
		if(!organ_found)
			to_chat(user, "No prosthetics located.")
		to_chat(user, "<hr>")
		to_chat(user, span_notice("Internal prosthetics:"))
		organ_found = null
		if(H.internal_organs.len)
			for(var/obj/item/organ/O in H.internal_organs)
				if(!(O.robotic >= ORGAN_ROBOT))
					continue
				organ_found = 1
				to_chat(user, "[O.name]: [span_red("[O.damage]")]")
		if(!organ_found)
			to_chat(user, "No prosthetics located.")

	if(isSynthetic(M))
		return //End here if they're FBP

	//Then do normal health scan
	var/fake_oxy = max(rand(1,40), M.getOxyLoss(), (300 - (M.getToxLoss() + M.getFireLoss() + M.getBruteLoss())))
	var/OX = M.getOxyLoss() > 50 	? 	span_bold("[M.getOxyLoss()]") 		: M.getOxyLoss()
	var/TX = M.getToxLoss() > 50 	? 	span_bold("[M.getToxLoss()]")  		: M.getToxLoss()
	var/BU = M.getFireLoss() > 50 	? 	span_bold("[M.getFireLoss()]") 		: M.getFireLoss()
	var/BR = M.getBruteLoss() > 50 	? 	span_bold("[M.getBruteLoss()]")  	: M.getBruteLoss()
	var/analyzed_results = ""
	if(M.status_flags & FAKEDEATH)
		OX = fake_oxy > 50 			? 	span_bold("[fake_oxy]") 			: fake_oxy
		dat += span_notice("Analyzing Results for [M]:")
		dat += "<br>"
		dat += span_notice("Overall Status: dead")
		dat += "<br>"
	else
		analyzed_results += "Analyzing Results for [M]:\n\t Overall Status: [M.stat > 1 ? "dead" : "[round((M.health/M.getMaxHealth())*100) ]% healthy"]<br>"
	analyzed_results += "\tKey: [span_cyan("Suffocation")]/[span_green("Toxin")]/[span_orange("Burns")]/[span_red("Brute")]<br>"
	analyzed_results += "\tDamage Specifics: [span_cyan("[OX]")] - [span_green("[TX]")] - [span_orange("[BU]")] - [span_red("[BR]")]<br>"
	analyzed_results +=	"Body Temperature: [M.bodytemperature-T0C]&deg;C ([M.bodytemperature*1.8-459.67]&deg;F)<br>"
	analyzed_results = span_notice(analyzed_results)
	dat += analyzed_results
	if(M.timeofdeath && (M.stat == DEAD || (M.status_flags & FAKEDEATH)))
		dat += 	span_notice("Time of Death: [worldtime2stationtime(M.timeofdeath)]")
		dat += "<br>"
		var/tdelta = round(world.time - M.timeofdeath)
		if(tdelta < (10 MINUTES * 10))
			dat += span_boldnotice("Subject died [DisplayTimeText(tdelta)] ago - resuscitation may be possible!")
			dat += "<br>"
	if(ishuman(M) && mode == 1)
		var/mob/living/carbon/human/H = M
		var/list/damaged = H.get_damaged_organs(1,1)
		dat += 	span_notice("Localized Damage, Brute/Burn:")
		dat += "<br>"
		if(length(damaged)>0)
			for(var/obj/item/organ/external/org in damaged)
				if(org.robotic >= ORGAN_ROBOT)
					continue
				else
					var/our_damage = "     [capitalize(org.name)]: [(org.brute_dam > 0) ? span_warning("[org.brute_dam]") : 0]"
					our_damage += "[(org.status & ORGAN_BLEEDING)?span_danger("\[Bleeding\]"):""] - "
					our_damage += "[(org.burn_dam > 0) ? "[span_orange("[org.burn_dam]")]" : 0]"
					dat += span_notice(our_damage) + "<br>"
		else
			dat += span_notice("    Limbs are OK.")
			dat += "<br>"
		// This handles genetic side effects and tells you the treatment, if any.
		// These are handled in side_effects.dm
		if(H.genetic_side_effects)
			for(var/datum/genetics/side_effect/side_effect in H.genetic_side_effects)
				var/datum/reagent/Rd = SSchemistry.chemical_reagents[side_effect.antidote_reagent]
				dat += "<br>"
				dat += span_danger("Patient is suffering from [side_effect.name]. ")
				if(Rd)
					dat += span_danger("Treatment: [Rd]<br>")
				else
					dat += "There is no known treatment.<br>"

	OX = M.getOxyLoss() > 50 ? 	 "[span_cyan(span_bold("Severe oxygen deprivation detected"))]" 			: 	"Subject bloodstream oxygen level normal"
	TX = M.getToxLoss() > 50 ? 	 "[span_green(span_bold("Dangerous amount of toxins detected"))]" 	: 	"Subject bloodstream toxin level minimal"
	BU = M.getFireLoss() > 50 ?  "[span_orange(span_bold("Severe burn damage detected"))]" 			:	"Subject burn injury status O.K"
	BR = M.getBruteLoss() > 50 ? "[span_red(span_bold("Severe anatomical damage detected"))]"		 		: 	"Subject brute-force injury status O.K"
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
		if(C.IsInfected())
			for (var/datum/disease/virus in C.GetViruses())
				if(virus.visibility_flags & HIDDEN_SCANNER || virus.visibility_flags & HIDDEN_PANDEMIC)
					continue
				dat += span_alert(span_bold("Warning: [virus.form] detected in subject's blood."))
				dat += "<br>"
	if (M.getCloneLoss())
		dat += span_warning("Subject appears to have been imperfectly cloned.")
		dat += "<br>"
//	if (M.reagents && M.reagents.get_reagent_amount(REAGENT_ID_INAPROVALINE))
//		user.show_message(span_notice("Bloodstream Analysis located [M.reagents:get_reagent_amount(REAGENT_ID_INAPROVALINE)] units of rejuvenation chemicals."))
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
		// Addictions
		if(H.get_addiction_to_reagent(REAGENT_ID_ASUSTENANCE) > 0)
			dat += span_warning("Biologically unstable, requires [REAGENT_ASUSTENANCE] to function properly.")
			dat += "<br>"
		for(var/addic in H.get_all_addictions())
			if(H.get_addiction_to_reagent(addic) > 0 && (advscan >= 2 || H.get_addiction_to_reagent(addic) <= 120)) // high enough scanner upgrade detects addiction even if not almost withdrawling
				var/datum/reagent/R = SSchemistry.chemical_reagents[addic]
				if(R.id == REAGENT_ID_ASUSTENANCE)
					continue
				if(advscan >= 1)
					// Shows multiple
					if(advscan >= 2 && H.get_addiction_to_reagent(addic) <= 80)
						dat += span_warning("Experiencing withdrawls from [R.name], [REAGENT_INAPROVALINE] treatment recomended.")
						dat += "<br>"
					else
						dat += span_warning("Chemical dependance detected: [R.name].")
						dat += "<br>"
				else
					// Shows single
					dat += span_warning("Chemical dependance detected.")
					dat += "<br>"
					break
		// Appendix
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
			var/blood_volume = H.vessel.get_reagent_amount(REAGENT_ID_BLOOD)
			var/blood_percent =  round((blood_volume / H.species.blood_volume)*100)
			var/blood_type = H.dna.b_type
			var/blood_reagent = H.species.blood_reagents
			if(blood_volume <= H.species.blood_volume*H.species.blood_level_danger)
				dat += span_danger(span_italics("Warning: Blood Level CRITICAL: [blood_percent]% [blood_volume]cl. Type: [blood_type]. Basis: [blood_reagent]."))
				dat += "<br>"
			else if(blood_volume <= H.species.blood_volume*H.species.blood_level_warning)
				dat += span_danger(span_italics("Warning: Blood Level VERY LOW: [blood_percent]% [blood_volume]cl. Type: [blood_type]. Basis: [blood_reagent]."))
				dat += "<br>"
			else if(blood_volume <= H.species.blood_volume*H.species.blood_level_safe)
				dat += span_danger("Warning: Blood Level LOW: [blood_percent]% [blood_volume]cl. Type: [blood_type]. Basis: [blood_reagent].")
				dat += "<br>"
			else
				dat += span_notice("Blood Level Normal: [blood_percent]% [blood_volume]cl. Type: [blood_type]. Basis: [blood_reagent].")
				dat += "<br>"
		dat += span_notice("Subject's pulse: [H.pulse == PULSE_THREADY || H.pulse == PULSE_NONE ? span_red(H.get_pulse(GETPULSE_TOOL) + " bpm") : span_blue(H.get_pulse(GETPULSE_TOOL) + " bpm")].") // VORE Edit: Missed a linebreak here.
		dat += "<br>"
		var/datum/component/xenochimera/xc = H.get_xenochimera_component()
		if(xc)
			if(H.stat == DEAD && xc.revive_ready == REVIVING_READY && !H.hasnutriment())
				dat += span_danger("WARNING: Protein levels low. Subject incapable of reconstitution.")
			else if(xc.revive_ready == REVIVING_NOW)
				dat += span_warning("Subject is undergoing form reconstruction. Estimated time to finish is in: [round((xc.revive_finished - world.time) / 10)] seconds.")
			else if(xc.revive_ready == REVIVING_DONE)
				dat += span_notice("Subject is ready to hatch. Transfer to dark room for holding with food available.")
			else if(H.stat == DEAD)
				dat+= span_danger("WARNING: Defib will cause extreme pain and set subject feral. Sedation recommended prior to defibrillation.")
			else // If they bop them and they're not dead or reviving, give 'em a little notice.
				dat += span_notice("Subject is a Xenochimera. Treat accordingly.")

	// Custom medical issues
		for(var/obj/item/organ/I in H.internal_organs)
			for(var/datum/medical_issue/MI in I.medical_issues)
				if(advscan >= MI.advscan)
					dat += span_danger("Warning: [MI.name] detected in [MI.affectedorgan].<br>")
					if(advscan >= MI.advscan_cure)
						if(MI.cure_reagent)
							dat += span_notice("Suggested treatment: Prescription of [MI.cure_reagent].<br>")
						else if(MI.cure_surgery)
							dat += span_notice("Required surgery: [MI.cure_surgery].<br>")
						else
							dat += span_notice("[MI.affectedorgan] may require surgical removal or transplantation.<br>")
		for(var/obj/item/organ/E in H.organs)
			for(var/datum/medical_issue/MI in E.medical_issues)
				if(advscan >= MI.advscan)
					dat += span_danger("Warning: [MI.name] detected in [MI.affectedorgan].<br>")
					if(advscan >= MI.advscan_cure)
						if(MI.cure_reagent)
							dat += span_notice("Suggested treatment: Prescription of [MI.cure_reagent].<br>")
						else if(MI.cure_surgery)
							dat += span_notice("Required surgery: [MI.cure_surgery].<br>")
						else
							dat += span_notice("[MI.affectedorgan] may require surgical removal or transplantation.<br>")

	user.show_message(dat, 1)
