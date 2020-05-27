//SolGov uniform hats

//Utility
/obj/item/clothing/head/soft/solgov
	name = "\improper SolGov cap"
	desc = "It's a blue ballcap in Solar Confederate Government colors."
	icon_state = "solsoft"
	item_state_slots = list(
		slot_l_hand_str = "lightbluesoft",
		slot_r_hand_str = "lightbluesoft",
		)

/obj/item/clothing/head/soft/solgov/veteranhat
	name = "veteran hat"
	desc = "It's a tacky black ballcap bearing the yellow service ribbon of the Gaia Conflict."
	icon_state = "cap_veteran"

/obj/item/clothing/head/soft/solgov/sifguard
	name = "\improper SifGuard cap"
	desc = "It's a black ballcap bearing a Sif Defense Force crest."
	icon_state = "expeditionsoft"
	item_state_slots = list(
		slot_l_hand_str = "blacksoft",
		slot_r_hand_str = "blacksoft",
		)

/obj/item/clothing/head/soft/solgov/sifguard/co
	name = "\improper SifGuard captain's cap"
	desc = "It's a black ballcap bearing the Sif Defense Force crest. The brim has gold trim."
	icon_state = "expeditioncomsoft"

/obj/item/clothing/head/soft/solgov/fleet
	name = "fleet cap"
	desc = "It's a navy blue ballcap with a SCG Fleet crest."
	icon_state = "fleetsoft"
	item_state_slots = list(
		slot_l_hand_str = "darkbluesoft",
		slot_r_hand_str = "darkbluesoft",
		)

/obj/item/clothing/head/utility
	name = "utility cover"
	desc = "An eight-point utility cover."
	icon_state = "greyutility"
	item_state_slots = list(
		slot_l_hand_str = "helmet",
		slot_r_hand_str = "helmet",
		)
	siemens_coefficient = 0.9
	body_parts_covered = 0

/obj/item/clothing/head/utility/fleet
	name = "fleet utility cover"
	desc = "A navy blue utility cover bearing the crest of a SCG Fleet."
	icon_state = "navyutility"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 10, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.7

