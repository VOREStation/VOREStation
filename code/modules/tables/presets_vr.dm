/obj/structure/table/darkglass
	name = "darkglass table"
	desc = "Shiny!"
	icon = 'icons/obj/tables_vr.dmi'
	icon_state = "darkglass_table_preview"
	flipped = -1
	can_reinforce = FALSE
	can_plate = FALSE

/obj/structure/table/darkglass/New()
	material = get_material_by_name("darkglass")
	verbs -= /obj/structure/table/verb/do_flip
	verbs -= /obj/structure/table/proc/do_put
	
	..()

/obj/structure/table/darkglass/dismantle(obj/item/weapon/wrench/W, mob/user)
	to_chat(user, "<span class='warning'>You cannot dismantle \the [src].</span>")
	return
/obj/structure/table/alien/blue
	icon = 'icons/turf/shuttle_alien_blue.dmi'
