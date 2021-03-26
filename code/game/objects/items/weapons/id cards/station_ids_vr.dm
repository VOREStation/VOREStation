/obj/item/weapon/card/id/event
	var/configured = 0
	var/accessset = 0
	initial_sprite_stack = list()
	var/list/title_strings = list()
	var/preset_rank = FALSE

/obj/item/weapon/card/id/event/attack_self(mob/user as mob)
	if(configured == 1)
		return ..()

	if(!preset_rank)
		var/title
		if(user.client.prefs.player_alt_titles[user.job])
			title = user.client.prefs.player_alt_titles[user.job]
		else
			title = user.job
		assignment = title
	user.set_id_info(src)
	if(user.mind && user.mind.initial_account)
		associated_account_number = user.mind.initial_account.account_number
	if(title_strings.len)
		var/tempname = pick(title_strings)
		name = tempname + " ([assignment])"
	else
		name = user.name + "'s ID card" + " ([assignment])"

	configured = 1
	to_chat(user, "<span class='notice'>Card settings set.</span>")

/obj/item/weapon/card/id/event/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/weapon/card/id) && !accessset)
		var/obj/item/weapon/card/id/O = I
		access |= O.access
		to_chat(user, "<span class='notice'>You copy the access from \the [I] to \the [src].</span>")
		user.drop_from_inventory(I)
		qdel(I)
		accessset = 1
	..()

/obj/item/weapon/card/id/event/accessset
	accessset = 1



/obj/item/weapon/card/id/gold/captain/spare/fakespare
	rank = "null"

/obj/item/weapon/card/id/event/accessset/itg
	name = "identification card"
	desc = "A small card designating affiliation with the Ironcrest Transport Group."
	icon = 'icons/obj/card_vr.dmi'
	base_icon = 'icons/obj/card_vr.dmi'
	icon_state = "itg"
	item_state = "itg_id"

/obj/item/weapon/card/id/event/accessset/itg/green
	icon_state = "itg_green"
	item_state = "itg_green_id"

/obj/item/weapon/card/id/event/accessset/itg/red
	icon_state = "itg_red"
	item_state = "itg_red_id"

/obj/item/weapon/card/id/event/accessset/itg/purple
	icon_state = "itg_purple"
	item_state = "itg_purple_id"

/obj/item/weapon/card/id/event/accessset/itg/white
	icon_state = "itg_white"
	item_state = "itg_white_id"

/obj/item/weapon/card/id/event/accessset/itg/orange
	icon_state = "itg_orange"
	item_state = "itg_orange_id"

/obj/item/weapon/card/id/event/accessset/itg/blue
	icon_state = "itg_blue"
	item_state = "itg_blue_id"

/obj/item/weapon/card/id/event/accessset/itg/crew
	name = "\improper ITG Crew ID"
	assignment = "Crew"
	rank = "Crew"
	access = list(777)
	preset_rank = TRUE

/obj/item/weapon/card/id/event/accessset/itg/crew/pilot
	name = "\improper ITG Pilot's ID"
	desc = "An ID card belonging to the Pilot of an ITG vessel. The Pilot's responsibility is primarily to fly the ship. They may also be tasked to assist with cargo movement duties."
	assignment = "Pilot"
	rank = "Pilot"

/obj/item/weapon/card/id/event/accessset/itg/crew/service
	name = "\improper ITG Cook's ID"
	desc = "An ID card belonging to the Cook of an ITG vessel. The Cook's responsibility is primarily to provide sustinence to the crew and passengers. The Cook answers to the Passenger Liason. In the absence of a Passenger Liason, the Cook is also responsible for tending to passenger related care and duties."
	assignment = "Cook"
	rank = "Cook"
	icon_state = "itg_green"
	item_state = "itg_green_id"

/obj/item/weapon/card/id/event/accessset/itg/crew/security
	name = "\improper ITG Security's ID"
	desc = "An ID card belonging to Security of an ITG vessel. Security's responsibility is primarily to protect the ship, cargo, or facility. They may also be tasked to assist with cargo movement duties and rescue operations. ITG Security is almost exclusively defensive. They should not start fights, but they are very capable of finishing them."
	assignment = "Security"
	rank = "Security"
	icon_state = "itg_red"
	item_state = "itg_red_id"

/obj/item/weapon/card/id/event/accessset/itg/crew/research
	name = "\improper ITG Research's ID"
	desc = "An ID card belonging to ITG Research staff. ITG Research staff primarily specializes in starship and starship engine design, and overcoming astronomic phenomena."
	assignment = "Research"
	rank = "Research"
	icon_state = "itg_purple"
	item_state = "itg_purple_id"

/obj/item/weapon/card/id/event/accessset/itg/crew/medical
	name = "\improper ITG Medic's ID"
	desc = "An ID card belonging to the Medic of an ITG vessel. The Medic's responsibility is primarily to treat crew and passenger injuries. They may also be tasked with rescue operations."
	assignment = "Medic"
	rank = "Medic"
	icon_state = "itg_white"
	item_state = "itg_white_id"

