//Sleeper
/obj/item/device/dogborg/sleeper
	name = "Medbelly"
	desc = "Equipment for medical hound. A mounted sleeper that stabilizes patients and can inject reagents in the borg's reserves."
	icon = 'icons/mob/dogborg_vr.dmi'
	icon_state = "sleeper"
	w_class = 1
	var/mob/living/carbon/patient = null
	var/mob/living/silicon/robot/hound = null
	var/inject_amount = 10
	var/min_health = -100
	var/cleaning = 0
	var/patient_laststat = null
	var/mob_energy = 30000 //Energy gained from digesting mobs (including PCs)
	var/list/injection_chems = list("dexalin", "bicaridine", "kelotane","anti_toxin", "alkysine", "imidazoline", "spaceacillin", "paracetamol") //The borg is able to heal every damage type. As a nerf, they use 750 charge per injection.
	var/eject_port = "ingestion"
	var/list/items_preserved = list()

/obj/item/device/dogborg/sleeper/New()
	..()
	flags |= NOBLUDGEON //No more attack messages

/obj/item/device/dogborg/sleeper/Exit(atom/movable/O)
	return 0

/obj/item/device/dogborg/sleeper/afterattack(mob/living/carbon/target, mob/living/silicon/user, proximity)
	hound = loc
	if(!proximity)
		return
	if(!ishuman(target))
		return
	if(target.buckled)
		user << "<span class='warning'>The user is buckled and can not be put into your [src.name].</span>"
		return
	if(patient)
		user << "<span class='warning'>Your [src.name] is already occupied.</span>"
		return
	user.visible_message("<span class='warning'>[hound.name] is ingesting [target.name] into their [src.name].</span>", "<span class='notice'>You start ingesting [target] into your [src]...</span>")
	if(!patient && ishuman(target) && !target.buckled && do_after (user, 50))

		if(!proximity) return //If they moved away, you can't eat them.

		if(patient) return //If you try to eat two people at once, you can only eat one.

		else //If you don't have someone in you, proceed.
			target.forceMove(src)
			target.reset_view(src)
			update_patient()
			processing_objects.Add(src)
			user.visible_message("<span class='warning'>[hound.name]'s medical pod lights up as [target.name] slips inside into their [src.name].</span>", "<span class='notice'>Your medical pod lights up as [target] slips into your [src]. Life support functions engaged.</span>")
			message_admins("[key_name(hound)] has eaten [key_name(patient)] as a dogborg. ([hound ? "<a href='?_src_=holder;adminplayerobservecoodjump=1;X=[hound.x];Y=[hound.y];Z=[hound.z]'>JMP</a>" : "null"])")
			playsound(hound, 'sound/vore/gulp.ogg', 100, 1) //POLARISTODO

/obj/item/device/dogborg/sleeper/proc/go_out(var/target)
	hound = src.loc
	if(length(contents) > 0)
		hound.visible_message("<span class='warning'>[hound.name] empties out their contents via their [eject_port] port.</span>", "<span class='notice'>You empty your contents via your [eject_port] port.</span>")
		if(target)
			if(ishuman(target))
				var/mob/living/carbon/human/person = target
				person.forceMove(get_turf(src))
				person.reset_view()
			else
				var/obj/T = target
				T.loc = hound.loc
		else
			for(var/C in contents)
				if(ishuman(C))
					var/mob/living/carbon/human/person = C
					person.forceMove(get_turf(src))
					person.reset_view()
				else
					var/obj/T = C
					T.loc = hound.loc
		items_preserved.Cut()
		cleaning = 0
		playsound(loc, 'sound/effects/splat.ogg', 50, 1)
		update_patient()
	else //You clicked eject with nothing in you, let's just reset stuff to be sure.
		items_preserved.Cut()
		cleaning = 0
		update_patient()

/obj/item/device/dogborg/sleeper/proc/drain(var/amt = 3) //Slightly reduced cost (before, it was always injecting inaprov)
	hound.cell.charge = hound.cell.charge - amt

/obj/item/device/dogborg/sleeper/attack_self(mob/user)
	if(..())
		return
	sleeperUI(user)

