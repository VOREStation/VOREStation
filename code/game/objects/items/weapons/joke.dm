/obj/item/squishhammer
	name = "The Short Stacker"
	desc = "Wield the power of this weapon with responsibility (God knows you won't)."
	icon = 'icons/obj/items.dmi'
	icon_state = "toyhammer"
	attack_verb = list("stacked")
	force = 0
	throwforce = 0

// Attack mob
/obj/item/squishhammer/attack(mob/M as mob, mob/user as mob)
	var/is_squished = M.tf_scale_x || M.tf_scale_y
	playsound(src, 'sound/items/hooh.ogg', 50, 1)
	if(!is_squished)
		M.SetTransform(null, (M.size_multiplier * 1.2), (M.size_multiplier * 0.5))
	else
		M.ClearTransform()
		M.update_transform()
	return ..()

// Do not ever just leave this laying about, it will go horribly wrong!
/obj/item/squishhammer/dark
	name = "The Dark Short Stacker"
	desc = "Wield the power of this weapon with responsibility (God knows you won't)."
	icon = 'icons/obj/items.dmi'
	icon_state = "dark_hammer"
	attack_verb = list("stacked")
	force = 0
	throwforce = 0

/obj/item/squishhammer/dark/attack(mob/M as mob, mob/user as mob)
	..()
	var/mob/living/carbon/human/H = M
	if(istype(H))
		for(var/obj/item/organ/external/E in H.organs)
			E.fracture() // Oof, ouch, owie
	var/turf/T = M.loc
	if(isturf(T))
		new /obj/effect/gibspawner/generic(T)
