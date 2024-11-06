/obj/structure/closet/wardrobe
	name = "wardrobe"
	desc = "It's a storage unit for standard-issue attire."
	closet_appearance = /decl/closet_appearance/wardrobe

/obj/structure/closet/wardrobe/red
	name = "security wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/red

	starts_with = list(
		/obj/item/clothing/under/rank/security = 3,
		/obj/item/clothing/under/rank/security2 = 3,
		/obj/item/clothing/under/rank/security/turtleneck = 3,
		/obj/item/clothing/under/rank/security/skirt = 2,
		/obj/item/clothing/shoes/boots/jackboots = 3,
		/obj/item/clothing/head/soft/sec = 3,
		/obj/item/clothing/head/beret/sec = 3,
		/obj/item/clothing/head/beret/sec/corporate/officer = 3,
		/obj/item/clothing/mask/bandana/red = 3,
		/obj/item/clothing/suit/storage/hooded/wintercoat/security = 3,
		/obj/item/clothing/accessory/armband = 3,
		/obj/item/clothing/accessory/holster/waist = 3)

/obj/structure/closet/wardrobe/red/Initialize()
	if(prob(50))
		starts_with += /obj/item/storage/backpack/security
	else
		starts_with += /obj/item/storage/backpack/satchel/sec
	if(prob(50))
		starts_with += /obj/item/storage/backpack/security
	else
		starts_with += /obj/item/storage/backpack/satchel/sec
	if(prob(50))
		starts_with += /obj/item/storage/backpack/security
	else
		starts_with += /obj/item/storage/backpack/satchel/sec

	return ..()

/obj/structure/closet/wardrobe/detective
	name = "detective wardrobe"
	closet_appearance = /decl/closet_appearance/cabinet

	open_sound = 'sound/effects/wooden_closet_open.ogg'
	close_sound = 'sound/effects/wooden_closet_close.ogg'

	starts_with = list(
		/obj/item/clothing/head/det = 2,
		/obj/item/clothing/head/det/grey = 2,
		/obj/item/clothing/shoes/brown = 2,
		/obj/item/clothing/shoes/laceup = 2,
		/obj/item/clothing/under/det = 2,
		/obj/item/clothing/under/det/waistcoat = 2,
		/obj/item/clothing/under/det/grey = 2,
		/obj/item/clothing/under/det/grey/waistcoat = 2,
		/obj/item/clothing/under/det/black = 2,
		/obj/item/clothing/under/det/skirt,
		/obj/item/clothing/under/det/corporate = 2,
		/obj/item/clothing/suit/storage/det_trench = 2,
		/obj/item/clothing/suit/storage/det_trench/grey = 2,
		/obj/item/clothing/suit/storage/forensics/blue = 2,
		/obj/item/clothing/suit/storage/forensics/red = 2)

/obj/structure/closet/wardrobe/pink
	name = "pink wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/pink

	starts_with = list(
		/obj/item/clothing/under/color/pink = 3,
		/obj/item/clothing/shoes/brown = 3)

/obj/structure/closet/wardrobe/black
	name = "black wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/black

	starts_with = list(
		/obj/item/clothing/under/color/black = 3,
		/obj/item/clothing/shoes/black = 3,
		/obj/item/clothing/head/that = 3,
		/obj/item/clothing/head/soft/black = 3,
		/obj/item/clothing/mask/bandana = 3,
		/obj/item/storage/backpack/messenger/black)


/obj/structure/closet/wardrobe/chaplain_black
	name = "chapel wardrobe"
	desc = "It's a storage unit for approved religious attire."
	closet_appearance = /decl/closet_appearance/wardrobe/chapel

	starts_with = list(
		/obj/item/clothing/under/rank/chaplain,
		/obj/item/clothing/shoes/black,
		/obj/item/clothing/suit/nun,
		/obj/item/clothing/head/nun_hood,
		/obj/item/clothing/suit/storage/hooded/chaplain_hoodie,
		/obj/item/clothing/suit/storage/hooded/chaplain_hoodie/whiteout,
		/obj/item/clothing/suit/holidaypriest,
		/obj/item/clothing/under/wedding/bride_white,
		/obj/item/storage/backpack/cultpack,
		/obj/item/storage/fancy/candle_box = 2,
		/obj/item/storage/fancy/whitecandle_box,
		/obj/item/storage/fancy/blackcandle_box,
		/obj/item/godfig = 2,
		/obj/item/deck/tarot)


