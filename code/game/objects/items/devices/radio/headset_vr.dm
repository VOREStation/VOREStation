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
	sprite_sheets = list(SPECIES_TESHARI = 'icons/mob/species/seromi/ears.dmi',
						SPECIES_WEREBEAST = 'icons/mob/species/werebeast/ears.dmi')

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