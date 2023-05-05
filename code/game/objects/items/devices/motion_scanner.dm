/obj/item/device/multi_scanner
	name = "motion sensor"
	desc = "A handheld device that scans the surrounding area for lifesigns using a sophisticated array of sensors, then outputs the scan results onto the display for the user to review. WARNING: Do not point the operational end of the device directly at organic life forms whilst scanning is in progress."
	description_info = "The scanner must be powered on before it can be used. Toggle the power state with ALT+LEFT CLICK. It does not require a cell to be installed to power on, but it does require one to scan. It consumes a quarter of a standard device power cell's charge per area scan."
	icon_state = "hyperscan_off"
	item_state = "multitool"
	w_class = ITEMSIZE_SMALL
	var/scan_range = 14 //twice standard view range
	var/detects_ghosts = FALSE	//who ya gonna call?
	var/power_stat = 0	//0 = off / 1 = on
	var/obj/item/weapon/cell/cell
	var/cell_type = /obj/item/weapon/cell/device
	var/scan_cost = 120	//you get 4 pings per standard device cell (480), deducted when the scan starts (so don't interrupt it!)

/obj/item/device/multi_scanner/ghost_buster
	detects_ghosts = TRUE

/obj/item/device/multi_scanner/Initialize()
	. = ..()
	cell = new cell_type(src)
	update_icon()

/obj/item/device/multi_scanner/examine(mob/user)
	. = ..()
	if(cell && power_stat)	//needs to be powered on to read the cell status
		. += "\The [src] has a \the [cell] installed."
		. += "The power readout indicates the device has [(cell.charge/cell.maxcharge)*100]% power remaining."
	else if(!cell)
		. += "It doesn't have a power cell installed."

/obj/item/device/multi_scanner/emp_act(severity)
	for(var/obj/O in contents)
		O.emp_act(severity)
	..()

/obj/item/device/multi_scanner/AltClick()
	power_stat = !power_stat
	update_icon()
	to_chat(usr,"<span class='notice'>You power \the [src] [power_stat ? "on" : "off"].</span>")

/obj/item/device/multi_scanner/update_icon()
	if(power_stat)
		icon_state = "hyperscan_on"
	else
		icon_state = "hyperscan_off"

/obj/item/device/multi_scanner/attack_hand(mob/user as mob)
	if(user.get_inactive_hand() == src)
		if(!user.IsAdvancedToolUser())
			return
		else if(power_stat)
			to_chat(user, "<span class='warning'>You should turn the [src] off before removing the battery.</span>")
			return
		else if(cell)
			cell.update_icon()
			user.put_in_hands(cell)
			cell = null
			to_chat(user, "<span class='notice'>You remove the cell from the [src].</span>")
			return
		..()
	else
		return ..()

/obj/item/device/multi_scanner/attackby(obj/item/weapon/W, mob/user as mob)
	if(istype(W, /obj/item/weapon/cell))
		if(istype(W, /obj/item/weapon/cell/device))
			if(!cell)
				user.drop_item()
				W.loc = src
				cell = W
				to_chat(user, "<span class='notice'>You install a cell in \the [src].</span>")
				playsound(src, 'sound/machines/button.ogg', 30, 1, 0)
			else
				to_chat(user, "<span class='notice'>\The [src] already has a cell.</span>")
		else
			to_chat(user, "<span class='notice'>\The [src] cannot use that type of cell.</span>")

	else
		..()

/obj/item/device/multi_scanner/attack_self(mob/user)
	var/carbon_count
	var/silicon_count
	var/simple_count
	var/ghost_count
	if(!user.IsAdvancedToolUser())
		to_chat(user,"<span class='warning'>This is way too complicated for you to understand!</span>")
		return
	if(!power_stat)
		to_chat(usr,"<span class='warning'>Scanner not powered on, cannot proceed.</span>")
		return
	if(cell.charge < scan_cost)
		to_chat(usr,"<span class='warning'>Not enough power! Cannot proceed.</span>")
		return
	else
		user.visible_message("<span class='notice'>[user] begins to scan the area with \the [src].</span>","<span class='notice'>Scan initiated, please remain stationary...</span>")
		cell.charge -= scan_cost	//consume charge BEFORE outputting the result, to encourage people to be careful with it
		playsound(src, 'sound/machines/terminal_alert.ogg', 75, 1, -1)
		for(var/mob/L in orange(scan_range))
			if(istype(L,/mob/living/carbon))
				carbon_count++
			if(istype(L,/mob/living/silicon))
				silicon_count++
			if(istype(L,/mob/living/simple_mob))
				simple_count++
			if(detects_ghosts && istype(L,/mob/observer/dead))
				ghost_count++

		flick("hyperscan_scanning",src)
		if(do_after(usr,3 SECONDS))
			if(carbon_count > 0)
				to_chat(usr,"<span class='notice'>Complex Carbon-Based Lifeforms in Range: [carbon_count]</span>")
			if(silicon_count > 0)
				to_chat(usr,"<span class='notice'>Complex Silicon-Based Lifeforms in Range: [silicon_count]</span>")
			if(simple_count > 0)
				to_chat(usr,"<span class='notice'>Primitive Lifeforms in Range: [simple_count]</span>")
			if(ghost_count > 0 && detects_ghosts)
				to_chat(usr,"<span class='notice'>Ectoplasmic Lifeforms in range: [ghost_count]</span>")
			if(carbon_count+silicon_count+simple_count < 1)	//didn't see nuffin'
				to_chat(usr,"<span class='notice'>No lifesigns detected.</span>")