/obj/item/device/dogborg/sleeper/proc/sleeperUI(mob/user)
	var/dat
	dat += "<h3>Injector</h3>"

	if(patient && !(patient.stat & DEAD)) //Why inject dead people with innaprov? Dundonuffin in Bay.
		dat += "<A href='?src=\ref[src];inject=inaprovaline'>Inject Inaprovaline</A>"
	else
		dat += "<span class='linkOff'>Inject Inaprovaline</span>"
	if(patient && patient.health > min_health)
		for(var/re in injection_chems)
			var/datum/reagent/C = chemical_reagents_list[re]
			if(C)
				dat += "<BR><A href='?src=\ref[src];inject=[C.id]'>Inject [C.name]</A>"
	else
		for(var/re in injection_chems)
			var/datum/reagent/C = chemical_reagents_list[re]
			if(C)
				dat += "<BR><span class='linkOff'>Inject [C.name]</span>"

	dat += "<h3>Sleeper Status</h3>"
	dat += "<A id='refbutton' href='?src=\ref[src];refresh=1'>Refresh</A>"
	dat += "<A href='?src=\ref[src];eject=1'>Eject All</A>"
	dat += "<A href='?src=\ref[src];port=1'>Eject port: [eject_port]</A>"
	if(!cleaning)
		dat += "<A href='?src=\ref[src];clean=1'>Self-Clean</A>"
	else
		dat += "<span class='linkOff'>Self-Clean</span>"

	dat += "<div class='statusDisplay'>"

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
		dat += "Sleeper Unoccupied"
	else
		dat += "[patient.name] => "

		switch(patient.stat)
			if(0)
				dat += "<span class='good'>Conscious</span>"
			if(1)
				dat += "<span class='average'>Unconscious</span>"
			else
				dat += "<span class='bad'>DEAD</span>"

		var/pulsecolor = (patient.pulse == PULSE_NONE || patient.pulse == PULSE_THREADY ? "color:red;" : "color:white;")
		var/healthcolor = (patient.health > 0 ? "color:white;" : "color:red;")
		var/brutecolor = (patient.getBruteLoss() < 60 ? "color:gray;" : "color:red;")
		var/o2color = (patient.getOxyLoss() < 60 ? "color:gray;" : "color:red;")
		var/toxcolor = (patient.getToxLoss() < 60 ? "color:gray;" : "color:red;")
		var/burncolor = (patient.getFireLoss() < 60 ? "color:gray;" : "color:red;")

		dat += "<span style='[pulsecolor]'>\t-Pulse, bpm: [patient.get_pulse(GETPULSE_TOOL)]</span><BR>"
		dat += "<span style='[healthcolor]'>\t-Overall Health %: [round(patient.health)]</span><BR>"
		dat += "<span style='[brutecolor]'>\t-Brute Damage %: [patient.getBruteLoss()]</span><BR>"
		dat += "<span style='[o2color]'>\t-Respiratory Damage %: [patient.getOxyLoss()]</span><BR>"
		dat += "<span style='[toxcolor]'>\t-Toxin Content %: [patient.getToxLoss()]</span><BR>"
		dat += "<span style='[burncolor]'>\t-Burn Severity %: [patient.getFireLoss()]</span><BR>"

		if(round(patient.paralysis / 4) >= 1)
			dat += text("<HR>Patient paralyzed for: []<BR>", round(patient.paralysis / 4) >= 1 ? "[round(patient.paralysis / 4)] seconds" : "None")
		if(patient.getBrainLoss())
			dat += "<div class='line'><span class='average'>Significant brain damage detected.</span></div><br>"
		if(patient.getCloneLoss())
			dat += "<div class='line'><span class='average'>Patient may be improperly cloned.</span></div><br>"
		if(patient.reagents.reagent_list.len)
			for(var/datum/reagent/R in patient.reagents.reagent_list)
				dat += "<div class='line'><div style='width: 170px;' class='statusLabel'>[R.name]:</div><div class='statusValue'>[round(R.volume, 0.1)] units</div></div><br>"
	dat += "</div>"

	var/datum/browser/popup = new(user, "sleeper", "Sleeper Console", 520, 540)	//Set up the popup browser window
	popup.set_title_image(user.browse_rsc_icon(icon, icon_state))
	popup.set_content(dat)
	popup.open()
	return

