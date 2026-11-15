#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/circuitboard/message_monitor
	name = T_BOARD("message monitor console")
	build_path = /obj/machinery/computer/message_monitor

/obj/item/circuitboard/aiupload
	name = T_BOARD("AI upload console")
	build_path = /obj/machinery/computer/aiupload

/obj/item/circuitboard/borgupload
	name = T_BOARD("cyborg upload console")
	build_path = /obj/machinery/computer/borgupload

/obj/item/circuitboard/med_data
	name = T_BOARD("medical records console")
	build_path = /obj/machinery/computer/med_data

/obj/item/circuitboard/med_data/pcu
	name = T_BOARD("medical records PCU")
	build_path = /obj/machinery/computer/med_data/laptop

/obj/item/circuitboard/scan_consolenew
	name = T_BOARD("DNA machine")
	build_path = /obj/machinery/computer/scan_consolenew

/obj/item/circuitboard/communications
	name = T_BOARD("command and communications console")
	build_path = /obj/machinery/computer/communications

/obj/item/circuitboard/card
	name = T_BOARD("ID card modification console")
	build_path = /obj/machinery/computer/card

/obj/item/circuitboard/card/centcom
	name = T_BOARD("CentCom ID card modification console")
	build_path = /obj/machinery/computer/card/centcom
	hidden = TRUE // Mapper only centcom machine

/obj/item/circuitboard/teleporter
	name = T_BOARD("teleporter control console")
	build_path = /obj/machinery/computer/teleporter

/obj/item/circuitboard/secure_data
	name = T_BOARD("security records console")
	build_path = /obj/machinery/computer/secure_data

/obj/item/circuitboard/skills/pcu
	name = T_BOARD("employment records PCU")
	build_path = /obj/machinery/computer/skills // this needs to be fixed someday, a pcu subtype needs to be made, but it affects all maps...

/obj/item/circuitboard/stationalert_engineering
	name = T_BOARD("station alert console (engineering)")
	build_path = /obj/machinery/computer/station_alert

/obj/item/circuitboard/stationalert_security
	name = T_BOARD("station alert console (security)")
	build_path = /obj/machinery/computer/station_alert/security

/obj/item/circuitboard/stationalert_all
	name = T_BOARD("station alert console (all)")
	build_path = /obj/machinery/computer/station_alert/all

/obj/item/circuitboard/atmos_alert
	name = T_BOARD("atmospheric alert console")
	build_path = /obj/machinery/computer/atmos_alert

/obj/item/circuitboard/pod
	name = T_BOARD("massdriver control")
	build_path = /obj/machinery/computer/pod
	hidden = TRUE // todo - Make properly constructable in round

/obj/item/circuitboard/robotics
	name = T_BOARD("robotics control console")
	build_path = /obj/machinery/computer/robotics

/obj/item/circuitboard/drone_control
	name = T_BOARD("drone control console")
	build_path = /obj/machinery/computer/drone_control

/obj/item/circuitboard/cloning
	name = T_BOARD("cloning control console")
	build_path = /obj/machinery/computer/cloning

/obj/item/circuitboard/arcade/battle
	name = T_BOARD("battle arcade machine")
	build_path = /obj/machinery/computer/arcade/battle

/obj/item/circuitboard/arcade/orion_trail
	name = T_BOARD("orion trail arcade machine")
	build_path = /obj/machinery/computer/arcade/orion_trail

/obj/item/circuitboard/arcade/clawmachine
	name = T_BOARD("grab-a-gift arcade machine")
	build_path = /obj/machinery/computer/arcade/clawmachine

/obj/item/circuitboard/turbine_control
	name = T_BOARD("turbine control console")
	build_path = /obj/machinery/computer/turbine_computer
	hidden = TRUE // todo - Make properly constructable in round

/obj/item/circuitboard/solar_control
	name = T_BOARD("solar control console")
	build_path = /obj/machinery/power/solar_control

