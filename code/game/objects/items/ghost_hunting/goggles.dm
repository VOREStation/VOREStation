/obj/item/clothing/glasses/ghost
	name = "spectral field analysis goggles"
	desc = "A pair of goggles claiming to let you see into the beyond!"
	description_fluff = "A pair of goggles created by K.E's Spectral-Division, a popular item among ghost hunters and paranormal investigators. \
	Due to their extremely poor visual clarity and the extreme static coming from the display, users often claim to see 'specters' and 'spirits' \
	while wearing them with no physcial proof to back up these claims, as any attempt to take a photo or record through the goggles results in \
	results in a blurry, static-filled mess."
	icon_state = "night"
	item_state_slots = list(slot_r_hand_str = "glasses", slot_l_hand_str = "glasses")
	darkness_view = 7 //So you can really see those ghosts~
	see_invisible = SEE_INVISIBLE_CULT
	toggleable = 1
	actions_types = list(/datum/action/item_action/toggle_goggles)
	off_state = "denight"
	flash_protection = FLASH_PROTECTION_VULNERABLE
	enables_planes = list(VIS_GHOSTS)
	///If we can see without static or not.
	var/static_vision = TRUE

/obj/item/clothing/glasses/ghost/Initialize(mapload)
	. = ..()
	if(static_vision)
		overlay = GLOB.global_hud.heavy_whitense //obscures your vision of the real realm AND makes actually seeing ghosts difficult.

/obj/item/clothing/glasses/ghost/advanced
	name = "improved spectral field analysis goggles"
	desc = "A pair of goggles claiming to let you see into the beyond! This one allows for extra clarity."
	static_vision = FALSE
