/datum/maint_recycler_vendor_entry/capture_crystal //just the stock one, keep the stronger ones to redgates
	name = "Capture Crystal"
	ad_message = "Poking Ball??"
	desc = "Subject your victim to the horror of being condensed down into a sub-reality of comically nausiating proportions! Bind them to your will! ignore morality issues! I get these for cheap, so you get them for slightly less cheap!"
	item_cost = 30 //kinda pricy, encourage other sources
	icon_state = "copyright" //lawyers at it again...
	object_type_to_spawn = /obj/item/capture_crystal
	tagline = "Capture crystal go to the recycling center!"
	vendor_category = MAINTVENDOR_SCENETOOLS

/datum/maint_recycler_vendor_entry/walkies
	name = "Leash"
	ad_message = "Walkies??"
	desc = "A leash for your pet! or a person! or a pet person! or a person pet! or a pet pet! or a person person! or a pet pet person! or a person pet pet! or a pet person person! or a person pet person! or a pet person pet!"
	object_type_to_spawn = /obj/item/leash
	item_cost = 20 //more expensive than recycling it!
	icon_state = "leash"
	tagline = "Remember, no pulling! Unless they deserve it! punks."
	vendor_category = MAINTVENDOR_SCENETOOLS

/datum/maint_recycler_vendor_entry/collar //god there's so many
	name = "Collar?"
	ad_message = "I barely know er!"
	desc = "Surplus from NT's dubiously real Ian cloning program has come to light, and the savings are for YOU!!"
	object_type_to_spawn = /obj/item/clothing/accessory/collar/silver //treating silver as the default as /collar is just "TIE"
	tagline = "Don't keep it too tight!"
	item_cost = 5 //cheap!
	icon_state = list("collar1","collar2","collar3")
	vendor_category = MAINTVENDOR_SCENETOOLS


/datum/maint_recycler_vendor_entry/collar/gold
	name = "Gold-Tagged Collar"
	ad_message = "AWOOOOOOGA!"
	desc = "A golden tagged treat for a particurally pimpy pet! or pets! I know what you are!"
	object_type_to_spawn = /obj/item/clothing/accessory/collar/gold
	vendor_category = MAINTVENDOR_SCENETOOLS

/datum/maint_recycler_vendor_entry/collar/bell
	name = "DINGDINGDINGDING"
	ad_message = "Waiter! a collar please!"
	desc = "DINGDINGDINGDING! 🛎️🛎️🛎️🛎️ WAITER! FIND ME MY PET. WAITER?!"
	object_type_to_spawn = /obj/item/clothing/accessory/collar/bell
	vendor_category = MAINTVENDOR_SCENETOOLS

/datum/maint_recycler_vendor_entry/collar/shock
	name = "Z4P Chok3r 4 k00l fr34ks... not like u care..."
	ad_message = "Electricity!"
	desc = "heh... nothing personelle... but it is! (a shockingly good deal!) buy now!"
	object_type_to_spawn = /obj/item/clothing/accessory/collar/shock
	vendor_category = MAINTVENDOR_SCENETOOLS

/datum/maint_recycler_vendor_entry/collar/spike
	name = "Spiked Collar"
	ad_message = "crawling in my skin!"
	desc = "these wounds may not heal, but your wallet sure will! this spiked collar WILL look edgy! which is good!"
	object_type_to_spawn = /obj/item/clothing/accessory/collar/spike
	vendor_category = MAINTVENDOR_SCENETOOLS

/datum/maint_recycler_vendor_entry/collar/pink
	name = "Pink Collar"
	ad_message = "FA-B-U-LOUS!✨✨"
	desc = "One pet in the pink, and a collar that physically can't stink! it's a win-win!"
	object_type_to_spawn = /obj/item/clothing/accessory/collar/pink
	vendor_category = MAINTVENDOR_SCENETOOLS

/datum/maint_recycler_vendor_entry/collar/earth
	name = "Earth Collar"
	ad_message = "Imagine ur pet's a geology nerd! LMFAO!"
	desc = "A failed tourist gimmick! the savings we got from the ungodly amount of surplus get passed onto YOU!"
	object_type_to_spawn = /obj/item/clothing/accessory/collar/collarplanet_earth
	vendor_category = MAINTVENDOR_SCENETOOLS

/datum/maint_recycler_vendor_entry/collar/holo
	name = "Holo Collar"
	ad_message = "Holo, Holo, Holo!"
	desc = "For the social-media-obsessed pet owner! this collar TOO has a screen! You can watch shortform videos WHILE scrungling your pet! waow!"
	object_type_to_spawn = /obj/item/clothing/accessory/collar/holo
	vendor_category = MAINTVENDOR_SCENETOOLS

