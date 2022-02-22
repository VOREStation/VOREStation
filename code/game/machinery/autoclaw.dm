
//Original Codebase created by Shadowfire117#1269 - Ported from CHOMPstation
//Modified by GhostActual#2055 to produce Claw Machine

/*
 * Space Crane
 */

/obj/machinery/autoclaw
	name = "Space Crane"
	desc = "Try your luck at winning a cute plush toy! No refunds, and whining won't win you anything."
	description_fluff = "Donk Co. AutoClaw Machines are a revolutionary take on a classic. No more will the player \
	blame themselves for their mistakes when trying to win an awsome toy. Now it's all up to sheer blind luck!"
	icon = 'icons/obj/computer.dmi'
	icon_state = "autoclaw"
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
						/obj/item/toy/plushie/borgplushie/drakiesec,
						/obj/item/toy/plushie/borgplushie/drakiemed,
						/obj/item/toy/plushie/otter
						)

/*
 * Super Claw
 */

/obj/machinery/autoclaw/superclaw
	name = "Super Claw"
	desc = "Try your luck at winning a sweet new action figure! No refunds, and whining won't win you anything."
	icon_state = "autoclaw"
	list/prizes	= list(/obj/item/toy/figure/cmo,
						/obj/item/toy/figure/assistant,
						/obj/item/toy/figure/atmos,
						/obj/item/toy/figure/bartender,
						/obj/item/toy/figure/borg,
						/obj/item/toy/figure/gardener,
						/obj/item/toy/figure/captain,
						/obj/item/toy/figure/cargotech,
						/obj/item/toy/figure/ce,
						/obj/item/toy/figure/chaplain,
						/obj/item/toy/figure/chef,
						/obj/item/toy/figure/chemist,
						/obj/item/toy/figure/clown,
						/obj/item/toy/figure/corgi,
						/obj/item/toy/figure/detective,
						/obj/item/toy/figure/dsquad,
						/obj/item/toy/figure/engineer,
						/obj/item/toy/figure/geneticist,
						/obj/item/toy/figure/hop,
						/obj/item/toy/figure/hos,
						/obj/item/toy/figure/qm,
						/obj/item/toy/figure/janitor,
						/obj/item/toy/figure/agent,
						/obj/item/toy/figure/librarian,
						/obj/item/toy/figure/md,
						/obj/item/toy/figure/mime,
						/obj/item/toy/figure/miner,
						/obj/item/toy/figure/ninja,
						/obj/item/toy/figure/wizard,
						/obj/item/toy/figure/rd,
						/obj/item/toy/figure/roboticist,
						/obj/item/toy/figure/scientist,
						/obj/item/toy/figure/syndie,
						/obj/item/toy/figure/secofficer,
						/obj/item/toy/figure/virologist,
						/obj/item/toy/figure/warden,
						/obj/item/toy/figure/psychologist,
						/obj/item/toy/figure/paramedic,
						/obj/item/toy/figure/ert,
						/obj/item/toy/figure/ranger,
						/obj/item/toy/figure/leadbandit,
						/obj/item/toy/figure/bandit,
						/obj/item/toy/figure/abe,
						/obj/item/toy/figure/profwho,
						/obj/item/toy/figure/prisoner
						)

/*
 * Code that makes it work
 */

/obj/machinery/autoclaw/update_icon()
	cut_overlays()
	if(!ispowered || isbroken)
		icon_state = "autoclaw_off"
		if(isbroken) //If the thing is smashed, add crack overlay on top of the unpowered sprite.
			add_overlay("autoclaw_broken")
		set_light(0)
		set_light_on(FALSE)
		return

	icon_state = "autoclaw"
	set_light(2)
	set_light_on(TRUE)
	return

/obj/machinery/autoclaw/power_change()
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

/obj/machinery/autoclaw/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(busy)
		to_chat(user,"<span class='notice'>The claw machine is currently running.</span> ")
		return
	if(W.is_wrench())
		playsound(src, W.usesound, 100, 1)
		if(anchored)
			user.visible_message("[user] begins unsecuring \the [src] from the floor.", "You start unsecuring \the [src] from the floor.")
		else
			user.visible_message("[user] begins securing \the [src] to the floor.", "You start securing \the [src] to the floor.")

		if(do_after(user, 20 * W.toolspeed))
			if(!src) return
			to_chat(user, "<span class='notice'>You [anchored? "un" : ""]secured \the [src]!</span>")
			anchored = !anchored
		return

	if(!anchored)
		to_chat(user,"<span class='notice'> The machine isn't secured.</span>")
		return

	var/handled = 0
	var/paid = 0

	if(istype(W, /obj/item/weapon/spacecash))
		var/obj/item/weapon/spacecash/C = W
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

/obj/machinery/autoclaw/proc/prizevend()
	if(LAZYLEN(prizes))
		var/prizeselect = pickweight(prizes)
		new prizeselect(src.loc)

/obj/machinery/autoclaw/proc/insert_cash(var/obj/item/weapon/spacecash/cashmoney, mob/user)
	if (ispowered == 0)
		return
	if (isbroken)
		return
	if(busy)
		to_chat(user,"<span class='notice'>The claw machine is currently running.</span> ")
		return
	if(cashmoney.worth < 5)
		to_chat(user,"<span class='notice'>You dont have enough Thalers to play!</span> ")
		return

	to_chat(user,"<span class='notice'>You put 5 Thalers in the claw machine and press start.</span>")
	cashmoney.worth -= 5
	cashmoney.update_icon()

	if(cashmoney.worth <= 0)
		usr.drop_from_inventory(cashmoney)
		qdel(cashmoney)
		cashmoney.update_icon()

	busy = 1
	icon_state = "autoclaw_play"
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
		to_chat(user,"<span class='notice'>The clam machine lights up and starts to play!</span>")

		if (symbol1 == "one" && symbol2 == "one" && symbol3 == "one")
			output = "<span class='notice'>Hooray! You Win!</span>"
			winnings = TRUE

		if (symbol1 == "two" && symbol2 == "two" && symbol3 == "two")
			output = "<span class='notice'>Hooray! You Win!!</span>"
			winnings = TRUE

		icon_state = initial(icon_state) // Set it back to the original iconstate.

		if(!output) // Is there anything to output? If not, consider it a loss.
			to_chat(user,"Better luck next time!")
			busy = FALSE
			return

		to_chat(user,output) //Output message

		if(winnings) //Did the person win?
			icon_state = "autoclaw_win"
			prizevend()
			playsound(src.loc, 'sound/machines/clawmachine_win.ogg', 50, 0)
			spawn(delaytime)
				icon_state = "autoclaw"

		busy = FALSE