/* // Doesn't show up on the cargo computer for some dumb fucking reason. -Ace
/datum/supply_packs/supply/stolen
	name = "Stolen supply crate"
	contains = list(/obj/item/stolenpackage = 1)
	cost = 150
	containertype = /obj/structure/closet/crate
	containername = "Stolen crate"
	contraband = 1
*/

/datum/supply_packs/randomised/contraband // So we're just going to overwrite the one we KNOW shows up.
	num_contained = 1
	contains = list(/obj/item/stolenpackage)
	name = "Contraband crate"
	cost = 150