/datum/maint_recycler_vendor_entry/collar/holo2
	name = "Acid resistant collar!"
	ad_message = "Basic!"
	desc = "Just like the spoon's worth of microplastic inside your brain, this too is with you forever! have fun!"
	object_type_to_spawn = /obj/item/clothing/accessory/collar/holo/indigestible
	vendor_category = MAINTVENDOR_SCENETOOLS

/datum/maint_recycler_vendor_entry/collar/bluespace
	name = "Bluespace Size Collar Wow Cool Magic Wow!"
	ad_message = "Magic!"
	desc = "Believe it or not, pets freak out when shrunk to the size of a pea! We can't sell these, so you need to buy it instead! I know what you are!"
	object_type_to_spawn = /obj/item/clothing/accessory/collar/shock/bluespace
	vendor_category = MAINTVENDOR_SCENETOOLS

/datum/maint_recycler_vendor_entry/tf_gun //lets go gambling!
	name = "MetaMorph Ray"
	ad_message = "Metamorph-SUS!"
	desc = "Wow! You wouldn't BELIEVE how many of these things we have! That surplus and the mystery of the exact one you get is up to YOU!"
	item_cost = 30 //kinda pricy, encourage other sources
	object_type_to_spawn = /obj/random/fromList/TFGuns
	icon_state="tf-gun"
	vendor_category = MAINTVENDOR_SCENETOOLS

/datum/maint_recycler_vendor_entry/NIF_laws
	name = "COMM4ND UR N1F!"
	ad_message = "KNEEL!"
	icon_state = "law"
	desc = "Unlocks the TRUE potential of your NIF! You set laws, you follow laws! Simple as! (we are not liable for usage on other parties)"
	object_type_to_spawn = /obj/item/disk/nifsoft/compliance
	tagline = "You didn't get it from us!"
	vendor_category = MAINTVENDOR_SCENETOOLS

/datum/maint_recycler_vendor_entry/NIFlet_laws
	name = "Implnt law?"
	ad_message = "Niflets seething!"
	icon_state = "law"
	desc = "Underlings not listening to you? Someone forgetting to do whta you tell them to? No more! this implant WILL make people bend to your will! KNEEL!"
	object_type_to_spawn = /obj/item/implanter/compliance
	item_cost = 25
	icon_state = "implanter"
	tagline = "Don't ask, don't tell!"
	vendor_category = MAINTVENDOR_SCENETOOLS

/datum/maint_recycler_vendor_entry/bluespace_cracker
	name = "BLU3SP4C3 P4RTY CR4CK3R"
	ad_message = "Party!"
	desc = "Not a teleporting white person, it's a party favor! we've been sued so many times we HAVE to sell it here, which means you get it cheap!"
	object_type_to_spawn = /obj/item/cracker
	item_cost = 15
	vendor_category = MAINTVENDOR_SCENETOOLS

/datum/maint_recycler_vendor_entry/bait_toys
	name = "Bait Toy"
	ad_message = "Bait used to be believable!"
	desc = "I have so many scars from my local catgirls!"
	object_type_to_spawn = /obj/item/toy/monster_bait
	item_cost = 15 //marginally more expensive than what u can sell it for
	tagline = "do NOT let them get it. EVER."
	vendor_category = MAINTVENDOR_SCENETOOLS

/datum/maint_recycler_vendor_entry/size_gun
	name = "BIG GUN 4 SMALL PEOPLE OR SMALL GUN 4 BIG PEOPLE"
	ad_message = "Size Matters!"
	desc = "Performance issues? Under 5'11? Shoot yourself!"
	object_type_to_spawn = /obj/item/gun/energy/sizegun
	item_cost = 30 //kinda pricy, encourage other sources
	icon_state = "size_gun"
	tagline = "Size matters!"
	vendor_category = MAINTVENDOR_SCENETOOLS

/datum/maint_recycler_vendor_entry/voodoo
	name = "V00D00 CURSE UPON YOU"
	ad_message = "SPOOKY!"
	desc = "HELP! I annoyed a SPOOOOKY redspace witch, and she made this doll of me! haha? unless? Farsooth? It works remotely? I can feel it? wow! buy it!"
	object_type_to_spawn = /obj/item/storage/box/remote_scene_tools/voodoo
	item_cost = 30
	tagline = "I know what you are!"
	vendor_category = MAINTVENDOR_SCENETOOLS

/datum/maint_recycler_vendor_entry/portal_stickers
	name = "REMOTE HOLE SEEKING GOAL"
	ad_message = "BLUESPCAE!"
	desc = "WAOW! A Portable hole! Alas, it's not useful for storage, but it IS useful for uh... um.... wow. no wonder it was surplus, this thing is weird!"
	object_type_to_spawn = /obj/item/storage/box/remote_scene_tools
	item_cost = 30
	tagline = "REMEMBER! YOU CAN'T SPELL BLUESPACE WITHOUT BS!"
	vendor_category = MAINTVENDOR_SCENETOOLS
