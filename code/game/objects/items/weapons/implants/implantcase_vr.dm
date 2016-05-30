/obj/item/weapon/implantcase/language
	name = "glass case - 'language'"
	desc = "A case containing a language implant."
	icon_state = "implantcase-r"

/obj/item/weapon/implantcase/language/New()
	src.imp = new /obj/item/weapon/implant/language( src )
	..()
	return