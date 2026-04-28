#define REM_CALM 				1
#define REM_IRREGULAR			2
#define REM_TENSION_RISING 		3
#define REM_VOLATILE			4
#define REM_UNCONTROLLED		5
#define REM_ANOMALOUS			6

/* 	Reactive Event Manager
*	Reacts on player's events, adding score every time a player does something.
*	Some departments might add more or trigger specific events more often.
*/

SUBSYSTEM_DEF(rem)
	name = "Reactive Event Manager"
	wait = 30 SECONDS
	dependencies = list(
		/datum/controller/subsystem/atoms
	)
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME

	var/score = 0
	var/mode = REM_CALM
	var/next_event_time = 0
	var/list/all_events = list()

	var/list/department_activity = list(
		DEPARTMENT_SECURITY = 0,
		DEPARTMENT_ENGINEERING = 0,
		DEPARTMENT_MEDICAL = 0,
		DEPARTMENT_RESEARCH = 0,
		DEPARTMENT_CARGO = 0,
		DEPARTMENT_CIVILIAN = 0
	)

	var/list/department_permanent_activity = list(
		DEPARTMENT_SECURITY = 0,
		DEPARTMENT_ENGINEERING = 0,
		DEPARTMENT_MEDICAL = 0,
		DEPARTMENT_RESEARCH = 0,
		DEPARTMENT_CARGO = 0,
		DEPARTMENT_CIVILIAN = 0
	)

/datum/controller/subsystem/rem/Initialize()
	for(var/path in subtypesof(/datum/rem_event))
		all_events += new path

	next_event_time = world.time + (rand(10, 15) MINUTES)
	return SS_INIT_SUCCESS

/datum/controller/subsystem/rem/fire(resumed)
	decay_activity()
	process_score()
	update_mode()
	try_trigger_event()

/datum/controller/subsystem/rem/proc/decay_activity()
	for(var/dept in department_activity)
		department_activity[dept] *= 0.9
		if(department_activity[dept] < 1) // Same as below
			department_activity[dept] = 0

/datum/controller/subsystem/rem/proc/process_score()
	var/total = 0

	for(var/dept in department_activity)
		total += department_activity[dept]
		total += department_permanent_activity[dept]

	score = (score * 0.8) + (total * 0.2)

	// Just so we don't end up with a fuckton on decimals behind a 0
	if(score < 1)
		score = 0

	return TRUE

/datum/controller/subsystem/rem/proc/update_mode()
	switch(score)
		if(21 to 50)
			mode = REM_IRREGULAR
		if(51 to 90)
			mode = REM_TENSION_RISING
		if(91 to 140)
			mode = REM_VOLATILE
		if(141 to 200)
			mode = REM_UNCONTROLLED
		if(201 to INFINITY)
			mode = REM_ANOMALOUS
		else
			mode = REM_CALM
	return TRUE

/datum/controller/subsystem/rem/proc/try_trigger_event()
	if(world.time < next_event_time)
		return FALSE

	trigger_event()

	var/delay = rand(15, 20) MINUTES

	switch(mode)
		if(REM_CALM)
			delay *= 1.5
		if(REM_IRREGULAR)
			delay *= 1.2
		if(REM_TENSION_RISING)
			delay *= 1
		if(REM_VOLATILE)
			delay *= 0.8
		if(REM_UNCONTROLLED)
			delay *= 0.6
		if(REM_ANOMALOUS)
			delay *= 0.4

	next_event_time = world.time + delay
	return TRUE

/datum/controller/subsystem/rem/proc/add_activity(dept, value)
	if(!(dept in department_activity))
		return FALSE

	department_activity[dept] += value

/datum/controller/subsystem/rem/proc/add_permanent_activity(dept, value)
	if(!(dept in department_permanent_activity))
		return FALSE

	department_permanent_activity[dept] += value
	department_permanent_activity[dept] = clamp(department_permanent_activity[dept], -100, 100)

/datum/controller/subsystem/rem/proc/get_available_events()
	var/list/valid = list()

	for(var/datum/rem_event/E in all_events)
		if(mode >= E.min_mode && mode <= E.max_mode)
			valid += E

	return valid

/datum/controller/subsystem/rem/proc/get_event_weight(datum/rem_event/E)
	var/weight = 1 // Base so events always exist

	if(!E.departments || !length(E.departments))
		return weight

	for(var/dept in E.departments)
		weight += get_effective_activity(dept)

	return weight

/datum/controller/subsystem/rem/proc/pick_weighted_event(list/events)
    var/total = 0
    var/list/weights = list()

    for(var/datum/rem_event/E in events)
        var/w = get_event_weight(E)
        weights[E] = w
        if(E.extra_value)
            total += E.extra_value
        total += w

    if(total <= 0)
        return FALSE

    var/roll = rand(0, total)

    for(var/datum/rem_event/E in weights)
        roll -= weights[E]
        if(roll <= 0)
            return E

    return FALSE

/datum/controller/subsystem/rem/proc/get_effective_activity(dept)
    return department_activity[dept] + department_permanent_activity[dept]

/datum/controller/subsystem/rem/proc/trigger_event()
	var/datum/rem_event/E = pick_weighted_event(get_available_events())

	if(!E)
		return FALSE

	// Higher chance for things to not happen, give more time between big events
	if(prob(5 * mode))
		return FALSE

	var/datum/event_meta/meta
	meta.severity = floor(mode/2)
	new E.event_path(meta)
	return TRUE