/obj/item/circuitboard/powermonitor
	name = T_BOARD("power monitoring console")
	build_path = /obj/machinery/computer/power_monitor

/obj/item/circuitboard/olddoor
	name = T_BOARD("DoorMex")
	build_path = /obj/machinery/computer/pod/old

/obj/item/circuitboard/syndicatedoor
	name = T_BOARD("ProComp Executive")
	build_path = /obj/machinery/computer/pod/old/syndicate

/obj/item/circuitboard/swfdoor
	name = T_BOARD("Magix")
	build_path = /obj/machinery/computer/pod/old/swf

/obj/item/circuitboard/prisoner
	name = T_BOARD("prisoner management console")
	build_path = /obj/machinery/computer/prisoner

/obj/item/circuitboard/mecha_control
	name = T_BOARD("exosuit control console")
	build_path = /obj/machinery/computer/mecha

/obj/item/circuitboard/rdservercontrol
	name = T_BOARD("R&D server control console")
	build_path = /obj/machinery/computer/rdservercontrol

/obj/item/circuitboard/crew
	name = T_BOARD("crew monitoring console")
	build_path = /obj/machinery/computer/crew

/obj/item/circuitboard/operating
	name = T_BOARD("patient monitoring console")
	build_path = /obj/machinery/computer/operating

/obj/item/circuitboard/mining_shuttle
	name = T_BOARD("mining shuttle console")
	build_path = /obj/machinery/computer/shuttle_control/mining
	hidden = TRUE // todo - Make properly constructable in round

/obj/item/circuitboard/engineering_shuttle
	name = T_BOARD("engineering shuttle console")
	build_path = /obj/machinery/computer/shuttle_control/engineering
	hidden = TRUE // todo - Make properly constructable in round

/obj/item/circuitboard/research_shuttle
	name = T_BOARD("research shuttle console")
	build_path = /obj/machinery/computer/shuttle_control/research
	hidden = TRUE // todo - Make properly constructable in round

/obj/item/circuitboard/aifixer
	name = T_BOARD("AI integrity restorer")
	build_path = /obj/machinery/computer/aifixer

/obj/item/circuitboard/helm
	name = T_BOARD("helm control console")
	build_path = /obj/machinery/computer/ship/helm
	hidden = TRUE // todo - Make properly constructable in round

/obj/item/circuitboard/engine
	name = T_BOARD("engine control console")
	build_path = /obj/machinery/computer/ship/engines
	hidden = TRUE // todo - Make properly constructable in round

/obj/item/circuitboard/nav
	name = T_BOARD("navigation console")
	build_path = /obj/machinery/computer/ship/navigation
	hidden = TRUE // todo - Make properly constructable in round

/obj/item/circuitboard/nav/tele
	name = T_BOARD("navigation telescreen")
	build_path = /obj/machinery/computer/ship/navigation/telescreen
	hidden = TRUE // todo - Make properly constructable in round

/obj/item/circuitboard/sensors
	name = T_BOARD("sensors console")
	build_path = /obj/machinery/computer/ship/sensors
	hidden = TRUE // todo - Make properly constructable in round

/obj/item/circuitboard/area_atmos
	name = T_BOARD("area air control console")
	build_path = /obj/machinery/computer/area_atmos

/obj/item/circuitboard/prison_shuttle
	name = T_BOARD("prison shuttle control console")
	build_path = /obj/machinery/computer/prison_shuttle
	hidden = TRUE // todo - Make properly constructable in round

/obj/item/circuitboard/rcon_console
	name = T_BOARD("RCON remote control console")
	build_path = /obj/machinery/computer/rcon

/obj/item/circuitboard/shutoff_monitor
	name = T_BOARD("automatic shutoff valve monitor")
	build_path = /obj/machinery/computer/shutoff_monitor

/obj/item/circuitboard/stockexchange
	name = T_BOARD("stock exchange console")
	build_path = /obj/machinery/computer/stockexchange
