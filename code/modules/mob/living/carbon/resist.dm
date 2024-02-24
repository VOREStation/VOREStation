/mob/living/carbon/resist_fire()
	adjust_fire_stacks(-1.2)
	Weaken(3)
	spin(32,2)
	visible_message(
		"<span class='danger'>[src] rolls on the floor, trying to put themselves out!</span>",
		"<span class='notice'>You stop, drop, and roll!</span>"
		)
	sleep(30)
	if(fire_stacks <= 0)
		visible_message(
			"<span class='danger'>[src] has successfully extinguished themselves!</span>",
			"<span class='notice'>You extinguish yourself.</span>"
			)
		ExtinguishMob()
	return TRUE

/mob/living/carbon/resist_restraints()
	var/obj/item/I = null
	if(handcuffed)
		I = handcuffed
	else if(legcuffed)
		I = legcuffed
	
	if(I)
		setClickCooldown(100)
		cuff_resist(I, cuff_break = can_break_cuffs())

/mob/living/carbon/proc/reduce_cuff_time()
	return FALSE

/mob/living/carbon/proc/cuff_resist(obj/item/weapon/handcuffs/I, breakouttime = 1200, cuff_break = 0)
	
	if(istype(I))
		breakouttime = I.breakouttime

	var/displaytime = breakouttime / 10

	var/reduceCuffTime = reduce_cuff_time()
	if(reduceCuffTime)
		breakouttime /= reduceCuffTime
		displaytime /= reduceCuffTime

	if(cuff_break)
		visible_message("<span class='danger'>[src] is trying to break [I]!</span>",
			"<span class='warning'>You attempt to break your [I]. (This will take around 5 seconds and you need to stand still)</span>")

		if(do_after(src, 5 SECONDS, target = src, incapacitation_flags = INCAPACITATION_DEFAULT & ~INCAPACITATION_RESTRAINED))
			if(!I || buckled)
				return
			visible_message("<span class='danger'>[src] manages to break [I]!</span>",
				"<span class='warning'>You successfully break your [I].</span>")
			say(pick(";RAAAAAAAARGH!", ";HNNNNNNNNNGGGGGGH!", ";GWAAAAAAAARRRHHH!", "NNNNNNNNGGGGGGGGHH!", ";AAAAAAARRRGH!" ))

			if(I == handcuffed)
				handcuffed = null
				update_handcuffed()
			else if(I == legcuffed)
				legcuffed = null
				update_inv_legcuffed()
	
			if(buckled && buckled.buckle_require_restraints)
				buckled.unbuckle_mob()

			qdel(I)
		else
			to_chat(src, "<span class='warning'>You fail to break [I].</span>")
		return
	
	visible_message("<span class='danger'>[src] attempts to remove [I]!</span>",
		"<span class='warning'>You attempt to remove [I]. (This will take around [displaytime] seconds and you need to stand still)</span>")
	if(do_after(src, breakouttime, target = src, incapacitation_flags = INCAPACITATION_DISABLED & INCAPACITATION_KNOCKDOWN))
		visible_message("<span class='danger'>[src] manages to remove [I]!</span>",
			"<span class='notice'>You successfully remove [I].</span>")
		drop_from_inventory(I)

/mob/living/carbon/resist_buckle()
	if(!buckled)
		return

	if(!restrained())
		return ..()

	setClickCooldown(100)
	visible_message(
		"<span class='danger'>[src] attempts to unbuckle themself!</span>",
		"<span class='warning'>You attempt to unbuckle yourself. (This will take around 2 minutes and you need to stand still)</span>"
		)

	if(do_after(src, 2 MINUTES, incapacitation_flags = INCAPACITATION_DEFAULT & ~(INCAPACITATION_RESTRAINED | INCAPACITATION_BUCKLED_FULLY)))
		if(!buckled)
			return
		visible_message("<span class='danger'>[src] manages to unbuckle themself!</span>",
						"<span class='notice'>You successfully unbuckle yourself.</span>")
		buckled.user_unbuckle_mob(src, src)

/mob/living/carbon/proc/can_break_cuffs()
	if(HULK in mutations)
		return 1
