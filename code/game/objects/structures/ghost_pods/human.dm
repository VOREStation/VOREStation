// Ghost variant.

/obj/structure/ghost_pod/ghost_activated/human
	name = "mysterious cryopod"
	desc = "This is a pod which appears to contain a body."
	description_info = "This contains a body, which may wake at any time. The external controls\
	seem to be malfunctioning."
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "sleeper_1"
	icon_state_opened = "sleeper_0"
	density = FALSE
	ghost_query_type = /datum/ghost_query/stowaway
	anchored = TRUE
	invisibility = 60

	var/occupant_type = "stowaway"

	var/allow_appearance_change = TRUE

	var/make_antag = MODE_STOWAWAY

	var/start_injured = FALSE
	var/spawn_with_emag = TRUE

	var/list/clothing_possibilities

/obj/structure/ghost_pod/ghost_activated/human/Initialize()
	. = ..()

	handle_clothing_setup()

/obj/structure/ghost_pod/ghost_activated/human/proc/handle_clothing_setup()
	clothing_possibilities = list()

	clothing_possibilities |= subtypesof(/obj/item/clothing/under/color)
	clothing_possibilities |= subtypesof(/obj/item/clothing/head/soft)
	clothing_possibilities |= /obj/item/clothing/shoes/black
	clothing_possibilities |= /obj/item/radio/headset

/obj/structure/ghost_pod/ghost_activated/human/create_occupant(var/mob/M)
	..()
	var/turf/T = get_turf(src)
	var/mob/living/carbon/human/H = new(src)

	H.adjustCloneLoss(rand(1,5))
	if(M.mind)
		M.mind.transfer_to(H)
	to_chat(M, "<span class='notice'>You are a [occupant_type]!</span>")
	if(make_antag)
		to_chat(M, "<span class='warning'>Your intent may not be completely beneficial.</span>")
	H.ckey = M.ckey
	visible_message("<span class='warning'>As \the [src] opens, the pipes on \the [src] surge, before it grows dark.</span>")
	log_and_message_admins("successfully opened \a [src] and became a [occupant_type].")

	var/list/uniform_options
	var/list/shoe_options
	var/list/head_options
	var/list/headset_options

	if(clothing_possibilities && clothing_possibilities.len)
		for(var/path in clothing_possibilities)
			if(ispath(path, /obj/item/clothing/under))
				if(!uniform_options)
					uniform_options = list()
				uniform_options |= path
			if(ispath(path, /obj/item/clothing/shoes))
				if(!shoe_options)
					shoe_options = list()
				shoe_options |= path
			if(ispath(path, /obj/item/clothing/head))
				if(!head_options)
					head_options = list()
				head_options |= path
			if(ispath(path, /obj/item/radio/headset))
				if(!headset_options)
					headset_options = list()
				headset_options |= path

	if(uniform_options && uniform_options.len)
		var/newpath = pick(uniform_options)
		var/obj/item/clothing/C = new newpath(H)
		H.equip_to_appropriate_slot(C)

	if(shoe_options && shoe_options.len)
		var/newpath = pick(shoe_options)
		var/obj/item/clothing/C = new newpath(H)
		H.equip_to_appropriate_slot(C)

	if(head_options && head_options.len)
		var/newpath = pick(head_options)
		var/obj/item/clothing/C = new newpath(H)
		H.equip_to_appropriate_slot(C)

	if(headset_options && headset_options.len)
		var/newpath = pick(headset_options)
		var/obj/item/C = new newpath(H)
		H.equip_to_appropriate_slot(C)

	if(spawn_with_emag)
		var/obj/item/card/emag/E = new(H)
		E.name = "broken card"
		E.description_antag = "This is a 'disguised' emag, to make your escape from wherever you happen to be trapped."
		H.equip_to_appropriate_slot(E)

	var/newname = sanitize(input(H, "Your mind feels foggy, and you recall your name might be [H.real_name]. Would you like to change your name?", "Name change") as null|text, MAX_NAME_LEN)
	if (newname)
		H.real_name = newname

	icon_state = icon_state_opened

	H.forceMove(T)

	if(make_antag)
		var/datum/antagonist/antag = all_antag_types[make_antag]
		if(antag)
			if(antag.add_antagonist(H.mind, 1, 1, 0, 1, 1))
				log_admin("\The [src] made [key_name(src)] into a [antag.role_text].")

	if(start_injured) // Done 3 different times to disperse damage.
		H.adjustBruteLoss(rand(1,20))
		H.adjustBruteLoss(rand(1,20))
		H.adjustBruteLoss(rand(1,20))

	if(allow_appearance_change)
		H.change_appearance(APPEARANCE_ALL, H, check_species_whitelist = 1)

