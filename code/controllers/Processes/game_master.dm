/datum/controller/process/event/setup()
	name = "\improper GM controller"
	schedule_interval = 600 // every 60 seconds

/datum/controller/process/event/doWork()
	game_master.process()