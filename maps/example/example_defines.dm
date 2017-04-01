#define Z_LEVEL_FIRST_EXAMPLE					1
#define Z_LEVEL_SECOND_EXAMPLE					2

/datum/map/example
	name = "Test Map"
	full_name = "The Test Map"
	path = "example"

	lobby_icon = 'icons/misc/title.dmi'
	lobby_screens = list("mockingjay00")

	station_levels = list(
		Z_LEVEL_FIRST_EXAMPLE,
		Z_LEVEL_SECOND_EXAMPLE
		)

	admin_levels = list()
	contact_levels = list(
		Z_LEVEL_FIRST_EXAMPLE,
		Z_LEVEL_SECOND_EXAMPLE
		)

	player_levels = list(
		Z_LEVEL_FIRST_EXAMPLE,
		Z_LEVEL_SECOND_EXAMPLE
		)

	sealed_levels = list()
	empty_levels = list()
	accessible_z_levels = list("1" = 50, "2" = 50) // The defines can't be used here sadly.
	base_turf_by_z = list("2" = /turf/simulated/open)

	station_name  = "The Funhouse"
	station_short = "Funhouse"
	dock_name     = "the Maximum Fun Chamber"
	boss_name     = "Mister Fun"
	boss_short    = "Mr. Fun"
	company_name  = "Fun Inc."
	company_short = "FI"
	starsys_name  = "Vir"

	shuttle_docked_message = "The scheduled shuttle to the %dock_name% has docked with the station at docks one and two. It will depart in approximately %ETD%."
	shuttle_leaving_dock = "The Crew Transfer Shuttle has left the station. Estimate %ETA% until the shuttle docks at %dock_name%."
	shuttle_called_message = "A crew transfer to %Dock_name% has been scheduled. The shuttle has been called. Those leaving should procede to docks one and two in approximately %ETA%"
	shuttle_recall_message = "The scheduled crew transfer has been cancelled."
	emergency_shuttle_docked_message = "The Emergency Shuttle has docked with the station at docks one and two. You have approximately %ETD% to board the Emergency Shuttle."
	emergency_shuttle_leaving_dock = "The Emergency Shuttle has left the station. Estimate %ETA% until the shuttle docks at %dock_name%."
	emergency_shuttle_called_message = "An emergency evacuation shuttle has been called. It will arrive at docks one and two in approximately %ETA%"
	emergency_shuttle_recall_message = "The emergency shuttle has been recalled."