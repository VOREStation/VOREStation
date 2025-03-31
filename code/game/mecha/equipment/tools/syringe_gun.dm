/obj/item/mecha_parts/mecha_equipment/tool/syringe_gun
	name = "syringe gun"
	desc = "Exosuit-mounted chem synthesizer with syringe gun. Reagents inside are held in stasis, so no reactions will occur. (Can be attached to: Medical Exosuits)"
	mech_flags = EXOSUIT_MODULE_MEDICAL
	icon = 'icons/obj/gun.dmi'
	icon_state = "syringegun"
	var/list/syringes
	var/list/known_reagents
	var/list/processed_reagents
	var/max_syringes = 10
	var/max_volume = 75 //max reagent volume
	var/synth_speed = 5 //[num] reagent units per cycle
	energy_drain = 10
	var/mode = 0 //0 - fire syringe, 1 - analyze reagents.
	var/datum/global_iterator/mech_synth/synth
	range = MELEE|RANGED
	equip_cooldown = 10
	origin_tech = list(TECH_MATERIAL = 3, TECH_BIO = 4, TECH_MAGNET = 4, TECH_DATA = 3)
	required_type = list(/obj/mecha/medical)

/obj/item/mecha_parts/mecha_equipment/tool/syringe_gun/Initialize(mapload)
	. = ..()
	flags |= NOREACT
	syringes = new
	known_reagents = list(REAGENT_ID_INAPROVALINE=REAGENT_INAPROVALINE,REAGENT_ID_ANTITOXIN=REAGENT_ANTITOXIN)
	processed_reagents = new
	create_reagents(max_volume)

/obj/item/mecha_parts/mecha_equipment/tool/syringe_gun/detach()
	STOP_PROCESSING(SSfastprocess, src)
	return ..()

/obj/item/mecha_parts/mecha_equipment/tool/syringe_gun/critfail()
	..()
	flags &= ~NOREACT
	return

/obj/item/mecha_parts/mecha_equipment/tool/syringe_gun/get_equip_info()
	var/output = ..()
	if(output)
		return "[output] \[<a href=\"?src=\ref[src];toggle_mode=1\">[mode? "Analyze" : "Launch"]</a>\]<br />\[Syringes: [syringes.len]/[max_syringes] | Reagents: [reagents.total_volume]/[reagents.maximum_volume]\]<br /><a href='byond://?src=\ref[src];show_reagents=1'>Reagents list</a>"
	return

/obj/item/mecha_parts/mecha_equipment/tool/syringe_gun/action(atom/movable/target)
	if(!action_checks(target))
		return
	if(istype(target,/obj/item/reagent_containers/syringe))
		return load_syringe(target)
	if(istype(target,/obj/item/storage))//Loads syringes from boxes
		for(var/obj/item/reagent_containers/syringe/S in target.contents)
			load_syringe(S)
		return
	if(mode)
		return analyze_reagents(target)
	if(!syringes.len)
		occupant_message(span_warning("No syringes loaded."))
		return
	if(reagents.total_volume<=0)
		occupant_message(span_warning("No available reagents to load syringe with."))
		return
	set_ready_state(FALSE)
	chassis.use_power(energy_drain)
	var/turf/trg = get_turf(target)
	var/obj/item/reagent_containers/syringe/S = syringes[1]
	S.forceMove(get_turf(chassis))
	reagents.trans_to_obj(S, min(S.volume, reagents.total_volume))
	syringes -= S
	S.icon = 'icons/obj/chemical.dmi'
	S.icon_state = "syringeproj"
	playsound(src, 'sound/items/syringeproj.ogg', 50, 1)
	log_message("Launched [S] from [src], targeting [target].")
	spawn(-1)
		src = null //if src is deleted, still process the syringe
		for(var/i=0, i<6, i++)
			if(!S)
				break
			if(step_towards(S,trg))
				var/list/mobs = new
				for(var/mob/living/carbon/M in S.loc)
					mobs += M
				var/mob/living/carbon/M = safepick(mobs)
				if(M)
					S.icon_state = initial(S.icon_state)
					S.icon = initial(S.icon)
					S.reagents.trans_to_mob(M, S.reagents.total_volume, CHEM_BLOOD)
					M.take_organ_damage(2)
					S.visible_message(span_attack("[M] was hit by the syringe!"))
					break
				else if(S.loc == trg)
					S.icon_state = initial(S.icon_state)
					S.icon = initial(S.icon)
					S.update_icon()
					break
			else
				S.icon_state = initial(S.icon_state)
				S.icon = initial(S.icon)
				S.update_icon()
				break
			sleep(1)
	do_after_cooldown()
	return 1


