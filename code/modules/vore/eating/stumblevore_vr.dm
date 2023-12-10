/mob/living/proc/CanStumbleVore(mob/living/target)
	if(!can_be_drop_pred)
		return FALSE
	if(!is_vore_predator(src))
		return FALSE
	if(!target.devourable)
		return FALSE
	if(!target.can_be_drop_prey)
		return FALSE
	if(!target.stumble_vore || !stumble_vore)
		return FALSE
	return TRUE

/mob/living/Bump(atom/movable/AM)
	//. = ..()
	if(istype(AM, /mob/living))
		if(((confused || is_blind()) && stat == CONSCIOUS && prob(50) && m_intent=="run") || flying && flight_vore)
			AM.stumble_into(src)
	return ..()
// Because flips toggle density
/mob/living/Crossed(var/atom/movable/AM)
	if(istype(AM, /mob/living) && isturf(loc) && AM != src)
		var/mob/living/AMV = AM
		if(((AMV.confused || AMV.is_blind()) && AMV.stat == CONSCIOUS && prob(50) && AMV.m_intent=="run") || AMV.flying && AMV.flight_vore)
			stumble_into(AMV)
	..()

/mob/living/stumble_into(mob/living/M)
	var/mob/living/carbon/human/S = src

	playsound(src, "punch", 25, 1, -1)
	M.Weaken(4)
	M.stop_flying()
	if(CanStumbleVore(M))
		visible_message("<span class='warning'>[M] flops carelessly into [src]!</span>")
		perform_the_nom(src,M,src,src.vore_selected,1)
	else if(M.CanStumbleVore(src))
		visible_message("<span class='warning'>[M] flops carelessly into [src]!</span>")
		perform_the_nom(M,src,M,M.vore_selected,1)
	else if(istype(S) && S.species.lightweight == 1)
		visible_message("<span class='warning'>[M] carelessly bowls [src] over!</span>")
		M.forceMove(get_turf(src))
		M.apply_damage(0.5, BRUTE)
		Weaken(4)
		stop_flying()
		apply_damage(0.5, BRUTE)
	else if(round(weight) > 474)
		var/throwtarget = get_edge_target_turf(M, reverse_direction(M.dir))
		visible_message("<span class='warning'>[M] bounces backwards off of [src]'s plush body!</span>")
		M.throw_at(throwtarget, 2, 1)
	else
		visible_message("<span class='warning'>[M] trips over [src]!</span>")
		M.forceMove(get_turf(src))
		M.apply_damage(1, BRUTE)
