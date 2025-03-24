//Pumpkins
/obj/structure/flora/pumpkin
	name = "pumpkin"
	icon = 'icons/obj/flora/pumpkins.dmi'
	desc = "A healthy, fat pumpkin. It looks as if it was freshly plucked from its vines and shows no signs of decay."
	icon_state = "decor-pumpkin"

/obj/effect/landmark/carved_pumpkin_spawn
	name = "jack o'lantern spawn"
	icon = 'icons/obj/flora/pumpkins.dmi'
	icon_state = "spawner-jackolantern"

/obj/effect/landmark/carved_pumpkin_spawn/Initialize(mapload)
	..()
	var/new_pumpkin = pick(
		prob(70);/obj/structure/flora/pumpkin,
		prob(60);/obj/structure/flora/pumpkin/carved,
		prob(30);/obj/structure/flora/pumpkin/carved/scream,
		prob(30);/obj/structure/flora/pumpkin/carved/girly,
		prob(10);/obj/structure/flora/pumpkin/carved/owo)
	new new_pumpkin(src.loc)
	return INITIALIZE_HINT_QDEL

/obj/structure/flora/pumpkin/carved
	name = "jack o'lantern"
	desc = "A fat, freshly picked pumpkin. This one has a face carved into it! This one has develishly evil-looking eyes and a grinning mouth more than big enough for a very small person to hide in."
	icon_state = "decor-jackolantern"

/obj/structure/flora/pumpkin/carved/scream
	desc = "A fat, freshly picked pumpkin. This one has a face carved into it! This one has rounded eyes looking in completely opposite directions and a wide mouth, forever frozen in a silent scream. It looks ridiculous, actually."
	icon_state = "decor-jackolantern-scream"

/obj/structure/flora/pumpkin/carved/girly
	desc = "A fat, freshly picked pumpkin. This one has a face carved into it! This one has neatly rounded eyes topped with what appear to be cartoony eyelashes, completed with what seems to have been the carver's attempt at friendly, toothy smile. The mouth is easily the scariest part of its face."
	icon_state = "decor-jackolantern-girly"

/obj/structure/flora/pumpkin/carved/owo
	desc = "A fat, freshly picked pumpkin. This one has a face carved into it! This one has large, round eyes and a squiggly, cat-like smiling mouth. Its pleasantly surprised expression seems to suggest that the pumpkin has noticed something about you."
	icon_state = "decor-jackolantern-owo"

// Various decorá
/obj/structure/flora/log1
	name = "waterlogged trunk"
	icon = 'icons/obj/flora/amayastuff.dmi'
	desc = "A part of a felled tree. Moss is growing across it."
	icon_state = "log1"

/obj/structure/flora/log2
	name = "driftwood"
	icon = 'icons/obj/flora/amayastuff.dmi'
	desc = "Driftwood carelessly lost in the water."
	icon_state = "log2"

/obj/structure/flora/lily1
	name = "red flowered lilypads"
	icon = 'icons/obj/flora/amayastuff.dmi'
	desc = "A bunch of lilypads. A beautiful red flower grows in the middle of them."
	icon_state = "lilypad1"

/obj/structure/flora/lily2
	name = "yellow flowered lilypads"
	icon = 'icons/obj/flora/amayastuff.dmi'
	desc = "A few lilypads. A sunny yellow flower stems from the water and from between the lilypads."
	icon_state = "lilypad2"

/obj/structure/flora/lily3
	name = "lilypads"
	icon = 'icons/obj/flora/amayastuff.dmi'
	desc = "A group of flowerless lilypads."
	icon_state = "lilypad3"

/obj/structure/flora/smallbould
	name = "small boulder"
	icon = 'icons/obj/flora/amayastuff.dmi'
	desc = "A small boulder, with its top smothered with moss."
	icon_state = "smallerboulder"

/obj/structure/flora/bboulder1
	name = "large boulder"
	icon = 'icons/obj/flora/amayastuff.dmi'
	desc = "Small stones sit beside this large boulder. Moss grows on the top of each of them."
	icon_state = "bigboulder1"
	density = TRUE

/obj/structure/flora/bboulder2
	name = "jagged large boulder"
	icon = 'icons/obj/flora/amayastuff.dmi'
	desc = "This boulder has had plates broken off it. Moss grows in the cracks and across the top."
	icon_state = "bigboulder2"
	density = TRUE

/obj/structure/flora/rocks1
	name = "rocks"
	icon = 'icons/obj/flora/amayastuff.dmi'
	desc = "A bunch of mossy rocks."
	icon_state = "rocks1"

/obj/structure/flora/rocks2
	name = "rocks"
	icon = 'icons/obj/flora/amayastuff.dmi'
	desc = "A bunch of mossy rocks."
	icon_state = "rocks2"
