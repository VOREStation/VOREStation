#define SLEEPER_INJECT_COST 600 // Note that this has unlimited supply unlike a borg hypo, so should be balanced accordingly

//Sleeper
/obj/item/dogborg/sleeper
	name = "Sleeper Belly"
	desc = "A mounted sleeper that stabilizes patients and can inject reagents in the borg's reserves."
	icon = 'icons/mob/dogborg_vr.dmi'
	icon_state = "sleeper"
	w_class = ITEMSIZE_TINY
	var/mob/living/carbon/patient = null
	var/mob/living/silicon/robot/hound = null
	var/inject_amount = 10
	var/min_health = -100
	var/cleaning = 0
	var/patient_laststat = null
	var/list/injection_chems = list(REAGENT_ID_INAPROVALINE, REAGENT_ID_BICARIDINE, REAGENT_ID_KELOTANE, REAGENT_ID_ANTITOXIN, REAGENT_ID_DEXALIN, REAGENT_ID_TRICORDRAZINE, REAGENT_ID_SPACEACILLIN, REAGENT_ID_TRAMADOL) //The borg is able to heal every damage type. As a nerf, they use 750 charge per injection.
	var/eject_port = "ingestion"
	var/list/items_preserved = list()
	var/UI_open = FALSE
	var/stabilizer = TRUE
	var/compactor = FALSE
	var/analyzer = FALSE
	var/decompiler = FALSE
	var/delivery = FALSE
	var/delivery_tag = "Fuel"
	var/list/list/deliverylists = list()
	var/list/deliveryslot_1 = list()
	var/list/deliveryslot_2 = list()
	var/list/deliveryslot_3 = list()
	var/datum/research/techonly/files //Analyzerbelly var.
	var/synced = FALSE
	var/startdrain = 500
	var/max_item_count = 1
	var/upgraded_capacity = FALSE
	var/gulpsound = 'sound/vore/gulp.ogg'
	var/datum/matter_synth/metal = null
	var/datum/matter_synth/glass = null
	var/datum/matter_synth/wood = null
	var/datum/matter_synth/plastic = null
	var/digest_brute = 2
	var/digest_burn = 3
	var/digest_multiplier = 1
	var/recycles = FALSE
	var/medsensor = TRUE //Does belly sprite come with patient ok/dead light?
	var/obj/item/healthanalyzer/med_analyzer = null

/obj/item/dogborg/sleeper/New()
	..()
	flags |= NOBLUDGEON //No more attack messages
	files = new /datum/research/techonly(src)
	med_analyzer = new /obj/item/healthanalyzer

/obj/item/dogborg/sleeper/Destroy()
	go_out()
	..()

/obj/item/dogborg/sleeper/Exit(atom/movable/O)
	return 0

/obj/item/dogborg/sleeper/return_air()
	return return_air_for_internal_lifeform()

/obj/item/dogborg/sleeper/return_air_for_internal_lifeform()
	var/datum/gas_mixture/belly_air/air = new(1000)
	return air

