/datum/maint_recycler_vendor_entry/revolver //secoff scam
	name = "COWBOY REVOLV3R"
	ad_message =  "TWO TICKETS TO THE GUN SHOW!"
	desc = "I USED THE REVOLVER. YOU KNOW WHY? CAUSE THE REVOLVER DOESN’T MISS: AND UNLIKE THE SHITTY TASER IT STOPS A CRIMINAL IN THEIR TRACKS IN TWO HITS. BANG: BANG: AND THEY’RE FUCKING DONE. I USE FOUR SHOTS JUST TO MAKE DAMN SURE."
	object_type_to_spawn = /obj/item/toy/russian_revolver/trick_revolver
	item_cost = 50 //pricy!
	tagline = "clean and effective as fuck! OnlySec!"
	per_person_cap = 1
	per_round_cap = 1 //limited supply!
	required_access = list(access_security)
	vendor_category = MAINTVENDOR_WEAPONS

/datum/maint_recycler_vendor_entry/foamforce_ammo //fun!
	name = "MUNITIONS FOR GUN"
	ad_message =  "FOAM FLINGING PAIN!"
	desc = "BIG BOX? BIG AMMO. THAT'S RIGHT. WE'LL BIG YOUR AMMO. FOAM DARTS, FOR FOAM DART GUNS - LIMITED EDITION FRAG MONTAGE BUY NOW"
	object_type_to_spawn = /obj/item/toy/russian_revolver/trick_revolver
	item_cost = 15 //cheap!
	tagline = "to war!"
	per_person_cap = 1
	per_round_cap = 3 //limited supply!
	required_access = list(access_security)
	vendor_category = MAINTVENDOR_WEAPONS

/datum/maint_recycler_vendor_entry/foamforce_ammo //fun!
	name = "MUNITIONS FOR GUN"
	ad_message =  "FOAM FLINGING PAIN!"
	desc = "BIG BOX? BIG AMMO. THAT'S RIGHT. WE'LL BIG YOUR AMMO. FOAM DARTS, FOR FOAM DART GUNS - LIMITED EDITION FRAG MONTAGE BUY NOW"
	object_type_to_spawn = /obj/item/ammo_magazine/ammo_box/foam
	item_cost = 15 //cheap!
	tagline = "hoo rah!"
	per_person_cap = 1
	per_round_cap = 3 //limited supply!
	vendor_category = MAINTVENDOR_WEAPONS

/datum/maint_recycler_vendor_entry/foamforce_shotgun
	name = "BIG GAME HUNTER GUN"
	ad_message = "WITH ENOUGH FOAM YOU CAN KILL GOD!"
	desc = "22 CALIBER FOAM IS SO DEADLY BECAUSE IT BOUNCES AROUND INSIDE THE BODY. PUMP ACTION IS ALL U NEED"
	item_cost = 25
	per_person_cap = 1
	vendor_category = MAINTVENDOR_WEAPONS
	object_type_to_spawn = /obj/item/gun/projectile/shotgun/pump/toy

/datum/maint_recycler_vendor_entry/sword
	name = "SORD"
	ad_message = "FOLDED X1204314"
	desc = "BUILT WITH SUPPERIOR NIPPON FOAM FOLDED BILLION TIMES WITH BLOOD CHANNEL FOR MORE DEADLY LETHAL WEAPON SUPERIER TO ANY SPEAR"
	item_cost = 15
	per_person_cap = 2 //ARES. MY LIFE IS YOURS.
	vendor_category = MAINTVENDOR_WEAPONS
	object_type_to_spawn = /obj/item/material/sword/foam

/datum/maint_recycler_vendor_entry/shark
	name = "BLOOD REACTIVE BIO-ORGANIC MISSILE"
	ad_message = "IT'S SMOOTH"
	desc = "YEARS OF BIO-ORGANIC RESEARC HAVBE OPTIMIZED THE FORM OF THIS WAEPON TO THE DGRERE WHERE IT CAN KILL ANYHTING IN WATER DEADLY DO NOT DEPLOY IF BLEEDING"
	item_cost = 50 //comically expensive
	object_type_to_spawn = /obj/item/toy/plushie/shark
	vendor_category = MAINTVENDOR_WEAPONS

/datum/maint_recycler_vendor_entry/shark/post_purchase_handling(obj/bought) //mostly an example of use
	. = ..()
	var/primary = pick("blood","dark","evil","s0ul","death","kill","fr4g","stab","torture","pain","shadow","tear","revenge")
	var/secondary = pick("claw","fang","blade","sword","tooth","murder","laser","montage")
	bought.name = "Bio-Missile [primary]-[secondary]"
	bought.desc = "What the fuck?"
	bought.color = "#880808" //blood red
