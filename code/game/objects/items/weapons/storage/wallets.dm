/obj/item/weapon/storage/wallet
	name = "wallet"
	desc = "It can hold a few small and personal things."
	storage_slots = 10
	icon = 'icons/obj/wallet.dmi'
	icon_state = "wallet-orange"
	w_class = ITEMSIZE_SMALL
	can_hold = list(
		/obj/item/weapon/spacecash,
		/obj/item/weapon/card,
		/obj/item/clothing/mask/smokable/cigarette/,
		/obj/item/device/flashlight/pen,
		/obj/item/device/tape,
		/obj/item/weapon/cartridge,
		/obj/item/device/encryptionkey,
		/obj/item/seeds,
		/obj/item/stack/medical,
		/obj/item/weapon/coin,
		/obj/item/weapon/dice,
		/obj/item/weapon/disk,
		/obj/item/weapon/implanter,
		/obj/item/weapon/flame/lighter,
		/obj/item/weapon/flame/match,
		/obj/item/weapon/forensics,
		/obj/item/weapon/glass_extra,
		/obj/item/weapon/haircomb,
		/obj/item/weapon/hand,
		/obj/item/weapon/key,
		/obj/item/weapon/lipstick,
		/obj/item/weapon/paper,
		/obj/item/weapon/pen,
		/obj/item/weapon/photo,
		/obj/item/weapon/reagent_containers/dropper,
		/obj/item/weapon/sample,
		/obj/item/weapon/tool/screwdriver,
		/obj/item/weapon/stamp,
		/obj/item/clothing/accessory/permit,
		/obj/item/clothing/accessory/badge,
		/obj/item/weapon/makeover
		)
	cant_hold = list(/obj/item/weapon/tool/screwdriver/power)
	slot_flags = SLOT_ID

	var/obj/item/weapon/card/id/front_id = null

	drop_sound = 'sound/items/drop/leather.ogg'
	pickup_sound = 'sound/items/pickup/leather.ogg'

	var/original_name // Due to loadout customizations and such

/obj/item/weapon/storage/wallet/remove_from_storage(obj/item/W as obj, atom/new_location)
	. = ..(W, new_location)
	if(.)
		if(W == front_id)
			front_id = null
			name = original_name || initial(name)
			update_icon()

/obj/item/weapon/storage/wallet/handle_item_insertion(obj/item/W as obj, prevent_warning = 0)
	. = ..(W, prevent_warning)
	if(.)
		if(!front_id && istype(W, /obj/item/weapon/card/id))
			front_id = W
			if(!original_name)
				original_name = name
			name = "[original_name] ([front_id])"
			update_icon()

<<<<<<< HEAD
/obj/item/weapon/storage/wallet/update_icon()
=======
/obj/item/storage/wallet/update_icon()
>>>>>>> 2a494dcb666... Merge pull request #8530 from Spookerton/cerebulon/ssoverlay
	cut_overlays()
	if(front_id)
		var/tiny_state = "id-generic"
		if("id-[front_id.icon_state]" in cached_icon_states(icon))
			tiny_state = "id-"+front_id.icon_state
		var/image/tiny_image = new/image(icon, icon_state = tiny_state)
		tiny_image.appearance_flags = RESET_COLOR
		add_overlay(tiny_image)

/obj/item/weapon/storage/wallet/GetID()
	return front_id

/obj/item/weapon/storage/wallet/GetAccess()
	var/obj/item/I = GetID()
	if(I)
		return I.GetAccess()
	else
		return ..()

/obj/item/weapon/storage/wallet/random/New()
	..()
	var/amount = rand(50, 100) + rand(50, 100) // Triangular distribution from 100 to 200
	var/obj/item/weapon/spacecash/SC = null
	SC = new(src)
	for(var/i in list(100, 50, 20, 10, 5, 1))
		if(amount < i)
			continue
		while(amount >= i)
			amount -= i
			SC.adjust_worth(i, 0)
		SC.update_icon()

/obj/item/weapon/storage/wallet/poly
	name = "polychromic wallet"
	desc = "You can recolor it! Fancy! The future is NOW!"
	icon_state = "wallet-white"

/obj/item/weapon/storage/wallet/poly/New()
	..()
	verbs |= /obj/item/weapon/storage/wallet/poly/proc/change_color
	color = "#"+get_random_colour()
	update_icon()

/obj/item/weapon/storage/wallet/poly/proc/change_color()
	set name = "Change Wallet Color"
	set category = "Object"
	set desc = "Change the color of the wallet."
	set src in usr

	if(usr.stat || usr.restrained() || usr.incapacitated())
		return

	var/new_color = input(usr, "Pick a new color", "Wallet Color", color) as color|null

	if(new_color && (new_color != color))
		color = new_color

/obj/item/weapon/storage/wallet/poly/emp_act()
	var/original_state = icon_state
	icon_state = "wallet-emp"
	update_icon()

	spawn(200)
		if(src)
			icon_state = original_state
			update_icon()

/obj/item/weapon/storage/wallet/womens
	name = "women's wallet"
	desc = "A stylish wallet typically used by women."
	icon_state = "girl_wallet"
	item_state_slots = list(slot_r_hand_str = "wowallet", slot_l_hand_str = "wowallet")

//Casino Wallet

/obj/item/weapon/storage/wallet/casino
	name = "casino wallet"
	desc = "A fancy casino wallet with flashy lights, oooh~"
	icon = 'icons/obj/casino.dmi'
	icon_state = "casinowallet_black"
	can_hold = list(
		/obj/item/weapon/spacecash,
		/obj/item/weapon/card,
		/obj/item/clothing/mask/smokable/cigarette/,
		/obj/item/device/flashlight/pen,
		/obj/item/device/tape,
		/obj/item/weapon/cartridge,
		/obj/item/device/encryptionkey,
		/obj/item/seeds,
		/obj/item/stack/medical,
		/obj/item/weapon/coin,
		/obj/item/weapon/dice,
		/obj/item/weapon/disk,
		/obj/item/weapon/implanter,
		/obj/item/weapon/flame/lighter,
		/obj/item/weapon/flame/match,
		/obj/item/weapon/forensics,
		/obj/item/weapon/glass_extra,
		/obj/item/weapon/haircomb,
		/obj/item/weapon/hand,
		/obj/item/weapon/key,
		/obj/item/weapon/lipstick,
		/obj/item/weapon/paper,
		/obj/item/weapon/pen,
		/obj/item/weapon/photo,
		/obj/item/weapon/reagent_containers/dropper,
		/obj/item/weapon/sample,
		/obj/item/weapon/tool/screwdriver,
		/obj/item/weapon/stamp,
		/obj/item/clothing/accessory/permit,
		/obj/item/clothing/accessory/badge,
		/obj/item/weapon/makeover,
		/obj/item/weapon/spacecasinocash,
		/obj/item/weapon/casino_platinum_chip,
		/obj/item/weapon/deck
		)

/obj/item/weapon/storage/wallet/casino/verb/toggle_design()
	set category = "Object"
	set name = "Toggle design"
	set src in usr

	if (icon_state == "casinowallet_black")
		icon_state = "casinowallet_brown"
		return
	if (icon_state == "casinowallet_brown")
		icon_state = "casinowallet_white"
		return
	else
		icon_state = "casinowallet_black"