/mob/living/carbon/human/proc/reconstitute_form() //Scree's race ability.in exchange for: No cloning.
	set name = "Reconstitute Form"
	set category = "Abilities"

	if(world.time < last_special)
		return

	last_special = world.time + 50 //To prevent button spam.

	var/confirm = alert(usr, "Are you sure you want to completely reconstruct your form?? This process can take up to thirty minutes, depending on how hungry you are, and you will be unable to move.", "Confirm Regeneration", "Yes", "No")
	if(confirm == "Yes")
		var/mob/living/carbon/human/C = src
		var/nutrition_used = C.nutrition/2

		if(C.species.reviving == 1) //If they're already unable to
			C << "You are already reconstructing!"
			return

		if(C.stat == DEAD) //Uh oh, you died!
			if(C.reagents.has_reagent("nutriment")) //Let's hope you have nutriment in you.... If not
				C.nutrition -= C.nutrition/2 //Cut their nutrition in half.
				var/old_nutrition = C.nutrition //Since the game is being annoying.
				var/time = (500+1/((nutrition_used/100+1)/1300))
				C.weakened = 10000 //Since it takes 1 tick to lose one weaken. Due to prior rounding errors, you'd sometimes unweaken before regenning. This fixes that.
				C.species.reviving = 1
				C.canmove = 0 //Make them unable to move. In case they somehow get up before the delay.
				C << "You begin to reconstruct your form. You will not be able to move during this time. It should take aproximately [round(time)] seconds."

				spawn(time SECONDS)
					if(C) //Runtime prevention.
						C << "<span class='notice'>We have reconstituted our form.</span>"
						viewers(C) << "<span class='danger'><p><font size=4> [C] suddenly bursts into a gorey mess, a copy of theirself laying in the viscera and blood. What the fuck?!</font> </span>" //Bloody hell...
						var/T = get_turf(src)
						new /obj/effect/gibspawner/human/scree(T)
						var/braindamage = C.brainloss/2 //If you have 100 brainloss, it gives you 50.
						C.species.reviving = 0
						C.revive() // I did have special snowflake code, but this is easier.
						C.weakened = 2 //Not going to let you get up immediately. 2 ticks before you get up. Overrides the above 10000 weaken.
						C.nutrition = old_nutrition
						C.brainloss = (braindamage+10) //Gives them half their prior brain damage plus ten more.
						C.bruteloss = (10) //There is some moderate damage from completely recreating yourself. Not much, but some. Natural health regen should heal it over time.
						C.update_canmove()
						for(var/obj/item/W in C)
							C.drop_from_inventory(W)
						return
					else
						return //Something went wrong.
			else //Dead until nutrition injected.
				C << "You're dead and have no liquid nutriment to use for the regeneration process."
				return

		else if(C.stat != DEAD) //If they're alive at the time of reviving.
			C.nutrition -= C.nutrition/2 //Cut their nutrition in half.
			var/old_nutrition = C.nutrition //Since the game is being annoying.
			var/time = (500+1/((nutrition_used/100+1)/1300))
			C.weakened = 10000 //Since it takes 1 tick to lose one weaken. Due to prior rounding errors, you'd sometimes unweaken before regenning. This fixes that.
			C.species.reviving	 = 1
			C.canmove = 0 //Make them unable to move. In case they somehow get up before the delay.
			C << "You begin to reconstruct your form. You will not be able to move during this time. It should take aproximately [round(time)] seconds."

			spawn(time SECONDS) //Not going to do another "if stat = dead" check because that'd make me have to do more lines than needed.
				if(C.stat == CONSCIOUS || C.stat == UNCONSCIOUS) //If they're alive still after regenning.
					C << "<span class='notice'>We have reconstituted our form.</span>"
					viewers(C) << "<span class='danger'><p><font size=4> [C] suddenly bursts into a gorey mess, a copy of theirself laying in the viscera and blood. What the fuck?!</font> </span>" //Bloody hell...
					var/T = get_turf(src)
					new /obj/effect/gibspawner/human/scree(T)
					var/braindamage = C.brainloss/2 //If you have 100 brainloss, it gives you 50.
					C.species.reviving = 0
					C.revive() // I did have special snowflake code, but this is easier.
					C.weakened = 2 //Not going to let you get up immediately. 2 ticks before you get up. Overrides the above 10000 weaken.
					C.nutrition = old_nutrition
					C.brainloss = (braindamage) //Gives them half their prior brain damage plus ten more.
					C.update_canmove()
					for(var/obj/item/W in C)
						C.drop_from_inventory(W)
					return
				else if(C.stat == DEAD)
					if(C.reagents.has_reagent("nutriment")) //Let's hope you have nutriment in you.... If not
						C.nutrition -= C.nutrition/2 //Cut their nutrition in half.
						C.weakened = 10000 //Since it takes 1 tick to lose one weaken. Due to prior rounding errors, you'd sometimes unweaken before regenning. This fixes that.
						C.species.reviving = 1
						C.canmove = 0 //Make them unable to move. In case they somehow get up before the delay.
						C << "You begin to reconstruct your form. You will not be able to move during this time. It should take aproximately [round(time)] seconds."

						spawn(time SECONDS)
							C << "<span class='notice'>We have reconstituted our form.</span>"
							viewers(C) << "<span class='danger'><p><font size=4> [C] suddenly bursts into a gorey mess, a copy of theirself laying in the viscera and blood. What the fuck?!</font> </span>" //Bloody hell...
							var/T = get_turf(src)
							new /obj/effect/gibspawner/human/scree(T)
							var/braindamage = C.brainloss/2 //If you have 100 brainloss, it gives you 50.
							C.species.reviving = 0
							C.revive() // I did have special snowflake code, but this is easier.
							C.weakened = 2 //Not going to let you get up immediately. 2 ticks before you get up. Overrides the above 10000 weaken.
							C.nutrition = old_nutrition
							C.brainloss = (braindamage+10) //Gives them half their prior brain damage plus ten more.
							C.bruteloss = (10) //There is some moderate damage from completely recreating yourself. Not much, but some. Natural health regen should heal it over time.
							C.update_canmove()
							for(var/obj/item/W in C)
								C.drop_from_inventory(W)
							return
					else //Dead until nutrition injected.
						C << "You're dead and have no liquid nutriment to use for the regeneration process."
						return
				else
					return //Something went wrong
		else
			return //Something went wrong

/obj/effect/gibspawner/human/scree
	fleshcolor = "#14AD8B" //Scree blood.
	bloodcolor = "#14AD8B"