/obj/structure/closet/wardrobe/green
	name = "green wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/green

	starts_with = list(
		/obj/item/clothing/under/color/green = 3,
		/obj/item/clothing/shoes/green = 3,
		/obj/item/clothing/head/soft/green = 3,
		/obj/item/clothing/mask/bandana/green = 3)

/obj/structure/closet/wardrobe/xenos
	name = "xenos wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/xenos

	starts_with = list(
		/obj/item/clothing/suit/unathi/mantle,
		/obj/item/clothing/suit/unathi/robe,
		/obj/item/clothing/shoes/sandal = 2,
		/obj/item/clothing/shoes/footwraps = 2,
		/obj/item/clothing/shoes/boots/winter = 2,
		/obj/item/clothing/suit/storage/hooded/wintercoat = 2)


/obj/structure/closet/wardrobe/orange
	name = "prison wardrobe"
	desc = "It's a storage unit for regulation prisoner attire."
	closet_appearance = /decl/closet_appearance/wardrobe/orange

	starts_with = list(
		/obj/item/clothing/under/color/prison = 3,
		/obj/item/clothing/shoes/orange = 3)


/obj/structure/closet/wardrobe/yellow
	name = "yellow wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/yellow

	starts_with = list(
		/obj/item/clothing/under/color/yellow = 3,
		/obj/item/clothing/shoes/yellow = 3,
		/obj/item/clothing/head/soft/yellow = 3,
		/obj/item/clothing/mask/bandana/gold = 3)


/obj/structure/closet/wardrobe/atmospherics_yellow
	name = "atmospherics wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/engineer/atmos

	starts_with = list(
		/obj/item/clothing/under/rank/atmospheric_technician = 3,
		/obj/item/clothing/under/rank/atmospheric_technician/skirt = 3,
		/obj/item/clothing/shoes/black = 3,
		/obj/item/clothing/head/hardhat/red = 3,
		/obj/item/clothing/head/beret/engineering = 3,
		/obj/item/clothing/mask/bandana/gold = 3,
		/obj/item/clothing/suit/storage/hooded/wintercoat/engineering/atmos = 3,
		/obj/item/clothing/shoes/boots/winter/atmos = 3)

/obj/structure/closet/wardrobe/engineering_yellow
	name = "engineering wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/engineer

	starts_with = list(
		/obj/item/clothing/under/rank/engineer = 3,
		/obj/item/clothing/under/rank/engineer/skirt = 3,
		/obj/item/clothing/under/rank/engineer/turtleneck = 3,
		/obj/item/clothing/shoes/orange = 3,
		/obj/item/clothing/head/hardhat = 3,
		/obj/item/clothing/head/beret/engineering = 3,
		/obj/item/clothing/mask/bandana/gold = 3,
		/obj/item/clothing/suit/storage/hooded/wintercoat/engineering = 3,
		/obj/item/clothing/shoes/boots/winter/engineering = 3,
		/obj/item/clothing/shoes/boots/workboots = 3)


/obj/structure/closet/wardrobe/white
	name = "white wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/white

	starts_with = list(
		/obj/item/clothing/under/color/white = 3,
		/obj/item/clothing/shoes/white = 3,
		/obj/item/clothing/head/soft/mime = 3)


/obj/structure/closet/wardrobe/pjs
	name = "pajama wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/pjs

	starts_with = list(
		/obj/item/clothing/under/pj/red = 2,
		/obj/item/clothing/under/pj/blue = 2,
		/obj/item/clothing/shoes/white = 2,
		/obj/item/clothing/shoes/slippers = 2)


