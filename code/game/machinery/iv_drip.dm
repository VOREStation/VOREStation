/obj/machinery/iv_drip
	name = "\improper IV drip"
	desc = "Helpful for giving someone blood! Or taking it away. It giveth, it taketh."
	icon = 'icons/obj/iv_drip.dmi'
	anchored = FALSE
	density = FALSE


/obj/machinery/iv_drip/var/mob/living/carbon/human/attached = null
/obj/machinery/iv_drip/var/mode = 1 // 1 is injecting, 0 is taking blood.
/obj/machinery/iv_drip/var/obj/item/reagent_containers/beaker = null

/obj/machinery/iv_drip/update_icon()
	if(attached)
		icon_state = "hooked"
	else
		icon_state = ""

	cut_overlays()

	if(beaker)
		var/datum/reagents/reagents = beaker.reagents
		if(reagents.total_volume)
			var/image/filling = image('icons/obj/iv_drip.dmi', src, "reagent")

			var/percent = round((reagents.total_volume / beaker.volume) * 100)
			switch(percent)
				if(0 to 9)		filling.icon_state = "reagent0"
				if(10 to 24) 	filling.icon_state = "reagent10"
				if(25 to 49)	filling.icon_state = "reagent25"
				if(50 to 74)	filling.icon_state = "reagent50"
				if(75 to 79)	filling.icon_state = "reagent75"
				if(80 to 90)	filling.icon_state = "reagent80"
				if(91 to INFINITY)	filling.icon_state = "reagent100"

			filling.icon += reagents.get_color()
			add_overlay(filling)

/obj/machinery/iv_drip/MouseDrop(over_object, src_location, over_location)
	..()
	if(!isliving(usr))
		return

	if(attached)
		visible_message("[attached] is detached from \the [src]")
		attached = null
		update_icon()
		return

	if(in_range(src, usr) && ishuman(over_object) && get_dist(over_object, src) <= 1)
		visible_message("[usr] attaches \the [src] to \the [over_object].")
		attached = over_object
		update_icon()


/obj/machinery/iv_drip/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/reagent_containers))
		if(!isnull(beaker))
			to_chat(user, "There is already a reagent container loaded!")
			return

		user.drop_item()
		W.loc = src
		beaker = W
		to_chat(user, "You attach \the [W] to \the [src].")
		update_icon()
		return

	if(W.has_tool_quality(TOOL_SCREWDRIVER))
		playsound(src, W.usesound, 50, 1)
		to_chat(user, span_notice("You start to dismantle the IV drip."))
		if(do_after(user, 15))
			to_chat(user, span_notice("You dismantle the IV drip."))
			new /obj/item/stack/rods(src.loc, 6)
			if(beaker)
				beaker.loc = get_turf(src)
				beaker = null
			qdel(src)
		return
	else
		return ..()


/obj/machinery/iv_drip/process()
	set background = 1

	if(attached)

		if(!(get_dist(src, attached) <= 1 && isturf(attached.loc)))
			visible_message("The needle is ripped out of [attached], doesn't that hurt?")
			attached:apply_damage(3, BRUTE, pick("r_arm", "l_arm"))
			attached = null
			update_icon()
			return

	if(attached && beaker)
		// Give blood
		if(mode)
			if(beaker.volume > 0)
				var/transfer_amount = REM
				if(istype(beaker, /obj/item/reagent_containers/blood))
					// speed up transfer on blood packs
					transfer_amount = 4
				beaker.reagents.trans_to_mob(attached, transfer_amount, CHEM_BLOOD)
				update_icon()

		// Take blood
		else
			var/amount = beaker.reagents.maximum_volume - beaker.reagents.total_volume
			amount = min(amount, 4)
			// If the beaker is full, ping
			if(amount == 0)
				if(prob(5))
					visible_message("\The [src] pings.")
				return

			var/mob/living/carbon/human/T = attached

			if(!istype(T))
				return
			if(!T.dna)
				return
			if(NOCLONE in T.mutations)
				return

			if(!T.should_have_organ(O_HEART))
				return

			// If the human is losing too much blood, beep.
			if(T.vessel.get_reagent_amount("blood") < T.species.blood_volume*T.species.blood_level_safe)
				visible_message("\The [src] beeps loudly.")

			var/datum/reagent/B = T.take_blood(beaker,amount)

			if(B)
				beaker.reagents.reagent_list |= B
				beaker.reagents.update_total()
				beaker.on_reagent_change()
				beaker.reagents.handle_reactions()
				update_icon()

/obj/machinery/iv_drip/attack_hand(mob/user as mob)
	if(beaker)
		beaker.loc = get_turf(src)
		beaker = null
		update_icon()
	else
		return ..()


/obj/machinery/iv_drip/verb/toggle_mode()
	set category = "Object"
	set name = "Toggle Mode"
	set src in view(1)

	if(!istype(usr, /mob/living))
		to_chat(usr, span_warning("You can't do that."))
		return

	if(usr.stat)
		return

	mode = !mode
	to_chat(usr, "The IV drip is now [mode ? "injecting" : "taking blood"].")

/obj/machinery/iv_drip/examine(mob/user)
	. = ..()

	if(get_dist(user, src) <= 2)
		. += "The IV drip is [mode ? "injecting" : "taking blood"]."

		if(beaker)
			if(beaker.reagents?.reagent_list?.len)
				. += span_notice("Attached is \a [beaker] with [beaker.reagents.total_volume] units of liquid.")
			else
				. += span_notice("Attached is an empty [beaker].")
		else
			. += span_notice("No chemicals are attached.")

		. += span_notice("[attached ? attached : "No one"] is attached.")

/obj/machinery/iv_drip/CanPass(atom/movable/mover, turf/target)
	if(istype(mover) && mover.checkpass(PASSTABLE)) //allow bullets, beams, thrown objects, mice, drones, and the like through.
		return TRUE
	return ..()
