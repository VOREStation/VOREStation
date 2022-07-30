// Note for newly added fluff items: Ckeys should not contain any spaces, underscores or capitalizations,
// or else the item will not be usable.
// Example: Someone whose username is "Master Pred_Man" should be written as "masterpredman" instead
// Note: Do not use characters such as # in the display_name. It will cause the item to be unable to be selected.

/datum/gear/fluff
	path = /obj/item
	sort_category = "Fluff Items"
	display_name = "If this item can be chosen or seen, ping a coder immediately!"
	ckeywhitelist = list("This entry should never be choosable with this variable set.") //If it does, then that means somebody fucked up the whitelist system pretty hard
	character_name = list("This entry should never be choosable with this variable set.")
	cost = 0
/*
/datum/gear/fluff/testhorn
	path = /obj/item/weapon/bikehorn
	display_name = "Airhorn - Example Item"
	description = "An example item that you probably shouldn't see!"
	ckeywhitelist = list("mewchild")
	allowed_roles = list("Engineer")
*/


/datum/gear/fluff/collar //Use this as a base path for collars if you'd like to set tags in loadout. Make sure you don't use apostrophes in the display name or this breaks!
	slot = slot_tie

/datum/gear/fluff/collar/New()
	..()
	gear_tweaks += gear_tweak_collar_tag

//  0-9 CKEYS
/datum/gear/fluff/malady_crop
	path = /obj/item/weapon/material/twohanded/riding_crop/malady
	display_name = "Malady's Crop"
	ckeywhitelist = list("1r1s")
	character_name = list("Malady Blanche")

//  A CKEYS
/datum/gear/fluff/lethe_helmet
	path = /obj/item/clothing/head/helmet/hos/fluff/lethe
	display_name = "Lethe's Helmet"
	slot = slot_head
	ckeywhitelist = list("adk09")
	character_name = list("Lethe")

/datum/gear/fluff/xander_bracer
	path = /obj/item/clothing/accessory/bracer/fluff/xander_sthasha
	display_name = "Xander's Bracer"
	ckeywhitelist = list("aegisoa")
	character_name = list("Xander Bevin")

/datum/gear/fluff/xander_medal
	path = /obj/item/clothing/accessory/medal/conduct
	display_name = "Xander's Conduct Medal"
	ckeywhitelist = list("aegisoa")
	character_name = list("Xander Bevin")

/datum/gear/fluff/xander_medal_2
	path = /obj/item/clothing/accessory/medal/silver/unity
	display_name = "Xander's Unity Medal"
	ckeywhitelist = list("aegisoa")
	character_name = list("Xander Bevin")

/datum/gear/fluff/charlotte_medal
    path = /obj/item/clothing/accessory/medal/silver/security
    display_name = "Charlotte's Robust Security Medal"
    ckeywhitelist = list("alfalah")
    character_name = list("Charlotte Graves")

/datum/gear/fluff/charlotte_medal_2
    path = /obj/item/clothing/accessory/medal/conduct
    display_name = "Charlotte's Medal of Conduct"
    ckeywhitelist = list("alfalah")
    character_name = list("Charlotte Graves")

/datum/gear/fluff/charlotte_cigarettes
	path = /obj/item/weapon/storage/fancy/fluff/charlotte
	display_name = "Charlotte's cigarette case"
	ckeywhitelist = list("alfalah")
	character_name = list("Charlotte Graves")

/datum/gear/fluff/fifi_hat
	path = /obj/item/clothing/head/fluff/fifi_hat
	display_name = "Fifi's hat"
	ckeywhitelist = list("allweek")
	character_name = list("Fifi The Magnificent")

/datum/gear/fluff/fifi_jumpsuit
	path = /obj/item/clothing/under/fluff/fifi_jumpsuit
	display_name = "Fifi's jumpsuit"
	ckeywhitelist = list("allweek")
	character_name = list("Fifi The Magnificent")

/datum/gear/fluff/fifi_socks
	path = /obj/item/clothing/shoes/fluff/fifi_socks
	display_name = "Fifi's socks"
	ckeywhitelist = list("allweek")
	character_name = list("Fifi The Magnificent")

/datum/gear/fluff/lynn_penlight
	path = /obj/item/flashlight/pen/fluff/lynn
	display_name = "Lynn's Penlight"
	ckeywhitelist = list("argobargsoup")
	character_name = list("Lynn Shady")

/datum/gear/fluff/felina_witchhat
	path = /obj/item/clothing/head/wizard/marisa/fake
	display_name = "Felina's Witch Hat"
	ckeywhitelist = list("argobargsoup")
	character_name = list("Felina Belliger")

/datum/gear/fluff/aronai_ccmeduniform
	path = /obj/item/clothing/under/solgov/utility/sifguard/officer/medical
	display_name  = "centcom medical uniform"
	description = "A medical uniform straight from Central Command."
	slot = slot_w_uniform
	ckeywhitelist = list("arokha")
	character_name = list("Aronai Sieyes")

/datum/gear/fluff/aronai_ccmedjacket
	path = /obj/item/clothing/suit/storage/solgov/service/sifguard/medical/command
	display_name  = "centcom medical jacket"
	description = "A medical jacket straight from Central Command."
	slot = slot_wear_suit
	ckeywhitelist = list("arokha")
	character_name = list("Aronai Sieyes")

/datum/gear/fluff/astra_ritualknife
	path = /obj/item/weapon/material/knife/ritual/fluff/astra
	display_name = "Polished Ritual Knife"
	description = "A well kept strange ritual knife, There is a small tag with the name 'Astra Ether' on it. They are probably looking for this."
	ckeywhitelist = list("astraether")
	character_name = list("Astra Ether")

/datum/gear/fluff/astra_medal
	path = /obj/item/clothing/accessory/medal/conduct
	display_name = "Astra's Conduct Medal"
	ckeywhitelist = list("astraether")
	character_name = list("Astra Ether")

/datum/gear/fluff/astra_medal_2
	path = /obj/item/clothing/accessory/medal/silver/unity
	display_name = "Astra's Unity Medal"
	ckeywhitelist = list("astraether")
	character_name = list("Astra Ether")

/datum/gear/fluff/collar/azura
	path = /obj/item/clothing/accessory/collar/azura
	display_name = "collar, Azura"
	description = "For the kobold's pet."
	ckeywhitelist = list("azurachitin")
	character_name = list("Azura Chitin")

/datum/gear/fluff/aurora
	path = /obj/item/clothing/accessory/solgov/department/security/aurora
	display_name = "Aurora's keepsake"
	description = "An old solcom sec insignia given to Aurora"
	ckeywhitelist = list("storesund97")
	character_name = list("Aurora")

/datum/gear/fluff/ashling
	path = /obj/item/clothing/accessory/storage/ritualharness/fluff/antoinette
	display_name = "Ritual Harness"
	description = "Antoinette's ritual supplies."
	ckeywhitelist = list("ashling")
	character_name = list("Antoinette DeKaultieste")

//  B CKEYS
/datum/gear/fluff/yuuko_kimono
	path = /obj/item/clothing/under/fluff/sakura_hokkaido_kimono
	display_name = "Yuuko's Kimono"
	slot = slot_w_uniform
	ckeywhitelist = list("benemuel")
	character_name = list("Yuuko Shimmerpond")

