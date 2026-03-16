#define SSMACHINES_PIPENETS      1
#define SSMACHINES_MACHINERY     2
#define SSMACHINES_POWERNETS     3
#define SSMACHINES_POWER_OBJECTS 4

//
// SSmachines subsystem - Processing machines, pipenets, and powernets!
//

SUBSYSTEM_DEF(machines)
	name = "Machines"
	dependencies = list(
		/datum/controller/subsystem/points_of_interest
	)
	priority = FIRE_PRIORITY_MACHINES
	flags = SS_KEEP_TIMING
	runlevels = RUNLEVEL_GAME|RUNLEVEL_POSTGAME

	var/current_step = SSMACHINES_PIPENETS

	var/cost_pipenets      = 0
	var/cost_machinery     = 0
	var/cost_powernets     = 0
	var/cost_power_objects = 0

	var/list/current_run = list()

	var/list/all_machines = list()
	var/list/hibernating_vents = list()

	var/list/networks = list()
	var/list/processing_machines = list()
	var/list/powernets = list()
	var/list/powerobjs = list()

	// Wait to rebuild powernets
	VAR_PRIVATE/defering_powernets = FALSE

/datum/controller/subsystem/machines/Initialize()
	makepowernets()
	admin_notice(span_danger("Initializing atmos machinery."), R_DEBUG)
	setup_atmos_machinery(all_machines)
	fire()
	return SS_INIT_SUCCESS

/datum/controller/subsystem/machines/fire(resumed = 0)
	var/timer = TICK_USAGE

	INTERNAL_PROCESS_STEP(SSMACHINES_POWER_OBJECTS,FALSE,process_power_objects,cost_power_objects,SSMACHINES_PIPENETS) // Higher priority, damnit
	INTERNAL_PROCESS_STEP(SSMACHINES_PIPENETS,TRUE,process_pipenets,cost_pipenets,SSMACHINES_MACHINERY)
	INTERNAL_PROCESS_STEP(SSMACHINES_MACHINERY,FALSE,process_machinery,cost_machinery,SSMACHINES_POWERNETS)
	INTERNAL_PROCESS_STEP(SSMACHINES_POWERNETS,FALSE,process_powernets,cost_powernets,SSMACHINES_POWER_OBJECTS)

// Call when you need the network rebuilt, but we should wait until we have a good time to do it
/datum/controller/subsystem/machines/proc/defer_powernet_rebuild()
	if(!SSticker.HasRoundStarted())
		return
	// Use with responsibility... Must regen the entire power network after deferal is finished.
	if(!defering_powernets)
		defering_powernets = TRUE
		message_admins("Powernet generation deferred...")


// This MUST be called if request_powernet_rebuild is called with defer = TRUE once the network is free to regen
/datum/controller/subsystem/machines/proc/release_powernet_defer()
	if(defering_powernets)
		defering_powernets = FALSE
		message_admins("Powernet generation resumed. Rebuilding network...")
		makepowernets()

/datum/controller/subsystem/machines/proc/powernet_is_defered()
	return defering_powernets

// rebuild all power networks from scratch - Called when major network changes happen, like shuttles/turbolifts with wires moving, or huge explosions, where doing it per-wire does not make sense.
/datum/controller/subsystem/machines/proc/makepowernets()
	// TODO - check to not run while in the middle of a tick!
	for(var/datum/powernet/PN as anything in powernets)
		qdel(PN)
	powernets.Cut()
	setup_powernets_for_cables(GLOB.cable_list)

/datum/controller/subsystem/machines/proc/setup_powernets_for_cables(list/cables)
	for(var/obj/structure/cable/PC as anything in cables)
		if(!PC.powernet)
			var/datum/powernet/NewPN = new()
			NewPN.add_cable(PC)
			propagate_network(PC,PC.powernet)

/datum/controller/subsystem/machines/proc/setup_atmos_machinery(list/atmos_machines)
	var/list/actual_atmos_machines = list()

	for(var/obj/machinery/atmospherics/machine in atmos_machines)
		machine.atmos_init()
		actual_atmos_machines += machine
		CHECK_TICK

	for(var/obj/machinery/atmospherics/machine as anything in actual_atmos_machines)
		machine.build_network()
		CHECK_TICK

	for(var/obj/machinery/atmospherics/unary/U as anything in actual_atmos_machines)
		if(istype(U, /obj/machinery/atmospherics/unary/vent_pump))
			var/obj/machinery/atmospherics/unary/vent_pump/T = U
			T.broadcast_status()
		else if(istype(U, /obj/machinery/atmospherics/unary/vent_scrubber))
			var/obj/machinery/atmospherics/unary/vent_scrubber/T = U
			T.broadcast_status()
		CHECK_TICK

/datum/controller/subsystem/machines/stat_entry(msg)
	msg = "C:{"
	msg += "PI:[round(cost_pipenets,1)]|"
	msg += "MC:[round(cost_machinery,1)]|"
	msg += "PN:[round(cost_powernets,1)]|"
	msg += "PO:[round(cost_power_objects,1)]"
	msg += "} "
	msg += "PI:[length(SSmachines.networks)]|"
	msg += "MC:[length(SSmachines.processing_machines)]|"
	msg += "PN:[length(SSmachines.powernets)][defering_powernets ? " - !!DEFER!!" : ""]|"
	msg += "PO:[length(SSmachines.powerobjs)]|"
	msg += "HV:[length(SSmachines.hibernating_vents)]|"
	msg += "MC/MS:[round((cost ? length(SSmachines.processing_machines)/cost_machinery : 0),0.1)]"
	return ..()

