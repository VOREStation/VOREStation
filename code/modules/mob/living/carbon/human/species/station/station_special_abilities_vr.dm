/mob/living/carbon/human/proc/begin_reconstitute_form() //Scree's race ability.in exchange for: No cloning.
	set name = "Begin Reconstitute Form"
	set category = "Abilities"

	if(world.time < last_special)
		return

	last_special = world.time + 50 //To prevent button spam.

	var/confirm = alert(usr, "Are you sure you want to completely reconstruct your form? This process can take up to thirty minutes, depending on how hungry you are, and you will be unable to move.", "Confirm Regeneration", "Yes", "No")
	if(confirm == "Yes")
		var/mob/living/carbon/human/C = src
		var/nutrition_used = C.nutrition/2

		if(C.reviving == 1) //If they're already unable to
			C << "You are already reconstructing, or your body is currently recovering from the intense process of your previous reconstitution."
			return

		if(C.stat == DEAD) //Uh oh, you died!
			if(C.hasnutriment()) //Let's hope you have nutriment in you.... If not
				var/time = (500+1/((nutrition_used/100+1)/1300))
				C.weakened = 10000 //Since it takes 1 tick to lose one weaken. Due to prior rounding errors, you'd sometimes unweaken before regenning. This fixes that.
				C.reviving = 1
				C.canmove = 0 //Make them unable to move. In case they somehow get up before the delay.
				C << "You begin to reconstruct your form. You will not be able to move during this time. It should take aproximately [round(time)] seconds."
				C.does_not_breathe = 1 //effectively makes them spaceworthy while regenning

				spawn(time SECONDS)
					if(C) //Runtime prevention.
						C << "<span class='notice'>Consciousness begins to stir as your new body awakens, ready to hatch..</span>"
						C.verbs += /mob/living/carbon/human/proc/hatch
						return
					else
						return //Something went wrong.
			else //Dead until nutrition injected.
				C << "Your body is too damaged to regenerate without additional nutrients to feed what few living cells remain."
				return

		else if(C.stat != DEAD) //If they're alive at the time of reviving.
			var/time = (500+1/((nutrition_used/100+1)/1300))
			C.weakened = 10000 //Since it takes 1 tick to lose one weaken. Due to prior rounding errors, you'd sometimes unweaken before regenning. This fixes that.
			C.reviving = 1
			C.canmove = 0 //Make them unable to move. In case they somehow get up before the delay.
			C << "You begin to reconstruct your form. You will not be able to move during this time. It should take aproximately [round(time)] seconds."
			C.does_not_breathe = 1 //effectively makes them spaceworthy while regenning

			spawn(time SECONDS)
				if(C.stat != DEAD) //If they're still alive after regenning.
					C << "<span class='notice'>Consciousness begins to stir as your new body awakens, ready to hatch..</span>"
					C.verbs += /mob/living/carbon/human/proc/hatch
					return
				else if(C.stat == DEAD)
					if(C.hasnutriment()) //Let's hope you have nutriment in you.... If not
						C << "<span class='notice'>Consciousness begins to stir as your new body awakens, ready to hatch..</span>"
						C.verbs += /mob/living/carbon/human/proc/hatch
					else //Dead until nutrition injected.
						C << "Your body was unable to regenerate, what few living cells remain require additional nutrients to complete the process."
						C.reviving = 0 // so they can try again when they're given a kickstart
						return
				else
					return //Something went wrong
		else
			return //Something went wrong



/mob/living/carbon/human/proc/hasnutriment()
	if (src.bloodstr.has_reagent("nutriment", 30) || src.bloodstr.has_reagent("protein", 15)) //protein needs half as much. For reference, a steak contains 9u protein.
		return 1
	else if (src.ingested.has_reagent("nutriment", 60) || src.ingested.has_reagent("protein", 30)) //try forcefeeding them, why not. Less effective.
		return 1
	else return 0


