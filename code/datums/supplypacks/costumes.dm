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
			/obj/item/clothing/head/collectable/chef,
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
			/obj/item/clothing/suit/pirate,
			/obj/item/clothing/suit/judgerobe,
			/obj/item/clothing/accessory/wcoat,
			/obj/item/clothing/suit/hastur,
			/obj/item/clothing/suit/holidaypriest,
			/obj/item/clothing/suit/nun,
			/obj/item/clothing/suit/imperium_monk,
			/obj/item/clothing/suit/ianshirt,
			/obj/item/clothing/under/suit_jacket/green,
			/obj/item/clothing/under/suit_jacket/teal,
			/obj/item/clothing/under/lawyer/purpsuit,
			/obj/item/clothing/under/rank/mailman,
			/obj/item/clothing/under/dress/dress_saloon,
			/obj/item/clothing/suit/suspenders,
			/obj/item/clothing/suit/storage/toggle/labcoat/mad,
			/obj/item/clothing/suit/bio_suit/plaguedoctorsuit,
			/obj/item/clothing/under/schoolgirl,
			/obj/item/clothing/under/owl,
			/obj/item/clothing/under/waiter,
			/obj/item/clothing/under/gladiator,
			/obj/item/clothing/under/soviet,
			/obj/item/clothing/under/scratch,
			/obj/item/clothing/under/wedding/bride_white,
			/obj/item/clothing/suit/chef,
			/obj/item/clothing/suit/storage/apron/overalls,
			/obj/item/clothing/under/redcoat,
			/obj/item/clothing/under/kilt
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
			/obj/item/clothing/head/mailman,
			/obj/item/clothing/head/plaguedoctorhat,
			/obj/item/clothing/head/pirate,
			/obj/item/clothing/head/hasturhood,
			/obj/item/clothing/head/powdered_wig,
			/obj/item/clothing/head/pin/flower,
			/obj/item/clothing/head/pin/flower/yellow,
			/obj/item/clothing/head/pin/flower/blue,
			/obj/item/clothing/head/pin/flower/pink,
			/obj/item/clothing/head/pin/clover,
			/obj/item/clothing/head/pin/butterfly,
			/obj/item/clothing/mask/gas/owl_mask,
			/obj/item/clothing/mask/gas/monkeymask,
			/obj/item/clothing/head/helmet/gladiator,
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

/datum/supply_pack/costumes/xenowear_vr
	name = "Xenowear crate"
	contains = list(
			/obj/item/clothing/shoes/footwraps,
			/obj/item/clothing/shoes/boots/jackboots/toeless,
			/obj/item/clothing/shoes/boots/workboots/toeless,
			/obj/item/clothing/suit/tajaran/furs,
			/obj/item/clothing/head/tajaran/scarf,
			/obj/item/clothing/suit/unathi/robe,
			/obj/item/clothing/suit/unathi/mantle,
			/obj/item/clothing/under/permit,
			/obj/item/clothing/under/vox/vox_casual,
			/obj/item/clothing/under/vox/vox_robes,
			/obj/item/clothing/under/harness,
			/obj/item/clothing/under/skirt/loincloth,
			/obj/item/clothing/gloves/vox
			)
	cost = 100
	containertype = /obj/structure/closet/crate
	containername = "Xenowear crate"

/datum/supply_pack/costumes/tesh_smocks_vr
	name = "Teshari smocks"
	num_contained = 4
	contains = list(
			/obj/item/clothing/under/teshari/smock,
			/obj/item/clothing/under/teshari/smock/white,
			/obj/item/clothing/under/teshari/smock/red,
			/obj/item/clothing/under/teshari/smock/yellow,
			/obj/item/clothing/under/teshari/smock/rainbow,
			/obj/item/clothing/under/teshari/smock/dress,
			/obj/item/clothing/under/teshari/smock/blackutilitysmock,
			/obj/item/clothing/under/teshari/smock/greydress,
			/obj/item/clothing/under/teshari/smock/blackutility,
			/obj/item/clothing/under/teshari/smock/bluegreydress
			)
	cost = 20
	containertype = /obj/structure/closet/crate
	containername = "Teshari smocks crate"

