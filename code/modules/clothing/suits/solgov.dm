//SolGov Uniform Suits
/obj/item/clothing/suit/storage/solgov
	name = "master solgov jacket"
	icon = 'icons/inventory/suit/item.dmi'
	icon_override = 'icons/inventory/suit/mob.dmi'

//Service

/obj/item/clothing/suit/storage/solgov/service
	name = "service jacket"
	desc = "A uniform service jacket, plain and undecorated."
	icon_state = "blackservice"
	item_state = "blackservice"
	item_state_slots = list(slot_r_hand_str = "suit_black", slot_l_hand_str = "suit_black")
	body_parts_covered = UPPER_TORSO|ARMS
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9
	flags_inv = HIDEHOLSTER //VOREStation Add - These obviously do.
	allowed = list(/obj/item/weapon/tank/emergency/oxygen,/obj/item/device/flashlight,/obj/item/weapon/pen,/obj/item/clothing/head/soft,/obj/item/clothing/head/beret,/obj/item/weapon/storage/fancy/cigarettes,/obj/item/weapon/flame/lighter,/obj/item/device/taperecorder,/obj/item/device/analyzer,/obj/item/device/radio,/obj/item/taperoll)
	valid_accessory_slots = (ACCESSORY_SLOT_ARMBAND|ACCESSORY_SLOT_MEDAL|ACCESSORY_SLOT_INSIGNIA|ACCESSORY_SLOT_RANK|ACCESSORY_SLOT_DEPT)
	restricted_accessory_slots = (ACCESSORY_SLOT_ARMBAND)

/obj/item/clothing/suit/storage/solgov/service/sifguard
	name = "\improper SifGuard jacket"
	desc = "A uniform service jacket belonging to the Sif Defense Force."
	icon_state = "sgservice_crew"

/obj/item/clothing/suit/storage/solgov/service/sifguard/medical
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/medical/service)

/obj/item/clothing/suit/storage/solgov/service/sifguard/medical/command
	icon_state = "sgservice_officer"

/obj/item/clothing/suit/storage/solgov/service/sifguard/engineering
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/engineering/service)

/obj/item/clothing/suit/storage/solgov/service/sifguard/engineering/command
	icon_state = "sgservice_officer"

/obj/item/clothing/suit/storage/solgov/service/sifguard/supply
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/supply/service)

/obj/item/clothing/suit/storage/solgov/service/sifguard/security
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/security/service)

/obj/item/clothing/suit/storage/solgov/service/sifguard/security/command
	icon_state = "sgservice_officer"

/obj/item/clothing/suit/storage/solgov/service/sifguard/service
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/service/service)

/obj/item/clothing/suit/storage/solgov/service/sifguard/service/command
	icon_state = "sgservice_officer"

/obj/item/clothing/suit/storage/solgov/service/sifguard/exploration
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/exploration/service)

/obj/item/clothing/suit/storage/solgov/service/sifguard/exploration/command
	icon_state = "sgservice_officer"

/obj/item/clothing/suit/storage/solgov/service/sifguard/research
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/research/service)

/obj/item/clothing/suit/storage/solgov/service/sifguard/research/command
	icon_state = "sgservice_officer"

/obj/item/clothing/suit/storage/solgov/service/sifguard/command
	icon_state = "sgservice_officer"
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/command/service)

/obj/item/clothing/suit/storage/solgov/service/fleet
	name = "fleet service jacket"
	desc = "A navy blue SCG Fleet service jacket."
	icon_state = "blueservice"
	item_state = "blueservice"

/obj/item/clothing/suit/storage/solgov/service/fleet/snco
	name = "fleet SNCO service jacket"
	desc = "A navy blue SCG Fleet service jacket with silver cuffs."
	icon_state = "blueservice_snco"
	item_state = "blueservice_snco"

/obj/item/clothing/suit/storage/solgov/service/fleet/officer
	name = "fleet officer's service jacket"
	desc = "A navy blue SCG Fleet dress jacket with silver accents."
	icon_state = "blueservice_off"
	item_state = "blueservice_off"

/obj/item/clothing/suit/storage/solgov/service/fleet/command
	name = "fleet senior officer's service jacket"
	desc = "A navy blue SCG Fleet dress jacket with gold accents."
	icon_state = "blueservice_comm"
	item_state = "blueservice_comm"

/obj/item/clothing/suit/storage/solgov/service/fleet/flag
	name = "fleet flag officer's service jacket"
	desc = "A navy blue SCG Fleet dress jacket with red accents."
	icon_state = "blueservice_flag"
	item_state = "blueservice_flag"

