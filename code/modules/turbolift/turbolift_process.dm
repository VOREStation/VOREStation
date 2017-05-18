var/datum/controller/process/turbolift/turbolift_controller

/datum/controller/process/turbolift
	var/list/moving_lifts = list()

/datum/controller/process/turbolift/New()
	..()
	turbolift_controller = src

/datum/controller/process/turbolift/setup()
	name = "turbolift controller"
	schedule_interval = 10

/datum/controller/process/turbolift/doWork()
	for(var/liftref in moving_lifts)
		if(world.time < moving_lifts[liftref])
			continue
		var/datum/turbolift/lift = locate(liftref)
		if(lift.busy)
			continue
		spawn(0)
			lift.busy = 1
			var/floor_delay
			if(!(floor_delay = lift.do_move()))
				moving_lifts[liftref] = null
				moving_lifts -= liftref
				if(lift.target_floor)
					lift.target_floor.ext_panel.reset()
					lift.target_floor = null
			else
				lift_is_moving(lift,floor_delay)
			lift.busy = 0
		SCHECK

/datum/controller/process/turbolift/proc/lift_is_moving(var/datum/turbolift/lift,var/floor_delay)
	moving_lifts["\ref[lift]"] = world.time + floor_delay
