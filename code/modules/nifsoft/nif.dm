/* //////////////////////////////
The NIF has a proc API shared with NIFSofts, and you should not really ever
directly interact with this API. Procs like install(), uninstall(), etc should
not be directly called. If you want to install a new NIFSoft, pass the NIF in
the constructor for a new instance of the NIFSoft. If you want to force a NIFSoft
to be uninstalled, use imp_check to get a reference to it, and call
uninstall() only on the return value of that.

You can also set the stat of a NIF to NIF_TEMPFAIL without any issues to disable it.
*/ //////////////////////////////

//Holder on humans to prevent having to 'find' it every time
/mob/living/carbon/human/var/obj/item/device/nif/nif

//Nanotech Implant Foundation
/obj/item/device/nif
	name = "nanite implant framework"
	desc = "A somewhat diminished knockoff of a Kitsuhana nano working surface, in a box. Can print new \
	implants inside living hosts on the fly based on software uploads. Must be surgically \
	implanted in the head to work. May eventually wear out and break."

	icon = 'icons/obj/device_alt.dmi'
	icon_state = "nif_0"

	w_class = ITEMSIZE_TINY

	var/durability = 100					// Durability remaining
	var/bioadap = FALSE						// If it'll work in fancy species

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

	var/obj/item/clothing/glasses/hud/nif_hud/nif_hud	// The AR ones require this
	var/obj/item/device/communicator/commlink/comm		// The commlink requires this

	var/global/icon/big_icon
	var/global/click_sound = 'sound/items/nif_click.ogg'
	var/global/bad_sound = 'sound/items/nif_tone_bad.ogg'
	var/global/good_sound = 'sound/items/nif_tone_good.ogg'
	var/global/list/look_messages = list(
			"flicks their eyes around",
			"looks at something unseen",
			"reads some invisible text",
			"seems to be daydreaming",
			"focuses elsewhere for a moment")

	var/list/save_data

//Constructor comes with a free AR HUD
/obj/item/device/nif/New(var/newloc,var/wear,var/list/load_data)
	..(newloc)

	//First one to spawn in the game, make a big icon
	if(!big_icon)
		big_icon = new(icon,icon_state = "nif_full")

	//Required for AR stuff.
	nif_hud = new(src)

	//Put loaded data here if we loaded any
	save_data = islist(load_data) ? load_data.Copy() : list()

	//If given a human on spawn (probably from persistence)
	if(ishuman(newloc))
		var/mob/living/carbon/human/H = newloc
		if(!quick_implant(H))
			WARNING("NIF spawned in [H] failed to implant")
			spawn(0)
				qdel(src)
			return FALSE
		else
			//Free commlink for return customers
			new /datum/nifsoft/commlink(src)

	//Free civilian AR included
	new /datum/nifsoft/ar_civ(src)

	//If given wear (like when spawned) then done
	if(wear)
		durability = wear
		wear(0) //Just make it update.

	//Draw me yo.
	update_icon()

//Destructor cleans up references
/obj/item/device/nif/Destroy()
	if(human)
		human.nif = null
		human = null
	qdel_null_list(nifsofts)
	qdel_null(nif_hud)
	qdel_null(comm)
	nifsofts_life.Cut()
	return ..()

//Being implanted in some mob
/obj/item/device/nif/proc/implant(var/mob/living/carbon/human/H)
	if(istype(H) && !H.nif && H.species && (loc == H.get_organ(BP_HEAD)))
		if(!bioadap && (H.species.flags & NO_SCAN)) //NO_SCAN is the default 'too complicated' flag
			return FALSE

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
		spawn(0) //Let the character finish spawning yo.
			if(H.mind)
				owner = H.mind.name
			implant(H)
		return TRUE

	return FALSE

//Being removed from some mob
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
	wear *= (rand(85,115) / 100) //Apparently rand() only takes integers.
	durability -= wear

	if(durability <= 0)
		notify("Danger! General system insta#^!($",TRUE)
		to_chat(human,"<span class='danger'>Your NIF vision overlays disappear and your head suddenly seems very quiet...</span>")
		stat = NIF_TEMPFAIL
		update_icon()

