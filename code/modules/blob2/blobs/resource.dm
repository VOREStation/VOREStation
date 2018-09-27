/obj/structure/blob/resource
	name = "resource blob"
	base_name = "resource blob"
	icon = 'icons/mob/blob.dmi'
	icon_state = "blob_resource"
	desc = "A thin spire of slightly swaying tendrils."
	max_integrity = 40
	point_return = 15
	var/resource_delay = 0
	var/resource_cooldown = 4 SECONDS

/obj/structure/blob/resource/New(var/newloc, var/new_overmind)
	..(newloc, new_overmind)
	if(overmind)
		overmind.resource_blobs += src

/obj/structure/blob/resource/Destroy()
	if(overmind)
		overmind.resource_blobs -= src
	return ..()

/obj/structure/blob/resource/pulsed()
	. = ..()
	if(resource_delay > world.time)
		return
	flick("blob_resource_glow", src)
	if(overmind)
		overmind.add_points(1)
		resource_delay = world.time + resource_cooldown + (overmind.resource_blobs.len * 2.5) //4 seconds plus a quarter second for each resource blob the overmind has
	else
		resource_delay = world.time + resource_cooldown

/obj/structure/blob/resource/sluggish // Tankier, but really slow.
	name = "sluggish resource blob"
	desc = "A thin spire of occasionally convulsing tendrils."
	max_integrity = 80
	resource_cooldown = 8 SECONDS