/datum/gear/fluff/cassandra_box
	path = /obj/item/weapon/storage/box/fluff/cassandra
	display_name = "Cassandra's Box"
	ckeywhitelist = list("beyondmylife")
	character_name = list("Cassandra Selone")

/datum/gear/fluff/kilano_dress
	path = /obj/item/clothing/under/dress/fluff/kilano
	display_name = "Kilano's Dress"
	slot = slot_w_uniform
	ckeywhitelist = list("beyondmylife")
	character_name = list("Kilano Soryu")

/datum/gear/fluff/kilano_gloves
	path = /obj/item/clothing/gloves/fluff/kilano
	display_name = "Kilano's Gloves"
	slot = slot_gloves
	ckeywhitelist = list("beyondmylife")
	character_name = list("Kilano Soryu")

/datum/gear/fluff/netra_box
	path = /obj/item/weapon/storage/box/fluff/kilano
	display_name = "Ne'tra's Box"
	ckeywhitelist = list("beyondmylife")
	character_name = list("Ne'tra Ky'ram")

/datum/gear/fluff/nolan_medal
	path = /obj/item/clothing/accessory/medal/silver/unity
	display_name = "Nolan's Unity Medal"
	ckeywhitelist = list("blakeryan")
	character_name = list("Nolan Conaway")

/datum/gear/fluff/amber_medal
	path = /obj/item/clothing/accessory/medal/conduct
	display_name = "Amber's Conduct Medal"
	ckeywhitelist = list("bluewolf128")
	character_name = list("Amber Wresspenn")

/datum/gear/fluff/charles_hat
	path = /obj/item/clothing/head/that/fluff/gettler
	display_name = "Charles' Top-Hat"
	ckeywhitelist = list("bobofboblandia")
	character_name = list("Charles Gettler")

/datum/gear/fluff/nettie_tablet
	path = /obj/item/modular_computer/tablet/preset/custom_loadout/nettie
	display_name = "Remodeled Tablet"
	ckeywhitelist = list("bricker98")
	character_name = list("Nettie Stough")

/datum/gear/fluff/xin_sovietuniform
	path = /obj/item/clothing/under/soviet
	display_name = "Xin's Soviet Uniform"
	description = "This soviet uniform has seen considerable use over the years, it's rather worn in some places, frayed in others and the stomach region has signs of being stretched out repeatedly."
	slot = slot_w_uniform
	ckeywhitelist = list("britishrabbit")
	character_name = list("Xin Xiao")

/datum/gear/fluff/tasald_box
	path = /obj/item/weapon/storage/box/fluff/tasald
	display_name = "Tasald's Box"
	ckeywhitelist = list("bwoincognito")
	character_name = list("Tasald Corlethian")

/datum/gear/fluff/octavius_box
	path = /obj/item/weapon/storage/box/fluff/octavious
	display_name = "Octavious' Box"
	ckeywhitelist = list("bwoincognito")
	character_name = list("Octavious Ward")

/datum/gear/fluff/jayda_meduniform
	path = /obj/item/clothing/under/solgov/utility/sifguard/medical/fluff
	display_name = "Jayda's Uniform"
	slot = slot_w_uniform
	ckeywhitelist = list("burritojustice")
	character_name = list("Jayda Wilson")

/datum/gear/fluff/star_hoodie
	path = /obj/item/clothing/suit/storage/star
	display_name = "Star hoodie"
	slot = slot_wear_suit
	ckeywhitelist = list("bacon12366")
	character_name = list("Elly Brown")

/datum/gear/fluff/alibig_medal
	path = /obj/item/clothing/accessory/medal/conduct
	display_name = "Ali Big's Conduct Medal"
	ckeywhitelist = list("bigbababooey")
	character_name = list("Ali Big")

//  C CKEYS
/datum/gear/fluff/cappy_watch
	path = /obj/item/clothing/accessory/watch
	display_name = "Cappy's Pocket Watch"
	ckeywhitelist = list("cappycat")
	character_name = list("Cappy Fuzzlyfeathers")

/datum/gear/fluff/james_disk
	path = /obj/item/weapon/disk/data
	display_name = "James' Disk"
	ckeywhitelist = list("cockatricexl")
	character_name = list("James Holder")

/datum/gear/fluff/diana_robe
	path = /obj/item/clothing/suit/fluff/purp_robes
	display_name = "Diana's Robes"
	slot = slot_wear_suit
	ckeywhitelist = list("cameron653")
	character_name = list("Diana Kuznetsova")

/datum/gear/fluff/diana_tiara
	path = /obj/item/clothing/head/fluff/pink_tiara
	display_name = "Diana's Tiara"
	slot = slot_head
	ckeywhitelist = list("cameron653")
	character_name = list("Diana Kuznetsova")

/datum/gear/fluff/aika_coat
	path = /obj/item/clothing/suit/fluff/blue_trimmed_coat
	display_name = "Aika's Coat"
	slot = slot_wear_suit
	ckeywhitelist = list("chaoko99")
	character_name = list("Aika Hisakawa")

/datum/gear/fluff/sariU_disk
	path = /obj/item/weapon/disk/limb/eggnerdltd
	display_name = "Sari-U's Eggnerd Disk"
	ckeywhitelist = list("crossexonar")
	character_name = list("Sari-U")

/datum/gear/fluff/sariE_disk
	path = /obj/item/weapon/disk/limb/eggnerdltd
	display_name = "Sari-E's Eggnerd Disk"
	ckeywhitelist = list("crossexonar")
	character_name = list("Sari-E")

/datum/gear/fluff/alexandria_medal
	path = /obj/item/clothing/accessory/medal/silver/unity
	display_name = "Alexandria's Unity Medal"
	ckeywhitelist = list("cgr")
	character_name = list("Alexandria Kozetto")

/datum/gear/fluff/hisako_medal
	path = /obj/item/clothing/accessory/medal/silver/unity
	display_name = "Hisako's Unity Medal"
	ckeywhitelist = list("chaleur")
	character_name = list("Hisako Arato")

/datum/gear/fluff/jade_stamp
	path = /obj/item/weapon/stamp/fluff/jade_horror
	display_name = "Official Council of Mid Horror rubber stamp"
	ckeywhitelist = list("coolcrow420")
	character_name = list("Jade Davis")

//  D CKEYS
/datum/gear/fluff/dhaeleena_medal
	path = /obj/item/clothing/accessory/medal/silver/security/fluff/dhael
	display_name = "Dhaeleena's Medal"
	ckeywhitelist = list("dhaeleena")
	character_name = list("Dhaeleena M'iar")

/datum/gear/fluff/elliot_belt
	path = /obj/item/weapon/storage/belt/champion
	display_name = "Elliot's Belt"
	ckeywhitelist = list("dickfreedomjohnson")
	character_name = list("Elliot Richards")

/datum/gear/fluff/donald_medal
	path = /obj/item/clothing/accessory/medal/conduct
	display_name = "Donald's Conduct Medal"
	ckeywhitelist = list("drainquake")
	character_name = list("Donald Weinbeck")

/datum/gear/fluff/donald_medal_2
	path = /obj/item/clothing/accessory/medal/bronze_heart
	display_name = "Donald's Heart Medal"
	ckeywhitelist = list("drainquake")
	character_name = list("Donald Weinbeck")

