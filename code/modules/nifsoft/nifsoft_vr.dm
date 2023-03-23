// Pilot Disk //
/obj/item/weapon/disk/nifsoft/pilot
	name = "NIFSoft Uploader - Pilot"
	desc = "Contains free NIFSofts useful for pilot members.\n\
	It has a small label: \n\
	\"Portable NIFSoft Installation Media. \n\
	Align ocular port with eye socket and depress red plunger.\""
	icon = 'icons/obj/nanomods_vr.dmi'
	icon_state = "pilot"
	stored_organic = /datum/nifsoft/package/pilot
	stored_synthetic = /datum/nifsoft/package/pilot_synth

/datum/nifsoft/package/pilot
	software = list(/datum/nifsoft/spare_breath)

/datum/nifsoft/package/pilot_synth
	software = list(/datum/nifsoft/pressure,/datum/nifsoft/heatsinks)

/obj/item/weapon/storage/box/nifsofts_pilot
	name = "pilot nifsoft uploaders"
	desc = "A box of free nifsofts for pilot employees."
	icon = 'icons/obj/boxes_vr.dmi'
	icon_state = "nifsoft_kit_pilot"

/obj/item/weapon/storage/box/nifsofts_pilot/New()
	..()
	for(var/i = 0 to 7)
		new /obj/item/weapon/disk/nifsoft/pilot(src)