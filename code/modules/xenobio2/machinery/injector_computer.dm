/*
	This file contains:

	Manual Injector:
	Manually injects chemicals into a xenobiological creature from a linked machine.

*/
/obj/machinery/computer/xenobio2
	name = "injector control console"
	desc = "Used to control mechanized biological injectors."
	icon_keyboard = "med_key"
	icon_screen = "dna"
	light_color = "#315ab4"
	use_power = USE_POWER_IDLE
	idle_power_usage = 250
	active_power_usage = 500
	circuit = /obj/item/weapon/circuitboard/xenobio2computer
	var/obj/machinery/xenobio2/manualinjector/injector
	var/transfer_amount = 5 //VOREStation Edit - This is never set anywhere, and 1 is too slow (1 is the default in the transfer proc).
	var/active

/obj/machinery/computer/xenobio2/Destroy()
	injector.computer = null
	..()

/obj/machinery/computer/xenobio2/attack_hand(mob/user)
	if(..())
		return 1
	ui_interact(user)

/obj/machinery/computer/xenobio2/attackby(var/obj/item/W, var/mob/user)

	//Did you want to link it?
	if(istype(W, /obj/item/device/multitool))
		var/obj/item/device/multitool/P = W
		if(P.connectable)
			if(istype(P.connectable, /obj/machinery/xenobio2/manualinjector))
				var/obj/machinery/xenobio2/manualinjector/I = P.connectable
				injector = I
				I.computer = src
				to_chat(user, "<span class='warning'> You link the [src] to the [P.connectable]!</span>")
		else
			to_chat(user, "<span class='warning'> You store the [src] in the [P]'s buffer!</span>")
			P.connectable = src
		return

	..()

//Is missing a tgui interface?
/obj/machinery/computer/xenobio2/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	if(!user)
		return
	if(!injector)
		return

	var/list/data = list()

	data["activity"] = active
	data["beaker"] = injector.beaker
	if(injector.occupant)
		data["occupied"] = 1
	if(isxeno(injector.occupant))
		var/mob/living/simple_mob/xeno/X = injector.occupant
		data["compatible"] = 1
		data["instability"] = 100 * (X.mut_level / X.mut_max)
	else
		data["compatible"] = null

	if(injector.beaker)
		data["reagentAmount"] = injector.beaker.reagents.total_volume
		data["reagentMax"] = injector.beaker.reagents.maximum_volume
		data["reagentMin"] = 0
	else
		data["reagentAmount"] = null
		data["reagentMax"] = 1
		data["reagentMin"] = 0

	if(injector.occupant)
		data["occupantHealth"] = injector.occupant.health
		data["occupantHealthMax"] = injector.occupant.getMaxHealth()
	else
		data["occupantHealth"] = null
		data["occupantHealthMax"] = null

	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "xenobio_computer.tmpl", "Injector Control Console UI", 470, 450)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/computer/xenobio2/Topic(href, href_list)

	if(..())
		return 1

	if(href_list["inject_target"])
		active = 1
		spawn(5)
			injector.inject_reagents()
			active = 0
	if(href_list["eject_occupant"])
		injector.eject_xeno()

	if(href_list["eject_beaker"])
		injector.eject_beaker()

	usr.set_machine(src)
	src.add_fingerprint(usr)

/obj/item/weapon/circuitboard/xenobio2computer
	name = T_BOARD("injector control console")
	build_path = /obj/machinery/computer/xenobio2
	origin_tech = list()	//To be filled
