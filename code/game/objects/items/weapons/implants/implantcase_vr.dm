/obj/item/weapon/implantcase/vrlanguage
	name = "glass case - 'language'"
	desc = "A case containing a language implant."
	icon_state = "implantcase-r"

/obj/item/weapon/implantcase/vrlanguage/New()
	src.imp = new /obj/item/weapon/implant/vrlanguage( src )
	..()
	return