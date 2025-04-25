#define SSTRANSCORE_IMPLANTS 1
#define SSTRANSCORE_BACKUPS 2

////////////////////////////////
//// Mind/body data storage system
//// for the resleeving tech
////////////////////////////////

SUBSYSTEM_DEF(transcore)
	name = "Transcore"
	priority = 20
	wait = 3 MINUTES
	flags = SS_BACKGROUND
	runlevels = RUNLEVEL_GAME
	init_order = INIT_ORDER_TRANSCORE

	// THINGS
	var/overdue_time = 6 MINUTES			// Has to be a multiple of wait var, or else will just round up anyway.

	var/current_step = SSTRANSCORE_IMPLANTS

	var/cost_backups = 0
	var/cost_implants = 0

	var/list/datum/transcore_db/databases = list()	// Holds instances of each database
	var/datum/transcore_db/default_db // The default if no specific one is used

	var/list/current_run = list()

/datum/controller/subsystem/transcore/Initialize()
	default_db = new()
	databases["default"] = default_db
	for(var/t in subtypesof(/datum/transcore_db))
		var/datum/transcore_db/db = new t()
		if(!db.key)
			warning("Instantiated transcore DB without a key: [t]")
			continue
		databases[db.key] = db
	return SS_INIT_SUCCESS

/datum/controller/subsystem/transcore/fire(resumed = 0)
	var/timer = TICK_USAGE

	INTERNAL_PROCESS_STEP(SSTRANSCORE_IMPLANTS,TRUE,process_implants,cost_implants,SSTRANSCORE_BACKUPS)
	INTERNAL_PROCESS_STEP(SSTRANSCORE_BACKUPS,FALSE,process_backups,cost_backups,SSTRANSCORE_IMPLANTS)

/datum/controller/subsystem/transcore/proc/process_implants(resumed = 0)
	if (!resumed)
		// Create a flat list of every implant in every db with a value of the db they're in
		src.current_run.Cut()
		for(var/key in databases)
			var/datum/transcore_db/db = databases[key]
			for(var/obj/item/implant/backup/imp as anything in db.implants)
				src.current_run[imp] = db

	var/list/current_run = src.current_run
	while(current_run.len)
		var/obj/item/implant/backup/imp = current_run[current_run.len]
		var/datum/transcore_db/db = current_run[imp]
		current_run.len--

		//Remove if not in a human anymore.
		if(!imp || !isorgan(imp.loc))
			db.implants -= imp
			continue

		//We're in an organ, at least.
		var/obj/item/organ/external/EO = imp.loc
		var/mob/living/carbon/human/H = EO.owner
		if(!H)
			db.implants -= imp
			continue

		//In a human
		BITSET(H.hud_updateflag, BACKUP_HUD)

		if(H == imp.imp_in && H.mind && H.stat < DEAD)
			db.m_backup(H.mind,H.nif)
			persist_nif_data(H)

		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/transcore/proc/process_backups(resumed = 0)
	if (!resumed)
		// Create a flat list of every implant in every db with a value of the db they're in
		src.current_run.Cut()
		for(var/key in databases)
			var/datum/transcore_db/db = databases[key]
			for(var/name in db.backed_up)
				var/datum/transhuman/mind_record/mr = db.backed_up[name]
				src.current_run[mr] = db

	var/list/current_run = src.current_run
	while(current_run.len)
		var/datum/transhuman/mind_record/curr_MR = current_run[current_run.len]
		var/datum/transcore_db/db = current_run[curr_MR]
		current_run.len--

		//Invalid record
		if(!curr_MR)
			log_debug("Tried to process [name] in transcore w/o a record!")
			db.backed_up -= curr_MR.mindname
			continue

		//Onetimes do not get processing or notifications
		if(curr_MR.one_time)
			continue

		//Timing check
		var/since_backup = world.time - curr_MR.last_update
		if(since_backup < overdue_time)
			curr_MR.dead_state = MR_NORMAL
		else
