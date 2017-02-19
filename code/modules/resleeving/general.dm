////////////////////////////////
//// General resleeving stuff common to
//// robotics and medical both
////////////////////////////////

//The backup implant itself
/obj/item/weapon/implant/backup
	name = "backup implant"
	desc = "Do you wanna live forever?"
	var/datum/transhuman/mind_record/my_record

/obj/item/weapon/implant/backup/get_data()
	var/dat = {"
<b>Implant Specifications:</b><BR>
<b>Name:</b> [company_name] Employee Backup Implant<BR>
<b>Life:</b> ~8 hours.<BR>
<b>Important Notes:</b> Implant is life-limited due to KHI licensing restrictions. Dissolves into harmless biomaterial after around ~8 hours, the typical work shift.<BR>
<HR>
<b>Implant Details:</b><BR>
<b>Function:</b> Contains a small swarm of nanobots that perform neuron scanning to create mind-backups.<BR>
<b>Special Features:</b> Will allow restoring of backups during the 8-hour period it is active.<BR>
<b>Integrity:</b> Generally very survivable. Susceptible to being destroyed by acid."}
	return dat

/obj/item/weapon/implant/backup/implanted(var/mob/living/carbon/human/H)
	..()
	if(istype(H))
		my_record = new(H,src,1)
		return 1

//The glass case for the implant
/obj/item/weapon/implantcase/backup
	name = "glass case - 'backup'"
	desc = "A case containing a backup implant."
	icon_state = "implantcase-b"

/obj/item/weapon/implantcase/backup/New()
	src.imp = new /obj/item/weapon/implant/backup(src)
	..()
	return

//The box of backup implants
/obj/item/weapon/storage/box/backup_kit
	name = "backup implant kit"
	desc = "Box of stuff used to implant backup implants."
	icon_state = "implant"
	item_state_slots = list(slot_r_hand_str = "syringe_kit", slot_l_hand_str = "syringe_kit")

/obj/item/weapon/storage/box/backup_kit/New()
	..()
	for(var/i = 1 to 7)
		new /obj/item/weapon/implantcase/backup(src)
	new /obj/item/weapon/implanter(src)