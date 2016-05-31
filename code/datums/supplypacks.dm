//SUPPLY PACKS
//NOTE: only secure crate types use the access var (and are lockable)
//NOTE: hidden packs only show up when the computer has been hacked.
//ANOTER NOTE: Contraband is obtainable through modified supplycomp circuitboards.
//BIG NOTE: Don't add living things to crates, that's bad, it will break the shuttle.
//NEW NOTE: Do NOT set the price of any crates below 7 points. Doing so allows infinite points.

var/list/all_supply_groups = list("Operations","Security","Hospitality","Engineering","Atmospherics","Medical","Reagents","Reagent Cartridges","Science","Hydroponics", "Supply", "Miscellaneous")

/datum/supply_packs
	var/name = null
	var/list/contains = list()
	var/manifest = ""
	var/amount = null
	var/cost = null
	var/containertype = null
	var/containername = null
	var/access = null
	var/hidden = 0
	var/contraband = 0
	var/group = "Operations"

/datum/supply_packs/New()
	manifest += "<ul>"
	for(var/path in contains)
		if(!path || !ispath(path, /atom))
			continue
		var/atom/O = path
		manifest += "<li>[initial(O.name)]</li>"
	manifest += "</ul>"

/datum/supply_packs/specialops
	name = "Special Ops supplies"
	contains = list(
			/obj/item/weapon/storage/box/emps,
			/obj/item/weapon/grenade/smokebomb = 3,
			/obj/item/weapon/pen/reagent/paralysis,
			/obj/item/weapon/grenade/chem_grenade/incendiary
			)
	cost = 20
	containertype = /obj/structure/closet/crate
	containername = "Special Ops crate"
	group = "Security"
	hidden = 1

/datum/supply_packs/food
	name = "Kitchen supply crate"
	contains = list(
			/obj/item/weapon/reagent_containers/food/condiment/flour = 6,
			/obj/item/weapon/reagent_containers/food/drinks/milk = 3,
			/obj/item/weapon/reagent_containers/food/drinks/soymilk = 2,
			/obj/item/weapon/storage/fancy/egg_box = 2,
			/obj/item/weapon/reagent_containers/food/snacks/tofu = 4,
			/obj/item/weapon/reagent_containers/food/snacks/meat = 4
			)
	cost = 10
	containertype = /obj/structure/closet/crate/freezer
	containername = "Food crate"
	group = "Supply"

/datum/supply_packs/monkey
	name = "Monkey crate"
	contains = list (/obj/item/weapon/storage/box/monkeycubes)
	cost = 20
	containertype = /obj/structure/closet/crate/freezer
	containername = "Monkey crate"
	group = "Hydroponics"

/datum/supply_packs/farwa
	name = "Farwa crate"
	contains = list (/obj/item/weapon/storage/box/monkeycubes/farwacubes)
	cost = 30
	containertype = /obj/structure/closet/crate/freezer
	containername = "Farwa crate"
	group = "Hydroponics"

/datum/supply_packs/skrell
	name = "Neaera crate"
	contains = list (/obj/item/weapon/storage/box/monkeycubes/neaeracubes)
	cost = 30
	containertype = /obj/structure/closet/crate/freezer
	containername = "Neaera crate"
	group = "Hydroponics"

/datum/supply_packs/stok
	name = "Stok crate"
	contains = list (/obj/item/weapon/storage/box/monkeycubes/stokcubes)
	cost = 30
	containertype = /obj/structure/closet/crate/freezer
	containername = "Stok crate"
	group = "Hydroponics"

/datum/supply_packs/beanbagammo
	name = "Beanbag shells"
	contains = list(/obj/item/weapon/storage/box/beanbags = 3)
	cost = 30
	containertype = /obj/structure/closet/crate
	containername = "Beanbag shells"
	group = "Security"

/datum/supply_packs/toner
	name = "Toner cartridges"
	contains = list(/obj/item/device/toner = 6)
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "Toner cartridges"
	group = "Supply"

/datum/supply_packs/party
	name = "Party equipment"
	contains = list(
			/obj/item/weapon/storage/box/drinkingglasses,
			/obj/item/weapon/reagent_containers/food/drinks/shaker,
			/obj/item/weapon/reagent_containers/food/drinks/flask/barflask,
			/obj/item/weapon/reagent_containers/food/drinks/bottle/patron,
			/obj/item/weapon/reagent_containers/food/drinks/bottle/goldschlager,
			/obj/item/weapon/reagent_containers/food/drinks/bottle/specialwhiskey,
			/obj/item/weapon/storage/fancy/cigarettes/dromedaryco,
			/obj/item/weapon/lipstick/random,
			/obj/item/weapon/reagent_containers/food/drinks/bottle/small/ale = 2,
			/obj/item/weapon/reagent_containers/food/drinks/bottle/small/beer = 4,
			/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/shotglass = 4
			)
	cost = 20
	containertype = /obj/structure/closet/crate
	containername = "Party equipment"
	group = "Hospitality"

/datum/supply_packs/lasertag
	name = "Lasertag equipment"
	contains = list(
			/obj/item/weapon/gun/energy/lasertag/red,
			/obj/item/clothing/suit/redtag,
			/obj/item/weapon/gun/energy/lasertag/blue,
			/obj/item/clothing/suit/bluetag
			)
	containertype = /obj/structure/closet
	containername = "Lasertag Closet"
	group = "Hospitality"
	cost = 20

/datum/supply_packs/internals
	name = "Internals crate"
	contains = list(
			/obj/item/clothing/mask/gas = 3,
			/obj/item/weapon/tank/air = 3
			)
	cost = 10
	containertype = /obj/structure/closet/crate/internals
	containername = "Internals crate"
	group = "Atmospherics"

/datum/supply_packs/evacuation
	name = "Emergency equipment"
	contains = list(
			/obj/item/weapon/storage/toolbox/emergency = 2,
			/obj/item/clothing/suit/storage/hazardvest = 2,
			/obj/item/clothing/suit/storage/vest = 2,
			/obj/item/weapon/tank/emergency_oxygen/engi = 4,
			/obj/item/clothing/suit/space/emergency = 4,
			/obj/item/clothing/head/helmet/space/emergency = 4,
			/obj/item/clothing/mask/gas = 4
			)
	cost = 45
	containertype = /obj/structure/closet/crate/internals
	containername = "Emergency crate"
	group = "Atmospherics"


/datum/supply_packs/inflatable
	name = "Inflatable barriers"
	contains = list(/obj/item/weapon/storage/briefcase/inflatable = 3)
	cost = 20
	containertype = /obj/structure/closet/crate
	containername = "Inflatable Barrier Crate"
	group = "Atmospherics"

/datum/supply_packs/janitor
	name = "Janitorial supplies"
	contains = list(
			/obj/item/weapon/reagent_containers/glass/bucket,
			/obj/item/weapon/mop,
			/obj/item/clothing/under/rank/janitor,
			/obj/item/weapon/cartridge/janitor,
			/obj/item/clothing/gloves/black,
			/obj/item/clothing/head/soft/purple,
			/obj/item/weapon/storage/belt/janitor,
			/obj/item/clothing/shoes/galoshes,
			/obj/item/weapon/caution = 4,
			/obj/item/weapon/storage/bag/trash,
			/obj/item/device/lightreplacer,
			/obj/item/weapon/reagent_containers/spray/cleaner,
			/obj/item/weapon/reagent_containers/glass/rag,
			/obj/item/weapon/grenade/chem_grenade/cleaner = 3,
			/obj/structure/mopbucket
			)
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "Janitorial supplies"
	group = "Supply"

/datum/supply_packs/lightbulbs
	name = "Replacement lights"
	contains = list(/obj/item/weapon/storage/box/lights/mixed = 3)
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "Replacement lights"
	group = "Engineering"

/datum/supply_packs/wizard
	name = "Wizard costume"
	contains = list(
			/obj/item/weapon/staff,
			/obj/item/clothing/suit/wizrobe/fake,
			/obj/item/clothing/shoes/sandal,
			/obj/item/clothing/head/wizard/fake
			)
	cost = 20
	containertype = /obj/structure/closet/crate
	containername = "Wizard costume crate"
	group = "Miscellaneous"

/datum/supply_packs/foam_weapons
	name = "Foam Weapon Crate"
	contains = list(
			/obj/item/weapon/material/sword/foam = 2,
			/obj/item/weapon/material/twohanded/baseballbat/foam = 2,
			/obj/item/weapon/material/twohanded/spear/foam = 2,
			/obj/item/weapon/material/twohanded/fireaxe/foam = 2
			)
	cost = 80
	containertype = /obj/structure/closet/crate
	containername = "foam weapon crate"
	group = "Miscellaneous"

/datum/supply_packs/mule
	name = "Mulebot Crate"
	contains = list()
	cost = 20
	containertype = /obj/structure/largecrate/animal/mulebot
	containername = "Mulebot Crate"
	group = "Operations"

/datum/supply_packs/cargotrain
	name = "Cargo Train Tug"
	contains = list(/obj/vehicle/train/cargo/engine)
	cost = 45
	containertype = /obj/structure/largecrate
	containername = "Cargo Train Tug Crate"
	group = "Operations"

/datum/supply_packs/cargotrailer
	name = "Cargo Train Trolley"
	contains = list(/obj/vehicle/train/cargo/trolley)
	cost = 15
	containertype = /obj/structure/largecrate
	containername = "Cargo Train Trolley Crate"
	group = "Operations"

