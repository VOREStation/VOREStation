/datum/nifsoft/crewmonitor
	name = "Crew Monitor"
	desc = "A link to the local crew monitor sensors. Useful for finding people in trouble."
	list_pos = NIF_CREWMONITOR
	access = access_medical
	cost = 1250
	p_drain = 0.025
	var/datum/nano_module/crew_monitor/arscreen

	New()
		..()
		arscreen = new(nif)

	Destroy()
		qdel_null(arscreen)
		return ..()

	activate()
		if((. = ..()))
			arscreen.ui_interact(nif.human,"main",null,1,nif_state)
			return TRUE

	deactivate()
		if((. = ..()))
			return TRUE

	stat_text()
		return "Show Monitor"

/datum/nifsoft/medichines_org
	name = "Medichines"
	desc = "An internal swarm of nanites to make sure you stay in good shape and to promote healing, or to preserve you if you are critically injured."
	list_pos = NIF_ORGANIC_HEAL
	cost = 2500
	p_drain = 0.05
	a_drain = 0.1 //This is messed with manually below.
	wear = 2
	activates = FALSE //It is automatic in emergencies, not manually controllable.
	tick_flags = NIF_ALWAYSTICK
	applies_to = NIF_ORGANIC
	var/mode = 0

	//These self-activate on their own, these aren't user-settable to on/off.
	activate()
		if((. = ..()))
			nif.set_flag(NIF_H_ORGREPAIR,NIF_FLAGS_HEALTH)
			mode = 1

	deactivate()
		if((. = ..()))
			nif.clear_flag(NIF_H_ORGREPAIR,NIF_FLAGS_HEALTH)
			a_drain = initial(a_drain)
			mode = initial(mode)
			nif.human.Stasis(0)

	life()
		if((. = ..()))
			var/mob/living/carbon/human/H = nif.human
			var/HP_percent = H.health/H.getMaxHealth()

			//Mode changing state machine
			if(HP_percent >= 0.9)
				if(mode)
					nif.notify("User Status: NORMAL. Medichines deactivating.")
					deactivate()
				return TRUE
			else if(!mode && HP_percent < 0.8)
				nif.notify("User Status: INJURED. Commencing medichine routines.",TRUE)
				activate()
			else if(mode == 1 && HP_percent < 0.2)
				nif.notify("User Status: DANGER. Seek medical attention!",TRUE)
				mode = 2
			else if(mode == 2 && HP_percent < -0.4)
				nif.notify("User Status: CRITICAL. Notifying medical, and starting emergency stasis!",TRUE)
				mode = 3
				if(!ishuman(H.loc)) //Not notified in case of vore, for gameplay purposes.
					var/turf/T = get_turf(H)
					var/obj/item/device/radio/headset/a = new /obj/item/device/radio/headset/heads/captain(null)
					a.autosay("[H.real_name] has been put in emergency stasis, located at ([T.x],[T.y],[T.z])!", "[H.real_name]'s NIF", "Medical")
					qdel(a)

			//Handle the actions in each mode

			//Injured but not critical
			if(mode)
				H.adjustToxLoss(-0.1 * mode)
				H.adjustBruteLoss(-0.1 * mode)
				H.adjustFireLoss(-0.1 * mode)

				if(mode >= 2)
					nif.use_charge(a_drain) //A second drain if we're in level 2+

				//Patient critical - emergency stasis
				if(mode >= 3)
					if(HP_percent <= 0)
						H.Stasis(3)
					if(HP_percent > 0.2)
						H.Stasis(0)
						nif.notify("Ending emergency stasis.",TRUE)
						mode = 2

			return TRUE

