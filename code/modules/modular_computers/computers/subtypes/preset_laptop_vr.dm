//Rugged laptop
/obj/item/modular_computer/laptop/preset/custom_loadout/rugged
	name = "rugged laptop computer"
	desc = "A rugged portable computer."
	icon_state_unpowered = "ruggedplus-open"
	icon_state = "ruggedplus-open"
	icon_state_closed = "ruggedplus-closed"

	max_damage = 300
	broken_damage = 200

/obj/item/modular_computer/laptop/preset/custom_loadout/rugged/install_default_hardware()
	..()
	processor_unit = new/obj/item/computer_hardware/processor_unit/small(src)
	tesla_link = new/obj/item/computer_hardware/tesla_link(src)
	hard_drive = new/obj/item/computer_hardware/hard_drive/advanced(src)
	network_card = new/obj/item/computer_hardware/network_card/advanced(src)
	nano_printer = new/obj/item/computer_hardware/nano_printer(src)
	card_slot = new/obj/item/computer_hardware/card_slot(src)
	battery_module = new/obj/item/computer_hardware/battery_module/super(src)
	battery_module.charge_to_full()

//Fancy Schmancy - this is defined in normal file, just swapping the icon
/obj/item/modular_computer/laptop/preset/custom_loadout/elite
	name = "elite laptop computer"
	desc = "Fancy shcmancy laptop."
	icon_state_unpowered = "elite-open"
	icon_state = "elite-open"
	icon_state_closed = "elite-closed"

//Alien/Human hybrid tech
/obj/item/modular_computer/laptop/preset/custom_loadout/hybrid
	name = "hybrid laptop computer"
	desc = "Weird glowy alien/human crossover tech."
	icon_state_unpowered = "hybrid-open"
	icon_state = "hybrid-open"
	icon_state_closed = "hybrid-closed"

/obj/item/modular_computer/laptop/preset/custom_loadout/hybrid/install_default_hardware()
	..()
	processor_unit = new/obj/item/computer_hardware/processor_unit/photonic(src)
	tesla_link = new/obj/item/computer_hardware/tesla_link(src)
	hard_drive = new/obj/item/computer_hardware/hard_drive/super(src)
	network_card = new/obj/item/computer_hardware/network_card/advanced(src)
	nano_printer = new/obj/item/computer_hardware/nano_printer(src)
	card_slot = new/obj/item/computer_hardware/card_slot(src)
	battery_module = new/obj/item/computer_hardware/battery_module/lambda(src)
	battery_module.charge_to_full()
