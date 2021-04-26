/obj/item/weapon/reagent_containers/spray/windowsealant
	name = "Krak-b-gone"
	desc = "A spray bottle of silicate sealant for rapid window repair."
	icon = 'icons/obj/items_vr.dmi'
	icon_state = "windowsealant"
	item_state = "spraycan"
	possible_transfer_amounts = null
	volume = 80

/obj/item/weapon/reagent_containers/spray/windowsealant/New()
	..()
	reagents.add_reagent("silicate", 80)


/obj/item/weapon/reagent_containers/spray/chemsprayer
	name = "chem sprayer"
	desc = "A utility used to spray large amounts of reagent in a given area."
	icon = 'icons/obj/gun_vr.dmi'
	icon_state = "chemsprayer"
	item_state = "chemsprayer"
	item_icons = list(slot_l_hand_str = 'icons/mob/items/lefthand_vr.dmi', slot_r_hand_str = 'icons/mob/items/righthand_vr.dmi')