/datum/gear/fluff/drake_box
	path = /obj/item/weapon/storage/box/fluff/drake
	display_name = "Drake's Box"
	ckeywhitelist = list("drakefrostpaw")
	character_name = list("Drake Frostpaw")

/datum/gear/fluff/theseus_coin
	path = /obj/item/weapon/coin/diamond
	display_name  = "Theseus' Diamond coin"
	ckeywhitelist = list("draycu")
	character_name = list("Theseus")
	description = "An engraved coin made of diamond. On the side for heads is printed the year 2541, along with the letter T. On the side for tails, the letter Y can be seen."

/datum/gear/fluff/yonra_box
	path = /obj/item/weapon/storage/box/fluff/yonra
	display_name = "Yonra's Box"
	ckeywhitelist = list("draycu")
	character_name = list("Schae Yonra")

//  E CKEYS
/datum/gear/fluff/serkii_slippers
	path = /obj/item/clothing/shoes/slippers
	display_name = "Serkii's Slippers"
	slot = slot_shoes
	ckeywhitelist = list("eekasqueak")
	character_name = list("Serkii Miishy")

/datum/gear/fluff/serkii_skirt
	path = /obj/item/clothing/under/skirt/fluff/serkii
	display_name = "Serkii's Skirt"
	slot = slot_w_uniform
	ckeywhitelist = list("eekasqueak")
	character_name = list("Serkii Miishy")

/datum/gear/fluff/jessie_coat
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/jessie
	display_name = "Jessie's Coat"
	slot = slot_wear_suit
	ckeywhitelist = list("epiccharger")
	character_name = list("Jessie Mare")

/datum/gear/fluff/verd_medal
	path = /obj/item/clothing/accessory/medal/bronze_heart
	display_name = "Verd's Medal"
	ckeywhitelist = list("epigraphzero")
	character_name = list("Verd Woodrow")

/datum/gear/fluff/erik_medal
	path = /obj/item/clothing/accessory/medal/silver/unity
	display_name = "Erik's Unity Medal"
	ckeywhitelist = list("erikthedog")
	character_name = list("Erik Ramadwood")

/datum/gear/fluff/salvage_id
	path = /obj/item/weapon/card/id/event/polymorphic/itg
	display_name = "Salvage's ITG-ID card"
	ckeywhitelist = list("essbie")
	character_name = list("Savage")

//  F CKEYS
/datum/gear/fluff/yikatihaki_armor
	path = /obj/item/clothing/suit/armor/vox_scrap
	display_name = "Yikatihaki's Armor"
	slot = slot_wear_suit
	ckeywhitelist = list("flaktual")
	character_name = list("Yikatihaki")
	allowed_roles = list("Explorer")

/datum/gear/fluff/suit/storage/flintlock
	path = /obj/item/clothing/suit/storage/flintlock
	display_name = "Flintlock's jacket"
	slot = slot_wear_suit
	ckeywhitelist = list("flintlockdafox")
	character_name = list("Flintlock Sharpsman")


//  G CKEYS

//  H CKEYS

/datum/gear/fluff/lauren_medal
	path = /obj/item/clothing/accessory/medal/conduct
	display_name = "Lauren's Medal"
	ckeywhitelist = list("heroman3003")
	character_name = list("Lauren Zackson")

/datum/gear/fluff/lauren_string
	path = /obj/item/clothing/accessory/collar/fluff/goldenstring
	display_name = "Lauren's String"
	ckeywhitelist = list("heroman3003")
	character_name = list("Lauren Zackson")

/datum/gear/fluff/belle_sizegun
	path = /obj/item/weapon/gun/energy/sizegun
	display_name = "Belle's Sizegun"
	ckeywhitelist = list("hottokeeki")
	character_name = list("Belle Day")

/datum/gear/fluff/amaryll_claws
	path = /obj/item/weapon/surgical/scalpel/amaryll_claws
	display_name = "Amaryll's Claws"
	ckeywhitelist = list("hunterbirk")
	character_name = list("Amaryll")

//  I CKEYS
/datum/gear/fluff/ruda_badge
	path = /obj/item/clothing/accessory/badge/holo/detective/ruda
	display_name = "Ruda's Detective Badge"
	ckeywhitelist = list("interrolouis")
	character_name = list("Ruda Lizden")

/datum/gear/fluff/kai_modkit
	path = /obj/item/borg/upgrade/modkit/chassis_mod/kai
	display_name = "Kai's Modkit"
	ckeywhitelist = list("interrolouis")
	character_name = list("Kai Highlands")

/datum/gear/fluff/ivy_backpack
	path = /obj/item/weapon/storage/backpack/messenger/sec/fluff/ivymoomoo
	display_name = "Ivy's Backpack"
	slot = slot_back
	ckeywhitelist = list("ivymoomoo")
	character_name = list("Ivy Baladeva")

/datum/gear/fluff/farren_medal
	path = /obj/item/clothing/accessory/medal/silver/unity
	display_name = "Farren's Unity Medal"
	ckeywhitelist = list("itsaket")
	character_name = list("Farren Fruit")

/datum/gear/fluff/myse_monk
	path = /obj/item/clothing/suit/imperium_monk
	display_name = "Imperium monk"
	ckeywhitelist = list("itsaket")
	character_name = list("Myse Topazian IV")

//  J CKEYS
/datum/gear/fluff/mor_box
	path = /obj/item/weapon/storage/box/fluff/morxaina
	display_name = "Mor's Box"
	ckeywhitelist = list("jacknoir413")
	character_name = list("Mor Xaina")

/datum/gear/fluff/areax_staff
	path = /obj/item/weapon/storage/backpack/fluff/stunstaff
	display_name = "Areax's Stun Staff"
	slot = slot_back
	ckeywhitelist = list("jacknoir413")
	character_name = list("Areax Third")
	allowed_roles = list("Security Officer, Warden, Head of Security")

/datum/gear/fluff/earthen_uniform
	path = /obj/item/clothing/under/fluff/earthenbreath
	display_name = "Earthen's Uniform"
	slot = slot_w_uniform
	ckeywhitelist = list("jacobdragon")
	character_name = list("Earthen Breath")

/datum/gear/fluff/earthen_hairpin
	path = /obj/item/clothing/head/fluff/hairflowerpin
	display_name = "Earthen's Flower Pin"
	slot = slot_head
	ckeywhitelist = list("jacobdragon")
	character_name = list("Earthen Breath")

/datum/gear/fluff/cirra_box
	path = /obj/item/weapon/storage/box/fluff/cirra
	display_name = "Cirra's Box"
	ckeywhitelist = list("jemli")
	character_name = list("Cirra Mayhem")

/datum/gear/fluff/jemli_fedora
	path = /obj/item/clothing/head/fedora/fluff/jemli
	display_name = "Jemli's Fedora"
	slot = slot_head
	ckeywhitelist = list("jemli")
	character_name = list("Jemli")

/datum/gear/fluff/jeremiah_holster
	path = /obj/item/clothing/accessory/holster/armpit
	display_name = "Ace's Holster"
	ckeywhitelist = list("jertheace")
	character_name = list("Jeremiah Acacius")
	allowed_roles = list("Site Manager", "Warden", "Head of Security")

