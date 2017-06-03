//Holder on humans to prevent having to 'find' it every time
/mob/living/carbon/human/var/obj/item/device/nif/nif

//Nanotech Implant Foundation
/obj/item/device/nif
	name = "nanotech implant foundation"
	desc = "A somewhat degraded copy of a Kitsuhana working surface, in a box. Can print new \
	implants inside living hosts on the fly based on software uploads. Must be surgically \
	implanted in the head to work. May eventually wear out and break."

	icon = 'icons/obj/device_alt.dmi'
	icon_state = "nif_0"

	w_class = ITEMSIZE_TINY

	var/durability = 100					// Durability remaining
	var/burn_factor = 100					// Divisor for power charge from nutrition (efficiency basically)

	var/tmp/power_usage = 0						// Nifsoft adds to this
	var/tmp/mob/living/carbon/human/human		// Our owner!
	var/tmp/list/nifsofts[TOTAL_NIF_SOFTWARE]	// All our nifsofts
	var/tmp/list/nifsofts_life = list()			// Ones that want to be talked to on life()
	var/owner									// Owner character name

	var/tmp/vision_flags = 0		// Flags implants set for faster lookups
	var/tmp/health_flags = 0
	var/tmp/combat_flags = 0
	var/tmp/other_flags = 0

	var/tmp/stat = NIF_PREINSTALL		// Status of the NIF
	var/tmp/install_done				// Time when install will finish
	var/tmp/open = FALSE				// If it's open for maintenance (1-3)

	var/obj/item/clothing/glasses/hud/nif_hud/nif_hud

	var/global/icon/big_icon
	var/global/click_sound = 'sound/effects/pop.ogg'

//Constructor comes with a free AR HUD
/obj/item/device/nif/New(var/newloc,var/wear)
	..(newloc)
	new /datum/nifsoft/ar_civ(src)
	nif_hud = new(src)

	if(!big_icon)
		big_icon = new(icon,icon_state = "nif_full")

	//Probably loading from a save
	if(ishuman(newloc))
		var/mob/living/carbon/human/H = newloc
		implant(H)
		owner = H.mind.name
		name = initial(name) + " ([owner])"
		stat = NIF_WORKING

	if(wear)
		durability = wear

	update_icon()

//Destructor cleans up references
/obj/item/device/nif/Destroy()
	if(human)
		human.nif = null
		human = null
	for(var/S in nifsofts)
		if(S)
			qdel(S)
	nifsofts.Cut()
	..()

//Being implanted in some mob
/obj/item/device/nif/proc/implant(var/mob/living/carbon/human/H)
	if(istype(H) && !H.nif && H.species && !(H.species.flags & NO_SCAN) && (loc == H.get_organ(BP_HEAD))) //NO_SCAN is the default 'too complicated' flag.
		human = H
		human.nif = src
		stat = NIF_INSTALLING
		return TRUE

	return FALSE

//For debug or antag purposes
/obj/item/device/nif/proc/quick_implant(var/mob/living/carbon/human/H)
	if(istype(H))
		var/obj/item/organ/external/head = H.get_organ(BP_HEAD)
		if(!head)
			return FALSE
		src.forceMove(head)
		head.implants += src
		owner = H.real_name
		return implant(H)

	return FALSE

//Being implanted in some mob
/obj/item/device/nif/proc/unimplant(var/mob/living/carbon/human/H)
	human = null
	stat = NIF_PREINSTALL
	install_done = null
	if(istype(H))
		H.nif = null
	update_icon()

//EMP adds wear and disables all nifsoft
/obj/item/device/nif/emp_act(var/severity)
	notify("Danger! Significant electromagnetic interference!",TRUE)
	for(var/nifsoft in nifsofts)
		if(nifsoft)
			var/datum/nifsoft/NS = nifsoft
			NS.deactivate()

	switch (severity)
		if (1)
			wear(rand(30,40))
		if (2)
			wear(rand(15,25))
		if (3)
			wear(rand(8,15))
		if (4)
			wear(rand(1,8))

//Wear update/check proc
/obj/item/device/nif/proc/wear(var/wear = 0)
	if(wear)
		durability -= wear * rand(0.85,1.15) // Also +/- 15%

	if(durability <= 0)
		stat = NIF_TEMPFAIL
		update_icon()
		notify("Danger! General system insta#^!($",TRUE)
		to_chat(human,"<span class='danger'>Your NIF vision overlays disappear and your head suddenly seems very quiet...</span>")

