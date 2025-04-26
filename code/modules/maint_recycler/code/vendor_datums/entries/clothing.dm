/datum/maint_recycler_vendor_entry/shirt //recycle some girls. recycle some boys. recycle them all
	name = "SH1RT! SAVE PLANET!"
	desc = "For the most committed in the trash4cash redemption program, we have a shirt! exclusive, with high quality materials!"
	object_type_to_spawn = /obj/item/clothing/suit/recycling_shirt
	item_cost = 15 //not too pricy
	tagline = "Congratulations on being the ONE. ONE. ONE. ONE. ONE. ONE. Visito-ONE-ONE!"
	ad_message = "This Person Recycles!"
	per_person_cap = 1
	per_round_cap = 3 //limited supply!
	vendor_category = MAINTVENDOR_CLOTHING

/datum/maint_recycler_vendor_entry/pimp
	name = "B1TCH1N HOT HAT"
	desc = "L1MP WRIST NO MORE. PIMP IT OUT!"
	object_type_to_spawn = /obj/item/clothing/head/collectable/petehat
	item_cost = 15 //not too pricy
	ad_message = "MMMhMMMMM"
	per_person_cap = 1
	per_round_cap = 3 //limited supply!
	vendor_category = MAINTVENDOR_CLOTHING

/datum/maint_recycler_vendor_entry/stripper_surplus
	name = "S3XY S3XY SURPLUS!"
	desc = "THE WETSKRELL \"DIAL-A-HOE\" STRIPPER PROGRAM MIGHT'VE GONE DOWN THE TOILET, BUT THAT JUST MEANS THE COST OF THEIR COSTUMES HAS WELL! DUBIOUSLY CLEAN! DUBIOUSLY SEXY!"
	ad_message = "KINKY!"
	item_cost = 15 //not too pricy
	object_type_to_spawn = /obj/random/fromList/sexy_costumes
	vendor_category = MAINTVENDOR_CLOTHING

/datum/maint_recycler_vendor_entry/gloves
	name = "RUBB3R GLOVES"
	desc = "YOU WOULD NOT BELIEVE HOW RUBBERY THESE ENGI SURPLUS?"
	ad_message = "RUBBERY!"
	item_cost = 25
	object_type_to_spawn = /obj/random/fromList/insuls
	vendor_category = MAINTVENDOR_CLOTHING
