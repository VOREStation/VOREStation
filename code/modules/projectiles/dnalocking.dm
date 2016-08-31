/obj/item/dnalockingchip
	name = "DNA Chip Lock"
	icon = 'icons/obj/ammo.dmi'
	icon_state = "dnalockchip"
	w_class = 1
	var/safety_level = 0
	origin_tech = list(TECH_COMBAT = 4, TECH_DATA = 4, TECH_BIO = 4)



/obj/item/weapon/gun/proc/get_dna(mob/user)
	var/mob/living/M = user
	if(!controller_lock)

		if(!stored_dna && !(M.dna in stored_dna))
			M << "<span class='warning'>\The [src] buzzes and displays a symbol showing the gun already contains your DNA.</span>"
			return 0
		else
			stored_dna += M.dna
			M << "<span class='notice'>\The [src] pings and a needle flicks out from the grip, taking a DNA sample from you.</span>"
			if(!controller_dna)
				controller_dna = M.dna
				M << "<span class='notice'>\The [src] processes the dna sample and pings, acknowledging you as the primary controller.</span>"
			return 1
	else
		M << "<span class='warning'>\The [src] buzzes and displays a locked symbol. It is not allowing DNA samples at this time.</span>"
		return 0

/obj/item/weapon/gun/verb/give_dna()
	set name = "Give DNA"
	set category = "Object"
	set src in usr
	get_dna(usr)

/obj/item/weapon/gun/proc/clear_dna(mob/user)
	var/mob/living/M = user
	if(!controller_lock)
		if(!authorized_user(M))
			M << "<span class='warning'>\The [src] buzzes and displays an invalid user symbol.</span>"
			return 0
		else
			stored_dna -= user.dna
			M << "<span class='notice'>\The [src] beeps and clears the DNA it has stored.</span>"
			if(M.dna == controller_dna)
				controller_dna = null
				M << "<span class='notice'>\The [src] beeps and removes you as the primary controller.</span>"
				if(controller_lock)
					controller_lock = 0
			return 1
	else
		M << "<span class='warning'>\The [src] buzzes and displays a locked symbol. It is not allowing DNA modifcation at this time.</span>"
		return 0

/obj/item/weapon/gun/verb/remove_dna()
	set name = "Remove DNA"
	set category = "Object"
	set src in usr
	clear_dna(usr)

/obj/item/weapon/gun/proc/toggledna(mob/user)
	var/mob/living/M = user
	if(authorized_user(M) && user.dna == controller_dna)
		if(!controller_lock)
			controller_lock = 1
			M << "<span class='notice'>\The [src] beeps and displays a locked symbol, informing you it will no longer allow DNA samples.</span>"
		else
			controller_lock = 0
			M << "<span class='notice'>\The [src] beeps and displays an unlocked symbol, informing you it will now allow DNA samples.</span>"
	else
		M << "<span class='warning'>\The [src] buzzes and displays an invalid user symbol.</span>"

/obj/item/weapon/gun/verb/allow_dna()
	set name = "Toggle DNA Samples Allowance"
	set category = "Object"
	set src in usr
	toggledna(usr)

/obj/item/weapon/gun/proc/authorized_user(mob/user)
	if(!stored_dna || !stored_dna.len)
		return 1
	if(!(user.dna in stored_dna))
		return 0
	return 1