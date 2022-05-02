/obj/item/weapon/card/id
	name = "identification card"
	desc = "A card used to provide ID and determine access across the station."
	icon_state = "generic-nt"
	item_state = "card-id"

	sprite_sheets = list(
		SPECIES_TESHARI = 'icons/mob/species/teshari/id.dmi'
		)

	var/access = list()
	var/registered_name = "Unknown" // The name registered_name on the card
	slot_flags = SLOT_ID | SLOT_EARS

	var/age = "\[UNSET\]"
	var/blood_type = "\[UNSET\]"
	var/dna_hash = "\[UNSET\]"
	var/fingerprint_hash = "\[UNSET\]"
	var/sex = "\[UNSET\]"
	var/front

	var/primary_color = rgb(0,0,0) // Obtained by eyedroppering the stripe in the middle of the card
	var/secondary_color = rgb(0,0,0) // Likewise for the oval in the top-left corner

	//alt titles are handled a bit weirdly in order to unobtrusively integrate into existing ID system
	var/assignment = null	//can be alt title or the actual job
	var/rank = null			//actual job
	var/dorm = 0			// determines if this ID has claimed a dorm already

	var/mining_points = 0	// For redeeming at mining equipment vendors
	var/survey_points = 0	// For redeeming at explorer equipment vendors.

/obj/item/weapon/card/id/examine(mob/user)
	. = ..()
	if(in_range(user, src))
		tgui_interact(user) //Not chat related
	else
		. += "<span class='warning'>It is too far away to read.</span>"

/obj/item/weapon/card/id/proc/prevent_tracking()
	return 0

/obj/item/weapon/card/id/tgui_state(mob/user)
	return GLOB.tgui_deep_inventory_state

/obj/item/weapon/card/id/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "IDCard", name)
		ui.open()

/obj/item/weapon/card/id/proc/update_name()
	name = "[src.registered_name]'s ID Card ([src.assignment])"

/obj/item/weapon/card/id/proc/set_id_photo(var/mob/M)
	COMPILE_OVERLAYS(M)
	SSoverlays.queue -= M
	var/icon/F = getFlatIcon(M, defdir = SOUTH, no_anim = TRUE)
	front = "'data:image/png;base64,[icon2base64(F)]'"

/mob/proc/set_id_info(var/obj/item/weapon/card/id/id_card)
	id_card.age = 0
	id_card.registered_name		= real_name
	id_card.sex 				= capitalize(gender)
	id_card.set_id_photo(src)

	if(dna)
		id_card.blood_type		= dna.b_type
		id_card.dna_hash		= dna.unique_enzymes
		id_card.fingerprint_hash= md5(dna.uni_identity)
	id_card.update_name()

<<<<<<< HEAD
/mob/living/carbon/human/set_id_info(var/obj/item/weapon/card/id/id_card)
=======
/mob/living/human/set_id_info(var/obj/item/card/id/id_card)
>>>>>>> 666428014d2... Merge pull request #8546 from Atermonera/surgery_refactor
	..()
	id_card.age = age
	id_card.sex = capitalize(name_gender())

/obj/item/weapon/card/id/tgui_data(mob/user)
	var/list/data = list()

	data["registered_name"] = registered_name
	data["sex"] = sex
	data["age"] = age
	data["assignment"] = assignment
	data["fingerprint_hash"] = fingerprint_hash
	data["blood_type"] = blood_type
	data["dna_hash"] = dna_hash
	data["photo_front"] = front

	return data

/obj/item/weapon/card/id/attack_self(mob/user as mob)
	user.visible_message("\The [user] shows you: [bicon(src)] [src.name]. The assignment on the card: [src.assignment]",\
		"You flash your ID card: [bicon(src)] [src.name]. The assignment on the card: [src.assignment]")

	src.add_fingerprint(user)
	return

/obj/item/weapon/card/id/GetAccess()
	return access

/obj/item/weapon/card/id/GetID()
	return src

/obj/item/weapon/card/id/verb/read()
	set name = "Read ID Card"
	set category = "Object"
	set src in usr

	to_chat(usr, "[bicon(src)] [src.name]: The current assignment on the card is [src.assignment].")
	to_chat(usr, "The blood type on the card is [blood_type].")
	to_chat(usr, "The DNA hash on the card is [dna_hash].")
	to_chat(usr, "The fingerprint hash on the card is [fingerprint_hash].")
	return

/obj/item/weapon/card/id/get_worn_icon_state(var/slot_name)
	if(slot_name == slot_wear_id_str)
		return "id" //Legacy, just how it is. There's only one sprite.

	return ..()

/obj/item/weapon/card/id/Initialize()
	. = ..()
	var/datum/job/J = job_master.GetJob(rank)
	if(J)
		access = J.get_access()

/obj/item/weapon/card/id/silver
	name = "identification card"
	desc = "A silver card which shows honour and dedication."
	icon_state = "silver-id"
	item_state = "silver_id"

/obj/item/weapon/card/id/gold
	name = "identification card"
	desc = "A golden card which shows power and might."
	icon_state = "gold-id"
	item_state = "gold_id"
	preserve_item = 1

/obj/item/weapon/card/id/gold/captain
	assignment = "Site Manager"
	rank = "Site Manager"

/obj/item/weapon/card/id/gold/captain/spare
	name = "\improper Site Manager's spare ID"
	desc = "The spare ID of the High Lord himself."
	icon_state = "gold-id-alternate"
	registered_name = "Site Manager"