/datum/gear/fluff/jeremiah_boots
	path = /obj/item/clothing/shoes/boots/combat
	display_name = "Ace's Boots"
	slot = slot_shoes
	ckeywhitelist = list("jertheace")
	character_name = list("Jeremiah Acacius")

/datum/gear/fluff/jeremiah_combatuniform
	path = /obj/item/clothing/under/syndicate/combat
	display_name = "Ace's Combat Uniform"
	slot = slot_w_uniform
	ckeywhitelist = list("jertheace")
	character_name = list("Jeremiah Acacius")

/datum/gear/fluff/joan_backpack
	path = /obj/item/weapon/storage/backpack/dufflebag/sec/fluff/joanrisu
	display_name = "Joan's backpack"
	ckeywhitelist = list("joanrisu")
	character_name = list("Joan Risu")


/datum/gear/fluff/katarina_backpack
	path = /obj/item/weapon/storage/backpack/dufflebag/sec/fluff/katarina
	display_name = "Katarina's Backpack"
	ckeywhitelist = list("joanrisu")
	character_name = list("Katarina Eine")
	allowed_roles = list("Site Manager", "Warden", "Head of Security")

/datum/gear/fluff/emoticon_box
	path = /obj/item/weapon/storage/box/fluff/emoticon
	display_name = "Emoticon's Box"
	ckeywhitelist = list("joey4298")
	character_name = list("Emoticon")

/datum/gear/fluff/emoticon_mimeuniform
	path = /obj/item/clothing/under/sexymime
	display_name = "Emoticon's Mime Uniform"
	slot = slot_w_uniform
	ckeywhitelist = list("joey4298")
	character_name = list("Emoticon")

/datum/gear/fluff/emoticon_mimemask
	path = /obj/item/clothing/mask/gas/sexymime
	display_name = "Emoticon's Mime Mask"
	slot = slot_wear_mask
	ckeywhitelist = list("joey4298")
	character_name = list("Emoticon")

/datum/gear/fluff/harmony_medal
	path = /obj/item/clothing/accessory/medal/gold/heroism
	display_name = "Harmony's Heroism Medal"
	ckeywhitelist = list("john.wayne9392")
	character_name = list("Harmony Pretchl")

/datum/gear/fluff/harmony_modkit
	path = /obj/item/modkit_conversion/fluff/harmonysuit
	display_name = "Harmony's Modkit"
	ckeywhitelist = list("john.wayne9392")
	character_name = list("Harmony Pretchl")

/datum/gear/fluff/harmony_spacemodkit
	path = /obj/item/modkit_conversion/fluff/harmonyspace
	display_name = "Harmony's Modkit 2"
	ckeywhitelist = list("john.wayne9392")
	character_name = list("Harmony Pretchl")

/datum/gear/fluff/koyo_box
	path = /obj/item/weapon/storage/box/fluff/koyoakimomi
	display_name = "Koyo's Box"
	ckeywhitelist = list("jwguy")
	character_name = list("Koyo Akimomi")

//  K CKEYS
/datum/gear/fluff/smu_medal
	path = /obj/item/clothing/accessory/medal/nobel_science
	display_name = "SMU's Nobel Science Award"
	ckeywhitelist = list("keekenox")
	character_name = list("SMU-453")

/datum/gear/fluff/ketrai_hat
	path = /obj/item/clothing/head/fluff/ketrai
	display_name = "Ketrai's Hat"
	slot = slot_head
	ckeywhitelist = list("ketrai")
	character_name = list("Ketrai")

/datum/gear/fluff/amaya_id
	path = /obj/item/weapon/card/id/event/fluff/amaya
	display_name = "Amaya's ID"
	ckeywhitelist = list("kiraalitruss")
	character_name = list("Amaya Rahl")

/datum/gear/fluff/kisuke_glasses
	path = /obj/item/clothing/glasses/omnihud/kamina
	display_name = "Kisuke's Kamina Glasses"
	slot = slot_glasses
	ckeywhitelist = list("kisukegema")
	character_name = list("Kisuke Gema")

/datum/gear/fluff/collar/excess
	path = /obj/item/clothing/accessory/collar/pink/fluff/warning
	display_name = "collar, Excess"
	ckeywhitelist = list("killerdragn")
	character_name = list("Excess")

/datum/gear/fluff/excess_uniform
	path = /obj/item/clothing/under/fluff/excess
	display_name = "Excess's Uniform"
	slot = slot_w_uniform
	ckeywhitelist = list("killerdragn")
	character_name = list("Excess")

/datum/gear/fluff/lassara_sheath
	path = /obj/item/clothing/accessory/storage/knifeharness
	display_name = "Lassara's Knife Harness"
	ckeywhitelist = list("killjaden")
	character_name = list("Lassara Faaira'Nrezi")

/datum/gear/fluff/rana_medal
	path = /obj/item/clothing/accessory/medal/silver/unity
	display_name = "Rana's Unity Medal"
	ckeywhitelist = list("kitchifox")
	character_name = list("Rana Starsong-Uma")

/datum/gear/fluff/taiga_uniform
	path = /obj/item/clothing/under/fluff/taiga
	display_name = "Taifa's Uniform"
	slot = slot_w_uniform
	ckeywhitelist = list("kiwidaninja")
	character_name = list("Chakat Taiga")

/datum/gear/fluff/ashley_medal
	path = /obj/item/clothing/accessory/medal/nobel_science/fluff/ashley
	display_name = "Ashley's Medal"
	ckeywhitelist = list("knightfall5")
	character_name = list("Ashley Kifer")

//  L CKEYS
/datum/gear/fluff/kenzie_medal
	path = /obj/item/clothing/accessory/medal/conduct
	display_name = "Kenzie's Conduct Medal"
	ckeywhitelist = list("lm40")
	character_name = list("Kenzie Houser")

/datum/gear/fluff/kenzie_hypospray
	path = /obj/item/weapon/reagent_containers/hypospray/vial/kenzie
	display_name = "Kenzie's Hypospray"
	ckeywhitelist = list("lm40")
	character_name = list("Kenzie Houser")
	allowed_roles = list("Chief Medical Officer","Medical Doctor","Chemist","Psychiatrist","Paramedic", "Field Medic")

/datum/gear/fluff/brianna_backpack
	path = /obj/item/weapon/storage/backpack/messenger/black/fluff/briana
	display_name = "Briana's Backpack"
	slot = slot_back
	ckeywhitelist = list("luminescentring")
	character_name = list("Briana Moore")

//  M CKEYS
/datum/gear/fluff/phi_box
	path = /obj/item/weapon/storage/box/fluff/phi
	display_name = "Phi's Box"
	ckeywhitelist = list("mewchild")
	character_name = list("Phi Vietsi")

/datum/gear/fluff/giliana_labcoat
	path = /obj/item/clothing/suit/storage/toggle/labcoat/fluff/molenar
	display_name = "Giliana's Labcoat"
	slot = slot_wear_suit
	ckeywhitelist = list("molenar")
	character_name = list("Giliana Gamish")

/datum/gear/fluff/myryan_belt
	path = /obj/item/weapon/storage/belt/utility/fluff/vulpine
	display_name = "Myryan's Belt"
	ckeywhitelist = list("myryan")
	character_name = list("Myryan Karnage-Cunningham")

