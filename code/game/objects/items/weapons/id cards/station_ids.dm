/obj/item/weapon/card/id
	name = "identification card"
	desc = "A card used to provide ID and determine access across the station."
	icon_state = "id"
	item_state = "card-id"

	sprite_sheets = list(
		"Teshari" = 'icons/mob/species/seromi/id.dmi'
		)

	var/access = list()
	var/registered_name = "Unknown" // The name registered_name on the card
	slot_flags = SLOT_ID | SLOT_EARS

	var/age = "\[UNSET\]"
	var/blood_type = "\[UNSET\]"
	var/dna_hash = "\[UNSET\]"
	var/fingerprint_hash = "\[UNSET\]"
	var/sex = "\[UNSET\]"
	var/icon/front
	var/icon/side

	var/primary_color = rgb(0,0,0) // Obtained by eyedroppering the stripe in the middle of the card
	var/secondary_color = rgb(0,0,0) // Likewise for the oval in the top-left corner

	//alt titles are handled a bit weirdly in order to unobtrusively integrate into existing ID system
	var/assignment = null	//can be alt title or the actual job
	var/rank = null			//actual job
	var/dorm = 0			// determines if this ID has claimed a dorm already

/obj/item/weapon/card/id/examine(mob/user)
	set src in oview(1)
	if(in_range(usr, src))
		show(usr)
		usr << desc
	else
		usr << "<span class='warning'>It is too far away.</span>"

/obj/item/weapon/card/id/proc/prevent_tracking()
	return 0

/obj/item/weapon/card/id/proc/show(mob/user as mob)
	if(front && side)
		user << browse_rsc(front, "front.png")
		user << browse_rsc(side, "side.png")
	var/datum/browser/popup = new(user, "idcard", name, 600, 250)
	popup.set_content(dat())
	popup.set_title_image(usr.browse_rsc_icon(src.icon, src.icon_state))
	popup.open()
	return

/obj/item/weapon/card/id/proc/update_name()
	name = "[src.registered_name]'s ID Card ([src.assignment])"

/obj/item/weapon/card/id/proc/set_id_photo(var/mob/M)
	front = getFlatIcon(M, SOUTH, always_use_defdir = 1)
	side = getFlatIcon(M, WEST, always_use_defdir = 1)

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

/mob/living/carbon/human/set_id_info(var/obj/item/weapon/card/id/id_card)
	..()
	id_card.age = age

/obj/item/weapon/card/id/proc/dat()
	var/dat = ("<table><tr><td>")
	dat += text("Name: []</A><BR>", registered_name)
	dat += text("Sex: []</A><BR>\n", sex)
	dat += text("Age: []</A><BR>\n", age)
	dat += text("Rank: []</A><BR>\n", assignment)
	dat += text("Fingerprint: []</A><BR>\n", fingerprint_hash)
	dat += text("Blood Type: []<BR>\n", blood_type)
	dat += text("DNA Hash: []<BR><BR>\n", dna_hash)
	if(front && side)
		dat +="<td align = center valign = top>Photo:<br><img src=front.png height=80 width=80 border=4><img src=side.png height=80 width=80 border=4></td>"
	dat += "</tr></table>"
	return dat

/obj/item/weapon/card/id/attack_self(mob/user as mob)
	user.visible_message("\The [user] shows you: \icon[src] [src.name]. The assignment on the card: [src.assignment]",\
		"You flash your ID card: \icon[src] [src.name]. The assignment on the card: [src.assignment]")

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

	usr << text("\icon[] []: The current assignment on the card is [].", src, src.name, src.assignment)
	usr << "The blood type on the card is [blood_type]."
	usr << "The DNA hash on the card is [dna_hash]."
	usr << "The fingerprint hash on the card is [fingerprint_hash]."
	return

/obj/item/weapon/card/id/silver
	name = "identification card"
	desc = "A silver card which shows honour and dedication."
	icon_state = "silver"
	item_state = "silver_id"

/obj/item/weapon/card/id/silver/secretary/New()
	..()
	assignment = "Command Secretary"
	rank = "Command Secretary"
	access |= get_access() //VOREStation Edit. All "access" lines have been edited to make them follow the config.

/obj/item/weapon/card/id/silver/hop/New()
	..()
	assignment = "Head of Personnel"
	rank = "Head of Personnel"
	access |= get_access()
/obj/item/weapon/card/id/gold
	name = "identification card"
	desc = "A golden card which shows power and might."
	icon_state = "gold"
	item_state = "gold_id"

/obj/item/weapon/card/id/gold/captain/New()
	assignment = "Colony Director"
	rank = "Colony Director"
	access = get_all_station_access()
	..()

