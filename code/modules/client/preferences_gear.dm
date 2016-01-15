var/global/list/gear_datums = list()

/hook/startup/proc/populate_gear_list()
	var/list/sort_categories = list(
		"[slot_head]"		= list(),
		"ears"				= list(),
		"[slot_glasses]" 	= list(),
		"[slot_wear_mask]"	= list(),
		"[slot_w_uniform]"	= list(),
		"[slot_tie]"		= list(),
		"[slot_wear_suit]"	= list(),
		"[slot_gloves]"		= list(),
		"[slot_shoes]"		= list(),
		"utility"			= list(),
		"misc"				= list(),
		"unknown"			= list(),
	)

	//create a list of gear datums to sort
	for(var/type in typesof(/datum/gear)-/datum/gear)
		var/datum/gear/G = new type()

		var/category = (G.sort_category in sort_categories)? G.sort_category : "unknown"
		sort_categories[category][G.display_name] = G

	for (var/category in sort_categories)
		gear_datums.Add(sortAssoc(sort_categories[category]))

	return 1

/datum/gear
	var/display_name       //Name/index. Must be unique.
	var/path               //Path to item.
	var/cost               //Number of points used. Items in general cost 1 point, storage/armor/gloves/special use costs 2 points.
	var/slot               //Slot to equip to.
	var/list/allowed_roles //Roles that can spawn with this item.
	var/whitelisted        //Term to check the whitelist for..
	var/sort_category

/datum/gear/New()
	..()
	if (!sort_category)
		sort_category = "[slot]"

// This is sorted both by slot and alphabetically! Don't fuck it up!
// Headslot items

/datum/gear/bandana
	display_name = "bandana, pirate-red"
	path = /obj/item/clothing/head/bandana
	cost = 1
	slot = slot_head

/datum/gear/bandana/green
	display_name = "bandana, green"
	path = /obj/item/clothing/head/greenbandana

/datum/gear/bandana/orange
	display_name = "bandana, orange"
	path = /obj/item/clothing/head/orangebandana

/datum/gear/beret
	display_name = "beret, red"
	path = /obj/item/clothing/head/beret
	cost = 1
	slot = slot_head

/datum/gear/beret/bsec
	display_name = "beret, navy (officer)"
	path = /obj/item/clothing/head/beret/sec/navy/officer
	allowed_roles = list("Security Officer","Head of Security","Warden")

/datum/gear/beret/bsec_warden
	display_name = "beret, navy (warden)"
	path = /obj/item/clothing/head/beret/sec/navy/warden
	allowed_roles = list("Head of Security","Warden")

/datum/gear/beret/bsec_hos
	display_name = "beret, navy (hos)"
	path = /obj/item/clothing/head/beret/sec/navy/hos
	allowed_roles = list("Head of Security")

/datum/gear/beret/eng
	display_name = "beret, engie-orange"
	path = /obj/item/clothing/head/beret/engineering
//	allowed_roles = list("Station Engineer","Atmospheric Technician","Chief Engineer")

/datum/gear/beret/purp
	display_name = "beret, purple"
	path = /obj/item/clothing/head/beret/purple

/datum/gear/beret/sec
	display_name = "beret, red (security)"
	path = /obj/item/clothing/head/beret/sec
	allowed_roles = list("Security Officer","Head of Security","Warden")

/datum/gear/cap
	display_name = "cap, black"
	path = /obj/item/clothing/head/soft/black
	cost = 1
	slot = slot_head

/datum/gear/cap/blue
	display_name = "cap, blue"
	path = /obj/item/clothing/head/soft/blue

/datum/gear/cap/mailman
	display_name = "cap, blue station"
	path = /obj/item/clothing/head/mailman

/datum/gear/cap/flat
	display_name = "cap, brown-flat"
	path = /obj/item/clothing/head/flatcap

/datum/gear/cap/corp
	display_name = "cap, corporate (Security)"
	path = /obj/item/clothing/head/soft/sec/corp
	allowed_roles = list("Security Officer","Head of Security","Warden", "Detective")

/datum/gear/cap/green
	display_name = "cap, green"
	path = /obj/item/clothing/head/soft/green

 /datum/gear/cap/grey
	display_name = "cap, grey"
	path = /obj/item/clothing/head/soft/grey

 /datum/gear/cap/orange
	display_name = "cap, orange"
	path = /obj/item/clothing/head/soft/orange

/datum/gear/cap/orange
	display_name = "cap, purple"
	path = /obj/item/clothing/head/soft/purple

/datum/gear/cap/rainbow
	display_name = "cap, rainbow"
	path = /obj/item/clothing/head/soft/rainbow

/datum/gear/cap/red
	display_name = "cap, red"
	path = /obj/item/clothing/head/soft/red

/datum/gear/cap/sec
	display_name = "cap, security (Security)"
	path = /obj/item/clothing/head/soft/sec
	allowed_roles = list("Security Officer","Head of Security","Warden", "Detective")

/datum/gear/cap/yellow
	display_name = "cap, yellow"
	path = /obj/item/clothing/head/soft/yellow

/datum/gear/cap/white
	display_name = "cap, white"
	path = /obj/item/clothing/head/soft/mime

/datum/gear/cowboy
	display_name = "cowboy, rodeo"
	path = /obj/item/clothing/head/cowboy_hat
	cost = 3
	slot = slot_head

/datum/gear/hairflower
	display_name = "hair flower pin, red"
	path = /obj/item/clothing/head/hairflower
	cost = 1
	slot = slot_head

/datum/gear/hairflower/yellow
	display_name = "hair flower pin, yellow"
	path = /obj/item/clothing/head/hairflower/yellow

/datum/gear/hairflower/pink
	display_name = "hair flower pin, pink"
	path = /obj/item/clothing/head/hairflower/pink

/datum/gear/hairflower/blue
	display_name = "hair flower pin, blue"
	path = /obj/item/clothing/head/hairflower/blue

/datum/gear/hairflower/violet
	display_name = "hair flower pin, violet"
	path = /obj/item/clothing/head/hairflower/violet

/datum/gear/hairflower/orange
	display_name = "hair flower pin, orange"
	path = /obj/item/clothing/head/hairflower/orange

/datum/gear/hardhat
	display_name = "hardhat, yellow"
	path = /obj/item/clothing/head/hardhat
	cost = 2
	slot = slot_head

/datum/gear/hardhat/blue
	display_name = "hardhat, blue"
	path = /obj/item/clothing/head/hardhat/dblue

