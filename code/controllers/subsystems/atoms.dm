#define BAD_INIT_QDEL_BEFORE 1
#define BAD_INIT_DIDNT_INIT 2
#define BAD_INIT_SLEPT 4
#define BAD_INIT_NO_HINT 8

SUBSYSTEM_DEF(atoms)
	name = "Atoms"
	init_order = INIT_ORDER_ATOMS
	flags = SS_NO_FIRE

	// override and GetArguments() exists for mod-override/downstream hook functionality.
	// Useful for total-overhaul type modifications.
	var/adjust_init_arguments = FALSE

	var/atom_init_stage = INITIALIZATION_INSSATOMS
	var/old_init_stage

	var/list/late_loaders
	var/list/BadInitializeCalls = list()

/datum/controller/subsystem/atoms/Initialize(timeofday)
	setupgenetics() //to set the mutations' place in structural enzymes, so initializers know where to put mutations.
	atom_init_stage = INITIALIZATION_INNEW_MAPLOAD
	InitializeAtoms()
	return ..()

/datum/controller/subsystem/atoms/proc/InitializeAtoms(var/list/supplied_atoms)

	if(atom_init_stage <= INITIALIZATION_INSSATOMS_LATE)
		return

	atom_init_stage = INITIALIZATION_INNEW_MAPLOAD

	LAZYINITLIST(late_loaders)

	var/list/mapload_arg = list(TRUE)
	var/count = LAZYLEN(supplied_atoms)
	if(count)
		while(supplied_atoms.len)
			var/atom/A = supplied_atoms[supplied_atoms.len]
			supplied_atoms.len--
			if(!A.initialized)
				InitAtom(A, GetArguments(A, mapload_arg))
				CHECK_TICK
	else if(!subsystem_initialized)
		// If wondering why not just store all atoms in a list and use the block above: that turns out unbearably expensive.
		// Instead, atoms without extra arguments in New created on server start are fished out of world directly.
		// We do this exactly once.

		for(var/atom/A in world)
			if(!A.initialized)
				InitAtom(A, GetArguments(A, mapload_arg, FALSE))
				++count
				CHECK_TICK

	report_progress("Initialized [count] atom\s")

	atom_init_stage = INITIALIZATION_INNEW_REGULAR

	if(late_loaders.len)
		for(var/atom/A as anything in late_loaders)
			A.LateInitialize()
			CHECK_TICK
		testing("Late initialized [late_loaders.len] atoms")
		late_loaders.Cut()

/datum/controller/subsystem/atoms/proc/InitAtom(atom/A, list/arguments)
	LAZYREMOVE(global.pre_init_created_atoms, A)
	var/the_type = A.type
	if(QDELING(A))
		BadInitializeCalls[the_type] |= BAD_INIT_QDEL_BEFORE
		return TRUE

	var/start_tick = world.time

	var/result = A.Initialize(arglist(arguments))

	if(start_tick != world.time)
		BadInitializeCalls[the_type] |= BAD_INIT_SLEPT

	var/qdeleted = FALSE

	if(result != INITIALIZE_HINT_NORMAL)
		switch(result)
			if(INITIALIZE_HINT_LATELOAD)
				if(arguments[1])	//mapload
					late_loaders[A] = arguments
				else
					A.LateInitialize(arglist(arguments))
			if(INITIALIZE_HINT_QDEL)
				qdel(A)
				qdeleted = TRUE
			else
				BadInitializeCalls[the_type] |= BAD_INIT_NO_HINT

	if(!A)	//possible harddel
		qdeleted = TRUE
	else if(!A.initialized)
		BadInitializeCalls[the_type] |= BAD_INIT_DIDNT_INIT

	return qdeleted || QDELING(A)

// override and GetArguments() exists for mod-override/downstream hook functionality.
// Useful for total-overhaul type modifications.
/atom/proc/AdjustInitializeArguments(list/arguments)
	// Lists are passed by reference so can simply modify the arguments list without returning it

/datum/controller/subsystem/atoms/proc/GetArguments(atom/A, list/mapload_arg, created=TRUE)
	if(!created && !adjust_init_arguments)
		return mapload_arg // Performance optimization. Nothing to do.
	var/list/arguments = mapload_arg.Copy()
	var/extra_args = LAZYACCESS(global.pre_init_created_atoms, A)
	if(created && extra_args)
		arguments += extra_args
	if(adjust_init_arguments)
		A.AdjustInitializeArguments(arguments)
	return arguments

/datum/controller/subsystem/atoms/stat_entry(msg)
	..("Bad Initialize Calls:[BadInitializeCalls.len]")

/datum/controller/subsystem/atoms/proc/map_loader_begin()
	old_init_stage = atom_init_stage
	atom_init_stage = INITIALIZATION_INSSATOMS_LATE

/datum/controller/subsystem/atoms/proc/map_loader_stop()
	atom_init_stage = old_init_stage

/datum/controller/subsystem/atoms/Recover()
	atom_init_stage = SSatoms.atom_init_stage
	if(atom_init_stage == INITIALIZATION_INNEW_MAPLOAD)
		InitializeAtoms()
	old_init_stage = SSatoms.old_init_stage
	BadInitializeCalls = SSatoms.BadInitializeCalls

/datum/controller/subsystem/atoms/proc/InitLog()
	. = ""
	for(var/path in BadInitializeCalls)
		. += "Path : [path] \n"
		var/fails = BadInitializeCalls[path]
		if(fails & BAD_INIT_DIDNT_INIT)
			. += "- Didn't call atom/Initialize()\n"
		if(fails & BAD_INIT_NO_HINT)
			. += "- Didn't return an Initialize hint\n"
		if(fails & BAD_INIT_QDEL_BEFORE)
			. += "- Qdel'd in New()\n"
		if(fails & BAD_INIT_SLEPT)
			. += "- Slept during Initialize()\n"

/datum/controller/subsystem/atoms/Shutdown()
	var/initlog = InitLog()
	if(initlog)
		text2file(initlog, "[log_path]-initialize.log")

#undef BAD_INIT_QDEL_BEFORE
#undef BAD_INIT_DIDNT_INIT
#undef BAD_INIT_SLEPT
#undef BAD_INIT_NO_HINT
