/obj/structure/bed/chair/sofa
	name = "sofa"
	desc = "A padded, comfy sofa. Great for lazing on."
	base_icon = "sofamiddle"

/obj/structure/bed/chair/sofa/left
	base_icon = "sofaend_left"

/obj/structure/bed/chair/sofa/right
	base_icon = "sofaend_right"

/obj/structure/bed/chair/sofa/corner
	base_icon = "sofacorner"

/obj/structure/bed/chair/sofa/corner/update_layer()
	if(src.dir == NORTH || src.dir == WEST)
		plane = MOB_PLANE
		layer = MOB_LAYER + 0.1
	else
		reset_plane_and_layer()