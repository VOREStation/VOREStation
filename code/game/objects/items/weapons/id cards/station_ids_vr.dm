/obj/item/weapon/card/id/gold/captain/spare/fakespare
	rank = "null"

/obj/item/weapon/card/id/itg
	name = "identification card"
	desc = "A small card designating affiliation with the Ironcrest Transport Group."
	icon = 'icons/obj/card_vr.dmi'
	icon_state = "itg"
	item_state = "itg_id"

/obj/item/weapon/card/id/itg/green
	icon_state = "itg_green"
	item_state = "itg_green_id"

/obj/item/weapon/card/id/itg/red
	icon_state = "itg_red"
	item_state = "itg_red_id"

/obj/item/weapon/card/id/itg/purple
	icon_state = "itg_purple"
	item_state = "itg_purple_id"

/obj/item/weapon/card/id/itg/white
	icon_state = "itg_white"
	item_state = "itg_white_id"

/obj/item/weapon/card/id/itg/orange
	icon_state = "itg_orange"
	item_state = "itg_orange_id"

/obj/item/weapon/card/id/itg/blue
	icon_state = "itg_blue"
	item_state = "itg_blue_id"

/obj/item/weapon/card/id/itg/event
	name = "\improper ITG Crew ID"
	assignment = "Crew"
	rank = "Crew"
	access = list(777)

/obj/item/weapon/card/id/itg/event/pilot
	name = "\improper ITG Pilot's ID"
	desc = "An ID card belonging to the Pilot of an ITG vessel. The Pilot's responsibility is primarily to fly the ship. They may also be tasked to assist with cargo movement duties."
	assignment = "Pilot"
	rank = "Pilot"

/obj/item/weapon/card/id/itg/event/service
	name = "\improper ITG Cook's ID"
	desc = "An ID card belonging to the Cook of an ITG vessel. The Cook's responsibility is primarily to provide sustinence to the crew and passengers. The Cook answers to the Passenger Liason. In the absence of a Passenger Liason, the Cook is also responsible for tending to passenger related care and duties."
	assignment = "Cook"
	rank = "Cook"
	icon_state = "itg_green"
	item_state = "itg_green_id"

/obj/item/weapon/card/id/itg/event/security
	name = "\improper ITG Security's ID"
	desc = "An ID card belonging to Security of an ITG vessel. Security's responsibility is primarily to protect the ship, cargo, or facility. They may also be tasked to assist with cargo movement duties and rescue operations. ITG Security is almost exclusively defensive. They should not start fights, but they are very capable of finishing them."
	assignment = "Security"
	rank = "Security"
	icon_state = "itg_red"
	item_state = "itg_red_id"

/obj/item/weapon/card/id/itg/event/research
	name = "\improper ITG Research's ID"
	desc = "An ID card belonging to ITG Research staff. ITG Research staff primarily specializes in starship and starship engine design, and overcoming astronomic phenomena."
	assignment = "Research"
	rank = "Research"
	icon_state = "itg_purple"
	item_state = "itg_purple_id"

/obj/item/weapon/card/id/itg/event/medical
	name = "\improper ITG Medic's ID"
	desc = "An ID card belonging to the Medic of an ITG vessel. The Medic's responsibility is primarily to treat crew and passenger injuries. They may also be tasked with rescue operations."
	assignment = "Medic"
	rank = "Medic"
	icon_state = "itg_white"
	item_state = "itg_white_id"

/obj/item/weapon/card/id/itg/event/engineer
	name = "\improper ITG Engineer's ID"
	desc = "An ID card belonging to the Engineer of an ITG vessel. The Engineer's responsibility is primarily to maintain the ship. They may also be tasked to assist with cargo movement duties."
	assignment = "Engineer"
	rank = "Engineer"
	icon_state = "itg_orange"
	item_state = "itg_orange_id"

/obj/item/weapon/card/id/itg/event/passengerliason
	name = "\improper ITG Passenger Liason's ID"
	desc = "An ID card belonging to the Passenger Liason of an ITG vessel. The Passenger Liason's responsibility is primarily to manage and tend to passenger needs and maintain supplies and facilities for passenger use."
	assignment = "Passenger Liason"
	rank = "Passenger Liason"
	icon_state = "itg_blue"
	item_state = "itg_blue_id"

/obj/item/weapon/card/id/itg/event/captain
	name = "\improper ITG Captain's ID"
	desc = "An ID card belonging to the Captain of an ITG vessel. The Captain's responsibility is primarily to manage crew to ensure smooth ship operations. Captains often also often pilot the vessel when no dedicated pilot is assigned."
	assignment = "Captain"
	rank = "Captain"
	icon_state = "itg_blue"
	item_state = "itg_blue_id"
	access = list(777, 778)