//Attackby proc, for maintenance
/obj/item/device/nif/attackby(obj/item/weapon/W, mob/user as mob)
	if(open == 0 && istype(W,/obj/item/weapon/screwdriver))
		if(do_after(user, 4 SECONDS, src) && open == 0)
			user.visible_message("[user] unscrews and pries open \the [src].","<span class='notice'>You unscrew and pry open \the [src].</span>")
			playsound(user, 'sound/items/Screwdriver.ogg', 50, 1)
			open = 1
			update_icon()
	else if(open == 1 && istype(W,/obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/C = W
		if(C.get_amount() < 3)
			to_chat(user,"<span class='warning'>You need at least three coils of wire to add them to \the [src].</span>")
			return
		if(do_after(user, 6 SECONDS, src) && open == 1 && C.use(3))
			user.visible_message("[user] replaces some wiring in \the [src].","<span class='notice'>You replace any burned out wiring in \the [src].</span>")
			playsound(user, 'sound/items/Deconstruct.ogg', 50, 1)
			open = 2
			update_icon()
	else if(open == 2 && istype(W,/obj/item/device/multitool))
		if(do_after(user, 8 SECONDS, src) && open == 2)
			user.visible_message("[user] resets several circuits in \the [src].","<span class='notice'>You find and repair any faulty circuits in \the [src].</span>")
			open = 3
			update_icon()
	else if(open == 3 && istype(W,/obj/item/weapon/screwdriver))
		if(do_after(user, 3 SECONDS, src) && open == 3)
			user.visible_message("[user] closes up \the [src].","<span class='notice'>You re-seal \the [src] for use once more.</span>")
			playsound(user, 'sound/items/Screwdriver.ogg', 50, 1)
			open = FALSE
			durability = initial(durability)
			stat = NIF_PREINSTALL
			update_icon()

//Icon updating
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
	if(human.stat || !human.mind) //No stuff while KO or not sleeved
		return FALSE

	//Firsties
	if(!install_done)
		if(human.mind.name == owner)
			install_done = world.time + 1 MINUTE
			notify("Welcome back, [owner]! Performing quick-calibration...")
		else if(!owner)
			install_done = world.time + 30 MINUTES
			notify("Adapting to new user...")
			sleep(5 SECONDS)
			notify("Adjoining optic [human.isSynthetic() ? "interface" : "nerve"], please be patient.",TRUE)
		else
			notify("You are not an authorized user for this device. Please contact [owner].",TRUE)
			unimplant()
			stat = NIF_TEMPFAIL
			return FALSE

	var/percent_done = (world.time - (install_done - (30 MINUTES))) / (30 MINUTES)

	if(human.client)
		human.client.screen.Add(global_hud.whitense) //This is the camera static

	switch(percent_done) //This is 0.0 to 1.0 kinda percent.
		//Connecting to optical nerves
		if(0.0 to 0.1)
			human.eye_blind = 5

		//Mapping brain
		if(0.2 to 0.9)
			if(prob(98)) return TRUE
			var/incident = rand(1,3)
			switch(incident)
				if(1)
					var/message = pick(list(
								"Your head throbs around your new implant!",
								"The skin around your recent surgery itches!",
								"A wave of nausea overtakes you as the world seems to spin!",
								"The floor suddenly seems to come up at you!",
								"There's a throbbing lump of ice behind your eyes!",
								"A wave of pain shoots down your neck!"
								))
					human.adjustHalLoss(35)
					human.custom_pain(message,35)
				if(2)
					human.Weaken(5)
					to_chat(human,"<span class='danger'>A wave of weakness rolls over you.</span>")
				if(3)
					human.Sleeping(5)
					to_chat(human,"<span class='danger'>You suddenly black out!</span>")

		//Finishing up
		if(1.0 to INFINITY)
			stat = NIF_WORKING
			owner = human.mind.name
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
	if(!human || stat == NIF_TEMPFAIL) return

	to_chat(human,"<b>\[\icon[src.big_icon]NIF\]</b> displays, \"<span class='[alert ? "danger" : "notice"]'>[message]</span>\"")
	if(prob(1)) human.visible_message("<span class='notice'>\The [human] [pick(look_messages)].</span>")
	if(alert)
		human << bad_sound
	else
		human << good_sound

//Called to spend nutrition, returns 1 if it was able to
/obj/item/device/nif/proc/use_charge(var/use_charge)
	if(stat != NIF_WORKING) return FALSE

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
	if(stat == NIF_TEMPFAIL) return FALSE

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

	wear(new_soft.wear)
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

	return TRUE

//Uninstall a piece of software
/obj/item/device/nif/proc/uninstall(var/datum/nifsoft/old_soft)
	var/datum/nifsoft/NS = nifsofts[old_soft.list_pos]
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
	if(stat != NIF_WORKING) return FALSE

	if(human)
		if(prob(5)) human.visible_message("<span class='notice'>\The [human] [pick(look_messages)].</span>")
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
		notify("Not enough power to activate \"[soft]\" NIFsoft!",TRUE)
		return FALSE

	if(soft.tick_flags == NIF_ACTIVETICK)
		nifsofts_life += soft

	power_usage += soft.a_drain
	human << click_sound

	return TRUE

//Deactivate a nifsoft
/obj/item/device/nif/proc/deactivate(var/datum/nifsoft/soft)
	if(human)
		if(prob(5)) human.visible_message("<span class='notice'>\The [human] [pick(look_messages)].</span>")

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
	if(stat != NIF_WORKING) return FALSE
	ASSERT(soft)

	if(ispath(soft))
		var/datum/nifsoft/path = soft
		soft = initial(path.list_pos)
	var/entry = nifsofts[soft]
	if(entry)
		return entry

//Check for a set flag
/obj/item/device/nif/proc/flag_check(var/flag,var/hint)
	if(stat != NIF_WORKING) return FALSE

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

///////////////////////////////////////////////////////////////////////////////////////
//NIF HUD object becasue HUD handling is trash and should be rewritten
/obj/item/clothing/glasses/hud/nif_hud/var/obj/item/device/nif/nif

/obj/item/clothing/glasses/hud/nif_hud/New(var/newloc)
	..(newloc)
	nif = newloc

/obj/item/clothing/glasses/hud/nif_hud/Destroy()
	if(nif)
		nif.nif_hud = null
		nif = null
	return ..()

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

// Alternate NIFs
/obj/item/device/nif/bad
	name = "bootleg NIF"
	desc = "A copy of a copy of a copy of a copy of... this can't be any good, right? Surely?"
	durability = 10

/obj/item/device/nif/authentic
	name = "\improper Kitsuhana NIF"
	desc = "An actual Kitsuhana working surface, in a box. From a society slightly less afraid \
	of self-replicating nanotechnology. Basically just a high-endurance NIF."
	durability = 1000

/obj/item/device/nif/bioadap
	name = "bioadaptive NIF"
	desc = "A NIF that goes out of it's way to accomidate strange body types. \
	Will function in species where it normally wouldn't."
	durability = 25
	bioadap = TRUE
