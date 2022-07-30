// BUILDABLE SMES(Superconducting Magnetic Energy Storage) UNIT
//
// Last Change 2.8.2018 by Neerti. Also signing this is still dumb.
//
// This is subtype of SMES that should be normally used. It can be constructed, deconstructed and hacked.
// It also supports RCON System which allows you to operate it remotely, if properly set.

//MAGNETIC COILS - These things actually store and transmit power within the SMES. Different types have different
/obj/item/smes_coil
	name = "superconductive magnetic coil"
	desc = "The standard superconductive magnetic coil, with average capacity and I/O rating."
	icon = 'icons/obj/stock_parts.dmi'
	icon_state = "smes_coil"			// Just few icons patched together. If someone wants to make better icon, feel free to do so!
	w_class = ITEMSIZE_LARGE 						// It's LARGE (backpack size)
	var/ChargeCapacity = 6000000		// 100 kWh
	var/IOCapacity = 250000				// 250 kW

// 20% Charge Capacity, 60% I/O Capacity. Used for substation/outpost SMESs.
/obj/item/smes_coil/weak
	name = "basic superconductive magnetic coil"
	desc = "A cheaper model of superconductive magnetic coil. Its capacity and I/O rating are considerably lower."
	icon_state = "smes_coil_weak"
	ChargeCapacity = 1200000			// 20 kWh
	IOCapacity = 150000					// 150 kW

// 1000% Charge Capacity, 20% I/O Capacity
/obj/item/smes_coil/super_capacity
	name = "superconductive capacitance coil"
	desc = "A specialised type of superconductive magnetic coil with a significantly stronger containment field, allowing for larger power storage. Its IO rating is much lower, however."
	icon_state = "smes_coil_capacitance"
	ChargeCapacity = 60000000			// 1000 kWh
	IOCapacity = 50000					// 50 kW

// 10% Charge Capacity, 400% I/O Capacity. Technically turns SMES into large super capacitor.Ideal for shields.
/obj/item/smes_coil/super_io
	name = "superconductive transmission coil"
	desc = "A specialised type of superconductive magnetic coil with reduced storage capabilites but vastly improved power transmission capabilities, making it useful in systems which require large throughput."
	icon_state = "smes_coil_transmission"
	ChargeCapacity = 600000				// 10 kWh
	IOCapacity = 1000000				// 1000 kW


// SMES SUBTYPES - THESE ARE MAPPED IN AND CONTAIN DIFFERENT TYPES OF COILS

// These are used on individual outposts as backup should power line be cut, or engineering outpost lost power.
// 1M Charge, 150K I/O
/obj/machinery/power/smes/buildable/outpost_substation/Initialize()
	. = ..()
	component_parts += new /obj/item/smes_coil/weak(src)
	recalc_coils()

// This one is pre-installed on engineering shuttle. Allows rapid charging/discharging for easier transport of power to outpost
// 11M Charge, 2.5M I/O
/obj/machinery/power/smes/buildable/power_shuttle/Initialize()
	. = ..()
	component_parts += new /obj/item/smes_coil/super_io(src)
	component_parts += new /obj/item/smes_coil/super_io(src)
	component_parts += new /obj/item/smes_coil(src)
	recalc_coils()

// Pre-installed and pre-charged SMES hidden from the station, for use in submaps.
/obj/machinery/power/smes/buildable/point_of_interest/Initialize()
	. = ..()
	charge = capacity // Should be enough for an individual POI.
	RCon = FALSE
	input_level = input_level_max
	output_level = output_level_max
	input_attempt = TRUE



// END SMES SUBTYPES

// SMES itself
/obj/machinery/power/smes/buildable
	var/max_coils = 6 			//30M capacity, 1.5MW input/output when fully upgraded /w default coils
	var/cur_coils = 1 			// Current amount of installed coils
	var/safeties_enabled = 1 	// If 0 modifications can be done without discharging the SMES, at risk of critical failure.
	var/failing = 0 			// If 1 critical failure has occured and SMES explosion is imminent.
	var/datum/wires/smes/wires
	var/grounding = 1			// Cut to quickly discharge, at cost of "minor" electrical issues in output powernet.
	var/RCon = 1				// Cut to disable AI and remote control.
	var/RCon_tag = "NO_TAG"		// RCON tag, change to show it on SMES Remote control console.
	charge = 0
	should_be_mapped = 1