/obj/item/device/dogborg/sleeper/Topic(href, href_list)
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
	if(href_list["clean"])
		if(!cleaning)
			var/confirm = alert(usr, "You are about to engage self-cleaning mode. This will fill your [src] with caustic enzymes to remove any objects or biomatter, and convert them into energy. Are you sure?", "Confirmation", "Self-Clean", "Cancel")
			if(confirm == "Self-Clean")
				cleaning = 1
				drain(500)
				processing_objects.Add(src)
				sleeperUI(usr)
				if(patient)
					patient << "<span class='danger'>[hound.name]'s [src.name] fills with caustic enzymes around you!</span>"
				return
		if(cleaning)
			sleeperUI(usr)
			return
	if(href_list["port"])
		switch(eject_port)
			if("ingestion")
				eject_port = "disposal"
			if("disposal")
				eject_port = "ingestion"
		sleeperUI(usr)
		return

	if(patient && !(patient.stat & DEAD)) //What is bitwise NOT? ... Thought it was tilde.
		if(href_list["inject"] == "inaprovaline" || patient.health > min_health)
			inject_chem(usr, href_list["inject"])
		else
			usr << "<span class='notice'>ERROR: Subject is not in stable condition for injections.</span>"
	else
		usr << "<span class='notice'>ERROR: Subject cannot metabolise chemicals.</span>"

	src.updateUsrDialog()
	sleeperUI(usr) //Needs a callback to boop the page to refresh.
	return

/obj/item/device/dogborg/sleeper/proc/inject_chem(mob/user, chem)
	if(patient && patient.reagents)
		if(chem in injection_chems + "inaprovaline")
			if(hound.cell.charge < 800) //This is so borgs don't kill themselves with it.
				hound << "<span class='notice'>You don't have enough power to synthesize fluids.</span>"
				return
			else if(patient.reagents.get_reagent_amount(chem) + 10 >= 20) //Preventing people from accidentally killing themselves by trying to inject too many chemicals!
				hound << "<span class='notice'>Your stomach is currently too full of fluids to secrete more fluids of this kind.</span>"
			else if(patient.reagents.get_reagent_amount(chem) + 10 <= 20) //No overdoses for you
				patient.reagents.add_reagent(chem, inject_amount)
				drain(750) //-750 charge per injection
			var/units = round(patient.reagents.get_reagent_amount(chem))
			hound << "<span class='notice'>Injecting [units] unit\s of [chemical_reagents_list[chem]] into occupant.</span>" //If they were immersed, the reagents wouldn't leave with them.

//For if the dogborg's existing patient uh, doesn't make it.
/obj/item/device/dogborg/sleeper/proc/update_patient()

	//Well, we HAD one, what happened to them?
	if(patient in contents)
		if(patient_laststat != patient.stat)
			if(patient.stat & DEAD)
				hound.sleeper_r = 1
				hound.sleeper_g = 0
				patient_laststat = patient.stat
			else
				hound.sleeper_r = 0
				hound.sleeper_g = 1
				patient_laststat = patient.stat
			//Update icon
			hound.updateicon()
		//Return original patient
		return(patient)

	//Check for a new patient
	else
		for(var/mob/living/carbon/human/C in contents)
			patient = C
			if(patient.stat & DEAD)
				hound.sleeper_r = 1
				hound.sleeper_g = 0
				patient_laststat = patient.stat
			else
				hound.sleeper_r = 0
				hound.sleeper_g = 1
				patient_laststat = patient.stat
			//Update icon and return new patient
			hound.updateicon()
			return(C)

	//Cleaning looks better with red on, even with nobody in it
	if(cleaning && !patient)
		hound.sleeper_r = 1
		hound.sleeper_g = 0

	//Couldn't find anyone, and not cleaning
	else if(!cleaning && !patient)
		hound.sleeper_r = 0
		hound.sleeper_g = 0

	patient_laststat = null
	patient = null
	hound.updateicon()
	return

