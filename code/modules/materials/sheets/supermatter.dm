// Forged in the equivalent of Hell, one piece at a time.
/obj/item/stack/material/supermatter
	name = MAT_SUPERMATTER
	icon_state = "sheet-super"
	item_state = "diamond"
	default_type = MAT_SUPERMATTER
	apply_colour = TRUE
	var/last_event = 0
	/// Mutex to prevent infinite recursion when propagating radiation pulses
	var/active = null

/obj/item/stack/material/supermatter/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/stack/material/supermatter/process()
	radiate()
	..()

/obj/item/stack/material/supermatter/proc/radiate()
	SIGNAL_HANDLER
	if(active)
		return
	if(world.time <= last_event + 1.5 SECONDS)
		return
	active = TRUE
	radiation_pulse(
		src,
		max_range = (amount * 0.2), //10 range at 50 amount
		threshold = RAD_HEAVY_INSULATION,
		chance = URANIUM_IRRADIATION_CHANCE,
		minimum_exposure_time = NEBULA_RADIATION_MINIMUM_EXPOSURE_TIME,
		strength = amount * 0.5 //2 sheets = 1 rad, 50 sheets = 25 rads.
	)
	last_event = world.time
	active = FALSE

/obj/item/stack/material/supermatter/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()


/obj/item/stack/material/supermatter/proc/update_mass()	// Due to how dangerous they can be, the item will get heavier and larger the more are in the stack.
	slowdown = amount / 10
	w_class = min(5, round(amount / 10) + 1)
	throw_range = round(amount / 7) + 1

/obj/item/stack/material/supermatter/use(used)
	. = ..()
	update_mass()
	return

/obj/item/stack/material/supermatter/attack_hand(mob/user)
	. = ..()

	update_mass()
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
			H.apply_damage(amount / 2 + 5, BURN, BP_R_HAND, used_weapon=src)
			H.apply_damage(amount / 2 + 5, BURN, BP_L_HAND, used_weapon=src)
			H.drop_from_inventory(src, get_turf(H))
			return

	if(isrobot(user))
		burn_user = FALSE

	if(burn_user)
		M.apply_damage(amount, BURN, null, used_weapon=src)

/obj/item/stack/material/supermatter/ex_act(severity)	// An incredibly hard to manufacture material, SM chunks are unstable by their 'stabilized' nature.
	if(prob((4 / severity) * 20))
		radiation_pulse(
			src,
			max_range = amount,
			threshold = RAD_HEAVY_INSULATION,
			chance = URANIUM_IRRADIATION_CHANCE * 5,
			minimum_exposure_time = 0,
			strength = amount * 10
			)
		explosion(get_turf(src),round(amount / 12) , round(amount / 6), round(amount / 3), round(amount / 25))
		qdel(src)
		return
	..()
