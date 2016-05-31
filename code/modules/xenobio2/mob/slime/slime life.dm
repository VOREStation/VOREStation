/*
Slime specific life events go here.
*/
#define HAPPYLEVEL 200
#define ANGRYLEVEL 10
/mob/living/simple_animal/xeno/slime/Life()
	. = ..()
	if(..())
		if(health)
			if(is_child)
				if(nutrition >= 275)
					growthcounter++
					nutrition -= hunger_factor
				if(nutrition <= 75)
					growthcounter--
				if(growthcounter >= growthpoint)
					src.GrowUp()
		
			else 
				if(nutrition < 0)
					nutrition = 0
				if((prob(10) && !emote_on))	//Slimes might display their food-based emotions over time.
					var/image/I = new(src.icon)
					I.color = "#FFFFFF"
					I.layer = src.layer + 0.2
					if((nutrition >= HAPPYLEVEL))
						if((nutrition >= 1.5 * HAPPYLEVEL))
							I.icon_state = "aslime-:33"
						else
							I.icon_state = "aslime-:3"
						
					else if((nutrition > ANGRYLEVEL))
						if((nutrition >= 10 * ANGRYLEVEL))
							I.icon_state = "aslime-pout"
						else if((nutrition >= 5 * ANGRYLEVEL))
							I.icon_state = "aslime-sad"
						else
							I.icon_state = "aslime-angry"
					overlays += I
					emote_on = 1
					spawn(30)
						GenerateAdultIcon()
						emote_on = null
						
		else
			if(is_child)
				icon_state = "slime baby dead"
			else
				overlays.Cut()
				icon_state = "slime adult dead"
				color = traitdat.traits[TRAIT_XENO_COLOR]
				
		return 0 //Everything worked okay
	
	return 	//xeno/Life() returned 0.