//Gurgleborg process
/obj/item/device/dogborg/sleeper/proc/clean_cycle()

	//Sanity? Maybe not required. More like if indigestible person OOC escapes.
	for(var/I in items_preserved)
		if(!(I in contents))
			items_preserved -= I

	var/list/touchable_items = contents - items_preserved

	//Belly is entirely empty
	if(!length(contents))
		hound << "<span class='notice'>Your [src.name] is now clean. Ending self-cleaning cycle.</span>"
		cleaning = 0
		update_patient()
		return

	if(prob(10))
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
		for(var/mob/outhearer in range(1,hound))
			outhearer << sound(churnsound)
		for(var/mob/inhearer in contents)
			inhearer << sound(churnsound)
	//If the timing is right, and there are items to be touched
	if(air_master.current_cycle%3==1 && length(touchable_items))

		//Burn all the mobs or add them to the exclusion list
		for(var/mob/living/carbon/human/T in (touchable_items))
			if((T.status_flags & GODMODE) || !T.digestable)
				src.items_preserved += T
			else
				T.adjustBruteLoss(2)
				T.adjustFireLoss(3)
				src.update_patient()

		//Pick a random item to deal with (if there are any)
		var/atom/target = pick(touchable_items)

		//Handle the target being a mob
		if(ishuman(target))
			var/mob/living/carbon/human/T = target

			//Mob is now dead
			if(T.stat & DEAD)
				message_admins("[key_name(hound)] has digested [key_name(T)] as a dogborg. ([hound ? "<a href='?_src_=holder;adminplayerobservecoodjump=1;X=[hound.x];Y=[hound.y];Z=[hound.z]'>JMP</a>" : "null"])")
				hound << "<span class='notice'>You feel your belly slowly churn around [T], breaking them down into a soft slurry to be used as power for your systems.</span>"
				T << "<span class='notice'>You feel [hound]'s belly slowly churn around your form, breaking you down into a soft slurry to be used as power for [hound]'s systems.</span>"
				src.drain(-30000) //Fueeeeellll
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
				for(var/mob/hearer in range(1,src.hound))
					hearer << deathsound
				T << deathsound
				//Spill(T) //TODOPOLARIS
				qdel(T)
				src.update_patient()

		//Handle the target being anything but a /mob/living/carbon/human
		else
			var/obj/T = target

			//If the object is in the items_preserved global list //POLARISTODO

			if(T.type in important_items)
				src.items_preserved += T

			//If the object is not one to preserve
			else
				//Special case for PDAs as they are dumb. TODO fix Del on PDAs to be less dumb.
				if (istype(T, /obj/item/device/pda))
					var/obj/item/device/pda/PDA = T
					if (PDA.id)
						PDA.id.loc = src
						PDA.id = null
					T.Del()

				//Special case for IDs to make them digested
			//else if (istype(T, /obj/item/weapon/card/id))
				//var/obj/item/weapon/card/id/ID = T
				//ID.digest() //Need the digest proc, first.

				//Anything not perserved, PDA, or ID
				else
					//Spill(T) //Needs the spill proc to be added
					qdel(T)
					src.update_patient()
					src.hound.cell.charge += 10
		return

/obj/item/device/dogborg/sleeper/process()

	if(cleaning) //We're cleaning, return early after calling this as we don't care about the patient.
		src.clean_cycle()
		return

	if(patient)	//We're caring for the patient. Medical emergency! Or endo scene.
		update_patient()
		if(patient.health < 0)
			patient.adjustOxyLoss(-1) //Heal some oxygen damage if they're in critical condition
			patient.updatehealth()
		patient.AdjustStunned(-4)
		patient.AdjustWeakened(-4)
		src.drain()
		if((patient.reagents.get_reagent_amount("inaprovaline") < 5) && (patient.health < patient.maxHealth)) //Stop pumping full HP people full of drugs. Don't heal people you're digesting, meanie.
			patient.reagents.add_reagent("inaprovaline", 5)
		return

	if(!patient && !cleaning) //We think we're done working.
		if(!update_patient()) //One last try to find someone
			processing_objects.Remove(src)
			return

/mob/living/silicon/robot
	var/sleeper_g
	var/sleeper_r

/obj/item/device/dogborg/sleeper/K9 //The K9 portabrig
	name = "Brig-Belly"
	desc = "Equipment for a K9 unit. A mounted portable-brig that holds criminals."
	icon = 'icons/mob/dogborg_vr.dmi'
	icon_state = "sleeper"
	inject_amount = 10
	min_health = -100
	injection_chems = null //So they don't have all the same chems as the medihound!