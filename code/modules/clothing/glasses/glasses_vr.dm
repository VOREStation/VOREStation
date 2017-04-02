/obj/item/clothing/glasses/proc/prescribe(var/mob/user)
	prescription = !prescription

	//Look it's really not that fancy. It's not ACTUALLY unique scrip data.
	if(prescription)
		name = "[initial(name)] (pr)"
		user.visible_message("[user] replaces the lenses in \the [src] with a new prescription.")
	else
		name = "[initial(name)]"
		user.visible_message("[user] replaces the prescription lenses in \the [src] with generics.")

	playsound(user,'sound/items/screwdriver.ogg', 50, 1)

//Prescription kit
/obj/item/device/glasses_kit
	name = "prescription glasses kit"
	desc = "A kit containing all the needed tools and parts to develop and apply a prescription for someone."
	icon = 'icons/obj/device.dmi'
	icon_state = "modkit"
	var/scrip_loaded = 0

/obj/item/device/glasses_kit/afterattack(var/target, var/mob/living/carbon/human/user, var/proximity)
	if(!proximity)
		return
	if(!istype(user))
		return

	//Too difficult
	if(target == user)
		user << "<span class='warning'>You can't use this on yourself. Get someone to help you.</span>"
		return

	//We're applying a prescription
	if(istype(target,/obj/item/clothing/glasses))
		var/obj/item/clothing/glasses/G = target
		if(!scrip_loaded)
			user << "<span class='warning'>You need to build a prescription from someone first! Use the kit on someone.</span>"
			return

		if(do_after(user,5 SECONDS))
			G.prescribe(user)
			scrip_loaded = 0

	//We're getting a prescription
	else if(ishuman(target))
		var/mob/living/carbon/human/T = target
		if(T.glasses || (T.head && T.head.flags_inv & HIDEEYES))
			user << "<span class='warning'>The person's eyes can't be covered!</span>"
			return

		T.visible_message("[user] begins making measurements for prescription lenses for [target].","[user] begins measuring your eyes. Hold still!")
		if(do_after(user,5 SECONDS,T))
			T.flash_eyes()
			scrip_loaded = 1
			T.visible_message("[user] finishes making prescription lenses for [target].","<span class='warning'>Gah, that's bright!</span>")

	else
		..()
