///////////////////////////////
//CABLE STRUCTURE
///////////////////////////////


////////////////////////////////
// Definitions
////////////////////////////////

/* Cable directions (d1 and d2)


  9   1   5
	\ | /
  8 - 0 - 4,
	/ | \
  10  2   6

If d1 = 0 and d2 = 0, there's no cable
If d1 = 0 and d2 = dir, it's a O-X cable, getting from the center of the tile to dir (knot cable)
If d1 = dir1 and d2 = dir2, it's a full X-X cable, getting from dir1 to dir2
By design, d1 is the smallest direction and d2 is the highest
*/
var/list/possible_cable_coil_colours = list(
		"White" = COLOR_WHITE,
		"Silver" = COLOR_SILVER,
		"Gray" = COLOR_GRAY,
		"Black" = COLOR_BLACK,
		"Red" = COLOR_RED,
		"Maroon" = COLOR_MAROON,
		"Yellow" = COLOR_YELLOW,
		"Olive" = COLOR_OLIVE,
		"Lime" = COLOR_GREEN,
		"Green" = COLOR_LIME,
		"Cyan" = COLOR_CYAN,
		"Teal" = COLOR_TEAL,
		"Blue" = COLOR_BLUE,
		"Navy" = COLOR_NAVY,
		"Pink" = COLOR_PINK,
		"Purple" = COLOR_PURPLE,
		"Orange" = COLOR_ORANGE,
		"Beige" = COLOR_BEIGE,
		"Brown" = COLOR_BROWN
	)

/obj/structure/cable
	level = 1
	anchored =TRUE
	unacidable = TRUE
	var/datum/powernet/powernet
	name = "power cable"
	desc = "A flexible superconducting cable for heavy-duty power transfer."
	icon = 'icons/obj/power_cond_white.dmi'
	icon_state = "0-1"
	var/d1 = 0
	var/d2 = 1
	plane = PLATING_PLANE
	layer = WIRES_LAYER
	color = COLOR_RED
	var/obj/machinery/power/breakerbox/breaker_box

/obj/structure/cable/drain_power(var/drain_check, var/surge, var/amount = 0)
	if(drain_check)
		return 1

	if(!powernet)
		return 0

	return powernet.draw_power(amount)

/obj/structure/cable/yellow
	color = COLOR_YELLOW

/obj/structure/cable/green
	color = COLOR_LIME

/obj/structure/cable/blue
	color = COLOR_BLUE

/obj/structure/cable/pink
	color = COLOR_PINK

/obj/structure/cable/orange
	color = COLOR_ORANGE

/obj/structure/cable/cyan
	color = COLOR_CYAN

/obj/structure/cable/white
	color = COLOR_WHITE

/obj/structure/cable/New()
	..()

	// ensure d1 & d2 reflect the icon_state for entering and exiting cable

	var/dash = findtext(icon_state, "-")

	d1 = text2num( copytext( icon_state, 1, dash ) )

	d2 = text2num( copytext( icon_state, dash+1 ) )

	var/turf/T = src.loc			// hide if turf is not intact
	if(level==1) hide(!T.is_plating())
	cable_list += src //add it to the global cable list


/obj/structure/cable/Destroy()					// called when a cable is deleted
	if(powernet)
		cut_cable_from_powernet()				// update the powernets
	cable_list -= src							//remove it from global cable list
	return ..()									// then go ahead and delete the cable

/obj/structure/cable/examine(mob/user)
	. = ..()
	if(isobserver(user))
		. += "<span class='warning'>[powernet?.avail > 0 ? "[DisplayPower(powernet.avail)] in power network." : "The cable is not powered."]</span>"

// Rotating cables requires d1 and d2 to be rotated
/obj/structure/cable/set_dir(new_dir)
	if(powernet)
		cut_cable_from_powernet() // Remove this cable from the powernet so the connections update

	// If d1 is 0, then it's a not, and doesn't rotate
	if(d1)
		// Using turn will maintain the cable's shape
		// Taking the difference between current orientation and new one
		d1 = turn(d1, dir2angle(new_dir) - dir2angle(dir))
	d2 = turn(d2, dir2angle(new_dir) - dir2angle(dir))

	// Maintain d1 < d2
	if(d1 > d2)
		var/temp = d1
		d1 = d2
		d2 = temp

	//	..()	Cable sprite generation is dependent upon only d1 and d2.
	// 			Actually changing dir will rotate the generated sprite to look wrong, but function correctly.
	update_icon()
	// Add this cable back to the powernet, if it's connected to any
	if(d1)
		mergeConnectedNetworks(d1)
	else
		mergeConnectedNetworksOnTurf()
	mergeConnectedNetworks(d2)