/obj/item/dogborg/sleeper/afterattack(var/atom/movable/target, mob/living/silicon/user, proximity)
	hound = loc
	if(!istype(target))
		return
	if(!proximity)
		return
	if(target.anchored)
		return
	if(target in hound.module.modules)
		return
	if(length(contents) >= max_item_count)
		to_chat(user, span_warning("Your [src.name] is full. Eject or process contents to continue."))
		return

	if(compactor)
		if(is_type_in_list(target,item_vore_blacklist))
			to_chat(user, span_warning("You are hard-wired to not ingest this item."))
			return
		if(istype(target, /obj/item) || istype(target, /obj/effect/decal/remains))
			var/obj/target_obj = target
			if(target_obj.w_class > ITEMSIZE_LARGE)
				to_chat(user, span_warning("\The [target] is too large to fit into your [src.name]"))
				return
			user.visible_message(span_warning("[hound.name] is ingesting [target.name] into their [src.name]."), span_notice("You start ingesting [target] into your [src.name]..."))
			if(do_after(user, 30, target) && length(contents) < max_item_count)
				target.forceMove(src)
				user.visible_message(span_warning("[hound.name]'s [src.name] groans lightly as [target.name] slips inside."), span_notice("Your [src.name] groans lightly as [target] slips inside."))
				playsound(src, gulpsound, vol = 60, vary = 1, falloff = 0.1, preference = /datum/preference/toggle/eating_noises)
				if(analyzer && istype(target,/obj/item))
					var/obj/item/tech_item = target
					var/list/tech_levels = list()
					for(var/T in tech_item.origin_tech)
						tech_levels += "\The [tech_item] has level [tech_item.origin_tech[T]] in [CallTechName(T)]."
					to_chat(user, span_notice("[jointext(tech_levels, "<br>")]"))
				if(delivery)
					if(islist(deliverylists[delivery_tag]))
						deliverylists[delivery_tag] |= target
					to_chat(user, span_notice("\The [target.name] added to cargo compartment slot: [delivery_tag]."))
				update_patient()
			return
		if(istype(target, /mob/living/simple_mob/animal/passive/mouse)) //Edible mice, dead or alive whatever. Mostly for carcass picking you cruel bastard :v
			var/mob/living/simple_mob/trashmouse = target
			user.visible_message(span_warning("[hound.name] is ingesting [trashmouse] into their [src.name]."), span_notice("You start ingesting [trashmouse] into your [src.name]..."))
			if(do_after(user, 30, trashmouse) && length(contents) < max_item_count)
				trashmouse.forceMove(src)
				trashmouse.reset_view(src)
				user.visible_message(span_warning("[hound.name]'s [src.name] groans lightly as [trashmouse] slips inside."), span_notice("Your [src.name] groans lightly as [trashmouse] slips inside."))
				playsound(src, gulpsound, vol = 60, vary = 1, falloff = 0.1, preference = /datum/preference/toggle/eating_noises)
				if(delivery)
					if(islist(deliverylists[delivery_tag]))
						deliverylists[delivery_tag] |= trashmouse
					to_chat(user, span_notice("\The [trashmouse] added to cargo compartment slot: [delivery_tag]."))
				update_patient()
			return
		else if(ishuman(target))
			var/mob/living/carbon/human/trashman = target
			if(patient)
				to_chat(user, span_warning("Your [src.name] is already occupied."))
				return
			if(trashman.buckled)
				to_chat(user, span_warning("[trashman] is buckled and can not be put into your [src.name]."))
				return
			user.visible_message(span_warning("[hound.name] is ingesting [trashman] into their [src.name]."), span_notice("You start ingesting [trashman] into your [src.name]..."))
			if(do_after(user, 30, trashman) && !patient && !trashman.buckled && length(contents) < max_item_count)
				trashman.forceMove(src)
				trashman.reset_view(src)
				START_PROCESSING(SSobj, src)
				user.visible_message(span_warning("[hound.name]'s [src.name] groans lightly as [trashman] slips inside."), span_notice("Your [src.name] groans lightly as [trashman] slips inside."))
				log_admin("[key_name(hound)] has eaten [key_name(patient)] with a cyborg belly. ([hound ? "<a href='?_src_=holder;[HrefToken()];adminplayerobservecoodjump=1;X=[hound.x];Y=[hound.y];Z=[hound.z]'>JMP</a>" : "null"])")
				playsound(src, gulpsound, vol = 100, vary = 1, falloff = 0.1, preference = /datum/preference/toggle/eating_noises)
				if(delivery)
					if(islist(deliverylists[delivery_tag]))
						deliverylists[delivery_tag] |= trashman
					to_chat(user, span_notice("\The [trashman] added to cargo compartment slot: [delivery_tag]."))
					to_chat(trashman, span_notice("[hound.name] has added you to their cargo compartment slot: [delivery_tag]."))
				update_patient()
			return
		return

	else if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if(H.buckled)
			to_chat(user, span_warning("The user is buckled and can not be put into your [src.name]."))
			return
		if(patient)
			to_chat(user, span_warning("Your [src.name] is already occupied."))
			return
		user.visible_message(span_warning("[hound.name] is ingesting [H.name] into their [src.name]."), span_notice("You start ingesting [H] into your [src]..."))
		if(!patient && !H.buckled && do_after (user, 50, H))
			if(!proximity)
				return //If they moved away, you can't eat them.
			if(patient)
				return //If you try to eat two people at once, you can only eat one.
			else //If you don't have someone in you, proceed.
				H.forceMove(src)
				H.reset_view(src)
				update_patient()
				START_PROCESSING(SSobj, src)
				user.visible_message(span_warning("[hound.name]'s [src.name] lights up as [H.name] slips inside."), span_notice("Your [src] lights up as [H] slips inside. Life support functions engaged."))
				log_admin("[key_name(hound)] has eaten [key_name(patient)] with a cyborg belly. ([hound ? "<a href='?_src_=holder;[HrefToken()];adminplayerobservecoodjump=1;X=[hound.x];Y=[hound.y];Z=[hound.z]'>JMP</a>" : "null"])")
				playsound(src, gulpsound, vol = 100, vary = 1, falloff = 0.1, preference = /datum/preference/toggle/eating_noises)

