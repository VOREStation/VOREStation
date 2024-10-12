/*
 * Gram
 */
/obj/item/gun/projectile/contender
	name = "\improper \"Gram\" Contender"
	desc = "Hedberg-Hammarstrom's flagship one-shot hand-cannon. For when you \
	really want to make a hole. This one has been modified to work almost like \
	a bolt-action. Uses .357 rounds."
	description_fluff = "The Hedberg-Hammarstrom company offers a range of high-quality, \
	high-cost hunting rifles and shotguns designed with the Sivian wilderness - and its \
	wildlife - in mind. The company operates just one production plant in Kalmar, but \
	their weapons have found popularity on garden worlds as far afield as the Tajaran \
	homeworld due to their excellent build quality, precision, and stopping power."
	icon_state = "pockrifle"
	var/icon_retracted = "pockrifle-e"
	item_state = "revolver"
	caliber = ".357"
	handle_casings = HOLD_CASINGS
	max_shells = 1
	ammo_type = /obj/item/ammo_casing/a357
	projectile_type = /obj/item/projectile/bullet/pistol/strong
	var/retracted_bolt = 0
	load_method = SINGLE_CASING

/obj/item/gun/projectile/contender/attack_self(mob/user as mob)
	if(chambered)
		chambered.loc = get_turf(src)
		chambered = null
		var/obj/item/ammo_casing/C = loaded[1]
		loaded -= C

	if(!retracted_bolt)
		to_chat(user, span_notice("You cycle back the bolt on [src], ejecting the casing and allowing you to reload."))
		icon_state = icon_retracted
		retracted_bolt = 1
		return 1
	else if(retracted_bolt && loaded.len)
		to_chat(user, span_notice("You cycle the loaded round into the chamber, allowing you to fire."))
	else
		to_chat(user, span_notice("You cycle the boly back into position, leaving the gun empty."))
	icon_state = initial(icon_state)
	retracted_bolt = 0

/obj/item/gun/projectile/contender/load_ammo(var/obj/item/A, mob/user)
	if(!retracted_bolt)
		to_chat(user, span_notice("You can't load [src] without cycling the bolt."))
		return
	..()

/*
 * Balmung
 */
/obj/item/gun/projectile/contender/tacticool
	name = "\improper \"Balmung\" Contender"
	desc = "A later model of the Hedberg-Hammarstrom \"Gram\", reinvented with a \
	tactical look. For when you really want to make a hole. This one has been \
	modified to work almost like a bolt-action. Uses .357 rounds."
	icon_state = "pockrifle_b"
	icon_retracted = "pockrifle_b-e"