/obj/item/weapon/card/id/captains_spare
	name = "colony director's spare ID"
	desc = "The spare ID of the High Lord himself."
	icon_state = "gold"
	item_state = "gold_id"
	registered_name = "Colony Director"
	assignment = "Colony Director"

/obj/item/weapon/card/id/captains_spare/New()
	access = get_all_station_access()
	..()

/obj/item/weapon/card/id/synthetic
	name = "\improper Synthetic ID"
	desc = "Access module for NanoTrasen Synthetics"
	icon_state = "id-robot"
	item_state = "tdgreen"
	assignment = "Synthetic"

/obj/item/weapon/card/id/synthetic/New()
	access = get_all_station_access() + access_synth
	..()

/obj/item/weapon/card/id/centcom
	name = "\improper CentCom. ID"
	desc = "An ID straight from Central Command."
	icon_state = "centcom"
	registered_name = "Central Command"
	assignment = "General"

/obj/item/weapon/card/id/centcom/New()
	access = get_all_centcom_access()
	..()

/obj/item/weapon/card/id/centcom/station/New()
	..()
	access |= get_all_station_access()

/obj/item/weapon/card/id/centcom/ERT
	name = "\improper Emergency Response Team ID"
	assignment = "Emergency Response Team"

/obj/item/weapon/card/id/centcom/ERT/New()
	..()
	access |= get_all_station_access()

// Department-flavor IDs
/obj/item/weapon/card/id/medical
	name = "identification card"
	desc = "A card issued to station medical staff."
	icon_state = "med"
	primary_color = rgb(189,237,237)
	secondary_color = rgb(223,255,255)
	access = get_access()

/obj/item/weapon/card/id/medical/doctor/New()
	..()
	assignment = "Medical Doctor"
	rank = "Medical Doctor"
	access |= get_access()

/obj/item/weapon/card/id/medical/chemist/New()
	..()
	assignment = "Chemist"
	rank = "Chemist"
	access |= get_access()

/obj/item/weapon/card/id/medical/geneticist/New()
	..()
	assignment = "Geneticist"
	rank = "Geneticist"
	access |= get_access()

/obj/item/weapon/card/id/medical/psychiatrist/New()
	..()
	assignment = "Psychiatrist"
	rank = "Psychiatrist"
	access |= get_access()

/obj/item/weapon/card/id/medical/paramedic/New()
	..()
	assignment = "Paramedic"
	rank = "Paramedic"
	access |= get_access()

/obj/item/weapon/card/id/medical/head
	name = "identification card"
	desc = "A card which represents care and compassion."
	assignment = "Chief Medical Officer"
	rank = "Chief Medical Officer"
	icon_state = "medGold"
	primary_color = rgb(189,237,237)
	secondary_color = rgb(255,223,127)

/obj/item/weapon/card/id/medical/head/New()
	access |= get_access()

/obj/item/weapon/card/id/security
	name = "identification card"
	desc = "A card issued to station security staff."
	icon_state = "sec"
	primary_color = rgb(189,47,0)
	secondary_color = rgb(223,127,95)
	access = get_access()

/obj/item/weapon/card/id/security/officer/New()
	..()
	assignment = "Assignment"
	rank = "Security Officer"
	access |= get_access()

/obj/item/weapon/card/id/security/detective/New()
	..()
	assignment = "Detective"
	rank = "Detective"
	access |= get_access()

/obj/item/weapon/card/id/security/warden/New()
	..()
	assignment = "Warden"
	rank = "Warden"
	access |= get_access()

/obj/item/weapon/card/id/security/head
	name = "identification card"
	desc = "A card which represents honor and protection."
	icon_state = "secGold"
	assignment = "Head of Security"
	rank = "Head of Security"
	primary_color = rgb(189,47,0)
	secondary_color = rgb(255,223,127)

/obj/item/weapon/card/id/security/head/New()
	..()
	access |= get_access()

/obj/item/weapon/card/id/engineering
	name = "identification card"
	desc = "A card issued to station engineering staff."
	icon_state = "eng"
	primary_color = rgb(189,94,0)
	secondary_color = rgb(223,159,95)
	access = get_access()

/obj/item/weapon/card/id/engineering/engineer/New()
	..()
	assignment = "Station Engineer"
	rank = "Station Engineer"
	access |= get_access()

/obj/item/weapon/card/id/engineering/atmos/New()
	..()
	assignment = "Atmospheric Technician"
	rank = "Atmospheric Technician"
	access |= get_access()