/datum/supply_pack/randomised/costumes/tesh_coats_vr
	name = "Teshari undercoats"
	num_contained = 4
	contains = list(
			/obj/item/clothing/under/teshari/undercoat/standard/orange_grey,
			/obj/item/clothing/under/teshari/undercoat/standard/rainbow,
			/obj/item/clothing/under/teshari/undercoat/standard/lightgrey_grey,
			/obj/item/clothing/under/teshari/undercoat/standard/white_grey,
			/obj/item/clothing/under/teshari/undercoat/standard/red_grey,
			/obj/item/clothing/under/teshari/undercoat/standard/orange,
			/obj/item/clothing/under/teshari/undercoat/standard/yellow_grey,
			/obj/item/clothing/under/teshari/undercoat/standard/green_grey,
			/obj/item/clothing/under/teshari/undercoat/standard/blue_grey,
			/obj/item/clothing/under/teshari/undercoat/standard/purple_grey,
			/obj/item/clothing/under/teshari/undercoat/standard/pink_grey,
			/obj/item/clothing/under/teshari/undercoat/standard/brown_grey
			)
	cost = 20
	containertype = /obj/structure/closet/crate
	containername = "Teshari undercoats crate"

/datum/supply_pack/randomised/costumes/tesh_coats_b_vr
	name = "Teshari undercoats (black)"
	num_contained = 4
	contains = list(
			/obj/item/clothing/under/teshari/undercoat,
			/obj/item/clothing/under/teshari/undercoat/standard/black_orange,
			/obj/item/clothing/under/teshari/undercoat/standard/black_grey,
			/obj/item/clothing/under/teshari/undercoat/standard/black_white,
			/obj/item/clothing/under/teshari/undercoat/standard/black_red,
			/obj/item/clothing/under/teshari/undercoat/standard/black,
			/obj/item/clothing/under/teshari/undercoat/standard/black_yellow,
			/obj/item/clothing/under/teshari/undercoat/standard/black_green,
			/obj/item/clothing/under/teshari/undercoat/standard/black_blue,
			/obj/item/clothing/under/teshari/undercoat/standard/black_purple,
			/obj/item/clothing/under/teshari/undercoat/standard/black_pink,
			/obj/item/clothing/under/teshari/undercoat/standard/black_brown
			)
	cost = 20
	containertype = /obj/structure/closet/crate
	containername = "Teshari undercoats crate"

/datum/supply_pack/randomised/costumes/tesh_cloaks_vr
	name = "Teshari cloaks"
	num_contained = 4
	contains = list(
			/obj/item/clothing/suit/storage/teshari/cloak/standard/white,
			/obj/item/clothing/suit/storage/teshari/cloak/standard/white_grey,
			/obj/item/clothing/suit/storage/teshari/cloak/standard/red_grey,
			/obj/item/clothing/suit/storage/teshari/cloak/standard/orange_grey,
			/obj/item/clothing/suit/storage/teshari/cloak/standard/yellow_grey,
			/obj/item/clothing/suit/storage/teshari/cloak/standard/green_grey,
			/obj/item/clothing/suit/storage/teshari/cloak/standard/blue_grey,
			/obj/item/clothing/suit/storage/teshari/cloak/standard/purple_grey,
			/obj/item/clothing/suit/storage/teshari/cloak/standard/pink_grey,
			/obj/item/clothing/suit/storage/teshari/cloak/standard/brown_grey,
			/obj/item/clothing/suit/storage/teshari/cloak/standard/rainbow,
			/obj/item/clothing/suit/storage/teshari/cloak/standard/orange
			)
	cost = 40
	containertype = /obj/structure/closet/crate
	containername = "Teshari cloaks crate"

