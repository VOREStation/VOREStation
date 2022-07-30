/obj/item/implantcase/vrlanguage
	name = "glass case - 'language'"
	desc = "A case containing a language implant."
	icon_state = "implantcase-r"

/obj/item/implantcase/vrlanguage/New()
	src.imp = new /obj/item/implant/vrlanguage( src )
	..()
	return
