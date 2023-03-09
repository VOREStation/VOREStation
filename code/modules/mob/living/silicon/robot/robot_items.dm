//A portable analyzer, for research borgs.  This is better then giving them a gripper which can hold anything and letting them use the normal analyzer.
/obj/item/weapon/portable_destructive_analyzer
	name = "Portable Destructive Analyzer"
	icon = 'icons/obj/items.dmi'
	icon_state = "portable_analyzer"
	desc = "Similar to the stationary version, this rather unwieldy device allows you to break down objects in the name of science."

	var/min_reliability = 90 //Can't upgrade, call it laziness or a drawback

	var/datum/research/techonly/files 	//The device uses the same datum structure as the R&D computer/server.
										//This analyzer can only store tech levels, however.

	var/obj/item/weapon/loaded_item	//What is currently inside the analyzer.

/obj/item/weapon/portable_destructive_analyzer/New()
	..()
	files = new /datum/research/techonly(src) //Setup the research data holder.

/obj/item/weapon/portable_destructive_analyzer/attack_self(user as mob)
	var/response = tgui_alert(user, 	"Analyzing the item inside will *DESTROY* the item for good.\n\
							Syncing to the research server will send the data that is stored inside to research.\n\
							Ejecting will place the loaded item onto the floor.",
							"What would you like to do?", list("Analyze", "Sync", "Eject"))
	if(response == "Analyze")
		if(loaded_item)
			var/confirm = tgui_alert(user, "This will destroy the item inside forever. Are you sure?","Confirm Analyze",list("Yes","No"))
			if(confirm == "Yes" && !QDELETED(loaded_item)) //This is pretty copypasta-y
				to_chat(user, "<span class='filter_notice'>You activate the analyzer's microlaser, analyzing \the [loaded_item] and breaking it down.</span>")
				flick("portable_analyzer_scan", src)
				playsound(src, 'sound/items/Welder2.ogg', 50, 1)
				var/research_levels = list()
				for(var/T in loaded_item.origin_tech)
					files.UpdateTech(T, loaded_item.origin_tech[T])
					research_levels += "\The [loaded_item] had level [loaded_item.origin_tech[T]] in [CallTechName(T)]."
				if (length(research_levels))
					to_chat(user, "<span class='filter_notice'>[jointext(research_levels,"<br>")]</span>")
				loaded_item = null
				for(var/obj/I in contents)
					for(var/mob/M in I.contents)
						M.death()
					if(istype(I,/obj/item/stack/material))//Only deconstructs one sheet at a time instead of the entire stack
						var/obj/item/stack/material/S = I
						if(S.get_amount() > 1)
							S.use(1)
							loaded_item = S
						else
							qdel(S)
							desc = initial(desc)
							icon_state = initial(icon_state)
					else
						qdel(I)
						desc = initial(desc)
						icon_state = initial(icon_state)
			else
				return
		else
			to_chat(user, "<span class='filter_notice'>The [src] is empty.  Put something inside it first.</span>")
	if(response == "Sync")
		var/success = 0
		for(var/obj/machinery/r_n_d/server/S in machines)
			for(var/datum/tech/T in files.known_tech) //Uploading
				S.files.AddTech2Known(T)
			for(var/datum/tech/T in S.files.known_tech) //Downloading
				files.AddTech2Known(T)
			success = 1
			files.RefreshResearch()
		if(success)
			to_chat(user, "<span class='filter_notice'>You connect to the research server, push your data upstream to it, then pull the resulting merged data from the master branch.</span>")
			playsound(src, 'sound/machines/twobeep.ogg', 50, 1)
		else
			to_chat(user, "<span class='filter_notice'>Reserch server ping response timed out.  Unable to connect.  Please contact the system administrator.</span>")
			playsound(src, 'sound/machines/buzz-two.ogg', 50, 1)
	if(response == "Eject")
		if(loaded_item)
			loaded_item.loc = get_turf(src)
			desc = initial(desc)
			icon_state = initial(icon_state)
			loaded_item = null
		else
			to_chat(user, "<span class='filter_notice'>The [src] is already empty.</span>")