/datum/supply_pack/randomised/costumes/tesh_cloaks_b_vr
	name = "Teshari cloaks (black)"
	num_contained = 4
	contains = list(
			/obj/item/clothing/suit/storage/teshari/cloak,
			/obj/item/clothing/suit/storage/teshari/cloak/standard/black_red,
			/obj/item/clothing/suit/storage/teshari/cloak/standard/black_orange,
			/obj/item/clothing/suit/storage/teshari/cloak/standard/black_yellow,
			/obj/item/clothing/suit/storage/teshari/cloak/standard/black_green,
			/obj/item/clothing/suit/storage/teshari/cloak/standard/black_blue,
			/obj/item/clothing/suit/storage/teshari/cloak/standard/black_purple,
			/obj/item/clothing/suit/storage/teshari/cloak/standard/black_pink,
			/obj/item/clothing/suit/storage/teshari/cloak/standard/black_brown,
			/obj/item/clothing/suit/storage/teshari/cloak/standard/black_grey,
			/obj/item/clothing/suit/storage/teshari/cloak/standard/black_white,
			/obj/item/clothing/suit/storage/teshari/cloak/standard/black_glow,
			/obj/item/clothing/suit/storage/teshari/cloak/standard/dark_retrowave
			)
	cost = 40
	containertype = /obj/structure/closet/crate
	containername = "Teshari cloaks crate"

/datum/supply_pack/costumes/tesh_worksuits_vr
	name = "Teshari worksuits"
	num_contained = 4
	contains = list(
			/obj/item/clothing/under/teshari/undercoat/standard/worksuit,
			/obj/item/clothing/under/teshari/undercoat/standard/worksuit/blackpurple,
			/obj/item/clothing/under/teshari/undercoat/standard/worksuit/blackorange,
			/obj/item/clothing/under/teshari/undercoat/standard/worksuit/blackblue,
			/obj/item/clothing/under/teshari/undercoat/standard/worksuit/blackgreen,
			/obj/item/clothing/under/teshari/undercoat/standard/worksuit/whitered,
			/obj/item/clothing/under/teshari/undercoat/standard/worksuit/whitepurple,
			/obj/item/clothing/under/teshari/undercoat/standard/worksuit/whiteorange,
			/obj/item/clothing/under/teshari/undercoat/standard/worksuit/whiteblue,
			/obj/item/clothing/under/teshari/undercoat/standard/worksuit/whitegreen
			)
	cost = 20
	containertype = /obj/structure/closet/crate
	containername = "Teshari worksuits crate"

/datum/supply_pack/randomised/costumes/tesh_beltcloaks_vr
	name = "Teshari cloaks (belted)"
	num_contained = 4
	contains = list(
			/obj/item/clothing/suit/storage/teshari/beltcloak/standard/orange_grey,
			/obj/item/clothing/suit/storage/teshari/beltcloak/standard/rainbow,
			/obj/item/clothing/suit/storage/teshari/beltcloak/standard/lightgrey_grey,
			/obj/item/clothing/suit/storage/teshari/beltcloak/standard/white_grey,
			/obj/item/clothing/suit/storage/teshari/beltcloak/standard/red_grey,
			/obj/item/clothing/suit/storage/teshari/beltcloak/standard/orange,
			/obj/item/clothing/suit/storage/teshari/beltcloak/standard/yellow_grey,
			/obj/item/clothing/suit/storage/teshari/beltcloak/standard/green_grey,
			/obj/item/clothing/suit/storage/teshari/beltcloak/standard/blue_grey,
			/obj/item/clothing/suit/storage/teshari/beltcloak/standard/purple_grey,
			/obj/item/clothing/suit/storage/teshari/beltcloak/standard/pink_grey,
			/obj/item/clothing/suit/storage/teshari/beltcloak/standard/brown_grey
			)
	cost = 40
	containertype = /obj/structure/closet/crate
	containername = "Teshari cloaks crate"

