//Sleeper
/obj/item/device/dogborg/sleeper
	name = "Medbelly"
	desc = "Equipment for medical hound. A mounted sleeper that stabilizes patients and can inject reagents in the borg's reserves."
	icon = 'icons/mob/dogborg_vr.dmi'
	icon_state = "sleeper"
	w_class = ITEMSIZE_TINY
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
	var/UI_open = 0

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
	if(!patient && ishuman(target) && !target.buckled && do_after (user, 50, target))

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
			if(UI_open == 1)
				sleeperUI(usr)

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
	UI_open = 1

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

	if(istype(src, /obj/item/device/dogborg/sleeper/compactor))//garbage counter for trashpup
		if(length(contents) > 0)
			dat += "<font color='red'><B>Current load</B> [length(contents)] / 25.</font><BR>"

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
		dat += "[src.name] unoccupied"
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
	//popup.set_title_image(user.browse_rsc_icon(icon, icon_state)) //I have no idea what this is, but it feels irrelevant and causes runtimes idk.
	popup.set_content(dat)
	popup.open()
	onclose(user, "sleeper")
	UI_open = 0
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
				if(cleaning)
					return
				else
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
	if((cleaning && !patient) || (length(contents) > 11))
		hound.sleeper_r = 1
		hound.sleeper_g = 0

	//Couldn't find anyone, and not cleaning
	else if(!cleaning && !patient)
		hound.sleeper_r = 0
		hound.sleeper_g = 0

	patient_laststat = null
	patient = null
	hound.updateicon()
	if(UI_open == 1)
		sleeperUI(usr)
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
				if(is_vore_predator(T))
					for (var/bellytype in T.vore_organs)
						var/datum/belly/belly = T.vore_organs[bellytype]
						for (var/obj/thing in belly.internal_contents)
							thing.loc = src
							belly.internal_contents -= thing
						for (var/mob/subprey in belly.internal_contents)
							subprey.loc = src
							belly.internal_contents -= subprey
							subprey << "As [T] melts away around you, you find yourself in [hound]'s [name]"
				for(var/obj/item/I in T)
					if(istype(I,/obj/item/organ/internal/mmi_holder/posibrain))
						var/obj/item/organ/internal/mmi_holder/MMI = I
						var/atom/movable/brain = MMI.removed()
						if(brain)
							hound.remove_from_mob(brain,src)
							brain.forceMove(src)
							items_preserved += brain
					else
						T.drop_from_inventory(I, src)
				qdel(T)
				src.update_patient()
				if(UI_open == 1)
					sleeperUI(hound)

		//Handle the target being anything but a /mob/living/carbon/human
		else
			var/obj/T = target
			if(!(T in items_preserved))
				if(T.type in important_items)
					src.items_preserved += T
					return
				if(T in items_preserved)
					return
				//If the object is not one to preserve
				if(istype(T, /obj/item/device/pda))
					var/obj/item/device/pda/PDA = T
					if (PDA.id)
						PDA.id.forceMove(src)
						PDA.id = null
					src.hound.cell.charge += (50 * T.w_class)
					contents -= T
					qdel(T)
					src.update_patient()
				//Special case for IDs to make them digested
				if(istype(T, /obj/item/weapon/card/id))
					var/obj/item/weapon/card/id/ID = T
					ID.desc = "A partially digested card that has seen better days.  Much of it's data has been destroyed."
					ID.icon = 'icons/obj/card_vr.dmi'
					ID.icon_state = "digested"
					ID.access = list() // No access
					src.items_preserved += ID
					return
				//Anything not preserved, PDA, or ID
				else if(istype(T, /obj/item))
					for(var/obj/item/SubItem in T)
						if(istype(SubItem,/obj/item/weapon/storage/internal))
							var/obj/item/weapon/storage/internal/SI = SubItem
							for(var/obj/item/SubSubItem in SI)
								SubSubItem.forceMove(src)
							qdel(SI)
						else
							SubItem.forceMove(src)
					src.hound.cell.charge += (50 * T.w_class)
					contents -= T
					qdel(T)
					src.update_patient()
				else
					src.hound.cell.charge += 120
					contents -= T
					qdel(T)
					src.update_patient()
				if(UI_open == 1)
					sleeperUI(hound)

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
	icon_state = "sleeperb"
	inject_amount = 10
	min_health = -100
	injection_chems = null //So they don't have all the same chems as the medihound!

