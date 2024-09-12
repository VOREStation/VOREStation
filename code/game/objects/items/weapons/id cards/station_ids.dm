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
	var/species = "\[UNSET\]"
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
	M.ImmediateOverlayUpdate()
	var/icon/F = getFlatIcon(M, defdir = SOUTH, no_anim = TRUE)
	front = "'data:image/png;base64,[icon2base64(F)]'"

/mob/proc/set_id_info(var/obj/item/weapon/card/id/id_card)
	id_card.age = 0
	id_card.registered_name		= real_name
	id_card.sex 				= capitalize(gender)
	id_card.species				= SPECIES_HUMAN
	id_card.set_id_photo(src)

	if(dna)
		id_card.blood_type		= dna.b_type
		id_card.dna_hash		= dna.unique_enzymes
		id_card.fingerprint_hash= md5(dna.uni_identity)
	id_card.update_name()

/mob/living/carbon/human/set_id_info(var/obj/item/weapon/card/id/id_card)
	..()
	id_card.age = age
	id_card.species = "[custom_species ? "[custom_species] ([species.name])" : species.name]"
	id_card.sex = capitalize(name_gender())

/obj/item/weapon/card/id/tgui_data(mob/user)
	var/list/data = list()

	data["registered_name"] = registered_name
	data["sex"] = sex
	data["species"] = species
	data["age"] = age
	data["assignment"] = assignment
	data["fingerprint_hash"] = fingerprint_hash
	data["blood_type"] = blood_type
	data["dna_hash"] = dna_hash
	data["photo_front"] = front

	return data

/obj/item/weapon/card/id/attack_self(mob/user as mob)
	user.visible_message("\The [user] shows you: [icon2html(src,viewers(src))] [src.name]. The assignment on the card: [src.assignment]",\
		"You flash your ID card: [icon2html(src, user.client)] [src.name]. The assignment on the card: [src.assignment]")

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

	to_chat(usr, "[icon2html(src, usr.client)] [src.name]: The current assignment on the card is [src.assignment].")
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
	assignment = JOB_SITE_MANAGER
	rank = JOB_SITE_MANAGER

/obj/item/weapon/card/id/gold/captain/spare
	name = "\improper " + JOB_SITE_MANAGER + "'s spare ID"
	desc = "The emergency spare ID for the station's very own Big Cheese."
	icon_state = "gold-id-alternate"
	registered_name = JOB_SITE_MANAGER

/obj/item/weapon/card/id/gold/captain/spare/fakespare
	rank = "null"

/obj/item/weapon/card/id/synthetic
	name = "\improper Synthetic ID"
	desc = "Access module for NanoTrasen Synthetics"
	icon_state = "id-robot"
	item_state = "idgreen"
	assignment = "Synthetic"

/obj/item/weapon/card/id/synthetic/Initialize()
	. = ..()
	access = get_all_station_access().Copy() + access_synth

/obj/item/weapon/card/id/lost
	name = "\improper Unknown ID"
	desc = "Access module for Lost drones"
	icon_state = "id-robot-n"
	assignment = "Lost"

/obj/item/weapon/card/id/lost/Initialize()
	. = ..()
	access += access_lost

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
	rank = JOB_MEDICAL_DOCTOR

/obj/item/weapon/card/id/medical/head
	name = "identification card"
	desc = "A card which represents care and compassion."
	primary_color = rgb(189,237,237)
	secondary_color = rgb(255,223,127)
	assignment = JOB_CHIEF_MEDICAL_OFFICER
	rank = JOB_CHIEF_MEDICAL_OFFICER

/obj/item/weapon/card/id/security
	name = "identification card"
	desc = "A card issued to station security staff."
	icon_state = "security-id"
	primary_color = rgb(189,47,0)
	secondary_color = rgb(223,127,95)
	rank = JOB_SECURITY_OFFICER

/obj/item/weapon/card/id/security/warden
	assignment = JOB_WARDEN
	rank = JOB_WARDEN

/obj/item/weapon/card/id/security/head
	name = "identification card"
	desc = "A card which represents honor and protection."
	primary_color = rgb(189,47,0)
	secondary_color = rgb(255,223,127)
	assignment = JOB_HEAD_OF_SECURITY
	rank = JOB_HEAD_OF_SECURITY