/datum/supply_pack/randomised/costumes/tesh_beltcloaks_b_vr
	name = "Teshari cloaks (belted, black)"
	num_contained = 4
	contains = list(
			/obj/item/clothing/suit/storage/teshari/beltcloak,
			/obj/item/clothing/suit/storage/teshari/beltcloak/standard/black_orange,
			/obj/item/clothing/suit/storage/teshari/beltcloak/standard/black_grey,
			/obj/item/clothing/suit/storage/teshari/beltcloak/standard/black_midgrey,
			/obj/item/clothing/suit/storage/teshari/beltcloak/standard/black_lightgrey,
			/obj/item/clothing/suit/storage/teshari/beltcloak/standard/black_white,
			/obj/item/clothing/suit/storage/teshari/beltcloak/standard/black_red,
			/obj/item/clothing/suit/storage/teshari/beltcloak/standard/black,
			/obj/item/clothing/suit/storage/teshari/beltcloak/standard/black_yellow,
			/obj/item/clothing/suit/storage/teshari/beltcloak/standard/black_green,
			/obj/item/clothing/suit/storage/teshari/beltcloak/standard/black_blue,
			/obj/item/clothing/suit/storage/teshari/beltcloak/standard/black_purple,
			/obj/item/clothing/suit/storage/teshari/beltcloak/standard/black_pink,
			/obj/item/clothing/suit/storage/teshari/beltcloak/standard/black_brown
			)
	cost = 40
	containertype = /obj/structure/closet/crate
	containername = "Teshari cloaks crate"

/datum/supply_pack/randomised/costumes/tesh_hoodcloaks_vr
	name = "Teshari cloaks (hooded)"
	num_contained = 4
	contains = list(
			/obj/item/clothing/suit/storage/hooded/teshari/standard/orange_grey,
			/obj/item/clothing/suit/storage/hooded/teshari/standard/lightgrey_grey,
			/obj/item/clothing/suit/storage/hooded/teshari/standard/white_grey,
			/obj/item/clothing/suit/storage/hooded/teshari/standard/red_grey,
			/obj/item/clothing/suit/storage/hooded/teshari/standard/orange,
			/obj/item/clothing/suit/storage/hooded/teshari/standard/yellow_grey,
			/obj/item/clothing/suit/storage/hooded/teshari/standard/green_grey,
			/obj/item/clothing/suit/storage/hooded/teshari/standard/blue_grey,
			/obj/item/clothing/suit/storage/hooded/teshari/standard/purple_grey,
			/obj/item/clothing/suit/storage/hooded/teshari/standard/pink_grey,
			/obj/item/clothing/suit/storage/hooded/teshari/standard/brown_grey
			)
	cost = 40
	containertype = /obj/structure/closet/crate
	containername = "Teshari cloaks crate"

/datum/supply_pack/randomised/costumes/tesh_hoodcloaks_b_vr
	name = "Teshari cloaks (hooded, black)"
	num_contained = 4
	contains = list(
			/obj/item/clothing/suit/storage/hooded/teshari,
			/obj/item/clothing/suit/storage/hooded/teshari/standard/black_orange,
			/obj/item/clothing/suit/storage/hooded/teshari/standard/black_grey,
			/obj/item/clothing/suit/storage/hooded/teshari/standard/black_midgrey,
			/obj/item/clothing/suit/storage/hooded/teshari/standard/black_lightgrey,
			/obj/item/clothing/suit/storage/hooded/teshari/standard/black_white,
			/obj/item/clothing/suit/storage/hooded/teshari/standard/black_red,
			/obj/item/clothing/suit/storage/hooded/teshari/standard/black,
			/obj/item/clothing/suit/storage/hooded/teshari/standard/black_yellow,
			/obj/item/clothing/suit/storage/hooded/teshari/standard/black_green,
			/obj/item/clothing/suit/storage/hooded/teshari/standard/black_blue,
			/obj/item/clothing/suit/storage/hooded/teshari/standard/black_purple,
			/obj/item/clothing/suit/storage/hooded/teshari/standard/black_pink,
			/obj/item/clothing/suit/storage/hooded/teshari/standard/black_brown
			)
	cost = 40
	containertype = /obj/structure/closet/crate
	containername = "Teshari cloaks crate"