/obj/item/clothing/head/utility/army
	name = "marine utility cover"
	desc = "A green utility cover bearing the crest of the SCG Marines."
	icon_state = "greenutility"
	armor = list(melee = 10, bullet = 0, laser = 10,energy = 0, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/head/utility/army/tan
	name = "tan utility cover"
	desc = "A tan utility cover bearing the crest of the SCG Marines."
	icon_state = "tanutility"

/obj/item/clothing/head/utility/army/urban
	name = "urban utility cover"
	desc = "A grey utility cover bearing the crest of the SCG Marines."
	icon_state = "greyutility"

//Service

/obj/item/clothing/head/service
	name = "service cover"
	desc = "A service uniform cover."
	icon_state = "greenwheelcap"
	item_state_slots = list(
		slot_l_hand_str = "helmet",
		slot_r_hand_str = "helmet",
		)
	siemens_coefficient = 0.9
	body_parts_covered = 0

/obj/item/clothing/head/service/sifguard
	name = "\improper SifGuard peaked cap"
	desc = "A peaked black uniform cap belonging to the Sif Defense Force Corps."
	icon_state = "ecdresscap"

/obj/item/clothing/head/service/sifguard/command
	name = "\improper SifGuard officer's peaked cap"
	desc = "A peaked black uniform cap belonging to the Sif Defense Force. This one is trimmed in gold."
	icon_state = "ecdresscap_ofcr"

/obj/item/clothing/head/service/sifguard/captain
	name = "\improper SifGuard captain's peaked cap"
	desc = "A gold-trimmed peaked black uniform cap belonging to a Captain of the Sif Defense Force."
	icon_state = "ecdresscap_capt"

/obj/item/clothing/head/service/sifguard/senior_command
	name = "senior SifGuard officer's peaked cap"
	desc = "A peaked grey uniform cap belonging to the Sif Defense Force. This one is trimmed in gold and blue."
	icon_state = "greydresscap_senior"

/obj/item/clothing/head/service/army
	name = "marine wheel cover"
	desc = "A green service uniform cover with an SCG Marine crest."
	icon_state = "greenwheelcap"

/obj/item/clothing/head/service/army/command
	name = "marine officer's wheel cover"
	desc = "A green service uniform cover with an SCG Marine crest and gold stripe."
	icon_state = "greenwheelcap_com"

/obj/item/clothing/head/service/army/garrison
	name = "marine garrison cap"
	desc = "A green garrison cap belonging to the SCG Marine."
	icon_state = "greengarrisoncap"

/obj/item/clothing/head/service/army/garrison/command
	name = "marine officer's garrison cap"
	desc = "A green garrison cap belonging to the SCG Marine. This one has a gold pin."
	icon_state = "greengarrisoncap_com"

/obj/item/clothing/head/service/army/campaign
	name = "campaign cover"
	desc = "A green campaign cover with an SCG Marine crest. Only found on the heads of Drill Sergeants."
	icon_state = "greendrill"

//Dress

/obj/item/clothing/head/dress
	name = "dress cover"
	desc = "A dress uniform cover."
	icon_state = "greenwheelcap"
	item_state_slots = list(
		slot_l_hand_str = "helmet",
		slot_r_hand_str = "helmet",
		)
	siemens_coefficient = 0.9
	body_parts_covered = 0

/obj/item/clothing/head/dress/fleet/garrison
	name = "fleet garrison cap"
	desc = "A white dress uniform cap. The classic sailor's choice."
	icon_state = "whitegarrisoncap"

/obj/item/clothing/head/dress/fleet
	name = "fleet dress wheel cover"
	desc = "A white dress uniform cover. This one has an SCG Fleet crest."
	icon_state = "whitepeakcap"

/obj/item/clothing/head/dress/fleet/command
	name = "fleet officer's dress wheel cover"
	desc = "A white dress uniform cover. This one has a gold stripe and an SCG Fleet crest."
	icon_state = "whitepeakcap_com"

/obj/item/clothing/head/dress/army
	name = "marine dress wheel cover"
	desc = "A white dress uniform cover with an SCG Marine crest."
	icon_state = "whitewheelcap"

/obj/item/clothing/head/dress/army/command
	name = "marine officer's dress wheel cover"
	desc = "A white dress uniform cover with an SCG Marine crest and gold stripe."
	icon_state = "whitewheelcap_com"

//Berets

/obj/item/clothing/head/beret/solgov
	name = "peacekeeper beret"
	desc = "A beret in Solar Confederate Government colors. For peacekeepers that are more inclined towards style than safety."
	icon_state = "beret_lightblue"

/obj/item/clothing/head/beret/solgov/homeguard
	name = "home guard beret"
	desc = "A red beret denoting service in the Sol Home Guard. For personnel that are more inclined towards style than safety."
	icon_state = "beret_red"

/obj/item/clothing/head/beret/solgov/gateway
	name = "gateway administration beret"
	desc = "An orange beret denoting service in the Gateway Administration. For personnel that are more inclined towards style than safety."
	icon_state = "beret_orange"

/obj/item/clothing/head/beret/solgov/customs
	name = "customs and trade beret"
	desc = "A purple beret denoting service in the Customs and Trade Bureau. For personnel that are more inclined towards style than safety."
	icon_state = "beret_purpleyellow"

/obj/item/clothing/head/beret/solgov/orbital
	name = "orbital assault beret"
	desc = "A blue beret denoting orbital assault training. For helljumpers that are more inclined towards style than safety."
	icon_state = "beret_blue"

/obj/item/clothing/head/beret/solgov/research
	name = "government research beret"
	desc = "A green beret denoting service in the Bureau of Research. For explorers that are more inclined towards style than safety."
	icon_state = "beret_green"

/obj/item/clothing/head/beret/solgov/health
	name = "health service beret"
	desc = "A white beret denoting service in the Interstellar Health Service. For medics that are more inclined towards style than safety."
	icon_state = "beret_white"

/obj/item/clothing/head/beret/solgov/marcom
	name = "\improper MARSCOM beret"
	desc = "A red beret with a gold insignia, denoting service in the SCGDF Mars Central Command. For brass who are more inclined towards style than safety."
	icon_state = "beret_redgold"

/obj/item/clothing/head/beret/solgov/stratcom
	name = "\improper STRATCOM beret"
	desc = "A grey beret with a silver insignia, denoting service in the SCGDF Strategic Command. For intelligence personnel who are more inclined towards style than safety."
	icon_state = "beret_graysilver"

/obj/item/clothing/head/beret/solgov/diplomatic
	name = "diplomatic security beret"
	desc = "A tan beret denoting service in the SCG Marines Diplomatic Security Group. For security personnel who are more inclined towards style than safety."
	icon_state = "beret_tan"

/obj/item/clothing/head/beret/solgov/borderguard
	name = "border security beret"
	desc = "A green beret with a silver emblem, denoting service in the Bureau of Border Security. For border guards who are more inclined towards style than safety."
	icon_state = "beret_greensilver"

/obj/item/clothing/head/beret/solgov/sifguard
	name = "\improper SifGuard beret"
	desc = "A black beret belonging to the Sif Defense Force. For personnel that are more inclined towards style than safety."
	icon_state = "beret_black"

/obj/item/clothing/head/beret/solgov/sifguard/security
	name = "\improper SifGuard security beret"
	desc = "A Sif Defense Force beret with a security crest. For personnel that are more inclined towards style than safety."
	icon_state = "beret_black_security"

/obj/item/clothing/head/beret/solgov/sifguard/medical
	name = "\improper SifGuard medical beret"
	desc = "A Sif Defense Force beret with a medical crest. For personnel that are more inclined towards style than safety."
	icon_state = "beret_black_medical"

/obj/item/clothing/head/beret/solgov/sifguard/engineering
	name = "\improper SifGuard engineering beret"
	desc = "A Sif Defense Force beret with an engineering crest. For personnel that are more inclined towards style than safety."
	icon_state = "beret_black_engineering"

/obj/item/clothing/head/beret/solgov/sifguard/supply
	name = "\improper SifGuard supply beret"
	desc = "A Sif Defense Force beret with a supply crest. For personnel that are more inclined towards style than safety."
	icon_state = "beret_black_supply"

/obj/item/clothing/head/beret/solgov/sifguard/service
	name = "\improper SifGuard service beret"
	desc = "An Sif Defense Force beret with a service crest. For personnel that are more inclined towards style than safety."
	icon_state = "beret_black_service"

/obj/item/clothing/head/beret/solgov/sifguard/command
	name = "\improper SifGuard command beret"
	desc = "A Sif Defense Force beret with a command crest. For personnel that are more inclined towards style than safety."
	icon_state = "beret_black_command"

/obj/item/clothing/head/beret/solgov/sifguard/branch
	name = "\improper Field Operations beret"
	desc = "An Sif Defense Force beret carrying insignia of the Field Operations section of the Sif Defense Force. For personnel that are more inclined towards style than safety."
	icon_state = "beret_black_fieldOps"

/obj/item/clothing/head/beret/solgov/sifguard/branch/observatory
	name = "\improper Observatory beret"
	desc = "An Sif Defense Force beret carrying insignia of the Observatory section of the Sif Defense Force. For personnel that are more inclined towards style than safety."
	icon_state = "beret_black_observatory"

/obj/item/clothing/head/beret/solgov/fleet
	name = "fleet beret"
	desc = "A navy blue beret belonging to the SCG Fleet. For personnel that are more inclined towards style than safety."
	icon_state = "beret_navy"

/obj/item/clothing/head/beret/solgov/fleet/security
	name = "fleet security beret"
	desc = "An SCG Fleet beret with a security crest. For personnel that are more inclined towards style than safety."
	icon_state = "beret_navy_security"

/obj/item/clothing/head/beret/solgov/fleet/medical
	name = "fleet medical beret"
	desc = "An SCG Fleet beret with a medical crest. For personnel that are more inclined towards style than safety."
	icon_state = "beret_navy_medical"

/obj/item/clothing/head/beret/solgov/fleet/engineering
	name = "fleet engineering beret"
	desc = "An SCG Fleet with an engineering crest. For personnel that are more inclined towards style than safety."
	icon_state = "beret_navy_engineering"

/obj/item/clothing/head/beret/solgov/fleet/supply
	name = "fleet supply beret"
	desc = "An SCG Fleet beret with a supply crest. For personnel that are more inclined towards style than safety."
	icon_state = "beret_navy_supply"

/obj/item/clothing/head/beret/solgov/fleet/service
	name = "fleet service beret"
	desc = "An SCG Fleet beret with a service crest. For personnel that are more inclined towards style than safety."
	icon_state = "beret_navy_service"

/obj/item/clothing/head/beret/solgov/fleet/exploration
	name = "fleet exploration beret"
	desc = "An SCG Fleet beret with an exploration crest. For personnel that are more inclined towards style than safety."
	icon_state = "beret_navy_exploration"

/obj/item/clothing/head/beret/solgov/fleet/command
	name = "fleet command beret"
	desc = "An SCG Fleet beret with a command crest. For personnel that are more inclined towards style than safety."
	icon_state = "beret_navy_command"

/obj/item/clothing/head/beret/solgov/fleet/dress
	name = "fleet dress beret"
	desc = "A white SCG Fleet beret. For personnel that are more inclined towards style than safety."
	icon_state = "beret_whiterim"

/obj/item/clothing/head/beret/solgov/fleet/dress/command
	name = "fleet officer's dress beret"
	desc = "A white SCG Fleet beret with a golden crest. For personnel that are more inclined towards style than safety."
	icon_state = "beret_whiterim_com"

/obj/item/clothing/head/beret/solgov/fleet/branch
	name = "first fleet beret"
	desc = "An SCG Fleet beret carrying insignia of First Fleet, the Sol Guard, stationed in Sol. For personnel that are more inclined towards style than safety."
	icon_state = "beret_navy_first"

/obj/item/clothing/head/beret/solgov/fleet/branch/second
	name = "second fleet beret"
	desc = "An SCG Fleet beret carrying insignia of Second Fleet, the Home Guard, tasked with defense of Sol territories. For personnel that are more inclined towards style than safety."
	icon_state = "beret_navy_second"

/obj/item/clothing/head/beret/solgov/fleet/branch/third
	name = "third fleet beret"
	desc = "An SCG Fleet beret carrying insignia of Third Fleet, the Border Guard, guarding borders of Sol territory against Vox and pirates. For personnel that are more inclined towards style than safety."
	icon_state = "beret_navy_third"

/obj/item/clothing/head/beret/solgov/fleet/branch/fourth
	name = "fourth fleet beret"
	desc = "An SCG Fleet beret carrying insignia of Fourth Fleet, stationed on Skrell border. For personnel that are more inclined towards style than safety."
	icon_state = "beret_navy_fourth"

/obj/item/clothing/head/beret/solgov/fleet/branch/fifth
	name = "fifth fleet beret"
	desc = "An SCG Fleet beret carrying insignia of Fifth Fleet, the Quick Reaction Force, recently formed and outfited with last tech. For personnel that are more inclined towards style than safety."
	icon_state = "beret_navy_fifth"

//ushanka

/obj/item/clothing/head/ushanka/solgov
	name = "\improper SifGuard fur hat"
	desc = "An Sif Defense Force synthfur-lined hat for operating in cold environments."
	icon_state = "ecushankadown"
	//icon_state_up = "ecushankaup"

/obj/item/clothing/head/ushanka/solgov/fleet
	name = "fleet fur hat"
	desc = "An SCG Fleet synthfur-lined hat for operating in cold environments."
	icon_state = "flushankadown"
	//icon_state_up = "flushankaup"

/obj/item/clothing/head/ushanka/solgov/army
	name = "marine fur hat"
	desc = "An SCG Marine synthfur-lined hat for operating in cold environments."
	icon_state = "barushankadown"
	//icon_state_up = "barushankaup"

/obj/item/clothing/head/ushanka/solgov/army/green
	name = "green marine fur hat"
	desc = "An SCG Marine synthfur-lined hat for operating in cold environments."
	icon_state = "arushankadown"
	//icon_state_up = "mcushankaup"

//Terran

/obj/item/clothing/head/terran/navy/service
	name = "ICCGN service cover"
	desc = "A service uniform cover, worn by low-ranking crew within the Independent Navy."
	icon_state = "terranservice"
	item_state = "terranservice"
	item_state_slots = list(
		slot_l_hand_str = "helmet",
		slot_r_hand_str = "helmet")
	body_parts_covered = 0

/obj/item/clothing/head/terran/navy/service/command
	name = "ICCGN command service cover"
	desc = "A service uniform cover, worn by high-ranking crew within the Independent Navy."
	icon_state = "terranservice_comm"
	item_state = "terranservice_comm"
