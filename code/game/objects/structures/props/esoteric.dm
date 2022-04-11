/obj/structure/prop/esoteric
	name = "some esoteric thing"
	desc = "Perhaps it's of ritual significance?"
	icon = 'icons/obj/props/decor.dmi'

/obj/structure/prop/esoteric/nt_pedestal0_old
	name = "pedestal"
	desc = "A pedestal with a mysterious slot at its center."
	icon_state = "nt_pedestal0_old"

/obj/structure/prop/esoteric/nt_pedestal1_old
	name = "pedestal"
	desc = "A pedestal with some kind of sword slotted securely in the center."
	icon_state = "nt_pedestal1_old"

// eye of the protector from Eris
/obj/structure/prop/esoteric/eotp
	icon = 'icons/obj/props/decor32x64.dmi'
	icon_state = "eotp"

/**
 * Possible 'state' options for change_state(state) are:
 * off: Looks boring and off
 * on: candles lit and stuff
 * no_cruciform: No cruciform (the little triangle thing) inserted
 * red_cruciform: Red light cruciform inserted
 * green_cruciform: Green light cruciform inserted
 * panel_open: The panel is open (wiring)
 * panel_closed: The panel is closed
 */
// neotheology cruciform reader from Eris
/obj/structure/prop/esoteric/reader
	name = "electronic altar"
	desc = "It looks like you're meant to scan something here."
	icon = 'icons/obj/props/decor.dmi'
	icon_state = "nt_reader_off"

/obj/structure/prop/esoteric/reader/change_state(state)
	. = ..()
	switch(state)
		if("off")
			icon_state = "nt_reader_off"
		if("on")
			icon_state = "nt_reader_on"
		if("no_cruciform")
			cut_overlay("nt_reader_c_green")
			cut_overlay("nt_reader_c_red")
		if("red_cruciform")
			cut_overlay("nt_reader_c_green")
			cut_overlay("nt_reader_c_red")
			add_overlay("nt_reader_c_red")
		if("green_cruciform")
			cut_overlay("nt_reader_c_red")
			cut_overlay("nt_reader_c_green")
			add_overlay("nt_reader_c_green")
		if("panel_open")
			cut_overlay("nt_reader_panel")
			add_overlay("nt_reader_panel")
		if("panel_closed")
			cut_overlay("nt_reader_panel")