//Attackby proc, for maintenance
/obj/item/device/nif/attackby(obj/item/weapon/W, mob/user as mob)
	if(open == 0 && istype(W,/obj/item/weapon/screwdriver))
		if(do_after(user, 4 SECONDS, src) && open == 0)
			user.visible_message("[user] unscrews and pries open \the [src].","<span class='notice'>You unscrew and pry open \the [src].")
			playsound(user, 'sound/items/Screwdriver.ogg', 50, 1)
			open = 1
			update_icon()
	else if(open == 1 && istype(W,/obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/C = W
		if(C.get_amount() < 3)
			to_chat(user,"<span class='warning'>You need at least three coils of wire to add them to \the [src].</span>")
			return
		if(do_after(user, 6 SECONDS, src) && open == 1 && C.use(3))
			user.visible_message("[user] replaces some wiring in \the [src].","<span class='notice'>You replace any burned out wiring in \the [src].")
			playsound(user, 'sound/items/Deconstruct.ogg', 50, 1)
			open = 2
			update_icon()
	else if(open == 2 && istype(W,/obj/item/device/multitool))
		if(do_after(user, 8 SECONDS, src) && open == 2)
			user.visible_message("[user] resets several circuits in \the [src].","<span class='notice'>You find and repair any faulty circuits in \the [src].")
			open = 3
			update_icon()
	else if(open == 3 && istype(W,/obj/item/weapon/screwdriver))
		if(do_after(user, 3 SECONDS, src) && open == 3)
			user.visible_message("[user] closes up \the [src].","<span class='notice'>You re-seal \the [src] for use once more.")
			playsound(user, 'sound/items/Screwdriver.ogg', 50, 1)
			open = FALSE
			durability = initial(durability)
			stat = NIF_PREINSTALL
			update_icon()

//Wear update/check proc
/obj/item/device/nif/update_icon()
	if(open)
		icon_state = "nif_open[open]"
	else
		switch(stat)
			if(NIF_PREINSTALL)
				icon_state = "nif_1"
			if(NIF_INSTALLING)
				icon_state = "nif_0"
			if(NIF_WORKING)
				icon_state = "nif_0"
			if(NIF_TEMPFAIL)
				icon_state = "nif_2"
			else
				icon_state = "nif_2"

//The (dramatic) install process
/obj/item/device/nif/proc/handle_install()
	if(human.stat) //No stuff while KO. Sleeping it off is viable, and doesn't start until you wake up from surgery
		return FALSE

	//Firsties
	if(!install_done)
		if(human.real_name == owner)
			install_done = world.time + 1 MINUTE
			notify("Welcome back, [owner]! Performing quick-calibration...")
		else
			install_done = world.time + 30 MINUTES
			notify("Adapting to new user...")
			sleep(5 SECONDS)
			notify("Adjoining optic [human.isSynthetic() ? "interface" : "nerve"], please be patient.",TRUE)

	var/percent_done = (world.time - (install_done - (30 MINUTES))) / (30 MINUTES)

	human.client.screen.Add(global_hud.whitense)

	switch(percent_done) //This is 0.0 to 1.0 kinda percent.
		//Connecting to optical nerves
		if(0.0 to 0.1)
			human.eye_blind = 5

		//Mapping brain
		if(0.2 to 0.9)
			if(prob(99)) return TRUE
			var/incident = rand(1,3)
			switch(incident)
				if(1)
					var/message = pick(list(
								"Your head throbs around your new implant.",
								"The skin around your recent surgery itches.",
								"A wave of nausea overtakes you as the world seems to spin.",
								"The floor suddenly seems to come up at you.",
								"There's a throbbing lump of ice behind your eyes.",
								"A wave of pain shoots down your neck."
								))
					to_chat(human,"<span class='danger'>[message]</span>")
				if(2)
					human.Weaken(5)
					to_chat(human,"<span class='danger'>A wave of weakness rolls over you.</span>")
				if(3)
					human.Sleeping(5)
					to_chat(human,"<span class='danger'>You suddenly black out!</span>")

		//Finishing up
		if(1.0 to INFINITY)
			stat = NIF_WORKING
			owner = human.real_name
			name = initial(name) + " ([owner])"
			notify("Calibration complete! User data stored!")

//Called each life() tick on the mob
/obj/item/device/nif/proc/life()
	if(!human || loc != human.get_organ(BP_HEAD))
		unimplant(human)
		return FALSE

	switch(stat)
		if(NIF_WORKING)
			//Perform our passive drain
			if(!use_charge(power_usage))
				stat = NIF_POWFAIL
				notify("Insufficient energy!",TRUE)
				return FALSE

			//HUD update!
			nif_hud.process_hud(human,1)

			//Process all the ones that want that
			for(var/S in nifsofts_life)
				var/datum/nifsoft/nifsoft = S
				nifsoft.life(human)

		if(NIF_POWFAIL)
			if(human && human.nutrition < 100)
				return FALSE
			else
				stat = NIF_WORKING
				notify("System Reboot Complete.")

		if(NIF_TEMPFAIL)
			//Something else has to take us out of tempfail
			return FALSE

		if(NIF_INSTALLING)
			handle_install()
			return FALSE

//Prints 'AR' messages to the user
/obj/item/device/nif/proc/notify(var/message,var/alert = 0)
	if(!human) return

	to_chat(human,"<b>\[\icon[src.big_icon]NIF\]</b> displays, \"<span class='[alert ? "danger" : "notice"]'>[message]</span>\"")

//Called to spend nutrition, returns 1 if it was able to
/obj/item/device/nif/proc/use_charge(var/use_charge)
	//You don't want us to take any? Well okay.
	if(!use_charge)
		return TRUE

	//Not enough nutrition/charge left.
	if(!human || human.nutrition < use_charge)
		return FALSE

	//Was enough, reduce and return.
	human.nutrition -= use_charge
	return TRUE

//Install a piece of software
/obj/item/device/nif/proc/install(var/datum/nifsoft/new_soft)
	if(nifsofts[new_soft.list_pos])
		return FALSE

	if(human)
		var/applies_to = new_soft.applies_to
		var/synth = human.isSynthetic()
		if(synth && !(applies_to & NIF_SYNTHETIC))
			notify("The software \"[new_soft]\" is not supported on your chassis type.",TRUE)
			return FALSE
		if(!synth && !(applies_to & NIF_ORGANIC))
			notify("The software \"[new_soft]\" is not supported in organic life.",TRUE)
			return FALSE

	nifsofts[new_soft.list_pos] = new_soft
	power_usage += new_soft.p_drain

	if(new_soft.tick_flags == NIF_ALWAYSTICK)
		nifsofts_life += new_soft

	if(new_soft.vision_flags)
		vision_flags |= new_soft.vision_flags
	if(new_soft.health_flags)
		health_flags |= new_soft.health_flags
	if(new_soft.combat_flags)
		combat_flags |= new_soft.combat_flags
	if(new_soft.other_flags)
		other_flags |= new_soft.other_flags

	wear(new_soft.wear)
	return TRUE

//Uninstall a piece of software
/obj/item/device/nif/proc/uninstall(var/datum/nifsoft/old_soft)
	var/datum/nifsoft/NS = old_soft.list_pos
	if(!NS || NS != old_soft)
		return FALSE //what??

	nifsofts[old_soft.list_pos] = null
	power_usage -= old_soft.p_drain

	if(old_soft.tick_flags == NIF_ALWAYSTICK)
		nifsofts_life -= old_soft

	if(old_soft.active)
		power_usage -= old_soft.a_drain
		if(old_soft.tick_flags == NIF_ACTIVETICK)
			nifsofts_life -= old_soft

	if(old_soft.vision_flags)
		vision_flags &= ~old_soft.vision_flags
	if(old_soft.health_flags)
		health_flags &= ~old_soft.health_flags
	if(old_soft.combat_flags)
		combat_flags &= ~old_soft.combat_flags
	if(old_soft.other_flags)
		other_flags &= ~old_soft.other_flags

	return TRUE

//Activate a nifsoft
/obj/item/device/nif/proc/activate(var/datum/nifsoft/soft)
	if(human)
		var/applies_to = soft.applies_to
		var/synth = human.isSynthetic()
		if(synth && !(applies_to & NIF_SYNTHETIC))
			notify("The software \"[soft]\" is not supported on your chassis type and will be uninstalled.",TRUE)
			uninstall(soft)
			return FALSE
		if(!synth && !(applies_to & NIF_ORGANIC))
			notify("The software \"[soft]\" is not supported in organic life and will be uninstalled.",TRUE)
			uninstall(soft)
			return FALSE

	if(!use_charge(soft.a_drain))
		return FALSE

	if(soft.tick_flags == NIF_ACTIVETICK)
		nifsofts_life += soft

	power_usage += soft.a_drain
	human << click_sound

	return TRUE

//Deactivate a nifsoft
/obj/item/device/nif/proc/deactivate(var/datum/nifsoft/soft)
	if(soft.tick_flags == NIF_ACTIVETICK)
		nifsofts_life -= soft

	power_usage -= soft.a_drain
	human << click_sound

	return TRUE

//Deactivate several nifsofts
/obj/item/device/nif/proc/deactivate_these(var/list/turn_off)
	for(var/N in turn_off)
		var/datum/nifsoft/NS = nifsofts[N]
		if(NS)
			NS.deactivate()

//Add a flag to one of the holders
/obj/item/device/nif/proc/set_flag(var/flag,var/hint)
	ASSERT(flag && hint)

	switch(hint)
		if(NIF_FLAGS_VISION)
			vision_flags |= flag
		if(NIF_FLAGS_HEALTH)
			health_flags |= flag
		if(NIF_FLAGS_COMBAT)
			combat_flags |= flag
		if(NIF_FLAGS_OTHER)
			other_flags |= flag
		else
			CRASH("Not a valid NIF flag hint: [hint]")

//Clear a flag from one of the holders
/obj/item/device/nif/proc/clear_flag(var/flag,var/hint)
	ASSERT(flag && hint)

	switch(hint)
		if(NIF_FLAGS_VISION)
			vision_flags &= ~flag
		if(NIF_FLAGS_HEALTH)
			health_flags &= ~flag
		if(NIF_FLAGS_COMBAT)
			combat_flags &= ~flag
		if(NIF_FLAGS_OTHER)
			other_flags &= ~flag
		else
			CRASH("Not a valid NIF flag hint: [hint]")

//Check for an installed implant
/obj/item/device/nif/proc/imp_check(var/soft)
	if(!stat == NIF_WORKING) return FALSE
	ASSERT(soft)

	if(ispath(soft))
		var/datum/nifsoft/path = soft
		soft = initial(path.list_pos)
	var/entry = nifsofts[soft]
	if(entry)
		return entry

//Check for a set flag
/obj/item/device/nif/proc/flag_check(var/flag,var/hint)
	if(!stat == NIF_WORKING) return FALSE
	ASSERT(flag && hint)

	var/result = FALSE
	switch(hint)
		if(NIF_FLAGS_VISION)
			if(flag & vision_flags) result = TRUE
		if(NIF_FLAGS_HEALTH)
			if(flag & health_flags) result = TRUE
		if(NIF_FLAGS_COMBAT)
			if(flag & combat_flags) result = TRUE
		if(NIF_FLAGS_OTHER)
			if(flag & other_flags) result = TRUE
		else
			CRASH("Not a valid NIF flag hint: [hint]")

	return result

//NIF HUD object becasue HUD handling is trash and should be rewritten
/obj/item/clothing/glasses/hud/nif_hud/var/obj/item/device/nif/nif

/obj/item/clothing/glasses/hud/nif_hud/New(var/newloc)
	..(newloc)
	nif = newloc

/obj/item/clothing/glasses/hud/nif_hud/process_hud(M,var/thing)
	//Faster checking with local var, and this is called often so I want fast.
	var/visflags = nif.vision_flags
	if(NIF_V_AR_OMNI & visflags)
		process_omni_hud(nif.human, "best")
	else if(NIF_V_AR_SECURITY & visflags)
		process_omni_hud(nif.human, "sec")
	else if(NIF_V_AR_MEDICAL & visflags)
		process_omni_hud(nif.human, "med")
	else if(NIF_V_AR_ENGINE & visflags)
		process_omni_hud(nif.human, "eng")
	else if(NIF_V_AR_SCIENCE & visflags)
		process_omni_hud(nif.human, "sci")
	else if(NIF_V_AR_CIVILIAN & visflags)
		process_omni_hud(nif.human, "civ")
