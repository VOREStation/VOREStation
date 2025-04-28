#define Z_LEVEL_FIRST_EXAMPLE					1
#define Z_LEVEL_SECOND_EXAMPLE					2

/datum/map/example
	name = "Test Map"
	full_name = "The Test Map"
	path = "example"

	lobby_screens = list('html/lobby/mockingjay00.gif')

	zlevel_datum_type = /datum/map_z_level/example

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
	shuttle_called_message = "A crew transfer to %Dock_name% has been scheduled. The shuttle has been called. Those leaving should proceed to docks one and two in approximately %ETA%."
	shuttle_recall_message = "The scheduled crew transfer has been cancelled."
	emergency_shuttle_docked_message = "The Emergency Shuttle has docked with the station at docks one and two. You have approximately %ETD% to board the Emergency Shuttle."
	emergency_shuttle_leaving_dock = "The Emergency Shuttle has left the station. Estimate %ETA% until the shuttle docks at %dock_name%."
	emergency_shuttle_called_message = "An emergency evacuation shuttle has been called. It will arrive at docks one and two in approximately %ETA%."
	emergency_shuttle_recall_message = "The emergency shuttle has been recalled."

/datum/map_z_level/example/first
	z = Z_LEVEL_FIRST_EXAMPLE
	name = "First Floor"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER
	transit_chance = 50

/datum/map_z_level/example/second
	z = Z_LEVEL_SECOND_EXAMPLE
	name = "Second Floor"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER
	transit_chance = 50
	base_turf = /turf/simulated/open
