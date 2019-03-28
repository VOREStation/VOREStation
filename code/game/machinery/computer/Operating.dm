//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/machinery/computer/operating
	name = "patient monitoring console"
	density = 1
	anchored = 1.0
	icon_keyboard = "med_key"
	icon_screen = "crew"
	circuit = /obj/item/weapon/circuitboard/operating
	var/mob/living/carbon/human/victim = null
	var/obj/machinery/optable/table = null

/obj/machinery/computer/operating/New()
	..()
	for(var/direction in list(NORTH,EAST,SOUTH,WEST))
		table = locate(/obj/machinery/optable, get_step(src, direction))
		if (table)
			table.computer = src
			break

/obj/machinery/computer/operating/attack_ai(mob/user)
	add_fingerprint(user)
	if(stat & (BROKEN|NOPOWER))
		return
	ui_interact(user)


/obj/machinery/computer/operating/attack_hand(mob/user)
	add_fingerprint(user)
	if(stat & (BROKEN|NOPOWER))
		return
	ui_interact(user)

/**
 *  Display the NanoUI window for the operating computer.
 *
 *  See NanoUI documentation for details.
 */
/obj/machinery/computer/operating/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	user.set_machine(src)

	var/list/data = list()
	var/list/victim_ui = list()

	if(table && (table.check_victim()))
		victim = table.victim

		victim_ui = list("real_name" = victim.real_name, "age" = victim.age, "b_type" = victim.b_type, "health" = victim.health,
						"brute" = victim.getBruteLoss(), "tox" = src.victim.getToxLoss(), "burn" = victim.getFireLoss(), "oxy" = victim.getOxyLoss(),
						"stat" = (victim.stat ? "Non-Responsive" : "Stable"), "pulse" = victim.get_pulse(GETPULSE_TOOL))
	else
		victim = null
		victim_ui = null

	data["table"] = table
	data["victim"] = victim_ui

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "operating.tmpl", src.name, 380, 400)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(5)

/obj/machinery/computer/operating/Topic(href, href_list)
	if(..())
		return 1
	if ((usr.contents.Find(src) || (in_range(src, usr) && istype(src.loc, /turf))) || (istype(usr, /mob/living/silicon)))
		usr.set_machine(src)

	src.add_fingerprint(usr)
	SSnanoui.update_uis(src)