///////////////////////////////////
// General procedures
///////////////////////////////////

//If underfloor, hide the cable
/obj/structure/cable/hide(var/i)
	if(istype(loc, /turf))
		invisibility = i ? 101 : 0
	update_icon()

/obj/structure/cable/hides_under_flooring()
	return 1

/obj/structure/cable/update_icon()
	icon_state = "[d1]-[d2]"
	alpha = invisibility ? 127 : 255

//Telekinesis has no effect on a cable
/obj/structure/cable/attack_tk(mob/user)
	return

// Items usable on a cable :
//   - Wirecutters : cut it duh !
//   - Cable coil : merge cables
//   - Multitool : get the power currently passing through the cable
//

/obj/structure/cable/attackby(obj/item/W, mob/user)

	var/turf/T = src.loc
	if(!T.is_plating())
		return

	if(W.is_wirecutter())
		var/obj/item/stack/cable_coil/CC
		if(d1 == UP || d2 == UP)
			to_chat(user, "<span class='warning'>You must cut this cable from above.</span>")
			return

		if(breaker_box)
			to_chat(user, "<span class='warning'>This cable is connected to nearby breaker box. Use breaker box to interact with it.</span>")
			return

		if (shock(user, 50))
			return

		if(src.d1)	// 0-X cables are 1 unit, X-X cables are 2 units long
			CC = new/obj/item/stack/cable_coil(T, 2, color)
		else
			CC = new/obj/item/stack/cable_coil(T, 1, color)

		src.add_fingerprint(user)
		src.transfer_fingerprints_to(CC)

		for(var/mob/O in viewers(src, null))
			O.show_message("<span class='warning'>[user] cuts the cable.</span>", 1)

		if(d1 == DOWN || d2 == DOWN)
			var/turf/turf = GetBelow(src)
			if(turf)
				for(var/obj/structure/cable/c in turf)
					if(c.d1 == UP || c.d2 == UP)
						qdel(c)

		investigate_log("was cut by [key_name(usr, usr.client)] in [user.loc.loc]","wires")

		qdel(src)
		return


	else if(istype(W, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/coil = W
		if (coil.get_amount() < 1)
			to_chat(user, "Not enough cable")
			return
		coil.cable_join(src, user)

	else if(istype(W, /obj/item/device/multitool))

		if(powernet && (powernet.avail > 0))		// is it powered?
			to_chat(user, "<span class='warning'>[DisplayPower(powernet.avail)] in power network.</span>")

		else
			to_chat(user, "<span class='warning'>The cable is not powered.</span>")

		shock(user, 5, 0.2)

	else
		if(!(W.atom_flags & ATOM_IS_INSULATED))
			shock(user, 50, 0.7)

	src.add_fingerprint(user)

// shock the user with probability prb
/obj/structure/cable/proc/shock(mob/user, prb, var/siemens_coeff = 1.0)
	if(!prob(prb))
		return 0
	if (electrocute_mob(user, powernet, src, siemens_coeff))
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(5, 1, src)
		s.start()
		if(usr.stunned)
			return 1
	return 0

//explosion handling
/obj/structure/cable/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
		if(2.0)
			if (prob(50))
				new/obj/item/stack/cable_coil(src.loc, src.d1 ? 2 : 1, color)
				qdel(src)

		if(3.0)
			if (prob(25))
				new/obj/item/stack/cable_coil(src.loc, src.d1 ? 2 : 1, color)
				qdel(src)
	return

/obj/structure/cable/proc/cableColor(var/colorC)
	var/color_n = "#DD0000"
	if(colorC)
		color_n = colorC
	color = color_n

/////////////////////////////////////////////////
// Cable laying helpers
////////////////////////////////////////////////

//handles merging diagonally matching cables
//for info : direction^3 is flipping horizontally, direction^12 is flipping vertically
/obj/structure/cable/proc/mergeDiagonalsNetworks(var/direction)

	//search for and merge diagonally matching cables from the first direction component (north/south)
	var/turf/T  = get_step(src, direction&3)//go north/south

	for(var/obj/structure/cable/C in T)

		if(!C)
			continue

		if(src == C)
			continue

		if(C.d1 == (direction^3) || C.d2 == (direction^3)) //we've got a diagonally matching cable
			if(!C.powernet) //if the matching cable somehow got no powernet, make him one (should not happen for cables)
				var/datum/powernet/newPN = new()
				newPN.add_cable(C)

			if(powernet) //if we already have a powernet, then merge the two powernets
				merge_powernets(powernet,C.powernet)
			else
				C.powernet.add_cable(src) //else, we simply connect to the matching cable powernet

	//the same from the second direction component (east/west)
	T  = get_step(src, direction&12)//go east/west

	for(var/obj/structure/cable/C in T)

		if(!C)
			continue

		if(src == C)
			continue
		if(C.d1 == (direction^12) || C.d2 == (direction^12)) //we've got a diagonally matching cable
			if(!C.powernet) //if the matching cable somehow got no powernet, make him one (should not happen for cables)
				var/datum/powernet/newPN = new()
				newPN.add_cable(C)

			if(powernet) //if we already have a powernet, then merge the two powernets
				merge_powernets(powernet,C.powernet)
			else
				C.powernet.add_cable(src) //else, we simply connect to the matching cable powernet

// merge with the powernets of power objects in the given direction
/obj/structure/cable/proc/mergeConnectedNetworks(var/direction)

	var/fdir = direction ? reverse_dir[direction] : 0 //flip the direction, to match with the source position on its turf

	if(!(d1 == direction || d2 == direction)) //if the cable is not pointed in this direction, do nothing
		return

	var/turf/TB  = get_zstep(src, direction)

	for(var/obj/structure/cable/C in TB)

		if(!C)
			continue

		if(src == C)
			continue

		if(C.d1 == fdir || C.d2 == fdir) //we've got a matching cable in the neighbor turf
			if(!C.powernet) //if the matching cable somehow got no powernet, make him one (should not happen for cables)
				var/datum/powernet/newPN = new()
				newPN.add_cable(C)

			if(powernet) //if we already have a powernet, then merge the two powernets
				merge_powernets(powernet,C.powernet)
			else
				C.powernet.add_cable(src) //else, we simply connect to the matching cable powernet

// merge with the powernets of power objects in the source turf
/obj/structure/cable/proc/mergeConnectedNetworksOnTurf()
	var/list/to_connect = list()

	if(!powernet) //if we somehow have no powernet, make one (should not happen for cables)
		var/datum/powernet/newPN = new()
		newPN.add_cable(src)

	//first let's add turf cables to our powernet
	//then we'll connect machines on turf with a node cable is present
	for(var/AM in loc)
		if(istype(AM,/obj/structure/cable))
			var/obj/structure/cable/C = AM
			if(C.d1 == d1 || C.d2 == d1 || C.d1 == d2 || C.d2 == d2) //only connected if they have a common direction
				if(C.powernet == powernet)	continue
				if(C.powernet)
					merge_powernets(powernet, C.powernet)
				else
					powernet.add_cable(C) //the cable was powernetless, let's just add it to our powernet

		else if(istype(AM,/obj/machinery/power/apc))
			var/obj/machinery/power/apc/N = AM
			if(!N.terminal)	continue // APC are connected through their terminal

			if(N.terminal.powernet == powernet)
				continue

			to_connect += N.terminal //we'll connect the machines after all cables are merged

		else if(istype(AM,/obj/machinery/power)) //other power machines
			var/obj/machinery/power/M = AM

			if(M.powernet == powernet)
				continue

			to_connect += M //we'll connect the machines after all cables are merged

	//now that cables are done, let's connect found machines
	for(var/obj/machinery/power/PM in to_connect)
		if(!PM.connect_to_network())
			PM.disconnect_from_network() //if we somehow can't connect the machine to the new powernet, remove it from the old nonetheless

//////////////////////////////////////////////
// Powernets handling helpers
//////////////////////////////////////////////

//if powernetless_only = 1, will only get connections without powernet
/obj/structure/cable/proc/get_connections(var/powernetless_only = 0)
	. = list()	// this will be a list of all connected power objects
	var/turf/T

	// Handle standard cables in adjacent turfs
	for(var/cable_dir in list(d1, d2))
		if(cable_dir == 0)
			continue
		var/reverse = reverse_dir[cable_dir]
		T = get_zstep(src, cable_dir)
		if(T)
			for(var/obj/structure/cable/C in T)
				if(C.d1 == reverse || C.d2 == reverse)
					. += C
		if(cable_dir & (cable_dir - 1)) // Diagonal, check for /\/\/\ style cables along cardinal directions
			for(var/pair in list(NORTH|SOUTH, EAST|WEST))
				T = get_step(src, cable_dir & pair)
				if(T)
					var/req_dir = cable_dir ^ pair
					for(var/obj/structure/cable/C in T)
						if(C.d1 == req_dir || C.d2 == req_dir)
							. += C

	// Handle cables on the same turf as us
	for(var/obj/structure/cable/C in loc)
		if(C.d1 == d1 || C.d2 == d1 || C.d1 == d2 || C.d2 == d2) // if either of C's d1 and d2 match either of ours
			. += C

	if(d1 == 0)
		for(var/obj/machinery/power/P in loc)
			if(P.powernet == 0) continue // exclude APCs with powernet=0
			if(!powernetless_only || !P.powernet)
				. += P

	// if the caller asked for powernetless cables only, dump the ones with powernets
	if(powernetless_only)
		for(var/obj/structure/cable/C in .)
			if(C.powernet)
				. -= C

//should be called after placing a cable which extends another cable, creating a "smooth" cable that no longer terminates in the centre of a turf.
//needed as this can, unlike other placements, disconnect cables
/obj/structure/cable/proc/denode()
	var/turf/T1 = loc
	if(!T1) return

	var/list/powerlist = power_list(T1,src,0,0) //find the other cables that ended in the centre of the turf, with or without a powernet
	if(powerlist.len>0)
		var/datum/powernet/PN = new()
		propagate_network(powerlist[1],PN) //propagates the new powernet beginning at the source cable

		if(PN.is_empty()) //can happen with machines made nodeless when smoothing cables
			qdel(PN)

// cut the cable's powernet at this cable and updates the powergrid
/obj/structure/cable/proc/cut_cable_from_powernet()
	var/turf/T1 = loc
	var/list/P_list
	if(!T1)	return
	if(d1)
		T1 = get_step(T1, d1)
		P_list = power_list(T1, src, turn(d1,180),0,cable_only = 1)	// what adjacently joins on to cut cable...

	P_list += power_list(loc, src, d1, 0, cable_only = 1)//... and on turf


	if(P_list.len == 0)//if nothing in both list, then the cable was a lone cable, just delete it and its powernet
		powernet.remove_cable(src)

		for(var/obj/machinery/power/P in T1)//check if it was powering a machine
			if(!P.connect_to_network()) //can't find a node cable on a the turf to connect to
				P.disconnect_from_network() //remove from current network (and delete powernet)
		return

	// remove the cut cable from its turf and powernet, so that it doesn't get count in propagate_network worklist
	loc = null
	powernet.remove_cable(src) //remove the cut cable from its powernet

	var/datum/powernet/newPN = new()// creates a new powernet...
	propagate_network(P_list[1], newPN)//... and propagates it to the other side of the cable

	// Disconnect machines connected to nodes
	if(d1 == 0) // if we cut a node (O-X) cable
		for(var/obj/machinery/power/P in T1)
			if(!P.connect_to_network()) //can't find a node cable on a the turf to connect to
				P.disconnect_from_network() //remove from current network

///////////////////////////////////////////////
// The cable coil object, used for laying cable
///////////////////////////////////////////////

////////////////////////////////
// Definitions
////////////////////////////////

#define MAXCOIL 30

/obj/item/stack/cable_coil
	name = "cable coil"
	icon = 'icons/obj/power.dmi'
	icon_state = "coil"
	amount = MAXCOIL
	max_amount = MAXCOIL
	color = COLOR_RED
	desc = "A coil of power cable."
	throwforce = 10
	w_class = ITEMSIZE_SMALL
	throw_speed = 2
	throw_range = 5
	matter = list(MAT_STEEL = 50, MAT_GLASS = 20)
	slot_flags = SLOT_BELT
	item_state = "coil"
	attack_verb = list("whipped", "lashed", "disciplined", "flogged")
	stacktype = /obj/item/stack/cable_coil
	drop_sound = 'sound/items/drop/accessory.ogg'
	pickup_sound = 'sound/items/pickup/accessory.ogg'
	tool_qualities = list(TOOL_CABLE_COIL)
	singular_name = "cable"

/obj/item/stack/cable_coil/cyborg
	name = "cable coil synthesizer"
	desc = "A device that makes cable."
	gender = NEUTER
	matter = null
	uses_charge = 1
	charge_costs = list(1)

/obj/item/stack/cable_coil/New(loc, length = MAXCOIL, var/param_color = null)
	..()
	src.amount = length
	if (param_color) // It should be red by default, so only recolor it if parameter was specified.
		color = param_color
	pixel_x = rand(-2,2)
	pixel_y = rand(-2,2)
	update_icon()
	update_wclass()

///////////////////////////////////
// General procedures
///////////////////////////////////

//you can use wires to heal robotics
/obj/item/stack/cable_coil/attack(var/atom/A, var/mob/living/user, var/def_zone)
	if(ishuman(A) && user.a_intent == I_HELP)
		var/mob/living/carbon/human/H = A
		var/obj/item/organ/external/S = H.organs_by_name[user.zone_sel.selecting]

		if(!S || S.robotic < ORGAN_ROBOT || S.open == 3)
			return ..()

		//VOREStation Add - No welding nanoform limbs
		if(S.robotic > ORGAN_LIFELIKE)
			return ..()
		//VOREStation Add End

		if(S.organ_tag == BP_HEAD)
			if(H.head && istype(H.head,/obj/item/clothing/head/helmet/space))
				to_chat(user, "<span class='warning'>You can't apply [src] through [H.head]!</span>")
				return 1
		else
			if(H.wear_suit && istype(H.wear_suit,/obj/item/clothing/suit/space))
				to_chat(user, "<span class='warning'>You can't apply [src] through [H.wear_suit]!</span>")
				return 1

		var/use_amt = min(src.amount, CEILING(S.burn_dam/5, 1), 5)
		if(can_use(use_amt))
			if(S.robo_repair(5*use_amt, BURN, "some damaged wiring", src, user))
				src.use(use_amt)

	else
		return ..()

/obj/item/stack/cable_coil/update_icon()
	if (!color)
		color = pick(COLOR_RED, COLOR_BLUE, COLOR_LIME, COLOR_ORANGE, COLOR_WHITE, COLOR_PINK, COLOR_YELLOW, COLOR_CYAN)
	if(amount == 1)
		icon_state = "coil1"
		name = "cable piece"
	else if(amount == 2)
		icon_state = "coil2"
		name = "cable piece"
	else
		icon_state = "coil"
		name = initial(name)

/obj/item/stack/cable_coil/proc/set_cable_color(var/selected_color, var/user)
	if(!selected_color)
		return

	var/final_color = possible_cable_coil_colours[selected_color]
	if(!final_color)
		final_color = possible_cable_coil_colours["Red"]
		selected_color = "red"
	color = final_color
	to_chat(user, "<span class='notice'>You change \the [src]'s color to [lowertext(selected_color)].</span>")

/obj/item/stack/cable_coil/proc/update_wclass()
	if(amount == 1)
		w_class = ITEMSIZE_TINY
	else
		w_class = ITEMSIZE_SMALL

/obj/item/stack/cable_coil/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/device/multitool))
		var/selected_type = tgui_input_list(usr, "Pick new colour.", "Cable Colour", possible_cable_coil_colours)
		set_cable_color(selected_type, usr)
		return
	return ..()

