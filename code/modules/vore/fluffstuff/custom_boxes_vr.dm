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
		/obj/item/fluff/permit/tasald_corlethian,
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
		/obj/item/clothing/head/fedora/fluff/bowler)

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
	desc = "A duffle bag Joan uses to carry her work equipment."
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
		new /obj/item/fluff/permit/joanrisu(src)
		new /obj/item/weapon/sword/fluff/joanaria(src)
		new /obj/item/weapon/flame/lighter/zippo/fluff/joan(src)
		new /obj/item/clothing/under/rank/internalaffairs/fluff/joan(src)
		new /obj/item/clothing/head/helmet/space/fluff/joan(src)
		new /obj/item/clothing/suit/space/fluff/joan(src)
		new /obj/item/device/pda/heads/hos/joanpda(src)



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

//Razerwing:Archer Maximus
/obj/item/weapon/storage/box/fluff/archermaximus
	desc = "Personal Effects"
	has_items = list(
		/obj/item/fluff/permit/archermaximus,
		/obj/item/weapon/gun/projectile/colt/fluff/archercolt)

//ivymoomoo:Ivy Baladeva
/obj/item/weapon/storage/backpack/messenger/sec/fluff/ivymoomoo
	name = "Ivy's Courier"
	desc = "A bag resembling something used by college students. Contains items for ''MooMoo''."

	New()
		..()
		new /obj/item/clothing/head/beretg(src)
		new /obj/item/weapon/card/id/fluff/ivyholoid(src)
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
		new /obj/item/weapon/reagent_containers/hypospray/vr/fluff/aronai(src)
		new /obj/item/weapon/reagent_containers/glass/beaker/vial/vr/fluff/aro_st(src)
		new /obj/item/weapon/reagent_containers/glass/beaker/vial/vr/fluff/aro_bt(src)
		new /obj/item/weapon/reagent_containers/glass/beaker/vial/vr/fluff/aro_bu(src)
		new /obj/item/weapon/reagent_containers/glass/beaker/vial/vr/fluff/aro_tx(src)
		//Centcom stuff and permit
		new /obj/item/weapon/card/id/centcom/fluff/aronai(src)
		new /obj/item/fluff/permit/aronai_kadigan(src)
		new /obj/item/clothing/under/rank/khi/fluff/aronai(src)
		new /obj/item/clothing/glasses/omnihud/med/fluff/aronai(src)
		//Gun and holster
		new /obj/item/weapon/gun/projectile/khi/pistol(src)
		new /obj/item/ammo_magazine/c45m/flash(src)
		new /obj/item/clothing/accessory/holster/armpit(src)

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
