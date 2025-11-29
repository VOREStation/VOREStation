#define SERVER_NOMINAL_TEXT "Nominal"

/obj/machinery/rnd/server
	name = "\improper R&D Server"
	desc = "A computer system running a deep neural network that processes arbitrary information to produce data useable in the development of new technologies. In layman's terms, it makes research points."
	icon = 'icons/obj/machines/research_vr.dmi'
	icon_state = "RD-server-on"
	var/base_icon_state = "RD-server"
	circuit = /obj/item/circuitboard/machine/rdserver
	req_access = list(ACCESS_RD)

	/// if TRUE, we are currently operational and giving out research points.
	var/working = TRUE
	/// if TRUE, someone manually disabled us via console.
	var/research_disabled = FALSE

/obj/machinery/rnd/server/Initialize(mapload)
	. = ..()
	//servers handle techwebs differently as we are expected to be there to connect
	//every other machinery on-station.
	if(!stored_research)
		var/datum/techweb/science_web = locate(/datum/techweb/science) in SSresearch.techwebs
		connect_techweb(science_web)
	stored_research.techweb_servers |= src
	name += " [num2hex(rand(1,65535), -1)]" //gives us a random four-digit hex number as part of the name. Y'know, for fluff.

/obj/machinery/rnd/server/Destroy()
	if(stored_research)
		stored_research.techweb_servers -= src
	return ..()

/obj/machinery/rnd/server/update_icon()
	if(stat & NOPOWER)
		icon_state = "[base_icon_state]-off"
	else
		// "working" will cover EMP'd, disabled, or just broken
		icon_state = "[base_icon_state]-[working ? "on" : "halt"]"
	return ..()

/obj/machinery/rnd/server/power_change()
	. = ..()
	refresh_working()

/// Checks if we should be working or not, and updates accordingly.
/obj/machinery/rnd/server/proc/refresh_working()
	if(stat & (NOPOWER|EMPED) || research_disabled)
		working = FALSE
	else
		working = TRUE

	// update_current_power_usage()
	update_icon()

/obj/machinery/rnd/server/emp_act(severity, recursive)
	. = ..()
	stat |= EMPED
	addtimer(CALLBACK(src, PROC_REF(fix_emp)), 60 SECONDS)
	refresh_working()

/// Callback to un-emp the server afetr some time.
/obj/machinery/rnd/server/proc/fix_emp()
	stat &= ~EMPED
	refresh_working()

/// Toggles whether or not researched_disabled is, yknow, disabled
/obj/machinery/rnd/server/proc/toggle_disable(mob/user)
	research_disabled = !research_disabled
	log_game("[key_name(user)] [research_disabled ? "shut off" : "turned on"] [src]")
	refresh_working()

/// Gets status text based on this server's status for the computer.
/obj/machinery/rnd/server/proc/get_status_text()
	if(stat & EMPED)
		return "O&F@I*$ - R3*&O$T R@U!R%D"
	else if(stat & NOPOWER)
		return "Offline - Server Unpowered"
	else if(research_disabled)
		return "Offline - Server Control Disabled"
	else if(!working)
		// If, for some reason, working is FALSE even though we're not emp'd or powerless,
		// We need something to update our working state - such as rebooting the server
		return "Offline - Reboot Required"

	return SERVER_NOMINAL_TEXT

/// Master R&D server. As long as this still exists and still holds the HDD for the theft objective, research points generate at normal speed. Destroy it or an antag steals the HDD? Half research speed.
/obj/machinery/rnd/server/master
	// max_integrity = 1800 //takes roughly ~15s longer to break then full deconstruction.
	circuit = null
	// var/obj/item/computer_disk/hdd_theft/source_code_hdd
	// var/deconstruction_state = HDD_PANEL_CLOSED
	// var/front_panel_screws = 4
	// var/hdd_wires = 6

/obj/machinery/rnd/server/master/Initialize(mapload)
	. = ..()
	name = "\improper Master " + name
	add_overlay("RD-server-objective-stripes")

/obj/machinery/rnd/server/master/attackby(obj/item/W, mob/user, attack_modifier, click_parameters)
	// No doing anything to the master server
	return

#undef SERVER_NOMINAL_TEXT
