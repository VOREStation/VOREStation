// Porting stack dragging/auto stacking from TG.

/obj/item/stack/proc/merge(obj/item/stack/S) //Merge src into S, as much as possible
	var/transfer = get_amount()
	transfer = min(transfer, S.max_amount - S.amount)
	if(pulledby)
		pulledby.start_pulling(S)
	transfer_fingerprints_to(S)
	if(blood_DNA)
		S.blood_DNA |= blood_DNA
	use(transfer)
	S.add(transfer)

/obj/item/stack/Crossed(var/atom/movable/AM)
	if(AM != src && istype(AM, src.type) && !AM.throwing)
		log_and_message_admins("AM is [AM] and source is [src] going ahead with merge.")
		merge(AM)
	return ..()