/obj/structure/closet/wardrobe/science_white
	name = "science wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/science

	starts_with = list(
		/obj/item/clothing/under/rank/scientist = 3,
		/obj/item/clothing/under/rank/scientist/skirt = 2,
		/obj/item/clothing/under/rank/scientist/turtleneck = 3,
		/obj/item/clothing/suit/storage/toggle/labcoat = 3,
		/obj/item/clothing/suit/storage/toggle/labcoat/modern = 3,
		/obj/item/clothing/shoes/white = 3,
		/obj/item/clothing/shoes/slippers = 3,
		/obj/item/clothing/suit/storage/hooded/wintercoat/science,
		/obj/item/clothing/shoes/boots/winter/science,
		/obj/item/storage/backpack/toxins,
		/obj/item/storage/backpack/satchel/tox)

/obj/structure/closet/wardrobe/science_white/Initialize()
	if(prob(50))
		starts_with += /obj/item/storage/backpack/dufflebag/sci
	else
		starts_with += /obj/item/storage/backpack/satchel/tox
	if(prob(50))
		starts_with += /obj/item/storage/backpack/dufflebag/sci
	else
		starts_with += /obj/item/storage/backpack/satchel/tox

	return ..()


/obj/structure/closet/wardrobe/robotics_black
	name = "robotics wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/robotics

	starts_with = list(
		/obj/item/clothing/under/rank/roboticist = 2,
		/obj/item/clothing/suit/storage/toggle/labcoat = 2,
		/obj/item/clothing/suit/storage/hooded/wintercoat/science/robotics,
		/obj/item/clothing/shoes/black = 2,
		/obj/item/clothing/gloves/black = 2,
		/obj/item/storage/backpack/toxins,
		/obj/item/storage/backpack/satchel/tox)

/obj/structure/closet/wardrobe/robotics_black/Initialize()
	if(prob(50))
		starts_with += /obj/item/storage/backpack/dufflebag/sci
	else
		starts_with += /obj/item/storage/backpack/satchel/tox

	return ..()


/obj/structure/closet/wardrobe/chemistry_white
	name = "chemistry wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/medical/chemistry

	starts_with = list(
		/obj/item/clothing/under/rank/chemist = 2,
		/obj/item/clothing/under/rank/chemist/skirt = 2,
		/obj/item/clothing/shoes/white = 2,
		/obj/item/clothing/suit/storage/toggle/labcoat/chemist = 2,
		/obj/item/clothing/suit/storage/hooded/wintercoat/medical/chemist,
		/obj/item/storage/backpack/chemistry = 2,
		/obj/item/storage/backpack/satchel/chem = 2,
		/obj/item/storage/bag/chemistry = 2,)


/obj/structure/closet/wardrobe/genetics_white
	name = "genetics wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/medical/genetics

	starts_with = list(
		/obj/item/clothing/under/rank/geneticist = 2,
		/obj/item/clothing/under/rank/geneticist/skirt = 2,
		/obj/item/clothing/shoes/white = 2,
		/obj/item/clothing/suit/storage/toggle/labcoat/genetics = 2,
		/obj/item/storage/backpack/genetics = 2,
		/obj/item/storage/backpack/satchel/gen = 2)


/obj/structure/closet/wardrobe/virology_white
	name = "virology wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/medical/virology

	starts_with = list(
		/obj/item/clothing/under/rank/virologist = 2,
		/obj/item/clothing/under/rank/virologist/skirt = 2,
		/obj/item/clothing/shoes/white = 2,
		/obj/item/clothing/suit/storage/toggle/labcoat/virologist = 2,
		/obj/item/clothing/suit/storage/hooded/wintercoat/medical/viro,
		/obj/item/clothing/mask/surgical = 2,
		/obj/item/storage/backpack/virology = 2,
		/obj/item/storage/backpack/satchel/vir = 2)