/datum/gear/fluff/resh_uniform
	path = /obj/item/clothing/suit/security/navyhos
	display_name = "Resh's HoS Uniform"
	slot = slot_wear_suit
	ckeywhitelist = list("mrsignmeup")
	character_name = list("Reshskakskakss Seekiseekis")
	allowed_roles = list("Head of Security")

/datum/gear/fluff/daniel_medal
	path = /obj/item/clothing/accessory/medal/conduct
	display_name = "Daniel's Conduct Medal"
	ckeywhitelist = list("mrsignmeup")
	character_name = list("Daniel Fisher")

//  N CKEYS
/datum/gear/fluff/awen_hat
	path = /obj/item/clothing/head/fluff/wolfgirl
	display_name = "Awen's Hat"
	slot = slot_head
	ckeywhitelist = list("natje")
	character_name = list("Awen Henry")

/datum/gear/fluff/awen_shoes
	path = /obj/item/clothing/shoes/fluff/wolfgirl
	display_name = "Awen's Shoes"
	slot = slot_shoes
	ckeywhitelist = list("natje")
	character_name = list("Awen Henry")

/datum/gear/fluff/awen_uniform
	path = /obj/item/clothing/under/fluff/wolfgirl
	display_name = "Awen's Uniform"
	slot = slot_w_uniform
	ckeywhitelist = list("natje")
	character_name = list("Awen Henry")

/datum/gear/fluff/pumila_vines
	path = /obj/item/clothing/under/fluff/aluranevines
	display_name = "Pumila's Vines"
	slot = slot_w_uniform
	ckeywhitelist = list("natje")
	character_name = list("Pumila")

/datum/gear/fluff/annie_sweater
	path = /obj/item/clothing/accessory/sweater/fluff/annie
	display_name = "Annie's Sweater"
	ckeywhitelist = list("nepox")
	character_name = list("Annie Rose")

/datum/gear/fluff/damon_medal
	path = /obj/item/clothing/accessory/medal/silver/unity
	display_name = "Damon's Unity Medal"
	ckeywhitelist = list("nickcrazy")
	character_name = list("Damon Bones Xrim")

/datum/gear/fluff/NDF_Medical_jacket
	path = /obj/item/clothing/under/solgov/utility/sifguard/medical
	display_name = "Ridge's Medical Jacket"
	ckeywhitelist = list("nickcrazy")
	character_name = list("Ridge")

/datum/gear/fluff/damon_jacket
	path = /obj/item/clothing/suit/storage/toggle/bomber/bombersec
	display_name = "Damon's Bomber Jacket"
	ckeywhitelist = list("nickcrazy")
	character_name = list("Damon Bones Xrim")

/datum/gear/fluff/kt_fishing_rod
	path = /obj/item/weapon/material/fishing_rod/modern/strong
	display_name = "K't's fishing rod"
	ckeywhitelist = list("nerdass")
	character_name = list("K't")

//  O CKEYS
/datum/gear/fluff/richard_chain
	path = /obj/item/weapon/melee/fluff/holochain
	display_name = "Richard's Holochain"
	ckeywhitelist = list("orbisa")
	character_name = list("Richard D'angelo")

/datum/gear/fluff/bogen_medal
	path = /obj/item/clothing/accessory/medal/silver/unity
	display_name = "Bogen's Unity Medal"
	ckeywhitelist = list("oscarholmes")
	character_name = list("Bogen Kellogg")

//  P CKEYS
/datum/gear/fluff/evelyn_medal
    path = /obj/item/clothing/accessory/medal/conduct
    display_name = "Evelyn's Medal of Conduct"
    ckeywhitelist = list("pandora029")
    character_name = list("Evelyn Tareen")

/datum/gear/fluff/evelyn_coat
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/security/fluff/evelyn/
	display_name = "warden's navy winter coat"
	ckeywhitelist = list("pandora029")
	character_name = list("Evelyn Tareen", "Velyn Tareen")

/datum/gear/fluff/seona_flightsuit
	path = /obj/item/clothing/under/fluff/foxoflightsuit/
	display_name = "padded flightsuit"
	ckeywhitelist = list("pandora029")
	character_name = list("Seona Young")

/datum/gear/fluff/lily_medal
	path = /obj/item/clothing/accessory/medal/silver/unity
	display_name = "Lily's Unity Medal"
	ckeywhitelist = list("phoaly")
	character_name = list("Lily Maximus")

/datum/gear/fluff/pip_cloak
	path = /obj/item/clothing/accessory/poncho/roles/cloak/hop/fluff/pip
	display_name = "Pip's Cloak"
	ckeywhitelist = list("phoaly")
	character_name = list("Pip Shyner")

/datum/gear/fluff/lucuis_battery
	path = /obj/item/weapon/fluff/dragor_dot
	display_name = "Lucuis' Spare Battery"
	ckeywhitelist = list("pontifexminimus")
	character_name = list("Lucius Null")

/datum/gear/fluff/lucia_battery
	path = /obj/item/weapon/fluff/dragor_dot
	display_name = "Lucia's Spare Battery"
	ckeywhitelist = list("pontifexminimus")
	character_name = list("Lucia Null")

/datum/gear/fluff/jamie_medal
	path = /obj/item/clothing/accessory/medal/silver/unity
	display_name = "Jamie's Unity Medal"
	ckeywhitelist = list("phoenixgamma7")
	character_name = list("Jamie Findlay")

/datum/gear/fluff/scylla_shades
	path = /obj/item/clothing/glasses/fluff/scylla
	display_name = "Scylla's Shades"
	description = "These cherry-red cat-eye shades give you an inclination to eat chalk."
	ckeywhitelist = list("pimientopyro")
	character_name = list("Scylla Casmus")

/datum/gear/fluff/zaku_sweatervest
	path = /obj/item/clothing/suit/varsity/green/sweater_vest
	display_name = "Zaku's Sweater Vest"
	slot = slot_wear_suit
	ckeywhitelist = list("pimientopyro")
	character_name = list("Zaku Fyodorovna")

/datum/gear/fluff/kiyoshi_cloak
	path = /obj/item/clothing/accessory/poncho/roles/cloak/fluff/cloakglowing
	display_name = "glowing cloak"
	ckeywhitelist = list("pastelprincedan")
	character_name = list("Kiyoshi Maki", "Masumi Maki")

/datum/gear/fluff/entchtut_medal
	path = /obj/item/clothing/accessory/medal/conduct
	display_name = "Entchtut's Conduct Medal"
	ckeywhitelist = list("positronicjune")
	character_name = list("Entchtut Cenein")

/datum/gear/fluff/mechanic_overalls
	path = /obj/item/clothing/under/fluff/mechanic_overalls
	display_name = "mechanic overalls"
	ckeywhitelist = list("pastelprincedan", "hatterhat")
	character_name = list("Masumi Maki", "Harold Robinson")

/datum/gear/fluff/mechanic_coat
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/fluff/mechanic
	display_name = "mechanic winter coat"
	ckeywhitelist = list("pastelprincedan", "hatterhat")
	character_name = list("Masumi Maki", "Harold Robinson")

/datum/gear/fluff/slimecat_rd_plush
	path = /obj/item/toy/plushie/fluff/slimeowshi
	display_name = "slimecat RD plushie"
	ckeywhitelist = list("pastelprincedan")
	character_name = list("Kiyoshi Maki", "Masumi Maki")

//  Q CKEYS

