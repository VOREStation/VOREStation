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

//joanrisu:Joan Risu
/obj/item/weapon/storage/backpack/dufflebag/sec/fluff/joanrisu
	name = "Joan's Workbag"
	desc = "A duffle bag Joan uses to carry her work equipment."

	New()
		..()
		new /obj/item/clothing/accessory/holster/hip(src)
		new /obj/item/clothing/suit/storage/fluff/fedcoat/fedcapt(src)
		new /obj/item/weapon/card/id/centcom/fluff/joanbadge(src)
		new /obj/item/weapon/gun/energy/gun/fluff/dominator(src)
		new /obj/item/clothing/suit/armor/det_suit(src)
		new /obj/item/fluff/permit/joanrisu(src)
		new /obj/item/clothing/accessory/storage/black_vest(src)
		new /obj/item/weapon/sword/fluff/joanaria(src)
		new /obj/item/weapon/flame/lighter/zippo/fluff/joan(src)
		new /obj/item/clothing/under/rank/internalaffairs/fluff/joan(src)

//joanrisu:Katarina Eine
/obj/item/weapon/storage/backpack/dufflebag/sec/fluff/Katarina
	name = "Katarina's Workbag"
	desc = "A duffle bag Katarina uses to carry her tools."

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

// arokha:Aronai Kadigan
/obj/item/weapon/storage/backpack/dufflebag/emt/fluff/aro
	name = "Aronai's Equipment"
	desc = "A big dufflebag, containing the stuff Aronai likes to carry with him."
	slowdown = 0 //HAX!

	New()
		..()
		new /obj/item/clothing/head/helmet/space/fluff/aronai(src)
		new /obj/item/clothing/suit/space/fluff/aronai(src)
		new /obj/item/device/suit_cooling_unit(src)
		new /obj/item/weapon/material/hatchet/tacknife/combatknife(src)
		new /obj/item/weapon/card/id/centcom/fluff/aro(src)
		new /obj/item/weapon/reagent_containers/hypospray/fluff/aronai(src)