/datum/gear/hardhat/orange
	display_name = "hardhat, orange"
	path = /obj/item/clothing/head/hardhat/orange

/datum/gear/hardhat/red
	display_name = "hardhat, red"
	path = /obj/item/clothing/head/hardhat/red

/datum/gear/boater
	display_name = "hat, boatsman"
	path = /obj/item/clothing/head/boaterhat
	cost = 1
	slot = slot_head

 /datum/gear/bowler
	display_name = "hat, bowler"
	path = /obj/item/clothing/head/bowler
	cost = 1
	slot = slot_head

/datum/gear/fez
	display_name = "hat, fez"
	path = /obj/item/clothing/head/fez
	cost = 1
	slot = slot_head

/datum/gear/tophat
	display_name = "hat, tophat"
	path = /obj/item/clothing/head/that
	cost = 1
	slot = slot_head

// Wig by Earthcrusher, blame him.
/datum/gear/philosopher_wig
	display_name = "natural philosopher's wig"
	path = /obj/item/clothing/head/philosopher_wig
	cost = 1
	slot = slot_head

/datum/gear/ushanka
	display_name = "ushanka"
	path = /obj/item/clothing/head/ushanka
	cost = 1
	slot = slot_head

/datum/gear/santahat
	display_name = "santa hat, red (holiday)"
	path = /obj/item/clothing/head/santa
	cost = 11
	slot = slot_head

/datum/gear/santahat/green
	display_name = "santa hat, green (holiday)"
	path = /obj/item/clothing/head/santa/green

// This was sprited and coded specifically for Zhan-Khazan characters. Before you
// decide that it's 'not even Taj themed' maybe you should read the wiki, gamer. ~ Z
/datum/gear/zhan_scarf
	display_name = "Zhan headscarf"
	path = /obj/item/clothing/head/tajaran/scarf
	cost = 1
	slot = slot_head
	whitelisted = "Tajara"

// Eyes

/datum/gear/eyepatch
	display_name = "eyepatch"
	path = /obj/item/clothing/glasses/eyepatch
	cost = 1
	slot = slot_glasses

/datum/gear/glasses
	display_name = "Glasses, prescription"
	path = /obj/item/clothing/glasses/regular
	cost = 1
	slot = slot_glasses

/datum/gear/glasses/green
	display_name = "Glasses, green"
	path = /obj/item/clothing/glasses/gglasses

/datum/gear/glasses/prescriptionhipster
	display_name = "Glasses, hipster"
	path = /obj/item/clothing/glasses/regular/hipster

/datum/gear/glasses/monocle
	display_name = "Monocle"
	path = /obj/item/clothing/glasses/monocle

/datum/gear/scanning_goggles
	display_name = "scanning goggles"
	path = /obj/item/clothing/glasses/regular/scanners
	cost = 1
	slot = slot_glasses

/datum/gear/sciencegoggles
	display_name = "Science Goggles"
	path = /obj/item/clothing/glasses/science
	cost = 1
	slot = slot_glasses

/datum/gear/security
	display_name = "Security HUD"
	path = /obj/item/clothing/glasses/hud/security
	cost = 1
	slot = slot_glasses
	allowed_roles = list("Security Officer","Head of Security","Warden")

/datum/gear/prescriptionsec
	display_name = "Security HUD, prescription"
	path = /obj/item/clothing/glasses/hud/security/prescription
	cost = 1
	slot = slot_glasses
	allowed_roles = list("Security Officer","Head of Security","Warden")

/datum/gear/prescriptionmed
	display_name = "Medical HUD, prescription"
	path = /obj/item/clothing/glasses/hud/health/prescription
	cost = 1
	slot = slot_glasses
	allowed_roles = list("Medical Doctor","Chief Medical Officer","Chemist","Paramedic","Geneticist")

/datum/gear/thugshades
	display_name = "Sunglasses, Fat"
	path = /obj/item/clothing/glasses/sunglasses/big
	cost = 1
	slot = slot_glasses
	allowed_roles = list("Security Officer","Head of Security","Warden","Captain","Head of Personnel","Quartermaster","Internal Affairs Agent","Detective")

/datum/gear/prescriptionsun
	display_name = "sunglasses, presciption"
	path = /obj/item/clothing/glasses/sunglasses/prescription
	cost = 2
	slot = slot_glasses
	allowed_roles = list("Security Officer","Head of Security","Warden","Captain","Head of Personnel","Quartermaster","Internal Affairs Agent","Detective")

// Mask

/datum/gear/bandanamask
	display_name = "bandana, blue"
	path = /obj/item/clothing/mask/bandana/blue
	cost = 1
	slot = slot_wear_mask

/datum/gear/bandanamask/gold
	display_name = "bandana, gold"
	path = /obj/item/clothing/mask/bandana/gold

/datum/gear/bandanamask/green
	display_name = "bandana, green 2"
	path = /obj/item/clothing/mask/bandana/green

/datum/gear/bandanamask/red
	display_name = "bandana, red"
	path = /obj/item/clothing/mask/bandana/red

/datum/gear/bandanamask/ipc_monitor
	display_name = "display monitor (prosthetic head only)"
	path = /obj/item/clothing/mask/monitor

/datum/gear/sterilemask
	display_name = "sterile mask"
	path = /obj/item/clothing/mask/surgical
	slot = slot_wear_mask
	cost = 2

// Uniform slot

/datum/gear/blazer_blue
	display_name = "blazer, blue"
	path = /obj/item/clothing/under/blazer
	slot = slot_w_uniform
	cost = 1

/datum/gear/cheongsam
	display_name = "cheongsam, white"
	path = /obj/item/clothing/under/cheongsam
	slot = slot_w_uniform
	cost = 1

/datum/gear/kilt
	display_name = "kilt"
	path = /obj/item/clothing/under/kilt
	slot = slot_w_uniform
	cost = 1

/datum/gear/croptop
	display_name = "croptop, NT"
	path = /obj/item/clothing/under/croptop
	slot = slot_w_uniform
	cost = 1

/datum/gear/croptop/grey
	display_name = "croptop, grey"
	path = /obj/item/clothing/under/croptop/grey

/datum/gear/croptop/red
	display_name = "croptop, red"
	path = /obj/item/clothing/under/croptop/red

/datum/gear/cuttop
	display_name = "cut top, grey"
	path = /obj/item/clothing/under/cuttop
	slot = slot_w_uniform
	cost = 1

