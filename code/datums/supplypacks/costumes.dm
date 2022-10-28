/*
*	Here is where any supply packs
*	related to costumes live.
*/


/datum/supply_pack/costumes
	group = "Costumes"

/datum/supply_pack/randomised/costumes
	group = "Costumes"

/datum/supply_pack/costumes/wizard
	name = "Wizard costume"
	contains = list(
			/obj/item/weapon/staff,
			/obj/item/clothing/suit/wizrobe/fake,
			/obj/item/clothing/shoes/sandal,
			/obj/item/clothing/head/wizard/fake
			)
	cost = 20
	containertype = /obj/structure/closet/crate/nanothreads
	containername = "Wizard costume crate"

/datum/supply_pack/randomised/costumes/hats
	num_contained = 4
	contains = list(
			/obj/item/clothing/head/collectable,
			/obj/item/clothing/head/collectable/paper,
			/obj/item/clothing/head/collectable/tophat,
			/obj/item/clothing/head/collectable/captain,
			/obj/item/clothing/head/collectable/beret,
			/obj/item/clothing/head/collectable/welding,
			/obj/item/clothing/head/collectable/flatcap,
			/obj/item/clothing/head/collectable/pirate,
			/obj/item/clothing/head/collectable/kitty,
			/obj/item/clothing/head/collectable/rabbitears,
			/obj/item/clothing/head/collectable/wizard,
			/obj/item/clothing/head/collectable/hardhat,
			/obj/item/clothing/head/collectable/HoS,
			/obj/item/clothing/head/collectable/thunderdome,
			/obj/item/clothing/head/collectable/swat,
			/obj/item/clothing/head/collectable/slime,
			/obj/item/clothing/head/collectable/police,
			/obj/item/clothing/head/collectable/slime,
			/obj/item/clothing/head/collectable/xenom,
			/obj/item/clothing/head/collectable/petehat
			)
	name = "Collectable hat crate!"
	cost = 200
	containertype = /obj/structure/closet/crate/nanothreads
	containername = "Collectable hats crate"

/datum/supply_pack/randomised/costumes/costume
	num_contained = 3
	contains = list(
			/obj/item/clothing/suit/costume,
			/obj/item/clothing/suit/costume/judgerobe,
			/obj/item/clothing/accessory/wcoat,
			/obj/item/clothing/suit/costume/hastur,
			/obj/item/clothing/suit/costume/holidaypriest,
			/obj/item/clothing/suit/nun,
			/obj/item/clothing/suit/ianshirt,
			/obj/item/clothing/under/suit_jacket/green,
			/obj/item/clothing/under/suit_jacket/teal,
			/obj/item/clothing/under/lawyer/purpsuit,
			/obj/item/clothing/under/rank/mailman,
			/obj/item/clothing/under/dress/dress_saloon,
			/obj/item/clothing/suit/suspenders,
			/obj/item/clothing/suit/storage/toggle/labcoat/mad,
			/obj/item/clothing/suit/bio_suit/plaguedoctorsuit,
			/obj/item/clothing/under/costume/schoolgirl,
			/obj/item/clothing/under/costume/owl,
			/obj/item/clothing/under/waiter,
<<<<<<< HEAD
			/obj/item/clothing/under/gladiator,
			/obj/item/clothing/under/soviet,
			/obj/item/clothing/under/scratch,
=======
			/obj/item/clothing/under/costume/gladiator,
			/obj/item/clothing/under/costume/soviet,
>>>>>>> 540b5cf6487... Merge pull request #8797 from Cerebulon/holloweeb
			/obj/item/clothing/under/wedding/bride_white,
			/obj/item/clothing/suit/chef,
			/obj/item/clothing/suit/storage/apron/overalls,
			/obj/item/clothing/under/costume/redcoat,
			/obj/item/clothing/under/costume/kilt
			)
	name = "Costumes crate"
	cost = 10
	containertype = /obj/structure/closet/crate/nanothreads
	containername = "Actor Costumes"

/datum/supply_pack/costumes/formal_wear
	contains = list(
			/obj/item/clothing/head/bowler,
			/obj/item/clothing/head/that,
			/obj/item/clothing/suit/storage/toggle/internalaffairs,
			/obj/item/clothing/suit/storage/toggle/lawyer/bluejacket,
			/obj/item/clothing/suit/storage/toggle/lawyer/purpjacket,
			/obj/item/clothing/under/suit_jacket,
			/obj/item/clothing/under/suit_jacket/female,
			/obj/item/clothing/under/suit_jacket/really_black,
			/obj/item/clothing/under/suit_jacket/red,
			/obj/item/clothing/under/lawyer/bluesuit,
			/obj/item/clothing/under/lawyer/purpsuit,
			/obj/item/clothing/shoes/black = 2,
			/obj/item/clothing/shoes/laceup/brown,
			/obj/item/clothing/accessory/wcoat
			)
	name = "Formalwear (Suits)"
	cost = 30
	containertype = /obj/structure/closet/crate/gilthari
	containername = "Formal suit crate"

/datum/supply_pack/costumes/witch
	name = "Witch costume"
	containername = "Witch costume"
	containertype = /obj/structure/closet/crate/nanothreads
	cost = 20
	contains = list(
			/obj/item/clothing/suit/wizrobe/marisa/fake,
			/obj/item/clothing/shoes/sandal,
			/obj/item/clothing/head/wizard/marisa/fake,
			/obj/item/weapon/staff/broom
			)

/datum/supply_pack/randomised/costumes/costume_hats
	name = "Costume hats"
	containername = "Actor hats crate"
	containertype = /obj/structure/closet/crate/nanothreads
	cost = 10
	num_contained = 3
	contains = list(
			/obj/item/clothing/head/redcoat,
			/obj/item/clothing/head/collectable/mailman,
			/obj/item/clothing/head/collectable/plaguedoctorhat,
			/obj/item/clothing/head/collectable/pirate,
			/obj/item/clothing/head/collectable/hasturhood,
			/obj/item/clothing/head/powdered_wig,
			/obj/item/clothing/head/pin/flower,
			/obj/item/clothing/head/pin/flower/yellow,
			/obj/item/clothing/head/pin/flower/blue,
			/obj/item/clothing/head/pin/flower/pink,
			/obj/item/clothing/head/pin/clover,
			/obj/item/clothing/head/pin/butterfly,
			/obj/item/clothing/mask/gas/costume/owl_mask,
			/obj/item/clothing/mask/gas/costume/monkeymask,
			/obj/item/clothing/head/helmet/collectable/gladiator,
			/obj/item/clothing/head/ushanka
			)

/datum/supply_pack/randomised/costumes/dresses
	name = "Formalwear (Dresses)"
	containername = "Formal dress crate"
	containertype = /obj/structure/closet/crate/gilthari
	cost = 15
	num_contained = 3
	contains = list(
			/obj/item/clothing/under/wedding/bride_orange,
			/obj/item/clothing/under/wedding/bride_purple,
			/obj/item/clothing/under/wedding/bride_blue,
			/obj/item/clothing/under/wedding/bride_red,
			/obj/item/clothing/under/wedding/bride_white,
			/obj/item/clothing/under/sundress,
			/obj/item/clothing/under/dress/dress_green,
			/obj/item/clothing/under/dress/dress_pink,
			/obj/item/clothing/under/dress/dress_orange,
			/obj/item/clothing/under/dress/dress_yellow,
			/obj/item/clothing/under/dress/dress_saloon
			)