/datum/supply_pack/supply/stolen
	name = "Stolen supply crate"
	contains = list(/obj/item/stolenpackage = 1)
	cost = 150
	containertype = /obj/structure/closet/crate
	containername = "Stolen crate"
	contraband = 1

/datum/supply_pack/supply/wolfgirl
	name = "Wolfgirl Crate"
	cost = 200 //I mean, it's a whole wolfgirl
	containertype = /obj/structure/largecrate/animal/wolfgirl
	containername = "Wolfgirl crate"
	contraband = 1

/datum/supply_pack/supply/catgirl
	name = "Catgirl Crate"
	cost = 200 //I mean, it's a whole catgirl
	containertype = /obj/structure/largecrate/animal/catgirl
	containername = "Catgirl crate"
	contraband = 1

/datum/supply_pack/randomised/hospitality/pizzavouchers //WE ALWAYS DELIVER WE ALWAYS DELIVER WE ALWAYS DELIVER WE ALWAYS DELIVER WE ALWAYS DELIVER
	num_contained = 3
	contains = list(
			/obj/item/pizzavoucher,
			/obj/item/pizzavoucher,
			/obj/item/pizzavoucher
			)
	name = "FANTASTIC PIZZA PIE VOUCHER CRATE!"
	cost = 60
	containertype = /obj/structure/closet/crate
	containername = "WE ALWAYS DELIVER!"
	contraband = 1
