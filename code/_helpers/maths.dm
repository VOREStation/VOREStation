/// Calculate the angle produced by a pair of x and y deltas
/proc/delta_to_angle(x, y)
	if(!y)
		return (x >= 0) ? 90 : 270
	. = arctan(x/y)
	if(y < 0)
		. += 180
	else if(x < 0)
		. += 360