/obj/item/dogborg/sleeper/proc/ingest_atom(var/atom/ingesting)
	if (!ingesting || ingesting == hound)
		return
	var/obj/belly/belly = hound.vore_selected
	if (!istype(hound) || !istype(belly) || !(belly in hound.vore_organs))
		return
	if (isliving(ingesting))
		ingest_living(ingesting, belly)
	else if (istype(ingesting, /obj/item))
		var/obj/item/to_eat = ingesting
		if (is_type_in_list(to_eat, item_vore_blacklist))
			return
		if (istype(to_eat, /obj/item/holder)) //just in case
			var/obj/item/holder/micro = ingesting
			var/delete_holder = TRUE
			for (var/mob/living/M in micro.contents)
				if (!ingest_living(M, belly) || M.loc == micro)
					delete_holder = FALSE
			if (delete_holder)
				micro.held_mob = null
				qdel(micro)
			return
		to_eat.forceMove(belly)
		log_admin("VORE: [hound] used their [src] to swallow [to_eat].")

/obj/item/dogborg/sleeper/proc/ingest_living(var/mob/living/victim, var/obj/belly/belly)
	if (victim.devourable && is_vore_predator(hound))
		belly.nom_mob(victim, hound)
		add_attack_logs(hound, victim, "Eaten via [belly.name]")
		return TRUE
	return FALSE

/obj/item/dogborg/sleeper/proc/go_out()
	hound = src.loc
	items_preserved.Cut()
	cleaning = 0
	for(var/list/dlist in deliverylists)
		dlist.Cut()
	if(length(contents) > 0)
		hound.visible_message(span_warning("[hound.name] empties out their contents via their [eject_port] port."), span_notice("You empty your contents via your [eject_port] port."))
		for(var/C in contents)
			if(ishuman(C))
				var/mob/living/carbon/human/person = C
				person.forceMove(get_turf(src))
				person.reset_view()
			else
				var/obj/T = C
				T.loc = hound.loc
		playsound(src, 'sound/effects/splat.ogg', 50, 1)
	update_patient()

/obj/item/dogborg/sleeper/proc/vore_ingest_all()
	hound = src.loc
	if (!istype(hound) || length(contents) <= 0)
		return
	if (!hound.vore_selected)
		to_chat(hound, span_warning("You don't have a belly selected to empty the contents into!"))
		return
	for (var/C in contents)
		if (isliving(C) || isitem(C))
			ingest_atom(C)
	hound.updateVRPanel()
	update_patient()

/obj/item/dogborg/sleeper/proc/drain(var/amt = 3) //Slightly reduced cost (before, it was always injecting inaprov)
	hound = src.loc
	if(istype(hound,/obj/item/robot_module))
		hound = hound.loc
	hound.cell.charge = hound.cell.charge - amt

/obj/item/dogborg/sleeper/attack_self(mob/user)
	if(..())
		return
	sleeperUI(user)

