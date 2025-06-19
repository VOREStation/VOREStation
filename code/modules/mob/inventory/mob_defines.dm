/mob
	var/obj/item/storage/s_active = null // Even ghosts can/should be able to peek into boxes on the ground

	var/datum/inventory/inventory = null
	var/inventory_type = /datum/inventory

/mob/living
	var/hand = null
	var/obj/item/tank/internal = null//Human/Monkey

	// inventory_type = /datum/inventory/living


/mob/living/carbon/human
	var/list/worn_clothing = list()	//Contains all CLOTHING items worn
	//Equipment slots
	var/obj/item/shoes = null
	var/obj/item/gloves = null
	var/obj/item/glasses = null
	var/obj/item/head = null
	var/obj/item/wear_id = null

	inventory_type = /datum/inventory/human