/datum/supply_packs/lisa
	name = "Corgi Crate"
	contains = list()
	cost = 50
	containertype = /obj/structure/largecrate/animal/corgi
	containername = "Corgi Crate"
	group = "Hydroponics"

/datum/supply_packs/hydroponics
	name = "Hydroponics Supply Crate"
	contains = list(
			/obj/item/weapon/reagent_containers/spray/plantbgone = 4,
			/obj/item/weapon/reagent_containers/glass/bottle/ammonia = 2,
			/obj/item/weapon/material/hatchet,
			/obj/item/weapon/material/minihoe,
			/obj/item/device/analyzer/plant_analyzer,
			/obj/item/clothing/gloves/botanic_leather,
			/obj/item/clothing/suit/apron,
			/obj/item/weapon/material/minihoe,
			/obj/item/weapon/storage/box/botanydisk
			)
	cost = 15
	containertype = /obj/structure/closet/crate/hydroponics
	containername = "Hydroponics crate"
	access = access_hydroponics
	group = "Hydroponics"

/datum/supply_packs/cow
	name = "Cow crate"
	cost = 30
	containertype = /obj/structure/largecrate/animal/cow
	containername = "Cow crate"
	access = access_hydroponics
	group = "Hydroponics"

/datum/supply_packs/goat
	name = "Goat crate"
	cost = 25
	containertype = /obj/structure/largecrate/animal/goat
	containername = "Goat crate"
	access = access_hydroponics
	group = "Hydroponics"

/datum/supply_packs/chicken
	name = "Chicken crate"
	cost = 20
	containertype = /obj/structure/largecrate/animal/chick
	containername = "Chicken crate"
	access = access_hydroponics
	group = "Hydroponics"

/datum/supply_packs/seeds
	name = "Seeds crate"
	contains = list(
			/obj/item/seeds/chiliseed,
			/obj/item/seeds/berryseed,
			/obj/item/seeds/cornseed,
			/obj/item/seeds/eggplantseed,
			/obj/item/seeds/tomatoseed,
			/obj/item/seeds/appleseed,
			/obj/item/seeds/soyaseed,
			/obj/item/seeds/wheatseed,
			/obj/item/seeds/carrotseed,
			/obj/item/seeds/harebell,
			/obj/item/seeds/lemonseed,
			/obj/item/seeds/orangeseed,
			/obj/item/seeds/grassseed,
			/obj/item/seeds/sunflowerseed,
			/obj/item/seeds/chantermycelium,
			/obj/item/seeds/potatoseed,
			/obj/item/seeds/sugarcaneseed
			)
	cost = 10
	containertype = /obj/structure/closet/crate/hydroponics
	containername = "Seeds crate"
	access = access_hydroponics
	group = "Hydroponics"

/datum/supply_packs/weedcontrol
	name = "Weed control crate"
	contains = list(
			/obj/item/weapon/material/hatchet = 2,
			/obj/item/weapon/reagent_containers/spray/plantbgone = 4,
			/obj/item/clothing/mask/gas = 2,
			/obj/item/weapon/grenade/chem_grenade/antiweed = 2
			)
	cost = 25
	containertype = /obj/structure/closet/crate/hydroponics
	containername = "Weed control crate"
	access = access_hydroponics
	group = "Hydroponics"

/datum/supply_packs/exoticseeds
	name = "Exotic seeds crate"
	contains = list(
			/obj/item/seeds/replicapod = 2,
			/obj/item/seeds/libertymycelium,
			/obj/item/seeds/reishimycelium,
			/obj/item/seeds/random = 6,
			/obj/item/seeds/kudzuseed
			)
	cost = 15
	containertype = /obj/structure/closet/crate/hydroponics
	containername = "Exotic Seeds crate"
	access = access_hydroponics
	group = "Hydroponics"

/datum/supply_packs/medical
	name = "Medical crate"
	contains = list(
			/obj/item/weapon/storage/firstaid/regular,
			/obj/item/weapon/storage/firstaid/fire,
			/obj/item/weapon/storage/firstaid/toxin,
			/obj/item/weapon/storage/firstaid/o2,
			/obj/item/weapon/storage/firstaid/adv,
			/obj/item/weapon/reagent_containers/glass/bottle/antitoxin,
			/obj/item/weapon/reagent_containers/glass/bottle/inaprovaline,
			/obj/item/weapon/reagent_containers/glass/bottle/stoxin,
			/obj/item/weapon/storage/box/syringes,
			/obj/item/weapon/storage/box/autoinjectors
			)
	cost = 10
	containertype = /obj/structure/closet/crate/medical
	containername = "Medical crate"
	group = "Medical"

/datum/supply_packs/bloodpack
	name = "BloodPack crate"
	contains = list(/obj/item/weapon/storage/box/bloodpacks = 3)
	cost = 10
	containertype = /obj/structure/closet/crate/medical
	containername = "BloodPack crate"
	group = "Medical"

/datum/supply_packs/bodybag
	name = "Body bag crate"
	contains = list(/obj/item/weapon/storage/box/bodybags = 3)
	cost = 10
	containertype = /obj/structure/closet/crate/medical
	containername = "Body bag crate"
	group = "Medical"

/datum/supply_packs/cryobag
	name = "Stasis bag crate"
	contains = list(/obj/item/bodybag/cryobag = 3)
	cost = 50
	containertype = /obj/structure/closet/crate/medical
	containername = "Stasis bag crate"
	group = "Medical"

/datum/supply_packs/virus
	name = "Virus sample crate"
	contains = list(/obj/item/weapon/virusdish/random = 4)
	cost = 25
	containertype = "/obj/structure/closet/crate/secure"
	containername = "Virus sample crate"
	access = access_cmo
	group = "Science"

/datum/supply_packs/metal50
	name = "50 metal sheets"
	contains = list(/obj/item/stack/material/steel)
	amount = 50
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "Metal sheets crate"
	group = "Engineering"

/datum/supply_packs/glass50
	name = "50 glass sheets"
	contains = list(/obj/item/stack/material/glass)
	amount = 50
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "Glass sheets crate"
	group = "Engineering"

/datum/supply_packs/wood50
	name = "50 wooden planks"
	contains = list(/obj/item/stack/material/wood)
	amount = 50
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "Wooden planks crate"
	group = "Engineering"

/datum/supply_packs/plastic50
	name = "50 plastic sheets"
	contains = list(/obj/item/stack/material/plastic)
	amount = 50
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "Plastic sheets crate"
	group = "Engineering"

/datum/supply_packs/smescoil
	name = "Superconducting Magnetic Coil"
	contains = list(/obj/item/weapon/smes_coil)
	cost = 75
	containertype = /obj/structure/closet/crate
	containername = "Superconducting Magnetic Coil crate"
	group = "Engineering"

/datum/supply_packs/electrical
	name = "Electrical maintenance crate"
	contains = list(
			/obj/item/weapon/storage/toolbox/electrical = 2,
			/obj/item/clothing/gloves/yellow = 2,
			/obj/item/weapon/cell = 2,
			/obj/item/weapon/cell/high = 2
			)
	cost = 15
	containertype = /obj/structure/closet/crate
	containername = "Electrical maintenance crate"
	group = "Engineering"

/datum/supply_packs/mechanical
	name = "Mechanical maintenance crate"
	contains = list(
			/obj/item/weapon/storage/belt/utility/full = 3,
			/obj/item/clothing/suit/storage/hazardvest = 3,
			/obj/item/clothing/head/welding = 2,
			/obj/item/clothing/head/hardhat
			)
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "Mechanical maintenance crate"
	group = "Engineering"

/datum/supply_packs/watertank
	name = "Water tank crate"
	contains = list(/obj/structure/reagent_dispensers/watertank)
	cost = 8
	containertype = /obj/structure/largecrate
	containername = "water tank crate"
	group = "Hydroponics"

/datum/supply_packs/fueltank
	name = "Fuel tank crate"
	contains = list(/obj/structure/reagent_dispensers/fueltank)
	cost = 8
	containertype = /obj/structure/largecrate
	containername = "fuel tank crate"
	group = "Engineering"

/datum/supply_packs/coolanttank
	name = "Coolant tank crate"
	contains = list(/obj/structure/reagent_dispensers/coolanttank)
	cost = 16
	containertype = /obj/structure/largecrate
	containername = "coolant tank crate"
	group = "Science"

/datum/supply_packs/solar
	name = "Solar Pack crate"
	contains  = list(
			/obj/item/solar_assembly = 21,
			/obj/item/weapon/circuitboard/solar_control,
			/obj/item/weapon/tracker_electronics,
			/obj/item/weapon/paper/solar
			)
	cost = 20
	containertype = /obj/structure/closet/crate
	containername = "Solar pack crate"
	group = "Engineering"

/datum/supply_packs/engine
	name = "Emitter crate"
	contains = list(/obj/machinery/power/emitter = 2)
	cost = 10
	containertype = /obj/structure/closet/crate/secure
	containername = "Emitter crate"
	access = access_ce
	group = "Engineering"

/datum/supply_packs/engine/field_gen
	name = "Field Generator crate"
	contains = list(/obj/machinery/field_generator = 2)
	containertype = /obj/structure/closet/crate/secure
	containername = "Field Generator crate"
	access = access_ce
	group = "Engineering"