//  R CKEYS
/datum/gear/fluff/tiemli_weldinggoggles
	path = /obj/item/clothing/glasses/welding/tiemgogs
	display_name = "Tiemli's Welding Goggles"
	ckeywhitelist = list("radiantaurora")
	character_name = list("Tiemli Kroto")
	allowed_roles = list("Roboticist")

/datum/gear/fluff/clara_flask
	path = /obj/item/weapon/reagent_containers/food/drinks/glass2/fluff/claraflask
	display_name = "Clara's Vacuum Flask"
	ckeywhitelist = list("rboys2")
	character_name = list("Clara Mali")
	cost = 1

/datum/gear/fluff/luna_sci_medal
	path = /obj/item/clothing/accessory/medal/nobel_science
	display_name = "LUNA's Nobel Science Award"
	ckeywhitelist = list("residentcody")
	character_name = list("LUNA")

/datum/gear/fluff/luna_conduct_medal
	path = /obj/item/clothing/accessory/medal/conduct
	display_name = "LUNA's Distinguished Conduct Medal"
	ckeywhitelist = list("residentcody")
	character_name = list("LUNA")

/datum/gear/fluff/pathfinder_id
	path = /obj/item/weapon/card/id/event/polymorphic/itg
	display_name = "Pathfinder's ITG ID"
	ckeywhitelist = list("residentcody")
	character_name = list("Pathfinder")

/datum/gear/fluff/revolver_claymore
	path = /obj/item/weapon/sword/fluff/revolver
	display_name = "Catnip"
	ckeywhitelist = list("revolvereloise")
	character_name = list("Revolver Eloise")

/datum/gear/fluff/nikki_dorky_outfit
	path = /obj/item/weapon/storage/box/fluff
	display_name = "Nikki's Witchy Outfit"
	ckeywhitelist = list("ryumi")
	character_name = list("Nikki Yumeno")

//  S CKEYS
/datum/gear/fluff/brynhild_medal
	path = /obj/item/clothing/accessory/medal/silver/valor
	display_name = "Brynhild's Valor Medal"
	ckeywhitelist = list("sageofaether12")
	character_name = list("Brynhild Vandradottir")

/datum/gear/fluff/brynhild_medal_2
	path = /obj/item/clothing/accessory/medal/silver/unity
	display_name = "Brynhild's Unity Medal"
	ckeywhitelist = list("sageofaether12")
	character_name = list("Brynhild Vandradottir")

/datum/gear/fluff/brynhild_medal_3
	path = /obj/item/clothing/accessory/medal/conduct
	display_name = "Brynhild's Conduct Medal"
	ckeywhitelist = list("sageofaether12")
	character_name = list("Brynhild Vandradottir")

/datum/gear/fluff/brynhild_medal_4
	path = /obj/item/clothing/accessory/medal/bronze_heart
	display_name = "Brynhild's Heart Medal"
	ckeywhitelist = list("sageofaether12")
	character_name = list("Brynhild Vandradottir")

/datum/gear/fluff/kateryna_voidsuit
	path = /obj/item/clothing/suit/space/void/engineering/kate
	display_name = "Kateryna's Voidsuit"
	ckeywhitelist = list("samanthafyre")
	character_name = list("Kateryna Petrovitch")
	allowed_roles = list("Engineer", "Chief Engineer", "Atmospheric Technician")

/datum/gear/fluff/katerina_spacesuit
	path = /obj/item/clothing/head/helmet/space/fluff/kate
	display_name = "Kateryna's Helmet"
	ckeywhitelist = list("samanthafyre")
	character_name = list("Kateryna Petrovitch")
	allowed_roles = list("Engineer", "Chief Engineer", "Atmospheric Technician")

/datum/gear/fluff/kateryna_armorvest
	path = /obj/item/clothing/suit/armor/vest/wolftaur/kate
	display_name = "Kateryna's Armor Vest"
	slot = slot_wear_suit
	ckeywhitelist = list("samanthafyre")
	character_name = list("Kateryna Petrovitch")
	allowed_roles = list("Security Officer", "Warden", "Head of Security", "Site Manager", "Head of Personnel")

/datum/gear/fluff/viktor_flask
	path = /obj/item/weapon/reagent_containers/food/drinks/flask/vacuumflask/fluff/viktor
	display_name = "Viktor's Flask"
	ckeywhitelist = list("semaun")
	character_name = list("Viktor Solothurn")

/datum/gear/fluff/scree_modkit
	path = /obj/item/modkit_conversion/fluff/screekit
	display_name = "Scree's Modkit"
	ckeywhitelist = list("scree")
	character_name = list("Scree")

/datum/gear/fluff/scree_pompom
	path = /obj/item/clothing/head/fluff/pompom
	display_name = "Scree's Weird PopPom thing"
	slot = slot_head
	ckeywhitelist = list("scree")
	character_name = list("Scree")

/datum/gear/fluff/avida_dress
	path = /obj/item/clothing/under/skirt/outfit/fluff/avida
	display_name = "Avida's Dress"
	slot = slot_w_uniform
	ckeywhitelist = list("scree")
	character_name = list("Avida")

/datum/gear/fluff/avida_hat
	path = /obj/item/clothing/head/fluff/avida
	display_name = "Avida's Hat"
	slot = slot_head
	ckeywhitelist = list("scree")
	character_name = list("Avida")

/datum/gear/fluff/alfonso_sunglasses
	path = /obj/item/clothing/glasses/sunglasses/fluff/alfonso
	display_name = "Alfonso's Sunglasses"
	slot = slot_glasses
	ckeywhitelist = list("seiga")
	character_name = list("Alfonso Oak Telanor")

/datum/gear/fluff/nthasd_modkit //Converts a Security suit's sprite
	path = /obj/item/modkit_conversion/hasd
	display_name = "NT-HASD 556's Modkit"
	ckeywhitelist = list("silencedmp5a5")
	character_name = list("NT-HASD #556")
	allowed_roles = list("Site Manager", "Head of Personnel", "Security Officer", "Warden", "Head of Security","Detective")

/datum/gear/fluff/serdykov_modkit //Also converts a Security suit's sprite
	path = /obj/item/modkit_conversion/fluff/serdykit
	display_name = "Serdykov Antoz's Modkit"
	ckeywhitelist = list("silencedmp5a5")
	character_name = list("Serdykov Antoz")
	allowed_roles = list("Site Manager", "Head of Personnel", "Security Officer", "Warden", "Head of Security","Detective")

/datum/gear/fluff/tasy_clownuniform
	path = /obj/item/clothing/under/sexyclown
	display_name = "Tasy's Clown Uniform"
	slot = slot_w_uniform
	ckeywhitelist = list("silvertalismen")
	character_name = list("Tasy Ruffles")

/datum/gear/fluff/tasy_clownmask
	path = /obj/item/clothing/mask/gas/sexyclown
	display_name = "Tasy's Clownmask"
	slot = slot_wear_mask
	ckeywhitelist = list("silvertalismen")
	character_name = list("Tasy Ruffles")

/datum/gear/fluff/tasy_clownPDA
	path = /obj/item/pda/clown
	display_name = "Tasy's Clown PDA"
	ckeywhitelist = list("silvertalismen")
	character_name = list("Tasy Ruffles")

