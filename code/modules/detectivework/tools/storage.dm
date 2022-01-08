/obj/item/weapon/storage/box/swabs
	name = "box of swab kits"
	desc = "Sterilized equipment within. Do not contaminate."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "dnakit"
	can_hold = list(/obj/item/weapon/forensics/swab)
	storage_slots = 14

/obj/item/weapon/storage/box/swabs/Initialize()
	. = ..()
	for(var/i = 1 to storage_slots) // Fill 'er up.
		new /obj/item/weapon/forensics/swab(src)

/obj/item/weapon/storage/box/evidence
	name = "evidence bag box"
	desc = "A box claiming to contain evidence bags."
	storage_slots = 7
	can_hold = list(/obj/item/weapon/evidencebag)

/obj/item/weapon/storage/box/evidence/Initialize()
	. = ..()
	for(var/i = 1 to storage_slots)
		new /obj/item/weapon/evidencebag(src)

/obj/item/weapon/storage/box/fingerprints
	name = "box of fingerprint cards"
	desc = "Sterilized equipment within. Do not contaminate."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "dnakit"
	can_hold = list(/obj/item/weapon/sample/print)
	storage_slots = 14

/obj/item/weapon/storage/box/fingerprints/Initialize()
	. = ..()
	for(var/i = 1 to storage_slots)
		new /obj/item/weapon/sample/print(src)