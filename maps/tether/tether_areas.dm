//Debug areas
/area/tether/surfacebase
	name = "Tether Debug Surface"

/area/tether/transit
	name = "Tether Debug Transit"
	requires_power = 0

/area/tether/space
	name = "Tether Debug Space"
	requires_power = 0

// Teather Areas itself
/area/tether/surfacebase/tether
	icon = 'icons/turf/areas_vr.dmi'
	icon_state = "tether1"
/area/tether/transit/tether
	icon = 'icons/turf/areas_vr.dmi'
	icon_state = "tether2"
/area/tether/space/tether
	icon = 'icons/turf/areas_vr.dmi'
	icon_state = "tether3"

// Elevator areas.
/area/turbolift/tether/transit
	name = "tether (midway)"
	lift_floor_label = "Midpoint"
	lift_floor_name = "Tether Midpoint"
	lift_announce_str = "Arriving at midway point."

/area/turbolift/t_surface/level1
	name = "base (level 1)"
	lift_floor_label = "B-Level 1"
	lift_floor_name = "Tram, Mining"
	lift_announce_str = "Arriving at Level 1."

/area/turbolift/t_surface/level2
	name = "base (level 2)"
	lift_floor_label = "B-Level 2"
	lift_floor_name = "Maintenance"
	lift_announce_str = "Arriving at Level 2."

/area/turbolift/t_surface/level3
	name = "base (level 3)"
	lift_floor_label = "B-Level 3"
	lift_floor_name = "R&D, Bar"
	lift_announce_str = "Arriving at Level 3."

/area/turbolift/t_station/level1
	name = "station (level 1)"
	lift_floor_label = "S-Level 1"
	lift_floor_name = "Docking, Command"
	lift_announce_str = "Arriving at Level 1."

/area/turbolift/t_station/level2
	name = "station (level 2)"
	lift_floor_label = "S-Level 2"
	lift_floor_name = "Maintenance"
	lift_announce_str = "Arriving at Level 2."

/area/turbolift/t_station/level3
	name = "station (level 3)"
	lift_floor_label = "S-Level 3"
	lift_floor_name = "Medical, Security"
	lift_announce_str = "Arriving at Level 3."
