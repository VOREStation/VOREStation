//This file contains the vars used to give taur and tail socks a baseline color, using their base sprite, upon the various suits and space suits that require them
// I've tried to reasonably color match to the vibes of the overall sprite just to be sure. - Pooj
// Rig Suits deploy a clothing path'd suit, so we just need to keep that in mind for sealed/unsealed related applications.
// These are all stored seperately because I don't really want to edit all the clothing paths myself and change a bunch of files. plays nicer with downstreams too.alist

/obj/item/clothing/suit
	///does the suit require a full-envelop suit sock? Spacesuits, bio suits, rad suits, etc.
	var/requires_tailsock = FALSE
	/// what color is the tailsock going to be? Defaults to a nice, dark grey that usually matches everything.
	/// rgb(29, 29, 29) for the VSC people
	var/tailsock_color = "#1D1D1D"
	/// toggle tailsock options, double duty for taurs, to revert to mask clipped vs full suited if false. This changes the HIDETAIL flag
	var/tailsock_toggle = TRUE

///This is purely for player preference.
/obj/item/clothing/suit/verb/toggle_tailsock()
	set name = "Toggle Tail Sock"
	set category = "Object"
	set desc = "Toggle the tail sock or full body taur sprite on your suit."
	set src in usr
	toggle_tailsock(usr)

/obj/item/clothing/suit/proc/toggle_tailsock()
	tailsock_toggle = !tailsock_toggle
	if(tailsock_toggle)
		flags_inv &= ~HIDETAIL
	else
		flags_inv |= ~HIDETAIL
	update_clothing_icon()

/obj/item/clothing/suit/examine(mob/user)
	. = ..()
	///It's a little thing, but feedback can help someone wondering why a suit isn't hinding their tails/butt.
	. += span_notice("The dynamic sheathing toggle is [tailsock_toggle ? "enabled" : "disabled"].")

/obj/item/clothing/suit/fire
	requires_tailsock = TRUE

/obj/item/clothing/suit/bomb_suit
	requires_tailsock = TRUE

/obj/item/clothing/suit/radiation
	requires_tailsock = TRUE