/datum/supply_pack/costumes/utility_vr
	name = "Utility uniforms"
	contains = list(
			/obj/item/clothing/under/utility,
			/obj/item/clothing/under/utility/blue,
			/obj/item/clothing/under/utility/grey
			)
	cost = 30
	containertype = /obj/structure/closet/crate
	containername = "Utility uniforms crate"

/datum/supply_pack/costumes/skirts_vr
	name = "Skirts crate"
	contains = list(
			/obj/item/clothing/under/skirt,
			/obj/item/clothing/under/skirt/blue,
			/obj/item/clothing/under/skirt/denim,
			/obj/item/clothing/under/skirt/khaki,
			/obj/item/clothing/under/skirt/outfit,
			/obj/item/clothing/under/skirt/red,
			/obj/item/clothing/under/skirt/swept,
			/obj/item/clothing/under/skirt/outfit/plaid_blue,
			/obj/item/clothing/under/skirt/outfit/plaid_purple,
			/obj/item/clothing/under/skirt/outfit/plaid_red
			)
	cost = 40
	containertype = /obj/structure/closet/crate
	containername = "Skirts crate"

/datum/supply_pack/costumes/varsity_vr
	name = "Varsity jackets"
	contains = list(
			/obj/item/clothing/suit/varsity,
			/obj/item/clothing/suit/varsity/blue,
			/obj/item/clothing/suit/varsity/brown,
			/obj/item/clothing/suit/varsity/green,
			/obj/item/clothing/suit/varsity/purple,
			/obj/item/clothing/suit/varsity/red
			)
	cost = 60
	containertype = /obj/structure/closet/crate
	containername = "Varsity jackets crate"

/datum/supply_pack/randomised/costumes/leathergear_vr
	name = "Leather gear"
	num_contained = 5
	contains = list(
			/obj/item/clothing/suit/leathercoat,
			/obj/item/clothing/suit/storage/leather_jacket_alt,
			/obj/item/clothing/suit/storage/toggle/leather_jacket,
			/obj/item/clothing/suit/storage/toggle/leather_jacket/sleeveless,
			/obj/item/clothing/suit/storage/toggle/leather_jacket/nanotrasen,
			/obj/item/clothing/suit/storage/toggle/leather_jacket/nanotrasen/sleeveless,
			/obj/item/clothing/under/pants/chaps,
			/obj/item/clothing/under/pants/chaps/black,
			/obj/item/clothing/under/harness,
			/obj/item/clothing/shoes/laceup/brown,
			/obj/item/clothing/shoes/boots/jungle,
			/obj/item/clothing/shoes/boots/jackboots,
			/obj/item/clothing/shoes/boots/cowboy,
			/obj/item/clothing/shoes/boots/cowboy/classic,
			/obj/item/clothing/shoes/boots/cowboy/snakeskin,
			/obj/item/clothing/accessory/chaps,
			/obj/item/clothing/accessory/chaps/black,
			/obj/item/clothing/accessory/collar/spike,
			/obj/item/clothing/gloves/fingerless,
			/obj/item/clothing/gloves/botanic_leather,
			/obj/item/clothing/head/cowboy,
			/obj/item/clothing/head/cowboy/bandit,
			/obj/item/clothing/accessory/cowboy_vest/brown,
			/obj/item/clothing/accessory/cowboy_vest/grey
			)
	cost = 50
	containertype = /obj/structure/closet/crate
	containername = "Leather gear crate"

/datum/supply_pack/costumes/eyewear_vr
	name = "Eyewear crate"
	contains = list(
			/obj/item/clothing/glasses/eyepatch,
			/obj/item/clothing/glasses/fakesunglasses,
			/obj/item/clothing/glasses/fakesunglasses/aviator,
			/obj/item/clothing/glasses/fluff/science_proper,
			/obj/item/clothing/glasses/fluff/spiffygogs,
			/obj/item/clothing/glasses/gglasses,
			/obj/item/clothing/glasses/monocle,
			/obj/item/clothing/glasses/regular,
			/obj/item/clothing/glasses/regular/hipster,
			/obj/item/clothing/glasses/regular/scanners,
			/obj/item/clothing/glasses/threedglasses
			)
	cost = 50
	containertype = /obj/structure/closet/crate
	containername = "Eyewear crate"

