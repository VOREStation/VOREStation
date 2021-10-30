// ToDo: Alphabetize by ckey.
// Also these things might be mildly obsolete considering the update to inventory.

// BEGIN - DO NOT EDIT PROTOTYPE
/obj/item/weapon/storage/box/fluff
	name = "Undefined Fluff Box"
	desc = "This should have a description. Tell an admin."
	storage_slots = 7
	var/list/has_items = list()

/obj/item/weapon/storage/box/fluff/New()
	storage_slots = has_items.len
	allowed = list()
	for(var/P in has_items)
		allowed += P
		new P(src)
	..()
	return
// END - DO NOT EDIT PROTOTYPE


/* TEMPLATE
// ckey:Character Name
/obj/item/weapon/storage/box/fluff/charactername
	name = ""
	desc = ""
	has_items = list(
		/obj/item/clothing/head/thing1,
		/obj/item/clothing/shoes/thing2,
		/obj/item/clothing/suit/thing3,
		/obj/item/clothing/under/thing4)
*/

// BeyondMyLife:Cassandra Selones Spawn Kit
/obj/item/weapon/storage/box/fluff/cassandra
	name = "Cassandra Selone's Spawn Kit"
	desc = "A spawn Kit, holding Cassandra Selone's Item's"
	has_items = list(
		/obj/item/clothing/gloves/fluff/kilano/purple,
		/obj/item/clothing/under/fluff/kilanosuit/purple,
		/obj/item/clothing/shoes/boots/fluff/kilano/purple)

//BeyondMyLife: Ne'tra Ky'ram //Made a box because they have so many items that it'd spam the debug log.
/obj/item/weapon/storage/box/fluff/kilano
	name = "Ne'tra Ky'ram's Kit"
	desc = "A kit containing Ne'tra Ky'ram's clothing."
	has_items = list(
		/obj/item/clothing/suit/storage/hooded/wintercoat/kilanocoat,
		/obj/item/clothing/under/fluff/kilanosuit,
		/obj/item/weapon/storage/backpack/messenger/sec/fluff/kilano,
		/obj/item/weapon/storage/belt/security/fluff/kilano,
		/obj/item/clothing/gloves/fluff/kilano/netra,
		/obj/item/clothing/shoes/boots/fluff/kilano,
		/obj/item/clothing/accessory/storage/black_vest/fluff/kilano
		)

// bwoincognito:Tasald Corlethian
/obj/item/weapon/storage/box/fluff/tasald
	name = "Tasald's Kit"
	desc = "A kit containing Tasald's equipment."
	has_items = list(
		/obj/item/clothing/suit/storage/det_suit/fluff/tasald,
		/obj/item/clothing/under/det/fluff/tasald)

//bwoincognito:Octavious Ward
/obj/item/weapon/storage/box/fluff/octavious
	name = "Octavious's Kit"
	desc = "A kit containing Octavious's work clothes."
	has_items = list(
		/obj/item/clothing/suit/storage/trench/fluff/octaviouscoat,
		/obj/item/clothing/under/det/fluff/octavious,
		/obj/item/clothing/mask/gas/plaguedoctor/fluff/octaviousmask,
		/obj/item/clothing/head/fedora/fluff/bowler,
		/obj/item/clothing/shoes/black/cuffs/octavious,
		/obj/item/weapon/cane/fluff/tasald,
		/obj/item/clothing/glasses/hud/health/octaviousmonicle
		)

//drakefrostpaw:Drake Frostpaw
/obj/item/weapon/storage/box/fluff/drake
	name = "United Federation Uniform Kit"
	desc = "A box containing all the parts of a United Federation Uniform"
	has_items = list(
		/obj/item/clothing/under/rank/internalaffairs/fluff/joan,
		/obj/item/clothing/suit/storage/fluff/modernfedcoat/modernfedsec,
		/obj/item/clothing/head/caphat/formal/fedcover/fedcoversec,
		/obj/item/clothing/gloves/white,
		)

// Draycu: Schae Yonra
/obj/item/weapon/storage/box/fluff/yonra
	name = "Yonra's Starting Kit"
	desc = "A small box containing Yonra's personal effects"
	has_items = list(
		/obj/item/weapon/melee/fluff/holochain/mass,
		/obj/item/clothing/accessory/medal/silver/unity)

//ivymoomoo:Ivy Baladeva
/obj/item/weapon/storage/backpack/messenger/sec/fluff/ivymoomoo
	name = "Ivy's Courier"
	desc = "A bag resembling something used by college students. Contains items for ''MooMoo''."

/obj/item/weapon/storage/backpack/messenger/sec/fluff/ivymoomoo/New()
	..()
	new /obj/item/clothing/head/beretg(src)
	new /obj/item/device/fluff/id_kit_ivy(src)
	new /obj/item/weapon/storage/fancy/cigarettes/dromedaryco(src)
	new /obj/item/weapon/storage/box/matches(src)
	new /obj/item/weapon/reagent_containers/food/snacks/sliceable/plaincake(src)

