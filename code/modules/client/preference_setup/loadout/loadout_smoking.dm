
/datum/gear/pipe
	display_name = "pipe"
	path = /obj/item/clothing/mask/smokable/pipe

/datum/gear/pipe/New()
	..()
	var/list/pipes = list()
	for(var/pipe_style in typesof(/obj/item/clothing/mask/smokable/pipe))
		var/obj/item/clothing/mask/smokable/pipe/pipe = pipe_style
		pipes[initial(pipe.name)] = pipe
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(pipes))

/datum/gear/matchbook
	display_name = "matchbook"
	path = /obj/item/storage/box/matches

/datum/gear/lighter
	display_name = "cheap lighter"
	path = /obj/item/flame/lighter

/datum/gear/lighter/zippo
	display_name = "Zippo selection"
	path = /obj/item/flame/lighter/zippo

/datum/gear/lighter/zippo/New()
	..()
	var/list/zippos = list()
<<<<<<< HEAD
	for(var/zippo in typesof(/obj/item/weapon/flame/lighter/zippo))
		if(zippo in typesof(/obj/item/weapon/flame/lighter/zippo/fluff))	//VOREStation addition
			continue														//VOREStation addition
		var/obj/item/weapon/flame/lighter/zippo/zippo_type = zippo
=======
	for(var/zippo in typesof(/obj/item/flame/lighter/zippo))
		var/obj/item/flame/lighter/zippo/zippo_type = zippo
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
		zippos[initial(zippo_type.name)] = zippo_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(zippos))

/datum/gear/ashtray
	display_name = "ashtray, plastic"
	path = /obj/item/material/ashtray/plastic

/datum/gear/cigar
	display_name = "cigar"
	path = /obj/item/clothing/mask/smokable/cigarette/cigar

/datum/gear/cigarettes
	display_name = "cigarette selection"
	path = /obj/item/storage/fancy/cigarettes

/datum/gear/cigarettes/New()
	..()
	var/list/cigarettes = list()
<<<<<<< HEAD
	for(var/obj/item/weapon/storage/fancy/cigarettes/cigarette_brand as anything in (typesof(/obj/item/weapon/storage/fancy/cigarettes) - typesof(/obj/item/weapon/storage/fancy/cigarettes/killthroat)))
=======
	for(var/cigarette in (typesof(/obj/item/storage/fancy/cigarettes) - typesof(/obj/item/storage/fancy/cigarettes/killthroat)))
		var/obj/item/storage/fancy/cigarettes/cigarette_brand = cigarette
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
		cigarettes[initial(cigarette_brand.name)] = cigarette_brand
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(cigarettes))