/datum/supply_pack/randomised/costumes/gloves_vr
	name = "Gloves crate"
	num_contained = 4
	contains = list(
			/obj/item/clothing/gloves/black,
			/obj/item/clothing/gloves/blue,
			/obj/item/clothing/gloves/botanic_leather,
			/obj/item/clothing/gloves/brown,
			/obj/item/clothing/gloves/evening,
			/obj/item/clothing/gloves/fingerless,
			/obj/item/clothing/gloves/fyellow,
			/obj/item/clothing/gloves/green,
			/obj/item/clothing/gloves/grey,
			/obj/item/clothing/gloves/light_brown,
			/obj/item/clothing/gloves/orange,
			/obj/item/clothing/gloves/purple,
			/obj/item/clothing/gloves/rainbow,
			/obj/item/clothing/gloves/red,
			/obj/item/clothing/gloves/white
			)
	cost = 40
	containertype = /obj/structure/closet/crate
	containername = "Gloves crate"

/datum/supply_pack/randomised/costumes/boots_vr
	name = "Boots crate"
	num_contained = 3
	contains = list(
			/obj/item/clothing/shoes/boots/workboots,
			/obj/item/clothing/shoes/boots/cowboy,
			/obj/item/clothing/shoes/boots/cowboy/classic,
			/obj/item/clothing/shoes/boots/cowboy/snakeskin,
			/obj/item/clothing/shoes/boots/duty,
			/obj/item/clothing/shoes/boots/jackboots,
			/obj/item/clothing/shoes/boots/jungle,
			/obj/item/clothing/shoes/boots/winter
			)
	cost = 60
	containertype = /obj/structure/closet/crate
	containername = "Boots crate"

/datum/supply_pack/costumes/taurbags
	name = "Saddlebags crate"
	contains = list(
			/obj/item/weapon/storage/backpack/saddlebag_common,
			/obj/item/weapon/storage/backpack/saddlebag_common/robust,
			/obj/item/weapon/storage/backpack/saddlebag_common/vest
			)
	cost = 60
	containertype = /obj/structure/closet/crate
	containername = "Saddlebags crate"

/datum/supply_pack/costumes/knights_gear
	name = "Knights Gear"
	contains = list(
			/obj/item/clothing/suit/storage/hooded/knight_costume,
			/obj/item/clothing/suit/storage/hooded/knight_costume/galahad,
			/obj/item/clothing/suit/storage/hooded/knight_costume/lancelot,
			/obj/item/clothing/suit/storage/hooded/knight_costume/robin,
			/obj/item/clothing/suit/armor/combat/crusader_costume,
			/obj/item/clothing/suit/armor/combat/crusader_costume/bedevere,
			/obj/item/clothing/head/helmet/combat/crusader_costume,
			/obj/item/clothing/head/helmet/combat/bedevere_costume,
			/obj/item/clothing/gloves/combat/knight_costume,
			/obj/item/clothing/gloves/combat/knight_costume/brown,
			/obj/item/clothing/shoes/knight_costume,
			/obj/item/clothing/shoes/knight_costume/black
			)
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "Knights Gear Crate"

/datum/supply_pack/costumes/christmas
	name = "Christmas costume pack"
	contains = list(
			/obj/item/clothing/head/santa,
			/obj/item/clothing/head/santa/green,
			/obj/item/clothing/suit/storage/hooded/wintercoat/christmasred,
			/obj/item/clothing/suit/storage/hooded/wintercoat/christmasgreen,
			/obj/item/clothing/under/christmas/red,
			/obj/item/clothing/under/christmas/green,
			/obj/item/clothing/under/christmas/croptop/red,
			/obj/item/clothing/under/christmas/croptop/green,
			/obj/item/clothing/shoes/boots/winter/christmasred,
			/obj/item/clothing/shoes/boots/winter/christmasgreen
			)
	cost = 20
	containertype = /obj/structure/closet/crate
	containername = "Christmas costume pack"
