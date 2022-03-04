

/obj/item/projectile/bullet/srmrocket
	name ="SRM-8 Rocket"
	desc = "Boom"
	icon = 'icons/obj/grenade.dmi'
	icon_state = "missile"
	damage = 30	//Meaty whack. *Chuckles*
	does_spin = 0

/obj/item/projectile/bullet/srmrocket/on_hit(atom/target, blocked=0)
	if(!isliving(target)) //if the target isn't alive, so is a wall or something
		explosion(target, 0, 1, 2, 4)
	else
		explosion(target, 0, 0, 2, 4)
	return 1

/obj/item/projectile/bullet/srmrocket/throw_impact(atom/target, var/speed)
	if(!isliving(target)) //if the target isn't alive, so is a wall or something
		explosion(target, 0, 1, 2, 4)
	else
		explosion(target, 0, 0, 2, 4)
	qdel(src)

/obj/item/projectile/bullet/srmrocket/weak	//Used in the jury rigged one.
	damage = 10

/obj/item/projectile/bullet/srmrocket/weak/on_hit(atom/target, blocked=0)
	explosion(target, 0, 0, 2, 4)//No need to have a question.
	return 1

/obj/item/projectile/bullet/srmrocket/weak/throw_impact(atom/target, var/speed)
	explosion(target, 0, 0, 2, 4)//No need to have a question.
	qdel(src)

/*Old vars here for reference.
	var/devastation = 0
	var/heavy_blast = 1
	var/light_blast = 2
	var/flash_blast = 4
*/