/obj/item/mecha_parts/mecha_equipment/tool/syringe_gun/Topic(href,href_list)
	..()
	var/datum/topic_input/top_filter = new (href,href_list)
	if(top_filter.get("toggle_mode"))
		mode = !mode
		update_equip_info()
		return
	if(top_filter.get("select_reagents"))
		processed_reagents.len = 0
		var/m = 0
		var/message
		for(var/i=1 to known_reagents.len)
			if(m>=synth_speed)
				break
			var/reagent = top_filter.get("reagent_[i]")
			if(reagent && (reagent in known_reagents))
				message = "[m ? ", " : null][known_reagents[reagent]]"
				processed_reagents += reagent
				m++
		if(processed_reagents.len)
			message += " added to production"
			START_PROCESSING(SSfastprocess, src)
			occupant_message(message)
			occupant_message("Reagent processing started.")
			log_message("Reagent processing started.")
		return
	if(top_filter.get("show_reagents"))
		chassis.occupant << browse(get_reagents_page(),"window=msyringegun")
	if(top_filter.get("purge_reagent"))
		var/reagent = top_filter.get("purge_reagent")
		if(reagent)
			reagents.del_reagent(reagent)
		return
	if(top_filter.get("purge_all"))
		reagents.clear_reagents()
		return
	return