/datum/gear/harness
	display_name = "gear harness (Full Body Prosthetic, Dionaea)"
	path = /obj/item/clothing/under/harness
	slot = slot_w_uniform
	cost = 1

/datum/gear/cuttop/red
	display_name = "cut top, red"
	path = /obj/item/clothing/under/cuttop/red

/datum/gear/blackfjumpsuit
	display_name = "jumpsuit, female-black"
	path = /obj/item/clothing/under/color/blackf
	slot = slot_w_uniform
	cost = 1

/datum/gear/jumpskirt
	display_name = "jumpskirt, black"
	path = /obj/item/clothing/under/blackjumpskirt
	slot = slot_w_uniform
	cost = 1

/datum/gear/jumpsuit  //I know, evil bastard am I for making the parent the rainbow jumpsuit. ~Sin.
	display_name = "jumpsuit, rainbow"
	path = /obj/item/clothing/under/rainbow
	slot = slot_w_uniform
	cost = 1

/datum/gear/jumpsuit/blue
	display_name = "jumpsuit, blue"
	path = /obj/item/clothing/under/color/blue

/datum/gear/jumpsuit/green
	display_name = "jumpsuit, green"
	path = /obj/item/clothing/under/color/green

/datum/gear/jumpsuit/grey
	display_name = "jumpsuit, grey"
	path = /obj/item/clothing/under/color/grey

/datum/gear/jumpsuit/pink
	display_name = "jumpsuit, pink"
	path = /obj/item/clothing/under/color/pink

/datum/gear/jumpsuit/white
	display_name = "jumpsuit, white"
	path = /obj/item/clothing/under/color/white

/datum/gear/jumpsuit/yellow
	display_name = "jumpsuit, yellow"
	path = /obj/item/clothing/under/color/yellow

/datum/gear/jumpsuit/lightblue
	display_name = "jumpsuit, lightblue"
	path = /obj/item/clothing/under/lightblue

/datum/gear/jumpsuit/red
	display_name = "jumpsuit, red"
	path = /obj/item/clothing/under/color/red

/datum/gear/skirt
	display_name = "plaid skirt, blue"
	path = /obj/item/clothing/under/dress/plaid_blue
	slot = slot_w_uniform
	cost = 1

/datum/gear/skirt/purple
	display_name = "plaid skirt, purple"
	path = /obj/item/clothing/under/dress/plaid_purple

/datum/gear/skirt/red
	display_name = "plaid skirt, red"
	path = /obj/item/clothing/under/dress/plaid_red

/datum/gear/skirt/black
	display_name = "skirt, black"
	path = /obj/item/clothing/under/blackskirt

/datum/gear/skirt/ce
	display_name = "skirt, ce"
	path = /obj/item/clothing/under/rank/chief_engineer/skirt
	allowed_roles = list("Chief Engineer")

/datum/gear/skirt/atmos
	display_name = "skirt, atmos"
	path = /obj/item/clothing/under/rank/atmospheric_technician/skirt
	allowed_roles = list("Chief Engineer","Atmospheric Technician")

/datum/gear/skirt/eng
	display_name = "skirt, engineer"
	path = /obj/item/clothing/under/rank/engineer/skirt
	allowed_roles = list("Chief Engineer","Station Engineer")

/datum/gear/skirt/cmo
	display_name = "skirt, cmo"
	path = /obj/item/clothing/under/rank/chief_medical_officer
	allowed_roles = list("Chief Medical Officer")

/datum/gear/skirt/chem
	display_name = "skirt, chemist"
	path = /obj/item/clothing/under/rank/chemist/skirt
	allowed_roles = list("Chief Medical Officer","Chemist")

/datum/gear/skirt/viro
	display_name = "skirt, virologist"
	path = /obj/item/clothing/under/rank/virologist/skirt
	allowed_roles = list("Chief Medical Officer","Medical Doctor")

/datum/gear/skirt/med
	display_name = "skirt, medical"
	path = /obj/item/clothing/under/rank/medical/skirt
	allowed_roles = list("Chief Medical Officer","Medical Doctor","Chemist","Psychiatrist","Paramedic")

/datum/gear/skirt/sci
	display_name = "skirt, scientist"
	path = /obj/item/clothing/under/rank/scientist/skirt
	allowed_roles = list("Research Director","Scientist")

/datum/gear/skirt/cargo
	display_name = "skirt, cargo"
	path = /obj/item/clothing/under/rank/cargotech/skirt
	allowed_roles = list("Quartermaster","Cargo Technician")

/datum/gear/skirt/qm
	display_name = "skirt, QM"
	path = /obj/item/clothing/under/rank/cargo/skirt
	allowed_roles = list("Quartermaster")

/datum/gear/jeans_qm
	display_name = "jeans, QM"
	path = /obj/item/clothing/under/rank/cargo/jeans
	slot = slot_w_uniform
	cost = 1
	allowed_roles = list("Quartermaster")

/datum/gear/jeans_qmf
	display_name = "female jeans, QM"
	path = /obj/item/clothing/under/rank/cargo/jeans/female
	slot = slot_w_uniform
	cost = 1
	allowed_roles = list("Quartermaster")

/datum/gear/jeans_cargo
	display_name = "jeans, cargo"
	path = /obj/item/clothing/under/rank/cargotech/jeans
	slot = slot_w_uniform
	cost = 1
	allowed_roles = list("Quartermaster","Cargo Technician")

/datum/gear/jeans_cargof
	display_name = "female jeans, cargo"
	path = /obj/item/clothing/under/rank/cargotech/jeans/female
	slot = slot_w_uniform
	cost = 1
	allowed_roles = list("Quartermaster","Cargo Technician")

/datum/gear/white
	display_name = "pants, white"
	path = /obj/item/clothing/under/pants/white
	slot = slot_w_uniform
	cost = 1

/datum/gear/pants/red
	display_name = "pants, red"
	path = /obj/item/clothing/under/pants/red

/datum/gear/pants/black
	display_name = "pants, black"
	path = /obj/item/clothing/under/pants/black

/datum/gear/pants/tan
	display_name = "pants, tan"
	path = /obj/item/clothing/under/pants/tan

/datum/gear/pants/track
	display_name = "pants, track"
	path = /obj/item/clothing/under/pants/track

/datum/gear/pants/khaki
	display_name = "pants, khaki"
	path = /obj/item/clothing/under/pants/khaki

/datum/gear/pants/camo
	display_name = "pants, camo"
	path = /obj/item/clothing/under/pants/camo

/datum/gear/pants/jeans
	display_name = "pants, jeans"
	path = /obj/item/clothing/under/pants/jeans

