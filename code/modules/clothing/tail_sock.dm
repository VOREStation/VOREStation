//This file contains the vars used to give taur and tail socks a baseline color, using their base sprite, upon the various suits and space suits that require them
// I've tried to reasonably color match to the vibes of the overall sprite just to be sure. - Pooj
// Rig Suits deploy a clothing path'd suit, so we just need to keep that in mind for sealed/unsealed related applications.
// These are all stored seperately because I don't really want to edit all the clothing paths myself and change a bunch of files. plays nicer with downstreams too.alist

/obj/item/clothing/suit
	///does the suit require a full-envelop suit sock? Spacesuits, bio suits, rad suits, etc.
	var/requires_tailsock = FALSE
	/// what color is the tailsock going to be? Defaults to a nice, dark grey that usually matches everything.
	var/tailsock_color = "#1F1F1F"
	/// toggle tailsock options
	var/tailsock_toggle = TRUE
	/// toggle taur extending for the sprites, for people who want their butts to be shown off, default false
	var/showtaurbutts = FALSE

/obj/item/clothing/suit/space
	/// unrelated to tailsocks directly, buuuuuut, taur suits have dedicated sealed/unsealed variants and that should be applied, too.
	var/sealable = FALSE
	requires_tailsock = TRUE

///This is purely for player preference.
/obj/item/clothing/suit/verb/toggletailsock()
	set name = "Toggle Tail Sock"
	set category = "Object"
	set desc = "Toggle the tail sock on your suit."
	toggle_tailsock(usr)