/obj/item/clothing/suit/storage/solgov/service/army
	name = "marine coat"
	desc = "An SCG Marine service coat. Green and undecorated."
	icon_state = "greenservice"
	item_state = "greenservice"

/obj/item/clothing/suit/storage/solgov/service/army/medical
	name = "marine medical jacket"
	desc = "An SCG Marine service coat. This one has blue markings."
	icon_state = "greenservice_med"
	item_state = "greenservice_med"

/obj/item/clothing/suit/storage/solgov/service/army/medical/command
	name = "marine medical command jacket"
	desc = "An SCG Marine service coat. This one has blue and gold markings."
	icon_state = "greenservice_medcom"
	item_state = "greenservice_medcom"

/obj/item/clothing/suit/storage/solgov/service/army/engineering
	name = "marine engineering jacket"
	desc = "An SCG Marine service coat. This one has orange markings."
	icon_state = "greenservice_eng"
	item_state = "greenservice_eng"

/obj/item/clothing/suit/storage/solgov/service/army/engineering/command
	name = "marine engineering command jacket"
	desc = "An SCG Marine service coat. This one has orange and gold markings."
	icon_state = "greenservice_engcom"
	item_state = "greenservice_engcom"

/obj/item/clothing/suit/storage/solgov/service/army/supply
	name = "marine supply jacket"
	desc = "An SCG Marine service coat. This one has brown markings."
	icon_state = "greenservice_sup"
	item_state = "greenservice_sup"

/obj/item/clothing/suit/storage/solgov/service/army/security
	name = "marine security jacket"
	desc = "An SCG Marine service coat. This one has red markings."
	icon_state = "greenservice_sec"
	item_state = "greenservice_sec"

/obj/item/clothing/suit/storage/solgov/service/army/security/command
	name = "marine security command jacket"
	desc = "An SCG Marine service coat. This one has red and gold markings."
	icon_state = "greenservice_seccom"
	item_state = "greenservice_seccom"

/obj/item/clothing/suit/storage/solgov/service/army/service
	name = "marine service jacket"
	desc = "An SCG Marine service coat. This one has green markings."
	icon_state = "greenservice_srv"
	item_state = "greenservice_srv"

/obj/item/clothing/suit/storage/solgov/service/army/service/command
	name = "marine service command jacket"
	desc = "An SCG Marine service coat. This one has green and gold markings."
	icon_state = "greenservice_srvcom"
	item_state = "greenservice_srvcom"

/obj/item/clothing/suit/storage/solgov/service/army/exploration
	name = "marine exploration jacket"
	desc = "An SCG Marine service coat. This one has purple markings."
	icon_state = "greenservice_exp"
	item_state = "greenservice_exp"

/obj/item/clothing/suit/storage/solgov/service/army/exploration/command
	name = "marine exploration command jacket"
	desc = "An SCG Marine service coat. This one has purple and gold markings."
	icon_state = "greenservice_expcom"
	item_state = "greenservice_expcom"

/obj/item/clothing/suit/storage/solgov/service/army/command
	name = "marine command jacket"
	desc = "An SCG Marine Corps service coat. This one has gold markings."
	icon_state = "greenservice_com"
	item_state = "greenservice_com"

//Dress - murder me with a gun why are these 3 different types

/obj/item/clothing/suit/storage/solgov/dress
	name = "dress jacket"
	desc = "A uniform dress jacket, fancy."
	icon_state = "sgdress_xpl"
	item_state = "sgdress_xpl"
	body_parts_covered = UPPER_TORSO|ARMS
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9
	allowed = list(/obj/item/weapon/tank/emergency/oxygen,/obj/item/device/flashlight,/obj/item/clothing/head/soft,/obj/item/clothing/head/beret,/obj/item/device/radio,/obj/item/weapon/pen)
	valid_accessory_slots = (ACCESSORY_SLOT_MEDAL|ACCESSORY_SLOT_RANK)
	restricted_accessory_slots = (ACCESSORY_SLOT_ARMBAND)

/obj/item/clothing/suit/storage/solgov/dress/sifguard
	name = "\improper SifGuard dress jacket"
	desc = "A silver and grey dress jacket belonging to the Sif Defense Force. Fashionable, for the 25th century at least."
	icon_state = "sgdress_xpl"
	item_state = "sgdress_xpl"

/obj/item/clothing/suit/storage/solgov/dress/sifguard/senior
	name = "\improper SifGuard senior's dress coat"
	icon_state = "sgdress_sxpl"
	item_state = "sgdress_sxpl"

