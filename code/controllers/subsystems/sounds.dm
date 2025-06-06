#define DATUMLESS "NO_DATUM"

SUBSYSTEM_DEF(sounds)
	name = "Sounds"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_SOUNDS
	var/static/using_channels_max = CHANNEL_HIGHEST_AVAILABLE //BYOND max channels
	/// Amount of channels to reserve for random usage rather than reservations being allowed to reserve all channels. Also a nice safeguard for when someone screws up.
	var/static/random_channels_min = 50

	// Hey uh these two needs to be initialized fast because the whole "things get deleted before init" thing.
	/// Assoc list, `"[channel]" =` either the datum using it or TRUE for an unsafe-reserved (datumless reservation) channel
	var/list/using_channels
	/// Assoc list datum = list(channel1, channel2, ...) for what channels something reserved.
	var/list/using_channels_by_datum
	// Special datastructure for fast channel management
	/// List of all channels as numbers
	var/list/channel_list
	/// Associative list of all reserved channels associated to their position. `"[channel_number]" =` index as number
	var/list/reserved_channels
	/// lower iteration position - Incremented and looped to get "random" sound channels for normal sounds. The channel at this index is returned when asking for a random channel.
	var/channel_random_low
	/// higher reserve position - decremented and incremented to reserve sound channels, anything above this is reserved. The channel at this index is the highest unreserved channel.
	var/channel_reserve_high
	/// Assoc list of character speaking sounds, contains lists of sounds per key for use with pick()
	var/talk_sound_map = list()

/datum/controller/subsystem/sounds/Initialize()
	setup_available_channels()
	create_talk_sound_map()
	return SS_INIT_SUCCESS

/datum/controller/subsystem/sounds/proc/setup_available_channels()
	channel_list = list()
	reserved_channels = list()
	using_channels = list()
	using_channels_by_datum = list()
	for(var/i in 1 to using_channels_max)
		channel_list += i
	channel_random_low = 1
	channel_reserve_high = length(channel_list)

/// Removes a channel from using list.
/datum/controller/subsystem/sounds/proc/free_sound_channel(channel)
	var/text_channel = num2text(channel)
	var/using = using_channels[text_channel]
	using_channels -= text_channel
	if(using != TRUE) // datum channel
		using_channels_by_datum[using] -= channel
		if(!length(using_channels_by_datum[using]))
			using_channels_by_datum -= using
	free_channel(channel)

/// Frees all the channels a datum is using.
/datum/controller/subsystem/sounds/proc/free_datum_channels(datum/D)
	var/list/L = using_channels_by_datum[D]
	if(!L)
		return
	for(var/channel in L)
		using_channels -= num2text(channel)
		free_channel(channel)
	using_channels_by_datum -= D

/// Frees all datumless channels
/datum/controller/subsystem/sounds/proc/free_datumless_channels()
	free_datum_channels(DATUMLESS)

/// NO AUTOMATIC CLEANUP - If you use this, you better manually free it later! Returns an integer for channel.
/datum/controller/subsystem/sounds/proc/reserve_sound_channel_datumless()
	. = reserve_channel()
	if(!.) //oh no..
		return FALSE
	var/text_channel = num2text(.)
	using_channels[text_channel] = DATUMLESS
	LAZYINITLIST(using_channels_by_datum[DATUMLESS])
	using_channels_by_datum[DATUMLESS] += .

/// Reserves a channel for a datum. Automatic cleanup only when the datum is deleted. Returns an integer for channel.
/datum/controller/subsystem/sounds/proc/reserve_sound_channel(datum/D)
	if(!D) //i don't like typechecks but someone will fuck it up
		CRASH("Attempted to reserve sound channel without datum using the managed proc.")
	.= reserve_channel()
	if(!.)
		return FALSE
	var/text_channel = num2text(.)
	using_channels[text_channel] = D
	LAZYINITLIST(using_channels_by_datum[D])
	using_channels_by_datum[D] += .

/**
 * Reserves a channel and updates the datastructure. Private proc.
 */
/datum/controller/subsystem/sounds/proc/reserve_channel()
	PRIVATE_PROC(TRUE)
	if(channel_reserve_high <= random_channels_min) // out of channels
		return
	var/channel = channel_list[channel_reserve_high]
	reserved_channels[num2text(channel)] = channel_reserve_high--
	return channel

/**
 * Frees a channel and updates the datastructure. Private proc.
 */
