//Pill sprites for UIs
/datum/asset/spritesheet/chem_master
	name = "chem_master"

/datum/asset/spritesheet/chem_master/create_spritesheets()
	for(var/i = 1 to 24)
		Insert("pill[i]", 'icons/obj/chemical.dmi', "pill[i]")

	for(var/i = 1 to 4)
		Insert("bottle-[i]", 'icons/obj/chemical.dmi', "bottle-[i]")