/obj/machinery/power/smes/buildable/Destroy()
	qdel(wires)
	wires = null
	for(var/datum/tgui_module/rcon/R in world)
		R.FindDevices()
	return ..()

// Proc: process()
// Parameters: None
// Description: Uses parent process, but if grounding wire is cut causes sparks to fly around.
// This also causes the SMES to quickly discharge, and has small chance of breaking lights connected to APCs in the powernet.
/obj/machinery/power/smes/buildable/process()
	if(!grounding && (Percentage() > 5))
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(5, 1, src)
		s.start()
		charge -= (output_level_max * SMESRATE)
		if(prob(1)) // Small chance of overload occuring since grounding is disabled.
			apcs_overload(0,10)

	..()

// Proc: attack_ai()
// Parameters: None
// Description: AI requires the RCON wire to be intact to operate the SMES.
/obj/machinery/power/smes/buildable/attack_ai()
	if(RCon)
		..()
	else // RCON wire cut
		to_chat(usr, "<span class='warning'>Connection error: Destination Unreachable.</span>")

	// Cyborgs standing next to the SMES can play with the wiring.
	if(istype(usr, /mob/living/silicon/robot) && Adjacent(usr) && panel_open)
		wires.Interact(usr)

// Proc: New()
// Parameters: None
// Description: Adds standard components for this SMES, and forces recalculation of properties.
/obj/machinery/power/smes/buildable/Initialize(var/install_coils = 1)
	. = ..()
	component_parts = list()
	component_parts += new /obj/item/stack/cable_coil(src,30)
	wires = new /datum/wires/smes(src)

	// Allows for mapped-in SMESs with larger capacity/IO
	if(install_coils)
		for(var/i = 1, i <= cur_coils, i++)
			component_parts += new /obj/item/smes_coil(src)
		recalc_coils()

// Proc: attack_hand()
// Parameters: None
// Description: Opens the UI as usual, and if cover is removed opens the wiring panel.
/obj/machinery/power/smes/buildable/attack_hand()
	..()
	if(panel_open)
		wires.Interact(usr)

/obj/machinery/power/smes/buildable/RefreshParts()
	recalc_coils()

// Proc: recalc_coils()
// Parameters: None
// Description: Updates properties (IO, capacity, etc.) of this SMES by checking internal components.
/obj/machinery/power/smes/buildable/proc/recalc_coils()
	if ((cur_coils <= max_coils) && (cur_coils >= 1))
		capacity = 0
		input_level_max = 0
		output_level_max = 0
		for(var/obj/item/smes_coil/C in component_parts)
			capacity += C.ChargeCapacity
			input_level_max += C.IOCapacity
			output_level_max += C.IOCapacity
		charge = between(0, charge, capacity)
		return 1
	return 0

