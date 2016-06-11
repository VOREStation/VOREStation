/mob/living/carbon/human/verb/chimera_revive() //Scree's race ability.in exchange for: No cloning.
	set name = "Chimera Regenerate"
	set category = "Abilities"

	if(world.time < last_special)
		return

	last_special = world.time + 50

	var/confirm = alert(usr, "Are you sure you want to regenerate? This process can take up to thirty minutes, depending on how hungry you are, and you will be unable to move.", "Confirm Regeneration", "Yes", "No")
	if(confirm == "Yes")
		var/regenerating = 0
		var/mob/living/carbon/human/C = src
		if(regenerating == 1) //If they're already unable to
			C << "You are already regenerating!"
			return
		C.canmove = 0 //Make them unable to move. In case they somehow get up before the delay.
		C << "You begin to regenerate. You will not be able to move during this time."

		var/nutrition_used = C.nutrition

		C.nutrition -= C.nutrition/2 //Cut their nutrition in half.

		var/old_nutrition = C.nutrition //Since the game is being annoying.

		var/time = (500+1/((nutrition_used/100+1)/1300))

		C.weakened = 10000 //Since it takes 1 tick to lose one weaken. Due to prior rounding errors, you'd sometimes unweaken before regenning. This fixes that.
		regenerating = 1
		spawn(time SECONDS)
			C << "<span class='notice'>We have regenerated.</span>"
			viewers(C) << "<span class='danger'><p><font size=4> [C] suddenly bursts into a gorey mess, a copy of theirself laying in the viscera and blood. What the fuck?!</font> </span>" //Bloody hell...
			var/T = get_turf(src)
			new /obj/effect/gibspawner/human/scree(T)
			regenerating = 0
			C.revive() // I did have special snowflake code, but this is easier.
			C.weakened = 2 //Not going to let you get up immediately. 2 ticks before you get up. Overrides the above 10000 weaken.
			C.nutrition = old_nutrition
			C.update_canmove()
			return

/obj/effect/gibspawner/human/scree
	fleshcolor = "#14AD8B" //Scree blood.
	bloodcolor = "#14AD8B"