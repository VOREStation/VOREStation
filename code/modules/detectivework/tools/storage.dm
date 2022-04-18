/obj/item/storage/box/swabs
	name = "box of swab kits"
	desc = "Sterilized equipment within. Do not contaminate."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "dnakit"
	can_hold = list(/obj/item/forensics/swab)
	storage_slots = 14

<<<<<<< HEAD
/obj/item/weapon/storage/box/swabs/New()
	..()
=======
/obj/item/storage/box/swabs/Initialize()
	. = ..()
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	for(var/i = 1 to storage_slots) // Fill 'er up.
		new /obj/item/forensics/swab(src)

/obj/item/storage/box/evidence
	name = "evidence bag box"
	desc = "A box claiming to contain evidence bags."
	storage_slots = 7
	can_hold = list(/obj/item/evidencebag)

<<<<<<< HEAD
/obj/item/weapon/storage/box/evidence/New()
	..()
=======
/obj/item/storage/box/evidence/Initialize()
	. = ..()
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	for(var/i = 1 to storage_slots)
		new /obj/item/evidencebag(src)

/obj/item/storage/box/fingerprints
	name = "box of fingerprint cards"
	desc = "Sterilized equipment within. Do not contaminate."
	icon = 'icons/obj/forensics.dmi'
	icon_state = "dnakit"
	can_hold = list(/obj/item/sample/print)
	storage_slots = 14

<<<<<<< HEAD
/obj/item/weapon/storage/box/fingerprints/New()
	..()
=======
/obj/item/storage/box/fingerprints/Initialize()
	. = ..()
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	for(var/i = 1 to storage_slots)
		new /obj/item/sample/print(src)