/obj/item/dogborg/sleeper/proc/sleeperUI(mob/user)
	var/dat = "<TITLE>[name] Console</TITLE><BR>"

	if(islist(injection_chems)) //Only display this if we're a drug-dispensing doggo.
		dat += "<h3>Injector</h3>"
		if(patient)// && patient.health > min_health) //Not necessary, leave the buttons on, but the feedback during injection will give more information.
			for(var/re in injection_chems)
				var/datum/reagent/C = SSchemistry.chemical_reagents[re]
				if(C)
					dat += "<A href='?src=\ref[src];inject=[C.id]'>Inject [C.name]</A><BR>"
		else
			for(var/re in injection_chems)
				var/datum/reagent/C = SSchemistry.chemical_reagents[re]
				if(C)
					dat += span_linkOff("Inject [C.name]") + "<BR>"

	dat += "<h3>[name] Status</h3>"
	dat += "<div style='display: flex; flex-wrap: wrap; flex-direction: row;'>"
	dat += "<A id='refbutton' href='?src=\ref[src];refresh=1'>Refresh</A>"
	dat += "<A href='?src=\ref[src];eject=1'>Eject All</A>"
	dat += "<A href='?src=\ref[src];port=1'>Eject port: [eject_port]</A>"
	dat += "<A href='?src=\ref[src];ingest=1'>Vore All</A>" //might as well make it obvious
	if(!cleaning)
		dat += "<A href='?src=\ref[src];clean=1'>Self-Clean</A>"
	else
		dat += span_linkOff("Self-Clean")
	if(medsensor)
		dat += "<A href='?src=\ref[src];analyze=1'>Analyze Patient</A>"
	if(delivery)
		dat += "<BR><h3>Cargo Compartment</h3><BR>"
		dat += "<A href='?src=\ref[src];deliveryslot=1'>Active Slot: [delivery_tag]</A>"
		if(islist(deliverylists[delivery_tag]))
			dat += "<A href='?src=\ref[src];slot_eject=1'>Eject Slot</A>"
	dat += "</div>"
	dat += "<div class='statusDisplay'>"

	if(!delivery && compactor && length(contents))//garbage counter for trashpup
		dat += "<font color='red'><B>Current load:</B> [length(contents)] / [max_item_count] objects.</font><BR>"
		dat += "<font color='gray'>([contents.Join(", ")])</font><BR><BR>"

	if(delivery && length(contents))
		dat += "<font color='red'><B>Current load:</B> [length(contents)] / [max_item_count] objects.</font><BR>"
		dat += "<font color='gray'>Cargo compartment slot: Cargo 1.</font><BR>"
		if(length(deliveryslot_1))
			dat += "<font color='gray'>([deliveryslot_1.Join(", ")])</font><BR>"
		dat += "<font color='gray'>Cargo compartment slot: Cargo 2.</font><BR>"
		if(length(deliveryslot_2))
			dat += "<font color='gray'>([deliveryslot_2.Join(", ")])</font><BR>"
		dat += "<font color='gray'>Cargo compartment slot: Cargo 3.</font><BR>"
		if(length(deliveryslot_3))
			dat += "<font color='gray'>([deliveryslot_3.Join(", ")])</font><BR>"
		dat += "<font color='red'>Cargo compartment slot: Fuel.</font><BR>"
		dat += "<font color='red'>([jointext(contents - (deliveryslot_1 + deliveryslot_2 + deliveryslot_3),", ")])</font><BR><BR>"

	if(analyzer && !synced)
		dat += "<A href='?src=\ref[src];sync=1'>Sync Files</A><BR>"

	//Cleaning and there are still un-preserved items
	if(cleaning && length(contents - items_preserved))
		dat += "<font color='red'><B>Self-cleaning mode.</B> [length(contents - items_preserved)] object(s) remaining.</font><BR>"

	//There are no items to be processed other than un-preserved items
	else if(cleaning && length(items_preserved))
		dat += "<font color='red'><B>Self-cleaning done. Eject remaining objects now.</B></font><BR>"

	//Preserved items count when the list is populated
	if(length(items_preserved))
		dat += "<font color='red'>[length(items_preserved)] uncleanable object(s).</font><BR>"

	if(!patient)
		dat += "[src.name] Unoccupied"
	else
		dat += "[patient.name] => "

		switch(patient.stat)
			if(0)
				dat += span_green("Conscious")
			if(1)
				dat += span_orange("Unconscious")
			else
				dat += span_red("DEAD")

		var/pulse = "\t-Pulse, bpm: [patient.get_pulse(GETPULSE_TOOL)]"
		dat += (patient.pulse == PULSE_NONE || patient.pulse == PULSE_THREADY ? span_red(pulse) : span_white(pulse))
		dat += "<BR>"
		var/health = "\t-Overall Health %: [round(100 * (patient.health / patient.getMaxHealth()))]"
		dat += (patient.health > 0 ? span_white(health) : span_red(health))
		dat += "<BR>"
		var/brute = "\t-Brute Damage %: [patient.getBruteLoss()]"
		dat += (patient.getBruteLoss() < 60 ? span_gray(brute) : span_red(brute))
		dat += "<BR>"
		var/oxygen = "\t-Respiratory Damage %: [patient.getOxyLoss()]"
		dat += (patient.getOxyLoss() < 60 ? span_gray(oxygen) : span_red(oxygen))
		dat += "<BR>"
		var/toxic = "\t-Toxin Content %: [patient.getToxLoss()]"
		dat += (patient.getToxLoss() < 60 ? span_gray(toxic) : span_red(toxic))
		dat += "<BR>"
		var/burn = "\t-Burn Severity %: [patient.getFireLoss()]"
		dat += (patient.getFireLoss() < 60 ? span_gray(burn) : span_red(burn))
		dat += "<BR>"

		if(round(patient.paralysis / 4) >= 1)
			dat += text("<HR>Patient paralyzed for: []<BR>", round(patient.paralysis / 4) >= 1 ? "[round(patient.paralysis / 4)] seconds" : "None")
		if(patient.getBrainLoss())
			dat += "<div class='line'>" + span_orange("Significant brain damage detected.") + "</div><br>"
		if(patient.getCloneLoss())
			dat += "<div class='line'>" + span_orange("Patient may be improperly cloned.") + "</div><br>"
		if(patient.reagents.reagent_list.len)
			for(var/datum/reagent/R in patient.reagents.reagent_list)
				dat += "<div class='line'><div style='width: 170px;' class='statusLabel'>[R.name]:</div><div class='statusValue'>[round(R.volume, 0.1)] units</div></div><br>"
	dat += "</div>"

	var/datum/browser/popup = new(user, "sleeper_b", "[name] Console", 450, 500, src)
	popup.set_content(dat)
	popup.open()
	UI_open = TRUE
	return

