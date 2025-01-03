// Forged in the equivalent of Hell, one piece at a time.
/obj/item/stack/material/supermatter
	name = MAT_SUPERMATTER
	icon_state = "sheet-super"
	item_state = "diamond"
	default_type = MAT_SUPERMATTER
	apply_colour = TRUE

/obj/item/stack/material/supermatter/proc/update_mass()	// Due to how dangerous they can be, the item will get heavier and larger the more are in the stack.
	slowdown = amount / 10
	w_class = min(5, round(amount / 10) + 1)
	throw_range = round(amount / 7) + 1

/obj/item/stack/material/supermatter/use(var/used)
	. = ..()
	update_mass()
	return

/obj/item/stack/material/supermatter/attack_hand(mob/user)
	. = ..()

	update_mass()
	SSradiation.radiate(src, 5 + amount)
	var/mob/living/M = user
	if(!istype(M))
		return

	var/burn_user = TRUE
	if(ishuman(M))
		var/mob/living/carbon/human/H = user
		var/obj/item/clothing/gloves/G = H.gloves
		if(istype(G) && ((G.flags & THICKMATERIAL && prob(70)) || istype(G, /obj/item/clothing/gloves/gauntlets)))
			burn_user = FALSE

		if(burn_user)
			H.visible_message(span_danger("\The [src] flashes as it scorches [H]'s hands!"))
			H.apply_damage(amount / 2 + 5, BURN, "r_hand", used_weapon="Supermatter Chunk")
			H.apply_damage(amount / 2 + 5, BURN, "l_hand", used_weapon="Supermatter Chunk")
			H.drop_from_inventory(src, get_turf(H))
			return

	if(isrobot(user))
		burn_user = FALSE

	if(burn_user)
		M.apply_damage(amount, BURN, null, used_weapon="Supermatter Chunk")

/obj/item/stack/material/supermatter/ex_act(severity)	// An incredibly hard to manufacture material, SM chunks are unstable by their 'stabilized' nature.
	if(prob((4 / severity) * 20))
		SSradiation.radiate(get_turf(src), amount * 4)
		explosion(get_turf(src),round(amount / 12) , round(amount / 6), round(amount / 3), round(amount / 25))
		qdel(src)
		return
	SSradiation.radiate(get_turf(src), amount * 2)
	..()