// jemli:Cirra Mayhem
/obj/item/weapon/storage/box/fluff/cirra
	name = "Instant Pirate Kit"
	desc = "Just add Akula!"
	has_items = list(
		/obj/item/clothing/head/pirate,
		/obj/item/clothing/glasses/eyepatch,
		/obj/item/clothing/suit/pirate,
		/obj/item/clothing/under/pirate)

// joey4298:Emoticon
/obj/item/weapon/storage/box/fluff/emoticon
	name = "Emoticon's Mime Kit"
	desc = "Specially packaged for the hungry catgirl mime with a taste for clown."
	has_items = list(
		/obj/item/device/fluff/id_kit_mime,
		/obj/item/clothing/gloves/white,
		/obj/item/clothing/head/beret,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/bottleofnothing,
		/obj/item/clothing/shoes/black,
		/*/obj/item/toy/crayon/mime*/) //Need to track down the code for crayons before adding this back in

//joanrisu:Joan Risu
/obj/item/weapon/storage/backpack/dufflebag/sec/fluff/joanrisu
	name = "Joan's Workbag"
	desc = "A bag Joan uses to carry her work equipment. It has the 82nd Battle Group Insignia on it."
	icon_state = "joanbag"
	icon = 'icons/vore/custom_items_vr.dmi'
	item_state = "duffle_med"
	slowdown = 0

/obj/item/weapon/storage/backpack/dufflebag/sec/fluff/joanrisu/New()
	..()
	new /obj/item/clothing/accessory/holster/hip(src)
	new /obj/item/clothing/suit/storage/fluff/modernfedcoat(src)
	new /obj/item/clothing/head/caphat/formal/fedcover(src)
	new /obj/item/clothing/suit/armor/det_suit(src)
	new /obj/item/weapon/flame/lighter/zippo/fluff/joan(src)
	new /obj/item/clothing/under/rank/internalaffairs/fluff/joan(src)
	new /obj/item/clothing/head/helmet/space/fluff/joan(src)
	new /obj/item/clothing/suit/space/fluff/joan(src)

//joanrisu:Katarina Eine
/obj/item/weapon/storage/backpack/dufflebag/sec/fluff/katarina
	name = "Katarina's Workbag"
	desc = "A duffle bag Katarina uses to carry her tools."
	slowdown = 0

/obj/item/weapon/storage/backpack/dufflebag/sec/fluff/katarina/New()
	..()
	new /obj/item/clothing/accessory/holster/hip(src)
	new /obj/item/clothing/suit/storage/fluff/fedcoat(src)
	new /obj/item/clothing/suit/armor/det_suit(src)
	new /obj/item/clothing/accessory/storage/black_vest(src)
	new /obj/item/weapon/material/knife/tacknife/combatknife/fluff/katarina(src)
	new /obj/item/clothing/under/rank/internalaffairs/fluff/joan(src)

//Razerwing:Archer Maximus
/obj/item/weapon/storage/box/fluff/archermaximus
	desc = "Personal Effects"
	has_items = list()

//Xsdew:Penelope Allen
/obj/item/weapon/storage/box/fluff/penelope
	name = "Penelope's capsule"
	desc = "A little capsule where a designer's swimsuit is stored."
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "capsule"
	storage_slots = 1
	foldable = null
	w_class = ITEMSIZE_SMALL
	max_w_class = ITEMSIZE_NORMAL
	can_hold = list(/obj/item/clothing/under/swimsuit/)
	has_items = list(/obj/item/clothing/under/swimsuit/fluff/penelope)

// JackNoir413: Mor Xaina
/obj/item/weapon/storage/box/fluff/morxaina
	name = "Fashionable clothes set"
	desc = "Set of custom-made, expensive attire elements."
	has_items = list(
		/obj/item/clothing/shoes/fluff/morthighs,
		/obj/item/clothing/gloves/fluff/morsleeves,
		/obj/item/clothing/under/fluff/morunder)

// Mewchild: Phi Vietsi
/obj/item/weapon/storage/box/fluff/phi
	name = "Phi's Personal Items"
	has_items = list(
		/obj/item/clothing/accessory/medal/bronze_heart,
		/obj/item/clothing/gloves/ring/seal/signet/fluff/phi)

// Tabiranth: Ascian
/obj/item/weapon/grenade/spawnergrenade/spirit
	name = "spirit's pet carrier"
	desc = "Contains kitten."
	spawner_type = /mob/living/simple_mob/animal/passive/cat/tabiranth
	deliveryamt = 1

