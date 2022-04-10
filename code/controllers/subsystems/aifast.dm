SUBSYSTEM_DEF(aifast)
<<<<<<< HEAD
	name = "AI (Fast)"
	init_order = INIT_ORDER_AI_FAST
	priority = FIRE_PRIORITY_AI
	wait = 0.25 SECONDS // Every quarter second
=======
	name = "AI Fast"
>>>>>>> 31d94c1f7d0... Merge pull request #8517 from Spookerton/spkrtn/sys/ssai-ssaifast
	flags = SS_NO_INIT
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	priority = FIRE_PRIORITY_AI
	wait = 0.25 SECONDS

	/// The list of AI datums to be processed.
	var/static/tmp/list/queue = list()

	/// The list of AI datums currently being processed.
	var/static/tmp/list/current = list()


/datum/controller/subsystem/aifast/stat_entry(msg_prefix)
	var/list/msg = list(msg_prefix)
	msg += "P:[queue.len]"
	..(msg.Join())

<<<<<<< HEAD
/datum/controller/subsystem/aifast/fire(resumed = 0)
=======

/datum/controller/subsystem/aifast/Recover()
	current.Cut()


/datum/controller/subsystem/aifast/fire(resumed, no_mc_tick)
>>>>>>> 31d94c1f7d0... Merge pull request #8517 from Spookerton/spkrtn/sys/ssai-ssaifast
	if (!resumed)
		current = queue.Copy()
	var/datum/ai_holder/subject
	for (var/i = current.len to 1 step -1)
		subject = current[i]
		if (QDELETED(subject) || subject.busy)
			continue
		subject.handle_tactics()
		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			current.Cut(i)
			return
	current.Cut()


/// Convenience define for safely enqueueing an AI datum for fast processing.
#define START_AIFASTPROCESSING(DATUM) \
if (!(DATUM.process_flags & AI_FASTPROCESSING)) {\
	DATUM.process_flags |= AI_FASTPROCESSING;\
	SSaifast.queue += DATUM;\
}


/// Convenience define for safely dequeueing an AI datum from fast processing.
#define STOP_AIFASTPROCESSING(DATUM) \
DATUM.process_flags &= ~AI_FASTPROCESSING; \
SSaifast.queue -= DATUM;