/datum/gear/pants/jeans/classic
	display_name = "pants, classic jeans"
	path = /obj/item/clothing/under/pants/classicjeans

/datum/gear/pants/jeans/mustang
	display_name = "pants, mustang jeans"
	path = /obj/item/clothing/under/pants/mustangjeans

/datum/gear/pants/jeans/black
	display_name = "pants, black jeans"
	path = /obj/item/clothing/under/pants/blackjeans

/datum/gear/pants/jeans/youngfolks
	display_name = "pants, young folks jeans"
	path = /obj/item/clothing/under/pants/youngfolksjeans

/datum/gear/shorts/jeans
	display_name = "shorts, jeans"
	path = /obj/item/clothing/under/shorts/jeans
	slot = slot_w_uniform
	cost = 1

/datum/gear/shorts/jeans/classic
	display_name = "shorts, classic jeans"
	path = /obj/item/clothing/under/shorts/jeans/classic

/datum/gear/shorts/jeans/mustang
	display_name = "shorts, mustang jeans"
	path = /obj/item/clothing/under/shorts/jeans/mustang

/datum/gear/shorts/jeans/youngfolks
	display_name = "shorts, young folks jeans"
	path = /obj/item/clothing/under/shorts/jeans/youngfolks

/datum/gear/shorts/jeans/black
	display_name = "shorts, black jeans"
	path = /obj/item/clothing/under/shorts/jeans/black

/datum/gear/shorts/jeans/female
	display_name = "shorts, female, jeans"
	path = /obj/item/clothing/under/shorts/jeans/female

/datum/gear/shorts/jeans/classic/female
	display_name = "shorts, female, classic jeans"
	path = /obj/item/clothing/under/shorts/jeans/classic/female

/datum/gear/shorts/jeans/mustang/female
	display_name = "shorts, female, mustang jeans"
	path = /obj/item/clothing/under/shorts/jeans/mustang/female

/datum/gear/shorts/jeans/youngfolks/female
	display_name = "shorts, female, young folks jeans"
	path = /obj/item/clothing/under/shorts/jeans/youngfolks/female

/datum/gear/shorts/jeans/black/female
	display_name = "shorts, female, black jeans"
	path = /obj/item/clothing/under/shorts/jeans/black/female

/datum/gear/shorts/khaki
	display_name = "shorts, khaki"
	path = /obj/item/clothing/under/shorts/khaki
	slot = slot_w_uniform
	cost = 1

/datum/gear/shorts/khaki/female
	display_name = "shorts, female, khaki"
	path = /obj/item/clothing/under/shorts/khaki/female

/datum/gear/suit  //amish
	display_name = "suit, amish"
	path = /obj/item/clothing/under/sl_suit
	slot = slot_w_uniform
	cost = 1

/datum/gear/suit/black
	display_name = "suit, black"
	path = /obj/item/clothing/under/suit_jacket

/datum/gear/suit/shinyblack
	display_name = "suit, shiny-black"
	path = /obj/item/clothing/under/lawyer/black

/datum/gear/suit/blue
	display_name = "suit, blue"
	path = /obj/item/clothing/under/lawyer/blue

/datum/gear/suit/burgundy
	display_name = "suit, burgundy"
	path = /obj/item/clothing/under/suit_jacket/burgundy

/datum/gear/suit/checkered
	display_name = "suit, checkered"
	path = /obj/item/clothing/under/suit_jacket/checkered

/datum/gear/suit/charcoal
	display_name = "suit, charcoal"
	path = /obj/item/clothing/under/suit_jacket/charcoal

/datum/gear/suit/exec
	display_name = "suit, executive"
	path = /obj/item/clothing/under/suit_jacket/really_black

/datum/gear/suit/femaleexec
	display_name = "suit, female-executive"
	path = /obj/item/clothing/under/suit_jacket/female

/datum/gear/suit/gentle
	display_name = "suit, gentlemen"
	path = /obj/item/clothing/under/gentlesuit

/datum/gear/suit/navy
	display_name = "suit, navy"
	path = /obj/item/clothing/under/suit_jacket/navy

/datum/gear/suit/red
	display_name = "suit, red"
	path = /obj/item/clothing/under/suit_jacket/red

/datum/gear/suit/redlawyer
	display_name = "suit, lawyer-red"
	path = /obj/item/clothing/under/lawyer/red

/datum/gear/suit/oldman
	display_name = "suit, old-man"
	path = /obj/item/clothing/under/lawyer/oldman

/datum/gear/suit/purple
	display_name = "suit, purple"
	path = /obj/item/clothing/under/lawyer/purpsuit

/datum/gear/suit/tan
	display_name = "suit, tan"
	path = /obj/item/clothing/under/suit_jacket/tan

/datum/gear/suit/white
	display_name = "suit, white"
	path = /obj/item/clothing/under/scratch

/datum/gear/suit/whiteblue
	display_name = "suit, white-blue"
	path = /obj/item/clothing/under/lawyer/bluesuit

/datum/gear/scrubs
	display_name = "scrubs, black"
	path = /obj/item/clothing/under/rank/medical/black
	slot = slot_w_uniform
	cost = 1
	allowed_roles = list("Medical Doctor","Chief Medical Officer","Chemist","Paramedic","Geneticist")

/datum/gear/scrubs/blue
	display_name = "scrubs, blue"
	path = /obj/item/clothing/under/rank/medical/blue

/datum/gear/scrubs/purple
	display_name = "scrubs, purple"
	path = /obj/item/clothing/under/rank/medical/purple

/datum/gear/scrubs/green
	display_name = "scrubs, green"
	path = /obj/item/clothing/under/rank/medical/green

/datum/gear/sundress
	display_name = "sundress"
	path = /obj/item/clothing/under/sundress
	slot = slot_w_uniform
	cost = 1

/datum/gear/sundress/white
	display_name = "sundress, white"
	path = /obj/item/clothing/under/sundress_white

/datum/gear/dress_fire
	display_name = "flame dress"
	path = /obj/item/clothing/under/dress/dress_fire
	slot = slot_w_uniform
	cost = 1

/datum/gear/uniform_captain
	display_name = "uniform, captain's dress"
	path = /obj/item/clothing/under/dress/dress_cap
	slot = slot_w_uniform
	cost = 1
	allowed_roles = list("Captain")

/datum/gear/corpdetsuit
	display_name = "uniform, corporate (Detective)"
	path = /obj/item/clothing/under/det/corporate
	cost = 1
	slot = slot_w_uniform
	allowed_roles = list("Detective","Head of Security")