// Jwguy: Koyo Akimomi
/obj/item/weapon/storage/box/fluff/koyoakimomi
	name = "Koyo's Cosplay Box"
	desc = "One of many traditional wolfgirl clothing sets that Koyo owns. Awoo!"
	has_items = list(
		/obj/item/clothing/head/fluff/wolfgirl,
		/obj/item/clothing/shoes/fluff/wolfgirl,
		/obj/item/clothing/under/fluff/wolfgirl,
		/obj/item/weapon/melee/fluffstuff/wolfgirlsword,
		/obj/item/weapon/shield/fluff/wolfgirlshield)

// Ryumi: Nikki Yumeno
/obj/item/weapon/storage/box/fluff
	name = "Nikki's Outfit Box"
	desc = "Warning: Contains dangerous amounts of dork."
	has_items = list(
		/obj/item/weapon/rig/nikki,
		/obj/item/clothing/head/fluff/nikki,
		/obj/item/clothing/under/skirt/outfit/fluff/nikki,
		/obj/item/clothing/shoes/fluff/nikki)

/*
Swimsuits, for general use, to avoid arriving to work with your swimsuit.
*/
/obj/item/weapon/storage/box/fluff/swimsuit
	name = "Black Swimsuit capsule"
	desc = "A little capsule where a swimsuit is usually stored."
	storage_slots = 1
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "capsule"
	foldable = null
	w_class = ITEMSIZE_SMALL
	max_w_class = ITEMSIZE_NORMAL
	can_hold = list(/obj/item/clothing/under/swimsuit/)
	has_items = list(/obj/item/clothing/under/swimsuit/black)

/obj/item/weapon/storage/box/fluff/swimsuit/blue
	name = "Blue Swimsuit capsule"
	has_items = list(/obj/item/clothing/under/swimsuit/blue)

/obj/item/weapon/storage/box/fluff/swimsuit/purple
	name = "Purple Swimsuit capsule"
	has_items = list(/obj/item/clothing/under/swimsuit/purple)

/obj/item/weapon/storage/box/fluff/swimsuit/green
	name = "Green Swimsuit capsule"
	has_items = list(/obj/item/clothing/under/swimsuit/green)

/obj/item/weapon/storage/box/fluff/swimsuit/red
	name = "Red Swimsuit capsule"
	has_items = list(/obj/item/clothing/under/swimsuit/red)

/obj/item/weapon/storage/box/fluff/swimsuit/white
	name = "White Swimsuit capsule"
	has_items = list(/obj/item/clothing/under/swimsuit/white)

/obj/item/weapon/storage/box/fluff/swimsuit/blue
	name = "Striped Swimsuit capsule"
	has_items = list(/obj/item/clothing/under/swimsuit/striped)

/obj/item/weapon/storage/box/fluff/swimsuit/earth
	name = "Earthen Swimsuit capsule"
	has_items = list(/obj/item/clothing/under/swimsuit/earth)

/obj/item/weapon/storage/box/fluff/swimsuit/engineering
	name = "Engineering Swimsuit capsule"
	has_items = list(/obj/item/clothing/under/swimsuit/fluff/engineering)

/obj/item/weapon/storage/box/fluff/swimsuit/science
	name = "Science Swimsuit capsule"
	has_items = list(/obj/item/clothing/under/swimsuit/fluff/science)

/obj/item/weapon/storage/box/fluff/swimsuit/security
	name = "Security Swimsuit capsule"
	has_items = list(/obj/item/clothing/under/swimsuit/fluff/security)

/obj/item/weapon/storage/box/fluff/swimsuit/medical
	name = "Medical Swimsuit capsule"
	has_items = list(/obj/item/clothing/under/swimsuit/fluff/medical)

/obj/item/weapon/storage/box/fluff/swimsuit/cowbikini
	name = "Cow Bikini Swimsuit capsule"
	has_items = list(/obj/item/clothing/under/swimsuit/cowbikini)

//Monkey boxes for the new primals we have
/obj/item/weapon/storage/box/monkeycubes/sobakacubes
	name = "sobaka cube box"
	desc = "Drymate brand sobaka cubes. Just add water!"
	starts_with = list(/obj/item/weapon/reagent_containers/food/snacks/monkeycube/wrapped/sobakacube = 4)

/obj/item/weapon/storage/box/monkeycubes/sarucubes
	name = "saru cube box"
	desc = "Drymate brand saru cubes. Just add water!"
	starts_with = list(/obj/item/weapon/reagent_containers/food/snacks/monkeycube/wrapped/sarucube = 4)

/obj/item/weapon/storage/box/monkeycubes/sparracubes
	name = "sparra cube box"
	desc = "Drymate brand sparra cubes. Just add water!"
	starts_with = list(/obj/item/weapon/reagent_containers/food/snacks/monkeycube/wrapped/sparracube = 4)

/obj/item/weapon/storage/box/monkeycubes/wolpincubes
	name = "wolpin cube box"
	desc = "Drymate brand wolpin cubes. Just add water!"
	starts_with = list(/obj/item/weapon/reagent_containers/food/snacks/monkeycube/wrapped/wolpincube = 4)
