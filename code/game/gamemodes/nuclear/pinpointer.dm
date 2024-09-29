/obj/item/pinpointer
	name = "pinpointer"
	icon = 'icons/obj/device.dmi'
	icon_state = "pinoff"
	slot_flags = SLOT_BELT
	w_class = ITEMSIZE_SMALL
	item_state = "electronic"
	throw_speed = 4
	throw_range = 20
	matter = list(MAT_STEEL = 500)
	preserve_item = 1
	var/obj/item/disk/nuclear/the_disk = null
	var/active = 0

/obj/item/pinpointer/Destroy()
	active = 0
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/pinpointer/attack_self()
	if(!active)
		active = 1
		START_PROCESSING(SSobj, src)
		to_chat(usr, "<span class='notice'>You activate the pinpointer</span>")
	else
		active = 0
		STOP_PROCESSING(SSobj, src)
		icon_state = "pinoff"
		to_chat(usr, "<span class='notice'>You deactivate the pinpointer</span>")

/obj/item/pinpointer/process()
	if(!active)
		return PROCESS_KILL
	
	if(!the_disk)
		the_disk = locate()
		if(!the_disk)
			icon_state = "pinonnull"
			return
	
	set_dir(get_dir(src,the_disk))
	
	switch(get_dist(src,the_disk))
		if(0)
			icon_state = "pinondirect"
		if(1 to 8)
			icon_state = "pinonclose"
		if(9 to 16)
			icon_state = "pinonmedium"
		if(16 to INFINITY)
			icon_state = "pinonfar"

/obj/item/pinpointer/examine(mob/user)
	. = ..()
	for(var/obj/machinery/nuclearbomb/bomb in machines)
		if(bomb.timing)
			. += "Extreme danger.  Arming signal detected.   Time remaining: [bomb.timeleft]"



/obj/item/pinpointer/advpinpointer
	name = "Advanced Pinpointer"
	icon = 'icons/obj/device.dmi'
	desc = "A larger version of the normal pinpointer, this unit features a helpful quantum entanglement detection system to locate various objects that do not broadcast a locator signal."
	var/mode = 0  // Mode 0 locates disk, mode 1 locates coordinates.
	var/turf/location = null
	var/obj/target = null

/obj/item/pinpointer/advpinpointer/process()
	if(!active)
		return PROCESS_KILL
	if(mode == 0)
		..()
	if(mode == 1)
		worklocation()
	if(mode == 2)
		workobj()

/obj/item/pinpointer/advpinpointer/proc/worklocation()
	if(!location)
		icon_state = "pinonnull"
		return

	set_dir(get_dir(src,location))

	switch(get_dist(src,location))
		if(0)
			icon_state = "pinondirect"
		if(1 to 8)
			icon_state = "pinonclose"
		if(9 to 16)
			icon_state = "pinonmedium"
		if(16 to INFINITY)
			icon_state = "pinonfar"

/obj/item/pinpointer/advpinpointer/proc/workobj()
	if(!target)
		icon_state = "pinonnull"
		return

	set_dir(get_dir(src,target))

	switch(get_dist(src,target))
		if(0)
			icon_state = "pinondirect"
		if(1 to 8)
			icon_state = "pinonclose"
		if(9 to 16)
			icon_state = "pinonmedium"
		if(16 to INFINITY)
			icon_state = "pinonfar"

/obj/item/pinpointer/advpinpointer/verb/toggle_mode()
	set category = "Object"
	set name = "Toggle Pinpointer Mode"
	set src in view(1)

	active = 0
	icon_state = "pinoff"
	target=null
	location = null

	switch(tgui_alert(usr, "Please select the mode you want to put the pinpointer in.", "Pinpointer Mode Select", list("Location", "Disk Recovery", "Other Signature")))
		if("Location")
			mode = 1

			var/locationx = tgui_input_number(usr, "Please input the x coordinate to search for.", "Location?" , "")
			if(!locationx || !(usr in view(1,src)))
				return
			var/locationy = tgui_input_number(usr, "Please input the y coordinate to search for.", "Location?" , "")
			if(!locationy || !(usr in view(1,src)))
				return

			var/turf/Z = get_turf(src)

			location = locate(locationx,locationy,Z.z)

			to_chat(usr, "You set the pinpointer to locate [locationx],[locationy]")

			return attack_self()

		if("Disk Recovery")
			mode = 0
			return attack_self()

		if("Other Signature")
			mode = 2
			switch(tgui_alert(usr, "Search for item signature or DNA fragment?", "Signature Mode Select", list("Item", "DNA")))

				if("Item")
					var/datum/objective/steal/itemlist
					itemlist = itemlist
					var/targetitem = tgui_input_list(usr, "Select item to search for.", "Item Mode Select", itemlist.possible_items)
					if(!targetitem)
						return
					target=locate(itemlist.possible_items[targetitem])
					if(!target)
						to_chat(usr, "Failed to locate [targetitem]!")
						return
					to_chat(usr, "You set the pinpointer to locate [targetitem]")

				if("DNA")
					var/DNAstring = tgui_input_text(usr, "Input DNA string to search for." , "Please Enter String." , "")
					if(!DNAstring)
						return
					for(var/mob/living/carbon/M in mob_list)
						if(!M.dna)
							continue
						if(M.dna.unique_enzymes == DNAstring)
							target = M
							break

			return attack_self()