/obj/item/dogborg/sleeper/Topic(href, href_list)
	if(..() || usr == patient)
		return
	usr.set_machine(src)
	if(href_list["refresh"])
		update_patient()
		src.updateUsrDialog()
		sleeperUI(usr)
		return
	if(href_list["eject"])
		go_out()
		sleeperUI(usr)
		return
	if(href_list["close"])
		UI_open = FALSE
		return
	if(href_list["clean"])
		if(!cleaning)
			var/confirm = tgui_alert(usr, "You are about to engage self-cleaning mode. This will fill your [src] with caustic enzymes to remove any objects or biomatter, and convert them into energy. Are you sure?", "Confirmation", list("Self-Clean", "Cancel"))
			if(confirm == "Self-Clean")
				if(cleaning)
					return
				else
					cleaning = 1
					drain(startdrain)
					START_PROCESSING(SSobj, src)
					update_patient()
					if(patient)
						to_chat(patient, span_danger("[hound.name]'s [src.name] fills with caustic enzymes around you!"))
					return
		if(cleaning)
			sleeperUI(usr)
			return
	if(href_list["analyze"]) //DO HEALTH ANALYZER STUFF HERE.
		med_analyzer.scan_mob(patient,hound)
	if(href_list["port"])
		switch(eject_port)
			if("ingestion")
				eject_port = "disposal"
			if("disposal")
				eject_port = "ingestion"
		sleeperUI(usr)
		return
	if (href_list["ingest"])
		vore_ingest_all()
		sleeperUI(usr)
		return
	if(href_list["deliveryslot"])
		var/tag = tgui_input_list(usr, "Select active delivery slot:", "Slot Choice", deliverylists)
		if(!tag)
			return 0
		delivery_tag = tag
		sleeperUI(usr)
		return
	if(href_list["slot_eject"])
		if(length(deliverylists[delivery_tag]) > 0)
			hound.visible_message(span_warning("[hound.name] empties out their cargo compartment via their [eject_port] port."), span_notice("You empty your cargo compartment via your [eject_port] port."))
			for(var/C in deliverylists[delivery_tag])
				if(ishuman(C))
					var/mob/living/carbon/human/person = C
					person.forceMove(get_turf(src))
					person.reset_view()
				else
					var/obj/T = C
					T.loc = hound.loc
			playsound(src, 'sound/effects/splat.ogg', 50, 1)
			update_patient()
			deliverylists[delivery_tag].Cut()
		sleeperUI(usr)
		return
	if(href_list["sync"])
		synced = TRUE
		var/success = 0
		for(var/obj/machinery/r_n_d/server/S in machines)
			for(var/datum/tech/T in files.known_tech) //Uploading
				S.files.AddTech2Known(T)
			for(var/datum/tech/T in S.files.known_tech) //Downloading
				files.AddTech2Known(T)
			success = 1
			files.RefreshResearch()
		if(success)
			to_chat(usr, "You connect to the research server, push your data upstream to it, then pull the resulting merged data from the master branch.")
			playsound(src, 'sound/machines/twobeep.ogg', 50, 1)
		else
			to_chat(usr, "Reserch server ping response timed out.  Unable to connect.  Please contact the system administrator.")
			playsound(src, 'sound/machines/buzz-two.ogg', 50, 1)
		sleeperUI(usr)
		return

	if(patient && !(patient.stat & DEAD)) //What is bitwise NOT? ... Thought it was tilde.
		if(href_list["inject"] == REAGENT_ID_INAPROVALINE || patient.health > min_health)
			inject_chem(usr, href_list["inject"])
		else
			to_chat(usr, span_notice("ERROR: Subject is not in stable condition for injections."))
	else
		to_chat(usr, span_notice("ERROR: Subject cannot metabolise chemicals."))

	updateUsrDialog()
	sleeperUI(usr) //Needs a callback to boop the page to refresh.
	return

/obj/item/dogborg/sleeper/proc/inject_chem(mob/user, chem)
	if(patient && patient.reagents)
		if(chem in injection_chems + REAGENT_ID_INAPROVALINE)
			if(hound.cell.charge < 800) //This is so borgs don't kill themselves with it.
				to_chat(hound, span_notice("You don't have enough power to synthesize fluids."))
				return
			else if(patient.reagents.get_reagent_amount(chem) + 10 >= 20) //Preventing people from accidentally killing themselves by trying to inject too many chemicals!
				to_chat(hound, span_notice("Your stomach is currently too full of fluids to secrete more fluids of this kind."))
			else if(patient.reagents.get_reagent_amount(chem) + 10 <= 20) //No overdoses for you
				patient.reagents.add_reagent(chem, inject_amount)
				drain(SLEEPER_INJECT_COST)
			var/units = round(patient.reagents.get_reagent_amount(chem))
			to_chat(hound, span_notice("Injecting [units] unit\s of [SSchemistry.chemical_reagents[chem]] into occupant.")) //If they were immersed, the reagents wouldn't leave with them.

