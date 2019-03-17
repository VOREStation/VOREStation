#ifdef T_BOARD_MICRO_MECHA
#error T_BOARD_MICRO_MECHA already defined elsewhere, we can't use it.
#endif
#define T_BOARD_MICRO_MECHA(name)	"exosuit module circuit board (" + (name) + ")"

/obj/item/weapon/circuitboard/mecha/gopher
		origin_tech = list(TECH_DATA = 3)

/obj/item/weapon/circuitboard/mecha/gopher/peripherals
		name = T_BOARD_MICRO_MECHA("Gopher peripherals control")
		icon_state = "mcontroller"

/obj/item/weapon/circuitboard/mecha/gopher/main
		name = T_BOARD_MICRO_MECHA("Gopher central control")
		icon_state = "mainboard"

/obj/item/weapon/circuitboard/mecha/polecat
		origin_tech = list(TECH_DATA = 4)

/obj/item/weapon/circuitboard/mecha/polecat/peripherals
		name = T_BOARD_MICRO_MECHA("Polecat peripherals control")
		icon_state = "mcontroller"

/obj/item/weapon/circuitboard/mecha/polecat/targeting
		name = T_BOARD_MICRO_MECHA("Polecat weapon control and targeting")
		icon_state = "mcontroller"
		origin_tech = list(TECH_DATA = 4, TECH_COMBAT = 4)

/obj/item/weapon/circuitboard/mecha/polecat/main
		name = T_BOARD_MICRO_MECHA("Polecat central control")
		icon_state = "mainboard"

/obj/item/weapon/circuitboard/mecha/weasel
		origin_tech = list(TECH_DATA = 4)

/obj/item/weapon/circuitboard/mecha/weasel/peripherals
		name = T_BOARD_MICRO_MECHA("Weasel peripherals control")
		icon_state = "mcontroller"

/obj/item/weapon/circuitboard/mecha/weasel/targeting
		name = T_BOARD_MICRO_MECHA("Weasel weapon control and targeting")
		icon_state = "mcontroller"
		origin_tech = list(TECH_DATA = 4, TECH_COMBAT = 4)

/obj/item/weapon/circuitboard/mecha/weasel/main
		name = T_BOARD_MICRO_MECHA("Weasel central control")
		icon_state = "mainboard"
