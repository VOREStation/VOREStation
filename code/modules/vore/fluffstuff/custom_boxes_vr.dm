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


// bwoincognito:Tasald Corlethian
/obj/item/weapon/storage/box/fluff/tasald
	name = "Tasald's Kit"
	desc = "A kit containing Talsald's equipment."
	has_items = list(
		/obj/item/clothing/suit/storage/det_suit/fluff/tasald,
		/obj/item/clothing/suit/storage/det_suit/fluff/tas_coat,
		/obj/item/clothing/under/det/fluff/tasald,
		/obj/item/clothing/accessory/permit/gun/fluff/tasald_corlethian,
		/obj/item/weapon/gun/projectile/revolver/mateba/fluff/tasald_corlethian,
		/obj/item/weapon/implanter/loyalty)

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

	New()
		..()
		new /obj/item/clothing/accessory/holster/hip(src)
		new /obj/item/clothing/suit/storage/fluff/modernfedcoat(src)
		new /obj/item/clothing/head/caphat/formal/fedcover(src)
		new /obj/item/weapon/card/id/centcom/fluff/joanbadge(src)
		new /obj/item/weapon/gun/energy/gun/fluff/dominator(src)
		new /obj/item/clothing/suit/armor/det_suit(src)
		new /obj/item/clothing/accessory/permit/gun/fluff/joanrisu(src)
		new /obj/item/weapon/sword/fluff/joanaria(src)
		new /obj/item/weapon/flame/lighter/zippo/fluff/joan(src)
		new /obj/item/clothing/under/rank/internalaffairs/fluff/joan(src)
		new /obj/item/clothing/head/helmet/space/fluff/joan(src)
		new /obj/item/clothing/suit/space/fluff/joan(src)



//joanrisu:Katarina Eine
/obj/item/weapon/storage/backpack/dufflebag/sec/fluff/katarina
	name = "Katarina's Workbag"
	desc = "A duffle bag Katarina uses to carry her tools."
	slowdown = 0

	New()
		..()
		new /obj/item/clothing/accessory/holster/hip(src)
		new /obj/item/clothing/suit/storage/fluff/fedcoat(src)
		new /obj/item/weapon/gun/energy/gun/fluff/dominator(src)
		new /obj/item/clothing/suit/armor/det_suit(src)
		new /obj/item/clothing/accessory/storage/black_vest(src)
		new /obj/item/weapon/material/hatchet/tacknife/combatknife/fluff/katarina(src)
		new /obj/item/weapon/material/hatchet/tacknife/combatknife/fluff/katarina(src)
		new /obj/item/weapon/material/hatchet/tacknife/combatknife/fluff/katarina(src)
		new /obj/item/weapon/material/hatchet/tacknife/combatknife/fluff/katarina(src)
		new /obj/item/clothing/under/rank/internalaffairs/fluff/joan(src)

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

//Razerwing:Archer Maximus
/obj/item/weapon/storage/box/fluff/archermaximus
	desc = "Personal Effects"
	has_items = list()

//ivymoomoo:Ivy Baladeva
/obj/item/weapon/storage/backpack/messenger/sec/fluff/ivymoomoo
	name = "Ivy's Courier"
	desc = "A bag resembling something used by college students. Contains items for ''MooMoo''."

	New()
		..()
		new /obj/item/clothing/head/beretg(src)
		new /obj/item/device/fluff/id_kit_ivy(src)
		new /obj/item/weapon/storage/fancy/cigarettes/dromedaryco(src)
		new /obj/item/weapon/storage/box/matches(src)
		new /obj/item/weapon/reagent_containers/food/snacks/sliceable/plaincake(src)

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

//Arokha:Aronai Kadigan
/obj/item/weapon/storage/backpack/satchel/gen/fluff/aronai
	name = "blue medical satchel"
	desc = "A medical satchel done up in blue and white."

	New()
		..() //Might look like a lot... but all small items.
		//Centcom stuff and permit
		new /obj/item/weapon/card/id/centcom/fluff/aronai(src)
		new /obj/item/clothing/accessory/permit/gun/fluff/aronai_kadigan(src)
		//Gun and holster
		new /obj/item/weapon/gun/projectile/nsfw(src)
		new /obj/item/ammo_magazine/nsfw_mag(src)
		new /obj/item/ammo_casing/nsfw_batt/stun(src)
		new /obj/item/ammo_casing/nsfw_batt/stun(src)
		new /obj/item/ammo_casing/nsfw_batt/net(src)
		new /obj/item/clothing/accessory/holster(src)

//Aerowing:Sebastian Aji
/obj/item/weapon/storage/box/fluff/sebastian_aji
	name = "Sebastian's Lumoco Arms P3 Box"
	has_items = list(
		/obj/item/weapon/gun/projectile/pistol,
		/obj/item/ammo_magazine/m9mm/flash,
		/obj/item/ammo_magazine/m9mm/flash,
		/obj/item/clothing/accessory/permit/gun/fluff/sebastian_aji)

/obj/item/weapon/storage/box/fluff/briana_moore
	name = "Briana's Derringer Box"
	has_items = list(
		/obj/item/weapon/gun/projectile/derringer/fluff/briana,
		/obj/item/clothing/accessory/permit/gun/fluff/briana_moore)

//SilencedMP5A5:Serdykov Antoz
/obj/item/weapon/storage/box/fluff/serdykov_antoz
	name = "Serdy's Weapon Box"
	has_items = list(
		/obj/item/clothing/accessory/permit/gun/fluff/silencedmp5a5,
		/obj/item/weapon/gun/projectile/colt/fluff/serdy)

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

// JackNoir413: Mor Xaina
/obj/item/weapon/storage/box/fluff/morxaina
	name = "Fashionable clothes set"
	desc = "Set of custom-made, expensive attire elements."
	has_items = list(
		/obj/item/clothing/shoes/fluff/morthighs,
		/obj/item/clothing/gloves/fluff/morsleeves,
		/obj/item/clothing/under/fluff/morunder)


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

//Monkey boxes for the new primals we have
/obj/item/weapon/storage/box/monkeycubes/sobakacubes
	name = "sobaka cube box"
	desc = "Drymate brand sobaka cubes. Just add water!"

/obj/item/weapon/storage/box/monkeycubes/sobakacubes/New()
	..()
	for(var/i = 1 to 4)
		new /obj/item/weapon/reagent_containers/food/snacks/monkeycube/wrapped/sobakacube(src)

/obj/item/weapon/storage/box/monkeycubes/sarucubes
	name = "saru cube box"
	desc = "Drymate brand saru cubes. Just add water!"

/obj/item/weapon/storage/box/monkeycubes/sarucubes/New()
	..()
	for(var/i = 1 to 4)
		new /obj/item/weapon/reagent_containers/food/snacks/monkeycube/wrapped/sarucube(src)

/obj/item/weapon/storage/box/monkeycubes/sparracubes
	name = "sparra cube box"
	desc = "Drymate brand sparra cubes. Just add water!"

/obj/item/weapon/storage/box/monkeycubes/sparracubes/New()
	..()
	for(var/i = 1 to 4)
		new /obj/item/weapon/reagent_containers/food/snacks/monkeycube/wrapped/sparracube(src)

/obj/item/weapon/storage/box/monkeycubes/wolpincubes
	name = "wolpin cube box"
	desc = "Drymate brand wolpin cubes. Just add water!"

/obj/item/weapon/storage/box/monkeycubes/wolpincubes/New()
	..()
	for(var/i = 1 to 4)
		new /obj/item/weapon/reagent_containers/food/snacks/monkeycube/wrapped/wolpincube(src)
