/obj/item/melee/rapier
	name = "rapier"
	desc = "A gleaming steel blade with a gold handguard and inlayed with an outstanding red gem."
	icon = 'icons/obj/weapons_vr.dmi'
	icon_state = "rapier"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_melee_vr.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_melee_vr.dmi',
		)
	force = 15
	throwforce = 10
	w_class = ITEMSIZE_NORMAL
	sharp = TRUE
	edge = FALSE
	attack_verb = list("stabbed", "lunged at", "dextrously struck", "sliced", "lacerated", "impaled", "diced", "charioted")
	hitsound = 'sound/weapons/bladeslice.ogg'

/obj/item/melee/hammer
	name = "claw hammer"
	desc = "A simple claw hammer for hitting things or people with, and the claw part probably does something too."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "claw_hammer"
	force = 15
	throwforce = 10
	w_class = ITEMSIZE_SMALL
	attack_verb = list("smashed", "swung at", "pummelled", "nailed", "crushed", "bonked", "hammered", "cracked")
	defend_chance = 0

/obj/item/melee/hammer/apply_hit_effect(mob/living/target, mob/living/user, var/hit_zone, var/attack_modifier)
	if(istype(target,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = target
		if(prob(50))
			var/obj/item/organ/external/affecting = H.get_organ(hit_zone)
			affecting.fracture()
	return ..()

/obj/item/melee/hammer/afterattack(atom/A as mob|obj|turf|area, mob/user as mob, proximity)
	if(!proximity) return
	..()
	if(A)
		if(istype(A,/obj/structure/window))
			var/obj/structure/window/W = A
			if(prob(50))
				W.visible_message(span_warning("\The [W] shatters under the force of the impact!"))
				W.shatter()
		else if(istype(A,/obj/structure/barricade))
			var/obj/structure/barricade/B = A
			if(prob(50))
				B.visible_message(span_warning("\The [B] is broken apart with ease!"))
				B.dismantle()
		else if(istype(A,/obj/structure/grille))
			if(prob(50))
				A.visible_message(span_warning("\The [A] is smashed open!"))
				qdel(A)