//For if the dogborg's existing patient uh, doesn't make it.
/obj/item/dogborg/sleeper/proc/update_patient()
	hound = src.loc
	if(!istype(hound,/mob/living/silicon/robot))
		return
	if(UI_open == TRUE)
		sleeperUI(hound)

	//Cleaning looks better with red on, even with nobody in it
	if(cleaning || (length(contents) > 10) || (decompiler && (length(contents) > 5)) || (analyzer && (length(contents) > 1)))
		hound.sleeper_state = 1
		hound.update_icon()
		return

	//Well, we HAD one, what happened to them?
	if(patient in contents)
		if(medsensor)
			if(patient_laststat != patient.stat)
				if(cleaning || (patient.stat & DEAD))
					hound.sleeper_state = 1
					patient_laststat = patient.stat
				else
					hound.sleeper_state = 2
					patient_laststat = patient.stat
		else
			hound.sleeper_state = 1
			patient_laststat = patient.stat
		//Update icon
		hound.update_icon()
		//Return original patient
		return(patient)

	//Check for a new patient
	else
		for(var/mob/living/carbon/human/C in contents)
			patient = C
			if(medsensor)
				if(cleaning || (patient.stat & DEAD))
					hound.sleeper_state = 1
					patient_laststat = patient.stat
				else
					hound.sleeper_state = 2
					patient_laststat = patient.stat
			else
				hound.sleeper_state = 1
				patient_laststat = patient.stat
			//Update icon and return new patient
			hound.update_icon()
			return(C)

	//Couldn't find anyone, and not cleaning
	if(!cleaning && !patient)
		hound.sleeper_state = 0

	patient_laststat = null
	patient = null
	hound.update_icon()
	return