/obj/item/stack/cable_coil/verb/make_restraint()
	set name = "Make Cable Restraints"
	set category = "Object"
	var/mob/M = usr

	if(ishuman(M) && !M.restrained() && !M.stat && !M.paralysis && ! M.stunned)
		if(!istype(usr.loc,/turf)) return
		if(src.amount <= 14)
			to_chat(usr, "<span class='warning'>You need at least 15 lengths to make restraints!</span>")
			return
		var/obj/item/weapon/handcuffs/cable/B = new /obj/item/weapon/handcuffs/cable(usr.loc)
		B.color = color
		to_chat(usr, "<span class='notice'>You wind some cable together to make some restraints.</span>")
		src.use(15)
	else
		to_chat(usr, "<span class='notice'>You cannot do that.</span>")

/obj/item/stack/cable_coil/cyborg/verb/set_colour()
	set name = "Change Colour"
	set category = "Object"

	var/selected_type = tgui_input_list(usr, "Pick new colour.", "Cable Colour", possible_cable_coil_colours)
	set_cable_color(selected_type, usr)

// Items usable on a cable coil :
//   - Wirecutters : cut them duh !
//   - Cable coil : merge cables

/obj/item/stack/cable_coil/transfer_to(obj/item/stack/cable_coil/S)
	if(!istype(S))
		return
	..()