/datum/supply_packs/engine/sing_gen
	name = "Singularity Generator crate"
	contains = list(/obj/machinery/the_singularitygen)
	containertype = /obj/structure/closet/crate/secure
	containername = "Singularity Generator crate"
	access = access_ce
	group = "Engineering"

/datum/supply_packs/engine/collector
	name = "Collector crate"
	contains = list(/obj/machinery/power/rad_collector = 3)
	containername = "Collector crate"
	group = "Engineering"

/datum/supply_packs/engine/PA
	name = "Particle Accelerator crate"
	cost = 40
	contains = list(
			/obj/structure/particle_accelerator/fuel_chamber,
			/obj/machinery/particle_accelerator/control_box,
			/obj/structure/particle_accelerator/particle_emitter/center,
			/obj/structure/particle_accelerator/particle_emitter/left,
			/obj/structure/particle_accelerator/particle_emitter/right,
			/obj/structure/particle_accelerator/power_box,
			/obj/structure/particle_accelerator/end_cap
			)
	containertype = /obj/structure/closet/crate/secure
	containername = "Particle Accelerator crate"
	access = access_ce
	group = "Engineering"

/datum/supply_packs/mecha_ripley
	name = "Circuit Crate (\"Ripley\" APLU)"
	contains = list(
			/obj/item/weapon/book/manual/ripley_build_and_repair,
			/obj/item/weapon/circuitboard/mecha/ripley/main,
			/obj/item/weapon/circuitboard/mecha/ripley/peripherals
			)
	cost = 30
	containertype = /obj/structure/closet/crate/secure
	containername = "APLU \"Ripley\" Circuit Crate"
	access = access_robotics
	group = "Science"

/datum/supply_packs/mecha_odysseus
	name = "Circuit Crate (\"Odysseus\")"
	contains = list(
			/obj/item/weapon/circuitboard/mecha/odysseus/peripherals,
			/obj/item/weapon/circuitboard/mecha/odysseus/main
			)
	cost = 25
	containertype = /obj/structure/closet/crate/secure
	containername = "\"Odysseus\" Circuit Crate"
	access = access_robotics
	group = "Science"

/datum/supply_packs/hoverpod
	name = "Hoverpod Shipment"
	contains = list()
	cost = 80
	containertype = /obj/structure/largecrate/hoverpod
	containername = "Hoverpod Crate"
	group = "Operations"

/datum/supply_packs/robotics
	name = "Robotics assembly crate"
	contains = list(
			/obj/item/device/assembly/prox_sensor = 3,
			/obj/item/weapon/storage/toolbox/electrical,
			/obj/item/device/flash = 4,
			/obj/item/weapon/cell/high = 2
			)
	cost = 10
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "Robotics assembly"
	access = access_robotics
	group = "Engineering"

/datum/supply_packs/robolimbs_basic
	name = "Basic robolimb blueprints"
	contains = list(
			/obj/item/weapon/disk/limb/morpheus,
			/obj/item/weapon/disk/limb/xion
			)
	cost = 15
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "Robolimb blueprints (basic)"
	access = access_robotics
	group = "Engineering"

/datum/supply_packs/robolimbs_adv
	name = "All robolimb blueprints"
	contains = list(
	/obj/item/weapon/disk/limb/bishop,
	/obj/item/weapon/disk/limb/hesphiastos,
	/obj/item/weapon/disk/limb/morpheus,
	/obj/item/weapon/disk/limb/veymed,
	/obj/item/weapon/disk/limb/wardtakahashi,
	/obj/item/weapon/disk/limb/xion,
	/obj/item/weapon/disk/limb/zenghu,
			)
	cost = 40
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "Robolimb blueprints (adv)"
	access = access_robotics
	group = "Engineering"

/datum/supply_packs/phoron
	name = "Phoron assembly crate"
	contains = list(
			/obj/item/weapon/tank/phoron = 3,
			/obj/item/device/assembly/igniter = 3,
			/obj/item/device/assembly/prox_sensor = 3,
			/obj/item/device/assembly/timer = 3
			)
	cost = 10
	containertype = /obj/structure/closet/crate/secure/phoron
	containername = "Phoron assembly crate"
	access = access_tox_storage
	group = "Science"

/datum/supply_packs/weapons
	name = "Weapons crate"
	contains = list(
			/obj/item/weapon/melee/baton = 2,
			/obj/item/weapon/gun/energy/gun = 2,
			/obj/item/weapon/gun/energy/taser = 2,
			/obj/item/weapon/gun/projectile/colt/detective = 2,
			/obj/item/weapon/storage/box/flashbangs = 2
			)
	cost = 40
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "Weapons crate"
	access = access_security
	group = "Security"

/datum/supply_packs/flareguns
	name = "Flare guns crate"
	contains = list(
			/obj/item/weapon/gun/projectile/sec/flash,
			/obj/item/ammo_magazine/c45m/flash,
			/obj/item/weapon/gun/projectile/shotgun/doublebarrel/flare,
			/obj/item/weapon/storage/box/flashshells
			)
	cost = 25
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "Flare gun crate"
	access = access_security
	group = "Security"

/datum/supply_packs/eweapons
	name = "Experimental weapons crate"
	contains = list(
			/obj/item/weapon/gun/energy/xray = 2,
			/obj/item/weapon/shield/energy = 2)
	cost = 125
	containertype = /obj/structure/closet/crate/secure/weapon
	containername = "Experimental weapons crate"
	access = access_armory
	group = "Security"

/datum/supply_packs/randomised/armor
	num_contained = 5
	contains = list(
			/obj/item/clothing/suit/storage/vest,
			/obj/item/clothing/suit/storage/vest/officer,
			/obj/item/clothing/suit/storage/vest/warden,
			/obj/item/clothing/suit/storage/vest/hos,
			/obj/item/clothing/suit/storage/vest/pcrc,
			/obj/item/clothing/suit/storage/vest/detective,
			/obj/item/clothing/suit/storage/vest/heavy,
			/obj/item/clothing/suit/storage/vest/heavy/officer,
			/obj/item/clothing/suit/storage/vest/heavy/warden,
			/obj/item/clothing/suit/storage/vest/heavy/hos,
			/obj/item/clothing/suit/storage/vest/heavy/pcrc
			)

	name = "Armor crate"
	cost = 40
	containertype = /obj/structure/closet/crate/secure
	containername = "Armor crate"
	access = access_security
	group = "Security"

/datum/supply_packs/riot_gear
	name = "Riot gear crate"
	contains = list(
			/obj/item/weapon/melee/baton = 3,
			/obj/item/weapon/shield/riot = 3,
			/obj/item/weapon/handcuffs = 3,
			/obj/item/weapon/storage/box/flashbangs,
			/obj/item/weapon/storage/box/beanbags,
			/obj/item/weapon/storage/box/handcuffs
			)
	cost = 40
	containertype = /obj/structure/closet/crate/secure
	containername = "riot gear crate"
	access = access_armory
	group = "Security"

/datum/supply_packs/riot_armor
	name = "Riot armor set crate"
	contains = list(
			/obj/item/clothing/head/helmet/riot,
			/obj/item/clothing/suit/armor/riot,
			/obj/item/clothing/gloves/arm_guard/riot,
			/obj/item/clothing/shoes/leg_guard/riot
			)
	cost = 30
	containertype = /obj/structure/closet/crate/secure
	containername = "riot armor set crate"
	access = access_armory
	group = "Security"

/datum/supply_packs/ablative_armor
	name = "Ablative armor set crate"
	contains = list(
			/obj/item/clothing/head/helmet/laserproof,
			/obj/item/clothing/suit/armor/laserproof,
			/obj/item/clothing/gloves/arm_guard/laserproof,
			/obj/item/clothing/shoes/leg_guard/laserproof
			)
	cost = 40
	containertype = /obj/structure/closet/crate/secure
	containername = "ablative armor set crate"
	access = access_armory
	group = "Security"

/datum/supply_packs/bullet_resistant_armor
	name = "Bullet resistant armor set crate"
	contains = list(
			/obj/item/clothing/head/helmet/bulletproof,
			/obj/item/clothing/suit/armor/bulletproof,
			/obj/item/clothing/gloves/arm_guard/bulletproof,
			/obj/item/clothing/shoes/leg_guard/bulletproof
			)
	cost = 35
	containertype = /obj/structure/closet/crate/secure
	containername = "bullet resistant armor set crate"
	access = access_armory
	group = "Security"

/datum/supply_packs/combat_armor
	name = "Combat armor set crate"
	contains = list(
			/obj/item/clothing/head/helmet/combat,
			/obj/item/clothing/suit/armor/combat,
			/obj/item/clothing/gloves/arm_guard/combat,
			/obj/item/clothing/shoes/leg_guard/combat
			)
	cost = 40
	containertype = /obj/structure/closet/crate/secure
	containername = "combat armor set crate"
	access = access_armory
	group = "Security"

