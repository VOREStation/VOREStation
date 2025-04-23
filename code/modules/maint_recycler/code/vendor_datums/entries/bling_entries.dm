/datum/maint_recycler_vendor_entry/bling_scanner
	name = "Premium Body Scanner"
	ad_message =  "Richful healing!"
	desc = "With it's luxurious golden sheen, emerald, sapphire, and ruby indicator lights, and a succulent distaste for the 99%, you'll be the talk of the medbay! Medical only!"
	object_type_to_spawn = /obj/item/healthanalyzer/bling
	item_cost = 50 //pricy!
	tagline = "It's not capital punishment, it's punishing a lack of capital. Go Green. Go PremiCare™️"
	per_person_cap = 1
	per_round_cap = 3 //limited supply!
	object_type_to_spawn = /obj/item/healthanalyzer/bling
	icon_state = "scamalyzer"
	required_access = list(access_medical)
	vendor_category = MAINTVENDOR_SWAG

/datum/maint_recycler_vendor_entry/bling_wrench
	name = "AUsome Wrenching Supplies!"
	ad_message = "Bust Nuts in Style!"
	desc = "*a distinct CuZn of ACTUAL gold, this wrench is sure to at least look KIND of gold! Robotics & Engineering ONLY!"
	object_type_to_spawn = /obj/item/tool/wrench/brass
	required_access = list(access_engine,access_robotics)
	item_cost = 30 //not actual gold
	per_person_cap = 1
	vendor_category = MAINTVENDOR_SWAG
	icon_state = "goldwrench"

/datum/maint_recycler_vendor_entry/bling_screwdriver
	name = "Luxyry gold screwdriver"
	ad_message = "Gold? Screw you!"
	desc = "With a luxurious gold sheen, this screwdriver is sure to make you the envy of all your zinc and copper hating friends! Robotics & Engineering ONLY!"
	object_type_to_spawn = /obj/item/tool/screwdriver/brass
	item_cost = 30 //not actual gold
	per_person_cap = 1
	vendor_category = MAINTVENDOR_SWAG
	icon_state="goldscrew"
	required_access = list(access_engine,access_robotics)

/datum/maint_recycler_vendor_entry/bling_crowbar
	name = "Gold Crowbar"
	ad_message = "It's free, man!"
	desc = "rise and shine, mister blingman. not that i wish to imply you have been dripping on the job, no one is more deserving of this high quality brass crowbar than YOU! buy now! Robotics, Paramedics, and Engineering ONLY!"
	object_type_to_spawn = /obj/item/tool/crowbar/brass
	item_cost = 30 //not actually free
	per_person_cap = 1
	vendor_category = MAINTVENDOR_SWAG
	icon_state="goldcrow"
	required_access = list(access_engine,access_robotics,access_medical) //for paramedics



/datum/maint_recycler_vendor_entry/bling_cutters
	name = "Gold Wirecutters"
	ad_message = "Sharp as a tack!"
	desc = "MATERIAL SCIENTISTS HATE HIM!!! This GOLDEN wirecutter has DEFIED science by being HARDER THAN GOLD! they don't want you to know how, and neither do we! Robotics & Engineering ONLY!"
	object_type_to_spawn = /obj/item/tool/crowbar/brass
	item_cost = 30 //not actually gold
	per_person_cap = 1
	vendor_category = MAINTVENDOR_SWAG
	icon_state="goldcutters"
	required_access = list(access_engine,access_robotics)

/datum/maint_recycler_vendor_entry/bling_welder
	name = "Golden Welder"
	ad_message = "Gold adjacent pun here!"
	desc = "Do you know how shitty of an idea this is? We don't! buy it! Robotics & Engineering ONLY!"
	object_type_to_spawn = /obj/item/weldingtool/brass
	item_cost = 30 //not actually gold
	per_person_cap = 1
	vendor_category = MAINTVENDOR_SWAG
	icon_state="goldweld"
	required_access = list(access_engine,access_robotics)
