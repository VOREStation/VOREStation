
//Original Codebase created by Shadowfire117#1269 - Ported from CHOMPstation
//Modified by GhostActual#2055 to produce Claw Machine

/*
 * Space Crane
 */

/obj/machinery/clawmachine
	name = "Space Crane"
	desc = "Try your luck at winning a cute plush toy! No refunds, and whining won't win you anything."
	icon = 'icons/obj/computer.dmi'
	icon_state = "clawmachine"
	anchored = 1
	density = 1
	power_channel = EQUIP
	use_power = USE_POWER_IDLE
	idle_power_usage = 10
	active_power_usage = 100
	light_power = 0.9
	light_range = 2
	light_color = "#B1FBBFF"
	var/isbroken = 0  //1 if someone banged it with something heavy
	var/ispowered = 1 //starts powered, changes with power_change()
	var/busy = 0
	var/symbol1 = null
	var/symbol2 = null
	var/symbol3 = null
	var/list/prizes	= list(/obj/random/carp_plushie,
						/obj/item/toy/plushie/nymph,
						/obj/item/toy/plushie/teshari,
						/obj/item/toy/plushie/mouse,
						/obj/item/toy/plushie/kitten,
						/obj/item/toy/plushie/lizard,
						/obj/item/toy/plushie/spider,
						/obj/item/toy/plushie/farwa,
						/obj/item/toy/plushie/corgi,
						/obj/item/toy/plushie/girly_corgi,
						/obj/item/toy/plushie/robo_corgi,
						/obj/item/toy/plushie/octopus,
						/obj/item/toy/plushie/face_hugger,
						/obj/item/toy/plushie/red_fox,
						/obj/item/toy/plushie/black_fox,
						/obj/item/toy/plushie/marble_fox,
						/obj/item/toy/plushie/blue_fox,
						/obj/item/toy/plushie/orange_fox,
						/obj/item/toy/plushie/coffee_fox,
						/obj/item/toy/plushie/pink_fox,
						/obj/item/toy/plushie/purple_fox,
						/obj/item/toy/plushie/crimson_fox,
						/obj/item/toy/plushie/deer,
						/obj/item/toy/plushie/black_cat,
						/obj/item/toy/plushie/grey_cat,
						/obj/item/toy/plushie/white_cat,
						/obj/item/toy/plushie/orange_cat,
						/obj/item/toy/plushie/siamese_cat,
						/obj/item/toy/plushie/tabby_cat,
						/obj/item/toy/plushie/tuxedo_cat,
						/obj/item/toy/plushie/borgplushie/medihound,
						/obj/item/toy/plushie/borgplushie/scrubpuppy,
						/obj/item/toy/plushie/borgplushie/drake/sec,
						/obj/item/toy/plushie/borgplushie/drake/med,
						/obj/item/toy/plushie/borgplushie/drake/sci,
						/obj/item/toy/plushie/borgplushie/drake/eng,
						/obj/item/toy/plushie/borgplushie/drake/mine,
						/obj/item/toy/plushie/borgplushie/drake/jani,
						/obj/item/toy/plushie/borgplushie/drake/trauma,
						/obj/item/toy/plushie/otter,
						/obj/item/toy/plushie/shark
						)

/obj/machinery/clawmachine/update_icon()
	cut_overlays()
	if(!ispowered || isbroken)
		icon_state = "clawmachine_off"
		if(isbroken) //If the thing is smashed, add crack overlay on top of the unpowered sprite.
			add_overlay("clawmachine_broken")
		set_light(0)
		set_light_on(FALSE)
		return

	icon_state = "clawmachine"
	set_light(2)
	set_light_on(TRUE)
	return

/obj/machinery/clawmachine/power_change()
	if(isbroken) //Broken shit can't be powered.
		return
	..()
	if(!(stat & NOPOWER))
		ispowered = 1
		update_icon()
	else
		spawn(rand(0, 15))
			ispowered = 0
			update_icon()

