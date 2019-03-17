/mob/living/carbon/human/dummy
	real_name = "Test Dummy"
	status_flags = GODMODE|CANPUSH
	has_huds = FALSE

/mob/living/carbon/human/dummy/mannequin/New()
	..()
	mob_list -= src
	living_mob_list -= src
	dead_mob_list -= src
	delete_inventory()

/mob/living/carbon/human/skrell/New(var/new_loc)
	h_style = "Skrell Short Tentacles"
	..(new_loc, SPECIES_SKRELL)

/mob/living/carbon/human/tajaran/New(var/new_loc)
	h_style = "Tajaran Ears"
	..(new_loc, SPECIES_TAJ)

/mob/living/carbon/human/unathi/New(var/new_loc)
	h_style = "Unathi Horns"
	..(new_loc, SPECIES_UNATHI)

/mob/living/carbon/human/vox/New(var/new_loc)
	h_style = "Short Vox Quills"
	..(new_loc, SPECIES_VOX)

/mob/living/carbon/human/diona/New(var/new_loc)
	..(new_loc, SPECIES_DIONA)

/mob/living/carbon/human/teshari/New(var/new_loc)
	h_style = "Teshari Default"
	..(new_loc, SPECIES_TESHARI)

/mob/living/carbon/human/promethean/New(var/new_loc)
	..(new_loc, SPECIES_PROMETHEAN)

/mob/living/carbon/human/machine/New(var/new_loc)
	h_style = "blue IPC screen"
	..(new_loc, "Machine")

/mob/living/carbon/human/monkey/New(var/new_loc)
	..(new_loc, SPECIES_MONKEY)

/mob/living/carbon/human/farwa/New(var/new_loc)
	..(new_loc, SPECIES_MONKEY_TAJ)

/mob/living/carbon/human/neaera/New(var/new_loc)
	..(new_loc, SPECIES_MONKEY_SKRELL)

/mob/living/carbon/human/stok/New(var/new_loc)
	..(new_loc, SPECIES_MONKEY_UNATHI)

/mob/living/carbon/human/event1/New(var/new_loc)
	..(new_loc, SPECIES_EVENT1)
