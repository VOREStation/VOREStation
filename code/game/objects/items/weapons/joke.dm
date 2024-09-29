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