/mob/living/carbon/human/proc/hatch()
	set name = "Hatch"
	set category = "Abilities"

	if(world.time < last_special)
		return

	last_special = world.time + 50 //To prevent button spam.

	var/confirm = alert(usr, "Are you sure you want to reconstruct your form this moment? This will happen immediately and alert an.", "Confirm Regeneration", "Yes", "No")
	if(confirm == "Yes")
		var/mob/living/carbon/human/C = src
		if(C.stat == DEAD) //Uh oh, you died!
			if(C.reagents.has_reagent("nutriment")) //Let's hope you have nutriment in you.... If not
				if(C) //Runtime prevention.
					C.nutrition -= C.nutrition/2 //Cut their nutrition in half.
					var/old_nutrition = C.nutrition //Since the game is being annoying.
					C << "<span class='notice'>Your new body awakens, bursting free from your old skin.</span>"
					viewers(C) << "<span class='danger'><p><font size=4>The lifeless husk of [C] bursts open, revealing a new, intact copy in the pool of viscera.</font></p></span>" //Bloody hell...
					var/T = get_turf(src)
					new /obj/effect/gibspawner/human/scree(T)
					var/braindamage = C.brainloss/2 //If you have 100 brainloss, it gives you 50.
					C.does_not_breathe = 0 //start breathing again
					C.revive() // I did have special snowflake code, but this is easier.
					C.weakened = 2 //Not going to let you get up immediately. 2 ticks before you get up. Overrides the above 10000 weaken.
					C.nutrition = old_nutrition
					C.brainloss = (braindamage+10) //Gives them half their prior brain damage plus ten more.
					C.update_canmove()
					for(var/obj/item/W in C)
						C.drop_from_inventory(W)
					spawn(3600 SECONDS) //1 hour wait until you can revive.
						C.reviving = 0
					C.verbs -= /mob/living/carbon/human/proc/hatch
					return
				else
					return //Ruuntime prevention
			else
				return //Something went wrong.

		else if(C.stat != DEAD) //If they're alive at the time of reviving.
			C.nutrition -= C.nutrition/2 //Cut their nutrition in half.
			var/old_nutrition = C.nutrition //Since the game is being annoying.
			C << "<span class='notice'>Your new body awakens, bursting free from your old skin.</span>"
			viewers(C) << "<span class='danger'><p><font size=4>The dormant husk of [C] bursts open, revealing a new, intact copy in the pool of viscera.</font></p></span>" //Bloody hell...
			var/T = get_turf(src)
			new /obj/effect/gibspawner/human/scree(T)
			var/braindamage = C.brainloss/2 //If you have 100 brainloss, it gives you 50.
			C.revive() // I did have special snowflake code, but this is easier.
			C.weakened = 2 //Not going to let you get up immediately. 2 ticks before you get up. Overrides the above 10000 weaken.
			C.nutrition = old_nutrition
			C.brainloss = (braindamage) //Gives them half their prior brain damage plus ten more.
			C.update_canmove()
			for(var/obj/item/W in C)
				C.drop_from_inventory(W)
			spawn(3600 SECONDS) //1 hour wait until you can revive again.
				C.reviving = 0
			C.does_not_breathe = 0 //start breathing again
			C.verbs -= /mob/living/carbon/human/proc/hatch
			return
		else
			return //Runtime prevention.

/obj/effect/gibspawner/human/scree
	fleshcolor = "#14AD8B" //Scree blood.
	bloodcolor = "#14AD8B"

/mob/living/carbon/human/proc/getlightlevel() //easier than having the same code in like three places
	if(isturf(src.loc)) //else, there's considered to be no light
		var/turf/T = src.loc
		return T.get_lumcount() * 5
	else return 0

