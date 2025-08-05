//no, I don't want or expect these to be roundstart. These are just for parity w/ the old augment system.
/obj/item/endoware/item_storage/rifle
	name = "Embedded Rifle"
	desc = "An egregiously less-than-legal implant that enables the storage of an entire (Albeit heavily modified) laser rifle."
	image_text = "RIFLE"
	starts_with = list(
		/obj/item/gun/energy/laser/mounted/augment)

/obj/item/endoware/item_storage/mantis
	name = "Arm Blade"
	desc = "TODO: Name me"
	image_text = "BLADE"
	starts_with = list(
		/obj/item/melee/augment/blade/arm
	)

/obj/item/endoware/item_storage/mantlet
	name = "Hand Blade"
	desc = "TODO: Name me"
	image_text = "BLADE"
	allowed_in = list(BP_L_HAND,BP_R_HAND)
	starts_with = list(
		/obj/item/melee/augment/blade
	)
//probably shouldn't have this here at all tbh
/obj/item/endoware/item_storage/esword
	name = "integrated energy blade projector"
	desc = "fsdfsd TODO"
	image_text = "ESWORD"
	starts_with = list(/obj/item/melee/energy/sword)

/obj/item/endoware/item_storage/robocop
	name = "Thigh Holster"
	desc = "Fsdfsdfsd. TODO"
	allowed_in = list(BP_L_LEG,BP_R_LEG)
	image_text = "GUN"
	starts_with = list(/obj/item/gun/energy/stunrevolver/detective)

//shitpost. put it in redgates for the loot goblins to get what they deserve.
/obj/item/endoware/item_storage/grenade  //TODO: EMP sets them off.
	name = "Integrated Grenade Magazine"
	desc = "A complicated fixture; replacing much of the structure of someone's forearm. It has all the systems needed for deploying and returning grenades to storage via impossibly durable monofilament line. there's an egregious amount of warnings about proper usage."
	image_text = "NADE"
	starts_with = list(/obj/item/grenade/explosive,/obj/item/grenade/explosive,/obj/item/grenade/explosive,/obj/item/grenade/explosive)

/obj/item/endoware/item_storage/grenade/get_return_message(var/obj/item/returning,var/mob/user)
	var/obj/item/grenade/potential = returning
	if(istype(potential))
		if(potential && potential.active)
			return span_notice("[returning] snaps back into its slot! ") + span_boldwarning("FUCK! FUCK!!!")
	return ..()