//Gurgleborg process
/obj/item/dogborg/sleeper/proc/clean_cycle()

	//Sanity? Maybe not required. More like if indigestible person OOC escapes.
	for(var/I in items_preserved)
		if(!(I in contents))
			items_preserved -= I

	var/list/touchable_items = contents - items_preserved - (deliveryslot_1 + deliveryslot_2 + deliveryslot_3)

	//Belly is entirely empty
	if(!length(touchable_items))
		var/finisher = pick(
			'sound/vore/death1.ogg',
			'sound/vore/death2.ogg',
			'sound/vore/death3.ogg',
			'sound/vore/death4.ogg',
			'sound/vore/death5.ogg',
			'sound/vore/death6.ogg',
			'sound/vore/death7.ogg',
			'sound/vore/death8.ogg',
			'sound/vore/death9.ogg',
			'sound/vore/death10.ogg')
		playsound(src, finisher, vol = 100, vary = 1, falloff = 0.1, ignore_walls = TRUE, preference = /datum/preference/toggle/digestion_noises)
		to_chat(hound, span_notice("Your [src.name] is now clean. Ending self-cleaning cycle."))
		cleaning = 0
		update_patient()
		playsound(src, 'sound/machines/ding.ogg', vol = 100, vary = 1, falloff = 0.1, ignore_walls = TRUE, preference = /datum/preference/toggle/digestion_noises)
		return

	if(prob(20))
		var/churnsound = pick(
			'sound/vore/digest1.ogg',
			'sound/vore/digest2.ogg',
			'sound/vore/digest3.ogg',
			'sound/vore/digest4.ogg',
			'sound/vore/digest5.ogg',
			'sound/vore/digest6.ogg',
			'sound/vore/digest7.ogg',
			'sound/vore/digest8.ogg',
			'sound/vore/digest9.ogg',
			'sound/vore/digest10.ogg',
			'sound/vore/digest11.ogg',
			'sound/vore/digest12.ogg')
		playsound(src, churnsound, vol = 100, vary = 1, falloff = 0.1, ignore_walls = TRUE, preference = /datum/preference/toggle/digestion_noises)
	//If the timing is right, and there are items to be touched
	if(SSair.current_cycle%3==1 && length(touchable_items))

		//Burn all the mobs or add them to the exclusion list
		for(var/mob/living/T in (touchable_items))
			touchable_items -= T //Exclude mobs from loose item picking.
			if((T.status_flags & GODMODE) || !T.digestable)
				items_preserved |= T
			else
				var/old_brute = T.getBruteLoss()
				var/old_burn = T.getFireLoss()
				T.adjustBruteLoss(digest_brute * digest_multiplier)
				T.adjustFireLoss(digest_burn * digest_multiplier)
				var/actual_brute = T.getBruteLoss() - old_brute
				var/actual_burn = T.getFireLoss() - old_burn
				var/damage_gain = actual_brute + actual_burn
				drain(-25 * damage_gain) //25*total loss as with voreorgan stats.
				if(T.stat == DEAD)
					if(ishuman(T))
						log_admin("[key_name(hound)] has digested [key_name(T)] with a cyborg belly. ([hound ? "<a href='?_src_=holder;[HrefToken()];adminplayerobservecoodjump=1;X=[hound.x];Y=[hound.y];Z=[hound.z]'>JMP</a>" : "null"])")
					to_chat(hound, span_notice("You feel your belly slowly churn around [T], breaking them down into a soft slurry to be used as power for your systems."))
					to_chat(T, span_notice("You feel [hound]'s belly slowly churn around your form, breaking you down into a soft slurry to be used as power for [hound]'s systems."))
					var/deathsound = pick(
						'sound/vore/death1.ogg',
						'sound/vore/death2.ogg',
						'sound/vore/death3.ogg',
						'sound/vore/death4.ogg',
						'sound/vore/death5.ogg',
						'sound/vore/death6.ogg',
						'sound/vore/death7.ogg',
						'sound/vore/death8.ogg',
						'sound/vore/death9.ogg',
						'sound/vore/death10.ogg')
					playsound(src, deathsound, vol = 100, vary = 1, falloff = 0.1, ignore_walls = TRUE, preference = /datum/preference/toggle/digestion_noises)
					if(is_vore_predator(T))
						for(var/obj/belly/B as anything in T.vore_organs)
							for(var/atom/movable/thing in B)
								thing.forceMove(src)
								if(ismob(thing))
									to_chat(thing, span_filter_notice("As [T] melts away around you, you find yourself in [hound]'s [name]."))
					for(var/obj/item/I in T)
						if(istype(I,/obj/item/organ/internal/mmi_holder/posibrain))
							var/obj/item/organ/internal/mmi_holder/MMI = I
							var/atom/movable/brain = MMI.removed()
							if(brain)
								hound.remove_from_mob(brain,src)
								brain.forceMove(src)
								items_preserved |= brain
						else
							T.drop_from_inventory(I, src)
					if(T.ckey)
						GLOB.prey_digested_roundstat++
					if(patient == T)
						patient_laststat = null
						patient = null
					T.mind?.vore_death = TRUE
					qdel(T)

		//Pick a random item to deal with (if there are any)
		if(length(touchable_items))
			var/atom/target = pick(touchable_items)

			//Handle the target being anything but a /mob/living
			var/obj/item/T = target
			if(istype(T))
				var/digested = T.digest_act(item_storage = src)
				if(!digested)
					items_preserved |= T
				else
					if(analyzer && digested)
						var/obj/item/tech_item = T
						for(var/tech in tech_item.origin_tech)
							files.UpdateTech(tech, tech_item.origin_tech[tech])
							synced = FALSE
					if(recycles && T.matter)
						for(var/material in T.matter)
							var/total_material = T.matter[material]
							if(istype(T,/obj/item/stack))
								var/obj/item/stack/stack = T
								total_material *= stack.get_amount()
							if(material == MAT_STEEL && metal)
								metal.add_charge(total_material)
							if(material == MAT_GLASS && glass)
								glass.add_charge(total_material)
							if(decompiler)
								if(material == MAT_PLASTIC && plastic)
									plastic.add_charge(total_material)
								if(material == MAT_WOOD && wood)
									wood.add_charge(total_material)
					drain(-50 * digested)
			else if(istype(target,/obj/effect/decal/remains))
				qdel(target)
				drain(-100)
			else
				items_preserved |= target
		update_patient()
	return

/obj/item/dogborg/sleeper/process()
	if(!istype(src.loc,/mob/living/silicon/robot))
		return

	if(cleaning) //We're cleaning, return early after calling this as we don't care about the patient.
		clean_cycle()
		return

	if(patient && stabilizer) //We're caring for the patient. Medical emergency! Or endo scene.
		update_patient()
		if(patient.health < 0)
			patient.adjustOxyLoss(-1) //Heal some oxygen damage if they're in critical condition
			patient.updatehealth()
			drain()
		patient.AdjustStunned(-4)
		patient.AdjustWeakened(-4)
		drain(1)
		return

	if(!patient && !cleaning) //We think we're done working.
		if(!update_patient()) //One last try to find someone
			STOP_PROCESSING(SSobj, src)
			return

/obj/item/dogborg/sleeper/K9 //The K9 portabrig
	name = "Brig-Belly"
	desc = "A mounted portable-brig that holds criminals for processing or 'processing'."
	icon_state = "sleeperb"
	injection_chems = null //So they don't have all the same chems as the medihound!
	stabilizer = TRUE
	medsensor = FALSE

/obj/item/dogborg/sleeper/compactor //Janihound gut.
	name = "Garbage Processor"
	desc = "A mounted garbage compactor unit with fuel processor, capable of processing any kind of contaminant."
	icon_state = "compactor"
	injection_chems = null //So they don't have all the same chems as the medihound!
	compactor = TRUE
	recycles = TRUE
	max_item_count = 25
	stabilizer = FALSE
	medsensor = FALSE