/mob/living/carbon/human/proc/handle_feral()
	if(handling_hal) return //avoid conflict with actual hallucinations
	handling_hal = 1
	var/light_amount = getlightlevel() //how much light there is in the place

	while(client && feral > 10 && light_amount >= 0.5) // largely a copy of handle_hallucinations() without the fake attackers
		light_amount = getlightlevel()
		sleep(rand(200,500)/(feral/10))
		var/halpick = rand(1,100)
		switch(halpick)
			if(0 to 15) //15% chance
				//Screwy HUD
				//src << "Screwy HUD"
				hal_screwyhud = pick(1,2,3,3,4,4)
				spawn(rand(100,250))
					hal_screwyhud = 0
			if(16 to 25) //10% chance
				//Strange items
				//src << "Traitor Items"
				if(!halitem)
					halitem = new
					var/list/slots_free = list(ui_lhand,ui_rhand)
					if(l_hand) slots_free -= ui_lhand
					if(r_hand) slots_free -= ui_rhand
					if(istype(src,/mob/living/carbon/human))
						var/mob/living/carbon/human/H = src
						if(!H.belt) slots_free += ui_belt
						if(!H.l_store) slots_free += ui_storage1
						if(!H.r_store) slots_free += ui_storage2
					if(slots_free.len)
						halitem.screen_loc = pick(slots_free)
						halitem.layer = 50
						switch(rand(1,6))
							if(1) //revolver
								halitem.icon = 'icons/obj/gun.dmi'
								halitem.icon_state = "revolver"
								halitem.name = "Revolver"
							if(2) //c4
								halitem.icon = 'icons/obj/assemblies.dmi'
								halitem.icon_state = "plastic-explosive0"
								halitem.name = "Mysterious Package"
								if(prob(25))
									halitem.icon_state = "c4small_1"
							if(3) //sword
								halitem.icon = 'icons/obj/weapons.dmi'
								halitem.icon_state = "sword1"
								halitem.name = "Sword"
							if(4) //stun baton
								halitem.icon = 'icons/obj/weapons.dmi'
								halitem.icon_state = "stunbaton"
								halitem.name = "Stun Baton"
							if(5) //emag
								halitem.icon = 'icons/obj/card.dmi'
								halitem.icon_state = "emag"
								halitem.name = "Cryptographic Sequencer"
							if(6) //flashbang
								halitem.icon = 'icons/obj/grenade.dmi'
								halitem.icon_state = "flashbang1"
								halitem.name = "Flashbang"
						if(client) client.screen += halitem
						spawn(rand(100,250))
							if(client)
								client.screen -= halitem
							halitem = null
			if(26 to 35) //10% chance
				//Flashes of danger
				//src << "Danger Flash"
				if(!halimage)
					var/list/possible_points = list()
					for(var/turf/simulated/floor/F in view(src,world.view))
						possible_points += F
					if(possible_points.len)
						var/turf/simulated/floor/target = pick(possible_points)

						switch(rand(1,3))
							if(1)
								//src << "Space"
								halimage = image('icons/turf/space.dmi',target,"[rand(1,25)]",TURF_LAYER)
							if(2)
								//src << "Fire"
								halimage = image('icons/effects/fire.dmi',target,"1",TURF_LAYER)
							if(3)
								//src << "C4"
								halimage = image('icons/obj/assemblies.dmi',target,"plastic-explosive2",OBJ_LAYER+0.01)


						if(client) client.images += halimage
						spawn(rand(10,50)) //Only seen for a brief moment.
							if(client) client.images -= halimage
							halimage = null

			if(36 to 55) //20% chance
				//Strange audio
				//src << "Strange Audio"
				switch(rand(1,12))
					if(1) src << 'sound/machines/airlock.ogg'
					if(2)
						if(prob(50))src << 'sound/effects/Explosion1.ogg'
						else src << 'sound/effects/Explosion2.ogg'
					if(3) src << 'sound/effects/explosionfar.ogg'
					if(4) src << 'sound/effects/Glassbr1.ogg'
					if(5) src << 'sound/effects/Glassbr2.ogg'
					if(6) src << 'sound/effects/Glassbr3.ogg'
					if(7) src << 'sound/machines/twobeep.ogg'
					if(8) src << 'sound/machines/windowdoor.ogg'
					if(9)
						//To make it more realistic, I added two gunshots (enough to kill)
						src << 'sound/weapons/Gunshot.ogg'
						spawn(rand(10,30))
							src << 'sound/weapons/Gunshot.ogg'
					if(10) src << 'sound/weapons/smash.ogg'
					if(11)
						//Same as above, but with tasers.
						src << 'sound/weapons/Taser.ogg'
						spawn(rand(10,30))
							src << 'sound/weapons/Taser.ogg'
				//Rare audio
					if(12)
