/obj/item/gun_new/proc/get_dna(mob/user)
	var/mob/living/M = user
	if(!attached_lock.controller_lock)

		if(attached_lock.stored_dna && (M.dna.unique_enzymes in attached_lock.stored_dna))
			to_chat(M, span_warning("\The [src] buzzes and displays a symbol showing the gun already contains your DNA."))
			return FALSE
		else if(ishuman(M))
			var/mob/living/carbon/human/human = user
			if(human.species.flags & NO_DNA)
				to_chat(human, span_warning("\The [src] buzzes and displays an NO DNA DETECTED symbol."))
				return FALSE
		else
			attached_lock.stored_dna += M.dna.unique_enzymes
			to_chat(M, span_notice("\The [src] pings and a needle flicks out from the grip, taking a DNA sample from you."))
			if(!attached_lock.controller_dna)
				attached_lock.controller_dna = M.dna.unique_enzymes
				to_chat(M, span_notice("\The [src] processes the dna sample and pings, acknowledging you as the primary controller."))
			return TRUE
	else
		to_chat(M, span_warning("\The [src] buzzes and displays a locked symbol. It is not allowing DNA samples at this time."))
		return FALSE

/obj/item/gun_new/verb/give_dna()
	set name = "Give DNA"
	set category = "Object"
	set src in usr
	get_dna(usr)

/obj/item/gun_new/proc/clear_dna(mob/user)
	var/mob/living/M = user
	if(!attached_lock.controller_lock)
		if(!authorized_user(M))
			to_chat(M, span_warning("\The [src] buzzes and displays an invalid user symbol."))
			return FALSE
		else
			attached_lock.stored_dna -= user.dna.unique_enzymes
			to_chat(M, span_notice("\The [src] beeps and clears the DNA it has stored."))
			if(M.dna.unique_enzymes == attached_lock.controller_dna)
				to_chat(M, span_notice("\The [src] beeps and removes you as the primary controller."))
				if(attached_lock.controller_lock)
					attached_lock.controller_lock = FALSE
			return TRUE
	else
		to_chat(M, span_warning("\The [src] buzzes and displays a locked symbol. It is not allowing DNA modifcation at this time."))
		return FALSE

/obj/item/gun_new/verb/remove_dna()
	set name = "Remove DNA"
	set category = "Object"
	set src in usr
	clear_dna(usr)

/obj/item/gun_new/proc/toggledna(mob/user)
	var/mob/living/M = user
	if(authorized_user(M) && user.dna.unique_enzymes == attached_lock.controller_dna)
		if(!attached_lock.controller_lock)
			attached_lock.controller_lock = TRUE
			to_chat(M, span_notice("\The [src] beeps and displays a locked symbol, informing you it will no longer allow DNA samples."))
		else
			attached_lock.controller_lock = FALSE
			to_chat(M, span_notice("\The [src] beeps and displays an unlocked symbol, informing you it will now allow DNA samples."))
	else
		to_chat(M, span_warning("\The [src] buzzes and displays an invalid user symbol."))

/obj/item/gun_new/verb/allow_dna()
	set name = "Toggle DNA Samples Allowance"
	set category = "Object"
	set src in usr
	toggledna(usr)

/obj/item/gun_new/proc/authorized_user(mob/user)
	if(!attached_lock.stored_dna || !attached_lock.stored_dna.len)
		return TRUE
	if(!(user.dna.unique_enzymes in attached_lock.stored_dna))
		return FALSE
	return TRUE

/obj/item/gun_new/proc/lock_explosion()
	explosion(src, 0, 0, 3, 4)
	QDEL_IN(src, 1)
