/* Clown Items
 * Contains:
 * 		Banana Peels
 *		Soap
 *		Bike Horns
 */

/*
 * Banana Peels
 */
/obj/item/bananapeel/Crossed(atom/movable/AM as mob|obj)
	if(AM.is_incorporeal())
		return
	if(istype(AM, /mob/living))
		var/mob/living/M = AM
		M.slip("the [src.name]",4)
/*
 * Soap
 */
/obj/item/soap/Initialize()
	. = ..()
	create_reagents(5)
	wet()

/obj/item/soap/proc/wet()
	reagents.add_reagent("cleaner", 5)

/obj/item/soap/Crossed(atom/movable/AM as mob|obj)
	if(AM.is_incorporeal())
		return
	if(istype(AM, /mob/living))
		var/mob/living/M =	AM
		M.slip("the [src.name]",3)

/obj/item/soap/afterattack(atom/target, mob/user as mob, proximity)
	if(!proximity) return
	//I couldn't feasibly  fix the overlay bugs caused by cleaning items we are wearing.
	//So this is a workaround. This also makes more sense from an IC standpoint. ~Carn
	if(user.client && (target in user.client.screen))
		to_chat(user, span_notice("You need to take that [target.name] off before cleaning it."))
	else if(istype(target,/obj/effect/decal/cleanable/blood))
		to_chat(user, span_notice("You scrub \the [target.name] out."))
		target.clean_blood()
		return	//Blood is a cleanable decal, therefore needs to be accounted for before all cleanable decals.
	else if(istype(target,/obj/effect/decal/cleanable))
		to_chat(user, span_notice("You scrub \the [target.name] out."))
		qdel(target)
	else if(istype(target,/turf))
		to_chat(user, span_notice("You scrub \the [target.name] clean."))
		var/turf/T = target
		T.clean(src, user)
	else if(istype(target,/obj/structure/sink))
		to_chat(user, span_notice("You wet \the [src] in the sink."))
		wet()
	else
		to_chat(user, span_notice("You clean \the [target.name]."))
		target.clean_blood(TRUE)
	return

//attack_as_weapon
/obj/item/soap/attack(mob/living/target, mob/living/user, var/target_zone)
	if(target && user && ishuman(target) && ishuman(user) && !user.incapacitated() && user.zone_sel &&user.zone_sel.selecting == "mouth" )
		user.visible_message(span_danger("\The [user] washes \the [target]'s mouth out with soap!"))
		user.setClickCooldown(DEFAULT_QUICK_COOLDOWN) //prevent spam
		return
	..()

/*
 * Bike Horns
 */
/obj/item/bikehorn
	var/honk_sound = 'sound/items/bikehorn.ogg'

/obj/item/bikehorn/attack_self(mob/user as mob)
	if(spam_flag == 0)
		spam_flag = 1
		playsound(src, honk_sound, 50, 1)
		src.add_fingerprint(user)
		spawn(20)
			spam_flag = 0
	return

/obj/item/bikehorn/Crossed(atom/movable/AM as mob|obj)
	if(AM.is_incorporeal())
		return
	if(istype(AM, /mob/living))
		playsound(src, honk_sound, 50, 1)
