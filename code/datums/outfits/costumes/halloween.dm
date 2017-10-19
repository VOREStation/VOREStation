/decl/hierarchy/outfit/h_masked_killer
	name = "Costume - Masked Killer"
	uniform = /obj/item/clothing/under/overalls
	shoes = /obj/item/clothing/shoes/white
	gloves = /obj/item/clothing/gloves/sterile/latex
	mask = /obj/item/clothing/mask/surgical
	head = /obj/item/clothing/head/welding
	suit = /obj/item/clothing/suit/storage/apron
	r_hand = /obj/item/weapon/material/twohanded/fireaxe/foam

/decl/hierarchy/outfit/masked_killer/post_equip(var/mob/living/carbon/human/H)
	var/victim = get_mannequin(H.ckey)
	for(var/obj/item/carried_item in H.get_equipped_items(TRUE))
		carried_item.add_blood(victim) //Oh yes, there will be blood.. just not blood from the killer because that's odd. //If I knew how to make fake blood, I would

/decl/hierarchy/outfit/h_professional
	name = "Costume - Professional"
	uniform = /obj/item/clothing/under/suit_jacket{ starting_accessories=list(/obj/item/clothing/accessory/wcoat) }
	shoes = /obj/item/clothing/shoes/black
	gloves = /obj/item/clothing/gloves/black
	glasses = /obj/item/clothing/glasses/fakesunglasses
	l_pocket = /obj/item/toy/sword

/decl/hierarchy/outfit/h_professional/post_equip(var/mob/living/carbon/human/H)
	var/obj/item/weapon/storage/briefcase/new_briefcase = new(H)
	for(var/obj/item/briefcase_item in new_briefcase)
		qdel(briefcase_item)
	new_briefcase.contents += new /obj/item/toy/crossbow
	new_briefcase.contents += new /obj/item/weapon/gun/projectile/revolver/capgun
	new_briefcase.contents += new /obj/item/clothing/mask/gas/clown_hat
	H.equip_to_slot_or_del(new_briefcase, slot_l_hand)

/decl/hierarchy/outfit/h_horrorcop
	name = "Costume - Slasher Movie Cop"
	uniform = /obj/item/clothing/under/pcrc{ starting_accessories=list(/obj/item/clothing/accessory/holster) }
	shoes = /obj/item/clothing/shoes/black
	gloves = /obj/item/clothing/gloves/black
	glasses = /obj/item/clothing/glasses/fakesunglasses
	mask = /obj/item/clothing/mask/fakemoustache
	head = /obj/item/clothing/head/beret
	r_hand = /obj/item/weapon/gun/projectile/revolver/capgun

/decl/hierarchy/outfit/h_horrorcop/post_equip(var/mob/living/carbon/human/H)
	var/obj/item/clothing/under/U = H.w_uniform
	if(U.accessories.len)
		for(var/obj/item/clothing/accessory/A in U.accessories)
			if(istype(A, /obj/item/clothing/accessory/holster))
				var/obj/item/clothing/accessory/holster/O = A
				O.holster_verb()

/decl/hierarchy/outfit/h_cowboy
	name = "Costume - Cowboy"
	uniform = /obj/item/clothing/under/pants{ starting_accessories=list(/obj/item/clothing/accessory/holster) }
	shoes = /obj/item/clothing/shoes/boots/cowboy
	head = /obj/item/clothing/head/cowboy_hat
	gloves = /obj/item/clothing/gloves/fingerless
	suit = /obj/item/clothing/accessory/poncho
	r_hand = /obj/item/weapon/gun/projectile/revolver/capgun

/decl/hierarchy/outfit/h_cowboy/post_equip(var/mob/living/carbon/human/H)
	var/obj/item/clothing/under/U = H.w_uniform
	if(U.accessories.len)
		for(var/obj/item/clothing/accessory/A in U.accessories)
			if(istype(A, /obj/item/clothing/accessory/holster))
				var/obj/item/clothing/accessory/holster/O = A
				O.holster_verb()

/decl/hierarchy/outfit/h_lumberjack
	name = "Costume - Lumberjack"
	uniform = /obj/item/clothing/under/pants{ starting_accessories=list(/obj/item/clothing/accessory/sweater/blackneck) }
	shoes = /obj/item/clothing/shoes/boots/workboots
	head = /obj/item/clothing/head/beanie
	gloves = /obj/item/clothing/gloves/fingerless
	suit = /obj/item/clothing/suit/storage/flannel/red
	r_hand = /obj/item/weapon/material/twohanded/fireaxe/foam

/decl/hierarchy/outfit/h_firefighter
	name = "Costume - Firefighter"
	uniform = /obj/item/clothing/under/pants
	shoes = /obj/item/clothing/shoes/boots/workboots
	head = /obj/item/clothing/head/hardhat/red
	gloves = /obj/item/clothing/gloves/black
	suit = /obj/item/clothing/suit/fire/firefighter
	mask = /obj/item/clothing/mask/gas

/decl/hierarchy/outfit/h_highlander
	name = "Costume - Highlander"
	uniform = /obj/item/clothing/under/kilt
	shoes = /obj/item/clothing/shoes/boots/jackboots
	head = /obj/item/clothing/head/beret
	r_hand = /obj/item/weapon/material/sword/foam

/decl/hierarchy/outfit/h_vampire
	name = "Costume - Vampire"
	uniform = /obj/item/clothing/under/suit_jacket/really_black
	shoes = /obj/item/clothing/shoes/dress
	gloves = /obj/item/clothing/gloves/white
	r_hand = /obj/item/weapon/bedsheet/red

/decl/hierarchy/outfit/h_vampire_hunter
	name = "Costume - Vampire Hunter"
	uniform = /obj/item/clothing/under/pants/tan
	suit = /obj/item/clothing/suit/storage/toggle/brown_jacket/sleeveless
	shoes = /obj/item/clothing/shoes/boots/jackboots
	gloves = /obj/item/clothing/gloves/fingerless
	l_pocket = /obj/item/toy/crossbow
	r_pocket = /obj/item/device/flashlight/color/red

/decl/hierarchy/outfit/h_pirate
	name = "Costume - Pirate"
	uniform = /obj/item/clothing/under/pirate
	shoes = /obj/item/clothing/shoes/brown
	head = /obj/item/clothing/head/helmet/space
	suit = /obj/item/clothing/suit/pirate
	glasses = /obj/item/clothing/glasses/eyepatch