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

//POLARISTODO - These fail to compile since not all items are ported yet
// bwoincognito:Tasald Corlethian
/obj/item/weapon/storage/box/fluff/tasald
	name = "Tasald's Kit"
	desc = "A kit containing Talsald's equipment."
	has_items = list(
		/obj/item/clothing/suit/storage/det_suit/fluff/tasald,
		/obj/item/clothing/suit/storage/det_suit/fluff/tas_coat,
		/obj/item/clothing/under/det/fluff/tasald,
		/obj/item/fluff/permit/tasald_corlethian,
		/obj/item/weapon/gun/projectile/revolver/detective/fluff/tasald_corlethian,
		/obj/item/weapon/implanter/loyalty)

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

// joanrisu:Joan Risu
/obj/item/weapon/storage/box/fluff/joanrisu
	name = "Federation Officer's Kit"
	desc = "A care package for every serving Federation officer serving away from the Federation."
	has_items = list(
		/obj/item/clothing/gloves/white,
		/obj/item/device/radio/headset/heads/captain,
		/obj/item/weapon/storage/backpack/satchel,
		/obj/item/clothing/suit/storage/fluff/fedcoat,
		/obj/item/weapon/card/id/gold/fluff/joanbadge,
		/obj/item/weapon/card/id/captains_spare)
