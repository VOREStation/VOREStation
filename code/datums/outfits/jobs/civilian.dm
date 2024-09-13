/decl/hierarchy/outfit/job/assistant
	name = OUTFIT_JOB_NAME(USELESS_JOB) //VOREStation Edit - Visitor not Assistant
	id_type = /obj/item/weapon/card/id/generic	//VOREStation Edit

/decl/hierarchy/outfit/job/assistant/visitor
	name = OUTFIT_JOB_NAME(USELESS_JOB)
	id_pda_assignment = USELESS_JOB
	uniform = /obj/item/clothing/under/assistantformal

//VOREStation Add - Interns
/decl/hierarchy/outfit/job/assistant/intern
	name = OUTFIT_JOB_NAME(JOB_INTERN)
	id_type = /obj/item/weapon/card/id/civilian
//VOREStation Add End - Interns

/decl/hierarchy/outfit/job/assistant/resident
	name = OUTFIT_JOB_NAME(JOB_ALT_RESIDENT)
	id_pda_assignment = JOB_ALT_RESIDENT
	uniform = /obj/item/clothing/under/color/white

/decl/hierarchy/outfit/job/service
	l_ear = /obj/item/device/radio/headset/headset_service
	hierarchy_type = /decl/hierarchy/outfit/job/service

/decl/hierarchy/outfit/job/service/bartender
	name = OUTFIT_JOB_NAME(JOB_BARTENDER)
	uniform = /obj/item/clothing/under/rank/bartender
	id_type = /obj/item/weapon/card/id/civilian/service/bartender		//VOREStation Edit
	pda_type = /obj/item/device/pda/bar
	backpack_contents = list(/obj/item/clothing/accessory/permit/gun/bar = 1)

/decl/hierarchy/outfit/job/service/bartender/post_equip(mob/living/carbon/human/H)
	..()
	if(H.back)
		for(var/obj/item/clothing/accessory/permit/gun/bar/permit in H.back.contents)
			permit.set_name(H.real_name)

/decl/hierarchy/outfit/job/service/bartender/barista
	name = OUTFIT_JOB_NAME(JOB_ALT_BARISTA)
	id_pda_assignment = JOB_ALT_BARISTA
	backpack_contents = null

/decl/hierarchy/outfit/job/service/chef
	name = OUTFIT_JOB_NAME(JOB_CHEF)
	uniform = /obj/item/clothing/under/rank/chef
	suit = /obj/item/clothing/suit/chef
	head = /obj/item/clothing/head/chefhat
	id_type = /obj/item/weapon/card/id/civilian/service/chef		//VOREStation Edit
	pda_type = /obj/item/device/pda/chef

/decl/hierarchy/outfit/job/service/chef/cook
	name = OUTFIT_JOB_NAME(JOB_ALT_COOK)
	id_pda_assignment = JOB_ALT_COOK

// Rykka adds Server Outfit

/decl/hierarchy/outfit/job/service/server
	name = OUTFIT_JOB_NAME(JOB_ALT_SERVER)
	uniform = /obj/item/clothing/under/waiter

// End Outfit addition

/decl/hierarchy/outfit/job/service/gardener
	name = OUTFIT_JOB_NAME(JOB_ALT_GARDENER)
	uniform = /obj/item/clothing/under/rank/hydroponics
	suit = /obj/item/clothing/suit/storage/apron
	gloves = /obj/item/clothing/gloves/botanic_leather
	r_pocket = /obj/item/device/analyzer/plant_analyzer
	backpack = /obj/item/weapon/storage/backpack/hydroponics
	satchel_one = /obj/item/weapon/storage/backpack/satchel/hyd
	messenger_bag = /obj/item/weapon/storage/backpack/messenger/hyd
	sports_bag = /obj/item/weapon/storage/backpack/sport/hyd
	id_type = /obj/item/weapon/card/id/civilian/service/botanist	//VOREStation Edit
	pda_type = /obj/item/device/pda/botanist

/decl/hierarchy/outfit/job/service/janitor
	name = OUTFIT_JOB_NAME(JOB_JANITOR)
	uniform = /obj/item/clothing/under/rank/janitor
	id_type = /obj/item/weapon/card/id/civilian/service/janitor		//VOREStation Edit
	pda_type = /obj/item/device/pda/janitor

/decl/hierarchy/outfit/job/librarian
	name = OUTFIT_JOB_NAME(JOB_LIBRARIAN)
	uniform = /obj/item/clothing/under/suit_jacket/red
	l_hand = /obj/item/weapon/barcodescanner
	id_type = /obj/item/weapon/card/id/civilian
	pda_type = /obj/item/device/pda/librarian

/decl/hierarchy/outfit/job/librarian/journalist
	id_type = /obj/item/weapon/card/id/civilian/journalist

/decl/hierarchy/outfit/job/internal_affairs_agent
	name = OUTFIT_JOB_NAME("Internal affairs agent")
	l_ear = /obj/item/device/radio/headset/ia
	uniform = /obj/item/clothing/under/rank/internalaffairs
	suit = /obj/item/clothing/suit/storage/toggle/internalaffairs
	shoes = /obj/item/clothing/shoes/brown
	glasses = /obj/item/clothing/glasses/sunglasses/big
	l_hand = /obj/item/weapon/clipboard
	id_type = /obj/item/weapon/card/id/civilian/internal_affairs
	pda_type = /obj/item/device/pda/lawyer

/decl/hierarchy/outfit/job/chaplain
	name = OUTFIT_JOB_NAME(JOB_CHAPLAIN)
	uniform = /obj/item/clothing/under/rank/chaplain
	l_hand = /obj/item/weapon/storage/bible
	id_type = /obj/item/weapon/card/id/civilian/chaplain
	pda_type = /obj/item/device/pda/chaplain

/decl/hierarchy/outfit/job/explorer
	name = OUTFIT_JOB_NAME(JOB_EXPLORER)
	shoes = /obj/item/clothing/shoes/boots/winter/explorer
	uniform = /obj/item/clothing/under/explorer
	mask = /obj/item/clothing/mask/gas/explorer
	suit = /obj/item/clothing/suit/storage/hooded/explorer
	gloves = /obj/item/clothing/gloves/black
	l_ear = /obj/item/device/radio/headset
	id_slot = slot_wear_id
	id_type = /obj/item/weapon/card/id/exploration					//VOREStation Edit
	pda_slot = slot_belt
	pda_type = /obj/item/device/pda/cargo // Brown looks more rugged
	r_pocket = /obj/item/device/gps/explorer
	id_pda_assignment = JOB_EXPLORER
