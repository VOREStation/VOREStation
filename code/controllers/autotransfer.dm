var/datum/controller/transfer_controller/transfer_controller

datum/controller/transfer_controller
	var/timerbuffer = 0 //buffer for time check
	var/currenttick = 0
	var/shift_hard_end = vote_autotransfer_initial + vote_autotransfer_interval //VOREStation Edit
datum/controller/transfer_controller/New()
	timerbuffer = config.vote_autotransfer_initial
	processing_objects += src

datum/controller/transfer_controller/Destroy()
	processing_objects -= src

datum/controller/transfer_controller/proc/process()
	currenttick = currenttick + 1
	if (round_duration_in_ticks >= shift_hard_end - 1 MINUTE)//VOREStation Edit START
		init_shift_change(null, 1)
		shift_hard_end = timerbuffer + config.vote_autotransfer_interval //If shuttle somehow gets recalled, let's do this.
		timerbuffer = timerbuffer + config.vote_autotransfer_interval //Just to make sure a vote doesn't occur immediately afterwords.
	else if (round_duration_in_ticks >= timerbuffer - 1 MINUTE) //VOREStation Edit END
		vote.autotransfer()
		timerbuffer = timerbuffer + config.vote_autotransfer_interval
		
