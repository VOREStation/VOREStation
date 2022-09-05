
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
	path = /obj/item/weapon/storage/box/matches

/datum/gear/lighter
<<<<<<< HEAD
	display_name = "cheap lighter"
	path = /obj/item/weapon/flame/lighter

/datum/gear/lighter/zippo
	display_name = "Zippo selection"
	path = /obj/item/weapon/flame/lighter/zippo
=======
	display_name = "lighter, cheap"
	path = /obj/item/flame/lighter

/datum/gear/lighter/zippo
	display_name = "lighter, zippo selection"
	path = /obj/item/flame/lighter/zippo
>>>>>>> db9d6679502... Merge pull request #8695 from Frenjo/loadout-tweaks

/datum/gear/lighter/zippo/New()
	..()
	var/list/zippos = list()
	for(var/zippo in typesof(/obj/item/weapon/flame/lighter/zippo))
		if(zippo in typesof(/obj/item/weapon/flame/lighter/zippo/fluff))	//VOREStation addition
			continue														//VOREStation addition
		var/obj/item/weapon/flame/lighter/zippo/zippo_type = zippo
		zippos[initial(zippo_type.name)] = zippo_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(zippos))

/datum/gear/ashtray
	display_name = "ashtray, plastic"
	path = /obj/item/weapon/material/ashtray/plastic

/datum/gear/cigar
	display_name = "cigar"
	path = /obj/item/clothing/mask/smokable/cigarette/cigar

/datum/gear/cigarettes
	display_name = "cigarette selection"
	path = /obj/item/weapon/storage/fancy/cigarettes

/datum/gear/cigarettes/New()
	..()
	var/list/cigarettes = list()
	for(var/obj/item/weapon/storage/fancy/cigarettes/cigarette_brand as anything in (typesof(/obj/item/weapon/storage/fancy/cigarettes) - typesof(/obj/item/weapon/storage/fancy/cigarettes/killthroat)))
		cigarettes[initial(cigarette_brand.name)] = cigarette_brand
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(cigarettes))
<<<<<<< HEAD
=======

/datum/gear/ecig
	display_name = "electronic cigarette"
	path = /obj/item/clothing/mask/smokable/ecig/util

/datum/gear/ecig/deluxe
	display_name = "electronic cigarette, deluxe"
	path = /obj/item/clothing/mask/smokable/ecig/deluxe
	cost = 2
>>>>>>> db9d6679502... Merge pull request #8695 from Frenjo/loadout-tweaks
