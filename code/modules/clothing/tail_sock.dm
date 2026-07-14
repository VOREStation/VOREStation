//This file contains the vars used to give taur and tail socks a baseline color, using their base sprite, upon the various suits and space suits that require them
// I've tried to reasonably color match to the vibes of the overall sprite just to be sure. - Pooj
// Rig Suits deploy a clothing path'd suit, so we just need to keep that in mind for sealed/unsealed related applications.
// These are all stored seperately because I don't really want to edit all the clothing paths myself and change a bunch of files. plays nicer with downstreams too.alist

/obj/item/clothing/suit
	///does the suit require a full-envelop suit sock? Spacesuits, bio suits, rad suits, etc.
	var/requires_tailsock = FALSE
	/// what color is the tailsock going to be? Defaults to a nice, dark grey that usually matches everything.
	/// rgb(29, 29, 29) for the VSC people
	var/tailsock_color = #1D1D1D

/obj/item/clothing/suit/fire
	requires_tailsock = TRUE

/obj/item/clothing/suit/bomb_suit
	requires_tailsock = TRUE

/obj/item/clothing/suit/radiation
	requires_tailsock = TRUE
