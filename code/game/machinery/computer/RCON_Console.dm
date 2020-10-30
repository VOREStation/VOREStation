// RCON REMOTE CONTROL CONSOLE
//
// Last Change 1.1.2015 by Atlantis
//
// Allows remote operation of electrical systems on station (SMESs and Breaker Boxes)

/obj/machinery/computer/rcon
	name = "\improper RCON console"
	desc = "Console used to remotely control electrical machinery on the station."
	icon_keyboard = "power_key"
	icon_screen = "ai-fixer"
	light_color = "#a97faa"
	circuit = /obj/item/weapon/circuitboard/rcon_console
	req_one_access = list(access_engine)
	var/current_tag = null
	var/datum/tgui_module/rcon/rcon

/obj/machinery/computer/rcon/New()
	..()
	rcon = new(src)

/obj/machinery/computer/rcon/Destroy()
	qdel(rcon)
	rcon = null
	..()

// Proc: attack_hand()
// Parameters: 1 (user - Person which clicked this computer)
// Description: Opens UI of this machine.
/obj/machinery/computer/rcon/attack_hand(var/mob/user as mob)
	..()
	tgui_interact(user)

// Proc: ui_interact()
// Description: Uses dark magic (TGUI) to render this machine's UI
/obj/machinery/computer/rcon/tgui_interact(mob/user, datum/tgui/ui)
	rcon.tgui_interact(user, ui)

/obj/machinery/computer/rcon/update_icon()
	..()
	if(!(stat & (NOPOWER|BROKEN)))
		add_overlay("ai-fixer-empty")
	else
		cut_overlay("ai-fixer-empty")
