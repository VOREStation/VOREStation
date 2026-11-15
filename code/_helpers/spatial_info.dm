///Returns the distance between two atoms
/proc/get_dist_euclidean(atom/first_location, atom/second_location)
	var/dx = first_location.x - second_location.x
	var/dy = first_location.y - second_location.y

	var/dist = sqrt(dx ** 2 + dy ** 2)

	return dist
