/////////////////////////////////////////////////////////////////////////////////
// NT subtype
/////////////////////////////////////////////////////////////////////////////////
/obj/item/poster/nanotrasen // held object
	icon_state = "rolled_poster_nt"
	poster_type = /obj/structure/sign/poster/nanotrasen

/obj/item/poster/nanotrasen/Initialize(mapload, var/decl/poster/P = null)
	if(!ispath(poster_decl) && !ispath(P) && !istype(P))
		poster_decl = get_poster_decl(/decl/poster/nanotrasen, FALSE, null)
	return ..()

/obj/structure/sign/poster/nanotrasen // placed wall object
	roll_type = /obj/item/poster/nanotrasen


/////////////////////////////////////////////////////////////////////////////////
// Selectable "custom" subtype
/////////////////////////////////////////////////////////////////////////////////
/obj/item/poster/custom // held object
	name = "rolled-up poly-poster"
	desc = "The poster comes with its own automatic adhesive mechanism, for easy pinning to any vertical surface. This one is made from some kind of e-paper, and could display almost anything!"
	poster_type = /obj/structure/sign/poster/custom

/// Verb to change a custom poster's design
/obj/item/poster/custom/verb/select_poster()
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)
	set name = "Set Poster type"
	set category = "Object"
	set desc = "Click to choose a poster to display."

	var/mob/M = usr
	var/list/options = list()
	var/list/decl/poster/posters = decls_repository.get_decls_of_type(/decl/poster)
	for(var/option in posters)
		options[posters[option].name] = posters[option]

	var/choice = tgui_input_list(M, "Choose a poster!", "Customize Poster", options)
	if(src && choice && !M.stat && in_range(M,src))
		poster_decl = options[choice]
		name = "rolled-up poly-poster - [poster_decl.name]"
		to_chat(M, "The poster is now: [choice].")

// Wall object
/obj/structure/sign/poster/custom // placed wall object
	roll_type = /obj/item/poster/custom