/datum/gear/corpsecsuit
	display_name = "uniform, corporate (Security)"
	path = /obj/item/clothing/under/rank/security/corp
	cost = 1
	slot = slot_w_uniform
	allowed_roles = list("Security Officer","Head of Security","Warden")

/datum/gear/uniform_hop
	display_name = "uniform, HoP's dress"
	path = /obj/item/clothing/under/dress/dress_hop
	slot = slot_w_uniform
	cost = 1
	allowed_roles = list("Head of Personnel")

/datum/gear/uniform_hr
	display_name = "uniform, HR director (HoP)"
	path = /obj/item/clothing/under/dress/dress_hr
	slot = slot_w_uniform
	cost = 1
	allowed_roles = list("Head of Personnel")

/datum/gear/navysecsuit
	display_name = "uniform, navyblue (Security)"
	path = /obj/item/clothing/under/rank/security/navyblue
	cost = 1
	slot = slot_w_uniform
	allowed_roles = list("Security Officer","Head of Security","Warden")

// Attachments
/datum/gear/armband
	display_name = "armband, red"
	path = /obj/item/clothing/accessory/armband
	slot = slot_tie
	cost = 1

/datum/gear/armband/cargo
	display_name = "armband, cargo"
	path = /obj/item/clothing/accessory/armband/cargo

/datum/gear/armband/emt
	display_name = "armband, EMT"
	path = /obj/item/clothing/accessory/armband/medgreen

/datum/gear/armband/engineering
	display_name = "armband, engineering"
	path = /obj/item/clothing/accessory/armband/engine

/datum/gear/armband/hydroponics
	display_name = "armband, hydroponics"
	path = /obj/item/clothing/accessory/armband/hydro

/datum/gear/armband/medical
	display_name = "armband, medical"
	path = /obj/item/clothing/accessory/armband/med

/datum/gear/armband/science
	display_name = "armband, science"
	path = /obj/item/clothing/accessory/armband/science

/datum/gear/holster
	display_name = "holster, armpit"
	path = /obj/item/clothing/accessory/holster/armpit
	slot = slot_tie
	cost = 1
	allowed_roles = list("Captain", "Head of Personnel", "Security Officer", "Warden", "Head of Security","Detective")

/datum/gear/holster/hip
	display_name = "holster, hip"
	path = /obj/item/clothing/accessory/holster/hip

/datum/gear/holster/waist
	display_name = "holster, waist"
	path = /obj/item/clothing/accessory/holster/waist

/datum/gear/tie
	display_name = "tie, black"
	path = /obj/item/clothing/accessory/black
	slot = slot_tie
	cost = 1

/datum/gear/tie/blue
	display_name = "tie, blue"
	path = /obj/item/clothing/accessory/blue

/datum/gear/tie/red
	display_name = "tie, red"
	path = /obj/item/clothing/accessory/red

/datum/gear/tie/horrible
	display_name = "tie, socially disgraceful"
	path = /obj/item/clothing/accessory/horrible

/datum/gear/scarf
	display_name = "scarf"
	path = /obj/item/clothing/accessory/scarf
	slot = slot_tie
	cost = 1

/datum/gear/scarf/red
	display_name = "scarf, red"
	path = /obj/item/clothing/accessory/scarf/red

/datum/gear/scarf/green
	display_name = "scarf, green"
	path = /obj/item/clothing/accessory/scarf/green

/datum/gear/scarf/darkblue
	display_name = "scarf, dark blue"
	path = /obj/item/clothing/accessory/scarf/darkblue

/datum/gear/scarf/purple
	display_name = "scarf, purple"
	path = /obj/item/clothing/accessory/scarf/purple

/datum/gear/scarf/yellow
	display_name = "scarf, yellow"
	path = /obj/item/clothing/accessory/scarf/yellow

/datum/gear/scarf/orange
	display_name = "scarf, orange"
	path = /obj/item/clothing/accessory/scarf/orange

/datum/gear/scarf/lightblue
	display_name = "scarf, light blue"
	path = /obj/item/clothing/accessory/scarf/lightblue

/datum/gear/scarf/white
	display_name = "scarf, white"
	path = /obj/item/clothing/accessory/scarf/white

/datum/gear/scarf/black
	display_name = "scarf, black"
	path = /obj/item/clothing/accessory/scarf/black

/datum/gear/scarf/zebra
	display_name = "scarf, zebra"
	path = /obj/item/clothing/accessory/scarf/zebra

/datum/gear/scarf/christmas
	display_name = "scarf, christmas"
	path = /obj/item/clothing/accessory/scarf/christmas

/datum/gear/scarf/stripedred
	display_name = "scarf, striped red"
	path = /obj/item/clothing/accessory/stripedredscarf

/datum/gear/scarf/stripedgreen
	display_name = "scarf, striped green"
	path = /obj/item/clothing/accessory/stripedgreenscarf

/datum/gear/scarf/stripedblue
	display_name = "scarf, striped blue"
	path = /obj/item/clothing/accessory/stripedbluescarf

/datum/gear/brown_vest
	display_name = "webbing, engineering"
	path = /obj/item/clothing/accessory/storage/brown_vest
	slot = slot_tie
	cost = 1
	allowed_roles = list("Station Engineer","Atmospheric Technician","Chief Engineer")

/datum/gear/black_vest
	display_name = "webbing, security"
	path = /obj/item/clothing/accessory/storage/black_vest
	slot = slot_tie
	cost = 1
	allowed_roles = list("Security Officer","Head of Security","Warden")

/datum/gear/webbing
	display_name = "webbing, simple"
	path = /obj/item/clothing/accessory/storage/webbing
	slot = slot_tie
	cost = 2

// Suit slot

/datum/gear/apron
	display_name = "apron, blue"
	path = /obj/item/clothing/suit/apron
	cost = 1
	slot = slot_wear_suit

/datum/gear/leather_coat
	display_name = "leather coat"
	path = /obj/item/clothing/suit/leathercoat
	cost = 2
	slot = slot_wear_suit

/datum/gear/puffer_coat
	display_name = "puffer coat"
	path = /obj/item/clothing/suit/jacket/puffer
	cost = 2
	slot = slot_wear_suit

/datum/gear/puffer_vest
	display_name = "puffer vest"
	path = /obj/item/clothing/suit/jacket/puffer/vest
	cost = 2
	slot = slot_wear_suit

