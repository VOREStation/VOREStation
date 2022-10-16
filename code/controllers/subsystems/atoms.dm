SUBSYSTEM_DEF(atoms)
	name = "Atoms"
	init_order = INIT_ORDER_ATOMS
	flags = SS_NO_FIRE

<<<<<<< HEAD
	var/static/initialized = INITIALIZATION_INSSATOMS
	// var/list/created_atoms // This is never used, so don't bother. ~Leshana
	var/static/old_initialized

	var/list/late_loaders
	var/list/created_atoms

	var/list/BadInitializeCalls = list()

/datum/controller/subsystem/atoms/Initialize(timeofday)
	setupgenetics() //to set the mutations' place in structural enzymes, so initializers know where to put mutations.
	initialized = INITIALIZATION_INNEW_MAPLOAD
	to_world_log("Initializing objects")
	admin_notice("<span class='danger'>Initializing objects</span>", R_DEBUG)
=======
	// Bad initialization types.
	var/const/QDEL_BEFORE_INITIALIZE = 1
	var/const/DID_NOT_SET_INITIALIZED = 2
	var/const/SLEPT_IN_INITIALIZE = 4
	var/const/DID_NOT_RETURN_HINT = 8

	var/static/atom_init_stage = INITIALIZATION_INSSATOMS
	var/static/old_init_stage
	var/static/list/late_loaders = list()
	var/static/list/created_atoms = list()
	var/static/list/bad_init_calls = list()


/datum/controller/subsystem/atoms/Initialize(start_uptime)
	atom_init_stage = INITIALIZATION_INNEW_MAPLOAD
>>>>>>> 3793cc764e4... Merge pull request #8757 from Spookerton/spkrtn/sys/ssatoms-massage
	InitializeAtoms()
	return ..()

<<<<<<< HEAD
/datum/controller/subsystem/atoms/proc/InitializeAtoms(list/atoms)
	if(initialized == INITIALIZATION_INSSATOMS)
		return

	initialized = INITIALIZATION_INNEW_MAPLOAD
=======

/datum/controller/subsystem/atoms/Recover()
	created_atoms.Cut()
	late_loaders.Cut()
	if (atom_init_stage == INITIALIZATION_INNEW_MAPLOAD)
		InitializeAtoms()

>>>>>>> 3793cc764e4... Merge pull request #8757 from Spookerton/spkrtn/sys/ssatoms-massage

/datum/controller/subsystem/atoms/Shutdown()
	var/initlog = InitLog()
	if (!initlog)
		return
	text2file(initlog, "[log_path]/initialize.log")


<<<<<<< HEAD
	var/count
	var/list/mapload_arg = list(TRUE)
	if(atoms)
		created_atoms = list()
		count = atoms.len
		for(var/atom/A as anything in atoms)
			if(!A.initialized)
				if(InitAtom(A, mapload_arg))
					atoms -= A
				CHECK_TICK
	else
		count = 0
		for(var/atom/A in world) // This must be world, since this operation adds all the atoms to their specific lists.
			if(!A.initialized)
				InitAtom(A, mapload_arg)
				++count
				CHECK_TICK

	log_world("Initialized [count] atoms")

	initialized = INITIALIZATION_INNEW_REGULAR

	if(late_loaders.len)
		for(var/atom/A as anything in late_loaders)
			A.LateInitialize()
			CHECK_TICK
		testing("Late initialized [late_loaders.len] atoms")
		late_loaders.Cut()

	// Nothing ever checks return value of this proc, so don't bother.  If this ever changes fix code in /atom/New() ~Leshana
	// if(atoms)
	// 	. = created_atoms + atoms
	// 	created_atoms = null

/datum/controller/subsystem/atoms/proc/InitAtom(atom/A, list/arguments)
	var/the_type = A.type
	if(QDELING(A))
		BadInitializeCalls[the_type] |= BAD_INIT_QDEL_BEFORE
		return TRUE
