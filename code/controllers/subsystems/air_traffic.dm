//Cactus, Speedbird, Dynasty, oh my
//Also, massive additions/refactors by Killian, because the original incarnation was full of holes
//Originally coded by above, massive refactor here to use datums instead of an if/else mess - Willbird
SUBSYSTEM_DEF(atc)
	name = "Air Traffic Control"
	priority = FIRE_PRIORITY_ATC
	runlevels = RUNLEVEL_GAME
	wait = 2 SECONDS
	init_order = INIT_ORDER_ATC
	flags = SS_BACKGROUND

	VAR_PRIVATE/next_tick = 0
	VAR_PRIVATE/datum/atc_chatter_type/chatter_datum = new() // don't change, override the chatter_box() proc
	VAR_PRIVATE/delay_min = 45 MINUTES				//How long between ATC traffic, minimum
	VAR_PRIVATE/delay_max = 90 MINUTES				//Ditto, maximum
							//Shorter delays means more traffic, which gives the impression of a busier system, but also means a lot more radio noise
	VAR_PRIVATE/backoff_delay = 5 MINUTES			//How long to back off if we can't talk and want to.  Default is 5 mins.
	VAR_PRIVATE/initial_delay = 15 MINUTES			//How long to wait before sending the first message of the shift.
	VAR_PRIVATE/squelched = FALSE					//If ATC is squelched currently

	//define a block of frequencies so we can have them be static instead of being random for each call
	var/ertchannel
	var/medchannel
	var/engchannel
	var/secchannel
	var/sdfchannel

/datum/controller/subsystem/atc/Initialize()
	//generate our static event frequencies for the shift. alternately they can be completely fixed, up in the core block
	ertchannel = "[rand(700,749)].[rand(1,9)]"
	medchannel = "[rand(750,799)].[rand(1,9)]"
	engchannel = "[rand(800,849)].[rand(1,9)]"
	secchannel = "[rand(850,899)].[rand(1,9)]"
	sdfchannel = "[rand(900,999)].[rand(1,9)]"
	return SS_INIT_SUCCESS

/datum/controller/subsystem/atc/fire()
	if(times_fired < 1)
		return
	if(times_fired == 1)
		next_tick = world.time + initial_delay
		INVOKE_ASYNC(src,PROC_REF(shift_starting))
		return
	if(world.time < next_tick)
		return
	if(squelched)
		next_tick = world.time + backoff_delay
		return
	next_tick = world.time + rand(delay_min,delay_max)
	INVOKE_ASYNC(src,PROC_REF(random_convo))

/datum/controller/subsystem/atc/proc/shift_starting()
	new /datum/atc_chatter/shift_start(null,null)

/datum/controller/subsystem/atc/proc/shift_ending()
	new /datum/atc_chatter/shift_end(null,null)

/datum/controller/subsystem/atc/proc/random_convo()
	// Pick from the organizations in the LOREMASTER, so we can find out what these ships are doing
	var/one = pick(loremaster.organizations) //These will pick an index, not an instance
	var/two = pick(loremaster.organizations)
	var/datum/lore/organization/source = loremaster.organizations[one] //Resolve to the instances
	var/datum/lore/organization/secondary = loremaster.organizations[two] //repurposed for new fun stuff

	//Random chance things for variety
	var/path = chatter_datum.chatter_box(source.org_type,secondary.org_type)
	new path(source,secondary)

/datum/controller/subsystem/atc/proc/reroute_traffic(var/yes = 1,var/silent = FALSE)
	if(yes)
		if(!squelched && !silent)
			msg("Rerouting traffic away from [using_map.station_name].")
		squelched = 1
	else
		if(squelched && !silent)
			msg("Resuming normal traffic routing around [using_map.station_name].")
		squelched = 0

/datum/controller/subsystem/atc/proc/msg(var/message,var/sender)
	ASSERT(message)
	global_announcer.autosay("[message]", sender ? sender : "[using_map.dock_name] Control")

/datum/controller/subsystem/atc/proc/is_squelched()
	return squelched
