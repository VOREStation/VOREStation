/obj/item/weapon/reagent_containers/glass/bottle/ickypak
	name = "ickypak bottle"
	desc = "A small bottle of ickypak. The smell alone makes you gag."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle-3"

/obj/item/weapon/reagent_containers/glass/bottle/ickypak/New()
	..()
	reagents.add_reagent("ickypak", 60)
	update_icon()


/obj/item/weapon/reagent_containers/glass/bottle/unsorbitol
	name = "unsorbitol bottle"
	desc = "A small bottle of unsorbitol. Sickeningly sweet."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle-3"

/obj/item/weapon/reagent_containers/glass/bottle/unsorbitol/New()
	..()
	reagents.add_reagent("unsorbitol", 60)
	update_icon()
