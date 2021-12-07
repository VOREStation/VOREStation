/obj/machinery/wish_granter
	name = "Wish Granter"
	desc = "You're not so sure about this, anymore..."
	icon = 'icons/obj/device.dmi'
	icon_state = "syndbeacon"

	anchored = 1
	density = 1
	use_power = USE_POWER_OFF

	var/chargesa = 1
	var/insistinga = 0

/obj/machinery/wish_granter/attack_hand(var/mob/living/carbon/human/user as mob)
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
				to_chat(user, "The Wish Granter punishes you for your selfishness, claiming your soul.")
				if (!(LASER in user.mutations))
					user.mutations.Add(LASER)
					to_chat(user, "<span class='notice'>You feel pressure building behind your eyes.</span>")
				if (!(COLD_RESISTANCE in user.mutations))
					user.mutations.Add(COLD_RESISTANCE)
					to_chat(user, "<span class='notice'>Your body feels warm.</span>")
				if (!(XRAY in user.mutations))
					user.mutations.Add(XRAY)
					user.sight |= (SEE_MOBS|SEE_OBJS|SEE_TURFS)
					user.see_in_dark = 8
					user.see_invisible = SEE_INVISIBLE_LEVEL_TWO
					to_chat(user, "<span class='notice'>The walls suddenly disappear.</span>")
			if("Wealth")
				to_chat(user, "<B>Your wish is granted, but at a terrible cost...</B>")
				to_chat(user, "The Wish Granter punishes you for your selfishness, claiming your soul.")
				new /obj/structure/closet/syndicate/resources/everything(loc)
			if("To Kill")
				to_chat(user, "<B>Your wish is granted, but at a terrible cost...</B>")
				to_chat(user, "The Wish Granter is outraged at your excessive wickedness, yet grants you your wish regardless. Someone will be killed soon.")
				spawn(100)
					if(user)
						to_chat(user, "Suddenly, you feel as though you are being torn to countless shreds! Your wish is coming true!")
						user.gib()
			if("Peace")
				to_chat(user, "<B>Whatever alien sentience that the Wish Granter possesses is satisfied with your wish. There is a distant wailing as the last of the Faithless begin to die, then silence.</B>")
				to_chat(user, "You feel as if you just narrowly avoided a terrible fate...")
				for(var/mob/living/simple_mob/faithless/F in living_mob_list)
					F.health = -10
					F.set_stat(DEAD)
					F.icon_state = "faithless_dead"