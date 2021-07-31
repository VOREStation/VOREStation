
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

/obj/machinery/clawmachine/attackby(obj/item/weapon/W as obj, mob/user as mob)

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

/obj/machinery/clawmachine/proc/prizevend()
	if(LAZYLEN(prizes))
		var/prizeselect = pickweight(prizes)
		new prizeselect(src.loc)

/obj/machinery/clawmachine/proc/insert_cash(var/obj/item/weapon/spacecash/cashmoney, mob/user)
	if (busy)
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
			icon_state = "clawmachine_win"
			prizevend()
			playsound(src.loc, 'sound/machines/clawmachine_win.ogg', 50, 0)
			spawn(delaytime)
				icon_state = "clawmachine"

		busy = FALSE