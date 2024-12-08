/obj/item/reagent_containers/spray/windowsealant
	name = "Krak-b-gone"
	desc = "A spray bottle of silicate sealant for rapid window repair."
	icon = 'icons/obj/items_vr.dmi'
	icon_state = "windowsealant"
	item_state = "spraycan"
	possible_transfer_amounts = null
	volume = 80

/obj/item/reagent_containers/spray/windowsealant/New()
	..()
	reagents.add_reagent(REAGENT_ID_SILICATE, 80)