// Proc: total_system_failure()
// Parameters: 2 (intensity - how strong the failure is, user - person which caused the failure)
// Description: Checks the sensors for alerts. If change (alerts cleared or detected) occurs, calls for icon update.
/obj/machinery/power/smes/buildable/proc/total_system_failure(var/intensity = 0, var/mob/user)
	// SMESs store very large amount of power. If someone screws up (ie: Disables safeties and attempts to modify the SMES) very bad things happen.
	// Bad things are based on charge percentage.
	// Possible effects:
	// Sparks - Lets out few sparks, mostly fire hazard if phoron present. Otherwise purely aesthetic.
	// Shock - Depending on intensity harms the user. Insultated Gloves protect against weaker shocks, but strong shock bypasses them.
	// EMP Pulse - Lets out EMP pulse discharge which screws up nearby electronics.
	// Light Overload - X% chance to overload each lighting circuit in connected powernet. APC based.
	// APC Failure - X% chance to destroy APC causing very weak explosion too. Won't cause hull breach or serious harm.
	// SMES Explosion - X% chance to destroy the SMES, in moderate explosion. May cause small hull breach.

	if (!intensity)
		return

	var/mob/living/carbon/human/h_user = user
	if (!istype(h_user))
		return


	// Preparations
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	// Check if user has protected gloves.
	var/user_protected = 0
	if(h_user.gloves)
		var/obj/item/clothing/gloves/G = h_user.gloves
		if(G.siemens_coefficient == 0)
			user_protected = 1
	log_game("SMES FAILURE: <b>[src.x]X [src.y]Y [src.z]Z</b> User: [usr.ckey], Intensity: [intensity]/100")
	message_admins("SMES FAILURE: <b>[src.x]X [src.y]Y [src.z]Z</b> User: [usr.ckey], Intensity: [intensity]/100 - <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>")

	var/used_hand = h_user.hand?"l_hand":"r_hand"

	switch (intensity)
		if (0 to 15)
			// Small overcharge
			// Sparks, Weak shock
			s.set_up(2, 1, src)
			if (user_protected && prob(80))
				to_chat(h_user, "A small electrical arc almost burns your hand. Luckily you had your gloves on!")
			else
				to_chat(h_user, "A small electrical arc sparks and burns your hand as you touch the [src]!")
				h_user.adjustFireLossByPart(rand(5,10), used_hand)
				h_user.Weaken(2)

		if (16 to 35)
			// Medium overcharge
			// Sparks, Medium shock, Weak EMP
			s.set_up(4,1,src)
			if (user_protected && prob(25))
				to_chat(h_user, "A medium electrical arc sparks and almost burns your hand. Luckily you had your gloves on!")
			else
				to_chat(h_user, "A medium electrical arc sparks as you touch the [src], severely burning your hand!")
				h_user.adjustFireLossByPart(rand(10,25), used_hand)
				h_user.Weaken(5)
			spawn()
				empulse(get_turf(src), 1, 2, 3, 4)

		if (36 to 60)
			// Strong overcharge
			// Sparks, Strong shock, Strong EMP, 10% light overload. 1% APC failure
			s.set_up(7,1,src)
			if (user_protected)
				to_chat(h_user, "A strong electrical arc sparks between you and [src], ignoring your gloves and burning your hand!")
				h_user.adjustFireLossByPart(rand(25,60), used_hand)
				h_user.Weaken(8)
			else
				to_chat(h_user, "A strong electrical arc sparks between you and [src], knocking you out for a while!")
				h_user.electrocute_act(rand(35,75), src, def_zone = BP_TORSO)
			spawn()
				empulse(get_turf(src), 6, 8, 12, 16)
			apcs_overload(1, 10)
			ping("Caution. Output regulator malfunction. Uncontrolled discharge detected.")

		if (61 to INFINITY)
			// Massive overcharge
			// Sparks, Near - instantkill shock, Strong EMP, 25% light overload, 5% APC failure. 50% of SMES explosion. This is bad.
			s.set_up(10,1,src)
			to_chat(h_user, "A massive electrical arc sparks between you and [src]. The last thing you can think about is \"Oh shit...\"")
			// Remember, we have few gigajoules of electricity here.. Turn them into crispy toast.
			h_user.electrocute_act(rand(150,195), src, def_zone = BP_TORSO)
			spawn()
				empulse(get_turf(src), 32, 64)
			apcs_overload(5, 25)
			ping("Caution. Output regulator malfunction. Significant uncontrolled discharge detected.")

			if (prob(50))
				// Added admin-notifications so they can stop it when griffed.
				log_game("SMES explosion imminent.")
				message_admins("SMES explosion imminent.")
				ping("DANGER! Magnetic containment field unstable! Containment field failure imminent!")
				failing = 1
				update_icon()
				// 30 - 60 seconds and then BAM!
				spawn(rand(300,600))
					if(!failing) // Admin can manually set this var back to 0 to stop overload, for use when griffed.
						update_icon()
						ping("Magnetic containment stabilised.")
						return
					ping("DANGER! Magnetic containment field failure in 3 ... 2 ... 1 ...")
					explosion(get_turf(src),1,2,4,8)
					// Not sure if this is necessary, but just in case the SMES *somehow* survived..
					qdel(src)

	s.start()
	charge = 0