/datum/supply_packs/tactical
	name = "Tactical suits"
	containertype = /obj/structure/closet/crate/secure
	containername = "Tactical Suit Locker"
	cost = 60
	group = "Security"
	access = access_armory
	contains = list(
			/obj/item/clothing/under/tactical,
			/obj/item/clothing/suit/armor/tactical,
			/obj/item/clothing/head/helmet/tactical,
			/obj/item/clothing/mask/balaclava/tactical,
			/obj/item/clothing/glasses/sunglasses/sechud/tactical,
			/obj/item/weapon/storage/belt/security/tactical,
			/obj/item/clothing/shoes/jackboots,
			/obj/item/clothing/gloves/black,
			/obj/item/clothing/under/tactical,
			/obj/item/clothing/suit/armor/tactical,
			/obj/item/clothing/head/helmet/tactical,
			/obj/item/clothing/mask/balaclava/tactical,
			/obj/item/clothing/glasses/sunglasses/sechud/tactical,
			/obj/item/weapon/storage/belt/security/tactical,
			/obj/item/clothing/shoes/jackboots,
			/obj/item/clothing/gloves/black
			)

/datum/supply_packs/energyweapons
	name = "Energy weapons crate"
	contains = list(/obj/item/weapon/gun/energy/laser = 3)
	cost = 50
	containertype = /obj/structure/closet/crate/secure
	containername = "energy weapons crate"
	access = access_armory
	group = "Security"

/datum/supply_packs/shotgun
	name = "Shotgun crate"
	contains = list(
			/obj/item/weapon/storage/box/shotgunammo,
			/obj/item/weapon/storage/box/shotgunshells,
			/obj/item/weapon/gun/projectile/shotgun/pump/combat = 2
			)
	cost = 65
	containertype = /obj/structure/closet/crate/secure
	containername = "Shotgun crate"
	access = access_armory
	group = "Security"

/datum/supply_packs/erifle
	name = "Energy marksman crate"
	contains = list(/obj/item/weapon/gun/energy/sniperrifle = 2)
	cost = 90
	containertype = /obj/structure/closet/crate/secure
	containername = "Energy marksman crate"
	access = access_armory
	group = "Security"

/datum/supply_packs/shotgunammo
	name = "Ballistic ammunition crate"
	contains = list(
			/obj/item/weapon/storage/box/shotgunammo = 2,
			/obj/item/weapon/storage/box/shotgunshells = 2
			)
	cost = 60
	containertype = /obj/structure/closet/crate/secure
	containername = "ballistic ammunition crate"
	access = access_armory
	group = "Security"

/datum/supply_packs/ionweapons
	name = "Electromagnetic weapons crate"
	contains = list(
			/obj/item/weapon/gun/energy/ionrifle = 2,
			/obj/item/weapon/storage/box/emps
			)
	cost = 50
	containertype = /obj/structure/closet/crate/secure
	containername = "electromagnetic weapons crate"
	access = access_armory
	group = "Security"

/datum/supply_packs/randomised/automatic
	name = "Automatic weapon crate"
	num_contained = 2
	contains = list(
			/obj/item/weapon/gun/projectile/automatic/wt550,
			/obj/item/weapon/gun/projectile/automatic/z8
			)
	cost = 90
	containertype = /obj/structure/closet/crate/secure
	containername = "Automatic weapon crate"
	access = access_armory
	group = "Security"

/datum/supply_packs/randomised/autoammo
	name = "Automatic weapon ammunition crate"
	num_contained = 6
	contains = list(
			/obj/item/ammo_magazine/mc9mmt,
			/obj/item/ammo_magazine/mc9mmt/rubber,
			/obj/item/ammo_magazine/a556
			)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "Automatic weapon ammunition crate"
	access = access_armory
	group = "Security"

/datum/supply_packs/energy_guns
	name = "energy guns crate"
	contains = list(/obj/item/weapon/gun/energy/gun = 2)
	cost = 50
	containertype = /obj/structure/closet/crate/secure
	containername = "energy guns crate"
	access = access_armory
	group = "Security"

/datum/supply_packs/securitybarriers
	name = "Security barrier crate"
	contains = list(/obj/machinery/deployable/barrier = 4)
	cost = 20
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "Security barrier crate"
	group = "Security"

/datum/supply_packs/securityshieldgen
	name = "Wall shield Generators"
	contains = list(/obj/machinery/shieldwallgen = 4)
	cost = 20
	containertype = /obj/structure/closet/crate/secure
	containername = "wall shield generators crate"
	access = access_teleporter
	group = "Security"

/datum/supply_packs/randomised
	var/num_contained = 4 //number of items picked to be contained in a randomised crate
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
	containertype = /obj/structure/closet/crate
	containername = "Collectable hats crate! Brought to you by Bass.inc!"
	group = "Miscellaneous"

/datum/supply_packs/randomised/New()
	manifest += "Contains any [num_contained] of:"
	..()

/datum/supply_packs/artscrafts
	name = "Arts and Crafts supplies"
	contains = list(
			/obj/item/weapon/storage/fancy/crayons,
			/obj/item/device/camera,
			/obj/item/device/camera_film = 2,
			/obj/item/weapon/storage/photo_album,
			/obj/item/weapon/packageWrap,
			/obj/item/weapon/reagent_containers/glass/paint/red,
			/obj/item/weapon/reagent_containers/glass/paint/green,
			/obj/item/weapon/reagent_containers/glass/paint/blue,
			/obj/item/weapon/reagent_containers/glass/paint/yellow,
			/obj/item/weapon/reagent_containers/glass/paint/purple,
			/obj/item/weapon/reagent_containers/glass/paint/black,
			/obj/item/weapon/reagent_containers/glass/paint/white,
			/obj/item/weapon/contraband/poster,
			/obj/item/weapon/wrapping_paper = 3
			)
	cost = 10
	containertype = "/obj/structure/closet/crate"
	containername = "Arts and Crafts crate"
	group = "Operations"


/datum/supply_packs/randomised/contraband
	num_contained = 5
	contains = list(
			/obj/item/seeds/bloodtomatoseed,
			/obj/item/weapon/storage/pill_bottle/zoom,
			/obj/item/weapon/storage/pill_bottle/happy,
			/obj/item/weapon/reagent_containers/food/drinks/bottle/pwine
			)

	name = "Contraband crate"
	cost = 30
	containertype = /obj/structure/closet/crate
	containername = "Unlabeled crate"
	contraband = 1
	group = "Operations"

/datum/supply_packs/boxes
	name = "Empty boxes"
	contains = list(/obj/item/weapon/storage/box = 10)
	cost = 10
	containertype = "/obj/structure/closet/crate"
	containername = "Empty box crate"
	group = "Supply"

/datum/supply_packs/surgery
	name = "Surgery crate"
	contains = list(
			/obj/item/weapon/cautery,
			/obj/item/weapon/surgicaldrill,
			/obj/item/clothing/mask/breath/medical,
			/obj/item/weapon/tank/anesthetic,
			/obj/item/weapon/FixOVein,
			/obj/item/weapon/hemostat,
			/obj/item/weapon/scalpel,
			/obj/item/weapon/bonegel,
			/obj/item/weapon/retractor,
			/obj/item/weapon/bonesetter,
			/obj/item/weapon/circular_saw
			)
	cost = 25
	containertype = "/obj/structure/closet/crate/secure"
	containername = "Surgery crate"
	access = access_medical
	group = "Medical"

/datum/supply_packs/sterile
	name = "Sterile equipment crate"
	contains = list(
			/obj/item/clothing/under/rank/medical/green = 2,
			/obj/item/clothing/head/surgery/green = 2,
			/obj/item/weapon/storage/box/masks,
			/obj/item/weapon/storage/box/gloves,
			/obj/item/weapon/storage/belt/medical = 3
			)
	cost = 15
	containertype = "/obj/structure/closet/crate"
	containername = "Sterile equipment crate"
	group = "Medical"

/datum/supply_packs/randomised/pizza
	num_contained = 5
	contains = list(
			/obj/item/pizzabox/margherita,
			/obj/item/pizzabox/mushroom,
			/obj/item/pizzabox/meat,
			/obj/item/pizzabox/vegetable
			)
	name = "Surprise pack of five pizzas"
	cost = 15
	containertype = /obj/structure/closet/crate/freezer
	containername = "Pizza crate"
	group = "Hospitality"

/datum/supply_packs/randomised/costume
	num_contained = 3
	contains = list(
			/obj/item/clothing/suit/pirate,
			/obj/item/clothing/suit/judgerobe,
			/obj/item/clothing/suit/wcoat,
			/obj/item/clothing/suit/hastur,
			/obj/item/clothing/suit/holidaypriest,
			/obj/item/clothing/suit/nun,
			/obj/item/clothing/suit/imperium_monk,
			/obj/item/clothing/suit/ianshirt,
			/obj/item/clothing/under/gimmick/rank/captain/suit,
			/obj/item/clothing/under/gimmick/rank/head_of_personnel/suit,
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
			/obj/item/clothing/suit/apron/overalls,
			/obj/item/clothing/under/redcoat,
			/obj/item/clothing/under/kilt
			)
	name = "Costumes crate"
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "Actor Costumes"
	group = "Miscellaneous"

/datum/supply_packs/formal_wear
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
			/obj/item/clothing/shoes/leather,
			/obj/item/clothing/suit/wcoat
			)
	name = "Formalwear closet"
	cost = 30
	containertype = /obj/structure/closet
	containername = "Formalwear for the best occasions."
	group = "Miscellaneous"

/datum/supply_packs/randomised/card_packs
	num_contained = 5
	contains = list(
			/obj/item/weapon/pack/cardemon,
			/obj/item/weapon/pack/spaceball,
			/obj/item/weapon/deck/holder
			)
	name = "Trading Card Crate"
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "cards crate"
	group = "Miscellaneous"