/datum/nifsoft/medichines_syn
	name = "Medichines"
	desc = "A swarm of mechanical repair nanites, able to repair relatively minor damage to synthetic bodies. Large repairs must still be performed manually."
	list_pos = NIF_SYNTH_HEAL
	cost = 2500
	p_drain = 0.05
	a_drain = 0.00 //This is manually drained below.
	wear = 2
	activates = FALSE //It is automatic in emergencies, not manually controllable.
	tick_flags = NIF_ALWAYSTICK
	applies_to = NIF_SYNTHETIC
	var/mode = 0

	//These self-activate on their own, these aren't user-settable to on/off.
	activate()
		if((. = ..()))
			nif.set_flag(NIF_H_SYNTHREPAIR,NIF_FLAGS_HEALTH)
			mode = 1

	deactivate()
		if((. = ..()))
			nif.clear_flag(NIF_H_SYNTHREPAIR,NIF_FLAGS_HEALTH)
			mode = 0

	life()
		if((. = ..()))
			//We're good!
			if(!nif.human.bad_external_organs.len)
				if(mode || active)
					nif.notify("User Status: NORMAL. Medichines deactivating.")
					deactivate()
				return TRUE

			if(!mode && !active)
				nif.notify("User Status: DAMAGED. Medichines performing minor repairs.",TRUE)
				activate()

			for(var/eo in nif.human.bad_external_organs)
				var/obj/item/organ/external/EO = eo
				for(var/w in EO.wounds)
					var/datum/wound/W = w
					if(W.damage <= 5)
						W.heal_damage(0.1)
						EO.update_damages()
						if(EO.update_icon())
							nif.human.UpdateDamageIcon(1)
						nif.use_charge(0.1)
						return TRUE //Return entirely, we only heal one at a time.
					else if(mode == 1)
						mode = 2
						nif.notify("Medichines unable to repair all damage. Perform manual repairs.",TRUE)

			return TRUE

/datum/nifsoft/spare_breath
	name = "Respirocytes"
	desc = "Nanites simulating red blood cells will filter and recycle oxygen for a short time, preventing suffocation in hostile environments. NOTE: Only capable of supplying OXYGEN."
	list_pos = NIF_SPAREBREATH
	cost = 650
	p_drain = 0.05
	a_drain = 0.1
	wear = 2
	tick_flags = NIF_ALWAYSTICK
	applies_to = NIF_ORGANIC
	var/filled = 100 //Tracks the internal tank 'refilling', which still uses power

	activate()
		if(!(filled > 50))
			nif.notify("Respirocytes not saturated!",TRUE)
			return FALSE
		if((. = ..()))
			nif.set_flag(NIF_H_SPAREBREATH,NIF_FLAGS_HEALTH)
			nif.notify("Now taking air from reserves.")

	deactivate()
		if((. = ..()))
			nif.clear_flag(NIF_H_SPAREBREATH,NIF_FLAGS_HEALTH)
			nif.notify("Now taking air from environment and refilling reserves.")

	life()
		if((. = ..()))
			if(active) //Supplying air, not recharging it
				switch(filled) //Text warnings
					if(75)
						nif.notify("Respirocytes at 75% saturation.",TRUE)
					if(50)
						nif.notify("Respirocytes at 50% saturation!",TRUE)
					if(25)
						nif.notify("Respirocytes at 25% saturation, seek a habitable environment!",TRUE)
					if(5)
						nif.notify("Respirocytes at 5% saturation! Failure imminent!",TRUE)

				if(filled == 0) //Ran out
					deactivate()
				else //Drain a little
					filled--

			else //Recharging air, not supplying it
				if(filled == 100)
					return TRUE
				else if(nif.use_charge(0.1) && ++filled == 100)
					nif.notify("Respirocytes now fully saturated.")

	proc/resp_breath()
		if(!active) return null
		var/datum/gas_mixture/breath = new()
		breath.adjust_gas("oxygen", 300)
		breath.temperature = T20C
		return breath

/datum/nifsoft/mindbackup
	name = "Mind Backup"
	desc = "Backup your mind on the go. Stores a one-time sync of your current mindstate upon activation"
	list_pos = NIF_BACKUP
	cost = 250

	activate()
		if((. = ..()))
			var/mob/living/carbon/human/H = nif.human
			SStranscore.m_backup(H.mind,H.nif,one_time = TRUE)
			nif.notify("Mind backed up!")
			nif.use_charge(0.1)
			deactivate()
			return TRUE

	deactivate()
		if((. = ..()))
			return TRUE

	stat_text()
		return "Store Backup"