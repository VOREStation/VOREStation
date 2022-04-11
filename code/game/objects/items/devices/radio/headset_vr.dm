/obj/item/device/radio/headset/centcom
	name = "centcom radio headset"
	desc = "The headset of the boss's boss."
	icon_state = "cent_headset"
	item_state = "headset"
	centComm = 1
	ks2type = /obj/item/device/encryptionkey/ert

/obj/item/device/radio/headset/centcom/alt
	name = "centcom bowman headset"
	icon_state = "com_headset_alt"

/obj/item/device/radio/headset/nanotrasen
	name = "\improper NT radio headset"
	desc = "The headset of a Nanotrasen corporate employee."
	icon_state = "nt_headset"
	centComm = 1
	ks2type = /obj/item/device/encryptionkey/ert

/obj/item/device/radio/headset/nanotrasen/alt
	name = "\improper NT bowman headset"
	icon_state = "nt_headset_alt"

/obj/item/device/radio/headset
	sprite_sheets = list(SPECIES_TESHARI = 'icons/inventory/ears/mob_teshari.dmi',
						SPECIES_WEREBEAST = 'icons/inventory/ears/mob_vr_werebeast.dmi')

/obj/item/device/radio/headset/mob_headset	//Adminbus headset for simplemob shenanigans.
	name = "nonhuman radio receiver"
	desc = "An updated, self-adhesive modular intercom that requires no hands to operate or ears to hold, just stick it on. Takes encryption keys"

/obj/item/device/radio/headset/mob_headset/receive_range(freq, level)
	if(ismob(src.loc))
		return ..(freq, level, 1)
	return -1

/obj/item/device/radio/headset/mob_headset/afterattack(var/atom/movable/target, mob/living/user, proximity)
	if(!proximity)
		return
	if(istype(target,/mob/living/simple_mob))
		var/mob/living/simple_mob/M = target
		if(!M.mob_radio)
			user.drop_item()
			forceMove(M)
			M.mob_radio = src
			return
		if(M.mob_radio)
			M.mob_radio.forceMove(M.loc)
			M.mob_radio = null
			return
	..()

/obj/item/device/radio/headset/headset_cargo
	desc = "A headset used by the QM's slaves."

/obj/item/device/radio/headset/headset_cargo/alt
	desc = "A bowman headset used by the QM's slaves."

/obj/item/device/radio/headset/headset_qm
	name = "qm radio headset"
	desc = "A headset used by the QM."
	icon_state = "cargo_headset"
	ks2type = /obj/item/device/encryptionkey/qm

/obj/item/device/radio/headset/headset_qm/alt
	name = "qm bowman headset"
	desc = "A bowman headset used by the QM."
	icon_state = "cargo_headset_alt"

/obj/item/device/radio/headset/pathfinder
	name = "pathfinder's headset"
	desc = "Headset used by pathfinders for exploring. Access to the explorer and command channels."
	icon_state = "exp_headset"
	adhoc_fallback = TRUE
	ks2type = /obj/item/device/encryptionkey/pathfinder

/obj/item/device/radio/headset/pathfinder/alt
	name = "pathfinder's bowman headset"
	desc = "Bowman headset used by pathfinders for exploring. Access to the explorer and command channels."
	icon_state = "exp_headset_alt"

/obj/item/device/radio/headset/pilot
	name = "pilot's headset"
	desc = "A headset used by pilots."
	icon_state = "pilot_headset"
	adhoc_fallback = TRUE

/obj/item/device/radio/headset/pilot/alt
	name = "pilot's bowman headset"
	desc = "A bowman headset used by pilots."
	icon_state = "pilot_headset_alt"

/obj/item/device/radio/headset/explorer
	name = "explorer's headset"
	desc = "Headset used by explorers for exploring. Access to the explorer channel."
	icon_state = "exp_headset"
	adhoc_fallback = TRUE
	ks2type = /obj/item/device/encryptionkey/explorer

/obj/item/device/radio/headset/explorer/alt
	name = "explorer's bowman headset"
	desc = "Bowman headset used by explorers for exploring. Access to the explorer channel."
	icon_state = "exp_headset_alt"

/obj/item/device/radio/headset/sar
	name = "fm radio headset"
	desc = "A headset for field medics."
	icon_state = "sar_headset"
	adhoc_fallback = TRUE
	ks2type = /obj/item/device/encryptionkey/sar

/obj/item/device/radio/headset/sar/alt
	name = "fm radio bowman headset"
	desc = "A bowman headset for field medics."
	icon_state = "sar_headset_alt"

/obj/item/device/radio/headset/volunteer
	name = "volunteer's headset"
	desc = "A headset used by volunteers to expedition teams, has access to the exploration channel."
	icon_state = "pilot_headset"
	adhoc_fallback = TRUE
	ks2type = /obj/item/device/encryptionkey/explorer

/obj/item/device/radio/headset/talon
	name = "talon headset"
	desc = "A headset for communication between the crew of the ITV Talon."
	adhoc_fallback = TRUE
	icon_state = "pilot_headset"
	ks2type = /obj/item/device/encryptionkey/talon