/obj/item/stack/cable_coil/use()
	. = ..()
	update_icon()
	return

/obj/item/stack/cable_coil/add()
	. = ..()
	update_icon()
	return

///////////////////////////////////////////////
// Cable laying procedures
//////////////////////////////////////////////

// called when cable_coil is clicked on a turf/simulated/floor
/obj/item/stack/cable_coil/proc/turf_place(turf/simulated/F, mob/user)
	if(!isturf(user.loc))
		return

	if(get_amount() < 1) // Out of cable
		to_chat(user, "There is no cable left.")
		return

	if(get_dist(F,user) > 1) // Too far
		to_chat(user, "You can't lay cable at a place that far away.")
		return

	if(!F.is_plating())		// Ff floor is intact, complain
		to_chat(user, "You can't lay cable there unless the floor tiles are removed.")
		return

	var/dirn
	if(user.loc == F)
		dirn = user.dir			// if laying on the tile we're on, lay in the direction we're facing
	else
		dirn = get_dir(F, user)

	var/end_dir = 0
	if(istype(F, /turf/simulated/open))
		if(!can_use(2))
			to_chat(user, "You don't have enough cable to do this!")
			return
		end_dir = DOWN

	for(var/obj/structure/cable/LC in F)
		if((LC.d1 == dirn && LC.d2 == end_dir ) || ( LC.d2 == dirn && LC.d1 == end_dir))
			to_chat(user, "<span class='warning'>There's already a cable at that position.</span>")
			return

	put_cable(F, user, end_dir, dirn)
	if(end_dir == DOWN)
		put_cable(GetBelow(F), user, UP, 0)
		to_chat(user, "You slide some cable downward.")

