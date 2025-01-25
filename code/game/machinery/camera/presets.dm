// PRESETS
/*
var/global/list/station_networks = list(
//										NETWORK_CAFE_DOCK,
										NETWORK_CARGO,
										NETWORK_CIVILIAN,
//										NETWORK_CIVILIAN_EAST,
//										NETWORK_CIVILIAN_WEST,
										NETWORK_COMMAND,
										NETWORK_ENGINE,
										NETWORK_ENGINEERING,
										NETWORK_ENGINEERING_OUTPOST,
										NETWORK_DEFAULT,
										NETWORK_MEDICAL,
										NETWORK_MINE,
										NETWORK_NORTHERN_STAR,
										NETWORK_RESEARCH,
										NETWORK_RESEARCH_OUTPOST,
										NETWORK_ROBOTS,
										NETWORK_PRISON,
										NETWORK_SECURITY,
										NETWORK_INTERROGATION
										)
*/
var/global/list/engineering_networks = list(
										NETWORK_ENGINE,
										NETWORK_ENGINEERING,
										//NETWORK_ENGINEERING_OUTPOST,	//VOREStation Edit: Tether has no Engineering Outpost,
										NETWORK_ALARM_ATMOS,
										NETWORK_ALARM_FIRE,
										NETWORK_ALARM_POWER)
/obj/machinery/camera/network/crescent
	network = list(NETWORK_CRESCENT)

/*
/obj/machinery/camera/network/cafe_dock
	network = list(NETWORK_CAFE_DOCK)
*/

/obj/machinery/camera/network/cargo
	network = list(NETWORK_CARGO)

/obj/machinery/camera/network/civilian
	network = list(NETWORK_CIVILIAN)

/obj/machinery/camera/network/circuits
	network = list(NETWORK_CIRCUITS)

/*
/obj/machinery/camera/network/civilian_east
	network = list(NETWORK_CIVILIAN_EAST)

/obj/machinery/camera/network/civilian_west
	network = list(NETWORK_CIVILIAN_WEST)
*/

/obj/machinery/camera/network/command
	network = list(NETWORK_COMMAND)

/obj/machinery/camera/network/engine
	network = list(NETWORK_ENGINE)

/obj/machinery/camera/network/engineering
	network = list(NETWORK_ENGINEERING)

/obj/machinery/camera/network/engineering_outpost
	network = list(NETWORK_ENGINEERING_OUTPOST)

/obj/machinery/camera/network/ert
	network = list(NETWORK_ERT)

/obj/machinery/camera/network/exodus
	network = list(NETWORK_DEFAULT)

/obj/machinery/camera/network/interrogation
	network = list(NETWORK_INTERROGATION)

/obj/machinery/camera/network/mining
	network = list(NETWORK_MINE)

/obj/machinery/camera/network/northern_star
	network = list(NETWORK_NORTHERN_STAR)

/obj/machinery/camera/network/prison
	network = list(NETWORK_PRISON)

/obj/machinery/camera/network/medbay
	network = list(NETWORK_MEDICAL)

/obj/machinery/camera/network/research
	network = list(NETWORK_RESEARCH)

/obj/machinery/camera/network/research_outpost
	network = list(NETWORK_RESEARCH_OUTPOST)

/obj/machinery/camera/network/security
	network = list(NETWORK_SECURITY)

/obj/machinery/camera/network/telecom
	network = list(NETWORK_TELECOM)

/obj/machinery/camera/network/exploration
	network = list(NETWORK_EXPLORATION)

/obj/machinery/camera/network/research/xenobio
	network = list(NETWORK_RESEARCH, NETWORK_XENOBIO)

/obj/machinery/camera/network/thunder
	network = list(NETWORK_THUNDER)
	invuln = 1
	always_visible = TRUE

// EMP

/obj/machinery/camera/emp_proof/New()
	..()
	upgradeEmpProof()

// X-RAY

/obj/machinery/camera/xray
	icon_state = "camera" // Thanks to Krutchen for the icons. // no xraycam in vr icons

/obj/machinery/camera/xray/command
	network = list(NETWORK_COMMAND)

/obj/machinery/camera/xray/security
	network = list(NETWORK_SECURITY)

/obj/machinery/camera/xray/medbay
	network = list(NETWORK_MEDICAL)

/obj/machinery/camera/xray/research
	network = list(NETWORK_RESEARCH)

/obj/machinery/camera/xray/New()
	..()
	upgradeXRay()

// MOTION

/obj/machinery/camera/motion/New()
	..()
	upgradeMotion()

/obj/machinery/camera/motion/engineering_outpost
	network = list(NETWORK_ENGINEERING_OUTPOST)

/obj/machinery/camera/motion/security
	network = list(NETWORK_SECURITY)

// ALL UPGRADES


/obj/machinery/camera/all/command
	network = list(NETWORK_COMMAND)

/obj/machinery/camera/all/New()
	..()
	upgradeEmpProof()
	upgradeXRay()
	upgradeMotion()

// AUTONAME
/obj/machinery/camera/autoname
	var/static/list/by_area

/obj/machinery/camera/autoname/Initialize()
	. = ..()
	var/area/A = get_area(src)
	if(!A)
		return .
	if(!by_area)
		by_area = list()
	if(!by_area[A.name])
		by_area[A.name] = list()
	var/list/my_area = by_area[A.name]
	my_area += src
	var/number = my_area.len

	c_tag = "[A.name] #[number]"

/obj/machinery/camera/autoname/Destroy()
	var/area/A = get_area(src)
	if(!A || !by_area || !by_area[A.name])
		return ..()
	var/list/my_area = by_area[A.name]
	my_area -= src
	return ..()

// CHECKS

/obj/machinery/camera/proc/isEmpProof()
	if(!assembly)
		return FALSE
	var/O = locate(/obj/item/stack/material/osmium) in assembly.upgrades
	return O

/obj/machinery/camera/proc/isXRay()
	if(!assembly)
		return FALSE
	var/obj/item/stock_parts/scanning_module/O = locate(/obj/item/stock_parts/scanning_module) in assembly.upgrades
	if (O && O.rating >= 2)
		return O
	return null

/obj/machinery/camera/proc/isMotion()
	if(!assembly)
		return FALSE
	var/O = locate(/obj/item/assembly/prox_sensor) in assembly.upgrades
	return O

// UPGRADE PROCS

/obj/machinery/camera/proc/upgradeEmpProof()
	assembly.upgrades.Add(new /obj/item/stack/material/osmium(assembly))
	setPowerUsage()
	update_coverage()

/obj/machinery/camera/proc/upgradeXRay()
	assembly.upgrades.Add(new /obj/item/stock_parts/scanning_module/adv(assembly))
	setPowerUsage()
	update_coverage()

/obj/machinery/camera/proc/upgradeMotion()
	if(!isturf(loc))
		return //nooooo
	assembly.upgrades.Add(new /obj/item/assembly/prox_sensor(assembly))
	setPowerUsage()
	START_MACHINE_PROCESSING(src)
	sense_proximity(callback = /atom/proc/HasProximity)
	update_coverage()

/obj/machinery/camera/proc/setPowerUsage()
	var/mult = 1
	if (isXRay())
		mult++
	if (isMotion())
		mult++
	update_active_power_usage(mult * initial(active_power_usage))
