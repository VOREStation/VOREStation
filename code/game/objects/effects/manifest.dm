/obj/effect/manifest
	name = "manifest"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x"
	unacidable = TRUE//Just to be sure.

/obj/effect/manifest/Initialize(mapload)
	. = ..()

	invisibility = INVISIBILITY_ABSTRACT

/obj/effect/manifest/proc/manifest()
	var/dat = span_bold("Crew Manifest") + ":<BR>"
	for(var/mob/living/carbon/human/M in mob_list)
		dat += text("    <B>[]</B> -  []<BR>", M.name, M.get_assignment())
	var/obj/item/paper/P = new /obj/item/paper( src.loc )
	P.info = dat
	P.name = "paper- 'Crew Manifest'"
	//SN src = null
	qdel(src)
	return
