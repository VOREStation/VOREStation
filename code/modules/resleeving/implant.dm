////////////////////////////////
//// Resleeving implant
//// for both organic and synthetic crew
////////////////////////////////

//The backup implant itself
/obj/item/weapon/implant/backup
	name = "backup implant"
	desc = "A mindstate backup implant that occasionally stores a copy of one's mind on a central server for backup purposes."
	var/last_attempt
	var/attempt_delay = 5 MINUTES

/obj/item/weapon/implant/backup/get_data()
	var/dat = {"
<b>Implant Specifications:</b><BR>
<b>Name:</b> [using_map.company_name] Employee Backup Implant<BR>
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
		var/obj/item/weapon/implant/backup/other_imp = locate(/obj/item/weapon/implant/backup,H)
		if(other_imp && other_imp.imp_in == H)
			qdel(other_imp) //implant fight

		if(H.mind) //One out here just in case they are dead
			transcore.m_backup(H.mind)
			last_attempt = world.time

		backup()

		return 1

/obj/item/weapon/implant/backup/proc/backup()
	last_attempt = world.time
	var/mob/living/carbon/human/H = loc

	//Okay we're in a human with a mind at least
	if(istype(H) && H == imp_in && H.mind && H.stat < DEAD)
		transcore.m_backup(H.mind)

	spawn(attempt_delay)
		backup()

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

//Purely for fluff
/obj/item/weapon/implant/backup/full
	name = "khi backup implant"
	desc = "A normal KHI wireless cortical stack with neutrino and QE transmission for constant-stream consciousness upload."
