/datum/maint_recycler_vendor_entry/circuit_upgrade_disk //borderline on the threshold. expensive enough that science can just get it easier normally, mostly for the ever cuckolded engineers
	name = "C1RCUIT PRINT DISK UPGRADE"
	desc = "A disk with ADVANCED designs LEGALLY pirated from fuckNT.nt/fuckNT"
	ad_message = "VIRGIN-TACULAR!"
	object_type_to_spawn = /obj/item/disk/integrated_circuit/upgrade/advanced
	per_person_cap = 1
	item_cost = 30

/datum/maint_recycler_vendor_entry/duckies
	name = "DUCK SURPLUS"
	desc = "RUBBER DUCKY REASONABLE PRICE?"
	ad_message = "BONUS DUCK!"
	object_type_to_spawn = /obj/random/fromList/ducky
	per_person_cap = 3
	item_cost = 20

/datum/maint_recycler_vendor_entry/mechas
	name = "MECHHAMMER COLLECTABLE PROXY MODELS"
	desc = "MECH WORKSHOP'S LAWYERS CAN EAT MY BALLS! THESE PROXY MODELS R BETTER & MORE EPIC & FUCK U MECH WORKSHOP"
	ad_message = "MY BALLS!"
	tagline = "I HAVE 8.2 PETABYTES OF MECHHAMMER MODELS!"
	item_cost = 50 //even discount bin warhammer's comically expensive
	object_type_to_spawn = /obj/random/fromList/mecha_toys

/datum/maint_recycler_vendor_entry/burger //packaged 40 years ago. you should regret this.
	name = "TRASH 4 BURGER REDEMPTION"
	desc = "RSG is glad to partner with on-station cooking staff for EXCLUSIVE culinary deals! Packaged daily, stocked daily, always fresh!"
	item_cost = 5
	object_type_to_spawn = /obj/item/reagent_containers/food/snacks/packaged/vendburger/ancient
	ad_message = "Always fresh, the 2285 Guarantee!"
	tagline = "Tasty! The RSG way!"
