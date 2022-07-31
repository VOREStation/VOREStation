/obj/structure/table/rack
	name = "rack"
	desc = "Different from the Middle Ages version."
	icon = 'icons/obj/objects.dmi'
	icon_state = "rack"
	can_plate = 0
	can_reinforce = 0
	flipped = -1

/obj/structure/table/rack/Initialize()
	. = ..()
	verbs -= /obj/structure/table/verb/do_flip
	verbs -= /obj/structure/table/proc/do_put

/obj/structure/table/rack/update_connections()
	return

/obj/structure/table/rack/update_desc()
	return

/obj/structure/table/rack/update_icon()
	if(material) //VOREStation Add for rack colors based on materials
		color = material.icon_colour
	return

/obj/structure/table/rack/holorack/dismantle(obj/item/tool/wrench/W, mob/user)
	to_chat(user, "<span class='warning'>You cannot dismantle \the [src].</span>")
	return

/obj/structure/table/rack/steel
	color = "#666666"

/obj/structure/table/rack/steel/Initialize()
	material = get_material_by_name(MAT_STEEL)
	. = ..()

//Shelves

/obj/structure/table/rack/shelf
	name = "shelving"
	desc = "Some nice metal shelves."
	icon_state = "shelf"

/obj/structure/table/rack/shelf/steel
	color = "#666666"

/obj/structure/table/rack/shelf/steel/Initialize()
	material = get_material_by_name(MAT_STEEL)
	. = ..()

//Gunrack
// SOMEONE should add cool overlay stuff to this
/obj/structure/table/rack/gun_rack
	name = "gun rack"
	desc = "Seems like you could prop up some rifles here."
	icon_state = "gunrack"

/obj/structure/table/rack/gun_rack/steel
	color = "#666666"

/obj/structure/table/rack/gun_rack/steel/Initialize()
	material = get_material_by_name(MAT_STEEL)
	. = ..()