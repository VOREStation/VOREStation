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
	var/synced = FALSE
	var/startdrain = 500
	var/max_item_count = 1
	var/upgraded_capacity = FALSE
	var/gulpsound = 'sound/vore/gulp.ogg'
	var/datum/matter_synth/metal = null
	var/datum/matter_synth/glass = null
	var/datum/matter_synth/wood = null
	var/datum/matter_synth/plastic = null
	var/datum/matter_synth/water = null
	var/digest_brute = 2
	var/digest_burn = 3
	var/digest_multiplier = 1
	var/recycles = FALSE
	var/medsensor = TRUE //Does belly sprite come with patient ok/dead light?
	var/obj/item/healthanalyzer/med_analyzer = null
	var/ore_storage = FALSE
	var/max_ore_storage = 500
	var/current_capacity = 0
	flags = NOBLUDGEON

/obj/item/dogborg/sleeper/Initialize(mapload)
	if(analyzer) //Destructive analysis
		var/static/list/destructive_signals = list(
			COMSIG_MACHINERY_DESTRUCTIVE_SCAN = TYPE_PROC_REF(/datum/component/experiment_handler, try_run_destructive_experiment),
		)
		AddComponent(/datum/component/experiment_handler, \
			config_mode = EXPERIMENT_CONFIG_ALTCLICK, \
			allowed_experiments = list(/datum/experiment/scanning),\
			config_flags = EXPERIMENT_CONFIG_ALWAYS_ACTIVE|EXPERIMENT_CONFIG_SILENT_FAIL,\
			experiment_signals = destructive_signals, \
		)
	. = ..()
	med_analyzer = new /obj/item/healthanalyzer

/obj/item/dogborg/sleeper/Destroy()
	go_out()
	. = ..()

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
		if(is_type_in_list(target, GLOB.item_vore_blacklist))
			to_chat(user, span_warning("You are hard-wired to not ingest this item."))
			return
		if(istype(target, /obj/item) || istype(target, /obj/effect/decal/remains))
			var/obj/target_obj = target
			if(target_obj.w_class > ITEMSIZE_LARGE)
				to_chat(user, span_warning("\The [target] is too large to fit into your [src.name]"))
				return
			user.visible_message(span_warning("[hound.name] is ingesting [target.name] into their [src.name]."), span_notice("You start ingesting [target] into your [src.name]..."))
			if(do_after(user, 3 SECONDS, target) && length(contents) < max_item_count)
				target.forceMove(src)
				user.visible_message(span_warning("[hound.name]'s [src.name] groans lightly as [target.name] slips inside."), span_notice("Your [src.name] groans lightly as [target] slips inside."))
				playsound(src, gulpsound, vol = 60, vary = 1, falloff = 0.1, preference = /datum/preference/toggle/eating_noises)
				if(delivery)
					if(islist(deliverylists[delivery_tag]))
						deliverylists[delivery_tag] |= target
					to_chat(user, span_notice("\The [target.name] added to cargo compartment slot: [delivery_tag]."))
				update_patient()
			return
		if(istype(target, /mob/living/simple_mob/animal/passive/mouse)) //Edible mice, dead or alive whatever. Mostly for carcass picking you cruel bastard :v
			var/mob/living/simple_mob/trashmouse = target
			user.visible_message(span_warning("[hound.name] is ingesting [trashmouse] into their [src.name]."), span_notice("You start ingesting [trashmouse] into your [src.name]..."))
			if(do_after(user, 3 SECONDS, target = trashmouse) && length(contents) < max_item_count)
				trashmouse.forceMove(src)
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
			if(do_after(user, 3 SECONDS, target = trashman) && !patient && !trashman.buckled && length(contents) < max_item_count)
				trashman.forceMove(src)
				START_PROCESSING(SSobj, src)
				user.visible_message(span_warning("[hound.name]'s [src.name] groans lightly as [trashman] slips inside."), span_notice("Your [src.name] groans lightly as [trashman] slips inside."))
				log_attack("[key_name(hound)] has eaten [key_name(patient)] with a cyborg belly. ([hound ? "<a href='byond://?_src_=holder;[HrefToken()];adminplayerobservecoodjump=1;X=[hound.x];Y=[hound.y];Z=[hound.z]'>JMP</a>" : "null"])")
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
				update_patient()
				START_PROCESSING(SSobj, src)
				user.visible_message(span_warning("[hound.name]'s [src.name] lights up as [H.name] slips inside."), span_notice("Your [src] lights up as [H] slips inside. Life support functions engaged."))
				log_admin("[key_name(hound)] has eaten [key_name(patient)] with a cyborg belly. ([hound ? "<a href='byond://?_src_=holder;[HrefToken()];adminplayerobservecoodjump=1;X=[hound.x];Y=[hound.y];Z=[hound.z]'>JMP</a>" : "null"])")
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
		if (is_type_in_list(to_eat, GLOB.item_vore_blacklist))
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
		belly.nom_atom(victim, hound)
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
		for(var/atom/movable/content in contents)
			content.forceMove(get_turf(src))
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
	. = ..(user)
	if(.)
		return TRUE
	tgui_interact(user)

