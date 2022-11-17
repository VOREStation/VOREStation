/mob/living/silicon/robot/platform/explorer
	req_access = list(access_explorer)

/mob/living/silicon/robot/platform/cargo
	req_access = list(access_cargo_bot)

/obj/item/card/id/platform/Initialize()
	. = ..()
	access |= access_explorer
