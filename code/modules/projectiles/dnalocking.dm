/obj/item/dnalockingchip
	name = "DNA Chip Lock"
	icon = 'icons/obj/ammo.dmi'
	icon_state = "dnalockchip"
	desc = "A state of the art technological chip that can be installed in a firearm. It allows the user to store their DNA and lock the gun's use from unwanted users."
	w_class = ITEMSIZE_TINY
	origin_tech = list(TECH_COMBAT = 4, TECH_DATA = 4, TECH_BIO = 4)

	var/list/stored_dna = list()	//list of the dna stored in the gun, used to allow users to use it or not
	var/safety_level = 0			//either 0 or 1, at 0 the game buzzes and tells the user they can't use it, at 1 it self destructs after 10 seconds
	var/controller_dna = null		//The dna of the person who is the primary controller of the gun
	var/controller_lock = 0			//whether or not the gun is locked by the primar controller, 0 or 1, at 1 it is locked and does not allow
	var/exploding = 0


/obj/item/weapon/gun/proc/get_dna(mob/user)
	var/mob/living/M = user
	if(!attached_lock.controller_lock)

		if(!attached_lock.stored_dna && !(M.dna in attached_lock.stored_dna))
			to_chat(M, "<span class='warning'>\The [src] buzzes and displays a symbol showing the gun already contains your DNA.</span>")
			return 0
		else
			attached_lock.stored_dna += M.dna
			to_chat(M, "<span class='notice'>\The [src] pings and a needle flicks out from the grip, taking a DNA sample from you.</span>")
			if(!attached_lock.controller_dna)
				attached_lock.controller_dna = M.dna
				to_chat(M, "<span class='notice'>\The [src] processes the dna sample and pings, acknowledging you as the primary controller.</span>")
			return 1
	else
		to_chat(M, "<span class='warning'>\The [src] buzzes and displays a locked symbol. It is not allowing DNA samples at this time.</span>")
		return 0

/obj/item/weapon/gun/verb/give_dna()
	set name = "Give DNA"
	set category = "Object"
	set src in usr
	get_dna(usr)

/obj/item/weapon/gun/proc/clear_dna(mob/user)
	var/mob/living/M = user
	if(!attached_lock.controller_lock)
		if(!authorized_user(M))
			to_chat(M, "<span class='warning'>\The [src] buzzes and displays an invalid user symbol.</span>")
			return 0
		else
			attached_lock.stored_dna -= user.dna
			to_chat(M, "<span class='notice'>\The [src] beeps and clears the DNA it has stored.</span>")
			if(M.dna == attached_lock.controller_dna)
				attached_lock.controller_dna = null
				to_chat(M, "<span class='notice'>\The [src] beeps and removes you as the primary controller.</span>")
				if(attached_lock.controller_lock)
					attached_lock.controller_lock = 0
			return 1
	else
		to_chat(M, "<span class='warning'>\The [src] buzzes and displays a locked symbol. It is not allowing DNA modifcation at this time.</span>")
		return 0

/obj/item/weapon/gun/verb/remove_dna()
	set name = "Remove DNA"
	set category = "Object"
	set src in usr
	clear_dna(usr)

/obj/item/weapon/gun/proc/toggledna(mob/user)
	var/mob/living/M = user
	if(authorized_user(M) && user.dna == attached_lock.controller_dna)
		if(!attached_lock.controller_lock)
			attached_lock.controller_lock = 1
			to_chat(M, "<span class='notice'>\The [src] beeps and displays a locked symbol, informing you it will no longer allow DNA samples.</span>")
		else
			attached_lock.controller_lock = 0
			to_chat(M, "<span class='notice'>\The [src] beeps and displays an unlocked symbol, informing you it will now allow DNA samples.</span>")
	else
		to_chat(M, "<span class='warning'>\The [src] buzzes and displays an invalid user symbol.</span>")

/obj/item/weapon/gun/verb/allow_dna()
	set name = "Toggle DNA Samples Allowance"
	set category = "Object"
	set src in usr
	toggledna(usr)

/obj/item/weapon/gun/proc/authorized_user(mob/user)
	if(!attached_lock.stored_dna || !attached_lock.stored_dna.len)
		return 1
	if(!(user.dna in attached_lock.stored_dna))
		return 0
	return 1