/datum/supply_packs/shield_gen
	contains = list(/obj/item/weapon/circuitboard/shield_gen)
	name = "Bubble shield generator circuitry"
	cost = 50
	containertype = /obj/structure/closet/crate/secure
	containername = "bubble shield generator circuitry crate"
	group = "Engineering"
	access = access_ce

/datum/supply_packs/shield_gen_ex
	contains = list(/obj/item/weapon/circuitboard/shield_gen_ex)
	name = "Hull shield generator circuitry"
	cost = 50
	containertype = /obj/structure/closet/crate/secure
	containername = "hull shield generator circuitry crate"
	group = "Engineering"
	access = access_ce

/datum/supply_packs/shield_cap
	contains = list(/obj/item/weapon/circuitboard/shield_cap)
	name = "Bubble shield capacitor circuitry"
	cost = 50
	containertype = /obj/structure/closet/crate/secure
	containername = "shield capacitor circuitry crate"
	group = "Engineering"
	access = access_ce

/datum/supply_packs/smbig
	name = "Supermatter Core"
	contains = list(/obj/machinery/power/supermatter)
	cost = 150
	containertype = /obj/structure/closet/crate/secure/phoron
	containername = "Supermatter crate (CAUTION)"
	group = "Engineering"
	access = access_ce

/datum/supply_packs/eftpos
	contains = list(/obj/item/device/eftpos)
	name = "EFTPOS scanner"
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "EFTPOS crate"
	group = "Miscellaneous"

/datum/supply_packs/teg
	contains = list(/obj/machinery/power/generator)
	name = "Mark I Thermoelectric Generator"
	cost = 75
	containertype = /obj/structure/closet/crate/secure/large
	containername = "Mk1 TEG crate"
	group = "Engineering"
	access = access_engine

/datum/supply_packs/circulator
	contains = list(/obj/machinery/atmospherics/binary/circulator)
	name = "Binary atmospheric circulator"
	cost = 60
	containertype = /obj/structure/closet/crate/secure/large
	containername = "Atmospheric circulator crate"
	group = "Engineering"
	access = access_engine

/datum/supply_packs/air_dispenser
	contains = list(/obj/machinery/pipedispenser/orderable)
	name = "Pipe Dispenser"
	cost = 35
	containertype = /obj/structure/closet/crate/secure/large
	containername = "Pipe Dispenser Crate"
	group = "Engineering"
	access = access_atmospherics

/datum/supply_packs/disposals_dispenser
	contains = list(/obj/machinery/pipedispenser/disposal/orderable)
	name = "Disposals Pipe Dispenser"
	cost = 35
	containertype = /obj/structure/closet/crate/secure/large
	containername = "Disposal Dispenser Crate"
	group = "Engineering"
	access = access_atmospherics

/datum/supply_packs/bee_keeper
	name = "Beekeeping crate"
	contains = list(
			/obj/item/beehive_assembly,
			/obj/item/bee_smoker,
			/obj/item/honey_frame = 5,
			/obj/item/bee_pack
			)
	cost = 40
	containertype = /obj/structure/closet/crate/hydroponics
	containername = "Beekeeping crate"
	access = access_hydroponics
	group = "Hydroponics"

/datum/supply_packs/cardboard_sheets
	contains = list(/obj/item/stack/material/cardboard)
	name = "50 cardboard sheets"
	amount = 50
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "Cardboard sheets crate"
	group = "Miscellaneous"

/datum/supply_packs/bureaucracy
	contains = list(
			/obj/item/weapon/clipboard = 2,
			/obj/item/weapon/pen/red,
			/obj/item/weapon/pen/blue,
			/obj/item/weapon/pen/blue,
			/obj/item/device/camera_film,
			/obj/item/weapon/folder/blue,
			/obj/item/weapon/folder/red,
			/obj/item/weapon/folder/yellow,
			/obj/item/weapon/hand_labeler,
			/obj/item/weapon/tape_roll,
			/obj/structure/filingcabinet/chestdrawer{anchored = 0},
			/obj/item/weapon/paper_bin
			)
	name = "Office supplies"
	cost = 15
	containertype = /obj/structure/closet/crate
	containername = "Office supplies crate"
	group = "Supply"

/datum/supply_packs/radsuit
	contains = list(
			/obj/item/clothing/suit/radiation = 3,
			/obj/item/clothing/head/radiation = 3
			)
	name = "Radiation suits package"
	cost = 20
	containertype = /obj/structure/closet/radiation
	containername = "Radiation suit locker"
	group = "Engineering"

/datum/supply_packs/carpet
	name = "Imported carpet"
	containertype = /obj/structure/closet/crate
	containername = "Imported carpet crate"
	cost = 15
	group = "Miscellaneous"
	contains = list(
					/obj/item/stack/tile/carpet,
					/obj/item/stack/tile/carpet/blue
					)
	amount = 50

/datum/supply_packs/linoleum
	name = "Linoleum"
	containertype = /obj/structure/closet/crate
	containername = "Linoleum crate"
	cost = 15
	group = "Miscellaneous"
	contains = list(/obj/item/stack/tile/linoleum)
	amount = 50

/datum/supply_packs/hydrotray
	name = "Empty hydroponics tray"
	cost = 30
	containertype = /obj/structure/closet/crate/hydroponics
	containername = "Hydroponics tray crate"
	group = "Hydroponics"
	contains = list(/obj/machinery/portable_atmospherics/hydroponics{anchored = 0})
	access = access_hydroponics

/datum/supply_packs/canister_empty
	name = "Empty gas canister"
	cost = 7
	containername = "Empty gas canister crate"
	containertype = /obj/structure/largecrate
	contains = list(/obj/machinery/portable_atmospherics/canister)
	group = "Atmospherics"

/datum/supply_packs/canister_air
	name = "Air canister"
	cost = 10
	containername = "Air canister crate"
	containertype = /obj/structure/largecrate
	group = "Atmospherics"
	contains = list(/obj/machinery/portable_atmospherics/canister/air)

/datum/supply_packs/canister_oxygen
	name = "Oxygen canister"
	cost = 15
	containername = "Oxygen canister crate"
	containertype = /obj/structure/largecrate
	group = "Atmospherics"
	contains = list(/obj/machinery/portable_atmospherics/canister/oxygen)

/datum/supply_packs/canister_nitrogen
	name = "Nitrogen canister"
	cost = 10
	containername = "Nitrogen canister crate"
	containertype = /obj/structure/largecrate
	group = "Atmospherics"
	contains = list(/obj/machinery/portable_atmospherics/canister/nitrogen)

/datum/supply_packs/canister_phoron
	name = "Phoron gas canister"
	cost = 60
	containername = "Phoron gas canister crate"
	containertype = /obj/structure/closet/crate/secure/large
	access = access_atmospherics
	group = "Atmospherics"
	contains = list(/obj/machinery/portable_atmospherics/canister/phoron)

/datum/supply_packs/canister_sleeping_agent
	name = "N2O gas canister"
	cost = 40
	containername = "N2O gas canister crate"
	containertype = /obj/structure/closet/crate/secure/large
	access = access_atmospherics
	group = "Atmospherics"
	contains = list(/obj/machinery/portable_atmospherics/canister/sleeping_agent)

/datum/supply_packs/canister_carbon_dioxide
	name = "Carbon dioxide gas canister"
	cost = 40
	containername = "CO2 canister crate"
	containertype = /obj/structure/closet/crate/secure/large
	access = access_atmospherics
	group = "Atmospherics"
	contains = list(/obj/machinery/portable_atmospherics/canister/carbon_dioxide)

/datum/supply_packs/pacman_parts
	name = "P.A.C.M.A.N. portable generator parts"
	cost = 45
	containername = "P.A.C.M.A.N. Portable Generator Construction Kit"
	containertype = /obj/structure/closet/crate/secure
	group = "Engineering"
	access = access_tech_storage
	contains = list(
			/obj/item/weapon/stock_parts/micro_laser,
			/obj/item/weapon/stock_parts/capacitor,
			/obj/item/weapon/stock_parts/matter_bin,
			/obj/item/weapon/circuitboard/pacman
			)

/datum/supply_packs/super_pacman_parts
	name = "Super P.A.C.M.A.N. portable generator parts"
	cost = 55
	containername = "Super P.A.C.M.A.N. portable generator construction kit"
	containertype = /obj/structure/closet/crate/secure
	group = "Engineering"
	access = access_tech_storage
	contains = list(
			/obj/item/weapon/stock_parts/micro_laser,
			/obj/item/weapon/stock_parts/capacitor,
			/obj/item/weapon/stock_parts/matter_bin,
			/obj/item/weapon/circuitboard/pacman/super
			)

/datum/supply_packs/witch
	name = "Witch costume"
	containername = "Witch costume"
	containertype = /obj/structure/closet
	cost = 20
	contains = list(
			/obj/item/clothing/suit/wizrobe/marisa/fake,
			/obj/item/clothing/shoes/sandal,
			/obj/item/clothing/head/wizard/marisa/fake,
			/obj/item/weapon/staff/broom
			)
	group = "Miscellaneous"