/obj/machinery/clawmachine/attackby(obj/item/W as obj, mob/user as mob)
	if(busy)
		to_chat(user,span_notice("The claw machine is currently running."))
		return
	if(W.has_tool_quality(TOOL_WRENCH))
		playsound(src, W.usesound, 100, 1)
		if(anchored)
			user.visible_message("[user] begins unsecuring \the [src] from the floor.", "You start unsecuring \the [src] from the floor.")
		else
			user.visible_message("[user] begins securing \the [src] to the floor.", "You start securing \the [src] to the floor.")

		if(do_after(user, 20 * W.toolspeed))
			if(!src) return
			to_chat(user, span_notice("You [anchored? "un" : ""]secured \the [src]!"))
			anchored = !anchored
		return

	if(!anchored)
		to_chat(user,span_notice("The machine isn't secured."))
		return

	var/handled = 0
	var/paid = 0

	if(istype(W, /obj/item/spacecash))
		var/obj/item/spacecash/C = W
		paid = insert_cash(C, user)
		handled = 1
		if(paid)
			return
		if(handled)
			SStgui.update_uis(src)
			return // don't smack that machine with your 2 chips

	else if(!(stat & NOPOWER))
		return

	else if(isbroken)
		return

/obj/machinery/clawmachine/proc/prizevend()
	if(LAZYLEN(prizes))
		var/prizeselect = pickweight(prizes)
		new prizeselect(src.loc)

/obj/machinery/clawmachine/proc/insert_cash(var/obj/item/spacecash/cashmoney, mob/user)
	if (ispowered == 0)
		return
	if (isbroken)
		return
	if(busy)
		to_chat(user,span_notice("The claw machine is currently running."))
		return
	if(cashmoney.worth < 5)
		to_chat(user,span_notice("You dont have enough Thalers to play!"))
		return

	to_chat(user,span_notice("You put 5 Thalers in the claw machine and press start."))
	cashmoney.worth -= 5
	cashmoney.update_icon()

	if(cashmoney.worth <= 0)
		usr.drop_from_inventory(cashmoney)
		qdel(cashmoney)
		cashmoney.update_icon()

	busy = 1
	icon_state = "clawmachine_play"
	playsound(src.loc, 'sound/machines/clawmachine_play.ogg', 50, 0)

	var/slot1 = rand(0,4)
	switch(slot1)
		if(0 to 2) symbol1 = "one"
		if(3 to 4) symbol1 = "two"

	var/slot2 = rand(0,4)
	switch(slot2)
		if(0 to 2) symbol2 = "one"
		if(3 to 4) symbol2 = "two"

	var/slot3 = rand(0,4)
	switch(slot3)
		if(0 to 2) symbol3 = "one"
		if(3 to 4) symbol3 = "two"

	var/output //Output variable to send out in chat after the large if statement.
	var/winnings = 0 //If you win a toy or not
	var/delaytime = 7 SECONDS

	spawn(delaytime)
		to_chat(user,span_notice("The clam machine lights up and starts to play!"))

		if (symbol1 == "one" && symbol2 == "one" && symbol3 == "one")
			output = span_notice("Hooray! You Win!")
			winnings = TRUE

		if (symbol1 == "two" && symbol2 == "two" && symbol3 == "two")
			output = span_notice("Hooray! You Win!!")
			winnings = TRUE

		icon_state = initial(icon_state) // Set it back to the original iconstate.

		if(!output) // Is there anything to output? If not, consider it a loss.
			to_chat(user,"Better luck next time!")
			busy = FALSE
			return

		to_chat(user,output) //Output message

		if(winnings) //Did the person win?
			icon_state = "clawmachine_win"
			prizevend()
			playsound(src.loc, 'sound/machines/clawmachine_win.ogg', 50, 0)
			spawn(delaytime)
				icon_state = "clawmachine"

		busy = FALSE