// Proc: apcs_overload()
// Parameters: 2 (failure_chance - chance to actually break the APC, overload_chance - Chance of breaking lights)
// Description: Damages output powernet by power surge. Destroys few APCs and lights, depending on parameters.
/obj/machinery/power/smes/buildable/proc/apcs_overload(var/failure_chance, var/overload_chance)
	if (!powernet)
		return

	for(var/obj/machinery/power/terminal/T in powernet.nodes)
		if(istype(T.master, /obj/machinery/power/apc))
			var/obj/machinery/power/apc/A = T.master
			if (prob(overload_chance))
				A.overload_lighting()
			if (prob(failure_chance))
				A.set_broken()

// Proc: update_icon()
// Parameters: None
// Description: Allows us to use special icon overlay for critical SMESs
/obj/machinery/power/smes/buildable/update_icon()
	if (failing)
		cut_overlays()
		add_overlay("smes-crit")
	else
		..()

// Proc: attackby()
// Parameters: 2 (W - object that was used on this machine, user - person which used the object)
// Description: Handles tool interaction. Allows deconstruction/upgrading/fixing.
/obj/machinery/power/smes/buildable/attackby(var/obj/item/W as obj, var/mob/user as mob)
	// No more disassembling of overloaded SMESs. You broke it, now enjoy the consequences.
	if (failing)
		to_chat(user, "<span class='warning'>The [src]'s indicator lights are flashing wildly. It seems to be overloaded! Touching it now is probably not a good idea.</span>")
		return
	// If parent returned 1:
	// - Hatch is open, so we can modify the SMES
	// - No action was taken in parent function (terminal de/construction atm).
	if (..())

		// Multitool - change RCON tag
		if(istype(W, /obj/item/multitool))
			var/newtag = tgui_input_text(user, "Enter new RCON tag. Use \"NO_TAG\" to disable RCON or leave empty to cancel.", "SMES RCON system")
			if(newtag)
				RCon_tag = newtag
				to_chat(user, "<span class='notice'>You changed the RCON tag to: [newtag]</span>")
			return
		// Charged above 1% and safeties are enabled.
		if((charge > (capacity/100)) && safeties_enabled)
			to_chat(user, "<span class='warning'>The safety circuit of [src] is preventing modifications while there is charge stored!</span>")
			return

		if (output_attempt || input_attempt)
			to_chat(user, "<span class='warning'>Turn off the [src] first!</span>")
			return

		// Probability of failure if safety circuit is disabled (in %)
		var/failure_probability = round((charge / capacity) * 100)

		// If failure probability is below 5% it's usually safe to do modifications
		if (failure_probability < 5)
			failure_probability = 0

		// Crowbar - Disassemble the SMES.
		if(W.is_crowbar())
			if (terminals.len)
				to_chat(user, "<span class='warning'>You have to disassemble the terminal first!</span>")
				return

			playsound(src, W.usesound, 50, 1)
			to_chat(user, "<span class='warning'>You begin to disassemble the [src]!</span>")
			if (do_after(usr, (100 * cur_coils) * W.toolspeed)) // More coils = takes longer to disassemble. It's complex so largest one with 5 coils will take 50s with a normal crowbar

				if (failure_probability && prob(failure_probability))
					total_system_failure(failure_probability, user)
					return

				to_chat(user, "<font color='red'>You have disassembled the SMES cell!</font>")
				dismantle()
				return

		// Superconducting Magnetic Coil - Upgrade the SMES
		else if(istype(W, /obj/item/smes_coil))
			if (cur_coils < max_coils)

				if (failure_probability && prob(failure_probability))
					total_system_failure(failure_probability, user)
					return

				to_chat(user, "You install the coil into the SMES unit!")
				user.drop_item()
				cur_coils ++
				component_parts += W
				W.loc = src
				recalc_coils()
			else
				to_chat(user, "<font color='red'>You can't insert more coils into this SMES unit!</font>")