/obj/item/weapon/card/id/event/accessset/itg/crew/engineer
	name = "\improper ITG Engineer's ID"
	desc = "An ID card belonging to the Engineer of an ITG vessel. The Engineer's responsibility is primarily to maintain the ship. They may also be tasked to assist with cargo movement duties."
	assignment = "Engineer"
	rank = "Engineer"
	icon_state = "itg_orange"
	item_state = "itg_orange_id"

/obj/item/weapon/card/id/event/accessset/itg/crew/passengerliason
	name = "\improper ITG Passenger Liason's ID"
	desc = "An ID card belonging to the Passenger Liason of an ITG vessel. The Passenger Liason's responsibility is primarily to manage and tend to passenger needs and maintain supplies and facilities for passenger use."
	assignment = "Passenger Liason"
	rank = "Passenger Liason"
	icon_state = "itg_blue"
	item_state = "itg_blue_id"

/obj/item/weapon/card/id/event/accessset/itg/crew/captain
	name = "\improper ITG Captain's ID"
	desc = "An ID card belonging to the Captain of an ITG vessel. The Captain's responsibility is primarily to manage crew to ensure smooth ship operations. Captains often also often pilot the vessel when no dedicated pilot is assigned."
	assignment = "Captain"
	rank = "Captain"
	icon_state = "itg_blue"
	item_state = "itg_blue_id"
	access = list(777, 778)

/obj/item/weapon/card/id/event/altcard
	icon = 'icons/obj/card_alt_vr.dmi'
	base_icon = 'icons/obj/card_alt_vr.dmi'
	icon_state = "id"
	item_state = "id_id"

/obj/item/weapon/card/id/event/altcard/hop
	icon_state = "silver"
	item_state = "silver_id"

/obj/item/weapon/card/id/event/altcard/cap
	icon_state = "cap"
	item_state = "cap_id"

/obj/item/weapon/card/id/event/altcard/centcom
	icon_state = "centcom"
	item_state = "centcom_id"

/obj/item/weapon/card/id/event/altcard/cargo
	icon_state = "cargo"
	item_state = "cargo_id"

/obj/item/weapon/card/id/event/altcard/qm
	icon_state = "cargoGold"
	item_state = "cargoGold_id"

/obj/item/weapon/card/id/event/altcard/miner
	icon_state = "miner"
	item_state = "miner_id"

/obj/item/weapon/card/id/event/altcard/sci
	icon_state = "sci"
	item_state = "sci_id"

/obj/item/weapon/card/id/event/altcard/rd
	icon_state = "sciGold"
	item_state = "sciGold_id"

/obj/item/weapon/card/id/event/altcard/sec
	icon_state = "sec"
	item_state = "sec_id"

/obj/item/weapon/card/id/event/altcard/hos
	icon_state = "secGold"
	item_state = "secGold_id"

/obj/item/weapon/card/id/event/altcard/warden
	icon_state = "warden"
	item_state = "warden_id"

/obj/item/weapon/card/id/event/altcard/eng
	icon_state = "eng"
	item_state = "eng_id"

/obj/item/weapon/card/id/event/altcard/ce
	icon_state = "engGold"
	item_state = "engGold_id"

/obj/item/weapon/card/id/event/altcard/atmos
	icon_state = "atmos"
	item_state = "atmos_id"

/obj/item/weapon/card/id/event/altcard/med
	icon_state = "med"
	item_state = "med_id"

/obj/item/weapon/card/id/event/altcard/cmo
	icon_state = "medGold"
	item_state = "medGold_id"

/obj/item/weapon/card/id/event/altcard/paramed
	icon_state = "paramed"
	item_state = "paramed_id"

/obj/item/weapon/card/id/event/altcard/clown
	icon_state = "clown"
	item_state = "clown_id"

/obj/item/weapon/card/id/event/altcard/mime
	icon_state = "mime"
	item_state = "mime_id"

/obj/item/weapon/card/id/event/altcard/syndie
	icon_state = "syndie"
	item_state = "syndie_id"

/obj/item/weapon/card/id/event/altcard/syndiegold
	icon_state = "syndieGold"
	item_state = "syndieGold_id"

/obj/item/weapon/card/id/event/altcard/green
	icon_state = "green"
	item_state = "green_id"

/obj/item/weapon/card/id/event/altcard/greengold
	icon_state = "greenGold"
	item_state = "greenGold_id"

/obj/item/weapon/card/id/event/altcard/explo
	icon_state = "explo"
	item_state = "explo_id"

/obj/item/weapon/card/id/event/altcard/pf
	icon_state = "exploGold"
	item_state = "exploGold_id"

/obj/item/weapon/card/id/event/altcard/fm
	icon_state = "fieldmed"
	item_state = "fieldmed_id"

/obj/item/weapon/card/id/event/altcard/chaplain
	icon_state = "chaplain"
	item_state = "chaplain_id"

/obj/item/weapon/card/id/event/altcard/nanotrasen
	icon_state = "nanotrasen"
	item_state = "nanotrasen_id"

/obj/item/weapon/card/id/event/altcard/pink
	icon_state = "pink"
	item_state = "pink_id"

/obj/item/weapon/card/id/event/altcard/pinkgold
	icon_state = "pinkGold"
	item_state = "pinkGold_id"

