/*
/datum/supply_pack/sci/dune_buggy
	name = "Exploration Dune Buggy"
	contains = list(
			/obj/vehicle/train/rover/engine/dunebuggy
			)
	cost = 100
	containertype = /obj/structure/largecrate
	containername = "Exploration Dune Buggy Crate"
*/
/datum/supply_pack/sci/pred
	name = "Dangerous Predator crate"
	cost = 40
	containertype = /obj/structure/largecrate/animal/pred
	containername = "Dangerous Predator crate"
	access = access_xenobiology

/datum/supply_pack/sci/pred_doom
	name = "EXTREMELY Dangerous Predator crate"
	cost = 200
	containertype = /obj/structure/largecrate/animal/dangerous
	containername = "EXTREMELY Dangerous Predator crate"
	access = access_xenobiology
	contraband = 1
/*
/datum/supply_pack/sci/otie
	name = "VARMAcorp adoptable reject (Dangerous!)"
	cost = 100
	containertype = /obj/structure/largecrate/animal/otie
	containername = "VARMAcorp adoptable reject (Dangerous!)"
	access = access_xenobiology

/datum/supply_pack/sci/phoronotie
	name = "VARMAcorp adaptive beta subject (Experimental)"
	cost = 200
	containertype = /obj/structure/largecrate/animal/otie/phoron
	containername = "VARMAcorp adaptive beta subject (Experimental)"
	access = access_xenobiology
*/ //VORESTATION AI TEMPORARY REMOVAL. Oties commented out cuz broke.