/datum/gear/fluff/fortune_backpack
	path = /obj/item/weapon/storage/backpack/satchel/fluff/swat43bag
	display_name = "Fortune's Backpack"
	slot = slot_back
	ckeywhitelist = list("swat43")
	character_name = list("Fortune Bloise")

/datum/gear/fluff/kyutar
	path = /obj/item/instrument/piano_synth/fluff/kyutar
	display_name = "Kyu's Holotar"
	ckeywhitelist = list("stobarico")
	character_name = list("Kyu Comet")

/datum/gear/fluff/roiz_coat
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/roiz
	display_name = "Roiz's Coat"
	slot = slot_wear_suit
	ckeywhitelist = list("spoopylizz")
	character_name = list("Roiz Lizden")

/datum/gear/fluff/lilith_medal
	path = /obj/item/clothing/accessory/medal/silver/valor
	display_name = "Lilith's Valor Medal"
	ckeywhitelist = list("stiphs")
	character_name = list("Lilith Vespers")

/datum/gear/fluff/silent_mimemask
	path = /obj/item/clothing/mask/gas/sexymime
	display_name = "Silent Stripe's Mime Mask"
	slot = slot_wear_mask
	ckeywhitelist = list("suicidalpickles")
	character_name = list("Silent Stripes")

/datum/gear/fluff/silent_mimeuniform
	path = /obj/item/clothing/under/sexymime
	display_name = "Silent Stripe's Mime Uniform"
	slot = slot_w_uniform
	ckeywhitelist = list("suicidalpickles")
	character_name = list("Silent Stripes")

//  T CKEYS
/datum/gear/fluff/ascian_medal
	path = /obj/item/clothing/accessory/medal/silver/unity/tabiranth
	display_name = "Ascian's Unity Medal"
	ckeywhitelist = list("tabiranth")
	character_name = list("Ascian")

/datum/gear/fluff/ascian_medal_2
	path = /obj/item/clothing/accessory/medal/silver/valor
	display_name = "Ascian's Valor Medal"
	ckeywhitelist = list("tabiranth")
	character_name = list("Ascian")

/datum/gear/fluff/ascian_medal_3
	path = /obj/item/clothing/accessory/medal/conduct
	display_name = "Ascian's Conduct Medal"
	ckeywhitelist = list("tabiranth")
	character_name = list("Ascian")

/datum/gear/fluff/ascian_spiritspawner
	path = /obj/item/weapon/grenade/spawnergrenade/spirit
	display_name = "The Best Kitten"
	ckeywhitelist = list("tabiranth")
	character_name = list("Ascian")

/datum/gear/fluff/ascian_shelterpod
	path = /obj/item/survivalcapsule/tabiranth
	display_name = "Ascian's Shelterpod"
	ckeywhitelist = list("tabiranth")
	character_name = list("Ascian")

/datum/gear/fluff/lasshseeki_ealimplant
	path = /obj/item/weapon/implant/language/eal
	display_name = "Lasshseeki's EAL Implant"
	ckeywhitelist = list("techtypes")
	character_name = list("Lasshseeki Korss")

/datum/gear/fluff/nick_medal
	path = /obj/item/clothing/accessory/medal/conduct
	display_name = "Nick's Conduct Medal"
	ckeywhitelist = list("thedavestdave")
	character_name = list("Nick Sloan")

/datum/gear/fluff/roy_medal
	path = /obj/item/clothing/accessory/medal/silver/unity
	display_name = "Roy's Unity Medal"
	ckeywhitelist = list("thedavestdave")
	character_name = list("Roy Tilton")

/datum/gear/fluff/monty_balaclava
	path = /obj/item/clothing/mask/balaclava
	display_name = "Monty's Balaclava"
	slot = slot_wear_mask
	ckeywhitelist = list("theskringdinger")
	character_name = list("Monty Kopic")

/datum/gear/fluff/shadow_laptop
	path = /obj/item/modular_computer/laptop/preset/custom_loadout/advanced/shadowlarkens
	display_name = "Shadow's Laptop"
	ckeywhitelist = list("tigercat2000")
	character_name = list("Shadow Larkens")
	cost = 5

/datum/gear/fluff/konor_medal
	path = /obj/item/clothing/accessory/medal/silver/unity
	display_name = "Konor's Unity Medal"
	ckeywhitelist = list("tinydude16")
	character_name = list("Konor Foxe")

//  U CKEYS
/datum/gear/fluff/brad_jordans
	path = /obj/item/clothing/shoes/fluff/airjordans
	display_name = "Bradley's Air Jordans"
	ckeywhitelist = list("unclefruitvevo")
	character_name = list("Bradley Khatibi")

//  V CKEYS
/datum/gear/fluff/verie_suit
	path = /obj/item/clothing/under/fluff/verie
	display_name = "Verie's Salacious Suit"
	ckeywhitelist = list("vitoras")
	character_name = list("Verie")

/datum/gear/fluff/verie_hoodie
	path = /obj/item/clothing/suit/storage/hooded/fluff/verie
	display_name = "Verie's Helluva Hoodie"
	ckeywhitelist = list("vitoras")
	character_name = list("Verie")

/datum/gear/fluff/verie_comb
	path = /obj/item/weapon/fluff/verie
	display_name = "Verie's Crazy Comb"
	description = "(Note: The highlights this gives you will be placed above EVERYTHING... including mobs!)"
	ckeywhitelist = list("vitoras")
	character_name = list("Verie")

/datum/gear/fluff/cameron_glasses
	path = /obj/item/clothing/glasses/fluff/science_proper
	display_name = "Cameron's Science Glasses"
	slot = slot_glasses
	ckeywhitelist = list("verkister")
	character_name = list("Cameron Eggbert")

/datum/gear/fluff/cameron_disk
	path = /obj/item/weapon/disk/limb/eggnerdltd
	display_name = "Cameron's Eggnerd Disk"
	ckeywhitelist = list("verkister")
	character_name = list("Cameron Eggbert")

/datum/gear/fluff/opie_glasses
	path = /obj/item/clothing/glasses/fluff/spiffygogs
	display_name = "Opie's Goggles"
	slot = slot_glasses
	ckeywhitelist = list("verkister")
	character_name = list("Opie Eggbert")

/datum/gear/fluff/verin_hazardvest
	path = /obj/item/clothing/suit/storage/hazardvest/fluff/verin
	display_name = "Verin's Hazard Vest"
	slot = slot_wear_suit
	ckeywhitelist = list("virgo113")
	character_name = list("Verin Raharra")

/datum/gear/fluff/lucina_pda
	path = /obj/item/pda/heads/cmo/fluff/lucinapda
	display_name = "Lucina's PDA"
	ckeywhitelist = list("vorrarkul")
	character_name = list("Lucina Dakarim")

/datum/gear/fluff/lucina_medal
	path = /obj/item/clothing/accessory/medal/gold/fluff/lucina
	display_name = "Lucina's Gold Medal"
	ckeywhitelist = list("vorrarkul")
	character_name = list("Lucina Dakarim")

/datum/gear/fluff/lucina_dress
	path = /obj/item/clothing/under/dress/fluff/lucinadress
	display_name = "Lucina's Dress"
	slot = slot_w_uniform
	ckeywhitelist = list("vorrarkul")
	character_name = list("Lucina Dakarim")

