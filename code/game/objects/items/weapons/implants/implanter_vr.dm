//Vorestation universal translator implant.

/obj/item/implanter/vrlanguage
	name = "implanter-language"

/obj/item/implanter/vrlanguage/Initialize(mapload)
	. = ..()
	imp = new /obj/item/implant/vrlanguage( src )
	update()
