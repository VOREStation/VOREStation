/obj/structure/table/CanPass(atom/movable/mover, turf/target)
	if(istype(mover,/obj/item/projectile))
		return (check_cover(mover,target))
	if(flipped == 1)
		if(get_dir(mover, target) == reverse_dir[dir]) // From elsewhere to here, can't move against our dir
			return !density
		return TRUE
	if(istype(mover) && mover.checkpass(PASSTABLE))
		return TRUE
	if(locate(/obj/structure/table/bench) in get_turf(mover))
		return FALSE
	var/obj/structure/table/table = locate(/obj/structure/table) in get_turf(mover)
	if(table && !(table.flipped == 1))
		return TRUE
	return FALSE

/obj/structure/table/climb_to(mob/living/mover)
	if(flipped == 1 && mover.loc == loc)
		var/turf/T = get_step(src, dir)
		if(T.Enter(mover))
			return T

	return ..()

/obj/structure/table/Uncross(atom/movable/mover, turf/target)
	if(flipped == 1 && (get_dir(mover, target) == dir)) // From here to elsewhere, can't move in our dir
		return !density
	return TRUE

//checks if projectile 'P' from turf 'from' can hit whatever is behind the table. Returns 1 if it can, 0 if bullet stops.
/obj/structure/table/proc/check_cover(obj/item/projectile/P, turf/from)
	var/turf/cover
	if(flipped==1)
		cover = get_turf(src)
	else if(flipped==0)
		cover = get_step(loc, get_dir(from, loc))
	if(!cover)
		return 1
	if (get_dist(P.starting, loc) <= 1) //Tables won't help you if people are THIS close
		return 1
	if (get_turf(P.original) == cover)
		var/chance = 20
		if (ismob(P.original))
			var/mob/M = P.original
			if (M.lying)
				chance += 20				//Lying down lets you catch less bullets
		if(flipped==1)
			if(get_dir(loc, from) == dir)	//Flipped tables catch mroe bullets
				chance += 20
			else
				return 1					//But only from one side
		if(prob(chance))
			health -= P.damage/2
			if (health > 0)
				visible_message("<span class='warning'>[P] hits \the [src]!</span>")
				return 0
			else
				visible_message("<span class='warning'>[src] breaks down!</span>")
				break_to_parts()
				return 1
	return 1

/obj/structure/table/MouseDrop_T(obj/O, mob/user, src_location, over_location, src_control, over_control, params)
	if(ismob(O.loc)) //If placing an item
		if(!isitem(O) || user.get_active_hand() != O)
			return ..()
		if(isrobot(user))
			return
		user.drop_item()
		if(O.loc != src.loc)
			step(O, get_dir(O, src))

	else if(isturf(O.loc) && isitem(O)) //If pushing an item on the tabletop
		var/obj/item/I = O
		if(I.anchored)
			return

		if((isliving(user)) && (Adjacent(user)) && !(user.incapacitated()))
			if(O.w_class <= user.can_pull_size)
				O.forceMove(loc)
				auto_align(I, params, TRUE)
			else
				to_chat(user, SPAN_WARNING("\The [I] is too big for you to move!"))
			return

	return ..()


/obj/structure/table/attackby(obj/item/W as obj, mob/user as mob, var/hit_modifier, var/click_parameters)
	if (!W) return

	// Handle harm intent grabbing/tabling.
	if(istype(W, /obj/item/grab) && get_dist(src,user)<2)
		var/obj/item/grab/G = W
		if (istype(G.affecting, /mob/living))
			var/mob/living/M = G.affecting
			var/obj/occupied = turf_is_crowded()
			if(occupied)
				to_chat(user, "<span class='danger'>There's \a [occupied] in the way.</span>")
				return
			if(!user.Adjacent(M))
				return
			if (G.state < 2)
				if(user.a_intent == I_HURT)
					if (prob(15))	M.Weaken(5)
					M.apply_damage(8,def_zone = BP_HEAD)
					visible_message("<span class='danger'>[G.assailant] slams [G.affecting]'s face against \the [src]!</span>")
					if(material)
						playsound(src, material.tableslam_noise, 50, 1)
					else
						playsound(src, 'sound/weapons/tablehit1.ogg', 50, 1)
					var/list/L = take_damage(rand(1,5))
					// Shards. Extra damage, plus potentially the fact YOU LITERALLY HAVE A PIECE OF GLASS/METAL/WHATEVER IN YOUR FACE
					for(var/obj/item/material/shard/S in L)
						if(prob(50))
							M.visible_message("<span class='danger'>\The [S] slices [M]'s face messily!</span>",
							                   "<span class='danger'>\The [S] slices your face messily!</span>")
							M.apply_damage(10, def_zone = BP_HEAD)
							if(prob(2))
								M.embed(S, def_zone = BP_HEAD)
				else
					to_chat(user, "<span class='danger'>You need a better grip to do that!</span>")
					return
			else if(G.state > GRAB_AGGRESSIVE || world.time >= (G.last_action + UPGRADE_COOLDOWN))
				M.forceMove(get_turf(src))
				M.Weaken(5)
				visible_message("<span class='danger'>[G.assailant] puts [G.affecting] on \the [src].</span>")
			qdel(W)
			return

	// Handle dismantling or placing things on the table from here on.
	if(isrobot(user))
		return

	if(W.loc != user) // This should stop mounted modules ending up outside the module.
		return

<<<<<<< HEAD
	if(istype(W, /obj/item/weapon/melee/energy/blade))
		var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
=======
	if(istype(W, /obj/item/melee/energy/blade))
		var/datum/effect_system/spark_spread/spark_system = new /datum/effect_system/spark_spread()
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
		spark_system.set_up(5, 0, src.loc)
		spark_system.start()
		playsound(src, 'sound/weapons/blade1.ogg', 50, 1)
		playsound(src, "sparks", 50, 1)
		user.visible_message("<span class='danger'>\The [src] was sliced apart by [user]!</span>")
		break_to_parts()
		return

	if(istype(W, /obj/item/melee/changeling/arm_blade))
		user.visible_message("<span class='danger'>\The [src] was sliced apart by [user]!</span>")
		break_to_parts()
		return

	if(can_plate && !material)
		to_chat(user, "<span class='warning'>There's nothing to put \the [W] on! Try adding plating to \the [src] first.</span>")
		return

// Placing stuff on tables
	if(user.unEquip(W, 0, src.loc) && user.is_preference_enabled(/datum/client_preference/precision_placement))
		auto_align(W, click_parameters)
		return 1

/obj/structure/table/attack_tk() // no telehulk sorry
	return
