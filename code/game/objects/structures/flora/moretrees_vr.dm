/obj/structure/flora/tree/bigtree
	icon = 'icons/obj/flora/moretrees_vr.dmi'
	icon_state = "bigtree1"
	base_state = "tree"
	product = /obj/item/stack/material/log
	product_amount = 20
	health = 2000
	max_health = 2000
	pixel_x = -65
	pixel_y = -8
	layer = MOB_LAYER - 1
	shake_animation_degrees = 2

/obj/structure/flora/tree/bigtree/choose_icon_state()
	return "[base_state][rand(1, 4)]"

/obj/structure/flora/tree/bigtree/Initialize()
	. = ..()

	var/image/i = image('icons/obj/flora/moretrees_vr.dmi', "[icon_state]-b")
	i.plane = ABOVE_MOB_PLANE
	add_overlay(i)