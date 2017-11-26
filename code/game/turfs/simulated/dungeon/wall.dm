// Special wall type for Point of Interests.

/turf/simulated/wall/dungeon
	block_tele = TRUE // Anti-cheese.

/turf/simulated/wall/dungeon/New(var/newloc)
	..(newloc,"dungeonium")

/turf/simulated/wall/dungeon/attackby()
	return

/turf/simulated/wall/dungeon/ex_act()
	return