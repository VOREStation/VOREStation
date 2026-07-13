//This file contains the vars used to give taur and tail socks a baseline color, using their base sprite, upon the various suits and space suits that require them
// I've tried to reasonably color match to the vibes of the overall sprite just to be sure. - Pooj

/obj/item/clothing/suit
	. = ..()
	///does the suit require a full-envelop suit sock? Spacesuits, bio suits, rad suits, etc.
	var/requires_tailsock = FALSE
	/// what color is the tailsock going to be? Defaults to a nice, dark grey that usually matches everything.
	var/tailsock_color = #3B3B3B