/obj/item/weapon/portable_destructive_analyzer/afterattack(var/atom/target, var/mob/living/user, proximity)
	if(!target)
		return
	if(!proximity)
		return
	if(!isturf(target.loc)) // Don't load up stuff if it's inside a container or mob!
		return
	if(istype(target,/obj/item))
		if(loaded_item)
			to_chat(user, "<span class='filter_notice'>Your [src] already has something inside.  Analyze or eject it first.</span>")
			return
		var/obj/item/I = target
		I.loc = src
		loaded_item = I
		for(var/mob/M in viewers())
			M.show_message("<span class='notice'>[user] adds the [I] to the [src].</span>", 1)
		desc = initial(desc) + "<br>It is holding \the [loaded_item]."
		flick("portable_analyzer_load", src)
		icon_state = "portable_analyzer_full"

/obj/item/weapon/portable_scanner
	name = "Portable Resonant Analyzer"
	icon = 'icons/obj/items.dmi'
	icon_state = "portable_scanner"
	desc = "An advanced scanning device used for analyzing objects without completely annihilating them for science. Unfortunately, it has no connection to any database like its angrier cousin."

/obj/item/weapon/portable_scanner/afterattack(var/atom/target, var/mob/living/user, proximity)
	if(!target)
		return
	if(!proximity)
		return
	if(istype(target,/obj/item))
		var/obj/item/I = target
		if(do_after(src, 5 SECONDS * I.w_class))
			for(var/mob/M in viewers())
				M.show_message(text("<span class='notice'>[user] sweeps \the [src] over \the [I].</span>"), 1)
			flick("[initial(icon_state)]-scan", src)
			if(I.origin_tech && I.origin_tech.len)
				for(var/T in I.origin_tech)
					to_chat(user, "<span class='notice'>\The [I] had level [I.origin_tech[T]] in [CallTechName(T)].</span>")
			else
				to_chat(user, "<span class='notice'>\The [I] cannot be scanned by \the [src].</span>")

//This is used to unlock other borg covers.
/obj/item/weapon/card/robot //This is not a child of id cards, as to avoid dumb typechecks on computers.
	name = "access code transmission device"
	icon_state = "id-robot"
	desc = "A circuit grafted onto the bottom of an ID card.  It is used to transmit access codes into other robot chassis, \
	allowing you to lock and unlock other robots' panels."

	var/dummy_card = null
	var/dummy_card_type = /obj/item/weapon/card/id/science/roboticist/dummy_cyborg

/obj/item/weapon/card/robot/Initialize()
	. = ..()
	dummy_card = new dummy_card_type(src)

/obj/item/weapon/card/robot/Destroy()
	qdel(dummy_card)
	dummy_card = null
	..()

/obj/item/weapon/card/robot/GetID()
	return dummy_card

/obj/item/weapon/card/robot/syndi
	dummy_card_type = /obj/item/weapon/card/id/syndicate/dummy_cyborg

/obj/item/weapon/card/id/science/roboticist/dummy_cyborg
	access = list(access_robotics)

/obj/item/weapon/card/id/syndicate/dummy_cyborg/Initialize()
	. = ..()
	access |= access_robotics

//A harvest item for serviceborgs.
/obj/item/weapon/robot_harvester
	name = "auto harvester"
	desc = "A hand-held harvest tool that resembles a sickle.  It uses energy to cut plant matter very efficently."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "autoharvester"

/obj/item/weapon/robot_harvester/afterattack(var/atom/target, var/mob/living/user, proximity)
	if(!target)
		return
	if(!proximity)
		return
	if(istype(target,/obj/machinery/portable_atmospherics/hydroponics))
		var/obj/machinery/portable_atmospherics/hydroponics/T = target
		if(T.harvest) //Try to harvest, assuming it's alive.
			T.harvest(user)
		else if(T.dead) //It's probably dead otherwise.
			T.remove_dead(user)
	else
		to_chat(user, "<span class='filter_notice'>Harvesting \a [target] is not the purpose of this tool. [src] is for plants being grown.</span>")

// A special tray for the service droid. Allow droid to pick up and drop items as if they were using the tray normally
// Click on table to unload, click on item to load. Otherwise works identically to a tray.
// Unlike the base item "tray", robotrays ONLY pick up food, drinks and condiments.