/obj/structure/closet/wardrobe/medic_white
	name = "medical wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/medical/white

	starts_with = list(
		/obj/item/clothing/under/rank/medical = 2,
		/obj/item/clothing/under/rank/medical/skirt = 2,
		/obj/item/clothing/under/rank/medical/turtleneck = 2,
		/obj/item/clothing/under/rank/medical/scrubs,
		/obj/item/clothing/under/rank/medical/scrubs/green,
		/obj/item/clothing/under/rank/medical/scrubs/purple,
		/obj/item/clothing/under/rank/medical/scrubs/black,
		/obj/item/clothing/under/rank/medical/scrubs/navyblue,
		/obj/item/clothing/head/surgery/navyblue,
		/obj/item/clothing/head/surgery/purple,
		/obj/item/clothing/head/surgery/blue,
		/obj/item/clothing/head/surgery/green,
		/obj/item/clothing/head/surgery/black,
		/obj/item/clothing/shoes/white = 2,
		/obj/item/clothing/suit/storage/toggle/labcoat = 2,
		/obj/item/clothing/mask/surgical = 2,
		/obj/item/clothing/suit/storage/hooded/wintercoat/medical = 2,
		/obj/item/clothing/shoes/boots/winter/medical = 2)


/obj/structure/closet/wardrobe/medic_gown
	name = "cloning wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/medical/patient

	starts_with = list(
		/obj/item/clothing/under/medigown = 4)


/obj/structure/closet/wardrobe/grey
	name = "grey wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/grey

	starts_with = list(
		/obj/item/clothing/under/color/grey = 3,
		/obj/item/clothing/shoes/black = 3,
		/obj/item/clothing/head/soft/grey = 3)


/obj/structure/closet/wardrobe/mixed
	name = "mixed wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/mixed

	starts_with = list(
		/obj/item/clothing/under/color/blue,
		/obj/item/clothing/under/color/yellow,
		/obj/item/clothing/under/color/green,
		/obj/item/clothing/under/color/pink,
		/obj/item/clothing/under/skirt/outfit/plaid_blue,
		/obj/item/clothing/under/skirt/outfit/plaid_red,
		/obj/item/clothing/under/skirt/outfit/plaid_purple,
		/obj/item/clothing/shoes/blue,
		/obj/item/clothing/shoes/yellow,
		/obj/item/clothing/shoes/green,
		/obj/item/clothing/shoes/purple,
		/obj/item/clothing/shoes/red,
		/obj/item/clothing/shoes/laceup/brown,
		/obj/item/clothing/under/pants/classicjeans,
		/obj/item/clothing/under/pants/mustangjeans,
		/obj/item/clothing/under/pants/blackjeans,
		/obj/item/clothing/under/pants/youngfolksjeans,
		/obj/item/clothing/under/pants/white,
		/obj/item/clothing/under/pants/red,
		/obj/item/clothing/under/pants/black,
		/obj/item/clothing/under/pants/tan,
		/obj/item/clothing/under/pants/track,
		/obj/item/clothing/suit/storage/toggle/track,
		/obj/item/clothing/under/pants,
		/obj/item/clothing/under/pants/khaki,
		/obj/item/clothing/mask/bandana/blue,
		/obj/item/clothing/mask/bandana/blue,
		/obj/item/clothing/accessory/hawaiian,
		/obj/item/clothing/accessory/hawaiian/blue,
		/obj/item/clothing/accessory/hawaiian/pink,
		/obj/item/clothing/accessory/hawaiian/red,
		/obj/item/clothing/accessory/hawaiian/yellow)


/obj/structure/closet/wardrobe/tactical
	name = "tactical equipment"
	closet_appearance = /decl/closet_appearance/tactical

	starts_with = list(
		/obj/item/clothing/under/tactical,
		/obj/item/clothing/suit/armor/tactical,
		/obj/item/clothing/head/helmet/tactical,
		/obj/item/clothing/mask/balaclava/tactical,
		/obj/item/clothing/mask/balaclava,
		/obj/item/clothing/glasses/sunglasses/sechud/tactical,
		/obj/item/clothing/shoes/boots/jackboots,
		/obj/item/clothing/gloves/black,
		/obj/item/clothing/under/pants/camo)

/obj/structure/closet/wardrobe/tactical/Initialize()
	if(prob(25))
		starts_with += /obj/item/storage/belt/security/tactical/bandolier
	else
		starts_with += /obj/item/storage/belt/security/tactical
	if(prob(10))
		starts_with += /obj/item/clothing/mask/bandana/skull

	return ..()

