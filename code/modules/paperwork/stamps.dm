/obj/item/weapon/stamp
	name = "rubber stamp"
	desc = "A rubber stamp for stamping important documents."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "stamp-qm"
	item_state = "stamp"
	throwforce = 0
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_HOLSTER
	throw_speed = 7
	throw_range = 15
	matter = list(MAT_STEEL = 60)
	pressure_resistance = 2
	attack_verb = list("stamped")
	drop_sound = 'sound/items/drop/device.ogg'
	pickup_sound = 'sound/items/pickup/device.ogg'
	var/stamptext = null

<<<<<<< HEAD
/obj/item/weapon/stamp/captain
	name = "site manager's rubber stamp"
=======
	/// The authority this stamp represents. Used where the full object name would be inappropriate.
	var/authority_name = ""

	/// Any trailing posessiveness for authority_name.
	var/authority_suffix = ""


/obj/item/stamp/Initialize()
	. = ..()
	GenerateName()


/obj/item/stamp/proc/GenerateName()
	if (!authority_name)
		name = initial(name)
		return
	var/first_char = copytext_char(authority_name, 1, 2)
	if (lowertext(first_char) != first_char)
		name = "\improper [authority_name][authority_suffix] [initial(name)]"
	else
		name = "[authority_name][authority_suffix] [initial(name)]"


/obj/item/stamp/captain
>>>>>>> 11ff35ddb7e... Merge pull request #8812 from Spookerton/spkrtn/cng/pushing-the-envelope
	icon_state = "stamp-cap"
	authority_name = "site manager"
	authority_suffix = "'s"


<<<<<<< HEAD
/obj/item/weapon/stamp/hop
	name = "head of personnel's rubber stamp"
=======
/obj/item/stamp/hop
>>>>>>> 11ff35ddb7e... Merge pull request #8812 from Spookerton/spkrtn/cng/pushing-the-envelope
	icon_state = "stamp-hop"
	authority_name = "head of personnel"
	authority_suffix = "'s"


<<<<<<< HEAD
/obj/item/weapon/stamp/hos
	name = "head of security's rubber stamp"
=======
/obj/item/stamp/hos
>>>>>>> 11ff35ddb7e... Merge pull request #8812 from Spookerton/spkrtn/cng/pushing-the-envelope
	icon_state = "stamp-hos"
	authority_name = "head of security"
	authority_suffix = "'s"


<<<<<<< HEAD
/obj/item/weapon/stamp/ward
	name = "warden's rubber stamp"
=======
/obj/item/stamp/ward
>>>>>>> 11ff35ddb7e... Merge pull request #8812 from Spookerton/spkrtn/cng/pushing-the-envelope
	icon_state = "stamp-ward"
	authority_name = "warden"
	authority_suffix = "'s"


<<<<<<< HEAD
/obj/item/weapon/stamp/ce
	name = "chief engineer's rubber stamp"
=======
/obj/item/stamp/ce
>>>>>>> 11ff35ddb7e... Merge pull request #8812 from Spookerton/spkrtn/cng/pushing-the-envelope
	icon_state = "stamp-ce"
	authority_name = "chief engineer"
	authority_suffix = "'s"


<<<<<<< HEAD
/obj/item/weapon/stamp/rd
	name = "research director's rubber stamp"
=======
/obj/item/stamp/rd
>>>>>>> 11ff35ddb7e... Merge pull request #8812 from Spookerton/spkrtn/cng/pushing-the-envelope
	icon_state = "stamp-rd"
	authority_name = "research director"
	authority_suffix = "'s"


<<<<<<< HEAD
/obj/item/weapon/stamp/cmo
	name = "chief medical officer's rubber stamp"
=======
/obj/item/stamp/cmo
>>>>>>> 11ff35ddb7e... Merge pull request #8812 from Spookerton/spkrtn/cng/pushing-the-envelope
	icon_state = "stamp-cmo"
	authority_name = "chief medical officer"
	authority_suffix = "'s"


<<<<<<< HEAD
/obj/item/weapon/stamp/denied
	name = "\improper DENIED rubber stamp"
=======
/obj/item/stamp/denied
>>>>>>> 11ff35ddb7e... Merge pull request #8812 from Spookerton/spkrtn/cng/pushing-the-envelope
	icon_state = "stamp-deny"
	attack_verb = list("DENIED")
	authority_name = "DENIED"


<<<<<<< HEAD
/obj/item/weapon/stamp/accepted
	name = "\improper ACCEPTED rubber stamp"
=======
/obj/item/stamp/accepted
>>>>>>> 11ff35ddb7e... Merge pull request #8812 from Spookerton/spkrtn/cng/pushing-the-envelope
	icon_state = "stamp-ok"
	attack_verb = list("ACCEPTED")
	authority_name = "ACCEPTED"


<<<<<<< HEAD
/obj/item/weapon/stamp/clown
	name = "clown's rubber stamp"
=======
/obj/item/stamp/clown
>>>>>>> 11ff35ddb7e... Merge pull request #8812 from Spookerton/spkrtn/cng/pushing-the-envelope
	icon_state = "stamp-clown"
	authority_name = "clown"
	authority_suffix = "'s"


