/mob
	var/obj/item/storage/s_active = null // Even ghosts can/should be able to peek into boxes on the ground

	var/datum/inventory/inventory = null
	var/inventory_type = /datum/inventory

/mob/living
	var/hand = null
	var/obj/item/l_hand = null
	var/obj/item/r_hand = null
	var/obj/item/back = null//Human/Monkey
	var/obj/item/tank/internal = null//Human/Monkey
	var/obj/item/clothing/mask/wear_mask = null//Carbon

	inventory_type = /datum/inventory/living


/mob/living/carbon/human
	var/list/worn_clothing = list()	//Contains all CLOTHING items worn
	//Equipment slots
	var/obj/item/wear_suit = null
	var/obj/item/w_uniform = null
	var/obj/item/shoes = null
	var/obj/item/belt = null
	var/obj/item/gloves = null
	var/obj/item/glasses = null
	var/obj/item/head = null
	var/obj/item/l_ear = null
	var/obj/item/r_ear = null
	var/obj/item/wear_id = null
	var/obj/item/s_store = null

	inventory_type = /datum/inventory/human
