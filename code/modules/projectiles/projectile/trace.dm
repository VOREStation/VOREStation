// Helper proc to check if you can hit them or not.
// Will return a list of hit mobs/objects.
/proc/check_trajectory(atom/target as mob|obj, atom/firer as mob|obj, var/pass_flags=PASSTABLE|PASSGLASS|PASSGRILLE, flags=null)
	if(!istype(target) || !istype(firer))
		return 0

	var/obj/item/projectile/test/trace = new /obj/item/projectile/test(get_turf(firer)) //Making the test....

	//Set the flags and pass flags to that of the real projectile...
	if(!isnull(flags))
		trace.flags = flags
	trace.pass_flags = pass_flags

	return trace.launch_projectile(target) //Test it!

/obj/item/projectile/proc/_check_fire(atom/target as mob, var/mob/living/user as mob)  //Checks if you can hit them or not.
	if(target in check_trajectory(target, user, pass_flags, flags))
		return TRUE
	return FALSE

//"Tracing" projectile
/obj/item/projectile/test //Used to see if you can hit them.
	invisibility = INVISIBILITY_ABSTRACT //Nope!  Can't see me!
	hitscan = TRUE
	nodamage = TRUE
	damage = 0
	bump_targets = FALSE
	var/list/hit = list()

/obj/item/projectile/test/process_hitscan()
	. = ..()
	if(!QDELING(src))
		qdel(src)
	return hit

/obj/item/projectile/test/Bump(atom/A)
	if(A != src)
		hit |= A
	if(isturf(A))
		for(var/obj/O in A)
			hit |= A
		for(var/mob/living/M in A)
			hit |= A
	return ..()

/obj/item/projectile/test/fire(angle, atom/direct_target)
	. = ..()
	if(direct_target)
		if(direct_target != src)
			hit |= direct_target
		. = hit


/obj/item/projectile/test/attack_mob()
	return

//Don't generate tracers - they are generated on Destroy()
/obj/item/projectile/test/finalize_hitscan_and_generate_tracers()
	return
