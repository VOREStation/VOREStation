/// A spawner that only spawns specific stuff on holidays
/obj/effect/spawner/holiday
	name = "holiday spawner"
	desc = "A spawner effect that only spawns stuff if a holiday is being celebrated"
	/// Contains holiday names as key, and the list of things to spawn on each holiday
	var/list/holidays_to_spawn
	/// If set and no holiday object is spawned, spawn this instead
	var/non_holiday_spawn

/obj/effect/spawner/holiday/Initialize(mapload)
	. = ..()
	var/found_holiday = FALSE
	for(var/holiday in holidays_to_spawn)
		if(check_holidays(holiday))
			found_holiday = TRUE
			var/list/spawn_list = holidays_to_spawn[holiday]
			for(var/path in spawn_list)
				new path(loc)
	if(!found_holiday && non_holiday_spawn)
		new non_holiday_spawn(loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/spawner/holiday/bar_keg
	name = "bar keg spawner"
	desc = "The spawner keg of station, with special stuff on holidays."
	icon = 'icons/obj/objects.dmi'
	icon_state = "beertankTEMP"
	holidays_to_spawn = list(
		HOLIDAY_PATRICK = list(
			/obj/structure/reagent_dispensers/beerkeg/irish
		),
		HOLIDAY_PIRATEDAY = list(
			/obj/structure/reagent_dispensers/beerkeg/pirate
		)
	)

	non_holiday_spawn = /obj/structure/reagent_dispensers/beerkeg
