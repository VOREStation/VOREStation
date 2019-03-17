/obj/effect/meteor/Bump_vr(atom/A)//BATTER UP
	if(istype(A, /mob/living/carbon))
		var/mob/living/carbon/batter = A
		var/obj/item/I = batter.get_active_hand()
		if(!batter.stat && istype(I, /obj/item/weapon/material/twohanded/baseballbat))
			batter.do_attack_animation(src)
			batter.visible_message("[batter] deflects [src] with [I]]! Home run!", "You deflect [src] with [I]! Home run!")
			walk_away(src, batter, 100, 1)
			return TRUE
	return