/datum/gear/bomber
	display_name = "bomber jacket"
	path = /obj/item/clothing/suit/storage/toggle/bomber
	cost = 2
	slot = slot_wear_suit

/datum/gear/bomber_alt
	display_name = "bomber jacket 2"
	path = /obj/item/clothing/suit/storage/bomber/alt
	cost = 2
	slot = slot_wear_suit

/datum/gear/leather_jacket
	display_name = "leather jacket, black"
	path = /obj/item/clothing/suit/storage/leather_jacket
	cost = 2
	slot = slot_wear_suit

/datum/gear/leather_jacket_alt
	display_name = "leather jacket 2, black"
	path = /obj/item/clothing/suit/storage/leather_jacket/alt
	cost = 2
	slot = slot_wear_suit

/datum/gear/leather_jacket_nt
	display_name = "leather jacket, corporate, black"
	path = /obj/item/clothing/suit/storage/leather_jacket/nanotrasen
	cost = 2
	slot = slot_wear_suit

/datum/gear/brown_jacket
	display_name = "leather jacket, brown"
	path = /obj/item/clothing/suit/storage/toggle/brown_jacket
	cost = 2
	slot = slot_wear_suit

/datum/gear/brown_jacket_nt
	display_name = "leather jacket, corporate, brown"
	path = /obj/item/clothing/suit/storage/toggle/brown_jacket/nanotrasen
	cost = 2
	slot = slot_wear_suit

/datum/gear/mil
	display_name = "military jacket"
	path = /obj/item/clothing/suit/storage/miljacket
	cost = 2
	slot = slot_wear_suit

/datum/gear/mil/alt
	display_name = "military jacket, alt"
	path = /obj/item/clothing/suit/storage/miljacket/alt
	cost = 2
	slot = slot_wear_suit

/datum/gear/hazard_vest
	display_name = "hazard vest"
	path = /obj/item/clothing/suit/storage/hazardvest
	cost = 2
	slot = slot_wear_suit

/datum/gear/hoodie
	display_name = "hoodie, grey"
	path = /obj/item/clothing/suit/storage/toggle/hoodie
	cost = 2
	slot = slot_wear_suit

/datum/gear/hoodie/red
	display_name = "hoodie, red"
	path = /obj/item/clothing/suit/storage/toggle/hoodie/red
	cost = 2
	slot = slot_wear_suit

/datum/gear/hoodie/blue
	display_name = "hoodie, blue"
	path = /obj/item/clothing/suit/storage/toggle/hoodie/blue
	cost = 2
	slot = slot_wear_suit

/datum/gear/hoodie/yellow
	display_name = "hoodie, yellow"
	path = /obj/item/clothing/suit/storage/toggle/hoodie/yellow
	cost = 2
	slot = slot_wear_suit

/datum/gear/hoodie/green
	display_name = "hoodie, green"
	path = /obj/item/clothing/suit/storage/toggle/hoodie/green
	cost = 2
	slot = slot_wear_suit

/datum/gear/hoodie/orange
	display_name = "hoodie, orange"
	path = /obj/item/clothing/suit/storage/toggle/hoodie/orange
	cost = 2
	slot = slot_wear_suit

/datum/gear/hoodie/black
	display_name = "hoodie, black"
	path = /obj/item/clothing/suit/storage/toggle/hoodie/black
	cost = 2
	slot = slot_wear_suit

/datum/gear/hoodie/cti
	display_name = "hoodie, CTI"
	path = /obj/item/clothing/suit/storage/toggle/hoodie/cti
	cost = 2
	slot = slot_wear_suit

/datum/gear/hoodie/mu
	display_name = "hoodie, MU"
	path = /obj/item/clothing/suit/storage/toggle/hoodie/mu
	cost = 2
	slot = slot_wear_suit

/datum/gear/hoodie/nt
	display_name = "hoodie, NT"
	path = /obj/item/clothing/suit/storage/toggle/hoodie/nt
	cost = 2
	slot = slot_wear_suit

/datum/gear/unathi_mantle
	display_name = "hide mantle (Unathi)"
	path = /obj/item/clothing/suit/unathi/mantle
	cost = 1
	slot = slot_wear_suit
	whitelisted = "Unathi"

/datum/gear/labcoat
	display_name = "labcoat"
	path = /obj/item/clothing/suit/storage/toggle/labcoat
	cost = 2
	slot = slot_wear_suit

/datum/gear/labcoat/blue
	display_name = "labcoat, blue"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/blue

/datum/gear/labcoat/green
	display_name = "labcoat, green"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/green

/datum/gear/labcoat/orange
	display_name = "labcoat, orange"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/orange

/datum/gear/labcoat/purple
	display_name = "labcoat, purple"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/purple

/datum/gear/labcoat/pink
	display_name = "labcoat, pink"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/pink

/datum/gear/labcoat/red
	display_name = "labcoat, red"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/red

/datum/gear/labcoat/yellow
	display_name = "labcoat, yellow"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/yellow

/datum/gear/labcoat/emt
	display_name = "labcoat, EMT (Medical)"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/emt
	allowed_roles = list("Medical Doctor","Chief Medical Officer","Chemist","Paramedic","Geneticist")

/datum/gear/overalls
	display_name = "overalls"
	path = /obj/item/clothing/suit/apron/overalls
	cost = 1
	slot = slot_wear_suit

/datum/gear/poncho
	display_name = "poncho, tan"
	path = /obj/item/clothing/suit/poncho
	cost = 1
	slot = slot_wear_suit

/datum/gear/poncho/blue
	display_name = "poncho, blue"
	path = /obj/item/clothing/suit/poncho/blue

/datum/gear/poncho/green
	display_name = "poncho, green"
	path = /obj/item/clothing/suit/poncho/green

/datum/gear/poncho/purple
	display_name = "poncho, purple"
	path = /obj/item/clothing/suit/poncho/purple

/datum/gear/poncho/red
	display_name = "poncho, red"
	path = /obj/item/clothing/suit/poncho/red

/datum/gear/unathi_robe
	display_name = "roughspun robe (Unathi)"
	path = /obj/item/clothing/suit/unathi/robe
	cost = 1
	slot = slot_wear_suit
//	whitelisted = "Unathi" // You don't have a monopoly on a robe!

/datum/gear/blue_lawyer_jacket
	display_name = "suit jacket, blue"
	path = /obj/item/clothing/suit/storage/toggle/lawyer/bluejacket
	cost = 2
	slot = slot_wear_suit

