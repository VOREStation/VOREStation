/obj/item/weapon/implantcase/language/vrversion
	name = "glass case - 'language'"
	desc = "A case containing a language implant."
	icon_state = "implantcase-r"

/obj/item/weapon/implantcase/language/vrversion/New()
	src.imp = new /obj/item/weapon/implant/language/vrversion( src )
	..()
	return