/datum/controller/subsystem/machines/proc/process_pipenets(resumed = 0)
	if (!resumed)
		src.current_run = networks.Copy()
	//cache for sanic speed (lists are references anyways)
	var/wait = src.wait
	var/list/current_run = src.current_run
	while(length(current_run))
		var/datum/pipe_network/PN = current_run[length(current_run)]
		current_run.len--
		if(!PN || QDELETED(PN))
			networks.Remove(PN)
			DISABLE_BITFIELD(PN?.datum_flags, DF_ISPROCESSING)
		else
			PN.process(wait)
		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/machines/proc/process_machinery(resumed = 0)
	if (!resumed)
		update_hibernating_vents()
		src.current_run = processing_machines.Copy()

	var/wait = src.wait
	var/list/current_run = src.current_run
	while(length(current_run))
		var/obj/machinery/M = current_run[length(current_run)]
		current_run.len--
		if(!istype(M) || QDELETED(M) || (M.process(wait) == PROCESS_KILL))
			processing_machines.Remove(M)
			DISABLE_BITFIELD(M?.datum_flags, DF_ISPROCESSING)
		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/machines/proc/process_powernets(resumed = 0)
	if (!resumed)
		src.current_run = powernets.Copy()

	var/wait = src.wait
	var/list/current_run = src.current_run
	while(length(current_run))
		var/datum/powernet/PN = current_run[length(current_run)]
		current_run.len--
		if(!PN)
			powernets.Remove(PN)
			DISABLE_BITFIELD(PN?.datum_flags, DF_ISPROCESSING)
		else
			PN.reset(wait)
		if(MC_TICK_CHECK)
			return

// Actually only processes power DRAIN objects.
// Currently only used by powersinks. These items get priority processed before machinery
/datum/controller/subsystem/machines/proc/process_power_objects(resumed = 0)
	if (!resumed)
		src.current_run = powerobjs.Copy()

	var/wait = src.wait
	var/list/current_run = src.current_run
	while(length(current_run))
		var/obj/item/I = current_run[length(current_run)]
		current_run.len--
		if(!I || (I.pwr_drain(wait) == PROCESS_KILL))
			powerobjs.Remove(I)
			DISABLE_BITFIELD(I?.datum_flags, DF_ISPROCESSING)
		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/machines/Recover()
	for(var/datum/D as anything in SSmachines.networks)
		if(!istype(D, /datum/pipe_network))
			log_world("## ERROR Found wrong type during SSmachinery recovery: list=SSmachines.networks, item=[D], type=[D?.type]")
			SSmachines.networks -= D
	for(var/datum/D as anything in SSmachines.processing_machines)
		if(!istype(D, /obj/machinery))
			log_world("## ERROR Found wrong type during SSmachinery recovery: list=SSmachines.machines, item=[D], type=[D?.type]")
			SSmachines.processing_machines -= D
	for(var/datum/D as anything in SSmachines.powernets)
		if(!istype(D, /datum/powernet))
			log_world("## ERROR Found wrong type during SSmachinery recovery: list=SSmachines.powernets, item=[D], type=[D?.type]")
			SSmachines.powernets -= D
	for(var/datum/D as anything in SSmachines.powerobjs)
		if(!istype(D, /obj/item))
			log_world("## ERROR Found wrong type during SSmachinery recovery: list=SSmachines.powerobjs, item=[D], type=[D?.type]")
			SSmachines.powerobjs -= D

	all_machines = SSmachines.all_machines
	networks = SSmachines.networks
	processing_machines = SSmachines.processing_machines
	powernets = SSmachines.powernets
	powerobjs = SSmachines.powerobjs

/datum/controller/subsystem/machines/proc/update_hibernating_vents()
	// pick at random
	var/i = rand(20,40)
	while(i-- > 0)
		if(!length(hibernating_vents))
			break
		wake_vent(hibernating_vents[pick(hibernating_vents)])
	// do first 10 entries
	i = 10
	for(var/key in hibernating_vents)
		if(i <= 0 || !length(hibernating_vents))
			break
		wake_vent(hibernating_vents[key])
		i--

/datum/controller/subsystem/machines/proc/hibernate_vent(var/obj/machinery/atmospherics/unary/V)
	if(!V)
		return
	var/datum/weakref/WR = WEAKREF(V)
	if(!WR)
		return
	hibernating_vents[WR.reference] = WR
	STOP_MACHINE_PROCESSING(V)

/datum/controller/subsystem/machines/proc/wake_vent(var/datum/weakref/WR)
	if(!WR)
		return
	var/obj/machinery/atmospherics/unary/V = WR.resolve()
	if(V)
		START_MACHINE_PROCESSING(V)
	if(WR.reference)
		hibernating_vents[WR.reference] = null
		hibernating_vents.Remove(WR.reference)

#undef SSMACHINES_PIPENETS
#undef SSMACHINES_MACHINERY
#undef SSMACHINES_POWERNETS
#undef SSMACHINES_POWER_OBJECTS