/obj/item/weapon/tray/robotray
	name = "RoboTray"
	desc = "An autoloading tray specialized for carrying refreshments."

/obj/item/weapon/tray/robotray/afterattack(atom/target, mob/user as mob, proximity)
	if(!proximity)
		return
	if ( !target )
		return
	// pick up items, mostly copied from base tray pickup proc
	// see code\game\objects\items\weapons\kitchen.dm line 241
	if ( istype(target,/obj/item))
		if ( !isturf(target.loc) ) // Don't load up stuff if it's inside a container or mob!
			return
		var turf/pickup = target.loc

		var addedSomething = 0

		for(var/obj/item/weapon/reagent_containers/food/I in pickup)


			if( I != src && !I.anchored && !istype(I, /obj/item/clothing/under) && !istype(I, /obj/item/clothing/suit) && !istype(I, /obj/item/projectile) )
				var/add = 0
				if(I.w_class == ITEMSIZE_TINY)
					add = 1
				else if(I.w_class == ITEMSIZE_SMALL)
					add = 3
				else
					add = 5
				if(calc_carry() + add >= max_carry)
					break

				I.loc = src
				carrying.Add(I)
				add_overlay(image("icon" = I.icon, "icon_state" = I.icon_state, "layer" = 30 + I.layer))
				addedSomething = 1
		if ( addedSomething )
			user.visible_message("<span class='notice'>[user] loads some items onto their service tray.</span>")

		return

	// Unloads the tray, copied from base item's proc dropped() and altered
	// see code\game\objects\items\weapons\kitchen.dm line 263

	if ( isturf(target) || istype(target,/obj/structure/table) )
		var foundtable = istype(target,/obj/structure/table/)
		if ( !foundtable ) //it must be a turf!
			for(var/obj/structure/table/T in target)
				foundtable = 1
				break

		var turf/dropspot
		if ( !foundtable ) // don't unload things onto walls or other silly places.
			dropspot = user.loc
		else if ( isturf(target) ) // they clicked on a turf with a table in it
			dropspot = target
		else					// they clicked on a table
			dropspot = target.loc


		overlays = null

		var droppedSomething = 0

		for(var/obj/item/I in carrying)
			I.loc = dropspot
			carrying.Remove(I)
			droppedSomething = 1
			if(!foundtable && isturf(dropspot))
				// if no table, presume that the person just shittily dropped the tray on the ground and made a mess everywhere!
				spawn()
					for(var/i = 1, i <= rand(1,2), i++)
						if(I)
							step(I, pick(NORTH,SOUTH,EAST,WEST))
							sleep(rand(2,4))
		if ( droppedSomething )
			if ( foundtable )
				user.visible_message("<span class='notice'>[user] unloads their service tray.</span>")
			else
				user.visible_message("<span class='notice'>[user] drops all the items on their tray.</span>")

	return ..()




// A special pen for service droids. Can be toggled to switch between normal writting mode, and paper rename mode
// Allows service droids to rename paper items.

/obj/item/weapon/pen/robopen
	desc = "A black ink printing attachment with a paper naming mode."
	name = "Printing Pen"
	var/mode = 1

/obj/item/weapon/pen/robopen/attack_self(mob/user as mob)

	var/choice = tgui_alert(usr, "Would you like to change colour or mode?", "Change What?", list("Colour","Mode","Cancel"))
	if(!choice || choice == "Cancel")
		return

	playsound(src, 'sound/effects/pop.ogg', 50, 0)

	switch(choice)

		if("Colour")
			var/newcolour = tgui_input_list(usr, "Which colour would you like to use?", "Color Choice", list("black","blue","red","green","yellow"))
			if(newcolour) colour = newcolour

		if("Mode")
			if (mode == 1)
				mode = 2
			else
				mode = 1
			to_chat(user, "<span class='filter_notice'>Changed printing mode to '[mode == 2 ? "Rename Paper" : "Write Paper"]'</span>")

	return

// Copied over from paper's rename verb
// see code\modules\paperwork\paper.dm line 62