/obj/item/stack/cable_coil/proc/put_cable(turf/simulated/F, mob/user, d1, d2)
	if(!istype(F))
		return

	var/obj/structure/cable/C = new(F)
	C.cableColor(color)
	C.d1 = d1
	C.d2 = d2
	C.add_fingerprint(user)
	C.update_icon()

	//create a new powernet with the cable, if needed it will be merged later
	var/datum/powernet/PN = new()
	PN.add_cable(C)

	C.mergeConnectedNetworks(C.d1) //merge the powernets...
	C.mergeConnectedNetworks(C.d2) //...in the two new cable directions
	C.mergeConnectedNetworksOnTurf()

	if(C.d1 & (C.d1 - 1))// if the cable is layed diagonally, check the others 2 possible directions
		C.mergeDiagonalsNetworks(C.d1)

	if(C.d2 & (C.d2 - 1))// if the cable is layed diagonally, check the others 2 possible directions
		C.mergeDiagonalsNetworks(C.d2)

	use(1)
	if (C.shock(user, 50))
		if (prob(50)) //fail
			new/obj/item/stack/cable_coil(C.loc, 1, C.color)
			qdel(C)

// called when cable_coil is click on an installed obj/cable
// or click on a turf that already contains a "node" cable
/obj/item/stack/cable_coil/proc/cable_join(obj/structure/cable/C, mob/user)
	var/turf/U = user.loc
	if(!isturf(U))
		return

	var/turf/T = C.loc

	if(!isturf(T) || !T.is_plating())		// sanity checks, also stop use interacting with T-scanner revealed cable
		return

	if(get_dist(C, user) > 1)		// make sure it's close enough
		to_chat(user, "You can't lay cable at a place that far away.")
		return

	if(U == T) //if clicked on the turf we're standing on, try to put a cable in the direction we're facing
		turf_place(T,user)
		return

	var/dirn = get_dir(C, user)

	// one end of the clicked cable is pointing towards us
	if(C.d1 == dirn || C.d2 == dirn)
		if(!U.is_plating())						// can't place a cable if the floor is complete
			to_chat(user, "You can't lay cable there unless the floor tiles are removed.")
			return
		else
			// cable is pointing at us, we're standing on an open tile
			// so create a stub pointing at the clicked cable on our tile

			var/fdirn = turn(dirn, 180)		// the opposite direction

			for(var/obj/structure/cable/LC in U)		// check to make sure there's not a cable there already
				if(LC.d1 == fdirn || LC.d2 == fdirn)
					to_chat(user, "There's already a cable at that position.")
					return
			put_cable(U,user,0,fdirn)
			return

	// exisiting cable doesn't point at our position, so see if it's a stub
	else if(C.d1 == 0)
							// if so, make it a full cable pointing from it's old direction to our dirn
		var/nd1 = C.d2	// these will be the new directions
		var/nd2 = dirn


		if(nd1 > nd2)		// swap directions to match icons/states
			nd1 = dirn
			nd2 = C.d2


		for(var/obj/structure/cable/LC in T)		// check to make sure there's no matching cable
			if(LC == C)			// skip the cable we're interacting with
				continue
			if((LC.d1 == nd1 && LC.d2 == nd2) || (LC.d1 == nd2 && LC.d2 == nd1) )	// make sure no cable matches either direction
				to_chat(user, "There's already a cable at that position.")
				return


		C.cableColor(color)

		C.d1 = nd1
		C.d2 = nd2

		C.add_fingerprint()
		C.update_icon()


		C.mergeConnectedNetworks(C.d1) //merge the powernets...
		C.mergeConnectedNetworks(C.d2) //...in the two new cable directions
		C.mergeConnectedNetworksOnTurf()

		if(C.d1 & (C.d1 - 1))// if the cable is layed diagonally, check the others 2 possible directions
			C.mergeDiagonalsNetworks(C.d1)

		if(C.d2 & (C.d2 - 1))// if the cable is layed diagonally, check the others 2 possible directions
			C.mergeDiagonalsNetworks(C.d2)

		use(1)

		if (C.shock(user, 50))
			if (prob(50)) //fail
				new/obj/item/stack/cable_coil(C.loc, 2, C.color)
				qdel(C)
				return

		C.denode()// this call may have disconnected some cables that terminated on the centre of the turf, if so split the powernets.
		return

