/mob/living/silicon/robot/platform/explorer
	req_access = list(ACCESS_EXPLORER)

/mob/living/silicon/robot/platform/cargo
	req_access = list(ACCESS_CARGO_BOT)

/obj/item/card/id/platform/Initialize(mapload)
	. = ..()
	access |= ACCESS_EXPLORER
	access |= ACCESS_PILOT