/*			if(curr_MR.dead_state != MR_DEAD) //First time switching to dead	//Remove auto notification! Ghosts have a button to notify, so no more false flags.
				if(curr_MR.do_notify)
					db.notify(curr_MR)
					curr_MR.last_notification = world.time
*/
			curr_MR.dead_state = MR_DEAD

		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/transcore/stat_entry(msg)
	msg = "$:{"
	msg += "IM:[round(cost_implants,1)]|"
	msg += "BK:[round(cost_backups,1)]"
	msg += "} "
	msg += "#:{"
	msg += "DB:[databases.len]|"
	if(!default_db)
		msg += "DEFAULT DB MISSING"
	else
		msg += "DFM:[default_db.backed_up.len]|"
		msg += "DFB:[default_db.body_scans.len]|"
		msg += "DFI:[default_db.implants.len]"
	msg += "} "
	return ..()

/datum/controller/subsystem/transcore/Recover()
	for(var/key in SStranscore.databases)
		if(!SStranscore.databases[key])
			warning("SStranscore recovery found missing database value for key: [key]")
			continue
		if(key == "default")
			default_db = SStranscore.databases[key]

		databases[key] = SStranscore.databases[key]

/datum/controller/subsystem/transcore/proc/leave_round(var/mob/M)
	if(!istype(M))
		warning("Non-mob asked to be removed from transcore: [M] [M?.type]")
		return
	if(!M.mind)
		warning("No mind mob asked to be removed from transcore: [M] [M?.type]")
		return

	for(var/key in databases)
		var/datum/transcore_db/db = databases[key]
		if(M.mind.name in db.backed_up)
			var/datum/transhuman/mind_record/MR = db.backed_up[M.mind.name]
			db.stop_backup(MR)
		if(M.mind.name in db.body_scans) //This uses mind names to avoid people cryo'ing a printed body to delete body scans.
			var/datum/transhuman/body_record/BR = db.body_scans[M.mind.name]
			db.remove_body(BR)

/datum/controller/subsystem/transcore/proc/db_by_key(var/key)
	if(isnull(key))
		return default_db
	if(!databases[key])
		warning("Tried to find invalid transcore database: [key]")
		return default_db
	return databases[key]

/datum/controller/subsystem/transcore/proc/db_by_mind_name(var/name)
	if(isnull(name))
		return null
	for(var/key in databases)
		var/datum/transcore_db/db = databases[key]
		if(name in db.backed_up)
			return db

// These are now just interfaces to databases
/datum/controller/subsystem/transcore/proc/m_backup(var/datum/mind/mind, var/obj/item/nif/nif, var/one_time = FALSE, var/database_key)
	var/datum/transcore_db/db = db_by_key(database_key)
	db.m_backup(mind=mind, nif=nif, one_time=one_time)

/datum/controller/subsystem/transcore/proc/add_backup(var/datum/transhuman/mind_record/MR, var/database_key)
	var/datum/transcore_db/db = db_by_key(database_key)
	db.add_backup(MR=MR)

/datum/controller/subsystem/transcore/proc/stop_backup(var/datum/transhuman/mind_record/MR, var/database_key)
	var/datum/transcore_db/db = db_by_key(database_key)
	db.stop_backup(MR=MR)

/datum/controller/subsystem/transcore/proc/add_body(var/datum/transhuman/body_record/BR, var/database_key)
	var/datum/transcore_db/db = db_by_key(database_key)
	db.add_body(BR=BR)

/datum/controller/subsystem/transcore/proc/remove_body(var/datum/transhuman/body_record/BR, var/database_key)
	var/datum/transcore_db/db = db_by_key(database_key)
	db.remove_body(BR=BR)

/datum/controller/subsystem/transcore/proc/core_dump(var/obj/item/disk/transcore/disk, var/database_key)
	var/datum/transcore_db/db = db_by_key(database_key)
	db.core_dump(disk=disk)


/datum/transcore_db
	var/list/datum/transhuman/mind_record/backed_up = list()	// All known mind records, indexed by MR.mindname/mind.name
	var/list/datum/transhuman/mind_record/has_left = list()		// Why do we even have this?
	var/list/datum/transhuman/body_record/body_scans = list()	// All known body records, indexed by BR.mydna.name
	var/list/obj/item/implant/backup/implants = list()	// All OPERATING implants that are being ticked

	var/core_dumped = FALSE
	var/key // Key for this DB