//////////////////////////////
// Misc.
/////////////////////////////

/obj/item/stack/cable_coil/cut
	item_state = "coil2"

/obj/item/stack/cable_coil/cut/New(loc)
	..()
	src.amount = rand(1,2)
	pixel_x = rand(-2,2)
	pixel_y = rand(-2,2)
	update_icon()
	update_wclass()

/obj/item/stack/cable_coil/yellow
	stacktype = /obj/item/stack/cable_coil
	color = COLOR_YELLOW

/obj/item/stack/cable_coil/blue
	stacktype = /obj/item/stack/cable_coil
	color = COLOR_BLUE

/obj/item/stack/cable_coil/green
	stacktype = /obj/item/stack/cable_coil
	color = COLOR_LIME

/obj/item/stack/cable_coil/pink
	stacktype = /obj/item/stack/cable_coil
	color = COLOR_PINK

/obj/item/stack/cable_coil/orange
	stacktype = /obj/item/stack/cable_coil
	color = COLOR_ORANGE

/obj/item/stack/cable_coil/cyan
	stacktype = /obj/item/stack/cable_coil
	color = COLOR_CYAN

/obj/item/stack/cable_coil/white
	stacktype = /obj/item/stack/cable_coil
	color = COLOR_WHITE

/obj/item/stack/cable_coil/silver
	stacktype = /obj/item/stack/cable_coil
	color = COLOR_SILVER

