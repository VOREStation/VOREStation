/decl/hierarchy/outfit/vox
	name = "Vox"
	uniform = /obj/item/clothing/under/vox/vox_robes
	shoes = /obj/item/clothing/shoes/boots/jackboots/toeless
	mask = /obj/item/clothing/mask/gas/vox
	id_slot = slot_wear_id
	hierarchy_type = /decl/hierarchy/outfit/vox
	flags = OUTFIT_HAS_BACKPACK

	var/list/consumables = list(
		/obj/item/reagent_containers/food/drinks/flask/vox/protoslurry,
		/obj/item/reagent_containers/food/drinks/flask/vox/repairgel,
		/obj/item/reagent_containers/food/drinks/flask/vox/riaak
	)

/decl/hierarchy/outfit/vox/equip(mob/living/carbon/human/H, rank, assignment)
	. = ..()
	if(istype(H) && length(consumables))
		for(var/consumable in consumables)
			var/thing = new consumable
			if(!H.equip_to_storage(thing))
				qdel(thing)
				break

/decl/hierarchy/outfit/vox/survivor
	name = "Vox Survivor"
	belt = /obj/item/gun/launcher/spikethrower/small

/decl/hierarchy/outfit/vox/raider
	name = "Vox Raider"
	mask = /obj/item/clothing/mask/gas/swat/vox
	shoes = /obj/item/clothing/shoes/magboots/vox
	l_ear = /obj/item/radio/headset/syndicate
	belt = /obj/item/storage/belt/utility/full
	gloves = /obj/item/clothing/gloves/vox
	r_hand = /obj/item/gun/launcher/spikethrower
	uniform = /obj/item/clothing/under/vox/vox_utility
	id_type = /obj/item/card/id/syndicate
	id_pda_assignment = "Scavenger"

/decl/hierarchy/outfit/vox/merchant
	name = "Vox Merchant"
	suit = /obj/item/clothing/suit/armor/vox_scrap