/obj/item/device/dogborg/sleeper/compactor //Janihound gut.
	name = "garbage processor"
	desc = "A mounted garbage compactor unit with fuel processor."
	icon = 'icons/mob/dogborg_vr.dmi'
	icon_state = "compactor"
	inject_amount = 10
	min_health = -100
	injection_chems = null //So they don't have all the same chems as the medihound!
	var/max_item_count = 25

/obj/item/device/dogborg/sleeper/compactor/afterattack(var/atom/movable/target, mob/living/silicon/user, proximity)//GARBO NOMS
	hound = loc

	if(!istype(target))
		return
	if(!proximity)
		return
	if(target.anchored)
		return
	if(target in hound.module.modules)
		return
	if(length(contents) > (max_item_count - 1))
		user << "<span class='warning'>Your [src.name] is full. Eject or process contents to continue.</span>"
		return

	if(istype(target, /obj/item) || istype(target, /obj/effect/decal/remains))
		var/obj/target_obj = target
		if(target_obj.w_class > ITEMSIZE_LARGE)
			user << "<span class='warning'>\The [target] is too large to fit into your [src.name]</span>"
			return
		user.visible_message("<span class='warning'>[hound.name] is ingesting [target.name] into their [src.name].</span>", "<span class='notice'>You start ingesting [target] into your [src.name]...</span>")
		if(do_after(user, 30, target) && length(contents) < max_item_count)
			target.forceMove(src)
			user.visible_message("<span class='warning'>[hound.name]'s garbage processor groans lightly as [target.name] slips inside.</span>", "<span class='notice'>Your garbage compactor groans lightly as [target] slips inside.</span>")
			playsound(hound, 'sound/vore/gulp.ogg', 30, 1)
			if(length(contents) > 11) //grow that tum after a certain junk amount
				hound.sleeper_r = 1
				hound.updateicon()
			if(UI_open == 1)
				sleeperUI(usr)
		return

	if(istype(target, /mob/living/simple_animal/mouse)) //Edible mice, dead or alive whatever. Mostly for carcass picking you cruel bastard :v
		var/mob/living/simple_animal/trashmouse = target
		user.visible_message("<span class='warning'>[hound.name] is ingesting [trashmouse] into their [src.name].</span>", "<span class='notice'>You start ingesting [trashmouse] into your [src.name]...</span>")
		if(do_after(user, 30, trashmouse) && length(contents) < max_item_count)
			trashmouse.forceMove(src)
			trashmouse.reset_view(src)
			user.visible_message("<span class='warning'>[hound.name]'s garbage processor groans lightly as [trashmouse] slips inside.</span>", "<span class='notice'>Your garbage compactor groans lightly as [trashmouse] slips inside.</span>")
			playsound(hound, 'sound/vore/gulp.ogg', 30, 1)
			if(length(contents) > 11) //grow that tum after a certain junk amount
				hound.sleeper_r = 1
				hound.updateicon()
			if(UI_open == 1)
				sleeperUI(usr)
		return

	else if(ishuman(target))
		var/mob/living/carbon/human/trashman = target
		if(patient)
			user << "<span class='warning'>Your [src.name] is already occupied.</span>"
			return
		if(trashman.buckled)
			user << "<span class='warning'>[trashman] is buckled and can not be put into your [src.name].</span>"
			return
		user.visible_message("<span class='warning'>[hound.name] is ingesting [trashman] into their [src.name].</span>", "<span class='notice'>You start ingesting [trashman] into your [src.name]...</span>")
		if(do_after(user, 30, trashman) && !patient && !trashman.buckled && length(contents) < max_item_count)
			trashman.forceMove(src)
			trashman.reset_view(src)
			update_patient()
			processing_objects.Add(src)
			user.visible_message("<span class='warning'>[hound.name]'s garbage processor groans lightly as [trashman] slips inside.</span>", "<span class='notice'>Your garbage compactor groans lightly as [trashman] slips inside.</span>")
			playsound(hound, 'sound/vore/gulp.ogg', 80, 1)
			hound.sleeper_r = 1
			hound.updateicon()
			if(UI_open == 1)
				sleeperUI(usr)
		return
	return

