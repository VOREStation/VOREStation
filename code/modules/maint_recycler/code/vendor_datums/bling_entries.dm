/datum/maint_recycler_vendor_entry/bling_scanner
	name = "Premium Body Scanner"
	desc = "With it's luxurious golden sheen, emerald, sapphire, and ruby indicator lights, and a succulent distaste for the 99%, you'll be the talk of the medbay!"
	object_type_to_spawn = /obj/item/healthanalyzer/bling
	item_cost = 50 //pricy!
	tagline = "It's not capital punishment, it's punishing a lack of capital. Go Green. Go PremiCare™️"
	per_person_cap = 1
	per_round_cap = 3 //limited supply!
	object_type_to_spawn = /obj/item/healthanalyzer/bling
	required_access = list(access_medical)
	vendor_category = MAINTVENDOR_SWAG

/datum/maint_recycler_vendor_entry/bling_wrench
	name = "AUsome Wrenching Supplies!"
	desc = "a distinct CuZn of ACTUAL gold, this wrench is sure to at least look KIND of gold!"
	object_type_to_spawn = /datum/maint_recycler_vendor_entry/bling_wrench
	required_access = list(access_engine,access_robotics)
	item_cost = 30 //not actual gold
	per_person_cap = 1
	vendor_category = MAINTVENDOR_SWAG

//TODO: port chomp mind bender
