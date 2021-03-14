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
	var/known_implant = TRUE

	var/durability = 100					// Durability remaining
	var/bioadap = FALSE						// If it'll work in fancy species

	var/tmp/power_usage = 0						// Nifsoft adds to this
	var/tmp/mob/living/carbon/human/human		// Our owner!
	var/tmp/list/nifsofts[TOTAL_NIF_SOFTWARE]	// All our nifsofts
	var/tmp/list/nifsofts_life = list()			// Ones that want to be talked to on life()
	var/owner									// Owner character name
	var/examine_msg								//Message shown on examine.

	var/tmp/vision_flags = 0		// Flags implants set for faster lookups
	var/tmp/health_flags = 0
	var/tmp/combat_flags = 0
	var/tmp/other_flags = 0

	var/tmp/stat = NIF_PREINSTALL		// Status of the NIF
	var/tmp/install_done				// Time when install will finish
	var/tmp/open = FALSE				// If it's open for maintenance (1-3)
	var/tmp/should_be_in = BP_HEAD		// Organ we're supposed to be held in

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

	var/list/planes_visible = list()

//Constructor comes with a free AR HUD
/obj/item/device/nif/New(var/newloc,var/wear,var/list/load_data)
	..(newloc)

	//First one to spawn in the game, make a big icon
	if(!big_icon)
		big_icon = new(icon,icon_state = "nif_full")

	//Put loaded data here if we loaded any
	save_data = islist(load_data) ? load_data.Copy() : list()
	var/saved_examine_msg = save_data["examine_msg"]

	//If it's an empty string, they want it blank. If null, it's never been saved, give default.
	if(isnull(saved_examine_msg))
		saved_examine_msg = "There's a certain spark to their eyes."
	examine_msg = saved_examine_msg

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

	if(!our_statclick)
		our_statclick = new(null, "Open", src)

//Destructor cleans up references
/obj/item/device/nif/Destroy()
	human = null
	QDEL_LIST_NULL(nifsofts)
	QDEL_NULL(comm)
	nifsofts_life.Cut()
	return ..()

//Being implanted in some mob
/obj/item/device/nif/proc/implant(var/mob/living/carbon/human/H)
	var/obj/item/organ/brain = H.internal_organs_by_name[O_BRAIN]
	if(istype(brain))
		should_be_in = brain.parent_organ

	if(istype(H) && !H.nif && H.species && (loc == H.get_organ(should_be_in)))
		if(!bioadap && (H.species.flags & NO_SCAN)) //NO_SCAN is the default 'too complicated' flag
			return FALSE

		human = H
		human.nif = src
		stat = NIF_INSTALLING
		H.verbs |= /mob/living/carbon/human/proc/set_nif_examine
		return TRUE

	return FALSE

//For debug or antag purposes
/obj/item/device/nif/proc/quick_implant(var/mob/living/carbon/human/H)
	if(istype(H))
		var/obj/item/organ/external/parent
		//Try to find their brain and put it near that
		var/obj/item/organ/brain = H.internal_organs_by_name[O_BRAIN]
		if(istype(brain))
			should_be_in = brain.parent_organ

		parent = H.get_organ(should_be_in)
		//Ok, nevermind then!
		if(!istype(parent))
			return FALSE
		forceMove(parent)
		parent.implants += src
		spawn(0) //Let the character finish spawning yo.
			if(!H) //Or letting them get deleted
				return
			if(H.mind)
				owner = H.mind.name
			implant(H)
		return TRUE

	return FALSE

//Being removed from some mob
/obj/item/device/nif/proc/unimplant(var/mob/living/carbon/human/H)
	var/datum/nifsoft/soulcatcher/SC = imp_check(NIF_SOULCATCHER)
	if(SC) //Clean up stored people, this is dirty but the easiest way.
		QDEL_LIST_NULL(SC.brainmobs)
		SC.brainmobs = list()
	stat = NIF_PREINSTALL
	vis_update()
	H.verbs -= /mob/living/carbon/human/proc/set_nif_examine
	H.nif = null
	human = null
	install_done = null
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
		stat = NIF_TEMPFAIL
		update_icon()

		if(human)
			notify("Danger! General system insta#^!($",TRUE)
			to_chat(human,"<span class='danger'>Your NIF vision overlays disappear and your head suddenly seems very quiet...</span>")

