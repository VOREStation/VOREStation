#ifdef T_BOARD_MECHA
#error T_BOARD_MECHA already defined elsewhere, we can't use it.
#endif
#define T_BOARD_MECHA(name)	"exosuit module circuit board (" + (name) + ")"

/obj/item/weapon/circuitboard/mecha
	name = "exosuit circuit board"
	icon = 'icons/obj/module.dmi'
	icon_state = "std_mod"
	board_type = "other"

/obj/item/weapon/circuitboard/mecha/ripley
		origin_tech = list(TECH_DATA = 3)

/obj/item/weapon/circuitboard/mecha/ripley/peripherals
		name = T_BOARD_MECHA("Ripley peripherals control")
		icon_state = "mcontroller"

/obj/item/weapon/circuitboard/mecha/ripley/main
		name = T_BOARD_MECHA("Ripley central control")
		icon_state = "mainboard"

/obj/item/weapon/circuitboard/mecha/gygax
		origin_tech = list(TECH_DATA = 4)

/obj/item/weapon/circuitboard/mecha/gygax/peripherals
		name = T_BOARD_MECHA("Gygax peripherals control")
		icon_state = "mcontroller"

/obj/item/weapon/circuitboard/mecha/gygax/targeting
		name = T_BOARD_MECHA("Gygax weapon control and targeting")
		icon_state = "mcontroller"
		origin_tech = list(TECH_DATA = 4, TECH_COMBAT = 4)

/obj/item/weapon/circuitboard/mecha/gygax/medical
		name = T_BOARD_MECHA("Serenity medical control")
		icon_state = "mcontroller"
		origin_tech = list(TECH_DATA = 4, TECH_BIO = 4)

/obj/item/weapon/circuitboard/mecha/gygax/main
		name = T_BOARD_MECHA("Gygax central control")
		icon_state = "mainboard"

/obj/item/weapon/circuitboard/mecha/durand
		origin_tech = list(TECH_DATA = 4)

/obj/item/weapon/circuitboard/mecha/durand/peripherals
		name = T_BOARD_MECHA("Durand peripherals control")
		icon_state = "mcontroller"

/obj/item/weapon/circuitboard/mecha/durand/targeting
		name = T_BOARD_MECHA("Durand weapon control and targeting")
		icon_state = "mcontroller"
		origin_tech = list(TECH_DATA = 4, TECH_COMBAT = 4)

/obj/item/weapon/circuitboard/mecha/durand/main
		name = T_BOARD_MECHA("Durand central control")
		icon_state = "mainboard"

/obj/item/weapon/circuitboard/mecha/phazon

/obj/item/weapon/circuitboard/mecha/phazon/peripherals
		name = T_BOARD_MECHA("Phazon peripherals control")
		icon_state = "mcontroller"
		origin_tech = list(TECH_DATA = 6, TECH_ILLEGAL = 6)

/obj/item/weapon/circuitboard/mecha/phazon/targeting
		name = T_BOARD_MECHA("Phazon weapon control and targeting")
		icon_state = "mcontroller"
		origin_tech = list(TECH_DATA = 6, TECH_COMBAT = 7)

/obj/item/weapon/circuitboard/mecha/phazon/main
		name = T_BOARD_MECHA("Phazon central control")
		origin_tech = list(TECH_DATA = 6, TECH_BLUESPACE = 5)
		icon_state = "mainboard"

/obj/item/weapon/circuitboard/mecha/honker
		origin_tech = list(TECH_DATA = 4)

/obj/item/weapon/circuitboard/mecha/honker/peripherals
		name = T_BOARD_MECHA("H.O.N.K peripherals control")
		icon_state = "mcontroller"

/obj/item/weapon/circuitboard/mecha/honker/targeting
		name = T_BOARD_MECHA("H.O.N.K weapon control and targeting")
		icon_state = "mcontroller"

/obj/item/weapon/circuitboard/mecha/honker/main
		name = T_BOARD_MECHA("H.O.N.K central control")
		icon_state = "mainboard"


/obj/item/weapon/circuitboard/mecha/odysseus
		origin_tech = list(TECH_DATA = 3)

/obj/item/weapon/circuitboard/mecha/odysseus/peripherals
		name = T_BOARD_MECHA("Odysseus peripherals control")
		icon_state = "mcontroller"

/obj/item/weapon/circuitboard/mecha/odysseus/main
		name = T_BOARD_MECHA("Odysseus central control")
		icon_state = "mainboard"

/obj/item/weapon/circuitboard/mecha/imperion
		name = "Alien Circuit"
		origin_tech = list(TECH_DATA = 5, TECH_BLUESPACE = 3, TECH_PRECURSOR = 1)
		icon = 'icons/obj/abductor.dmi'
		icon_state = "circuit"

/obj/item/weapon/circuitboard/mecha/imperion/main
		desc = "It is marked with a <span class='alien'>strange glyph</span>."

/obj/item/weapon/circuitboard/mecha/imperion/peripherals
		desc = "It is marked with a <span class='alien'>pulsing glyph</span>."

/obj/item/weapon/circuitboard/mecha/imperion/targeting
		desc = "It is marked with an <span class='alien'>ominous glyph</span>."

/obj/item/weapon/circuitboard/mecha/imperion/phasing
		desc = "It is marked with a <span class='alien'>disturbing glyph</span>."

/obj/item/weapon/circuitboard/mecha/imperion/damaged
		name = "Damaged Alien Circuit"
		desc = "It is marked with a <span class='alien'>constantly shifting glyph</span>."
		origin_tech = list(TECH_DATA = 3, TECH_BLUESPACE = 1, TECH_PRECURSOR = 2)

//Undef the macro, shouldn't be needed anywhere else
#undef T_BOARD_MECHA