/obj/item/weapon/card/id/engineering
	name = "identification card"
	desc = "A card issued to station engineering staff."
	icon_state = "engineering-id"
	primary_color = rgb(189,94,0)
	secondary_color = rgb(223,159,95)

/obj/item/weapon/card/id/engineering/atmos
	assignment = JOB_ATMOSPHERIC_TECHNICIAN
	rank = JOB_ATMOSPHERIC_TECHNICIAN

/obj/item/weapon/card/id/engineering/head
	name = "identification card"
	desc = "A card which represents creativity and ingenuity."
	primary_color = rgb(189,94,0)
	secondary_color = rgb(255,223,127)
	assignment = JOB_CHIEF_ENGINEER
	rank = JOB_CHIEF_ENGINEER

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
	assignment = JOB_RESEARCH_DIRECTOR
	rank = JOB_RESEARCH_DIRECTOR

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

//Event IDs
/obj/item/weapon/card/id/event
	var/configured = 0
	var/accessset = 0
	initial_sprite_stack = list()
	var/list/title_strings = list()
	var/preset_rank = FALSE

/obj/item/weapon/card/id/event/attack_self(var/mob/user)
	if(configured == 1)
		return ..()

	if(!preset_rank)
		var/title
		if(user.client.prefs.player_alt_titles[user.job])
			title = user.client.prefs.player_alt_titles[user.job]
		else
			title = user.job
		assignment = title
	user.set_id_info(src)
	if(user.mind && user.mind.initial_account)
		associated_account_number = user.mind.initial_account.account_number
	if(title_strings.len)
		var/tempname = pick(title_strings)
		name = tempname + " ([assignment])"
	else
		name = user.name + "'s ID card" + " ([assignment])"

	configured = 1
	to_chat(user, "<span class='notice'>Card settings set.</span>")

/obj/item/weapon/card/id/event/attackby(obj/item/I as obj, var/mob/user)
	if(istype(I, /obj/item/weapon/card/id) && !accessset)
		var/obj/item/weapon/card/id/O = I
		access |= O.GetAccess()
		desc = I.desc
		rank = O.rank
		to_chat(user, "<span class='notice'>You copy the access from \the [I] to \the [src].</span>")
		user.drop_from_inventory(I)
		qdel(I)
		accessset = 1
	..()

/obj/item/weapon/card/id/event/accessset
	accessset = 1

/obj/item/weapon/card/id/event/accessset/itg
	name = "identification card"
	desc = "A small card designating affiliation with the Ironcrest Transport Group."
	icon = 'icons/obj/card_vr.dmi'
	base_icon = 'icons/obj/card_vr.dmi'
	icon_state = "itg"

/obj/item/weapon/card/id/event/accessset/itg/green
	icon_state = "itg_green"

/obj/item/weapon/card/id/event/accessset/itg/red
	icon_state = "itg_red"

/obj/item/weapon/card/id/event/accessset/itg/purple
	icon_state = "itg_purple"

/obj/item/weapon/card/id/event/accessset/itg/white
	icon_state = "itg_white"

/obj/item/weapon/card/id/event/accessset/itg/orange
	icon_state = "itg_orange"

/obj/item/weapon/card/id/event/accessset/itg/blue
	icon_state = "itg_blue"

/obj/item/weapon/card/id/event/accessset/itg/crew
	name = "\improper ITG Crew ID"
	assignment = "Crew"
	rank = "Crew"
	access = list(777)
	preset_rank = TRUE

/obj/item/weapon/card/id/event/accessset/itg/crew/pilot
	name = "\improper ITG Pilot's ID"
	desc = "An ID card belonging to the Pilot of an ITG vessel. The Pilot's responsibility is primarily to fly the ship. They may also be tasked to assist with cargo movement duties."
	assignment = "Pilot"
	rank = "Pilot"

/obj/item/weapon/card/id/event/accessset/itg/crew/service
	name = "\improper ITG Cook's ID"
	desc = "An ID card belonging to the Cook of an ITG vessel. The Cook's responsibility is primarily to provide sustinence to the crew and passengers. The Cook answers to the Passenger Liason. In the absence of a Passenger Liason, the Cook is also responsible for tending to passenger related care and duties."
	assignment = "Cook"
	rank = "Cook"
	icon_state = "itg_green"