/obj/structure/closet/wardrobe/ert
	name = "emergency response team equipment"
	closet_appearance = /decl/closet_appearance/ert

	starts_with = list(
		/obj/item/clothing/under/rank/centcom,
		/obj/item/clothing/under/ert,
		/obj/item/clothing/under/syndicate/combat,
		/obj/item/radio/headset/ert/alt,
		/obj/item/clothing/glasses/sunglasses,
		/obj/item/clothing/shoes/boots/swat,
		/obj/item/clothing/gloves/swat,
		/obj/item/clothing/mask/balaclava/tactical,
		/obj/item/clothing/mask/balaclava,
		/obj/item/clothing/mask/bandana/skull = 2,
		/obj/item/clothing/mask/gas/sechailer/swat)


/obj/structure/closet/wardrobe/suit
	name = "suit locker"
	closet_appearance = /decl/closet_appearance/wardrobe/suit

	starts_with = list(
		/obj/item/clothing/under/assistantformal,
		/obj/item/clothing/under/suit_jacket/charcoal,
		/obj/item/clothing/under/suit_jacket/charcoal/skirt,
		/obj/item/clothing/under/suit_jacket/navy,
		/obj/item/clothing/under/suit_jacket/navy/skirt,
		/obj/item/clothing/under/suit_jacket/burgundy,
		/obj/item/clothing/under/suit_jacket/burgundy/skirt,
		/obj/item/clothing/under/suit_jacket/checkered,
		/obj/item/clothing/under/suit_jacket/checkered/skirt,
		/obj/item/clothing/under/suit_jacket/tan,
		/obj/item/clothing/under/suit_jacket/tan/skirt,
		/obj/item/clothing/under/sl_suit,
		/obj/item/clothing/under/suit_jacket,
		/obj/item/clothing/under/suit_jacket/female,
		/obj/item/clothing/under/suit_jacket/female/skirt,
		/obj/item/clothing/under/suit_jacket/really_black,
		/obj/item/clothing/under/suit_jacket/really_black/skirt,
		/obj/item/clothing/under/suit_jacket/red,
		/obj/item/clothing/under/suit_jacket/red/skirt,
		/obj/item/clothing/under/scratch,
		/obj/item/clothing/under/scratch/skirt,
		/obj/item/storage/backpack/satchel = 2)

/obj/structure/closet/wardrobe/captain
	name = "site manager's wardrobe"
	closet_appearance = /decl/closet_appearance/cabinet

	open_sound = 'sound/effects/wooden_closet_open.ogg'
	close_sound = 'sound/effects/wooden_closet_close.ogg'

	starts_with = list(
		/obj/item/storage/backpack/captain,
		/obj/item/clothing/suit/captunic,
		/obj/item/clothing/suit/captunic/capjacket,
		/obj/item/clothing/head/caphat/cap,
		/obj/item/clothing/head/caphat/beret,
		/obj/item/clothing/under/rank/captain,
		/obj/item/clothing/under/dress/dress_cap/femformal,
		/obj/item/clothing/under/rank/neo_captain_parade,
		/obj/item/clothing/under/rank/neo_captain_skirt,
		/obj/item/clothing/under/rank/neo_captain,
		/obj/item/clothing/under/rank/neo_captain_kilt,
		/obj/item/clothing/under/rank/neo_captain_blacksuit,
		/obj/item/clothing/under/rank/neo_commandutil,
		/obj/item/clothing/shoes/brown,
		/obj/item/clothing/gloves/captain,
		/obj/item/clothing/under/dress/dress_cap,
		/obj/item/storage/backpack/satchel/cap,
		/obj/item/clothing/head/caphat/formal,
		/obj/item/clothing/under/captainformal,
		/obj/item/clothing/suit/storage/hooded/wintercoat/captain,
		/obj/item/clothing/shoes/boots/winter/command,
		/obj/item/clothing/head/beret/centcom/captain,
		/obj/item/clothing/under/suit_jacket/green,
		/obj/item/clothing/under/suit_jacket/green/skirt,
		/obj/item/clothing/glasses/sunglasses,
		/obj/item/clothing/head/caphat)
