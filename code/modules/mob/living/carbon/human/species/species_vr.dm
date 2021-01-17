/datum/species
	//This is used in character setup preview generation (prefences_setup.dm) and human mob
	//rendering (update_icons.dm)
	var/color_mult = 0

	//This is for overriding tail rendering with a specific icon in icobase, for static
	//tails only, since tails would wag when dead if you used this
	var/icobase_tail = 0

	//This is so that if a race is using the chimera revive they can't use it more than once.
	//Shouldn't really be seen in play too often, but it's case an admin event happens and they give a non chimera the chimera revive. Only one person can use the chimera revive at a time per race.
	//var/reviving = 0 //commented out 'cause moved to mob
	holder_type = /obj/item/weapon/holder/micro //This allows you to pick up crew
	min_age = 18
	descriptors = list()
	var/wing_hair
	var/wing
	var/wing_animation
	var/icobase_wing
	var/wikilink = null //link to wiki page for species
	var/icon_height = 32
	var/agility = 20 //prob() to do agile things

	var/list/traits = list()

/datum/species/proc/update_attack_types()
	unarmed_attacks = list()
	for(var/u_type in unarmed_types)
		unarmed_attacks += new u_type()

/datum/species/proc/give_numbing_bite() //Holy SHIT this is hacky, but it works. Updating a mob's attacks mid game is insane.
	unarmed_attacks = list()
	unarmed_types += /datum/unarmed_attack/bite/sharp/numbing
	for(var/u_type in unarmed_types)
		unarmed_attacks += new u_type()

/datum/species/create_organs(var/mob/living/carbon/human/H)
	if(H.nif)
		var/type = H.nif.type
		var/durability = H.nif.durability
		var/list/nifsofts = H.nif.nifsofts
		var/list/nif_savedata = H.nif.save_data.Copy()
		..()

		var/obj/item/device/nif/nif = new type(H,durability,nif_savedata)
		nif.nifsofts = nifsofts
	else
		..()
/datum/species/proc/produceCopy(var/datum/species/to_copy,var/list/traits,var/mob/living/carbon/human/H)
	ASSERT(to_copy)
	ASSERT(istype(H))

	if(ispath(to_copy))
		to_copy = "[initial(to_copy.name)]"
	if(istext(to_copy))
		to_copy = GLOB.all_species[to_copy]

	var/datum/species/new_copy = new to_copy.type()

	new_copy.traits = traits

	//If you had traits, apply them
	if(new_copy.traits)
		for(var/trait in new_copy.traits)
			var/datum/trait/T = all_traits[trait]
			T.apply(new_copy,H)

	//Set up a mob
	H.species = new_copy

	if(H.dna)
		H.dna.ready_dna(H)

	return new_copy