/obj/item/stack/cable_coil/gray
	stacktype = /obj/item/stack/cable_coil
	color = COLOR_GRAY

/obj/item/stack/cable_coil/black
	stacktype = /obj/item/stack/cable_coil
	color = COLOR_BLACK

/obj/item/stack/cable_coil/maroon
	stacktype = /obj/item/stack/cable_coil
	color = COLOR_MAROON

/obj/item/stack/cable_coil/olive
	stacktype = /obj/item/stack/cable_coil
	color = COLOR_OLIVE

/obj/item/stack/cable_coil/lime
	stacktype = /obj/item/stack/cable_coil
	color = COLOR_LIME

/obj/item/stack/cable_coil/teal
	stacktype = /obj/item/stack/cable_coil
	color = COLOR_TEAL

/obj/item/stack/cable_coil/navy
	stacktype = /obj/item/stack/cable_coil
	color = COLOR_NAVY

/obj/item/stack/cable_coil/purple
	stacktype = /obj/item/stack/cable_coil
	color = COLOR_PURPLE

/obj/item/stack/cable_coil/beige
	stacktype = /obj/item/stack/cable_coil
	color = COLOR_BEIGE

/obj/item/stack/cable_coil/brown
	stacktype = /obj/item/stack/cable_coil
	color = COLOR_BROWN

