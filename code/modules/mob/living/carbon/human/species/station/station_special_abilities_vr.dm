/mob/living/carbon/human/verb/chimera_revive()
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

		var/time = (500+1/((nutrition_used/200+1)/2500))

		C.weakened = round(time/3) //Since it takes 1 tick to lose one weaken.
		regenerating = 1
		spawn(30) //Spawn works in deciseconds.
			C << "<span class='notice'>We have regenerated.</span>"
			viewers(C) << "<span class='danger'> [C] stands up, all prior injuries gone." //OHGODITSACHANGELINGKILLIT!!
			C.setOxyLoss(0)
			C.setCloneLoss(0)
			//C.setParalysis(0) //why
			//C.setStunned(0)   //wont
			//C.setWeakened(0)  //you work
			C.radiation = 0
			C.halloss = 0
			C.canmove = 1
			regenerating = 0
			C.setToxLoss(0)
			C.shock_stage = 0 //Pain
			C.heal_overall_damage(C.getBruteLoss(), C.getFireLoss())
			C.reagents.clear_reagents()
			C.restore_all_organs() //Covers things like fractures and other things not covered by the above.
			C.stat = CONSCIOUS
			C.lying = 0
			C.sdisabilities = 0
			C.disabilities = 0
			C.bodytemperature = T20C
			C.blinded = 0
			C.eye_blind = 0
			C.restore_blood()
			C.eye_blurry = 0
			C.ear_deaf = 0
			C.ear_damage = 0
			C.update_canmove()
			return