/obj/item/clothing/suit/storage/solgov/dress/sifguard/chief
	name = "\improper SifGuard chief's dress coat"
	icon_state = "ecdress_cxpl"
	item_state = "sgdress_cxpl"

/obj/item/clothing/suit/storage/solgov/dress/sifguard/command
	name = "\improper SifGuard officer's dress coat"
	desc = "A gold and black dress peacoat belonging to the Sif Defense Force. The height of fashion."
	icon_state = "ecdress_ofcr"
	item_state = "sgdress_ofcr"

/obj/item/clothing/suit/storage/solgov/dress/sifguard/command/cdr
	name = "\improper SifGuard commander's dress coat"
	icon_state = "sgdress_cdr"
	item_state = "sgdress_cdr"

/obj/item/clothing/suit/storage/solgov/dress/sifguard/command/capt
	name = "\improper SifGuard captain's dress coat"
	icon_state = "sgdress_capt"
	item_state = "sgdress_capt"

/obj/item/clothing/suit/storage/solgov/dress/sifguard/command/adm
	name = "\improper SifGuard admiral's dress coat"
	icon_state = "sgdress_adm"
	item_state = "sgdress_adm"

/obj/item/clothing/suit/storage/solgov/dress/fleet
	name = "fleet dress jacket"
	desc = "A navy blue SCG Fleet dress jacket. Don't get near pasta sauce or vox."
	icon_state = "whitedress"
	item_state = "whitedress"

/obj/item/clothing/suit/storage/solgov/dress/fleet/snco
	name = "fleet dress SNCO jacket"
	desc = "A navy blue SCG Fleet dress jacket with silver cuffs. Don't get near pasta sauce or vox."
	icon_state = "whitedress_snco"
	item_state = "whitedress_snco"

/obj/item/clothing/suit/storage/solgov/dress/fleet/officer
	name = "fleet officer's dress jacket"
	desc = "A navy blue SCG Fleet dress jacket with silver accents. Don't get near pasta sauce or vox."
	icon_state = "whitedress_off"
	item_state = "whitedress_off"

/obj/item/clothing/suit/storage/solgov/dress/fleet/command
	name = "fleet senior officer's dress jacket"
	desc = "A navy blue SCG Fleet dress jacket with gold accents. Don't get near pasta sauce or vox."
	icon_state = "whitedress_comm"
	item_state = "whitedress_comm"

/obj/item/clothing/suit/storage/solgov/dress/fleet/flag
	name = "fleet flag officer's dress jacket"
	desc = "A navy blue SCG Fleet dress jacket with red accents. Don't get near pasta sauce or vox."
	icon_state = "whitedress_flag"
	item_state = "whitedress_flag"

/obj/item/clothing/suit/dress/solgov
	name = "dress jacket"
	desc = "A uniform dress jacket, fancy."
	icon_state = "blackdress"
	item_state = "blackdress"
	icon = 'icons/inventory/suit/item.dmi'
	icon_override = 'icons/inventory/suit/mob.dmi'
	body_parts_covered = UPPER_TORSO|ARMS
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9
	allowed = list(/obj/item/weapon/tank/emergency,/obj/item/device/flashlight,/obj/item/clothing/head/soft,/obj/item/clothing/head/beret,/obj/item/device/radio,/obj/item/weapon/pen)
	valid_accessory_slots = (ACCESSORY_SLOT_MEDAL|ACCESSORY_SLOT_RANK)

/obj/item/clothing/suit/dress/solgov/fleet/sailor
	name = "fleet dress overwear"
	desc = "A navy blue SCG Fleet dress suit. Almost looks like a school-girl outfit."
	icon_state = "sailordress"
	item_state = "whitedress"

/obj/item/clothing/suit/dress/solgov/army
	name = "marine dress jacket"
	desc = "A tailored black SCG Marines dress jacket with red trim. So sexy it hurts."
	icon_state = "blackdress"
	item_state = "blackdress"

/obj/item/clothing/suit/dress/solgov/army/command
	name = "marine officer's dress jacket"
	desc = "A tailored black SCG Marines dress jacket with gold trim. Smells like ceremony."
	icon_state = "blackdress_com"
	item_state = "blackdress_com"

//Misc

