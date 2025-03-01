/mob/living/carbon/human/dummy
	real_name = "Test Dummy"
	status_flags = GODMODE|CANPUSH
	has_huds = FALSE
	blocks_emissive = FALSE

/mob/living/carbon/human/dummy/Initialize()
	. = ..()
	mob_list -= src
	living_mob_list -= src
	dead_mob_list -= src
	human_mob_list -= src

/mob/living/carbon/human/dummy/Life()
	mob_list -= src
	living_mob_list -= src
	dead_mob_list -= src
	human_mob_list -= src
	return

/mob/living/carbon/human/dummy/mannequin/Initialize()
	. = ..()
	delete_inventory()

/mob/living/carbon/human/dummy/mannequin/autoequip
	icon = 'icons/mob/human_races/r_human.dmi'
	icon_state = "preview"
	var/autorotate = TRUE

/mob/living/carbon/human/dummy/mannequin/autoequip/Initialize()
	icon = null
	icon_state = ""
	. = ..()

	dress_up()
	if(autorotate)
		turntable()

/mob/living/carbon/human/dummy/mannequin/autoequip/proc/dress_up()
	set waitfor = FALSE

	for(var/obj/item/I in loc)
		if(istype(I, /obj/item/clothing))
			var/obj/item/clothing/C = I
			C.species_restricted = null
		equip_to_appropriate_slot(I)

	if(istype(back, /obj/item/rig))
		var/obj/item/rig/rig = back
		rig.toggle_seals(src)

/mob/living/carbon/human/dummy/mannequin/autoequip/proc/turntable()
	set waitfor = FALSE

	while(TRUE)
		set_dir(SOUTH)
		sleep(2 SECONDS)
		set_dir(EAST)
		sleep(2 SECONDS)
		set_dir(NORTH)
		sleep(2 SECONDS)
		set_dir(WEST)
		sleep(2 SECONDS)

/mob/living/carbon/human/dummy/mannequin/autoequip/tajaran
	icon = 'icons/mob/human_races/r_tajaran.dmi'
/mob/living/carbon/human/dummy/mannequin/autoequip/tajaran/Initialize(mapload)
	h_style = "Tajaran Ears"
	return ..(mapload, SPECIES_TAJARAN)

/mob/living/carbon/human/dummy/mannequin/autoequip/unathi
	icon = 'icons/mob/human_races/r_lizard.dmi'
/mob/living/carbon/human/dummy/mannequin/autoequip/unathi/Initialize(mapload)
	h_style = "Unathi Horns"
	return ..(mapload, SPECIES_UNATHI)

/mob/living/carbon/human/dummy/mannequin/autoequip/sergal
	icon = 'icons/mob/human_races/r_sergal.dmi'
/mob/living/carbon/human/dummy/mannequin/autoequip/sergal/Initialize(mapload)
	h_style = "Sergal Ears"
	return ..(mapload, SPECIES_SERGAL)

/mob/living/carbon/human/dummy/mannequin/autoequip/vulpkanin
	icon = 'icons/mob/human_races/r_vulpkanin.dmi'
/mob/living/carbon/human/dummy/mannequin/autoequip/vulpkanin/Initialize(mapload)
	h_style = "vulpkanin, dual-color"
	return ..(mapload, SPECIES_VULPKANIN)

/mob/living/carbon/human/dummy/mannequin/autoequip/teshari
	icon = 'icons/mob/human_races/r_teshari.dmi'
/mob/living/carbon/human/dummy/mannequin/autoequip/teshari/Initialize(mapload)
	//h_style = "teshari, dual-color"
	return ..(mapload, SPECIES_TESHARI)

/mob/living/carbon/human/skrell/Initialize(mapload)
	h_style = "Skrell Short Tentacles"
	return ..(mapload, SPECIES_SKRELL)

/mob/living/carbon/human/tajaran/Initialize(mapload)
	h_style = "Tajaran Ears"
	return ..(mapload, SPECIES_TAJARAN)

/mob/living/carbon/human/unathi/Initialize(mapload)
	h_style = "Unathi Horns"
	return ..(mapload, SPECIES_UNATHI)

/mob/living/carbon/human/vox/Initialize(mapload)
	h_style = "Short Vox Quills"
	return ..(mapload, SPECIES_VOX)

/mob/living/carbon/human/diona/Initialize(mapload)
	return ..(mapload, SPECIES_DIONA)

/mob/living/carbon/human/teshari/Initialize(mapload)
	h_style = "Teshari Default"
	return ..(mapload, SPECIES_TESHARI)

/mob/living/carbon/human/promethean/Initialize(mapload)
	return ..(mapload, SPECIES_PROMETHEAN)

/mob/living/carbon/human/zaddat/Initialize(mapload)
	return ..(mapload, SPECIES_ZADDAT)

/mob/living/carbon/human/monkey
	low_sorting_priority = TRUE

/mob/living/carbon/human/monkey/Initialize(mapload)
	. = ..(mapload, SPECIES_MONKEY)
	species.produceCopy(species.traits.Copy(),src,null,FALSE)

/mob/living/carbon/human/farwa
	low_sorting_priority = TRUE

/mob/living/carbon/human/farwa/Initialize(mapload)
	. = .. (mapload, SPECIES_MONKEY_TAJ)
	species.produceCopy(species.traits.Copy(),src,null,FALSE)

/mob/living/carbon/human/neaera
	low_sorting_priority = TRUE

/mob/living/carbon/human/neaera/Initialize(mapload)
	. = ..(mapload, SPECIES_MONKEY_SKRELL)
	species.produceCopy(species.traits.Copy(),src,null,FALSE)

/mob/living/carbon/human/stok
	low_sorting_priority = TRUE

/mob/living/carbon/human/stok/Initialize(mapload)
	. = ..(mapload, SPECIES_MONKEY_UNATHI)
	species.produceCopy(species.traits.Copy(),src,null,FALSE)