/datum/supply_packs/randomised/costume_hats
	name = "Costume hats"
	containername = "Actor hats crate"
	containertype = /obj/structure/closet
	cost = 10
	num_contained = 3
	contains = list(
			/obj/item/clothing/head/redcoat,
			/obj/item/clothing/head/mailman,
			/obj/item/clothing/head/plaguedoctorhat,
			/obj/item/clothing/head/pirate,
			/obj/item/clothing/head/hasturhood,
			/obj/item/clothing/head/powdered_wig,
			/obj/item/clothing/head/hairflower,
			/obj/item/clothing/head/hairflower/yellow,
			/obj/item/clothing/head/hairflower/blue,
			/obj/item/clothing/head/hairflower/pink,
			/obj/item/clothing/mask/gas/owl_mask,
			/obj/item/clothing/mask/gas/monkeymask,
			/obj/item/clothing/head/helmet/gladiator,
			/obj/item/clothing/head/ushanka
			)
	group = "Miscellaneous"

/datum/supply_packs/spare_pda
	name = "Spare PDAs"
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "Spare PDA crate"
	group = "Supply"
	contains = list(/obj/item/device/pda = 3)

/datum/supply_packs/randomised/dresses
	name = "Womens formal dress locker"
	containername = "Pretty dress locker"
	containertype = /obj/structure/closet
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
	group = "Miscellaneous"

/datum/supply_packs/painters
	name = "Station Painting Supplies"
	cost = 10
	containername = "station painting supplies crate"
	containertype = /obj/structure/closet/crate
	group = "Engineering"
	contains = list(
			/obj/item/device/pipe_painter = 2,
			/obj/item/device/floor_painter = 2,
			/obj/item/device/closet_painter = 2
			)

/datum/supply_packs/randomised/exosuit_mod
	num_contained = 1
	contains = list(
			/obj/item/device/kit/paint/ripley,
			/obj/item/device/kit/paint/ripley/death,
			/obj/item/device/kit/paint/ripley/flames_red,
			/obj/item/device/kit/paint/ripley/flames_blue
			)
	name = "Random APLU modkit"
	cost = 200
	containertype = /obj/structure/closet/crate
	containername = "heavy crate"
	group = "Miscellaneous"

/datum/supply_packs/randomised/exosuit_mod/durand
	contains = list(
			/obj/item/device/kit/paint/durand,
			/obj/item/device/kit/paint/durand/seraph,
			/obj/item/device/kit/paint/durand/phazon
			)
	name = "Random Durand exosuit modkit"

/datum/supply_packs/randomised/exosuit_mod/gygax
	contains = list(
			/obj/item/device/kit/paint/gygax,
			/obj/item/device/kit/paint/gygax/darkgygax,
			/obj/item/device/kit/paint/gygax/recitence
			)
	name = "Random Gygax exosuit modkit"

/datum/supply_packs/engineeringvoidsuits
	name = "Engineering voidsuits"
	contains = list(
			/obj/item/clothing/suit/space/void/engineering = 2,
			/obj/item/clothing/head/helmet/space/void/engineering = 2,
			/obj/item/clothing/mask/breath = 2,
			/obj/item/clothing/shoes/magboots = 2,
			/obj/item/weapon/tank/oxygen = 2
			)
	cost = 40
	containertype = "/obj/structure/closet/crate/secure"
	containername = "Engineering voidsuit crate"
	access = access_engine_equip
	group = "Engineering"

/datum/supply_packs/atmosvoidsuits
	name = "Atmospheric voidsuits"
	contains = list(
			/obj/item/clothing/suit/space/void/atmos = 2,
			/obj/item/clothing/head/helmet/space/void/atmos = 2,
			/obj/item/clothing/mask/breath = 2,
			/obj/item/clothing/shoes/magboots = 2,
			/obj/item/weapon/tank/oxygen = 2,
			)
	cost = 45
	containertype = "/obj/structure/closet/crate/secure"
	containername = "Atmospheric voidsuit crate"
	access = access_atmospherics
	group = "Atmospherics"

/datum/supply_packs/miningvoidsuits
	name = "Mining voidsuits"
	contains = list(
			/obj/item/clothing/suit/space/void/mining = 2,
			/obj/item/clothing/head/helmet/space/void/mining = 2,
			/obj/item/clothing/mask/breath = 2,
			/obj/item/weapon/tank/oxygen = 2
			)
	cost = 35
	containertype = "/obj/structure/closet/crate/secure"
	containername = "Mining voidsuit crate"
	access = access_mining
	group = "Supply"

/datum/supply_packs/randomised/webbing
	name = "Webbing crate"
	num_contained = 4
	contains = list(
			/obj/item/clothing/accessory/storage/black_vest,
			/obj/item/clothing/accessory/storage/brown_vest,
			/obj/item/clothing/accessory/storage/white_vest,
			/obj/item/clothing/accessory/storage/black_drop_pouches,
			/obj/item/clothing/accessory/storage/brown_drop_pouches,
			/obj/item/clothing/accessory/storage/white_drop_pouches,
			/obj/item/clothing/accessory/storage/webbing
			)
	cost = 15
	containertype = "/obj/structure/closet/crate"
	containername = "Webbing crate"
	group = "Operations"

/datum/supply_packs/securityvoidsuits
	name = "Security voidsuits"
	contains = list(
			/obj/item/clothing/suit/space/void/security = 2,
			/obj/item/clothing/head/helmet/space/void/security = 2,
			/obj/item/clothing/mask/breath = 2,
			/obj/item/clothing/shoes/magboots = 2,
			/obj/item/weapon/tank/oxygen = 2
			)
	cost = 55
	containertype = "/obj/structure/closet/crate/secure"
	containername = "Security voidsuit crate"
	access = access_security
	group = "Security"

/datum/supply_packs/randomised/holster
	name = "Holster crate"
	num_contained = 4
	contains = list(
			/obj/item/clothing/accessory/holster,
			/obj/item/clothing/accessory/holster/armpit,
			/obj/item/clothing/accessory/holster/waist,
			/obj/item/clothing/accessory/holster/hip
			)
	cost = 15
	containertype = "/obj/structure/closet/crate/secure"
	containername = "Holster crate"
	access = access_security
	group = "Security"

/datum/supply_packs/medicalvoidsuits
	name = "Medical voidsuits"
	contains = list(
			/obj/item/clothing/suit/space/void/medical = 2,
			/obj/item/clothing/head/helmet/space/void/medical = 2,
			/obj/item/clothing/mask/breath = 2,
			/obj/item/clothing/shoes/magboots = 2,
			/obj/item/weapon/tank/oxygen = 2
			)
	cost = 40
	containertype = "/obj/structure/closet/crate/secure"
	containername = "Medical voidsuit crate"
	access = access_medical_equip
	group = "Medical"

/datum/supply_packs/securityextragear
	name = "Security surplus equipment"
	contains = list(
			/obj/item/weapon/storage/belt/security = 3,
			/obj/item/clothing/glasses/sunglasses/sechud = 3,
			/obj/item/device/radio/headset/headset_sec/alt = 3,
			/obj/item/clothing/suit/storage/hooded/wintercoat/security = 3
			)
	cost = 25
	containertype = "/obj/structure/closet/crate/secure"
	containername = "Security surplus equipment"
	access = access_security
	group = "Security"

/datum/supply_packs/detectivegear
	name = "Forensic investigation equipment"
	contains = list(
			/obj/item/weapon/storage/box/evidence = 2,
			/obj/item/clothing/suit/storage/vest/detective,
			/obj/item/weapon/cartridge/detective,
			/obj/item/device/radio/headset/headset_sec,
			/obj/item/taperoll/police,
			/obj/item/clothing/glasses/sunglasses,
			/obj/item/device/camera,
			/obj/item/weapon/folder/red,
			/obj/item/weapon/folder/blue,
			/obj/item/weapon/storage/belt/detective,
			/obj/item/clothing/gloves/black,
			/obj/item/device/taperecorder,
			/obj/item/device/mass_spectrometer,
			/obj/item/device/camera_film = 2,
			/obj/item/weapon/storage/photo_album,
			/obj/item/device/reagent_scanner,
			/obj/item/device/flashlight/maglight,
			/obj/item/weapon/storage/briefcase/crimekit
			)
	cost = 40
	containertype = "/obj/structure/closet/crate/secure"
	containername = "Forensic equipment"
	access = access_forensics_lockers
	group = "Security"

/datum/supply_packs/detectiveclothes
	name = "Investigation apparel"
	contains = list(
			/obj/item/clothing/under/det/black = 2,
			/obj/item/clothing/under/det/grey = 2,
			/obj/item/clothing/head/det/grey = 2,
			/obj/item/clothing/under/det = 2,
			/obj/item/clothing/head/det = 2,
			/obj/item/clothing/suit/storage/det_trench,
			/obj/item/clothing/suit/storage/det_trench/grey,
			/obj/item/clothing/suit/storage/forensics/red,
			/obj/item/clothing/suit/storage/forensics/blue,
			/obj/item/clothing/under/det/corporate = 2,
			/obj/item/clothing/accessory/badge/holo/detective = 2,
			/obj/item/clothing/gloves/black = 2
			)
	cost = 20
	containertype = "/obj/structure/closet/crate/secure"
	containername = "Investigation clothing"
	access = access_forensics_lockers
	group = "Security"