/obj/item/weapon/card/id/event/accessset/itg/crew/security
	name = "\improper ITG Security's ID"
	desc = "An ID card belonging to Security of an ITG vessel. Security's responsibility is primarily to protect the ship, cargo, or facility. They may also be tasked to assist with cargo movement duties and rescue operations. ITG Security is almost exclusively defensive. They should not start fights, but they are very capable of finishing them."
	assignment = "Security"
	rank = "Security"
	icon_state = "itg_red"

/obj/item/weapon/card/id/event/accessset/itg/crew/research
	name = "\improper ITG Research's ID"
	desc = "An ID card belonging to ITG Research staff. ITG Research staff primarily specializes in starship and starship engine design, and overcoming astronomic phenomena."
	assignment = "Research"
	rank = "Research"
	icon_state = "itg_purple"

/obj/item/weapon/card/id/event/accessset/itg/crew/medical
	name = "\improper ITG Medic's ID"
	desc = "An ID card belonging to the Medic of an ITG vessel. The Medic's responsibility is primarily to treat crew and passenger injuries. They may also be tasked with rescue operations."
	assignment = "Medic"
	rank = "Medic"
	icon_state = "itg_white"

/obj/item/weapon/card/id/event/accessset/itg/crew/engineer
	name = "\improper ITG " + JOB_ENGINEER + "'s ID"
	desc = "An ID card belonging to the " + JOB_ENGINEER + " of an ITG vessel. The " + JOB_ENGINEER + "'s responsibility is primarily to maintain the ship. They may also be tasked to assist with cargo movement duties."
	assignment = JOB_ENGINEER
	rank = JOB_ENGINEER
	icon_state = "itg_orange"

/obj/item/weapon/card/id/event/accessset/itg/crew/passengerliason
	name = "\improper ITG Passenger Liason's ID"
	desc = "An ID card belonging to the Passenger Liason of an ITG vessel. The Passenger Liason's responsibility is primarily to manage and tend to passenger needs and maintain supplies and facilities for passenger use."
	assignment = "Passenger Liason"
	rank = "Passenger Liason"
	icon_state = "itg_blue"

/obj/item/weapon/card/id/event/accessset/itg/crew/captain
	name = "\improper ITG Captain's ID"
	desc = "An ID card belonging to the Captain of an ITG vessel. The Captain's responsibility is primarily to manage crew to ensure smooth ship operations. Captains often also often pilot the vessel when no dedicated pilot is assigned."
	assignment = "Captain"
	rank = "Captain"
	icon_state = "itg_blue"
	access = list(777, 778)

/obj/item/weapon/card/id/event/altcard
	icon = 'icons/obj/card_alt_vr.dmi'
	base_icon = 'icons/obj/card_alt_vr.dmi'
	icon_state = "id"

/obj/item/weapon/card/id/event/altcard/spare
	icon_state = "spare"

/obj/item/weapon/card/id/event/altcard/clown
	icon_state = "Clown"

/obj/item/weapon/card/id/event/altcard/mime
	icon_state = "Mime"

/obj/item/weapon/card/id/event/altcard/centcom
	icon_state = "CentCom Officer"

/obj/item/weapon/card/id/event/altcard/ert
	icon_state = "Emergency Responder"

/obj/item/weapon/card/id/event/altcard/nt
	icon_state = "nanotrasen"

/obj/item/weapon/card/id/event/altcard/syndiegold
	icon_state = "syndieGold"

/obj/item/weapon/card/id/event/altcard/syndie
	icon_state = "syndie"

/obj/item/weapon/card/id/event/altcard/greengold
	icon_state = "greenGold"

/obj/item/weapon/card/id/event/altcard/pink
	icon_state = "pink"

/obj/item/weapon/card/id/event/altcard/pinkgold
	icon_state = "pinkGold"

/obj/item/weapon/card/id/event/polymorphic
	var/base_icon_state

/obj/item/weapon/card/id/event/polymorphic/digest_act(atom/movable/item_storage = null)
	var/gimmeicon = icon
	. = ..()
	icon = gimmeicon
	icon_state = base_icon_state + "_digested"