/obj/item/clothing/suit/storage/hooded/wintercoat/solgov
	name = "\improper SifGuard winter coat"
	icon_state = "coatec"
	icon = 'icons/inventory/suit/item.dmi'
	icon_override = 'icons/inventory/suit/mob.dmi'
	armor = list(melee = 25, bullet = 10, laser = 5, energy = 10, bomb = 20, bio = 0, rad = 10)
	valid_accessory_slots = (ACCESSORY_SLOT_INSIGNIA|ACCESSORY_SLOT_RANK)

/obj/item/clothing/suit/storage/hooded/wintercoat/solgov/army
	name = "marine winter coat"
	icon_state = "coatar"
	armor = list(melee = 30, bullet = 10, laser = 10, energy = 15, bomb = 20, bio = 0, rad = 0)
	valid_accessory_slots = (ACCESSORY_SLOT_INSIGNIA|ACCESSORY_SLOT_RANK)

/obj/item/clothing/suit/storage/hooded/wintercoat/solgov/fleet
	name = "fleet winter coat"
	icon_state = "coatfl"
	armor = list(melee = 20, bullet = 10, laser = 10, energy = 20, bomb = 20, bio = 0, rad = 10)
	valid_accessory_slots = (ACCESSORY_SLOT_INSIGNIA)

/obj/item/clothing/suit/storage/toggle/dress
	name = "clasped dress jacket"
	desc = "A uniform dress jacket with gold toggles."
	icon_state = "whitedress"
	item_state = "labcoat"
	blood_overlay_type = "coat"

/obj/item/clothing/suit/storage/toggle/dress/fleet
	name = "fleet dress jacket"
	desc = "A crisp white SCG Fleet dress jacket with blue and gold accents. Don't get near pasta sauce or vox."

/obj/item/clothing/suit/storage/toggle/dress/fleet/command
	name = "fleet command dress jacket"
	desc = "A crisp white SCG Fleet dress jacket dripping with gold accents. So bright it's blinding."
	icon_state = "whitedress_com"
	item_state = "labcoat"
	blood_overlay_type = "coat"

/obj/item/clothing/suit/storage/eio_jacket
	name = "EIO jacket"
	desc = "A black synthleather jacket. The acronym 'EIO' of the Emergent Intelligence Oversight is stenciled onto the back in gold lettering."
	icon_state = "marshal_jacket"
	item_state_slots = list(slot_r_hand_str = "suit_black", slot_l_hand_str = "suit_black")
	body_parts_covered = UPPER_TORSO|ARMS

//SAARE Mercenaries

//Service

/obj/item/clothing/suit/storage/saare/service/
	name = "SAARE coat"
	desc = "An Stealth Assault Enterprises . Black and undecorated."
	icon_state = "terranservice"
	item_state = "terranservice"
	icon = 'icons/inventory/suit/item.dmi'
	icon_override = 'icons/inventory/suit/mob.dmi'

/obj/item/clothing/suit/storage/saare/service/command
	name = "SAARE command coat"
	desc = "An Stealth Assault Enterprises command coat. White and undecorated."
	icon_state = "terranservice_comm"
	item_state = "terranservice_comm"

//Dress

/obj/item/clothing/suit/dress/saare
	name = "dress jacket"
	desc = "A Stealth Assault Enterprises uniform dress jacket, fancy."
	icon_state = "terrandress"
	item_state = "terrandress"
	icon = 'icons/inventory/suit/item.dmi'
	icon_override = 'icons/inventory/suit/mob.dmi'
	body_parts_covered = UPPER_TORSO|ARMS
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9
	allowed = list(/obj/item/weapon/tank/emergency,/obj/item/device/flashlight,/obj/item/clothing/head/soft,/obj/item/clothing/head/beret,/obj/item/device/radio,/obj/item/weapon/pen)
	valid_accessory_slots = (ACCESSORY_SLOT_MEDAL|ACCESSORY_SLOT_RANK)

/obj/item/clothing/suit/dress/terran/navy
	name = "SAARE dress cloak"
	desc = "A Stealth Assault Enterprises dress cloak with red detailing. So sexy it hurts."
	icon_state = "terrandress"
	item_state = "terrandress"

/obj/item/clothing/suit/dress/terran/navy/officer
	name = "SAARE officer's dress cloak"
	desc = "A black Stealth Assault Enterprises dress cloak with gold detailing. Smells like ceremony."
	icon_state = "terrandress_off"
	item_state = "terrandress_off"

/obj/item/clothing/suit/dress/terran/navy/command
	name = "SAARE command dress cloak"
	desc = "A black Stealth Assault Enterprises dress cloak with royal detailing. Smells like ceremony."
	icon_state = "terrandress_comm"
	item_state = "terrandress_comm"