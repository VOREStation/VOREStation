/obj/item/stack/teeth
	name = "teeth"
	desc = "Those little white things growing in your mouth, until someone extracts them and uses as a gorgeous Valentine's gift or a delicious snack."
	singular_name = "tooth"
	icon = 'icons/obj/teeth.dmi'
	icon_state = "tooth"
	w_class = ITEMSIZE_TINY
	force = 2.0
	throwforce = 7.0
	throw_speed = 5
	throw_range = 20
	max_amount = 32


/obj/item/stack/teeth/attack(mob/M as mob, mob/user as mob)
	if (!ishuman(M))
		..()
		return
	else
		var/mob/living/carbon/human/H = M
		var/obj/item/blocked = H.check_mouth_coverage()
		if(blocked)
			to_chat(user, "<span class='warning'>\The [blocked] is in the way!</span>")
			return
		if(H.species.has_organ[O_LIVER])
			if(H == user)
				user.visible_message("[user] has swallowed a handfull of teeth!", "You swallow the teeth!")
				H.nutrition -= amount*3 //NOT ENOUGH NOT ENOUGH NOT ENOUGH
				var/obj/item/organ/internal/liver/L = H.internal_organs_by_name[O_LIVER]
				L.take_damage(amount*1.5)
			else
				user.visible_message("[user] tries to feed [M] a handfull of teeth!")
				if(do_after(user, 20))
					user.visible_message("[user] has fed [M] a handfull of teeth!", "You feed [M] the teeth!")
					var/obj/item/organ/internal/liver/L = H.internal_organs_by_name[O_LIVER]
					L.take_damage(amount*1.5)
		playsound(src.loc, 'sound/vore/gulp.ogg', 25, 1)
		qdel(src)


/obj/item/teethglass
	name = "glass of teeth"
	desc = "You get hungry by just looking at them."
	icon = 'icons/obj/teeth.dmi'
	icon_state = "teethglass"


/obj/item/teethglass/attack(mob/M as mob, mob/user as mob)
	if (!ishuman(M))
		..()
		return
	else
		var/mob/living/carbon/human/H = M
		var/obj/item/blocked = H.check_mouth_coverage()
		if(blocked)
			to_chat(user, "<span class='warning'>\The [blocked] is in the way!</span>")
			return
		if(H.species.has_organ[O_LIVER])
			if(H == user)
				user.visible_message("[user] has swallowed a glass of teeth!", "You swallow the teeth!")
				H.nutrition -= 150
				var/obj/item/organ/internal/liver/L = H.internal_organs_by_name[O_LIVER]
				if(prob(10)	)//All shall be well.
					H.verbs |= /mob/living/proc/eat_trash
					to_chat(user, "<span class='warning'>WHY ARE YOU SO DAMNABLY HUNGRY?!</span>")
				L.take_damage(40)
			else
				user.visible_message("[user] tries to feed [M] a glass of teeth!")
				if(do_after(user, 20))
					user.visible_message("[user] has fed [M] a glass of teeth!", "You feed [M] the teeth!")
					var/obj/item/organ/internal/liver/L = H.internal_organs_by_name[O_LIVER]
					L.take_damage(50)
		playsound(src.loc, 'sound/vore/gulp.ogg', 25, 1)
		new /obj/item/weapon/reagent_containers/food/drinks/drinkingglass(user.loc)
		qdel(src)