/datum/supply_packs/officergear
	name = "Officer equipment"
	contains = list(
			/obj/item/clothing/suit/storage/vest/officer,
			/obj/item/clothing/head/helmet,
			/obj/item/weapon/cartridge/security,
			/obj/item/clothing/accessory/badge/holo,
			/obj/item/clothing/accessory/badge/holo/cord,
			/obj/item/device/radio/headset/headset_sec,
			/obj/item/weapon/storage/belt/security,
			/obj/item/device/flash,
			/obj/item/weapon/reagent_containers/spray/pepper,
			/obj/item/weapon/grenade/flashbang,
			/obj/item/weapon/melee/baton/loaded,
			/obj/item/clothing/glasses/sunglasses/sechud,
			/obj/item/taperoll/police,
			/obj/item/clothing/gloves/black,
			/obj/item/device/hailer,
			/obj/item/device/flashlight/flare,
			/obj/item/clothing/accessory/storage/black_vest,
			/obj/item/clothing/head/soft/sec/corp,
			/obj/item/clothing/under/rank/security/corp,
			/obj/item/weapon/gun/energy/taser,
			/obj/item/device/flashlight/maglight
			)
	cost = 30
	containertype = "/obj/structure/closet/crate/secure"
	containername = "Officer equipment"
	access = access_brig
	group = "Security"

/datum/supply_packs/wardengear
	name = "Warden equipment"
	contains = list(
			/obj/item/clothing/suit/storage/vest/warden,
			/obj/item/clothing/under/rank/warden,
			/obj/item/clothing/under/rank/warden/corp,
			/obj/item/clothing/suit/armor/vest/warden,
			/obj/item/clothing/suit/armor/vest/warden/alt,
			/obj/item/clothing/head/helmet/warden,
			/obj/item/weapon/cartridge/security,
			/obj/item/device/radio/headset/headset_sec,
			/obj/item/clothing/glasses/sunglasses/sechud,
			/obj/item/taperoll/police,
			/obj/item/device/hailer,
			/obj/item/clothing/accessory/badge/holo/warden,
			/obj/item/weapon/storage/box/flashbangs,
			/obj/item/weapon/storage/belt/security,
			/obj/item/weapon/reagent_containers/spray/pepper,
			/obj/item/weapon/melee/baton/loaded,
			/obj/item/weapon/storage/box/holobadge,
			/obj/item/clothing/head/beret/sec/corporate/warden,
			/obj/item/device/flashlight/maglight
			)
	cost = 45
	containertype = "/obj/structure/closet/crate/secure"
	containername = "Warden equipment"
	access = access_armory
	group = "Security"

/datum/supply_packs/headofsecgear
	name = "Head of security equipment"
	contains = list(
			/obj/item/clothing/head/helmet/HoS,
			/obj/item/clothing/suit/storage/vest/hos,
			/obj/item/clothing/under/rank/head_of_security/corp,
			/obj/item/clothing/suit/armor/hos,
			/obj/item/clothing/head/helmet/HoS/dermal,
			/obj/item/weapon/cartridge/hos,
			/obj/item/device/radio/headset/heads/hos,
			/obj/item/clothing/glasses/sunglasses/sechud,
			/obj/item/weapon/storage/belt/security,
			/obj/item/device/flash,
			/obj/item/device/hailer,
			/obj/item/clothing/accessory/badge/holo/hos,
			/obj/item/clothing/accessory/holster/waist,
			/obj/item/weapon/melee/telebaton,
			/obj/item/weapon/shield/riot/tele,
			/obj/item/clothing/head/beret/sec/corporate/hos,
			/obj/item/device/flashlight/maglight
			)
	cost = 65
	containertype = "/obj/structure/closet/crate/secure"
	containername = "Head of security equipment"
	access = access_hos
	group = "Security"

/datum/supply_packs/securityclothing
	name = "Security uniform crate"
	contains = list(
			/obj/item/weapon/storage/backpack/satchel/sec = 2,
			/obj/item/weapon/storage/backpack/security = 2,
			/obj/item/clothing/accessory/armband = 4,
			/obj/item/clothing/under/rank/security = 4,
			/obj/item/clothing/under/rank/security2 = 4,
			/obj/item/clothing/under/rank/warden,
			/obj/item/clothing/under/rank/head_of_security,
			/obj/item/clothing/suit/armor/hos/jensen,
			/obj/item/clothing/head/soft/sec = 4,
			/obj/item/clothing/gloves/black = 4,
			/obj/item/weapon/storage/box/holobadge
			)
	cost = 20
	containertype = "/obj/structure/closet/crate/secure"
	containername = "Security uniform crate"
	access = access_security
	group = "Security"

/datum/supply_packs/navybluesecurityclothing
	name = "Navy blue security uniform crate"
	contains = list(
			/obj/item/weapon/storage/backpack/satchel/sec = 2,
			/obj/item/weapon/storage/backpack/security = 2,
			/obj/item/clothing/under/rank/security/navyblue = 4,
			/obj/item/clothing/suit/security/navyofficer = 4,
			/obj/item/clothing/under/rank/warden/navyblue,
			/obj/item/clothing/suit/security/navywarden,
			/obj/item/clothing/under/rank/head_of_security/navyblue,
			/obj/item/clothing/suit/security/navyhos,
			/obj/item/clothing/head/beret/sec/navy/officer = 4,
			/obj/item/clothing/head/beret/sec/navy/warden,
			/obj/item/clothing/head/beret/sec/navy/hos,
			/obj/item/clothing/gloves/black = 4,
			/obj/item/weapon/storage/box/holobadge
			)
	cost = 20
	containertype = "/obj/structure/closet/crate/secure"
	containername = "Navy blue security uniform crate"
	access = access_security
	group = "Security"

/datum/supply_packs/corporatesecurityclothing
	name = "Corporate security uniform crate"
	contains = list(
			/obj/item/weapon/storage/backpack/satchel/sec = 2,
			/obj/item/weapon/storage/backpack/security = 2,
			/obj/item/clothing/under/rank/security/corp = 4,
			/obj/item/clothing/head/soft/sec/corp = 4,
			/obj/item/clothing/under/rank/warden/corp,
			/obj/item/clothing/under/rank/head_of_security/corp,
			/obj/item/clothing/head/beret/sec = 4,
			/obj/item/clothing/head/beret/sec/corporate/warden,
			/obj/item/clothing/head/beret/sec/corporate/hos,
			/obj/item/clothing/under/det/corporate = 2,
			/obj/item/clothing/gloves/black = 4,
			/obj/item/weapon/storage/box/holobadge
			)
	cost = 20
	containertype = "/obj/structure/closet/crate/secure"
	containername = "Corporate security uniform crate"
	access = access_security
	group = "Security"

/datum/supply_packs/securitybiosuit
	name = "Security biohazard gear"
	contains = list(
			/obj/item/clothing/head/bio_hood/security,
			/obj/item/clothing/under/rank/security,
			/obj/item/clothing/suit/bio_suit/security,
			/obj/item/clothing/shoes/white,
			/obj/item/clothing/mask/gas,
			/obj/item/weapon/tank/oxygen,
			/obj/item/clothing/gloves/latex
			)
	cost = 35
	containertype = "/obj/structure/closet/crate/secure"
	containername = "Security biohazard gear"
	access = access_security
	group = "Security"

/datum/supply_packs/medicalextragear
	name = "Medical surplus equipment"
	contains = list(
			/obj/item/weapon/storage/belt/medical = 3,
			/obj/item/clothing/glasses/hud/health = 3,
			/obj/item/device/radio/headset/headset_med/alt = 3,
			/obj/item/clothing/suit/storage/hooded/wintercoat/medical = 3
			)
	cost = 15
	containertype = "/obj/structure/closet/crate/secure"
	containername = "Medical surplus equipment"
	access = access_medical
	group = "Medical"

/datum/supply_packs/cmogear
	name = "Chief medical officer equipment"
	contains = list(
			/obj/item/weapon/storage/belt/medical,
			/obj/item/device/radio/headset/heads/cmo,
			/obj/item/clothing/under/rank/chief_medical_officer,
			/obj/item/weapon/reagent_containers/hypospray,
			/obj/item/clothing/accessory/stethoscope,
			/obj/item/clothing/glasses/hud/health,
			/obj/item/clothing/suit/storage/toggle/labcoat/cmo,
			/obj/item/clothing/suit/storage/toggle/labcoat/cmoalt,
			/obj/item/clothing/mask/surgical,
			/obj/item/clothing/shoes/white,
			/obj/item/weapon/cartridge/cmo,
			/obj/item/clothing/gloves/latex,
			/obj/item/device/healthanalyzer,
			/obj/item/device/flashlight/pen,
			/obj/item/weapon/reagent_containers/syringe
			)
	cost = 60
	containertype = "/obj/structure/closet/crate/secure"
	containername = "Chief medical officer equipment"
	access = access_cmo
	group = "Medical"

/datum/supply_packs/doctorgear
	name = "Medical Doctor equipment"
	contains = list(
			/obj/item/weapon/storage/belt/medical,
			/obj/item/device/radio/headset/headset_med,
			/obj/item/clothing/under/rank/medical,
			/obj/item/clothing/accessory/stethoscope,
			/obj/item/clothing/glasses/hud/health,
			/obj/item/clothing/suit/storage/toggle/labcoat,
			/obj/item/clothing/mask/surgical,
			/obj/item/weapon/storage/firstaid/adv,
			/obj/item/clothing/shoes/white,
			/obj/item/weapon/cartridge/medical,
			/obj/item/clothing/gloves/latex,
			/obj/item/device/healthanalyzer,
			/obj/item/device/flashlight/pen,
			/obj/item/weapon/reagent_containers/syringe
			)
	cost = 20
	containertype = "/obj/structure/closet/crate/secure"
	containername = "Medical Doctor equipment"
	access = access_medical_equip
	group = "Medical"