/obj/item/mecha_parts/mecha_equipment/tool/syringe_gun/proc/get_reagents_page()
	var/output = {"<html>
						<head>
						<title>Reagent Synthesizer</title>
						<script language='javascript' type='text/javascript'>
						[js_byjax]
						</script>
						<style>
						h3 {margin-bottom:2px;font-size:14px;}
						#reagents, #reagents_form {}
						form {width: 90%; margin:10px auto; border:1px dotted #999; padding:6px;}
						#submit {margin-top:5px;}
						</style>
						</head>
						<body>
						<h3>Current reagents:</h3>
						<div id="reagents">
						[get_current_reagents()]
						</div>
						<h3>Reagents production:</h3>
						<div id="reagents_form">
						[get_reagents_form()]
						</div>
						</body>
						</html>
						"}
	return output

/obj/item/mecha_parts/mecha_equipment/tool/syringe_gun/proc/get_reagents_form()
	var/r_list = get_reagents_list()
	var/inputs
	if(r_list)
		inputs += "<input type=\"hidden\" name=\"src\" value=\"\ref[src]\">"
		inputs += "<input type=\"hidden\" name=\"select_reagents\" value=\"1\">"
		inputs += "<input id=\"submit\" type=\"submit\" value=\"Apply settings\">"
	var/output = {"<form action="byond://" method="get">
						[r_list || "No known reagents"]
						[inputs]
						</form>
						[r_list? "<span style=\"font-size:80%;\">Only the first [synth_speed] selected reagent\s will be added to production</span>" : null]
						"}
	return output

/obj/item/mecha_parts/mecha_equipment/tool/syringe_gun/proc/get_reagents_list()
	var/output
	for(var/i=1 to known_reagents.len)
		var/reagent_id = known_reagents[i]
		output += {"<input type="checkbox" value="[reagent_id]" name="reagent_[i]" [(reagent_id in processed_reagents)? "checked=\"1\"" : null]> [known_reagents[reagent_id]]<br />"}
	return output

/obj/item/mecha_parts/mecha_equipment/tool/syringe_gun/proc/get_current_reagents()
	var/output
	for(var/datum/reagent/R in reagents.reagent_list)
		if(R.volume > 0)
			output += "[R]: [round(R.volume,0.001)] - <a href=\"?src=\ref[src];purge_reagent=[R.id]\">Purge Reagent</a><br />"
	if(output)
		output += "Total: [round(reagents.total_volume,0.001)]/[reagents.maximum_volume] - <a href=\"?src=\ref[src];purge_all=1\">Purge All</a>"
	return output || "None"

/obj/item/mecha_parts/mecha_equipment/tool/syringe_gun/proc/load_syringe(obj/item/reagent_containers/syringe/S)
	if(syringes.len<max_syringes)
		if(get_dist(src,S) >= 2)
			occupant_message("The syringe is too far away.")
			return 0
		for(var/obj/structure/D in S.loc)//Basic level check for structures in the way (Like grilles and windows)
			if(!(D.CanPass(S,src.loc)))
				occupant_message("Unable to load syringe.")
				return 0
		for(var/obj/machinery/door/D in S.loc)//Checks for doors
			if(!(D.CanPass(S,src.loc)))
				occupant_message("Unable to load syringe.")
				return 0
		S.reagents.trans_to_obj(src, S.reagents.total_volume)
		S.forceMove(src)
		syringes += S
		occupant_message("Syringe loaded.")
		update_equip_info()
		return 1
	occupant_message("The [src] syringe chamber is full.")
	return 0

/obj/item/mecha_parts/mecha_equipment/tool/syringe_gun/proc/analyze_reagents(atom/A)
	if(get_dist(src,A) >= 4)
		occupant_message("The object is too far away.")
		return 0
	if(!A.reagents || istype(A,/mob))
		occupant_message(span_warning("No reagent info gained from [A]."))
		return 0
	occupant_message("Analyzing reagents...")
	//VOREStation Block Edit - Start
	for(var/datum/reagent/R in A.reagents.reagent_list)
		if(R.id in known_reagents)
			occupant_message("Reagent \"[R.name]\" already present in database, skipping.")
		else if(R.reagent_state == 2 && add_known_reagent(R.id,R.name))
			occupant_message("Reagent analyzed, identified as [R.name] and added to database.")
			send_byjax(chassis.occupant,"msyringegun.browser","reagents_form",get_reagents_form())
		else
			occupant_message("Reagent \"[R.name]\" unable to be scanned, skipping.")
	//VOREstation Block Edit - End
	occupant_message("Analysis complete.")
	return 1

/obj/item/mecha_parts/mecha_equipment/tool/syringe_gun/proc/add_known_reagent(r_id,r_name)
	set_ready_state(FALSE)
	do_after_cooldown()
	if(!(r_id in known_reagents))
		known_reagents += r_id
		known_reagents[r_id] = r_name
		return 1
	return 0


/obj/item/mecha_parts/mecha_equipment/tool/syringe_gun/update_equip_info()
	if(..())
		send_byjax(chassis.occupant,"msyringegun.browser","reagents",get_current_reagents())
		send_byjax(chassis.occupant,"msyringegun.browser","reagents_form",get_reagents_form())
		return 1
	return

/obj/item/mecha_parts/mecha_equipment/tool/syringe_gun/on_reagent_change()
	..()
	update_equip_info()
	return

/obj/item/mecha_parts/mecha_equipment/tool/syringe_gun/process()
	if(!chassis)
		return PROCESS_KILL
	if(!processed_reagents.len || reagents.total_volume >= reagents.maximum_volume || !chassis.has_charge(energy_drain))
		occupant_message(span_warning("Reagent processing stopped."))
		log_message("Reagent processing stopped.")
		return PROCESS_KILL
	var/amount = synth_speed / processed_reagents.len
	for(var/reagent in processed_reagents)
		reagents.add_reagent(reagent,amount)
		chassis.use_power(energy_drain)

/obj/item/mecha_parts/mecha_equipment/crisis_drone
	name = "crisis dronebay"
	desc = "A small shoulder-mounted dronebay containing a rapid response drone capable of moderately stabilizing a patient near the exosuit."
	icon_state = "mecha_dronebay"
	origin_tech = list(TECH_PHORON = 3, TECH_MAGNET = 6, TECH_BIO = 5, TECH_DATA = 4)
	range = MELEE|RANGED
	equip_cooldown = 3 SECONDS
	required_type = list(/obj/mecha/medical)

	var/droid_state = "med_droid"

	var/beam_state = "medbeam"

	var/enabled = FALSE

	var/icon/drone_overlay

	var/max_distance = 3

	var/damcap = 60
	var/heal_dead = FALSE	// Does this device heal the dead?

	var/brute_heal = 0.5	// Amount of bruteloss healed.
	var/burn_heal = 0.5		// Amount of fireloss healed.
	var/tox_heal = 0.5		// Amount of toxloss healed.
	var/oxy_heal = 1		// Amount of oxyloss healed.
	var/rad_heal = 0		// Amount of radiation healed.
	var/clone_heal = 0	// Amount of cloneloss healed.
	var/hal_heal = 0.2	// Amount of halloss healed.
	var/bone_heal = 0	// Percent chance it will heal a broken bone. this does not mean 'make it not instantly re-break'.

	var/mob/living/Target = null
	var/datum/beam/MyBeam = null

	equip_type = EQUIP_HULL

/obj/item/mecha_parts/mecha_equipment/crisis_drone/Initialize(mapload)
	. = ..()
	drone_overlay = new(src.icon, icon_state = droid_state)

/obj/item/mecha_parts/mecha_equipment/crisis_drone/attach(obj/mecha/M as obj)
	. = ..(M)
	if(chassis)
		START_PROCESSING(SSobj, src)

/obj/item/mecha_parts/mecha_equipment/crisis_drone/detach(atom/moveto=null)
	shut_down()
	. = ..(moveto)
	STOP_PROCESSING(SSobj, src)

/obj/item/mecha_parts/mecha_equipment/crisis_drone/critfail()
	. = ..()
	STOP_PROCESSING(SSobj, src)
	shut_down()
	if(chassis && chassis.occupant)
		to_chat(chassis.occupant, span_notice("\The [chassis] shudders as something jams!"))
		log_message("[src.name] has malfunctioned. Maintenance required.")

/obj/item/mecha_parts/mecha_equipment/crisis_drone/process()	// Will continually try to find the nearest person above the threshold that is a valid target, and try to heal them.
	if(chassis && enabled && chassis.has_charge(energy_drain) && (chassis.occupant || enable_special))
		var/mob/living/Targ = Target
		var/TargDamage = 0

		if(!valid_target(Target))
			Target = null

		if(Target)
			TargDamage = (Targ.getOxyLoss() + Targ.getFireLoss() + Targ.getBruteLoss() + Targ.getToxLoss())

		for(var/mob/living/Potential in viewers(max_distance, chassis))
			if(!valid_target(Potential))
				continue

			var/tallydamage = 0
			if(oxy_heal)
				tallydamage += Potential.getOxyLoss()
			if(burn_heal)
				tallydamage += Potential.getFireLoss()
			if(brute_heal)
				tallydamage += Potential.getBruteLoss()
			if(tox_heal)
				tallydamage += Potential.getToxLoss()
			if(hal_heal)
				tallydamage += Potential.getHalLoss()
			if(clone_heal)
				tallydamage += Potential.getCloneLoss()
			if(rad_heal)
				tallydamage += Potential.radiation / 2

			if(tallydamage > TargDamage)
				Target = Potential

		if(MyBeam && !valid_target(MyBeam.target))
			QDEL_NULL(MyBeam)

		if(Target)
			if(MyBeam && MyBeam.target != Target)
				QDEL_NULL(MyBeam)

			if(valid_target(Target))
				if(!MyBeam)
					MyBeam = chassis.Beam(Target,icon='icons/effects/beam.dmi',icon_state=beam_state,time=3 SECONDS,maxdistance=max_distance,beam_type = /obj/effect/ebeam,beam_sleep_time=2)
				heal_target(Target)

	else
		shut_down()

/obj/item/mecha_parts/mecha_equipment/crisis_drone/proc/valid_target(var/mob/living/L)
	. = TRUE

	if(!L || !istype(L))
		return FALSE

	if(get_dist(L, src) > max_distance)
		return FALSE

	if(!(L in viewers(max_distance, chassis)))
		return FALSE

	if(!unique_patient_checks(L))
		return FALSE

	if(L.stat == DEAD && !heal_dead)
		return FALSE

	var/tallydamage = 0
	if(oxy_heal)
		tallydamage += L.getOxyLoss()
	if(burn_heal)
		tallydamage += L.getFireLoss()
	if(brute_heal)
		tallydamage += L.getBruteLoss()
	if(tox_heal)
		tallydamage += L.getToxLoss()
	if(hal_heal)
		tallydamage += L.getHalLoss()
	if(clone_heal)
		tallydamage += L.getCloneLoss()
	if(rad_heal)
		tallydamage += L.radiation / 2

	if(tallydamage < damcap)
		return FALSE

/obj/item/mecha_parts/mecha_equipment/crisis_drone/proc/shut_down()
	if(enabled)
		chassis.visible_message(span_notice("\The [chassis]'s [src] buzzes as its drone returns to port."))
		toggle_drone()
	if(!isnull(Target))
		Target = null
	if(MyBeam)
		QDEL_NULL(MyBeam)

/obj/item/mecha_parts/mecha_equipment/crisis_drone/proc/unique_patient_checks(var/mob/living/L)	// Anything special for subtypes. Does it only work on Robots? Fleshies? A species?
	. = TRUE

/obj/item/mecha_parts/mecha_equipment/crisis_drone/proc/heal_target(var/mob/living/L)	// We've done all our special checks, just get to fixing damage.
	chassis.use_power(energy_drain)
	if(istype(L))
		L.adjustBruteLoss(brute_heal * -1)
		L.adjustFireLoss(burn_heal * -1)
		L.adjustToxLoss(tox_heal * -1)
		L.adjustOxyLoss(oxy_heal * -1)
		L.adjustCloneLoss(clone_heal * -1)
		L.adjustHalLoss(hal_heal * -1)
		L.radiation = max(0, L.radiation - rad_heal)

		if(ishuman(L) && bone_heal)
			var/mob/living/carbon/human/H = L

			if(H.bad_external_organs.len)
				for(var/obj/item/organ/external/E in H.bad_external_organs)
					if(prob(bone_heal))
						E.status &= ~ORGAN_BROKEN

/obj/item/mecha_parts/mecha_equipment/crisis_drone/proc/toggle_drone()
	if(chassis)
		enabled = !enabled
		if(enabled)
			set_ready_state(FALSE)
			log_message("Activated.")
		else
			set_ready_state(TRUE)
			log_message("Deactivated.")

/obj/item/mecha_parts/mecha_equipment/crisis_drone/add_equip_overlay(obj/mecha/M as obj)
	..()
	if(enabled)
		M.add_overlay(drone_overlay)
	return

/obj/item/mecha_parts/mecha_equipment/crisis_drone/Topic(href, href_list)
	..()
	if(href_list["toggle_drone"])
		toggle_drone()
	return

/obj/item/mecha_parts/mecha_equipment/crisis_drone/get_equip_info()
	if(!chassis) return
	return (equip_ready ? span_green("*") : span_red("*")) + "&nbsp;[src.name] - <a href='byond://?src=\ref[src];toggle_drone=1'>[enabled?"Dea":"A"]ctivate</a>"

/obj/item/mecha_parts/mecha_equipment/crisis_drone/rad
	name = "hazmat dronebay"
	desc = "A small shoulder-mounted dronebay containing a rapid response drone capable of purging a patient near the exosuit of radiation damage."
	icon_state = "mecha_dronebay_rad"

	droid_state = "rad_drone"
	beam_state = "g_beam"

	tox_heal = 0.5
	rad_heal = 5
	clone_heal = 0.2
	hal_heal = 0.2

/obj/item/mecha_parts/mecha_equipment/tool/powertool/medanalyzer
	name = "mounted humanoid scanner"
	desc = "An exosuit-mounted scanning device."
	icon_state = "mecha_analyzer_health"
	origin_tech = list(TECH_MATERIAL = 5, TECH_MAGNET = 5, TECH_BIO = 5)
	equip_cooldown = 5 SECONDS
	energy_drain = 100
	range = MELEE
	equip_type = EQUIP_UTILITY
	ready_sound = 'sound/weapons/flash.ogg'
	required_type = list(/obj/mecha/medical)

	tooltype = /obj/item/healthanalyzer/advanced