/datum/gear/fluff/melanie_skeleton
	path = /obj/item/clothing/under/fluff/slime_skeleton
	display_name = "Melanie's Skeleton"
	slot = slot_w_uniform
	ckeywhitelist = list("vorrarkul")
	character_name = list("Melanie Farmer")

/datum/gear/fluff/nyssa_coat
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/cargo
	display_name = "Nyssa's Coat"
	slot = slot_wear_suit
	ckeywhitelist = list("vorrarkul")
	character_name = list("Nyssa Brennan")

/datum/gear/fluff/theodora_suit
	path = /obj/item/clothing/suit/chococoat
	display_name = "Theodora's Coat"
	slot = slot_wear_suit
	ckeywhitelist = list("vorrarkul")
	character_name = list("Theodora Lindt")

/datum/gear/fluff/kaitlyn_plush
	path = /obj/item/toy/plushie/mouse/fluff
	display_name = "Kaitlyn's Mouse Plush"
	ckeywhitelist = list("vorrarkul")
	character_name = list("Kaitlyn Fiasco")

/datum/gear/fluff/keturah_maiddress
	path = /obj/item/clothing/under/dress/maid
	display_name = "Keturah's Maid Dress"
	slot = slot_w_uniform
	ckeywhitelist = list("viveret")
	character_name = list("Keturah")

/datum/gear/fluff/silentio_mimeuniform
	path = /obj/item/clothing/under/sexymime
	display_name = "Silentio's Mime Uniform"
	slot = slot_w_uniform
	ckeywhitelist = list("viveret")
	character_name = list("Silentio")

/datum/gear/fluff/silentio_mimemask
	path = /obj/item/clothing/mask/gas/sexymime
	display_name = "Silentio's Mime Mask"
	slot = slot_wear_mask
	ckeywhitelist = list("viveret")
	character_name = list("Silentio")

/datum/gear/fluff/roanna_medal
	path = /obj/item/clothing/accessory/medal/silver/unity
	display_name = "Roanna's Unity Medal"
	ckeywhitelist = list("vitoras")
	character_name = list("Roanna Ti'Rox")

/datum/gear/fluff/harmony_id
	path = /obj/item/weapon/card/id/event/polymorphic/itg
	display_name = "Harmony's ITG-ID card"
	ckeywhitelist = list("verysoft")
	character_name = list("Harmony")

/datum/gear/fluff/shinerunner_id
	path = /obj/item/weapon/card/id/event/polymorphic/itg
	display_name = "Shine-Runner's ITG-ID card"
	ckeywhitelist = list("verysoft")
	character_name = list("Shine-Runner")

//  W CKEYS
/datum/gear/fluff/sthasha_bracer
	path = /obj/item/clothing/accessory/bracer/fluff/xander_sthasha
	display_name = "S'thasha's Bracer"
	ckeywhitelist = list("wanderingdeviant")
	character_name = list("S'thasha Tavakdavi")

/datum/gear/fluff/silas_glasses
	path = /obj/item/clothing/glasses/threedglasses
	display_name = "Silas' 3-D Glasses"
	slot = slot_glasses
	ckeywhitelist = list("werebear")
	character_name = list("Silas Newton")

/datum/gear/fluff/vinjj_weldingmask
	path = /obj/item/clothing/head/welding/fluff/vinjj
	display_name = "Vinjj's Welding Mask"
	ckeywhitelist = list("whiskyrose")
	character_name = list("Vinjj")

/datum/gear/fluff/tempest_hudglases
	path = /obj/item/clothing/glasses/omnihud/med/fluff/wickedtemphud
	display_name = "Tempest's Medical Hud"
	slot = slot_glasses
	ckeywhitelist = list("wickedtemp")
	character_name = list("Chakat Tempest Venosare")
	allowed_roles = list("Chief Medical Officer","Medical Doctor","Chemist","Psychiatrist","Paramedic", "Field Medic", "Off-duty Medic")

/datum/gear/fluff/tempest_hypospray
	path = /obj/item/weapon/reagent_containers/hypospray/vial/tempest
	display_name = "Tempest's Hypospray"
	slot = slot_belt
	ckeywhitelist = list("wickedtemp")
	character_name = list("Chakat Tempest Venosare")
	allowed_roles = list("Chief Medical Officer","Medical Doctor","Chemist","Psychiatrist","Paramedic", "Field Medic", "Off-duty Medic")

/datum/gear/fluff/tempest_backpack
	path = /obj/item/weapon/storage/backpack/saddlebag/tempest
	display_name = "Tempest's Saddlebag"
	slot = slot_back
	ckeywhitelist = list("wickedtemp")
	character_name = list("Chakat Tempest Venosare")

//  X CKEYS
/datum/gear/fluff/penelope_box
	path = /obj/item/weapon/storage/box/fluff/penelope
	display_name = "Penelope's Box"
	ckeywhitelist = list("xsdew")
	character_name = list("Penelope Allen")

/datum/gear/fluff/ali_medal
	path = /obj/item/clothing/accessory/medal/silver/unity
	display_name = "Ali's Unity Medal"
	ckeywhitelist = list("xonkon")
	character_name = list("Ali")

/datum/gear/fluff/zena_suit
	path = /obj/item/clothing/suit/space/void/engineering/zena
	display_name = "Zena's Shroud Suit"
	ckeywhitelist = list("xonkon")
	character_name = list("Zena Aviv")

/datum/gear/fluff/zena_helmet
	path = /obj/item/clothing/head/helmet/space/void/engineering/zena
	display_name = "Zena's Shroud Helmet"
	ckeywhitelist = list("xonkon")
	character_name = list("Zena Aviv")


//  Y CKEYS

/datum/gear/fluff/lemon_plush
	path = /obj/item/toy/plushie/fluff/lemonplush
	display_name = "yellow slime plushie"
	ckeywhitelist = list("yecrowbarman")
	character_name = list("Lemon Yellow", "Lemon Gettler Yellow", "Lemon Lee Yellow", "Lemon Jade Yellow") //different sleeves, same char

//  Z CKEYS
/datum/gear/fluff/tachika_medal
	path = /obj/item/clothing/accessory/medal/conduct
	display_name = "Tachika's Conduct Medal"
	ckeywhitelist = list("zammyman215")
	character_name = list("Tachika")

/datum/gear/fluff/zaoozaoo_hat
	path = /obj/item/clothing/head/fluff/zao
	display_name = "Zaoozaoo's Hat"
	slot = slot_head
	ckeywhitelist = list("zigfe")
	character_name = list("Zaoozaoo Xrimxuqmqixzix")

/datum/gear/fluff/nehi_radio
	path = /obj/item/radio/headset/fluff/zodiacshadow
	display_name = "Nehi's 'phones"
	ckeywhitelist = list("zodiacshadow")
	character_name = list("Nehi Maximus")

/datum/gear/fluff/nehi_health_medal
	path = /obj/item/clothing/accessory/medal/silver/fluff/zodiacshadow
	display_name = "Health Service Achievement medal"
	ckeywhitelist = list("zodiacshadow")
	character_name = list("Nehi Maximus")

/datum/gear/fluff/lucky_amour
	path = /obj/item/clothing/suit/armor/combat/crusader_costume/lucky
	display_name = "Lucky's amour"
	ckeywhitelist = list ("thedavestdave")
	character_name = list("Lucky")
	allowed_roles = "Chaplain"