/datum/supply_packs/chemistgear
	name = "Chemist equipment"
	contains = list(
			/obj/item/weapon/storage/box/beakers,
			/obj/item/device/radio/headset/headset_med,
			/obj/item/weapon/storage/box/autoinjectors,
			/obj/item/clothing/under/rank/chemist,
			/obj/item/clothing/glasses/science,
			/obj/item/clothing/suit/storage/toggle/labcoat/chemist,
			/obj/item/clothing/mask/surgical,
			/obj/item/clothing/shoes/white,
			/obj/item/weapon/cartridge/chemistry,
			/obj/item/clothing/gloves/latex,
			/obj/item/weapon/reagent_containers/dropper,
			/obj/item/device/healthanalyzer,
			/obj/item/weapon/storage/box/pillbottles,
			/obj/item/weapon/reagent_containers/syringe
			)
	cost = 15
	containertype = "/obj/structure/closet/crate/secure"
	containername = "Chemist equipment"
	access = access_chemistry
	group = "Medical"

/datum/supply_packs/paramedicgear
	name = "Paramedic equipment"
	contains = list(
			/obj/item/weapon/storage/belt/medical/emt,
			/obj/item/device/radio/headset/headset_med,
			/obj/item/clothing/under/rank/medical/black,
			/obj/item/clothing/accessory/armband/medgreen,
			/obj/item/clothing/glasses/hud/health,
			/obj/item/clothing/suit/storage/toggle/labcoat/emt,
			/obj/item/clothing/under/rank/medical/paramedic,
			/obj/item/clothing/suit/storage/toggle/fr_jacket,
			/obj/item/clothing/mask/gas,
			/obj/item/clothing/under/rank/medical/paramedic,
			/obj/item/clothing/accessory/stethoscope,
			/obj/item/weapon/storage/firstaid/adv,
			/obj/item/clothing/shoes/jackboots,
			/obj/item/clothing/gloves/latex,
			/obj/item/device/healthanalyzer,
			/obj/item/weapon/cartridge/medical,
			/obj/item/device/flashlight/pen,
			/obj/item/weapon/reagent_containers/syringe,
			/obj/item/clothing/accessory/storage/white_vest
			)
	cost = 20
	containertype = "/obj/structure/closet/crate/secure"
	containername = "Paramedic equipment"
	access = access_medical_equip
	group = "Medical"

/datum/supply_packs/psychiatristgear
	name = "Psychiatrist equipment"
	contains = list(
			/obj/item/clothing/under/rank/psych,
			/obj/item/device/radio/headset/headset_med,
			/obj/item/clothing/under/rank/psych/turtleneck,
			/obj/item/clothing/shoes/laceup,
			/obj/item/clothing/suit/storage/toggle/labcoat,
			/obj/item/clothing/shoes/white,
			/obj/item/weapon/clipboard,
			/obj/item/weapon/folder/white,
			/obj/item/weapon/pen,
			/obj/item/weapon/cartridge/medical
			)
	cost = 15
	containertype = "/obj/structure/closet/crate/secure"
	containername = "Psychiatrist equipment"
	access = access_psychiatrist
	group = "Medical"

/datum/supply_packs/medicalscrubs
	name = "Medical scrubs"
	contains = list(
			/obj/item/clothing/shoes/white = 3,,
			/obj/item/clothing/under/rank/medical/blue = 3,
			/obj/item/clothing/under/rank/medical/green = 3,
			/obj/item/clothing/under/rank/medical/purple = 3,
			/obj/item/clothing/under/rank/medical/black = 3,
			/obj/item/clothing/head/surgery = 3,
			/obj/item/clothing/head/surgery/purple = 3,
			/obj/item/clothing/head/surgery/blue = 3,
			/obj/item/clothing/head/surgery/green = 3,
			/obj/item/clothing/head/surgery/black = 3,
			/obj/item/weapon/storage/box/masks,
			/obj/item/weapon/storage/box/gloves
			)
	cost = 15
	containertype = "/obj/structure/closet/crate/secure"
	containername = "Medical scrubs crate"
	access = access_medical_equip
	group = "Medical"

/datum/supply_packs/autopsy
	name = "Autopsy equipment"
	contains = list(
			/obj/item/weapon/folder/white,
			/obj/item/device/camera,
			/obj/item/device/camera_film = 2,
			/obj/item/weapon/autopsy_scanner,
			/obj/item/weapon/scalpel,
			/obj/item/weapon/storage/box/masks,
			/obj/item/weapon/storage/box/gloves,
			/obj/item/weapon/pen
			)
	cost = 20
	containertype = "/obj/structure/closet/crate/secure"
	containername = "Autopsy equipment crate"
	access = access_morgue
	group = "Medical"

/datum/supply_packs/medicaluniforms
	name = "Medical uniforms"
	contains = list(
			/obj/item/clothing/shoes/white = 3,
			/obj/item/clothing/under/rank/chief_medical_officer,
			/obj/item/clothing/under/rank/geneticist,
			/obj/item/clothing/under/rank/virologist,
			/obj/item/clothing/under/rank/nursesuit,
			/obj/item/clothing/under/rank/nurse,
			/obj/item/clothing/under/rank/orderly,
			/obj/item/clothing/under/rank/medical = 3,
			/obj/item/clothing/under/rank/medical/paramedic = 3,
			/obj/item/clothing/suit/storage/toggle/labcoat = 3,
			/obj/item/clothing/suit/storage/toggle/labcoat/cmo,
			/obj/item/clothing/suit/storage/toggle/labcoat/emt,
			/obj/item/clothing/suit/storage/toggle/labcoat/cmoalt,
			/obj/item/clothing/suit/storage/toggle/labcoat/genetics,
			/obj/item/clothing/suit/storage/toggle/labcoat/virologist,
			/obj/item/clothing/suit/storage/toggle/labcoat/chemist,
			/obj/item/weapon/storage/box/masks,
			/obj/item/weapon/storage/box/gloves
			)
	cost = 15
	containertype = "/obj/structure/closet/crate/secure"
	containername = "Medical uniform crate"
	access = access_medical_equip
	group = "Medical"

/datum/supply_packs/medicalbiosuits
	name = "Medical biohazard gear"
	contains = list(
			/obj/item/clothing/head/bio_hood = 3,
			/obj/item/clothing/suit/bio_suit = 3,
			/obj/item/clothing/head/bio_hood/virology = 2,
			/obj/item/clothing/suit/bio_suit/cmo,
			/obj/item/clothing/head/bio_hood/cmo,
			/obj/item/clothing/mask/gas = 5,
			/obj/item/weapon/tank/oxygen = 5,
			/obj/item/weapon/storage/box/masks,
			/obj/item/weapon/storage/box/gloves
			)
	cost = 50
	containertype = "/obj/structure/closet/crate/secure"
	containername = "Medical biohazard equipment"
	access = access_medical_equip
	group = "Medical"

/datum/supply_packs/portablefreezers
	name = "Portable freezers crate"
	contains = list(/obj/item/weapon/storage/box/freezer = 7)
	cost = 25
	containertype = "/obj/structure/closet/crate/secure"
	containername = "Portable freezers"
	access = access_medical_equip
	group = "Medical"

/datum/supply_packs/minergear
	name = "Shaft miner equipment"
	contains = list(
			/obj/item/weapon/storage/backpack/industrial,
			/obj/item/weapon/storage/backpack/satchel/eng,
			/obj/item/clothing/suit/storage/hooded/wintercoat/miner,
			/obj/item/device/radio/headset/headset_cargo,
			/obj/item/clothing/under/rank/miner,
			/obj/item/clothing/gloves/black,
			/obj/item/clothing/shoes/black,
			/obj/item/device/analyzer,
			/obj/item/weapon/storage/bag/ore,
			/obj/item/device/flashlight/lantern,
			/obj/item/weapon/shovel,
			/obj/item/weapon/pickaxe,
			/obj/item/weapon/mining_scanner,
			/obj/item/clothing/glasses/material,
			/obj/item/clothing/glasses/meson
			)
	cost = 15
	containertype = "/obj/structure/closet/crate/secure"
	containername = "Shaft miner equipment"
	access = access_mining
	group = "Supply"

/datum/supply_packs/chaplaingear
	name = "Chaplain equipment"
	contains = list(
			/obj/item/clothing/under/rank/chaplain,
			/obj/item/clothing/shoes/black,
			/obj/item/clothing/suit/nun,
			/obj/item/clothing/head/nun_hood,
			/obj/item/clothing/suit/chaplain_hoodie,
			/obj/item/clothing/head/chaplain_hood,
			/obj/item/clothing/suit/holidaypriest,
			/obj/item/clothing/under/wedding/bride_white,
			/obj/item/weapon/storage/backpack/cultpack,
			/obj/item/weapon/storage/fancy/candle_box = 3
			)
	cost = 10
	containertype = "/obj/structure/closet/crate"
	containername = "Chaplain equipment crate"
	group = "Miscellaneous"