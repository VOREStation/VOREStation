/datum/asset/spritesheet/pipes
	name = "pipes"

/datum/asset/spritesheet/pipes/create_spritesheets()
	for(var/each in list('icons/obj/pipe-item.dmi', 'icons/obj/pipes/disposal.dmi'))
		InsertAll("", each, global.alldirs)
