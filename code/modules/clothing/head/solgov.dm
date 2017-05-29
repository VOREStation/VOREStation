//SolGov uniform hats

//Utility
/obj/item/clothing/head/soft/sol
	name = "\improper SolGov cap"
	desc = "It's a blue ballcap in Solar Confederate Government colors."
	icon_state = "solsoft"
	item_state_slots = list(
		slot_l_hand_str = "lightbluesoft",
		slot_r_hand_str = "lightbluesoft",
		)

/obj/item/clothing/head/soft/sol/expedition
	name = "\improper SifGuard cap"
	desc = "It's a black ballcap bearing a Sif Defense Force crest."
	icon_state = "expeditionsoft"
	item_state_slots = list(
		slot_l_hand_str = "blacksoft",
		slot_r_hand_str = "blacksoft",
		)

/obj/item/clothing/head/soft/sol/fleet
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

/obj/item/clothing/head/utility/marine
	name = "marine utility cover"
	desc = "A grey utility cover bearing the crest of the SCG Marine Corps."
	icon_state = "greyutility"
	armor = list(melee = 10, bullet = 0, laser = 10,energy = 0, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/head/utility/marine/tan
	name = "tan utility cover"
	desc = "A tan utility cover bearing the crest of the SCG Marine Corps."
	icon_state = "tanutility"

/obj/item/clothing/head/utility/marine/green
	name = "green utility cover"
	desc = "A green utility cover bearing the crest of the SCG Marine Corps."
	icon_state = "greenutility"

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

/obj/item/clothing/head/service/marine
	name = "marine wheel cover"
	desc = "A green service uniform cover with an SCG Marine Corps crest."
	icon_state = "greenwheelcap"

/obj/item/clothing/head/service/marine/command
	name = "marine officer's wheel cover"
	desc = "A green service uniform cover with an SCG Marine Corps crest and gold stripe."
	icon_state = "greenwheelcap_com"

/obj/item/clothing/head/service/marine/garrison
	name = "marine garrison cap"
	desc = "A green garrison cap belonging to the SCG Marine Corps."
	icon_state = "greengarrisoncap"

/obj/item/clothing/head/service/marine/garrison/command
	name = "marine officer's garrison cap"
	desc = "A green garrison cap belonging to the SCG Marine Corps. This one has a gold pin."
	icon_state = "greengarrisoncap_com"

/obj/item/clothing/head/service/marine/campaign
	name = "campaign cover"
	desc = "A green campaign cover with an SCG Marine Corps crest. Only found on the heads of Drill Instructors."
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

/obj/item/clothing/head/dress/expedition
	name = "\improper SifGuard dress cap"
	desc = "A peaked grey dress uniform cap belonging to the Sif Defense Force."
	icon_state = "greydresscap"

/obj/item/clothing/head/dress/expedition/command
	name = "\improper SifGuard command dress cap"
	desc = "A peaked grey dress uniform cap belonging to the Sif Defense Force. This one is trimmed in gold."
	icon_state = "greydresscap_com"

/obj/item/clothing/head/dress/fleet
	name = "fleet dress wheel cover"
	desc = "A white dress uniform cover. This one has an SCG Fleet crest."
	icon_state = "whitepeakcap"

/obj/item/clothing/head/dress/fleet/command
	name = "fleet command dress wheel cover"
	desc = "A white dress uniform cover. This one has a gold stripe and an SCG Fleet crest."
	icon_state = "whitepeakcap_com"

/obj/item/clothing/head/dress/marine
	name = "marine dress wheel cover"
	desc = "A white dress uniform cover with an SCG Marine Corps crest."
	icon_state = "whitewheelcap"

/obj/item/clothing/head/dress/marine/command
	name = "marine officer's dress wheel cover"
	desc = "A white dress uniform cover with an SCG Marine Corps crest and gold stripe."
	icon_state = "whitewheelcap_com"

//Berets

/obj/item/clothing/head/beret/sol
	name = "peacekeeper beret"
	desc = "A beret in Solar Confederate Government colors. For peacekeepers that are more inclined towards style than safety."
	icon_state = "beret_lightblue"

/obj/item/clothing/head/beret/sol/gateway
	name = "gateway administration beret"
	desc = "An orange beret denoting service in the Gateway Administration. For personnel that are more inclined towards style than safety."
	icon_state = "beret_orange"

/obj/item/clothing/head/beret/sol/customs
	name = "customs and trade beret"
	desc = "A purple beret denoting service in the Customs and Trade Bureau. For personnel that are more inclined towards style than safety."
	icon_state = "beret_purpleyellow"

/obj/item/clothing/head/beret/sol/orbital
	name = "orbital assault beret"
	desc = "A blue beret denoting orbital assault training. For helljumpers that are more inclined towards style than safety."
	icon_state = "beret_blue"

/obj/item/clothing/head/beret/sol/research
	name = "government research beret"
	desc = "A green beret denoting service in the Bureau of Research. For explorers that are more inclined towards style than safety."
	icon_state = "beret_green"

/obj/item/clothing/head/beret/sol/health
	name = "health service beret"
	desc = "A white beret denoting service in the Interstellar Health Service. For medics that are more inclined towards style than safety."
	icon_state = "beret_white"

/obj/item/clothing/head/beret/sol/expedition
	name = "\improper SifGuard beret"
	desc = "A black beret belonging to the Sif Defense Force. For personnel that are more inclined towards style than safety."
	icon_state = "beret_black"

/obj/item/clothing/head/beret/sol/expedition/security
	name = "\improper SifGuard security beret"
	desc = "A Sif Defense Force beret with a security crest. For personnel that are more inclined towards style than safety."
	icon_state = "beret_black_security"

/obj/item/clothing/head/beret/sol/expedition/medical
	name = "\improper SifGuard medical beret"
	desc = "A Sif Defense Force beret with a medical crest. For personnel that are more inclined towards style than safety."
	icon_state = "beret_black_medical"

/obj/item/clothing/head/beret/sol/expedition/engineering
	name = "\improper SifGuard engineering beret"
	desc = "A Sif Defense Force beret with an engineering crest. For personnel that are more inclined towards style than safety."
	icon_state = "beret_black_engineering"

/obj/item/clothing/head/beret/sol/expedition/supply
	name = "\improper SifGuard supply beret"
	desc = "A Sif Defense Force beret with a supply crest. For personnel that are more inclined towards style than safety."
	icon_state = "beret_black_supply"

/obj/item/clothing/head/beret/sol/expedition/command
	name = "\improper SifGuard command beret"
	desc = "A Sif Defense Force beret with a command crest. For personnel that are more inclined towards style than safety."
	icon_state = "beret_black_command"

/obj/item/clothing/head/beret/sol/fleet
	name = "fleet beret"
	desc = "A navy blue beret belonging to the SCG Fleet. For personnel that are more inclined towards style than safety."
	icon_state = "beret_navy"

/obj/item/clothing/head/beret/sol/fleet/security
	name = "fleet security beret"
	desc = "An SCG Fleet beret with a security crest. For personnel that are more inclined towards style than safety."
	icon_state = "beret_navy_security"

/obj/item/clothing/head/beret/sol/fleet/medical
	name = "fleet medical beret"
	desc = "An SCG Fleet beret with a medical crest. For personnel that are more inclined towards style than safety."
	icon_state = "beret_navy_medical"

/obj/item/clothing/head/beret/sol/fleet/engineering
	name = "fleet engineering beret"
	desc = "An SCG Fleet with an engineering crest. For personnel that are more inclined towards style than safety."
	icon_state = "beret_navy_engineering"

/obj/item/clothing/head/beret/sol/fleet/supply
	name = "fleet supply beret"
	desc = "An SCG Fleet beret with a supply crest. For personnel that are more inclined towards style than safety."
	icon_state = "beret_navy_supply"

/obj/item/clothing/head/beret/sol/fleet/command
	name = "fleet command beret"
	desc = "An SCG Fleet beret with a command crest. For personnel that are more inclined towards style than safety."
	icon_state = "beret_navy_command"
