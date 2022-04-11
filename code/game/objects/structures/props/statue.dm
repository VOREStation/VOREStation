//Eris statues

/obj/structure/prop/statue
	name = "statue"
	desc = "It's art!"
	icon = 'icons/obj/props/decor.dmi'
	icon_state = "artwork_statue"

/obj/structure/prop/statue/statue1
	icon_state = "artwork_statue_1"

/obj/structure/prop/statue/statue2
	icon_state = "artwork_statue_2"

/obj/structure/prop/statue/statue3
	icon_state = "artwork_statue_3"

/obj/structure/prop/statue/statue4
	icon_state = "artwork_statue_4"

/obj/structure/prop/statue/statue5
	icon_state = "artwork_statue_5"

//TGMC Ship Mast

/obj/structure/prop/statue/stump_plaque
	name = "commemorative stump"
	desc = "A wooden stump adorned with a little plaque."
	icon = 'icons/obj/props/decor.dmi'
	icon_state = "stump"

//World Server statues

/obj/structure/prop/statue
	name = "statue"
	desc = "A statue."
	icon = 'icons/obj/props/decor32x64.dmi'
	icon_state = "venus"

/obj/structure/prop/statue/lion
	icon_state = "lion"

/obj/structure/prop/statue/angel
	icon = 'icons/obj/props/decor.dmi'
	icon_state = "angel"

/obj/structure/prop/statue/phoron
	name = "phoronic cascade"
	desc = "A sculpture made of pure phoron. It is covered in a lacquer that prevents erosion and renders it fireproof. It's safe. Probably."
	icon_state = "phoronic"
	layer = ABOVE_WINDOW_LAYER
	interaction_message = "<span class = 'notice'>Cool to touch and unbelievable smooth. You can almost see your reflection in it.</span>"

/obj/structure/prop/statue/phoron/New()
	set_light(2, 3, "#cc66ff")

/obj/structure/prop/statue/pillar
	name = "pillar"
	desc = "A pillar."
	icon_state = "pillar"

/obj/structure/prop/statue/pillar/dark
	name = "pillar"
	desc = "A dark pillar."
	icon_state = "dark_pillar"