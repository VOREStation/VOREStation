// To be filled out when more progress on the new map occurs.

/datum/map/southern_cross
	name = "Southern Cross"
	full_name = "Southern Cross"
	path = "southern_cross"

	lobby_icon = 'icons/misc/title.dmi'
	lobby_screens = list("mockingjay00") // New lobby screen if possible.

	station_levels = list(1,2,3)

	admin_levels = list(8,9)
	contact_levels = list(1,2,3)

	player_levels = list(1,2,3,4,5,6,7)

	sealed_levels = list()
	empty_levels = list(4)
	accessible_z_levels = list("1"=1,"2"=1,"3"=1,"4"=30,"6"=10,"7"=10)
	base_turf_by_z = list()

	station_name  = "Southern Cross"
	station_short = "Southern Cross"
	dock_name     = "NCS Northern Star" // Now we're the centcom!
	boss_name     = "Central Command"
	boss_short    = "Centcomm"
	company_name  = "NanoTrasen"
	company_short = "NT"
	starsys_name  = "Vir"

	shuttle_docked_message = "The scheduled shuttle to the %dock_name% has docked with the station at docks one and two. It will depart in approximately %ETD%."
	shuttle_leaving_dock = "The Crew Transfer Shuttle has left the station. Estimate %ETA% until the shuttle docks at %dock_name%."
	shuttle_called_message = "A crew transfer to %Dock_name% has been scheduled. The shuttle has been called. Those leaving should procede to docks one and two in approximately %ETA%"
	shuttle_recall_message = "The scheduled crew transfer has been cancelled."
	emergency_shuttle_docked_message = "The Emergency Shuttle has docked with the station at docks one and two. You have approximately %ETD% to board the Emergency Shuttle."
	emergency_shuttle_leaving_dock = "The Emergency Shuttle has left the station. Estimate %ETA% until the shuttle docks at %dock_name%."
	emergency_shuttle_called_message = "An emergency evacuation shuttle has been called. It will arrive at docks one and two in approximately %ETA%"
	emergency_shuttle_recall_message = "The emergency shuttle has been recalled."

	station_networks = list()