/datum/transcore_db/proc/m_backup(var/datum/mind/mind, var/obj/item/nif/nif, var/one_time = FALSE)
	ASSERT(mind)
	if(!mind.name || core_dumped)
		return 0

	var/datum/transhuman/mind_record/MR

	if(mind.name in backed_up)
		MR = backed_up[mind.name]
		MR.last_update = world.time
		MR.one_time = one_time

		//Pass a 0 to not change NIF status (because the elseif is checking for null)
		if(nif)
			MR.nif_path = nif.type
			MR.nif_durability = nif.durability
			var/list/nifsofts = list()
			for(var/N in nif.nifsofts)
				if(N)
					var/datum/nifsoft/nifsoft = N
					nifsofts += nifsoft.type
			MR.nif_software = nifsofts
			MR.nif_savedata = nif.save_data.Copy()
		else if(isnull(nif)) //Didn't pass anything, so no NIF
			MR.nif_path = null
			MR.nif_durability = null
			MR.nif_software = null
			MR.nif_savedata = null

	else
		MR = new(mind, mind.current, add_to_db = TRUE, one_time = one_time, database_key = src.key)

	return 1

// Send a past-due notification to the proper radio channel.
/datum/transcore_db/proc/notify(var/datum/transhuman/mind_record/MR)
	ASSERT(MR)
	var/datum/transcore_db/db = SStranscore.db_by_mind_name(MR.mindname)
	var/datum/transhuman/body_record/BR = db.body_scans[MR.mindname]
	if(!BR)
		GLOB.global_announcer.autosay("[MR.mindname] is past-due for a mind backup, but lacks a corresponding body record.", "TransCore Oversight", "Medical")
		return
	GLOB.global_announcer.autosay("[MR.mindname] is past-due for a mind backup.", "TransCore Oversight", BR.synthetic ? "Science" : "Medical")

// Called from mind_record to add itself to the transcore.
/datum/transcore_db/proc/add_backup(var/datum/transhuman/mind_record/MR)
	ASSERT(MR)
	backed_up[MR.mindname] = MR
	backed_up = sortAssoc(backed_up)
	log_debug("Added [MR.mindname] to transcore DB.")

// Remove a mind_record from the backup-checking list.  Keeps track of it in has_left // Why do we do that? ~Leshana
/datum/transcore_db/proc/stop_backup(var/datum/transhuman/mind_record/MR)
	ASSERT(MR)
	has_left[MR.mindname] = MR
	backed_up.Remove("[MR.mindname]")
	MR.cryo_at = world.time
	log_debug("Put [MR.mindname] in transcore suspended DB.")

// Called from body_record to add itself to the transcore.
/datum/transcore_db/proc/add_body(var/datum/transhuman/body_record/BR)
	ASSERT(BR)
	if(body_scans[BR.mydna.name])
		qdel(body_scans[BR.mydna.name])
	body_scans[BR.mydna.name] = BR
	body_scans = sortAssoc(body_scans)
	log_debug("Added [BR.mydna.name] to transcore body DB.")

// Remove a body record from the database (Usually done when someone cryos)  // Why? ~Leshana
/datum/transcore_db/proc/remove_body(var/datum/transhuman/body_record/BR)
	ASSERT(BR)
	body_scans.Remove("[BR.mydna.name]")
	log_debug("Removed [BR.mydna.name] from transcore body DB.")

// Moves all mind records from the databaes into the disk and shuts down all backup canary processing.
/datum/transcore_db/proc/core_dump(var/obj/item/disk/transcore/disk)
	ASSERT(disk)
	GLOB.global_announcer.autosay("An emergency core dump has been initiated!", "TransCore Oversight", "Command")
	GLOB.global_announcer.autosay("An emergency core dump has been initiated!", "TransCore Oversight", "Medical")

	disk.stored += backed_up
	backed_up.Cut()
	core_dumped = TRUE
	return disk.stored.len

#undef SSTRANSCORE_BACKUPS
#undef SSTRANSCORE_IMPLANTS