/obj/item/clothing/suit/proc/toggle_tailsock(mob/user)
	if(!user || !ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(H.wear_suit != src)
		to_chat(user, span_warning("You must be wearing \the [src] to adjust the tail sock."))
		return

	if(!requires_tailsock)
		to_chat(user, span_notice("\The [src] does not have a tail sock extruder."))
		return

	if(showtaurbutts)
		to_chat(user, span_notice("You must enable full body taur sheathing on \the [src] first."))
		return

	tailsock_toggle = !tailsock_toggle
	to_chat(user, span_notice("You toggle \the [src]'s dynamic tail sheath [tailsock_toggle ? "ON" : "OFF"]."))

	H.update_inv_wear_suit()
	H.update_tail_showing()

/obj/item/clothing/suit/verb/toggletaursuit()
	set name = "Toggle Taur Extension"
	set category = "Object"
	set desc = "Toggle the full body taur sprite on your suit."
	toggle_taurextender(usr)

/obj/item/clothing/suit/proc/toggle_taurextender(mob/user)
	if(!user || !ishuman(user))
		return

	var/mob/living/carbon/human/H = user
	if(H.wear_suit != src)
		to_chat(user, span_warning("You must be wearing \the [src] to adjust the taur extension."))
		return

	var/taurtail = istaurtail(H.tail_style)
	if(!taurtail)
		to_chat(user, span_warning("\The [src]'s taur extension requires a taur body."))
		return

	showtaurbutts = !showtaurbutts

	if(showtaurbutts)
		// Classic Mode: turn off suit tailsock sleeve
		tailsock_toggle = FALSE
		to_chat(user, span_notice("You disable full body sheathing on \the [src] (Classic mode)."))
	else
		// Modern Taur Mode: Enable suit override & tail sheath
		tailsock_toggle = TRUE
		to_chat(user, span_notice("You enable full body taur sheathing on \the [src]."))

	taurize(H, taurtail)
	H.update_inv_wear_suit()
	H.update_tail_showing()

/obj/item/clothing/suit/examine(mob/user)
	. = ..()
	///It's a little thing, but feedback can help someone wondering why a suit isn't hinding their tails/butt.
	. += span_notice("The dynamic sheathing toggle is [tailsock_toggle ? "enabled" : "disabled"].")

//The following for specific sock colors more than anything.

//Fire suits
/obj/item/clothing/suit/fire
	requires_tailsock = TRUE
	tailsock_color = "#343442"

/obj/item/clothing/suit/fire/firefighter
	tailsock_color = "#3F3F3F"

/obj/item/clothing/suit/fire/heavy
	tailsock_color = "#3F3F3F"

//Bomb suits
/obj/item/clothing/suit/bomb_suit
	requires_tailsock = TRUE
	tailsock_color = "#9C8956"

/obj/item/clothing/suit/bomb_suit/security
	tailsock_color = "#4A4A2F"

// Bio suits
/obj/item/clothing/suit/bio_suit
	requires_tailsock = TRUE
	tailsock_color = "#BBBBBB"

/obj/item/clothing/suit/bio_suit/security
	tailsock_color = "#5F615E"

/obj/item/clothing/suit/bio_suit/janitor
	tailsock_color = "#5F615E"

/obj/item/clothing/suit/bio_suit/scientist
	tailsock_color = "#CCB8A8"

// Radiation
/obj/item/clothing/suit/radiation
	requires_tailsock = TRUE

// Misc suits
/obj/item/clothing/suit/straight_jacket
	requires_tailsock = TRUE
	tailsock_color = "#AAAAAA"

//Station Void Space Suits
/obj/item/clothing/suit/space/void/makeshift
	tailsock_color = "#573226"

/obj/item/clothing/suit/space/void/refurb
	tailsock_color = "#293f61"

/obj/item/clothing/suit/space/void/captain
	tailsock_color = "#7F7F7F"

/obj/item/clothing/suit/space/void/security/prototype
	tailsock_color = "#7F7F7F"

/obj/item/clothing/suit/space/void/pilot
	tailsock_color = "#6B5E52"

/obj/item/clothing/suit/space/void/exploration/alt
	tailsock_color = "#6B5E52"

/obj/item/clothing/suit/space/void/engineering
	sealable = TRUE
	tailsock_color = "#4E4139"

/obj/item/clothing/suit/space/void/engineering/salvage
	tailsock_color = "#3E3823"

/obj/item/clothing/suit/space/void/atmos
	sealable = TRUE
	tailsock_color = "#6B5E52"

/obj/item/clothing/suit/space/void/mining
	sealable = TRUE
	tailsock_color = "#6B5E52"

/obj/item/clothing/suit/space/void/mining/alt
	sealable = TRUE
	tailsock_color = "#5F615E"

/obj/item/clothing/suit/space/void/medical
	sealable = TRUE
	tailsock_color = "#645C56"

/obj/item/clothing/suit/space/void/security
	sealable = TRUE
	tailsock_color = "#39342D"

/obj/item/clothing/suit/space/void/security/riot
	sealable = TRUE
	tailsock_color = "#660000"

/obj/item/clothing/suit/space/void/security/alt
	sealable = TRUE
	tailsock_color = "#1D1D1D"

/obj/item/clothing/suit/armor/captain
	requires_tailsock = TRUE
	tailsock_color = "#1E3E50"

/obj/item/clothing/suit/space/emergency
	tailsock_color = "#282828"

//Bay ported Station Suits
/obj/item/clothing/suit/space/void/engineering/alt2
	sealable = FALSE
	tailsock_color = "#1C222B"

/obj/item/clothing/suit/space/void/atmos/alt2
	sealable = FALSE
	tailsock_color = "#1C222B"

/obj/item/clothing/suit/space/void/captain/alt
	sealable = FALSE
	tailsock_color = "#1C222B"

/obj/item/clothing/suit/space/void/medical/alt2
	sealable = FALSE
	tailsock_color = "#1C222B"

/obj/item/clothing/suit/space/void/exploration/alt2
	sealable = FALSE
	tailsock_color = "#1C222B"

/obj/item/clothing/suit/space/void/mining/alt2
	sealable = FALSE
	tailsock_color = "#2B3440"

/obj/item/clothing/suit/space/anomaly/alt
	sealable = FALSE
	tailsock_color = "#1C222B"

/obj/item/clothing/suit/space/void/security/riot/alt
	sealable = FALSE
	tailsock_color = "#1C222B"

//Event Space Suits
/obj/item/clothing/suit/space/void/hev
	tailsock_color = "#2D313C"

/obj/item/clothing/suit/space/void/aether
	tailsock_color = "#423F4F"

/obj/item/clothing/suit/space/void/custodian
	tailsock_color = "#453542"

/obj/item/clothing/suit/space/void/excelsior
	tailsock_color = "#6D6D6B"

//Antag Space suits
/obj/item/clothing/suit/space/syndicate
	tailsock_color = "#282828"

/obj/item/clothing/suit/space/void/merc
	sealable = TRUE
	tailsock_color = "#851e0e"

/obj/item/clothing/suit/space/void/merc/fire
	sealable = TRUE
	tailsock_color = "#483031"

/obj/item/clothing/suit/space/void/wizard
	sealable = TRUE
	tailsock_color = "#493955"

//snowflake species suits
/obj/item/clothing/suit/space/vox
	requires_tailsock = FALSE

/obj/item/clothing/suit/space/void/altevian_heartbreaker
	requires_tailsock = FALSE

/obj/item/clothing/suit/space/void/zaddat
	requires_tailsock = FALSE

//RIG's space suits
/obj/item/clothing/suit/space/rig/zero
	tailsock_color = "#232226"

/obj/item/clothing/suit/space/rig/baymed
	tailsock_color = "#1C222B"

/obj/item/clothing/suit/space/rig/pathfinder
	tailsock_color = "#1C222B"

/obj/item/clothing/suit/space/rig/advsuit
	tailsock_color = "#6B5E52"

/obj/item/clothing/suit/space/rig/focalpoint
	tailsock_color = "#303B40"

/obj/item/clothing/suit/space/rig/hephaestus
	tailsock_color = "#2D253E"