/datum/controller/subsystem/sounds/proc/free_channel(number)
	PRIVATE_PROC(TRUE)
	var/text_channel = num2text(number)
	var/index = reserved_channels[text_channel]
	if(!index)
		CRASH("Attempted to (internally) free a channel that wasn't reserved.")
	reserved_channels -= text_channel
	// push reserve index up, which makes it now on a channel that is reserved
	channel_reserve_high++
	// swap the reserved channel wtih the unreserved channel so the reserve index is now on an unoccupied channel and the freed channel is next to be used.
	channel_list.Swap(channel_reserve_high, index)
	// now, an existing reserved channel will likely (exception: unreserving last reserved channel) be at index
	// get it, and update position.
	var/text_reserved = num2text(channel_list[index])
	if(!reserved_channels[text_reserved]) //if it isn't already reserved make sure we don't accidently mistakenly put it on reserved list!
		return
	reserved_channels[text_reserved] = index

/// Random available channel, returns text.
/datum/controller/subsystem/sounds/proc/random_available_channel_text()
	if(channel_random_low > channel_reserve_high)
		channel_random_low = 1
	. = "[channel_list[channel_random_low++]]"

/// Random available channel, returns number
/datum/controller/subsystem/sounds/proc/random_available_channel()
	if(channel_random_low > channel_reserve_high)
		channel_random_low = 1
	. = channel_list[channel_random_low++]

/// How many channels we have left.
/datum/controller/subsystem/sounds/proc/available_channels_left()
	return length(channel_list) - random_channels_min

/// Init talking sound lists
/datum/controller/subsystem/sounds/proc/create_talk_sound_map()
	talk_sound_map["beep-boop"] = DEFAULT_TALK_SOUNDS // first is DEFAULT
	talk_sound_map["goon speak 1"] =list('sound/talksounds/goon/speak_1.ogg', 'sound/talksounds/goon/speak_1_ask.ogg', 'sound/talksounds/goon/speak_1_exclaim.ogg')
	talk_sound_map["goon speak 2"] = list('sound/talksounds/goon/speak_2.ogg', 'sound/talksounds/goon/speak_2_ask.ogg', 'sound/talksounds/goon/speak_2_exclaim.ogg')
	talk_sound_map["goon speak 3"] = list('sound/talksounds/goon/speak_3.ogg', 'sound/talksounds/goon/speak_3_ask.ogg', 'sound/talksounds/goon/speak_3_exclaim.ogg')
	talk_sound_map["goon speak 4"] = list('sound/talksounds/goon/speak_4.ogg', 'sound/talksounds/goon/speak_4_ask.ogg', 'sound/talksounds/goon/speak_4_exclaim.ogg')
	talk_sound_map["goon speak blub"] = list('sound/talksounds/goon/blub.ogg', 'sound/talksounds/goon/blub_ask.ogg', 'sound/talksounds/goon/blub_exclaim.ogg')
	talk_sound_map["goon speak bottalk"] = list('sound/talksounds/goon/bottalk_1.ogg', 'sound/talksounds/goon/bottalk_2.ogg', 'sound/talksounds/goon/bottalk_3.ogg', 'sound/talksounds/goon/bottalk_4.wav')
	talk_sound_map["goon speak buwoo"] = list('sound/talksounds/goon/buwoo.ogg', 'sound/talksounds/goon/buwoo_ask.ogg', 'sound/talksounds/goon/buwoo_exclaim.ogg')
	talk_sound_map["goon speak cow"] = list('sound/talksounds/goon/cow.ogg', 'sound/talksounds/goon/cow_ask.ogg', 'sound/talksounds/goon/cow_exclaim.ogg')
	talk_sound_map["goon speak lizard"] = list('sound/talksounds/goon/lizard.ogg', 'sound/talksounds/goon/lizard_ask.ogg', 'sound/talksounds/goon/lizard_exclaim.ogg')
	talk_sound_map["goon speak pug"] = list('sound/talksounds/goon/pug.ogg', 'sound/talksounds/goon/pug_ask.ogg', 'sound/talksounds/goon/pug_exclaim.ogg')
	talk_sound_map["goon speak pugg"] = list('sound/talksounds/goon/pugg.ogg', 'sound/talksounds/goon/pugg_ask.ogg', 'sound/talksounds/goon/pugg_exclaim.ogg')
	talk_sound_map["goon speak roach"] = list('sound/talksounds/goon/roach.ogg', 'sound/talksounds/goon/roach_ask.ogg', 'sound/talksounds/goon/roach_exclaim.ogg')
	talk_sound_map["goon speak skelly"] = list('sound/talksounds/goon/skelly.ogg', 'sound/talksounds/goon/skelly_ask.ogg', 'sound/talksounds/goon/skelly_exclaim.ogg')
	talk_sound_map["xeno speak"] = list('sound/talksounds/xeno/xenotalk.ogg', 'sound/talksounds/xeno/xenotalk2.ogg', 'sound/talksounds/xeno/xenotalk3.ogg')

#undef DATUMLESS