/mob/living/silicon/robot/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/handcuffs))
		return
	if(opened)
		for(var/V in components)
			var/datum/robot_component/C = components[V]
			if(!C.installed && istype(W, C.external_type))
				C.installed = 1
				C.wrapped = W
				C.install()
				user.drop_item()
				W.loc = null

				var/obj/item/robot_parts/robot_component/WC = W
				if(istype(WC))
					C.brute_damage = WC.brute
					C.electronics_damage = WC.burn

				usr << "<font color='blue'>You install the [W.name].</font>"

				return


	if (istype(W, /obj/item/weapon/weldingtool))
		if (src == user)
			user << "<span class='warning'>You lack the reach to be able to repair yourself.</span>"
			return

		if (!getBruteLoss())
			user << "Nothing to fix here!"
			return
		var/obj/item/weapon/weldingtool/WT = W
		if (WT.remove_fuel(0))
			user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
			adjustBruteLoss(-30)
			updatehealth()
			add_fingerprint(user)
			for(var/mob/O in viewers(user, null))
				O.show_message(text("<span class='warning'>[user] has fixed some of the dents on [src]!</span>,"), 1)
		else
			user << "Need more welding fuel!"
			return

	else if(istype(W, /obj/item/stack/cable_coil) && (wiresexposed || istype(src,/mob/living/silicon/robot/drone)))
		if (!getFireLoss())
			user << "Nothing to fix here!"
			return
		var/obj/item/stack/cable_coil/coil = W
		if (coil.use(1))
			user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
			adjustFireLoss(-30)
			updatehealth()
			for(var/mob/O in viewers(user, null))
				O.show_message("<span class='warning'>\[user] has fixed some of the burnt wires on [src]</span>", 1)

	else if (istype(W, /obj/item/weapon/crowbar))	// crowbar means open or close the cover
		if(opened)
			if(cell)
				user << "You close the cover."
				opened = 0
				updateicon()
			else if(wiresexposed && wires.IsAllCut())
				//Cell is out, wires are exposed, remove MMI, produce damaged chassis, baleet original mob.
				if(!mmi)
					user << "\The [src] has no brain to remove."
					return

				user << "You jam the crowbar into the robot and begin levering [mmi]."
				sleep(30)
				user << "You damage some parts of the chassis, but eventually manage to rip out [mmi]!"
				var/obj/item/robot_parts/robot_suit/C = new/obj/item/robot_parts/robot_suit(loc)
				C.l_leg = new/obj/item/robot_parts/l_leg(C)
				C.r_leg = new/obj/item/robot_parts/r_leg(C)
				C.l_arm = new/obj/item/robot_parts/l_arm(C)
				C.r_arm = new/obj/item/robot_parts/r_arm(C)
				C.updateicon()
				new/obj/item/robot_parts/chest(loc)
				qdel(src)
			else
				// Okay we're not removing the cell or an MMI, but maybe something else?
				var/list/removable_components = list()
				for(var/V in components)
					if(V == "power cell") continue
					var/datum/robot_component/C = components[V]
					if(C.installed == 1 || C.installed == -1)
						removable_components += V

				var/remove = input(user, "Which component do you want to pry out?", "Remove Component") as null|anything in removable_components
				if(!remove)
					return
				var/datum/robot_component/C = components[remove]
				var/obj/item/robot_parts/robot_component/I = C.wrapped
				user << "You remove \the [I]."
				if(istype(I))
					I.brute = C.brute_damage
					I.burn = C.electronics_damage

				I.loc = src.loc

				if(C.installed == 1)
					C.uninstall()
				C.installed = 0

		else
			if(locked)
				user << "The cover is locked and cannot be opened."
			else
				user << "You open the cover."
				opened = 1
				updateicon()

	else if (istype(W, /obj/item/weapon/cell) && opened)	// trying to put a cell inside
		var/datum/robot_component/C = components["power cell"]
		if(wiresexposed)
			user << "Close the panel first."
		else if(cell)
			user << "There is a power cell already installed."
		else if(W.w_class != ITEMSIZE_NORMAL)
			user << "\The [W] is too [W.w_class < ITEMSIZE_NORMAL ? "small" : "large"] to fit here."
		else
			user.drop_item()
			W.loc = src
			cell = W
			user << "You insert the power cell."

			C.installed = 1
			C.wrapped = W
			C.install()
			//This will mean that removing and replacing a power cell will repair the mount, but I don't care at this point. ~Z
			C.brute_damage = 0
			C.electronics_damage = 0

	else if (istype(W, /obj/item/weapon/wirecutters) || istype(W, /obj/item/device/multitool))
		if (wiresexposed)
			wires.Interact(user)
		else
			user << "You can't reach the wiring."

	else if(istype(W, /obj/item/weapon/screwdriver) && opened && !cell)	// haxing
		wiresexposed = !wiresexposed
		user << "The wires have been [wiresexposed ? "exposed" : "unexposed"]"
		updateicon()

	else if(istype(W, /obj/item/weapon/screwdriver) && opened && cell)	// radio
		if(radio)
			radio.attackby(W,user)//Push it to the radio to let it handle everything
		else
			user << "Unable to locate a radio."
		updateicon()

	else if(istype(W, /obj/item/device/encryptionkey/) && opened)
		if(radio)//sanityyyyyy
			radio.attackby(W,user)//GTFO, you have your own procs
		else
			user << "Unable to locate a radio."

	else if (istype(W, /obj/item/weapon/card/id)||istype(W, /obj/item/device/pda)||istype(W, /obj/item/weapon/card/robot))			// trying to unlock the interface with an ID card
		if(emagged)//still allow them to open the cover
			user << "The interface seems slightly damaged"
		if(opened)
			user << "You must close the cover to swipe an ID card."
		else
			if(allowed(usr))
				locked = !locked
				user << "You [ locked ? "lock" : "unlock"] [src]'s interface."
				updateicon()
			else
				user << "<span class='warning'>Access denied.</span>"

	else if(istype(W, /obj/item/borg/upgrade/))
		var/obj/item/borg/upgrade/U = W
		if(!opened)
			usr << "You must access the borgs internals!"
		else if(!src.module && U.require_module)
			usr << "The borg must choose a module before he can be upgraded!"
		else if(U.locked)
			usr << "The upgrade is locked and cannot be used yet!"
		else
			if(U.action(src))
				usr << "You apply the upgrade to [src]!"
				usr.drop_item()
				U.loc = src
			else
				usr << "Upgrade error!"

	else if(module_active && istype(module_active,/obj/item/device/dogborg/sleeper/compactor && user.a_intent == I_HELP)) //Feeding?
		if(src == user)
			return
		if(user.a_intent == I_HELP)
			var/obj/item/device/dogborg/sleeper/compactor/CR = module_active
			user << "You attempt to feed [W] to [src]."
			W.attackby(CR,src)


	else
		if( !(istype(W, /obj/item/device/robotanalyzer) || istype(W, /obj/item/device/healthanalyzer)) )
			spark_system.start()
		return ..()