/obj/item/weapon/card/id/synthetic
	name = "\improper Synthetic ID"
	desc = "Access module for NanoTrasen Synthetics"
	icon_state = "id-robot"
	item_state = "idgreen"
	assignment = "Synthetic"

/obj/item/weapon/card/id/synthetic/Initialize()
	. = ..()
	access = get_all_station_access().Copy() + access_synth

/obj/item/weapon/card/id/platform
	name = "\improper Support Platform ID"
	desc = "Access module for support platforms."
	icon_state = "id-robot"
	item_state = "tdgreen"
	assignment = "Synthetic"
	access = list(
		access_synth, access_mining, access_mining_station, access_mining_office, access_research,
		access_xenoarch, access_xenobiology, access_external_airlocks, access_robotics, access_tox, 
		access_tox_storage, access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot
	)

/obj/item/weapon/card/id/centcom
	name = "\improper CentCom. ID"
	desc = "An ID straight from Central Command."
	icon_state = "cc-id"
	registered_name = "Central Command"
	assignment = "General"

/obj/item/weapon/card/id/centcom/Initialize()
	. = ..()
	access = get_all_centcom_access().Copy()

/obj/item/weapon/card/id/centcom/station/Initialize()
	. = ..()
	access |= get_all_station_access()

/obj/item/weapon/card/id/centcom/ERT
	name = "\improper Emergency Response Team ID"
	assignment = "Emergency Response Team"
	icon_state = "ert-id"

/obj/item/weapon/card/id/centcom/ERT/Initialize()
	. = ..()
	access |= get_all_station_access()

// Department-flavor IDs
/obj/item/weapon/card/id/medical
	name = "identification card"
	desc = "A card issued to station medical staff."
	icon_state = "medical-id"
	primary_color = rgb(189,237,237)
	secondary_color = rgb(223,255,255)

/obj/item/weapon/card/id/medical/head
	name = "identification card"
	desc = "A card which represents care and compassion."
	primary_color = rgb(189,237,237)
	secondary_color = rgb(255,223,127)
	assignment = "Chief Medical Officer"
	rank = "Chief Medical Officer"

/obj/item/weapon/card/id/security
	name = "identification card"
	desc = "A card issued to station security staff."
	icon_state = "security-id"
	primary_color = rgb(189,47,0)
	secondary_color = rgb(223,127,95)

/obj/item/weapon/card/id/security/warden
	assignment = "Warden"
	rank = "Warden"

/obj/item/weapon/card/id/security/head
	name = "identification card"
	desc = "A card which represents honor and protection."
	primary_color = rgb(189,47,0)
	secondary_color = rgb(255,223,127)
	assignment = "Head of Security"
	rank = "Head of Security"

/obj/item/weapon/card/id/engineering
	name = "identification card"
	desc = "A card issued to station engineering staff."
	icon_state = "engineering-id"
	primary_color = rgb(189,94,0)
	secondary_color = rgb(223,159,95)

/obj/item/weapon/card/id/engineering/atmos
	assignment = "Atmospheric Technician"
	rank = "Atmospheric Technician"

/obj/item/weapon/card/id/engineering/head
	name = "identification card"
	desc = "A card which represents creativity and ingenuity."
	primary_color = rgb(189,94,0)
	secondary_color = rgb(255,223,127)
	assignment = "Chief Engineer"
	rank = "Chief Engineer"

/obj/item/weapon/card/id/science
	name = "identification card"
	desc = "A card issued to station science staff."
	icon_state = "science-id"
	primary_color = rgb(142,47,142)
	secondary_color = rgb(191,127,191)

/obj/item/weapon/card/id/science/head
	name = "identification card"
	desc = "A card which represents knowledge and reasoning."
	primary_color = rgb(142,47,142)
	secondary_color = rgb(255,223,127)
	assignment = "Research Director"
	rank = "Research Director"

/obj/item/weapon/card/id/cargo
	name = "identification card"
	desc = "A card issued to station cargo staff."
	icon_state = "cargo-id"
	primary_color = rgb(142,94,0)
	secondary_color = rgb(191,159,95)

/obj/item/weapon/card/id/cargo/head
	name = "identification card"
	desc = "A card which represents service and planning."
	primary_color = rgb(142,94,0)
	secondary_color = rgb(255,223,127)
	assignment = "Quartermaster"
	rank = "Quartermaster"

/obj/item/weapon/card/id/assistant
	assignment = USELESS_JOB //VOREStation Edit - Visitor not Assistant
	rank = USELESS_JOB //VOREStation Edit - Visitor not Assistant

/obj/item/weapon/card/id/civilian
	name = "identification card"
	desc = "A card issued to station civilian staff."
	icon_state = "civilian-id"
	primary_color = rgb(0,94,142)
	secondary_color = rgb(95,159,191)
	assignment = "Civilian"
	rank = "Assistant"

/obj/item/weapon/card/id/civilian/head //This is not the HoP. There's no position that uses this right now.
	name = "identification card"
	desc = "A card which represents common sense and responsibility."
	primary_color = rgb(0,94,142)
	secondary_color = rgb(255,223,127)

/obj/item/weapon/card/id/external
	name = "identification card"
	desc = "An identification card of some sort. It does not look like it is issued by NT."
	icon_state = "generic"
	primary_color = rgb(142,94,0)
	secondary_color = rgb(191,159,95)