/obj/item/dogborg/sleeper/tgui_state(mob/user)
	return GLOB.tgui_conscious_state

/obj/item/dogborg/sleeper/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "RobotSleeper", "[name] Console")
		ui.open()

/obj/item/dogborg/sleeper/tgui_static_data(mob/user)
	var/list/data = ..()

	if(!isrobot(user))
		return data

	var/mob/living/silicon/robot/robot_user = user
	var/list/robot_chems = list()
	for(var/re in injection_chems)
		var/datum/reagent/possible_reagent = SSchemistry.chemical_reagents[re]
		UNTYPED_LIST_ADD(robot_chems, list("id" = possible_reagent.id, "name" = possible_reagent.name))

	data["name"] = name
	data["theme"] = robot_user.get_ui_theme()
	data["chems"] = robot_chems
	return data

/obj/item/dogborg/sleeper/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/patient_data

	if(patient)
		var/list/ingested_reagents = list()
		if(patient.reagents.reagent_list.len)
			for(var/datum/reagent/ingested in patient.reagents.reagent_list)
				UNTYPED_LIST_ADD(ingested_reagents, list("name" = ingested.name, "volume" = ingested.volume))

		patient_data = list(
			"name" = patient.name,
			"stat" = patient.stat,
			"pulse" = patient.get_pulse(GETPULSE_TOOL),
			"crit_pulse" = (patient.pulse == PULSE_NONE || patient.pulse == PULSE_THREADY),
			"health" = patient.health,
			"max_health" = patient.getMaxHealth(),
			"brute" = patient.getBruteLoss(),
			"oxy" = patient.getOxyLoss(),
			"tox" = patient.getToxLoss(),
			"burn" = patient.getFireLoss(),
			"paralysis" = patient.paralysis,
			"braindamage" = !!patient.getBrainLoss(),
			"clonedamage" = !!patient.getCloneLoss(),
			"ingested_reagents" = ingested_reagents
			)

	var/datum/component/experiment_handler/handler = get_experiment_handler()
	var/list/data = list(
		"our_patient" = patient_data,
		"eject_port" = eject_port,
		"cleaning" = cleaning,
		"medsensor" = medsensor,
		"delivery" = delivery,
		"delivery_tag" = delivery_tag,
		"delivery_lists" = deliverylists,
		"compactor" = compactor,
		"max_item_count" = max_item_count,
		"ore_storage" = ore_storage,
		"current_capacity" = current_capacity,
		"max_ore_storage" = max_ore_storage,
		"contents" = contents,
		"deliveryslot_1" = deliveryslot_1,
		"deliveryslot_2" = deliveryslot_2,
		"deliveryslot_3" = deliveryslot_3,
		"items_preserved" = items_preserved,
		"has_destructive_analyzer" = analyzer,
		"techweb_name" = handler?.linked_web ? "[handler.linked_web.id] / [handler.linked_web.organization]" : "Disconnected",
	)
	return data