//These sounds are (mostly) taken from Hidden: Source
						var/list/creepyasssounds = list('sound/effects/ghost.ogg', 'sound/effects/ghost2.ogg', 'sound/effects/Heart Beat.ogg', 'sound/effects/screech.ogg',\
							'sound/hallucinations/behind_you1.ogg', 'sound/hallucinations/behind_you2.ogg', 'sound/hallucinations/far_noise.ogg', 'sound/hallucinations/growl1.ogg', 'sound/hallucinations/growl2.ogg',\
							'sound/hallucinations/growl3.ogg', 'sound/hallucinations/im_here1.ogg', 'sound/hallucinations/im_here2.ogg', 'sound/hallucinations/i_see_you1.ogg', 'sound/hallucinations/i_see_you2.ogg',\
							'sound/hallucinations/look_up1.ogg', 'sound/hallucinations/look_up2.ogg', 'sound/hallucinations/over_here1.ogg', 'sound/hallucinations/over_here2.ogg', 'sound/hallucinations/over_here3.ogg',\
							'sound/hallucinations/turn_around1.ogg', 'sound/hallucinations/turn_around2.ogg', 'sound/hallucinations/veryfar_noise.ogg', 'sound/hallucinations/wail.ogg')
						src << pick(creepyasssounds)
			if(56 to 60) //5% chance
				//Flashes of danger
				//src << "Danger Flash"
				if(!halbody)
					var/list/possible_points = list()
					for(var/turf/simulated/floor/F in view(src,world.view))
						possible_points += F
					if(possible_points.len)
						var/turf/simulated/floor/target = pick(possible_points)
						switch(rand(1,4))
							if(1)
								halbody = image('icons/mob/human.dmi',target,"husk_l",TURF_LAYER)
							if(2,3)
								halbody = image('icons/mob/human.dmi',target,"husk_s",TURF_LAYER)
							if(4)
								halbody = image('icons/mob/alien.dmi',target,"alienother",TURF_LAYER)
	//						if(5)
	//							halbody = image('xcomalien.dmi',target,"chryssalid",TURF_LAYER)

						if(client) client.images += halbody
						spawn(rand(50,80)) //Only seen for a brief moment.
							if(client) client.images -= halbody
							halbody = null
			if(61 to 85) //25% chance
				//food
				if(!halbody)
					var/list/possible_points = list()
					for(var/turf/simulated/floor/F in view(src,world.view))
						possible_points += F
					if(possible_points.len)
						var/turf/simulated/floor/target = pick(possible_points)
						switch(rand(1,10))
							if(1)
								halbody = image('icons/mob/animal.dmi',target,"cow",TURF_LAYER)
							if(2)
								halbody = image('icons/mob/animal.dmi',target,"chicken",TURF_LAYER)
							if(3)
								halbody = image('icons/obj/food.dmi',target,"bigbiteburger",TURF_LAYER)
							if(4)
								halbody = image('icons/obj/food.dmi',target,"meatbreadslice",TURF_LAYER)
							if(5)
								halbody = image('icons/obj/food.dmi',target,"sausage",TURF_LAYER)
							if(6)
								halbody = image('icons/obj/food.dmi',target,"bearmeat",TURF_LAYER)
							if(7)
								halbody = image('icons/obj/food.dmi',target,"fishfillet",TURF_LAYER)
							if(8)
								halbody = image('icons/obj/food.dmi',target,"meat",TURF_LAYER)
							if(9)
								halbody = image('icons/obj/food.dmi',target,"meatstake",TURF_LAYER)
							if(10)
								halbody = image('icons/obj/food.dmi',target,"monkeysdelight",TURF_LAYER)

						if(client) client.images += halbody
						spawn(rand(50,80)) //Only seen for a brief moment.
							if(client) client.images -= halbody
							halbody = null
			if(86 to 100) //15% chance
				//disorientation
				if(client)
					client.dir = pick(2,4,8)
					spawn(rand(20,50))
						client.dir = 1

	handling_hal = 0
	return