/obj/item/weapon/pen/robopen/proc/RenamePaper(mob/user, obj/item/weapon/paper/paper)
	if ( !user || !paper )
		return
	var/n_name = sanitizeSafe(tgui_input_text(user, "What would you like to label the paper?", "Paper Labelling", null, 32), 32)
	if ( !user || !paper )
		return

	//n_name = copytext(n_name, 1, 32)
	if(( get_dist(user,paper) <= 1  && user.stat == 0))
		paper.name = "paper[(n_name ? text("- '[n_name]'") : null)]"
		paper.last_modified_ckey = user.ckey
	add_fingerprint(user)
	return

//TODO: Add prewritten forms to dispense when you work out a good way to store the strings.
/obj/item/weapon/form_printer
	//name = "paperwork printer"
	name = "paper dispenser"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "paper_bin1"
	item_icons = list(
			slot_l_hand_str = 'icons/mob/items/lefthand_material.dmi',
			slot_r_hand_str = 'icons/mob/items/righthand_material.dmi',
			)
	item_state = "sheet-metal"

/obj/item/weapon/form_printer/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	return

/obj/item/weapon/form_printer/afterattack(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, flag, params)

	if(!target || !flag)
		return

	if(istype(target,/obj/structure/table))
		deploy_paper(get_turf(target))

/obj/item/weapon/form_printer/attack_self(mob/user as mob)
	deploy_paper(get_turf(src))

<<<<<<< HEAD
/obj/item/weapon/form_printer/proc/deploy_paper(var/turf/T)
	T.visible_message("<font color='blue'>\The [src.loc] dispenses a sheet of crisp white paper.</font>")
	new /obj/item/weapon/paper(T)
=======
/obj/item/form_printer/proc/deploy_paper(var/turf/T)
	T.visible_message("<span class='notice'>\The [src.loc] dispenses a sheet of crisp white paper.</span>")
	new /obj/item/paper(T)