/datum/gear/purple_lawyer_jacket
	display_name = "suit jacket, purple"
	path = /obj/item/clothing/suit/storage/lawyer/purpjacket
	cost = 2
	slot = slot_wear_suit

/datum/gear/suspenders
	display_name = "suspenders"
	path = /obj/item/clothing/suit/suspenders
	cost = 1
	slot = slot_wear_suit

/datum/gear/wcoat
	display_name = "waistcoat"
	path = /obj/item/clothing/suit/wcoat
	cost = 1
	slot = slot_wear_suit

/datum/gear/zhan_furs
	display_name = "Zhan-Khazan furs (Tajaran)"
	path = /obj/item/clothing/suit/tajaran/furs
	cost = 1
	slot = slot_wear_suit
	whitelisted = "Tajara" // You do have a monopoly on a fur suit tho

/datum/gear/forensics/red
	display_name = "forensics long, red"
	path = /obj/item/clothing/suit/storage/forensics/red/long
	cost = 2
	slot = slot_wear_suit
	allowed_roles = list("Detective")

/datum/gear/forensics/blue
	display_name = "forensics long, blue"
	path = /obj/item/clothing/suit/storage/forensics/blue/long
	cost = 2
	slot = slot_wear_suit
	allowed_roles = list("Detective")

// Gloves

/datum/gear/gloves
	display_name = "gloves, black"
	path = /obj/item/clothing/gloves/black
	cost = 2
	slot = slot_gloves

/datum/gear/gloves/blue
	display_name = "gloves, blue"
	path = /obj/item/clothing/gloves/blue

/datum/gear/gloves/brown
	display_name = "gloves, brown"
	path = /obj/item/clothing/gloves/brown

/datum/gear/gloves/light_brown
	display_name = "gloves, light-brown"
	path = /obj/item/clothing/gloves/light_brown

/datum/gear/gloves/green
	display_name = "gloves, green"
	path = /obj/item/clothing/gloves/green

/datum/gear/gloves/grey
	display_name = "gloves, grey"
	path = /obj/item/clothing/gloves/grey

/datum/gear/gloves/latex
	display_name = "gloves, latex"
	path = /obj/item/clothing/gloves/latex

/datum/gear/gloves/orange
	display_name = "gloves, orange"
	path = /obj/item/clothing/gloves/orange

/datum/gear/gloves/purple
	display_name = "gloves, purple"
	path = /obj/item/clothing/gloves/purple

/datum/gear/gloves/rainbow
	display_name = "gloves, rainbow"
	path = /obj/item/clothing/gloves/rainbow

/datum/gear/gloves/red
	display_name = "gloves, red"
	path = /obj/item/clothing/gloves/red

/datum/gear/gloves/white
	display_name = "gloves, white"
	path = /obj/item/clothing/gloves/white

// Shoelocker

/datum/gear/jackboots
	display_name = "jackboots"
	path = /obj/item/clothing/shoes/jackboots
	cost = 1
	slot = slot_shoes

/datum/gear/toeless_jackboots
	display_name = "toe-less jackboots"
	path = /obj/item/clothing/shoes/jackboots/unathi
	cost = 1
	slot = slot_shoes

/datum/gear/workboots
	display_name = "workboots"
	path = /obj/item/clothing/shoes/workboots
	cost = 1
	slot = slot_shoes

/datum/gear/sandal
	display_name = "sandals"
	path = /obj/item/clothing/shoes/sandal
	cost = 1
	slot = slot_shoes

/datum/gear/shoes
	display_name = "shoes, black"
	path = /obj/item/clothing/shoes/black
	cost = 1
	slot = slot_shoes

/datum/gear/shoes/blue
	display_name = "shoes, blue"
	path = /obj/item/clothing/shoes/blue

/datum/gear/shoes/brown
	display_name = "shoes, brown"
	path = /obj/item/clothing/shoes/brown

/datum/gear/shoes/lacey
	display_name = "shoes, classy"
	path = /obj/item/clothing/shoes/laceup

/datum/gear/shoes/dress
	display_name = "shoes, dress"
	path = /obj/item/clothing/shoes/laceup

/datum/gear/shoes/green
	display_name = "shoes, green"
	path = /obj/item/clothing/shoes/green

/datum/gear/shoes/leather
	display_name = "shoes, leather"
	path = /obj/item/clothing/shoes/leather

/datum/gear/shoes/orange
	display_name = "shoes, orange"
	path = /obj/item/clothing/shoes/orange

/datum/gear/shoes/purple
	display_name = "shoes, purple"
	path = /obj/item/clothing/shoes/purple

/datum/gear/shoes/rainbow
	display_name = "shoes, rainbow"
	path = /obj/item/clothing/shoes/rainbow

/datum/gear/shoes/red
	display_name = "shoes, red"
	path = /obj/item/clothing/shoes/red

/datum/gear/shoes/white
	display_name = "shoes, white"
	path = /obj/item/clothing/shoes/white

/datum/gear/shoes/yellow
	display_name = "shoes, yellow"
	path = /obj/item/clothing/shoes/yellow

/datum/gear/flats
	display_name = "flats, black"
	path = /obj/item/clothing/shoes/flats
	cost = 1
	slot = slot_shoes

/datum/gear/flats/blue
	display_name = "flats, blue"
	path = /obj/item/clothing/shoes/flats/blue

/datum/gear/flats/brown
	display_name = "flats, brown"
	path = /obj/item/clothing/shoes/flats/brown

/datum/gear/flats/orange
	display_name = "flats, orange"
	path = /obj/item/clothing/shoes/flats/orange

/datum/gear/flats/purple
	display_name = "flats, purple"
	path = /obj/item/clothing/shoes/flats/purple

/datum/gear/flats/red
	display_name = "flats, red"
	path = /obj/item/clothing/shoes/flats/red

/datum/gear/flats/white
	display_name = "flats, white"
	path = /obj/item/clothing/shoes/flats/white


// "Useful" items - I'm guessing things that might be used at work?

/datum/gear/briefcase
	display_name = "briefcase"
	path = /obj/item/weapon/storage/briefcase
	sort_category = "utility"
	cost = 2

/datum/gear/clipboard
	display_name = "clipboard"
	path = /obj/item/weapon/clipboard
	sort_category = "utility"
	cost = 1

/datum/gear/communicator
	display_name = "personal communicator"
	path = /obj/item/device/communicator
	sort_category = "utility"
	cost = 1

