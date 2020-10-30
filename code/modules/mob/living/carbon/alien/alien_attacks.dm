//There has to be a better way to define this shit. ~ Z
//can't equip anything
/mob/living/carbon/alien/attack_ui(slot_id)
	return

/mob/living/carbon/alien/attack_hand(mob/living/carbon/M as mob)

	..()

	switch(M.a_intent)

		if (I_HELP)
			help_shake_act(M)

		if (I_GRAB)
			if (M == src)
				return
			var/obj/item/weapon/grab/G = new /obj/item/weapon/grab( M, src )

			M.put_in_active_hand(G)

			grabbed_by += G
			G.affecting = src
			G.synch()

			LAssailant = M

			playsound(src, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
			for(var/mob/O in viewers(src, null))
				if ((O.client && !( O.blinded )))
					O.show_message(text("<font color='red'>[] has grabbed [] passively!</font>", M, src), 1)

		else
			var/damage = rand(1, 9)
			if (prob(90))
				if (HULK in M.mutations)
					damage += 5
					spawn(0)
						Paralyse(1)
						step_away(src,M,15)
						sleep(3)
						step_away(src,M,15)
				playsound(src, "punch", 25, 1, -1)
				for(var/mob/O in viewers(src, null))
					if ((O.client && !( O.blinded )))
						O.show_message(text("<font color='red'><B>[] has punched []!</B></font>", M, src), 1)
				if (damage > 4.9)
					Weaken(rand(10,15))
					for(var/mob/O in viewers(M, null))
						if ((O.client && !( O.blinded )))
							O.show_message(text("<font color='red'><B>[] has weakened []!</B></font>", M, src), 1, "<font color='red'>You hear someone fall.</font>", 2)
				adjustBruteLoss(damage)
				updatehealth()
			else
				playsound(src, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
				for(var/mob/O in viewers(src, null))
					if ((O.client && !( O.blinded )))
						O.show_message(text("<font color='red'><B>[] has attempted to punch []!</B></font>", M, src), 1)
	return
