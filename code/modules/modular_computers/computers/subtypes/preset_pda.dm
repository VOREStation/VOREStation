/obj/item/modular_computer/pda/install_default_hardware()
	..()
	processor_unit = new /obj/item/weapon/computer_hardware/processor_unit/small(src)
	tesla_link = new /obj/item/weapon/computer_hardware/tesla_link(src)
	hard_drive = new /obj/item/weapon/computer_hardware/hard_drive/small(src)
	network_card = new /obj/item/weapon/computer_hardware/network_card/(src)
	//card_slot = new /obj/item/weapon/computer_hardware/card_slot/broadcaster(src)
	card_slot = new /obj/item/weapon/computer_hardware/card_slot(src)
	battery_module = new /obj/item/weapon/computer_hardware/battery_module(src)
	battery_module.charge_to_full()
	scanner = new /obj/item/weapon/computer_hardware/scanner/medical(src)

/obj/item/modular_computer/pda/install_default_programs()
	..()
	//var/datum/extension/interactive/ntos/os = get_extension(src, /datum/extension/interactive/ntos)
	//if(os)
		//os.create_file(new/datum/computer_file/program/email_client())
		//os.create_file(new/datum/computer_file/program/crew_manifest())
		//os.create_file(new/datum/computer_file/program/wordprocessor())
		//os.create_file(new/datum/computer_file/program/records())
		//os.create_file(new/datum/computer_file/program/newscast())
		//if(prob(50)) //harmless tax software
			//os.create_file(new /datum/computer_file/program/uplink())
		//os.set_autorun("emailc")'
	hard_drive.store_file(new/datum/computer_file/program/chatclient())
	hard_drive.store_file(new/datum/computer_file/program/email_client())
	hard_drive.store_file(new/datum/computer_file/program/crew_manifest())
	hard_drive.store_file(new/datum/computer_file/program/wordprocessor())
	//hard_drive.store_file(new/datum/computer_file/program/records())
	//hard_drive.store_file(new/datum/computer_file/program/newscast())
	//if(prob(50)) //harmless tax software
			//os.create_file(new /datum/computer_file/program/uplink())
	set_autorun("chatclient")

/obj/item/modular_computer/pda/medical/install_default_hardware()
	..()
	scanner = new /obj/item/weapon/computer_hardware/scanner/medical(src)

/obj/item/modular_computer/pda/chemistry/install_default_hardware()
	..()
	scanner = new /obj/item/weapon/computer_hardware/scanner/reagent(src)

/obj/item/modular_computer/pda/engineering/install_default_hardware()
	..()
	scanner = new /obj/item/weapon/computer_hardware/scanner/atmos(src)

/obj/item/modular_computer/pda/science/install_default_hardware()
	..()
	scanner = new /obj/item/weapon/computer_hardware/scanner/reagent(src)

/obj/item/modular_computer/pda/forensics/install_default_hardware()
	..()
	scanner = new /obj/item/weapon/computer_hardware/scanner/reagent(src)

/obj/item/modular_computer/pda/heads/install_default_programs()
	..()
	//var/datum/extension/interactive/ntos/os = get_extension(src, /datum/extension/interactive/ntos)
	//if(os)
		//os.create_file(new/datum/computer_file/program/reports())

/obj/item/modular_computer/pda/heads/hop/install_default_hardware()
	..()
	//scanner = new /obj/item/weapon/computer_hardware/scanner/paper(src)

/obj/item/modular_computer/pda/heads/hos/install_default_hardware()
	..()
	//scanner = new /obj/item/weapon/computer_hardware/scanner/paper(src)

/obj/item/modular_computer/pda/heads/ce/install_default_hardware()
	..()
	scanner = new /obj/item/weapon/computer_hardware/scanner/atmos(src)

/obj/item/modular_computer/pda/heads/cmo/install_default_hardware()
	..()
	scanner = new /obj/item/weapon/computer_hardware/scanner/medical(src)

/obj/item/modular_computer/pda/heads/rd/install_default_hardware()
	..()
	//scanner = new /obj/item/weapon/computer_hardware/scanner/paper(src)

/obj/item/modular_computer/pda/cargo/install_default_programs()
	..()
	//var/datum/extension/interactive/ntos/os = get_extension(src, /datum/extension/interactive/ntos)
	//if(os)
		//os.create_file(new/datum/computer_file/program/reports())

/obj/item/modular_computer/pda/cargo/install_default_hardware()
	..()
	//scanner = new /obj/item/weapon/computer_hardware/scanner/paper(src)

/obj/item/modular_computer/pda/mining/install_default_hardware()
	..()
	scanner = new /obj/item/weapon/computer_hardware/scanner/atmos(src)

/obj/item/modular_computer/pda/explorer/install_default_hardware()
	..()
	scanner = new /obj/item/weapon/computer_hardware/scanner/atmos(src)

/obj/item/modular_computer/pda/captain/install_default_hardware()
	..()
	//scanner = new /obj/item/weapon/computer_hardware/scanner/paper(src)

/obj/item/modular_computer/pda/roboticist/install_default_hardware()
	..()
	//scanner = new /obj/item/weapon/computer_hardware/scanner/robotic(src)