/datum/gear/folder_blue
	display_name = "folder, blue"
	path = /obj/item/weapon/folder/blue
	sort_category = "utility"
	cost = 1

/datum/gear/folder_grey
	display_name = "folder, grey"
	path = /obj/item/weapon/folder
	sort_category = "utility"
	cost = 1

/datum/gear/folder_red
	display_name = "folder, red"
	path = /obj/item/weapon/folder/red
	sort_category = "utility"
	cost = 1

/datum/gear/folder_white
	display_name = "folder, white"
	path = /obj/item/weapon/folder/white
	sort_category = "utility"
	cost = 1

/datum/gear/folder_yellow
	display_name = "folder, yellow"
	path = /obj/item/weapon/folder/yellow
	sort_category = "utility"
	cost = 1

/datum/gear/paicard
	display_name = "personal AI device"
	path = /obj/item/device/paicard
	sort_category = "utility"
	cost = 2

// The rest of the trash.

/datum/gear/ashtray
	display_name = "ashtray, plastic"
	path = /obj/item/weapon/material/ashtray/plastic
	sort_category = "misc"
	cost = 1

/*
/datum/gear/boot_knife
	display_name = "boot knife"
	path = /obj/item/weapon/material/kitchen/utensil/knife/boot
	sort_category = "misc"
	cost = 3
*/

/datum/gear/cane
	display_name = "cane"
	path = /obj/item/weapon/cane
	sort_category = "misc"
	cost = 1

/datum/gear/dice
	display_name = "d20"
	path = /obj/item/weapon/dice/d20
	sort_category = "misc"
	cost = 1

/datum/gear/cards
	display_name = "deck of cards"
	path = /obj/item/weapon/deck
	sort_category = "misc"
	cost = 1

/datum/gear/flask
	display_name = "flask"
	path = /obj/item/weapon/reagent_containers/food/drinks/flask/barflask
	sort_category = "misc"
	cost = 1

/datum/gear/vacflask
	display_name = "vacuum-flask"
	path = /obj/item/weapon/reagent_containers/food/drinks/flask/vacuumflask
	sort_category = "misc"
	cost = 1
/datum/gear/blipstick
	display_name = "lipstick, black"
	path = /obj/item/weapon/lipstick/black
	sort_category = "misc"
	cost = 1

/datum/gear/jlipstick
	display_name = "lipstick, jade"
	path = /obj/item/weapon/lipstick/jade
	sort_category = "misc"
	cost = 1

/datum/gear/plipstick
	display_name = "lipstick, purple"
	path = /obj/item/weapon/lipstick/purple
	sort_category = "misc"
	cost = 1

/datum/gear/rlipstick
	display_name = "lipstick, red"
	path = /obj/item/weapon/lipstick
	sort_category = "misc"
	cost = 1

/datum/gear/smokingpipe
	display_name = "pipe, smoking"
	path = /obj/item/clothing/mask/smokable/pipe
	sort_category = "misc"
	cost = 1

/datum/gear/cornpipe
	display_name = "pipe, corn"
	path = /obj/item/clothing/mask/smokable/pipe/cobpipe
	sort_category = "misc"
	cost = 1

/datum/gear/matchbook
	display_name = "matchbook"
	path = /obj/item/weapon/storage/box/matches
	sort_category = "misc"
	cost = 1

/datum/gear/comb
	display_name = "purple comb"
	path = /obj/item/weapon/haircomb
	sort_category = "misc"
	cost = 1

/datum/gear/zippo
	display_name = "zippo"
	path = /obj/item/weapon/flame/lighter/zippo
	sort_category = "misc"
	cost = 1

/*/datum/gear/combitool
	display_name = "combi-tool"
	path = /obj/item/weapon/combitool
	cost = 3*/

// Stuff worn on the ears. Items here go in the "ears" sort_category but they must not use
// the slot_r_ear or slot_l_ear as the slot, or else players will spawn with no headset.
/datum/gear/earmuffs
	display_name = "earmuffs"
	path = /obj/item/clothing/ears/earmuffs
	cost = 1
	sort_category = "ears"

/datum/gear/headphones
	display_name = "headphones"
	path = /obj/item/clothing/ears/earmuffs/headphones
	cost = 1
	sort_category = "ears"

/datum/gear/skrell_chain
	display_name = "skrell headtail-wear, female, chain"
	path = /obj/item/clothing/ears/skrell/chain
	cost = 1
	sort_category = "ears"
	whitelisted = "Skrell"

/datum/gear/skrell_plate
	display_name = "skrell headtail-wear, male, bands"
	path = /obj/item/clothing/ears/skrell/band
	cost = 1
	sort_category = "ears"
	whitelisted = "Skrell"

/datum/gear/skrell_cloth //male/red
	display_name = "skrell headtail-wear, male, red, cloth"
	path = /obj/item/clothing/ears/skrell/cloth_male
	cost = 1
	sort_category = "ears"
	whitelisted = "Skrell"

/datum/gear/skrell_cloth/male //black
	display_name = "skrell headtail-wear, male, black, cloth"
	path = /obj/item/clothing/ears/skrell/cloth_male/black

/datum/gear/skrell_cloth/male/blue
	display_name = "skrell headtail-wear, male, blue, cloth"
	path = /obj/item/clothing/ears/skrell/cloth_male/blue

/datum/gear/skrell_cloth_male/green
	display_name = "skrell headtail-wear, male, green, cloth"
	path = /obj/item/clothing/ears/skrell/cloth_male/green

/datum/gear/skrell_cloth_male/pink
	display_name = "skrell headtail-wear, male, pink, cloth"
	path = /obj/item/clothing/ears/skrell/cloth_male/pink

/datum/gear/skrell_cloth/female
	display_name = "skrell headtail-wear, female, red, cloth"
	path = /obj/item/clothing/ears/skrell/cloth_female

/datum/gear/skrell_cloth_female/black
	display_name = "skrell headtail-wear, female, black, cloth"
	path = /obj/item/clothing/ears/skrell/cloth_female/black

/datum/gear/skrell_cloth_female/blue
	display_name = "skrell headtail-wear, female, blue, cloth"
	path = /obj/item/clothing/ears/skrell/cloth_female/blue

/datum/gear/skrell_cloth_female/green
	display_name = "skrell headtail-wear, female, green, cloth"
	path = /obj/item/clothing/ears/skrell/cloth_female/green

/datum/gear/skrell_cloth_female/pink
	display_name = "skrell headtail-wear, female, pink, cloth"
	path = /obj/item/clothing/ears/skrell/cloth_female/pink