>>>>>>> 75577bd3ca9... cleans up so many to_chats so they use vchat filters, unsorted chat filter for everything else (#9006)


//Personal shielding for the combat module.
/obj/item/borg/combat/shield
	name = "personal shielding"
	desc = "A powerful experimental module that turns aside or absorbs incoming attacks at the cost of charge."
	icon = 'icons/obj/decals.dmi'
	icon_state = "shock"
	var/shield_level = 0.5			//Percentage of damage absorbed by the shield.
	var/active = 1					//If the shield is on
	var/flash_count = 0				//Counter for how many times the shield has been flashed
	var/overload_threshold = 3		//Number of flashes it takes to overload the shield
	var/shield_refresh = 15 SECONDS	//Time it takes for the shield to reboot after destabilizing
	var/overload_time = 0			//Stores the time of overload
	var/last_flash = 0				//Stores the time of last flash

/obj/item/borg/combat/shield/New()
	START_PROCESSING(SSobj, src)
	..()

/obj/item/borg/combat/shield/Destroy()
	STOP_PROCESSING(SSobj, src)
	..()

/obj/item/borg/combat/shield/attack_self(var/mob/living/user)
	set_shield_level()

/obj/item/borg/combat/shield/process()
	if(active)
		if(flash_count && (last_flash + shield_refresh < world.time))
			flash_count = 0
			last_flash = 0
	else if(overload_time + shield_refresh < world.time)
		active = 1
		flash_count = 0
		overload_time = 0

		var/mob/living/user = src.loc
		user.visible_message("<span class='danger'>[user]'s shield reactivates!</span>", "<span class='danger'>Your shield reactivates!</span>")
		user.update_icon()

/obj/item/borg/combat/shield/proc/adjust_flash_count(var/mob/living/user, amount)
	if(active)			//Can't destabilize a shield that's not on
		flash_count += amount

		if(amount > 0)
			last_flash = world.time
			if(flash_count >= overload_threshold)
				overload(user)

/obj/item/borg/combat/shield/proc/overload(var/mob/living/user)
	active = 0
	user.visible_message("<span class='danger'>[user]'s shield destabilizes!</span>", "<span class='danger'>Your shield destabilizes!</span>")
	user.update_icon()
	overload_time = world.time

/obj/item/borg/combat/shield/verb/set_shield_level()
	set name = "Set shield level"
	set category = "Object"
	set src in range(0)

	var/N = tgui_input_list(usr, "How much damage should the shield absorb?", "Shield Level", list("5","10","25","50","75","100"))
	if (N)
		shield_level = text2num(N)/100

/obj/item/borg/combat/mobility
	name = "mobility module"
	desc = "By retracting limbs and tucking in its head, a combat android can roll at high speeds."
	icon = 'icons/obj/decals.dmi'
	icon_state = "shock"

/obj/item/weapon/inflatable_dispenser
	name = "inflatables dispenser"
	desc = "Hand-held device which allows rapid deployment and removal of inflatables."
	icon = 'icons/obj/storage.dmi'
	icon_state = "inf_deployer"
	w_class = ITEMSIZE_LARGE

	var/stored_walls = 5
	var/stored_doors = 2
	var/max_walls = 5
	var/max_doors = 2
	var/mode = 0 // 0 - Walls   1 - Doors

/obj/item/weapon/inflatable_dispenser/robot
	w_class = ITEMSIZE_HUGE
	stored_walls = 10
	stored_doors = 5
	max_walls = 10
	max_doors = 5

/obj/item/weapon/inflatable_dispenser/examine(var/mob/user)
	. = ..()
	. += "It has [stored_walls] wall segment\s and [stored_doors] door segment\s stored."
	. += "It is set to deploy [mode ? "doors" : "walls"]"

/obj/item/weapon/inflatable_dispenser/attack_self()
	mode = !mode
	to_chat(usr, "<span class='filter_notice'>You set \the [src] to deploy [mode ? "doors" : "walls"].</span>")

/obj/item/weapon/inflatable_dispenser/afterattack(var/atom/A, var/mob/user)
	..(A, user)
	if(!user)
		return
	if(!user.Adjacent(A))
		to_chat(user, "You can't reach!")
		return
	if(istype(A, /turf))
		try_deploy_inflatable(A, user)
	if(istype(A, /obj/item/inflatable) || istype(A, /obj/structure/inflatable))
		pick_up(A, user)

/obj/item/weapon/inflatable_dispenser/proc/try_deploy_inflatable(var/turf/T, var/mob/living/user)
	if(mode) // Door deployment
		if(!stored_doors)
			to_chat(user, "<span class='filter_notice'>\The [src] is out of doors!</span>")
			return

		if(T && istype(T))
			new /obj/structure/inflatable/door(T)
			stored_doors--

	else // Wall deployment
		if(!stored_walls)
			to_chat(user, "<span class='filter_notice'>\The [src] is out of walls!</span>")
			return

		if(T && istype(T))
			new /obj/structure/inflatable(T)
			stored_walls--

	playsound(T, 'sound/items/zip.ogg', 75, 1)
	to_chat(user, "<span class='filter_notice'>You deploy the inflatable [mode ? "door" : "wall"]!</span>")

/obj/item/weapon/inflatable_dispenser/proc/pick_up(var/obj/A, var/mob/living/user)
	if(istype(A, /obj/structure/inflatable))
		if(!istype(A, /obj/structure/inflatable/door))
			if(stored_walls >= max_walls)
				to_chat(user, "<span class='filter_notice'>\The [src] is full.</span>")
				return
			stored_walls++
			qdel(A)
		else
			if(stored_doors >= max_doors)
				to_chat(user, "<span class='filter_notice'>\The [src] is full.</span>")
				return
			stored_doors++
			qdel(A)
		playsound(src, 'sound/machines/hiss.ogg', 75, 1)
		visible_message("<span class='filter_notice'>\The [user] deflates \the [A] with \the [src]!</span>")
		return
	if(istype(A, /obj/item/inflatable))
		if(!istype(A, /obj/item/inflatable/door))
			if(stored_walls >= max_walls)
				to_chat(user, "<span class='filter_notice'>\The [src] is full.</span>")
				return
			stored_walls++
			qdel(A)
		else
			if(stored_doors >= max_doors)
				to_chat(usr, "<span class='filter_notice'>\The [src] is full!</span>")
				return
			stored_doors++
			qdel(A)
		visible_message("<span class='filter_notice'>\The [user] picks up \the [A] with \the [src]!</span>")
		return

	to_chat(user, "<span class='filter_notice'>You fail to pick up \the [A] with \the [src].</span>")
	return