/obj/item/dogborg/sleeper/compactor/analyzer //sci-borg gut.
	name = "Digestive Analyzer"
	desc = "A mounted destructive analyzer unit with fuel processor, for 'deep scientific analysis'."
	icon_state = "analyzer"
	max_item_count = 10
	startdrain = 100
	analyzer = TRUE
	recycles = FALSE

/obj/item/dogborg/sleeper/compactor/decompiler
	name = "Matter Decompiler"
	desc = "A mounted matter decompiling unit with fuel processor, for recycling anything and everyone."
	icon_state = "decompiler"
	max_item_count = 10
	decompiler = TRUE
	recycles = TRUE
/*
/obj/item/dogborg/sleeper/compactor/delivery //Unfinished and unimplemented, still testing.
	name = "Cargo Belly"
	desc = "A mounted cargo bay unit for tagged deliveries."
	icon_state = "decompiler"
	max_item_count = 20
	delivery = TRUE
	recycles = FALSE
*/
/obj/item/dogborg/sleeper/compactor/supply //Miner borg belly
	name = "Supply Storage"
	desc = "A mounted survival unit with fuel processor, helpful with both deliveries and assisting injured miners."
	icon_state = "sleeperc"
	injection_chems = list(REAGENT_ID_GLUCOSE,REAGENT_ID_INAPROVALINE,REAGENT_ID_TRICORDRAZINE)
	max_item_count = 10
	recycles = FALSE
	stabilizer = TRUE
	medsensor = FALSE

/obj/item/dogborg/sleeper/compactor/brewer
	name = "Brew Belly"
	desc = "A mounted drunk tank unit with fuel processor, for putting away particularly rowdy patrons."
	icon_state = "brewer"
	injection_chems = null //So they don't have all the same chems as the medihound!
	max_item_count = 10
	recycles = FALSE
	stabilizer = TRUE
	medsensor = FALSE

/obj/item/dogborg/sleeper/compactor/generic
	name = "Internal Cache"
	desc = "An internal storage of no particularly specific purpose.."
	icon_state = "sleeperd"
	max_item_count = 10
	recycles = FALSE

/obj/item/dogborg/sleeper/K9/ert
	name = "Emergency Storage"
	desc = "A mounted 'emergency containment cell'."
	icon_state = "sleeperert"
	injection_chems = list(REAGENT_ID_INAPROVALINE, REAGENT_ID_TRAMADOL) // short list

/obj/item/dogborg/sleeper/trauma //Trauma borg belly
	name = "Recovery Belly"
	desc = "A downgraded model of the sleeper belly, intended primarily for post-surgery recovery."
	icon_state = "sleeper"
	injection_chems = list(REAGENT_ID_INAPROVALINE, REAGENT_ID_DEXALIN, REAGENT_ID_TRICORDRAZINE, REAGENT_ID_SPACEACILLIN, REAGENT_ID_OXYCODONE)

/obj/item/dogborg/sleeper/lost
	name = "Multipurpose Belly"
	desc = "A multipurpose belly, capable of functioning as both sleeper and processor."
	icon_state = "sleeperlost"
	injection_chems = list(REAGENT_ID_TRICORDRAZINE, REAGENT_ID_BICARIDINE, REAGENT_ID_DEXALIN, REAGENT_ID_ANTITOXIN, REAGENT_ID_TRAMADOL, REAGENT_ID_SPACEACILLIN)
	compactor = TRUE
	max_item_count = 25
	stabilizer = TRUE
	medsensor = TRUE

/obj/item/dogborg/sleeper/syndie
	name = "Combat Triage Belly"
	desc = "A mounted sleeper that stabilizes patients and can inject reagents in the borg's reserves. This one is for more extreme combat scenarios."
	icon_state = "sleepersyndiemed"
	injection_chems = list(REAGENT_ID_HEALINGNANITES, REAGENT_ID_HYPERZINE, REAGENT_ID_TRAMADOL, REAGENT_ID_OXYCODONE, REAGENT_ID_SPACEACILLIN, REAGENT_ID_PERIDAXON, REAGENT_ID_OSTEODAXON, REAGENT_ID_MYELAMINE, REAGENT_ID_SYNTHBLOOD)
	digest_multiplier = 2

/obj/item/dogborg/sleeper/K9/syndie
	name = "Cell-Belly"
	desc = "A mounted portable cell that holds anyone you wish for processing or 'processing'."
	icon_state = "sleepersyndiebrig"
	digest_multiplier = 3

/obj/item/dogborg/sleeper/compactor/syndie
	name = "Advanced Matter Decompiler"
	desc = "A mounted matter decompiling unit with fuel processor, for recycling anything and everyone in your way."
	icon_state = "sleepersyndieeng"
	max_item_count = 35
	digest_multiplier = 3

#undef SLEEPER_INJECT_COST
