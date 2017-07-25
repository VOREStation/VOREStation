////////////////////////////////
//// Resleeving implant
//// for both organic and synthetic crew
////////////////////////////////

//The backup implant itself
/obj/item/weapon/implant/backup
	name = "backup implant"
	desc = "A mindstate backup implant that occasionally stores a copy of one's mind on a central server for backup purposes."
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "backup_implant"
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

		if(H.mind && H.stat < DEAD) //One right now, on implanting.
			SStranscore.m_backup(H.mind)
			last_attempt = world.time

		backup()

		return 1

/obj/item/weapon/implant/backup/proc/backup()
	last_attempt = world.time
	var/mob/living/carbon/human/H = loc

	//We're in a human, at least.
	if(istype(H))
		BITSET(H.hud_updateflag, BACKUP_HUD)
		//Okay we've got a mind at least
		if(H == imp_in && H.mind && H.stat < DEAD)
			SStranscore.m_backup(H.mind,H.nif)
			persist_nif_data(H)

	spawn(attempt_delay)
		backup()

//New, modern implanter instead of old style implanter.
/obj/item/weapon/backup_implanter
	name = "backup implanter"
	desc = "After discovering that Nanotrasen was just re-using the same implanters over and over again on organics, leading to cross-contamination, Kitsuhana Heavy industries designed this self-cleaning model. Holds four backup implants at a time."
	icon = 'icons/obj/device_alt.dmi'
	icon_state = "bimplant"
	item_state = "syringe_0"
	throw_speed = 1
	throw_range = 5
	w_class = ITEMSIZE_SMALL
	matter = list(DEFAULT_WALL_MATERIAL = 2000, "glass" = 2000)
	var/obj/item/weapon/implant/backup/list/imps = list()
	var/max_implants = 4 //Iconstates need to exist due to the update proc!

/obj/item/weapon/backup_implanter/New()
	..()
	for(var/i = 1 to max_implants)
		var/obj/item/weapon/implant/backup/imp = new(src)
		imps |= imp
		imp.germ_level = 0
	update()

/obj/item/weapon/backup_implanter/proc/update()
	icon_state = "[initial(icon_state)][imps.len]"
	germ_level = 0

/obj/item/weapon/backup_implanter/attack_self(mob/user as mob)
	if(!istype(user))
		return

	if(imps.len)
		user << "<span class='notice'>You eject a backup implant.</span>"
		var/obj/item/weapon/implant/backup/imp = imps[imps.len]
		imp.forceMove(get_turf(user))
		imps -= imp
		user.put_in_any_hand_if_possible(imp)
		update()
	else
		user << "<span class='warning'>\The [src] is empty.</span>"

	return

/obj/item/weapon/backup_implanter/attackby(obj/W, mob/user)
	if(istype(W,/obj/item/weapon/implant/backup))
		if(imps.len < max_implants)
			user.unEquip(W)
			imps |= W
			W.germ_level = 0
			W.forceMove(src)
			update()
			user << "<span class='notice'>You load \the [W] into \the [src].</span>"
		else
			user << "<span class='warning'>\The [src] is already full!</span>"

/obj/item/weapon/backup_implanter/attack(mob/M as mob, mob/user as mob)
	if (!istype(M, /mob/living/carbon))
		return
	if (user && imps.len)
		M.visible_message("<span class='notice'>[user] is injecting a backup implant into [M].</span>")

		user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
		user.do_attack_animation(M)

		var/turf/T1 = get_turf(M)
		if (T1 && ((M == user) || do_after(user, 5 SECONDS, M)))
			if(user && M && (get_turf(M) == T1) && src && src.imps.len)
				M.visible_message("<span class='notice'>[M] has been backup implanted by [user].</span>")

				var/obj/item/weapon/implant/backup/imp = imps[imps.len]
				if(imp.implanted(M))
					imp.forceMove(M)
					imps -= imp
					imp.imp_in = M
					imp.implanted = 1
					admin_attack_log(user, M, "Implanted using \the [src.name] ([imp.name])", "Implanted with \the [src.name] ([imp.name])", "used an implanter, [src.name] ([imp.name]), on")
					if (ishuman(M))
						var/mob/living/carbon/human/H = M
						var/obj/item/organ/external/affected = H.get_organ(user.zone_sel.selecting)
						affected.implants += imp
						imp.part = affected
						BITSET(H.hud_updateflag, BACKUP_HUD)

				update()

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
