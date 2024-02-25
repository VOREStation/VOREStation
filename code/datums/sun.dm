/datum/sun
	var/angle
	var/dx
	var/dy
	var/rate
	var/solar_next_update	// last time the sun position was checked and adjusted

/datum/sun/New()
	rate = rand(50,200)/100			// 50% - 200% of standard rotation
	if(prob(50))					// same chance to rotate clockwise than counter-clockwise
		rate = -rate
	angle = rand (0,360)			// the station position to the sun is randomised at round start

// calculate the sun's position given the time of day
// at the standard rate (100%) the angle is increase/decreased by 6 degrees every minute.
// a full rotation thus take a game hour in that case
/datum/sun/proc/calc_position()
	angle = (360 + angle + rate * 6) % 360	 // increase/decrease the angle to the sun, adjusted by the rate
	// now calculate and cache the (dx,dy) increments for line drawing

	var/s = sin(angle)
	var/c = cos(angle)

	// Either "abs(s) < abs(c)" or "abs(s) >= abs(c)"
	// In both cases, the greater is greater than 0, so, no "if 0" check is needed for the divisions

	if( abs(s) < abs(c))

		dx = s / abs(c)
		dy = c / abs(c)

	else
		dx = s/abs(s)
		dy = c / abs(s)

	//now tell the solar control computers to update their status and linked devices
	for(var/obj/machinery/power/solar_control/SC in GLOB.solars_list)
		if(!SC.powernet)
			GLOB.solars_list.Remove(SC)
			continue
		SC.update()