<<<<<<< HEAD
/obj/item/weapon/stamp/internalaffairs
	name = "internal affairs rubber stamp"
=======
/obj/item/stamp/internalaffairs
>>>>>>> 11ff35ddb7e... Merge pull request #8812 from Spookerton/spkrtn/cng/pushing-the-envelope
	icon_state = "stamp-intaff"
	authority_name = "internal affairs"


<<<<<<< HEAD
/obj/item/weapon/stamp/centcomm
	name = "\improper CentCom rubber stamp"
=======
/obj/item/stamp/centcomm
>>>>>>> 11ff35ddb7e... Merge pull request #8812 from Spookerton/spkrtn/cng/pushing-the-envelope
	icon_state = "stamp-cent"
	authority_name = "CentCom"


<<<<<<< HEAD
/obj/item/weapon/stamp/qm
	name = "quartermaster's rubber stamp"
=======
/obj/item/stamp/qm
>>>>>>> 11ff35ddb7e... Merge pull request #8812 from Spookerton/spkrtn/cng/pushing-the-envelope
	icon_state = "stamp-qm"
	authority_name = "quartermaster"
	authority_suffix = "'s"


<<<<<<< HEAD
/obj/item/weapon/stamp/cargo
	name = "cargo rubber stamp"
=======
/obj/item/stamp/cargo
>>>>>>> 11ff35ddb7e... Merge pull request #8812 from Spookerton/spkrtn/cng/pushing-the-envelope
	icon_state = "stamp-cargo"
	authority_name = "cargo"


<<<<<<< HEAD
/obj/item/weapon/stamp/solgov
	name = "\improper Sol Government rubber stamp"
=======
/obj/item/stamp/solgov
>>>>>>> 11ff35ddb7e... Merge pull request #8812 from Spookerton/spkrtn/cng/pushing-the-envelope
	icon_state = "stamp-sg"
	authority_name = "Sol Government"


<<<<<<< HEAD
/obj/item/weapon/stamp/solgov
	name = "\improper Sol Government rubber stamp"
	icon_state = "stamp-sg"

/obj/item/weapon/stamp/solgovlogo
	name = "\improper Sol Government logo stamp"
	icon_state = "stamp-sol"

/obj/item/weapon/stamp/solgovlogo
	name = "\improper Sol Government logo stamp"
=======
/obj/item/stamp/solgovlogo
>>>>>>> 11ff35ddb7e... Merge pull request #8812 from Spookerton/spkrtn/cng/pushing-the-envelope
	icon_state = "stamp-sol"
	name = "logo stamp"
	authority_name = "Sol Government"


/obj/item/stamp/einstein
	icon_state = "stamp-einstein"
	authority_name = "Eintstein Engines"


/obj/item/stamp/hephaestus
	icon_state = "stamp-heph"
	authority_name = "Hephaestus Industries"


/obj/item/stamp/zeng_hu
	icon_state = "stamp-zenghu"
	authority_name = "Zeng-Hu Pharmaceuticals"

<<<<<<< HEAD
// Syndicate stamp to forge documents.
/obj/item/weapon/stamp/chameleon/attack_self(mob/user as mob)

	var/list/stamp_types = typesof(/obj/item/weapon/stamp) - src.type // Get all stamp types except our own
	var/list/stamps = list()

	// Generate them into a list
	for(var/stamp_type in stamp_types)
		var/obj/item/weapon/stamp/S = new stamp_type
		stamps[capitalize(S.name)] = S
=======

/obj/item/stamp/chameleon
	var/static/list/chameleon_stamps

>>>>>>> 11ff35ddb7e... Merge pull request #8812 from Spookerton/spkrtn/cng/pushing-the-envelope

/obj/item/stamp/chameleon/Initialize()
	. = ..()
	if (chameleon_stamps)
		return
	chameleon_stamps = list()
	for (var/obj/item/stamp/stamp as anything in (typesof(/obj/item/stamp) - type))
		stamp = new stamp
		chameleon_stamps[stamp.name] = list(stamp.icon_state, stamp.authority_name, stamp.authority_suffix)
	chameleon_stamps = sortList(chameleon_stamps)

<<<<<<< HEAD
	var/input_stamp = tgui_input_list(user, "Choose a stamp to disguise as:", "Stamp Choice", show_stamps)
=======
>>>>>>> 11ff35ddb7e... Merge pull request #8812 from Spookerton/spkrtn/cng/pushing-the-envelope

/obj/item/stamp/chameleon/attack_self(mob/living/user)
	UpdateChameleon(user)

<<<<<<< HEAD
		var/obj/item/weapon/stamp/chosen_stamp = stamps[capitalize(input_stamp)]
=======
>>>>>>> 11ff35ddb7e... Merge pull request #8812 from Spookerton/spkrtn/cng/pushing-the-envelope

/obj/item/stamp/chameleon/proc/UpdateChameleon(mob/living/user)
	if (BlockInteraction(user))
		return
	var/response = input(user, "Select a stamp to copy:") as null | anything in chameleon_stamps
	if (!response || !(response in chameleon_stamps))
		return
	if (BlockInteraction(user))
		return
	var/list/stamp = chameleon_stamps[response]
	name = response
	icon_state = stamp[1]
	authority_name = stamp[2]
	authority_suffix = stamp[3]