//	visible_message("<span class='aliem'>\The [src] [pick("gurgles", "seizes", "clangs")] before releasing \the [H]!</span>")

	qdel(src)

// Manual Variant
// This one lacks the emag option due to the fact someone has to activate it, and they will probably help the person.
/obj/structure/ghost_pod/manual/human
	name = "mysterious cryopod"
	desc = "This is a pod which appears to contain a body."
	description_info = "This contains a body, which may wake at any time. The external controls\
	seem to be functioning, though the warning lights that flash give no solace.."
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "sleeper_1"
	icon_state_opened = "sleeper_0"
	density = TRUE
	ghost_query_type = /datum/ghost_query/lost_passenger
	anchored = FALSE

	var/occupant_type = "lost passenger"

	var/allow_appearance_change = TRUE

	var/make_antag = MODE_STOWAWAY

	var/start_injured = TRUE

	var/list/clothing_possibilities

/obj/structure/ghost_pod/manual/human/Initialize()
	. = ..()

	handle_clothing_setup()

/obj/structure/ghost_pod/manual/human/proc/handle_clothing_setup()
	clothing_possibilities = list()

	clothing_possibilities |= subtypesof(/obj/item/clothing/under/utility)
	clothing_possibilities |= subtypesof(/obj/item/clothing/head/beret)
	clothing_possibilities |= /obj/item/clothing/shoes/black
	clothing_possibilities |= /obj/item/radio/headset

/obj/structure/ghost_pod/manual/human/create_occupant(var/mob/M)
	..()
	var/turf/T = get_turf(src)
	var/mob/living/carbon/human/H = new(src)

	H.adjustCloneLoss(rand(1,5))
	if(M.mind)
		M.mind.transfer_to(H)
	to_chat(M, "<span class='notice'>You are a [occupant_type]!</span>")
	if(make_antag)
		to_chat(M, "<span class='warning'>Your intent may not be completely beneficial.</span>")
	H.ckey = M.ckey
	visible_message("<span class='warning'>As \the [src] opens, the pipes on \the [src] surge, before it grows dark.</span>")
	log_and_message_admins("successfully opened \a [src] and got a [occupant_type].")

	var/list/uniform_options
	var/list/shoe_options
	var/list/head_options
	var/list/headset_options

	if(clothing_possibilities && clothing_possibilities.len)
		for(var/path in clothing_possibilities)
			if(ispath(path, /obj/item/clothing/under))
				if(!uniform_options)
					uniform_options = list()
				uniform_options |= path
			if(ispath(path, /obj/item/clothing/shoes))
				if(!shoe_options)
					shoe_options = list()
				shoe_options |= path
			if(ispath(path, /obj/item/clothing/head))
				if(!head_options)
					head_options = list()
				head_options |= path
			if(ispath(path, /obj/item/radio/headset))
				if(!headset_options)
					headset_options = list()
				headset_options |= path

	if(uniform_options && uniform_options.len)
		var/newpath = pick(uniform_options)
		var/obj/item/clothing/C = new newpath(H)
		H.equip_to_appropriate_slot(C)

	if(shoe_options && shoe_options.len)
		var/newpath = pick(shoe_options)
		var/obj/item/clothing/C = new newpath(H)
		H.equip_to_appropriate_slot(C)

	if(head_options && head_options.len)
		var/newpath = pick(head_options)
		var/obj/item/clothing/C = new newpath(H)
		H.equip_to_appropriate_slot(C)

	if(headset_options && headset_options.len)
		var/newpath = pick(headset_options)
		var/obj/item/C = new newpath(H)
		H.equip_to_appropriate_slot(C)

	var/newname = sanitize(input(H, "Your mind feels foggy, and you recall your name might be [H.real_name]. Would you like to change your name?", "Name change") as null|text, MAX_NAME_LEN)
	if (newname)
		H.real_name = newname

	icon_state = icon_state_opened

	H.forceMove(T)

	if(make_antag)
		var/datum/antagonist/antag = all_antag_types[make_antag]
		if(antag)
			if(antag.add_antagonist(H.mind, 1, 1, 0, 1, 1))
				log_admin("\The [src] made [key_name(src)] into a [antag.role_text].")

	if(start_injured) // Done 3 different times to disperse damage.
		H.adjustBruteLoss(rand(1,20))
		H.adjustBruteLoss(rand(1,20))
		H.adjustBruteLoss(rand(1,20))

	if(allow_appearance_change)
		H.change_appearance(APPEARANCE_ALL, H, check_species_whitelist = 1)

	visible_message("<span class='aliem'>\The [src] [pick("gurgles", "seizes", "clangs")] before releasing \the [H]!</span>")