=======
/datum/controller/subsystem/atoms/proc/InitializeAtoms()
	if (atom_init_stage <= INITIALIZATION_INSSATOMS_LATE)
		return
	atom_init_stage = INITIALIZATION_INNEW_MAPLOAD
	var/list/mapload_arg = list(TRUE)
	var/count = 0
	var/atom/created
	var/list/arguments
	for (var/i = 1 to length(created_atoms))
		created = created_atoms[i]
		if (!created.initialized)
			arguments = created_atoms[created] ? mapload_arg + created_atoms[created] : mapload_arg
			InitAtom(created, arguments)
			CHECK_TICK
	created_atoms.Cut()
	if (!subsystem_initialized)
		for (var/atom/atom in world)
			if (!atom.initialized)
				InitAtom(atom, mapload_arg)
				++count
				CHECK_TICK
	report_progress("Initialized [count] atom\s")
	atom_init_stage = INITIALIZATION_INNEW_REGULAR
	if (!length(late_loaders))
		return
	for (var/atom/atom as anything in late_loaders)
		atom.LateInitialize(arglist(late_loaders[atom]))
	report_progress("Late initialized [length(late_loaders)] atom\s")
	late_loaders.Cut()

>>>>>>> 3793cc764e4... Merge pull request #8757 from Spookerton/spkrtn/sys/ssatoms-massage

/datum/controller/subsystem/atoms/proc/InitAtom(atom/atom, list/arguments)
	var/atom_type = atom?.type
	if (QDELING(atom))
		bad_init_calls[atom_type] |= QDEL_BEFORE_INITIALIZE
		return TRUE
	var/start_tick = world.time
	var/result = atom.Initialize(arglist(arguments))
	if (start_tick != world.time)
		bad_init_calls[atom_type] |= SLEPT_IN_INITIALIZE
	var/qdeleted = FALSE
<<<<<<< HEAD

	if(result != INITIALIZE_HINT_NORMAL)
		switch(result)
			if(INITIALIZE_HINT_LATELOAD)
				if(arguments[1])	//mapload
					late_loaders += A
				else
					A.LateInitialize()
			if(INITIALIZE_HINT_QDEL)
				qdel(A)
=======
	if (result != INITIALIZE_HINT_NORMAL)
		switch (result)
			if (INITIALIZE_HINT_LATELOAD)
				if (arguments[1])	//mapload
					late_loaders[atom] = arguments
				else
					atom.LateInitialize(arglist(arguments))
			if (INITIALIZE_HINT_QDEL)
				qdel(atom)
>>>>>>> 3793cc764e4... Merge pull request #8757 from Spookerton/spkrtn/sys/ssatoms-massage
				qdeleted = TRUE
			else
				bad_init_calls[atom_type] |= DID_NOT_RETURN_HINT
	if (!atom)
		qdeleted = TRUE
<<<<<<< HEAD
	else if(!A.initialized)
		BadInitializeCalls[the_type] |= BAD_INIT_DIDNT_INIT

	return qdeleted || QDELING(A)

/datum/controller/subsystem/atoms/proc/map_loader_begin()
	old_initialized = initialized
	initialized = INITIALIZATION_INSSATOMS

/datum/controller/subsystem/atoms/proc/map_loader_stop()
	initialized = old_initialized

/datum/controller/subsystem/atoms/Recover()
	initialized = SSatoms.initialized
	if(initialized == INITIALIZATION_INNEW_MAPLOAD)
		InitializeAtoms()
	old_initialized = SSatoms.old_initialized
	BadInitializeCalls = SSatoms.BadInitializeCalls
=======
	else if (!atom.initialized)
		bad_init_calls[atom_type] |= DID_NOT_SET_INITIALIZED
	return qdeleted || QDELING(atom)


/datum/controller/subsystem/atoms/proc/BeginMapLoad()
	old_init_stage = atom_init_stage
	atom_init_stage = INITIALIZATION_INSSATOMS_LATE


/datum/controller/subsystem/atoms/proc/FinishMapLoad()
	atom_init_stage = old_init_stage

>>>>>>> 3793cc764e4... Merge pull request #8757 from Spookerton/spkrtn/sys/ssatoms-massage

/datum/controller/subsystem/atoms/proc/InitLog()
	. = ""
	for (var/path in bad_init_calls)
		. += "Path : [path] \n"
		var/fails = bad_init_calls[path]
		if (fails & DID_NOT_SET_INITIALIZED)
			. += "- Didn't call atom/Initialize()\n"
		if (fails & DID_NOT_RETURN_HINT)
			. += "- Didn't return an Initialize hint\n"
		if (fails & QDEL_BEFORE_INITIALIZE)
			. += "- Qdel'd in New()\n"
		if (fails & SLEPT_IN_INITIALIZE)
			. += "- Slept during Initialize()\n"