/obj/item/weapon/card/id/event/polymorphic/altcard/attack_self(var/mob/user)
	if(configured == 1)
		return ..()
	else
		icon_state = user.job
		base_icon_state = user.job
		return ..()

/obj/item/weapon/card/id/event/polymorphic/altcard
	icon = 'icons/obj/card_alt_vr.dmi'
	base_icon = 'icons/obj/card_alt_vr.dmi'
	icon_state = "blank"
	name = "contractor identification card"
	desc = "An ID card typically used by contractors."

/obj/item/weapon/card/id/event/polymorphic/itg/attack_self(var/mob/user)
	if(!configured)
		var/list/jobs_to_icon = list( //ITG only has a few kinds of icons so we have to group them up!
		"Pilot" = "itg",
		"Visitor" = "itg",
		"Quartermaster" = "itg",
		"Cargo Technician" = "itg",
		JOB_SHAFT_MINER = "itg",
		"Intern" = "itg",
		"Talon Pilot" = "itg",
		"Talon Miner" = "itg",
		"Bartender" = "itg_green",
		"Botanist" = "itg_green",
		"Chef" = "itg_green",
		"Janitor" = "itg_green",
		"Chaplain" = "itg_green",
		"Entertainer" = "itg_green",
		"Janitor" = "itg_green",
		"Librarian" = "itg_green",
		JOB_WARDEN = "itg_red",
		JOB_DETECTIVE = "itg_red",
		JOB_SECURITY_OFFICER = "itg_red",
		"Talon Guard" = "itg_red",
		"Roboticist" = "itg_purple",
		"Scientist" = "itg_purple",
		"Xenobiologist" = "itg_purple",
		"Xenobotanist" = "itg_purple",
		"Pathfinder" = "itg_purple",
		"Explorer" = "itg_purple",
		JOB_CHEMIST = "itg_white",
		JOB_MEDICAL_DOCTOR = "itg_white",
		"Paramedic" = "itg_white",
		"Psychiatrist" = "itg_white",
		"Field Medic" = "itg_white",
		"Talon Doctor" = "itg_white",
		JOB_ATMOSPHERIC_TECHNICIAN = "itg_orange",
		JOB_ENGINEER = "itg_orange",
		"Off-duty Officer" = "itg_red",
		"Off-duty Engineer" = "itg_orange",
		"Off-duty Medic" = "itg_white",
		"Off-duty Scientist" = "itg_purple",
		"Off-duty Cargo" = "itg",
		"Off-duty Explorer" = "itg_purple",
		"Off-duty Worker" = "itg_green"
		)
		var/guess = jobs_to_icon[user.job]

		if(!guess)
			to_chat(user, "<span class='notice'>ITG Cards do not seem to be able to accept the access codes for your ID.</span>")
			return
		else
			icon_state = guess
			base_icon_state = guess
	. = ..()
	name = user.name + "'s ITG ID card" + " ([assignment])"


/obj/item/weapon/card/id/event/polymorphic/itg/attackby(obj/item/I as obj, var/mob/user)
	if(istype(I, /obj/item/weapon/card/id) && !accessset)
		var/obj/item/weapon/card/id/O = I
		var/list/itgdont = list(JOB_SITE_MANAGER, JOB_HEAD_OF_PERSONNEL, JOB_COMMAND_SECRETARY, "Head of Security", JOB_CHIEF_ENGINEER, JOB_CHIEF_MEDICAL_OFFICER, JOB_RESEARCH_DIRECTOR, "Clown", "Mime", "Talon Captain") //If you're in as one of these you probably aren't representing ITG
		if(O.rank in itgdont)
			to_chat(user, "<span class='notice'>ITG Cards do not seem to be able to accept the access codes for your ID.</span>")
			return
	. = ..()
	desc = "A small card designating affiliation with the Ironcrest Transport Group. It has a NanoTrasen insignia and a lot of very small print on the back to do with practices and regulations for contractors to use."


/obj/item/weapon/card/id/event/polymorphic/itg
	icon = 'icons/obj/card_vr.dmi'
	base_icon = 'icons/obj/card_vr.dmi'
	icon_state = "itg"
	name = "\improper ITG identification card"
	desc = "A small card designating affiliation with the Ironcrest Transport Group. It has a NanoTrasen insignia and a lot of very small print on the back to do with practices and regulations for contractors to use."
