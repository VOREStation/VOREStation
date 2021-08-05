/obj/structure/table/rack
	icon = 'icons/obj/objects_vr.dmi'

/obj/structure/table/rack/steel
	color = "#666666"

/obj/structure/table/rack/steel/New()
	material = get_material_by_name(MAT_STEEL)
	..()

/obj/structure/table/rack/shelf
	name = "shelving"
	desc = "Some nice metal shelves."
	icon_state = "shelf"

/obj/structure/table/rack/shelf/steel
	color = "#666666"

/obj/structure/table/rack/shelf/steel/New()
	material = get_material_by_name(MAT_STEEL)
	..()

// SOMEONE should add cool overlay stuff to this
/obj/structure/table/rack/gun_rack
	name = "gun rack"
	desc = "Seems like you could prop up some rifles here."
	icon_state = "gunrack"

/obj/structure/table/rack/gun_rack/steel
	color = "#666666"

/obj/structure/table/rack/gun_rack/steel/New()
	material = get_material_by_name(MAT_STEEL)
	..()