/obj/item/weapon/card/id/engineering/head
	name = "identification card"
	desc = "A card which represents creativity and ingenuity."
	icon_state = "engGold"
	assignment = "Chief Engineer"
	rank = "Chief Engineer"
	primary_color = rgb(189,94,0)
	secondary_color = rgb(255,223,127)

/obj/item/weapon/card/id/engineering/head/New()
	..()
	access |= get_access()

/obj/item/weapon/card/id/science
	name = "identification card"
	desc = "A card issued to station science staff."
	icon_state = "sci"
	primary_color = rgb(142,47,142)
	secondary_color = rgb(191,127,191)
	access = get_access()

/obj/item/weapon/card/id/science/scientist/New()
	..()
	assignment = "Scientist"
	rank = "Scientist"
	access |= get_access()

/obj/item/weapon/card/id/science/xenobiologist/New()
	..()
	assignment = "Xenobiologist"
	rank = "Xenobiologist"
	access |= get_access()

/obj/item/weapon/card/id/science/roboticist/New()
	..()
	assignment = "Roboticist"
	rank = "Roboticist"
	access |= get_access()

/obj/item/weapon/card/id/science/head
	name = "identification card"
	desc = "A card which represents knowledge and reasoning."
	icon_state = "sciGold"
	assignment = "Research Director"
	rank = "Research Director"
	primary_color = rgb(142,47,142)
	secondary_color = rgb(255,223,127)

/obj/item/weapon/card/id/science/head/New()
	..()
	access |= get_access()

/obj/item/weapon/card/id/cargo
	name = "identification card"
	desc = "A card issued to station cargo staff."
	icon_state = "cargo"
	primary_color = rgb(142,94,0)
	secondary_color = rgb(191,159,95)
	access = get_access()

/obj/item/weapon/card/id/cargo/cargo_tech/New()
	..()
	assignment = "Cargo Technician"
	rank = "Cargo Technician"
	access |= get_access()

/obj/item/weapon/card/id/cargo/mining/New()
	..()
	assignment = "Shaft Miner"
	rank = "Shaft Miner"
	access |= get_access()

/obj/item/weapon/card/id/cargo/head
	name = "identification card"
	desc = "A card which represents service and planning."
	icon_state = "cargoGold"
	assignment = "Quartermaster"
	rank = "Quartermaster"
	primary_color = rgb(142,94,0)
	secondary_color = rgb(255,223,127)

/obj/item/weapon/card/id/cargo/head/New()
	..()
	access |= list(access_maint_tunnels, access_cargo, access_cargo_bot, access_qm, access_mining, access_mining_station)

/obj/item/weapon/card/id/assistant
	name = "identification card"
//	assignment = "Assistant"
//	rank = "Assistant"
	access = get_access()

/obj/item/weapon/card/id/civilian
	name = "identification card"
	desc = "A card issued to station civilian staff."
	icon_state = "civ"
	assignment = "Civilian"
	rank = "Assistant"
	primary_color = rgb(0,94,142)
	secondary_color = rgb(95,159,191)
	access = list()

/obj/item/weapon/card/id/civilian/bartender/New()
	..()
	assignment = "Bartender"
	rank = "Bartender"
	access |= get_access()

/obj/item/weapon/card/id/civilian/botanist/New()
	..()
	assignment = "Gardener"
	rank = "Gardener"
	access |= get_access()

/obj/item/weapon/card/id/civilian/chaplain/New()
	..()
	assignment = "Chaplain"
	rank = "Chaplain"
	access |= get_access()

/obj/item/weapon/card/id/civilian/chef/New()
	..()
	assignment = "Chef"
	rank = "Chef"
	access |= get_access()

/obj/item/weapon/card/id/civilian/internal_affairs_agent/New()
	..()
	assignment = "Internal Affairs Agent"
	rank = "Internal Affairs Agent"
	access |= get_access()

/obj/item/weapon/card/id/civilian/janitor/New()
	..()
	assignment = "Janitor"
	rank = "Janitor"
	access |= get_access()

/obj/item/weapon/card/id/civilian/librarian/New()
	..()
	assignment = "Librarian"
	rank = "Librarian"
	access |= get_access()

/obj/item/weapon/card/id/civilian/head //This is not the HoP. There's no position that uses this right now.
	name = "identification card"
	desc = "A card which represents common sense and responsibility."
	icon_state = "civGold"
	primary_color = rgb(0,94,142)
	secondary_color = rgb(255,223,127)

/obj/item/weapon/card/id/external
	name = "identification card"
	desc = "An identification card of some sort. It does not look like it is issued by NT."
	icon_state = "permit"
	primary_color = rgb(142,94,0)
	secondary_color = rgb(191,159,95)
