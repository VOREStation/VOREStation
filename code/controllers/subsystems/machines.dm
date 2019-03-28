#define SSMACHINES_PIPENETS      1
#define SSMACHINES_MACHINERY     2
#define SSMACHINES_POWERNETS     3
#define SSMACHINES_POWER_OBJECTS 4

//
// SSmachines subsystem - Processing machines, pipenets, and powernets!
//
// Implementation Plan:
// PHASE 1 - Add subsystem using the existing global list vars
// PHASE 2 - Move the global list vars into the subsystem.

SUBSYSTEM_DEF(machines)
	name = "Machines"
	priority = FIRE_PRIORITY_MACHINES
	init_order = INIT_ORDER_MACHINES
	flags = SS_KEEP_TIMING
	runlevels = RUNLEVEL_GAME|RUNLEVEL_POSTGAME

	var/current_step = SSMACHINES_PIPENETS

	var/cost_pipenets      = 0
	var/cost_machinery     = 0
	var/cost_powernets     = 0
	var/cost_power_objects = 0

	// TODO - PHASE 2 - Switch these from globals to instance vars
	// var/list/pipenets      = list()
	// var/list/machinery     = list()
	// var/list/powernets     = list()
	// var/list/power_objects = list()

	var/list/current_run = list()

/datum/controller/subsystem/machines/Initialize(timeofday)
	makepowernets()
	admin_notice("<span class='danger'>Initializing atmos machinery.</span>", R_DEBUG)
	setup_atmos_machinery(global.machines)
	fire()
	..()

/datum/controller/subsystem/machines/fire(resumed = 0)
	var/timer = TICK_USAGE

	INTERNAL_PROCESS_STEP(SSMACHINES_POWER_OBJECTS,FALSE,process_power_objects,cost_power_objects,SSMACHINES_PIPENETS) // Higher priority, damnit
	INTERNAL_PROCESS_STEP(SSMACHINES_PIPENETS,TRUE,process_pipenets,cost_pipenets,SSMACHINES_MACHINERY)
	INTERNAL_PROCESS_STEP(SSMACHINES_MACHINERY,FALSE,process_machinery,cost_machinery,SSMACHINES_POWERNETS)
	INTERNAL_PROCESS_STEP(SSMACHINES_POWERNETS,FALSE,process_powernets,cost_powernets,SSMACHINES_POWER_OBJECTS)

// rebuild all power networks from scratch - only called at world creation or by the admin verb
// The above is a lie. Turbolifts also call this proc.
/datum/controller/subsystem/machines/proc/makepowernets()
	// TODO - check to not run while in the middle of a tick!
	for(var/datum/powernet/PN in powernets)
		qdel(PN)
	powernets.Cut()
	setup_powernets_for_cables(cable_list)

/datum/controller/subsystem/machines/proc/setup_powernets_for_cables(list/cables)
	for(var/obj/structure/cable/PC in cables)
		if(!PC.powernet)
			var/datum/powernet/NewPN = new()
			NewPN.add_cable(PC)
			propagate_network(PC,PC.powernet)

/datum/controller/subsystem/machines/proc/setup_atmos_machinery(list/atmos_machines)
	for(var/obj/machinery/atmospherics/machine in atmos_machines)
		machine.atmos_init()
		CHECK_TICK

	for(var/obj/machinery/atmospherics/machine in atmos_machines)
		machine.build_network()
		CHECK_TICK

	for(var/obj/machinery/atmospherics/unary/U in atmos_machines)
		if(istype(U, /obj/machinery/atmospherics/unary/vent_pump))
			var/obj/machinery/atmospherics/unary/vent_pump/T = U
			T.broadcast_status()
		else if(istype(U, /obj/machinery/atmospherics/unary/vent_scrubber))
			var/obj/machinery/atmospherics/unary/vent_scrubber/T = U
			T.broadcast_status()
		CHECK_TICK

/datum/controller/subsystem/machines/stat_entry()
	var/msg = list()
	msg += "C:{"
	msg += "PI:[round(cost_pipenets,1)]|"
	msg += "MC:[round(cost_machinery,1)]|"
	msg += "PN:[round(cost_powernets,1)]|"
	msg += "PO:[round(cost_power_objects,1)]"
	msg += "} "
	msg += "PI:[global.pipe_networks.len]|"
	msg += "MC:[global.processing_machines.len]|"
	msg += "PN:[global.powernets.len]|"
	msg += "PO:[global.processing_power_items.len]|"
	msg += "MC/MS:[round((cost ? global.processing_machines.len/cost_machinery : 0),0.1)]"
	..(jointext(msg, null))

/datum/controller/subsystem/machines/proc/process_pipenets(resumed = 0)
	if (!resumed)
		src.current_run = global.pipe_networks.Copy()
	//cache for sanic speed (lists are references anyways)
	var/list/current_run = src.current_run
	while(current_run.len)
		var/datum/pipe_network/PN = current_run[current_run.len]
		current_run.len--
		if(istype(PN) && !QDELETED(PN))
			PN.process(wait)
		else
			global.pipe_networks.Remove(PN)
			if(!QDELETED(PN))
				DISABLE_BITFIELD(PN.datum_flags, DF_ISPROCESSING)
		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/machines/proc/process_machinery(resumed = 0)
	if (!resumed)
		src.current_run = global.processing_machines.Copy()

	var/list/current_run = src.current_run
	while(current_run.len)
		var/obj/machinery/M = current_run[current_run.len]
		current_run.len--
		if(istype(M) && !QDELETED(M) && !(M.process(wait) == PROCESS_KILL))
			if(M.use_power)
				M.auto_use_power()
		else
			global.processing_machines.Remove(M)
			if(!QDELETED(M))
				DISABLE_BITFIELD(M.datum_flags, DF_ISPROCESSING)
		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/machines/proc/process_powernets(resumed = 0)
	if (!resumed)
		src.current_run = global.powernets.Copy()

	var/list/current_run = src.current_run
	while(current_run.len)
		var/datum/powernet/PN = current_run[current_run.len]
		current_run.len--
		if(istype(PN) && !QDELETED(PN))
			PN.reset(wait)
		else
			global.powernets.Remove(PN)
			if(!QDELETED(PN))
				DISABLE_BITFIELD(PN.datum_flags, DF_ISPROCESSING)
		if(MC_TICK_CHECK)
			return

// Actually only processes power DRAIN objects.
// Currently only used by powersinks. These items get priority processed before machinery
/datum/controller/subsystem/machines/proc/process_power_objects(resumed = 0)
	if (!resumed)
		src.current_run = global.processing_power_items.Copy()

	var/list/current_run = src.current_run
	while(current_run.len)
		var/obj/item/I = current_run[current_run.len]
		current_run.len--
		if(!I.pwr_drain(wait)) // 0 = Process Kill, remove from processing list.
			global.processing_power_items.Remove(I)
			DISABLE_BITFIELD(I.datum_flags, DF_ISPROCESSING)
		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/machines/Recover()
	// TODO - PHASE 2
	// if (istype(SSmachines.pipenets))
	// 	pipenets = SSmachines.pipenets
	// if (istype(SSmachines.machinery))
	// 	machinery = SSmachines.machinery
	// if (istype(SSmachines.powernets))
	// 	powernets = SSmachines.powernets
	// if (istype(SSmachines.power_objects))
	// 	power_objects = SSmachines.power_objects

#undef SSMACHINES_PIPENETS
#undef SSMACHINES_MACHINERY
#undef SSMACHINES_POWER
#undef SSMACHINES_POWER_OBJECTS