///////////////////////
//nuke op pinpointers//
///////////////////////


/obj/item/pinpointer/nukeop
	var/mode = 0	//Mode 0 locates disk, mode 1 locates the shuttle
	var/obj/machinery/computer/shuttle_control/multi/syndicate/home = null

/obj/item/pinpointer/nukeop/attack_self(mob/user as mob)
	if(!active)
		active = 1
		START_PROCESSING(SSobj, src)
		if(!mode)
			workdisk()
			to_chat(user, "<span class='notice'>Authentication Disk Locator active.</span>")
		else
			worklocation()
			to_chat(user, "<span class='notice'>Shuttle Locator active.</span>")
	else
		active = 0
		STOP_PROCESSING(SSobj, src)
		icon_state = "pinoff"
		to_chat(user, "<span class='notice'>You deactivate the pinpointer.</span>")

/obj/item/pinpointer/nukeop/process()
	if(!active)
		return PROCESS_KILL

	switch(mode)
		if(0)
			workdisk()
		if(1)
			worklocation()

/obj/item/pinpointer/nukeop/proc/workdisk()
	if(bomb_set)	//If the bomb is set, lead to the shuttle
		mode = 1	//Ensures worklocation() continues to work
		playsound(src, 'sound/machines/twobeep.ogg', 50, 1)	//Plays a beep
		visible_message("<span class='notice'>Shuttle Locator active.</span>")			//Lets the mob holding it know that the mode has changed
		return		//Get outta here

	if(!the_disk)
		the_disk = locate()
		if(!the_disk)
			icon_state = "pinonnull"
			return

	set_dir(get_dir(src, the_disk))

	switch(get_dist(src, the_disk))
		if(0)
			icon_state = "pinondirect"
		if(1 to 8)
			icon_state = "pinonclose"
		if(9 to 16)
			icon_state = "pinonmedium"
		if(16 to INFINITY)
			icon_state = "pinonfar"

/obj/item/pinpointer/nukeop/proc/worklocation()
	if(!bomb_set)
		mode = 0
		playsound(src, 'sound/machines/twobeep.ogg', 50, 1)
		visible_message("<span class='notice'>Authentication Disk Locator active.</span>")
		return

	if(!home)
		home = locate()
		if(!home)
			icon_state = "pinonnull"
			return

	if(loc.z != home.z)	//If you are on a different z-level from the shuttle
		icon_state = "pinonnull"

	else
		set_dir(get_dir(src, home))

		switch(get_dist(src, home))
			if(0)
				icon_state = "pinondirect"
			if(1 to 8)
				icon_state = "pinonclose"
			if(9 to 16)
				icon_state = "pinonmedium"
			if(16 to INFINITY)
				icon_state = "pinonfar"


// This one only points to the ship.  Useful if there is no nuking to occur today.
/obj/item/pinpointer/shuttle
	var/shuttle_comp_id = null
	var/obj/machinery/computer/shuttle_control/our_shuttle = null

/obj/item/pinpointer/shuttle/attack_self(mob/user as mob)
	if(!active)
		active = TRUE
		START_PROCESSING(SSobj, src)
		to_chat(user, "<span class='notice'>Shuttle Locator active.</span>")
	else
		active = FALSE
		STOP_PROCESSING(SSobj, src)
		icon_state = "pinoff"
		to_chat(user, "<span class='notice'>You deactivate the pinpointer.</span>")

/obj/item/pinpointer/shuttle/process()
	if(!active)
		return PROCESS_KILL

	if(!our_shuttle)
		for(var/obj/machinery/computer/shuttle_control/S in machines)
			if(S.shuttle_tag == shuttle_comp_id) // Shuttle tags are used so that it will work if the computer path changes, as it does on the southern cross map.
				our_shuttle = S
				break

		if(!our_shuttle)
			icon_state = "pinonnull"
			return

	if(loc.z != our_shuttle.z)	//If you are on a different z-level from the shuttle
		icon_state = "pinonnull"
	
	else
		set_dir(get_dir(src, our_shuttle))
	
		switch(get_dist(src, our_shuttle))
			if(0)
				icon_state = "pinondirect"
			if(1 to 8)
				icon_state = "pinonclose"
			if(9 to 16)
				icon_state = "pinonmedium"
			if(16 to INFINITY)
				icon_state = "pinonfar"


/obj/item/pinpointer/shuttle/merc
	shuttle_comp_id = "Mercenary"

/obj/item/pinpointer/shuttle/heist
	shuttle_comp_id = "Skipjack"