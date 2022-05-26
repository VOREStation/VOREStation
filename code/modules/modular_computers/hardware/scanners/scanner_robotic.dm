/obj/item/weapon/computer_hardware/scanner/robotic
	name = "robotic scanner module"
	desc = "A robotic scanner module. It is used to analyse the integrity of synthetic components."

/obj/item/weapon/computer_hardware/scanner/robotic/do_on_afterattack(mob/user, atom/target, proximity)
	if(!can_use_scanner(user, target, proximity))
		return

	var/scan_type = roboscan(target, user)

	if(scan_type && driver?.using_scanner)
		driver.data_buffer = html2pencode(scan_type)