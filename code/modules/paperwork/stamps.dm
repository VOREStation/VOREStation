/obj/item/stamp
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

/obj/item/stamp/captain
	name = "site manager's rubber stamp"
	icon_state = "stamp-cap"

/obj/item/stamp/hop
	name = "head of personnel's rubber stamp"
	icon_state = "stamp-hop"

/obj/item/stamp/hos
	name = "head of security's rubber stamp"
	icon_state = "stamp-hos"

/obj/item/stamp/ward
	name = "warden's rubber stamp"
	icon_state = "stamp-ward"

/obj/item/stamp/ce
	name = "chief engineer's rubber stamp"
	icon_state = "stamp-ce"

/obj/item/stamp/rd
	name = "research director's rubber stamp"
	icon_state = "stamp-rd"

/obj/item/stamp/cmo
	name = "chief medical officer's rubber stamp"
	icon_state = "stamp-cmo"

/obj/item/stamp/denied
	name = "\improper DENIED rubber stamp"
	icon_state = "stamp-deny"
	attack_verb = list("DENIED")

/obj/item/stamp/accepted
	name = "\improper ACCEPTED rubber stamp"
	icon_state = "stamp-ok"

/obj/item/stamp/clown
	name = "clown's rubber stamp"
	icon_state = "stamp-clown"

/obj/item/stamp/internalaffairs
	name = "internal affairs rubber stamp"
	icon_state = "stamp-intaff"

/obj/item/stamp/centcomm
	name = "\improper CentCom rubber stamp"
	icon_state = "stamp-cent"

/obj/item/stamp/qm
	name = "quartermaster's rubber stamp"
	icon_state = "stamp-qm"

/obj/item/stamp/cargo
	name = "cargo rubber stamp"
	icon_state = "stamp-cargo"

/obj/item/stamp/solgov
	name = "\improper Sol Government rubber stamp"
	icon_state = "stamp-sg"

/obj/item/stamp/solgov
	name = "\improper Sol Government rubber stamp"
	icon_state = "stamp-sg"

/obj/item/stamp/solgovlogo
	name = "\improper Sol Government logo stamp"
	icon_state = "stamp-sol"

/obj/item/stamp/solgovlogo
	name = "\improper Sol Government logo stamp"
	icon_state = "stamp-sol"

/obj/item/stamp/einstein
	name = "\improper Einstein Engines rubber stamp"
	icon_state = "stamp-einstein"

/obj/item/stamp/hephaestus
	name = "\improper Hephaestus Industries rubber stamp"
	icon_state = "stamp-heph"

/obj/item/stamp/zeng_hu
	name = "\improper Zeng-Hu Pharmaceuticals rubber stamp"
	icon_state = "stamp-zenghu"

// Syndicate stamp to forge documents.
/obj/item/stamp/chameleon/attack_self(mob/user as mob)

	var/list/stamp_types = typesof(/obj/item/stamp) - src.type // Get all stamp types except our own
	var/list/stamps = list()

	// Generate them into a list
	for(var/stamp_type in stamp_types)
		var/obj/item/stamp/S = new stamp_type
		stamps[capitalize(S.name)] = S

	var/list/show_stamps = list("EXIT" = null) + sortList(stamps) // the list that will be shown to the user to pick from

	var/input_stamp = tgui_input_list(user, "Choose a stamp to disguise as:", "Stamp Choice", show_stamps)

	if(user && (src in user.contents)) // Er, how necessary is this in attack_self?

		var/obj/item/stamp/chosen_stamp = stamps[capitalize(input_stamp)]

		if(chosen_stamp)
			name = chosen_stamp.name
			icon_state = chosen_stamp.icon_state
