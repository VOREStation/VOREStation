/datum/modifier/underwater_stealth
	name = "underwater stealth"
	desc = "You are currently underwater, rendering it more difficult to see you and enabling you to move quicker, thanks to your aquatic nature."

	on_created_text = "<span class='warning'>You sink under the water.</span>"
	on_expired_text = "<span class='notice'>You come out from the water.</span>"

	stacks = MODIFIER_STACK_FORBID

	slowdown = -1.5							//A bit faster when actually submerged fully in water, as you're not waddling through it.
	siemens_coefficient = 1.5 				//You are, however, underwater. Getting shocked will hurt.

	outgoing_melee_damage_percent = 0.75 	//You are swinging a sword under water...Good luck.
	accuracy = -50							//You're underwater. Good luck shooting a gun. (Makes shots as if you were 3.33 tiles further.)
	evasion = 30							//You're underwater and a bit harder to hit.

/datum/modifier/underwater_stealth/on_applied()
	holder.alpha = 50
	return

/datum/modifier/underwater_stealth/on_expire()
	holder.alpha = 255
	return

/datum/modifier/underwater_stealth/tick()
	if(holder.stat == DEAD)
		expire(silent = TRUE) //If you're dead you float to the top.
	if(istype(holder.loc, /turf/simulated/floor/water))
		var/turf/simulated/floor/water/water_floor = holder.loc
		if(water_floor.depth < 1) //You're not in deep enough water anymore.
			expire(silent = FALSE)
	else
		expire(silent = FALSE)


//Adrenaline system begin//
/datum/modifier/adrenaline_unsteady
	name = "Unsteady hands"
	desc =" Over-exertion is making it difficult to keep a steady hand!"

	on_created_text = "<span class='warning'> Over-exertion is making it hard to keep a steady hand! </span>"
	on_expired_text = "<span class='notice'>Your muscles and breathing returns to normal.</span>"

	stacks = MODIFIER_STACK_FORBID

	accuracy = -15
	outgoing_melee_damage_percent = 0.8

/datum/modifier/adrenaline_jittery
	name = "Jittery hands"
	desc = "Over-worked muscles make it very difficult to keep a steady hand!"

	on_created_text = "<span class='warning'> Over-exertion is making it almost impossible to keep a steady hand! </span>"
	on_expired_text = "<span class='notice'> Keeping aim is still difficult, but it's not as bad now.</span>"

	stacks = MODIFIER_STACK_FORBID

	accuracy = -70
	outgoing_melee_damage_percent = 0.6

