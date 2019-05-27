/obj/item/modular_computer/laptop/preset/custom_loadout/cheap/install_default_hardware()
	..()
	processor_unit = new/obj/item/weapon/computer_hardware/processor_unit/small(src)
	tesla_link = new/obj/item/weapon/computer_hardware/tesla_link(src)
	hard_drive = new/obj/item/weapon/computer_hardware/hard_drive/(src)
	network_card = new/obj/item/weapon/computer_hardware/network_card/(src)
	nano_printer = new/obj/item/weapon/computer_hardware/nano_printer(src)
	card_slot = new/obj/item/weapon/computer_hardware/card_slot(src)
	battery_module = new/obj/item/weapon/computer_hardware/battery_module/advanced(src)
	battery_module.charge_to_full()

/obj/item/modular_computer/laptop/preset/custom_loadout/advanced/install_default_hardware()
	..()
	processor_unit = new/obj/item/weapon/computer_hardware/processor_unit(src)
	tesla_link = new/obj/item/weapon/computer_hardware/tesla_link(src)
	hard_drive = new/obj/item/weapon/computer_hardware/hard_drive/advanced(src)
	network_card = new/obj/item/weapon/computer_hardware/network_card/advanced(src)
	nano_printer = new/obj/item/weapon/computer_hardware/nano_printer(src)
	card_slot = new/obj/item/weapon/computer_hardware/card_slot(src)
	battery_module = new/obj/item/weapon/computer_hardware/battery_module/advanced(src)
	battery_module.charge_to_full()

/obj/item/modular_computer/laptop/preset/custom_loadout/standard/install_default_hardware()
	..()
	processor_unit = new/obj/item/weapon/computer_hardware/processor_unit(src)
	tesla_link = new/obj/item/weapon/computer_hardware/tesla_link(src)
	hard_drive = new/obj/item/weapon/computer_hardware/hard_drive/(src)
	network_card = new/obj/item/weapon/computer_hardware/network_card/(src)
	nano_printer = new/obj/item/weapon/computer_hardware/nano_printer(src)
	card_slot = new/obj/item/weapon/computer_hardware/card_slot(src)
	battery_module = new/obj/item/weapon/computer_hardware/battery_module/advanced(src)
	battery_module.charge_to_full()

/obj/item/modular_computer/laptop/preset/custom_loadout/elite
	icon_state_unpowered = "adv-laptop-open"
	icon_state = "adv-laptop-open"
	icon_state_closed = "adv-laptop-closed"

/obj/item/modular_computer/laptop/preset/custom_loadout/elite/install_default_hardware()
	..()
	processor_unit = new/obj/item/weapon/computer_hardware/processor_unit(src)
	tesla_link = new/obj/item/weapon/computer_hardware/tesla_link(src)
	hard_drive = new/obj/item/weapon/computer_hardware/hard_drive/super(src)
	network_card = new/obj/item/weapon/computer_hardware/network_card/advanced(src)
	nano_printer = new/obj/item/weapon/computer_hardware/nano_printer(src)
	card_slot = new/obj/item/weapon/computer_hardware/card_slot(src)
	battery_module = new/obj/item/weapon/computer_hardware/battery_module/super(src)
	battery_module.charge_to_full()

//VOREStation Add Start
/obj/item/modular_computer/laptop/preset/custom_loadout/rugged
	name = "rugged laptop computer"
	desc = "A rugged portable computer."
	icon = 'icons/obj/modular_laptop_vr.dmi'
	max_damage = 300
	broken_damage = 200

/obj/item/modular_computer/laptop/preset/custom_loadout/rugged/install_default_hardware()
	..()
	processor_unit = new/obj/item/weapon/computer_hardware/processor_unit/small(src)
	tesla_link = new/obj/item/weapon/computer_hardware/tesla_link(src)
	hard_drive = new/obj/item/weapon/computer_hardware/hard_drive/advanced(src)
	network_card = new/obj/item/weapon/computer_hardware/network_card/advanced(src)
	nano_printer = new/obj/item/weapon/computer_hardware/nano_printer(src)
	card_slot = new/obj/item/weapon/computer_hardware/card_slot(src)
	battery_module = new/obj/item/weapon/computer_hardware/battery_module/super(src)
	battery_module.charge_to_full()
//VOREStation Add End