/obj/item/stack/cable_coil/random/New()
	stacktype = /obj/item/stack/cable_coil
	color = pick(COLOR_RED, COLOR_BLUE, COLOR_LIME, COLOR_WHITE, COLOR_PINK, COLOR_YELLOW, COLOR_CYAN, COLOR_SILVER, COLOR_GRAY, COLOR_BLACK, COLOR_MAROON, COLOR_OLIVE, COLOR_LIME, COLOR_TEAL, COLOR_NAVY, COLOR_PURPLE, COLOR_BEIGE, COLOR_BROWN)
	..()

/obj/item/stack/cable_coil/random_belt/New()
	stacktype = /obj/item/stack/cable_coil
	color = pick(COLOR_RED, COLOR_YELLOW, COLOR_ORANGE)
	amount = 30
	..()

//Endless alien cable coil


/datum/category_item/catalogue/anomalous/precursor_a/alien_wire
	name = "Precursor Alpha Object - Recursive Spool"
	desc = "Upon visual inspection, this merely appears to be a \
	spool for silver-colored cable. If one were to use this for \
	some time, however, it would become apparent that the cables \
	inside the spool appear to coil around the spool endlessly, \
	suggesting an infinite length of wire.\
	<br><br>\
	In reality, an infinite amount of something within a finite space \
	would likely not be able to exist. Instead, the spool likely has \
	some method of creating new wire as it is unspooled. How this is \
	accomplished without an apparent source of material would require \
	further study."
	value = CATALOGUER_REWARD_EASY

/obj/item/stack/cable_coil/alien
	name = "alien spool"
	desc = "A spool of cable. No matter how hard you try, you can never seem to get to the end."
	catalogue_data = list(/datum/category_item/catalogue/anomalous/precursor_a/alien_wire)
	icon = 'icons/obj/abductor.dmi'
	icon_state = "coil"
	amount = MAXCOIL
	max_amount = MAXCOIL
	color = COLOR_SILVER
	throwforce = 10
	w_class = ITEMSIZE_SMALL
	throw_speed = 2
	throw_range = 5
	matter = list(MAT_STEEL = 50, MAT_GLASS = 20)
	slot_flags = SLOT_BELT
	attack_verb = list("whipped", "lashed", "disciplined", "flogged")
	stacktype = null
	toolspeed = 0.25

/obj/item/stack/cable_coil/alien/New(loc, length = MAXCOIL, var/param_color = null)		//There has to be a better way to do this.
	if(embed_chance == -1)		//From /obj/item, don't want to do what the normal cable_coil does
		if(sharp)
			embed_chance = force/w_class
		else
			embed_chance = force/(w_class*3)
	update_icon()

/obj/item/stack/cable_coil/alien/update_icon()
	icon_state = initial(icon_state)

/obj/item/stack/cable_coil/alien/can_use(var/used)
	return 1

/obj/item/stack/cable_coil/alien/use()	//It's endless
	return 1

/obj/item/stack/cable_coil/alien/add()	//Still endless
	return 0

/obj/item/stack/cable_coil/alien/update_wclass()
	return 0

/obj/item/stack/cable_coil/alien/examine(mob/user)
	. = ..()

	if(Adjacent(user))
		. += "It doesn't seem to have a beginning, or an end."

/obj/item/stack/cable_coil/alien/attack_hand(mob/user as mob)
	if (user.get_inactive_hand() == src)
		var/N = tgui_input_number(usr, "How many units of wire do you want to take from [src]?  You can only take up to [amount] at a time.", "Split stacks", 1)
		if(N && N <= amount)
			var/obj/item/stack/cable_coil/CC = new/obj/item/stack/cable_coil(user.loc)
			CC.amount = N
			CC.update_icon()
			to_chat(user,"<font color='blue'>You take [N] units of wire from the [src].</font>")
			if (CC)
				user.put_in_hands(CC)
				src.add_fingerprint(user)
				CC.add_fingerprint(user)
				spawn(0)
					if (src && usr.machine==src)
						src.interact(usr)
		else
			return
	else
		..()
	return
