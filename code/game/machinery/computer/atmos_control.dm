/obj/item/circuitboard/atmoscontrol
	name = "\improper Central Atmospherics Computer Circuitboard"
	build_path = /obj/machinery/computer/atmoscontrol

/obj/machinery/computer/atmoscontrol
	name = "\improper Central Atmospherics Computer"
	desc = "Control the station's atmospheric systems from afar! Certified atmospherics technicians only."
	icon_keyboard = "generic_key"
	icon_screen = "comm_logs"
	light_color = "#00b000"
<<<<<<< HEAD
	density = TRUE
	anchored = TRUE
	circuit = /obj/item/weapon/circuitboard/atmoscontrol
=======
	density = 1
	anchored = 1.0
	circuit = /obj/item/circuitboard/atmoscontrol
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	req_access = list(access_ce)
	var/list/monitored_alarm_ids = null
	var/datum/tgui_module/atmos_control/atmos_control

/obj/machinery/computer/atmoscontrol/New()
	..()

/obj/machinery/computer/atmoscontrol/laptop //[TO DO] Change name to PCU and update mapdata to include replacement computers
	name = "\improper Atmospherics PCU"
	desc = "A personal computer unit. It seems to have only the Atmosphereics Control program installed."
	icon_screen = "pcu_atmo"
	icon_state = "pcu_engi"
	icon_keyboard = "pcu_key"
	density = FALSE
	light_color = "#00cc00"
	density = 0

/obj/machinery/computer/atmoscontrol/attack_ai(var/mob/user as mob)
	tgui_interact(user)

/obj/machinery/computer/atmoscontrol/attack_hand(mob/user)
	if(..())
		return 1
	tgui_interact(user)

/obj/machinery/computer/atmoscontrol/emag_act(var/remaining_carges, var/mob/user)
	if(!emagged)
		user.visible_message("<span class='warning'>\The [user] does something \the [src], causing the screen to flash!</span>",\
			"<span class='warning'>You cause the screen to flash as you gain full control.</span>",\
			"You hear an electronic warble.")
		atmos_control.emagged = 1
		return 1

/obj/machinery/computer/atmoscontrol/tgui_interact(var/mob/user)
	if(!atmos_control)
		atmos_control = new(src, req_access, req_one_access, monitored_alarm_ids)
	atmos_control.tgui_interact(user)
