/* Code for the Wild West map by Brotemis
 * Contains:
 *		Wish Granter
 *		Meat Grinder
 */

/*
 * Wish Granter
 */
/obj/machinery/wish_granter_dark
	name = "Wish Granter"
	desc = "You're not so sure about this, anymore..."
	icon = 'icons/obj/device.dmi'
	icon_state = "syndbeacon"

	anchored = 1
	density = 1
	use_power = USE_POWER_OFF

	var/chargesa = 1
	var/insistinga = 0

/obj/machinery/wish_granter_dark/attack_hand(var/mob/living/carbon/human/user as mob)
	usr.set_machine(src)

	if(chargesa <= 0)
		to_chat(user, "The Wish Granter lies silent.")
		return

	else if(!istype(user, /mob/living/carbon/human))
		to_chat(user, "You feel a dark stirring inside of the Wish Granter, something you want nothing of. Your instincts are better than any man's.")
		return

	else if(is_special_character(user))
		to_chat(user, "Even to a heart as dark as yours, you know nothing good will come of this.  Something instinctual makes you pull away.")

	else if (!insistinga)
		to_chat(user, "Your first touch makes the Wish Granter stir, listening to you.  Are you really sure you want to do this?")
		insistinga++

	else
		chargesa--
		insistinga = 0
		var/wish = tgui_input_list(usr, "You want...","Wish", list("Power","Wealth","Immortality","To Kill","Peace"))
		switch(wish)
			if("Power")
				to_chat(user, "<B>Your wish is granted, but at a terrible cost...</B>")
				to_chat(user, "The Wish Granter punishes you for your selfishness, claiming your soul and warping your body to match the darkness in your heart.")
				if (!(LASER in user.mutations))
					user.mutations.Add(LASER)
					to_chat(user, span_notice("You feel pressure building behind your eyes."))
				if (!(COLD_RESISTANCE in user.mutations))
					user.mutations.Add(COLD_RESISTANCE)
					to_chat(user, span_notice("Your body feels warm."))
				if (!(XRAY in user.mutations))
					user.mutations.Add(XRAY)
					user.sight |= (SEE_MOBS|SEE_OBJS|SEE_TURFS)
					user.see_in_dark = 8
					user.see_invisible = SEE_INVISIBLE_LEVEL_TWO
					to_chat(user, span_notice("The walls suddenly disappear."))
				user.dna.mutantrace = "shadow"
				user.update_mutantrace()
			if("Wealth")
				to_chat(user, "<B>Your wish is granted, but at a terrible cost...</B>")
				to_chat(user, "The Wish Granter punishes you for your selfishness, claiming your soul and warping your body to match the darkness in your heart.")
				new /obj/structure/closet/syndicate/resources/everything(loc)
				user.dna.mutantrace = "shadow"
				user.update_mutantrace()
			if("Immortality")
				to_chat(user, "<B>Your wish is granted, but at a terrible cost...</B>")
				to_chat(user, "The Wish Granter punishes you for your selfishness, claiming your soul and warping your body to match the darkness in your heart.")
				user.verbs += /mob/living/carbon/proc/immortality
				user.dna.mutantrace = "shadow"
				user.update_mutantrace()
			if("To Kill")
				to_chat(user, "<B>Your wish is granted, but at a terrible cost...</B>")
				to_chat(user, "The Wish Granter punishes you for your wickedness, claiming your soul and warping your body to match the darkness in your heart.")
				ticker.mode.traitors += user.mind
				user.mind.special_role = "traitor"
				var/datum/objective/hijack/hijack = new
				hijack.owner = user.mind
				user.mind.objectives += hijack
				to_chat(user, "<B>Your inhibitions are swept away, the bonds of loyalty broken, you are free to murder as you please!</B>")
				var/obj_count = 1
				for(var/datum/objective/OBJ in user.mind.objectives)
					to_chat(user, "<B>Objective #[obj_count]</B>: [OBJ.explanation_text]")
					obj_count++
				user.dna.mutantrace = "shadow"
				user.update_mutantrace()
			if("Peace")
				to_chat(user, "<B>Whatever alien sentience that the Wish Granter possesses is satisfied with your wish. There is a distant wailing as the last of the Faithless begin to die, then silence.</B>")
				to_chat(user, "You feel as if you just narrowly avoided a terrible fate...")
				for(var/mob/living/simple_mob/faithless/F in living_mob_list)
					F.health = -10
					F.set_stat(DEAD)
					F.icon_state = "faithless_dead"


///////////////Meatgrinder//////////////


/obj/effect/meatgrinder
	name = "Meat Grinder"
	desc = "What is that thing?"
	density = 1
	anchored = 1
	icon = 'icons/mob/critter.dmi'
	icon_state = "blob"
	var/triggerproc = "explode" //name of the proc thats called when the mine is triggered
	var/triggered = 0

/obj/effect/meatgrinder/New()
	icon_state = "blob"

/obj/effect/meatgrinder/HasEntered(AM as mob|obj)
	Bumped(AM)

/obj/effect/meatgrinder/Bumped(mob/M as mob|obj)

	if(triggered) return

	if(istype(M, /mob/living/carbon/human) || istype(M, /mob/living/carbon/monkey))
		for(var/mob/O in viewers(world.view, src.loc))
			to_chat(O, span_red("[M] triggered the [icon2html(src, O.client)] [src]"))
		triggered = 1
		call(src,triggerproc)(M)

/obj/effect/meatgrinder/proc/triggerrad1(mob)
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	for(var/mob/O in viewers(world.view, src.loc))
		s.set_up(3, 1, src)
		s.start()
		explosion(mob, 1, 0, 0, 0)
		spawn(0)
			qdel(src)

/obj/effect/meatgrinder
	name = "Meat Grinder"
	icon_state = "blob"
	triggerproc = "triggerrad1"


/////For the Wishgranter///////////

/mob/living/carbon/proc/immortality()
	set category = "Immortality"
	set name = "Resurrection"

	var/mob/living/carbon/C = usr
	if(!C.stat)
		to_chat(C, span_notice("You're not dead yet!"))
		return
	to_chat(C, span_notice("Death is not your end!"))

	spawn(rand(800,1200))
		if(C.stat == DEAD)
			dead_mob_list -= C
			living_mob_list += C
		C.set_stat(CONSCIOUS)
		C.tod = null
		C.setToxLoss(0)
		C.setOxyLoss(0)
		C.setCloneLoss(0)
		C.SetParalysis(0)
		C.SetStunned(0)
		C.SetWeakened(0)
		C.radiation = 0
		C.heal_overall_damage(C.getBruteLoss(), C.getFireLoss())
		C.reagents.clear_reagents()
		to_chat(C, span_notice("You have regenerated."))
		C.visible_message(span_warning("[usr] appears to wake from the dead, having healed all wounds."))
		C.update_canmove()
	return 1