/obj/item/dogborg/sleeper/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	if(ui.user == patient)
		return FALSE

	switch(action)
		if("eject")
			go_out()
			return TRUE
		if("clean")
			if(cleaning)
				return FALSE
			cleaning = TRUE
			drain(startdrain)
			START_PROCESSING(SSobj, src)
			update_patient()
			if(patient)
				to_chat(patient, span_danger("[hound.name]'s [src.name] fills with caustic enzymes around you!"))
			return TRUE
		if("analyze")
			med_analyzer.scan_mob(patient,hound)
			return TRUE
		if("port")
			var/new_port = params["value"]
			if(!(new_port in list("disposal", "ingestion")))
				return FALSE
			eject_port = new_port
			return TRUE
		if("ingest")
			vore_ingest_all()
			return TRUE
		if("deliveryslot")
			var/new_tag = params["value"]
			if(!(new_tag in deliverylists))
				return FALSE
			delivery_tag = new_tag
			return TRUE
		if("slot_eject")
			if(!length(deliverylists[delivery_tag]))
				return FALSE
			hound.visible_message(span_warning("[hound.name] empties out their cargo compartment via their [eject_port] port."), span_notice("You empty your cargo compartment via your [eject_port] port."))
			for(var/atom/movable/content in deliverylists[delivery_tag])
				content.forceMove(get_turf(src))
			playsound(src, 'sound/effects/splat.ogg', 50, 1)
			update_patient()
			deliverylists[delivery_tag].Cut()
			return TRUE
		if("inject")
			if(!patient || (patient.stat & DEAD))
				to_chat(ui.user, span_notice("ERROR: Subject cannot metabolise chemicals."))
				return FALSE
			var/selected_reagent = params["value"]
			if(!(selected_reagent in injection_chems))
				return FALSE
			if(selected_reagent == REAGENT_ID_INAPROVALINE || patient.health > min_health)
				inject_chem(ui.user, selected_reagent)
			else
				to_chat(ui.user, span_notice("ERROR: Subject is not in stable condition for injections."))
			return TRUE

/obj/item/dogborg/sleeper/proc/inject_chem(mob/user, chem)
	if(patient && patient.reagents)
		if(chem in (injection_chems + REAGENT_ID_INAPROVALINE))
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
		var/volume = 0
		for(var/mob/living/T in (touchable_items))
			touchable_items -= T //Exclude mobs from loose item picking.
			if(SEND_SIGNAL(T, COMSIG_CHECK_FOR_GODMODE) & COMSIG_GODMODE_CANCEL)
				items_preserved |= T
			else if(!T.digestable)
				items_preserved |= T
			else
				var/old_brute = T.getBruteLoss()
				var/old_burn = T.getFireLoss()
				T.adjustBruteLoss(digest_brute * digest_multiplier)
				T.adjustFireLoss(digest_burn * digest_multiplier)
				var/actual_brute = T.getBruteLoss() - old_brute
				var/actual_burn = T.getFireLoss() - old_burn
				var/damage_gain = actual_brute + actual_burn
				hound.adjust_nutrition(2.5 * damage_gain) //drain(-25 * damage_gain) //25*total loss as with voreorgan stats.
				if(water)
					water.add_charge(damage_gain)
				if(T.stat == DEAD)
					if(ishuman(T))
						log_admin("[key_name(hound)] has digested [key_name(T)] with a cyborg belly. ([hound ? "<a href='byond://?_src_=holder;[HrefToken()];adminplayerobservecoodjump=1;X=[hound.x];Y=[hound.y];Z=[hound.z]'>JMP</a>" : "null"])")
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
					if(ishuman(T))
						var/mob/living/carbon/human/Prey = T
						volume = (Prey.bloodstr.total_volume + Prey.ingested.total_volume + Prey.touching.total_volume + Prey.weight) * Prey.size_multiplier
					if(water)
						water.add_charge(volume)
					if(T.reagents)
						volume = T.reagents.total_volume
						if(water)
							water.add_charge(volume)
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
				if(T.reagents)
					volume = T.reagents.total_volume
				var/is_trash = istype(T, /obj/item/trash)
				var/digested = T.digest_act(item_storage = src)
				if(!digested)
					items_preserved |= T
				else
					if(volume && water)
						water.add_charge(volume)
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
					var/datum/component/experiment_handler/handler = get_experiment_handler()
					if(analyzer && handler)
						techweb_item_generate_points(T, handler.linked_web)
						SEND_SIGNAL(src, COMSIG_MACHINERY_DESTRUCTIVE_SCAN, T)
					if(is_trash)
						hound.adjust_nutrition(digested)
					else
						hound.adjust_nutrition(5 * digested)  //drain(-50 * digested)
			else if(istype(target,/obj/effect/decal/remains))
				qdel(target)
				hound.adjust_nutrition(10) //drain(-100)
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

/obj/item/dogborg/sleeper/proc/get_experiment_handler()
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)
	RETURN_TYPE(/datum/component/experiment_handler)
	if(!analyzer)
		return null
	return GetComponent(/datum/component/experiment_handler)

#undef SLEEPER_INJECT_COST
