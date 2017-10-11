// Pilots
/var/const/PILOT =(1<<15)
/var/const/access_pilot = 67

/datum/access/pilot
	id = access_pilot
	desc = "Pilot"
	region = ACCESS_REGION_SUPPLY

/datum/job/pilot
	title = "Pilot"
	flag = PILOT
	department = "Cargo"
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the quartermaster and the head of personnel"
	selection_color = "#515151"
	idtype = /obj/item/weapon/card/id/cargo
	access = list(access_pilot, access_cargo, access_mining, access_mining_station)
	minimal_access = list(access_pilot, access_cargo, access_mining, access_mining_station)

/datum/job/pilot/equip(var/mob/living/carbon/human/H, var/alt_title)
	if(!H)
		return 0
	H.equip_to_slot_or_del(new /obj/item/device/radio/headset/headset_cargo/alt(H), slot_l_ear)
	H.equip_to_slot_or_del(new /obj/item/clothing/under/color/black(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), slot_shoes)
	H.equip_to_slot_or_del(new /obj/item/device/pda/cargo(H), slot_belt)
	H.equip_to_slot_or_del(new /obj/item/clothing/glasses/fakesunglasses/aviator(H), slot_glasses)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/toggle/bomber(H), slot_wear_suit)
	H.equip_to_slot_or_del(new /obj/item/clothing/gloves/fingerless(H), slot_gloves)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/flatcap(H), slot_head)
	return 1