//Attackby proc, for maintenance
/obj/item/device/nif/attackby(obj/item/weapon/W, mob/user as mob)
	if(open == 0 && W.is_screwdriver())
		if(do_after(user, 4 SECONDS, src) && open == 0)
			user.visible_message("[user] unscrews and pries open \the [src].","<span class='notice'>You unscrew and pry open \the [src].</span>")
			playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
			open = 1
			update_icon()
	else if(open == 1 && istype(W,/obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/C = W
		if(C.get_amount() < 3)
			to_chat(user,"<span class='warning'>You need at least three coils of wire to add them to \the [src].</span>")
			return
		if(do_after(user, 6 SECONDS, src) && open == 1 && C.use(3))
			user.visible_message("[user] replaces some wiring in \the [src].","<span class='notice'>You replace any burned out wiring in \the [src].</span>")
			playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)
			open = 2
			update_icon()
	else if(open == 2 && istype(W,/obj/item/device/multitool))
		if(do_after(user, 8 SECONDS, src) && open == 2)
			user.visible_message("[user] resets several circuits in \the [src].","<span class='notice'>You find and repair any faulty circuits in \the [src].</span>")
			open = 3
			update_icon()
	else if(open == 3 && W.is_screwdriver())
		if(do_after(user, 3 SECONDS, src) && open == 3)
			user.visible_message("[user] closes up \the [src].","<span class='notice'>You re-seal \the [src] for use once more.</span>")
			playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
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
			install_done = world.time + 35 MINUTES
			notify("Adapting to new user...")
			sleep(5 SECONDS)
			notify("Adjoining optic [human.isSynthetic() ? "interface" : "nerve"], please be patient.",TRUE)
		else
			notify("You are not an authorized user for this device. Please contact [owner].",TRUE)
			unimplant()
			stat = NIF_TEMPFAIL
			return FALSE

	var/percent_done = (world.time - (install_done - (35 MINUTES))) / (35 MINUTES)

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
				/*if(3)
					human.Sleeping(5) //Disabled for being boring
					to_chat(human,"<span class='danger'>You suddenly black out!</span>")*/

		//Finishing up
		if(1.0 to INFINITY)
			stat = NIF_WORKING
			owner = human.mind.name
			name = initial(name) + " ([owner])"
			if(comm)
				var/saved_name = save_data["commlink_name"]
				if(saved_name)
					comm.register_device(saved_name)
				else if(human)
					comm.register_device(human.name)
			notify("Calibration complete! User data stored!")

//Called each life() tick on the mob
/obj/item/device/nif/proc/life()
	if(!human || loc != human.get_organ(should_be_in))
		unimplant(human)
		return FALSE

	switch(stat)
		if(NIF_WORKING)
			//Perform our passive drain
			if(!use_charge(power_usage))
				stat = NIF_POWFAIL
				vis_update()
				notify("Insufficient energy!",TRUE)
				return FALSE

			//HUD update!
			//nif_hud.process_hud(human,1) //TODO VIS

			//Process all the ones that want that
			for(var/S in nifsofts_life)
				var/datum/nifsoft/nifsoft = S
				nifsoft.life(human)

		if(NIF_POWFAIL)
			if(human && human.nutrition < 100)
				return FALSE
			else
				stat = NIF_WORKING
				vis_update()
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

	last_notification = message // TGUI Hook

	to_chat(human,"<b>\[[bicon(src.big_icon)]NIF\]</b> displays, \"<span class='[alert ? "danger" : "notice"]'>[message]</span>\"")
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
	human.adjust_nutrition(-use_charge)
	return TRUE

// This operates on a nifsoft *path*, not an instantiation.
// It tells the nifsoft shop if it's installation will succeed, to prevent it
// from charging the user for incompatible software.
/obj/item/device/nif/proc/can_install(var/datum/nifsoft/path)
	if(stat == NIF_TEMPFAIL)
		return FALSE

	if(nifsofts[initial(path.list_pos)])
		notify("The software \"[initial(path.name)]\" is already installed.", TRUE)
		return FALSE

	if(human)
		var/applies_to = initial(path.applies_to)
		var/synth = human.isSynthetic()
		if(synth && !(applies_to & NIF_SYNTHETIC))
			notify("The software \"[initial(path.name)]\" is not supported on your chassis type.",TRUE)
			return FALSE
		if(!synth && !(applies_to & NIF_ORGANIC))
			notify("The software \"[initial(path.name)]\" is not supported in organic life.",TRUE)
			return FALSE

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
		old_soft.deactivate(force = TRUE)

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
		human << click_sound

	if(!use_charge(soft.a_drain))
		notify("Not enough power to activate \"[soft]\" NIFsoft!",TRUE)
		return FALSE

	if(soft.tick_flags == NIF_ACTIVETICK)
		nifsofts_life += soft

	power_usage += soft.a_drain

	return TRUE

//Deactivate a nifsoft
/obj/item/device/nif/proc/deactivate(var/datum/nifsoft/soft)
	if(human)
		if(prob(5)) human.visible_message("<span class='notice'>\The [human] [pick(look_messages)].</span>")
		human << click_sound

	if(soft.tick_flags == NIF_ACTIVETICK)
		nifsofts_life -= soft

	power_usage -= soft.a_drain

	return TRUE

//Deactivate several nifsofts
/obj/item/device/nif/proc/deactivate_these(var/list/turn_off)
	for(var/N in turn_off)
		var/datum/nifsoft/NS = nifsofts[N]
		if(NS)
			NS.deactivate()

//Add a flag to one of the holders
/obj/item/device/nif/proc/set_flag(var/flag,var/hint)
	ASSERT(flag != null && hint)

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
			CRASH("Not a valid NIF set_flag hint: [hint]")

//Clear a flag from one of the holders
/obj/item/device/nif/proc/clear_flag(var/flag,var/hint)
	ASSERT(flag != null && hint)

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
			CRASH("Not a valid NIF clear_flag hint: [hint]")

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

/obj/item/device/nif/proc/planes_visible()
	if(stat != NIF_WORKING)
		return list() //None!

	return planes_visible

/obj/item/device/nif/proc/add_plane(var/planeid = null)
	if(!planeid)
		return
	planes_visible |= planeid

/obj/item/device/nif/proc/del_plane(var/planeid = null)
	if(!planeid)
		return
	planes_visible -= planeid

/obj/item/device/nif/proc/vis_update()
	if(human)
		human.recalculate_vis()

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
	durability = 75
	bioadap = TRUE

////////////////////////////////
// Special Promethean """surgery"""
/obj/item/device/nif/attack(mob/living/M, mob/living/user, var/target_zone)
	if(!ishuman(M) || !ishuman(user) || (M == user))
		return ..()

	var/mob/living/carbon/human/U = user
	var/mob/living/carbon/human/T = M

	if(istype(T.species,/datum/species/shapeshifter/promethean) && target_zone == BP_TORSO)
		if(T.w_uniform || T.wear_suit)
			to_chat(user,"<span class='warning'>Remove any clothing they have on, as it might interfere!</span>")
			return
		var/obj/item/organ/external/eo = T.get_organ(BP_TORSO)
		if(!T)
			to_chat(user,"<span class='warning'>They should probably regrow their torso first.</span>")
			return
		U.visible_message("<span class='notice'>[U] begins installing [src] into [T]'s chest by just stuffing it in.</span>",
		"<span class='notice'>You begin installing [src] into [T]'s chest by just stuffing it in.</span>",
		"There's a wet SQUISH noise.")
		if(do_mob(user = user, target = T, time = 200, target_zone = BP_TORSO))
			user.unEquip(src)
			forceMove(eo)
			eo.implants |= src
			implant(T)
			playsound(T,'sound/effects/slime_squish.ogg',50,1)
	else
		return ..()

/mob/living/carbon/human/proc/set_nif_examine()
	set name = "NIF Appearance"
	set desc = "If your NIF alters your appearance in some way, describe it here."
	set category = "OOC"

	if(!nif)
		verbs -= /mob/living/carbon/human/proc/set_nif_examine
		to_chat(src,"<span class='warning'>You don't have a NIF, not sure why this was here.</span>")
		return

	var/new_flavor = sanitize(input(src,"Describe how your NIF alters your appearance, like glowy eyes or metal plate on your head, etc. Be sensible. Clear this for no examine text. 128ch max.","Describe NIF", nif.examine_msg) as null|text, max_length = 128)
	//They clicked cancel or meanwhile lost their NIF
	if(!nif || isnull(new_flavor))
		return //No changes
	//Sanitize or user cleaned it entirely
	if(!new_flavor)
		nif.examine_msg = ""
		nif.save_data["examine_msg"] = ""
	else
		nif.examine_msg = new_flavor
		nif.save_data["examine_msg"] = new_flavor
