/mob/living/carbon/human/proc/begin_reconstitute_form() //Scree's race ability.in exchange for: No cloning.
	set name = "Begin Reconstitute Form"
	set category = "Abilities"

	if(world.time < last_special)
		return

	last_special = world.time + 50 //To prevent button spam.

	var/confirm = alert(usr, "Are you sure you want to completely reconstruct your form? This process can take up to twenty minutes, depending on how hungry you are, and you will be unable to move.", "Confirm Regeneration", "Yes", "No")
	if(confirm == "Yes")
		var/mob/living/carbon/human/C = src
		var/nutrition_used = C.nutrition/2

		if(C.reviving == 1) //If they're already unable to
			C << "You are already reconstructing, or your body is currently recovering from the intense process of your previous reconstitution."
			return

		if(C.stat == DEAD) //Uh oh, you died!
			if(C.hasnutriment()) //Let's hope you have nutriment in you.... If not
				var/time = (240+960/(1 + nutrition_used/75))
				C.weakened = 10000 //Since it takes 1 tick to lose one weaken. Due to prior rounding errors, you'd sometimes unweaken before regenning. This fixes that.
				C.reviving = 1
				C.canmove = 0 //Make them unable to move. In case they somehow get up before the delay.
				C << "You begin to reconstruct your form. You will not be able to move during this time. It should take aproximately [round(time)] seconds."
				C.does_not_breathe = 1 //effectively makes them spaceworthy while regenning

				for(var/obj/item/organ/E in C.bad_external_organs)
					var/obj/item/organ/external/affected = E
					for(var/datum/wound/W in affected.wounds) // Fix internal bleeds at the start of the rejuv process.
						if(istype(W, /datum/wound/internal_bleeding))
							affected.wounds -= W
							affected.update_damages()

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
			var/time = (240+960/(1 + nutrition_used/75))
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

/mob/living/carbon/human/proc/purge_impurities() //a lesser regeneration that just purges toxin/infections without healing. Does NOT clear reagents.
	set name = "Purge Impurities"
	set category = "Abilities"

	if(world.time < last_special)
		return

	last_special = world.time + 50 //To prevent button spam.

	var/mob/living/carbon/human/C = src

	if(C.reviving == 1) //If they're already unable to
		C << "Your body is currently still recovering from the last time you healed."
		return

	C.reviving = 1 // apply cooldown, this also locks out their main regen.
	C << "<span class='notice'>You start to purge your body of poisons and intruders...</span>"

	var/grossness = min(100, toxloss*5)

	for(var/i = 0, i<10,i++) // tick some tox down. This'll clear 20 toxloss in total.
		if(C)
			C.adjustToxLoss(-2)
			sleep(10)

	for(var/obj/item/organ/external/E in C.organs) //half the germ_level of everything. If they're anything short of outright necrotic they'll be fine.
		var/obj/item/organ/external/G = E
		if(G.germ_level)
			grossness += G.germ_level/10
			G.germ_level = min(0, (G.germ_level/2) - 100)

	for(var/obj/item/organ/internal/I in C.internal_organs)
		var/obj/item/organ/internal/G = I
		if(G.germ_level)
			grossness += G.germ_level/5
			G.germ_level = min(0, (G.germ_level/2) - 100)

	//and now comes the fun part because they're gross
	for (var/i = 0, i< grossness/10,i++)
		if (prob(min(100, grossness)))
			C << "<span class='warning'>You feel nauseous...</span>"
			sleep(30)
			if(prob(min(100, grossness/2))) // relatively small chance unless they really let themselves go to shit
				C << "<span class='warning'>You double over, gagging!</span>"
				C.Stun(3)
			C.vomit()
		sleep(50)

	C << "<span class='notice'>You have finished purging your body of impurities.</span>"

	spawn(300 SECONDS) //5 minute wait until you can purge or regenerate again.
		C.reviving = 0


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

	var/confirm = alert(usr, "Are you sure you want to hatch right now? This will be very obvious to anyone in view.", "Confirm Regeneration", "Yes", "No")
	if(confirm == "Yes")
		var/mob/living/carbon/human/C = src
		if(C.stat == DEAD) //Uh oh, you died!
			if(C.hasnutriment()) //Let's hope you have nutriment in you.... If not
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
					C.mutations.Remove(HUSK)
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
			C.mutations.Remove(HUSK)
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

	if(client && feral) // largely a copy of handle_hallucinations() without the fake attackers. Unlike hallucinations, only fires once - if they're still feral they'll get hit again anyway.
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


/mob/living/carbon/human/proc/bloodsuck()
	set name = "Partially Drain prey of blood"
	set desc = "Bites prey and drains them of a significant portion of blood, feeding you in the process. You may only do this once per minute."
	set category = "Abilities"

	if(last_special > world.time)
		return

	if(stat || paralysis || stunned || weakened || lying || restrained() || buckled)
		src << "You cannot bite anyone in your current state!"
		return

	var/list/choices = list()
	for(var/mob/living/carbon/human/M in view(1,src))
		if(!istype(M,/mob/living/silicon) && Adjacent(M))
			choices += M
	choices -= src

	var/mob/living/carbon/human/B = input(src,"Who do you wish to bite?") as null|anything in choices

	if(!B || !src || src.stat) return

	if(!Adjacent(B)) return

	if(last_special > world.time) return

	if(stat || paralysis || stunned || weakened || lying || restrained() || buckled)
		src << "You cannot bite in your current state."
		return
	if(B.vessel.total_volume <= 0 || B.isSynthetic()) //Do they have any blood in the first place, and are they synthetic?
		src << "<font color='red'>There appears to be no blood in this prey...</font>"
		return

	last_special = world.time + 600
	src.visible_message("<font color='red'><b>[src] moves their head next to [B]'s neck, seemingly looking for something!</b></font>")

	if(do_after(src, 300, B)) //Thrirty seconds.
		if(!Adjacent(B)) return
		src.visible_message("<font color='red'><b>[src] suddenly extends their fangs and plunges them down into [B]'s neck!</b></font>")
		B.apply_damage(5, BRUTE, BP_HEAD) //You're getting fangs pushed into your neck. What do you expect????
		B.drip(80) //Remove enough blood to make them a bit woozy, but not take oxyloss.
		src.nutrition += 400
		sleep(50)
		B.drip(1)
		sleep(50)
		B.drip(1)


//Welcome to the adapted changeling absorb code.
/mob/living/carbon/human/proc/succubus_drain()
	set name = "Drain prey of nutrition"
	set desc = "Slowly drain prey of all the nutrition in their body, feeding you in the process. You may only do this to one person at a time."
	set category = "Abilities"
	if(!ishuman(src))
		return //If you're not a human you don't have permission to do this.
	var/mob/living/carbon/human/C = src
	var/obj/item/weapon/grab/G = src.get_active_hand()
	if(!istype(G))
		to_chat(C, "<span class='warning'>You must be grabbing a creature in your active hand to absorb them.</span>")
		return

	var/mob/living/carbon/human/T = G.affecting // I must say, this is a quite ingenious way of doing it. Props to the original coders.
	if(!istype(T) || T.isSynthetic())
		to_chat(src, "<span class='warning'>\The [T] is not able to be drained.</span>")
		return

	if(G.state != GRAB_NECK)
		to_chat(C, "<span class='warning'>You must have a tighter grip to drain this creature.</span>")
		return

	if(C.absorbing_prey)
		to_chat(C, "<span class='warning'>You are already draining someone!</span>")
		return

	C.absorbing_prey = 1
	for(var/stage = 1, stage<=100, stage++) //100 stages.
		switch(stage)
			if(1)
				to_chat(C, "<span class='notice'>You begin to drain [T]...</span>")
				to_chat(T, "<span class='danger'>An odd sensation flows through your body as [C] begins to drain you!</span>")
				C.nutrition = (C.nutrition + (T.nutrition*0.05)) //Drain a small bit at first. 5% of the prey's nutrition.
				T.nutrition = T.nutrition*0.95
			if(2)
				to_chat(C, "<span class='notice'>You feel stronger with every passing moment of draining [T].</span>")
				src.visible_message("<span class='danger'>[C] seems to be doing something to [T], resulting in [T]'s body looking weaker with every passing moment!</span>")
				to_chat(T, "<span class='danger'>You feel weaker with every passing moment as [C] drains you!</span>")
				C.nutrition = (C.nutrition + (T.nutrition*0.1))
				T.nutrition = T.nutrition*0.9
			if(3 to 99)
				C.nutrition = (C.nutrition + (T.nutrition*0.1)) //Just keep draining them.
				T.nutrition = T.nutrition*0.9
				T.eye_blurry += 5 //Some eye blurry just to signify to the prey that they are still being drained. This'll stack up over time, leave the prey a bit more "weakened" after the deed is done.
				if(T.nutrition < 100 && stage < 99 && C.drain_finalized == 1)//Did they drop below 100 nutrition? If so, immediately jump to stage 99 so it can advance to 100.
					stage = 99
				if(C.drain_finalized != 1 && stage == 99) //Are they not finalizing and the stage hit 100? If so, go back to stage 3 until they finalize it.
					stage = 3
			if(100)
				C.nutrition = (C.nutrition + T.nutrition)
				T.nutrition = 0 //Completely drained of everything.
				var/damage_to_be_applied = T.species.total_health //Get their max health.
				T.apply_damage(damage_to_be_applied, HALLOSS) //Knock em out.
				C.absorbing_prey = 0
				to_chat(C, "<span class='notice'>You have completely drained [T], causing them to pass out.</span>")
				to_chat(T, "<span class='danger'>You feel weak, as if you have no control over your body whatsoever as [C] finishes draining you.!</span>")
				T.attack_log += text("\[[time_stamp()]\] <font color='red'>Was drained by [key_name(C)]</font>")
				C.attack_log += text("\[[time_stamp()]\] <font color='orange'> Drained [key_name(T)]</font>")
				msg_admin_attack("[key_name(T)] was completely drained of all nutrition by [key_name(C)]")
				return

		if(!do_mob(src, T, 50) || G.state != GRAB_NECK) //One drain tick every 5 seconds.
			to_chat(src, "<span class='warning'>Your draining of [T] has been interrupted!</span>")
			C.absorbing_prey = 0
			return

/mob/living/carbon/human/proc/succubus_drain_lethal()
	set name = "Lethally drain prey" //Provide a warning that THIS WILL KILL YOUR PREY.
	set desc = "Slowly drain prey of all the nutrition in their body, feeding you in the process. Once prey run out of nutrition, you will begin to drain them lethally. You may only do this to one person at a time."
	set category = "Abilities"
	if(!ishuman(src))
		return //If you're not a human you don't have permission to do this.

	var/obj/item/weapon/grab/G = src.get_active_hand()
	if(!istype(G))
		to_chat(src, "<span class='warning'>You must be grabbing a creature in your active hand to drain them.</span>")
		return

	var/mob/living/carbon/human/T = G.affecting // I must say, this is a quite ingenious way of doing it. Props to the original coders.
	if(!istype(T) || T.isSynthetic())
		to_chat(src, "<span class='warning'>\The [T] is not able to be drained.</span>")
		return

	if(G.state != GRAB_NECK)
		to_chat(src, "<span class='warning'>You must have a tighter grip to drain this creature.</span>")
		return

	if(absorbing_prey)
		to_chat(src, "<span class='warning'>You are already draining someone!</span>")
		return

	absorbing_prey = 1
	for(var/stage = 1, stage<=100, stage++) //100 stages.
		switch(stage)
			if(1)
				if(T.stat == DEAD)
					to_chat(src, "<span class='warning'>[T] is dead and can not be drained..</span>")
					return
				to_chat(src, "<span class='notice'>You begin to drain [T]...</span>")
				to_chat(T, "<span class='danger'>An odd sensation flows through your body as [src] begins to drain you!</span>")
				nutrition = (nutrition + (T.nutrition*0.05)) //Drain a small bit at first. 5% of the prey's nutrition.
				T.nutrition = T.nutrition*0.95
			if(2)
				to_chat(src, "<span class='notice'>You feel stronger with every passing moment as you drain [T].</span>")
				visible_message("<span class='danger'>[src] seems to be doing something to [T], resulting in [T]'s body looking weaker with every passing moment!</span>")
				to_chat(T, "<span class='danger'>You feel weaker with every passing moment as [src] drains you!</span>")
				nutrition = (nutrition + (T.nutrition*0.1))
				T.nutrition = T.nutrition*0.9
			if(3 to 48) //Should be more than enough to get under 100.
				nutrition = (nutrition + (T.nutrition*0.1)) //Just keep draining them.
				T.nutrition = T.nutrition*0.9
				T.eye_blurry += 5 //Some eye blurry just to signify to the prey that they are still being drained. This'll stack up over time, leave the prey a bit more "weakened" after the deed is done.
				if(T.nutrition < 100)//Did they drop below 100 nutrition? If so, do one last check then jump to stage 50 (Lethal!)
					stage = 49
			if(49)
				if(T.nutrition < 100)//Did they somehow not get drained below 100 nutrition yet? If not, go back to stage 3 and repeat until they get drained.
					stage = 3 //Otherwise, advance to stage 50 (Lethal draining.)
			if(50)
				if(!T.digestable)
					to_chat(src, "<span class='danger'>You feel invigorated as you completely drain [T] and begin to move onto draining them lethally before realizing they are too strong for you to do so!</span>")
					to_chat(T, "<span class='danger'>You feel completely drained as [src] finishes draining you and begins to move onto draining you lethally, but you are too strong for them to do so!</span>")
					nutrition = (nutrition + T.nutrition)
					T.nutrition = 0 //Completely drained of everything.
					var/damage_to_be_applied = T.species.total_health //Get their max health.
					T.apply_damage(damage_to_be_applied, HALLOSS) //Knock em out.
					absorbing_prey = 0 //Clean this up before we return
					return
				to_chat(src, "<span class='notice'>You begin to drain [T] completely...</span>")
				to_chat(T, "<span class='danger'>An odd sensation flows through your body as you as [src] begins to drain you to dangerous levels!</span>")
			if(51 to 98)
				if(T.stat == DEAD)
					T.apply_damage(500, OXY) //Bit of fluff.
					absorbing_prey = 0
					to_chat(src, "<span class='notice'>You have completely drained [T], killing them.</span>")
					to_chat(T, "<span class='danger'size='5'>You feel... So... Weak...</span>")
					T.attack_log += text("\[[time_stamp()]\] <font color='red'>Was drained by [key_name(src)]</font>")
					src.attack_log += text("\[[time_stamp()]\] <font color='orange'> Drained [key_name(T)]</font>")
					msg_admin_attack("[key_name(T)] was completely drained of all nutrition by [key_name(src)]")
					return
				if(drain_finalized == 1 || T.getBrainLoss() < 55) //Let's not kill them with this unless the drain is finalized. This will still stack up to 55, since 60 is lethal.
					T.adjustBrainLoss(5) //Will kill them after a short bit!
				T.eye_blurry += 20 //A lot of eye blurry just to signify to the prey that they are still being drained. This'll stack up over time, leave the prey a bit more "weakened" after the deed is done. More than non-lethal due to their lifeforce being sucked out
				nutrition = (nutrition + 25) //Assuming brain damage kills at 60, this gives 300 nutrition.
			if(99)
				if(drain_finalized != 1)
					stage = 51
			if(100) //They shouldn't  survive long enough to get here, but just in case.
				T.apply_damage(500, OXY) //Kill them.
				absorbing_prey = 0
				to_chat(src, "<span class='notice'>You have completely drained [T], killing them in the process.</span>")
				to_chat(T, "<span class='danger'><font size='7'>You... Feel... So... Weak...</font></span>")
				visible_message("<span class='danger'>[src] seems to finish whatever they were doing to [T].</span>")
				T.attack_log += text("\[[time_stamp()]\] <font color='red'>Was drained by [key_name(src)]</font>")
				src.attack_log += text("\[[time_stamp()]\] <font color='orange'> Drained [key_name(T)]</font>")
				msg_admin_attack("[key_name(T)] was completely drained of all nutrition by [key_name(src)]")
				return

		if(!do_mob(src, T, 50) || G.state != GRAB_NECK) //One drain tick every 5 seconds.
			to_chat(src, "<span class='warning'>Your draining of [T] has been interrupted!</span>")
			absorbing_prey = 0
			return

/mob/living/carbon/human/proc/slime_feed()
	set name = "Feed prey with self"
	set desc = "Slowly feed prey with your body, draining you in the process. You may only do this to one person at a time."
	set category = "Abilities"
	if(!ishuman(src))
		return //If you're not a human you don't have permission to do this.
	var/mob/living/carbon/human/C = src
	var/obj/item/weapon/grab/G = src.get_active_hand()
	if(!istype(G))
		to_chat(C, "<span class='warning'>You must be grabbing a creature in your active hand to feed them.</span>")
		return

	var/mob/living/carbon/human/T = G.affecting // I must say, this is a quite ingenious way of doing it. Props to the original coders.
	if(!istype(T) || T.isSynthetic())
		to_chat(src, "<span class='warning'>\The [T] is not able to be fed.</span>")
		return

	if(!G.state) //This should never occur. But alright
		return

	if(C.absorbing_prey)
		to_chat(C, "<span class='warning'>You are already feeding someone!</span>")
		return

	C.absorbing_prey = 1
	for(var/stage = 1, stage<=100, stage++) //100 stages.
		switch(stage)
			if(1)
				to_chat(C, "<span class='notice'>You begin to feed [T]...</span>")
				to_chat(T, "<span class='notice'>An odd sensation flows through your body as [C] begins to feed you!</span>")
				T.nutrition = (T.nutrition + (C.nutrition*0.05)) //Drain a small bit at first. 5% of the prey's nutrition.
				C.nutrition = C.nutrition*0.95
			if(2)
				to_chat(C, "<span class='notice'>You feel weaker with every passing moment of feeding [T].</span>")
				src.visible_message("<span class='notice'>[C] seems to be doing something to [T], resulting in [T]'s body looking stronger with every passing moment!</span>")
				to_chat(T, "<span class='notice'>You feel stronger with every passing moment as [C] feeds you!</span>")
				T.nutrition = (T.nutrition + (C.nutrition*0.1))
				C.nutrition = C.nutrition*0.90
			if(3 to 99)
				T.nutrition = (T.nutrition + (C.nutrition*0.1)) //Just keep draining them.
				C.nutrition = C.nutrition*0.9
				T.eye_blurry += 1 //Eating a slime's body is odd and will make your vision a bit blurry!
				if(C.nutrition < 100 && stage < 99 && C.drain_finalized == 1)//Did they drop below 100 nutrition? If so, immediately jump to stage 99 so it can advance to 100.
					stage = 99
				if(C.drain_finalized != 1 && stage == 99) //Are they not finalizing and the stage hit 100? If so, go back to stage 3 until they finalize it.
					stage = 3
			if(100)
				T.nutrition = (T.nutrition + C.nutrition)
				C.nutrition = 0 //Completely drained of everything.
				C.absorbing_prey = 0
				to_chat(C, "<span class='danger'>You have completely fed [T] every part of your body!</span>")
				to_chat(T, "<span class='notice'>You feel quite strong and well fed, as [C] finishes feeding \himself to you!</span>")
				T.attack_log += text("\[[time_stamp()]\] <font color='red'>Was fed via slime feed  by [key_name(C)]</font>")
				C.attack_log += text("\[[time_stamp()]\] <font color='orange'> Fed via slime feed [key_name(T)]</font>")
				msg_admin_attack("[key_name(C)] fed [key_name(T)] via slime feed, resulting in them being eaten!")
				C.feed_grabbed_to_self_falling_nom(T,C) //Reused this proc instead of making a new one to cut down on code usage.
				return

		if(!do_mob(src, T, 50) || !G.state) //One drain tick every 5 seconds.
			to_chat(src, "<span class='warning'>Your feeding of [T] has been interrupted!</span>")
			C.absorbing_prey = 0
			return




/mob/living/carbon/human/proc/succubus_drain_finalize()
	set name = "Drain/Feed Finalization"
	set desc = "Toggle to allow for draining to be prolonged. Turn this on to make it so prey will be knocked out/die while being drained, or you will feed yourself to the prey's selected stomach if you're feeding them. Can be toggled at any time."
	set category = "Abilities"

	var/mob/living/carbon/human/C = src
	C.drain_finalized = !C.drain_finalized
	to_chat(C, "<span class='notice'>You will [C.drain_finalized?"now":"not"] finalize draining/feeding.</span>")

/mob/living/carbon/human/proc/shred_limb() //If you're looking at this, nothing but pain and suffering lies below.
	set name = "Damage/Remove Prey's Organ"
	set desc = "Severely damages prey's organ. If the limb is already severely damaged, it will be torn off."
	set category = "Abilities"
	if(!ishuman(src))
		return //If you're not a human you don't have permission to do this.

	if(last_special > world.time)
		return

	if(stat || paralysis || stunned || weakened || lying || restrained() || buckled)
		to_chat(src, "You cannot severely damage anything in your current state!")
		return

	var/mob/living/carbon/human/C = src
	var/obj/item/weapon/grab/G = src.get_active_hand()
	if(!istype(G))
		to_chat(C, "<span class='warning'>We must be grabbing a creature in our active hand to severely damage them.</span>")
		return

	var/mob/living/carbon/human/T = G.affecting
	if(!istype(T)) //Are they a mob?
		to_chat(C, "<span class='warning'>\The [T] is not able to be severely damaged!</span>")
		return

	if(G.state != GRAB_NECK)
		to_chat(C, "<span class='warning'>You must have a tighter grip to severely damage this creature.</span>")
		return

	if(!T || !C || C.stat)
		return

	if(!Adjacent(T))
		return

	var/list/choices2 = list()
	for(var/obj/item/organ/O in T.organs) //External organs
		choices2 += O

	var/obj/item/organ/external/D = input(C,"What do you wish to severely damage?") as null|anything in choices2 //D for destroy.
	if(D.vital)
		if(alert("Are you sure you wish to severely damage their [D]? It most likely will kill the prey...",,"Yes", "No") != "Yes")
			return //If they reconsider, don't continue.

	var/list/choices3 = list()
	for(var/obj/item/organ/internal/I in D.internal_organs) //Look for the internal organ in the organ being shreded.
		choices3 += I

	var/obj/item/organ/internal/P = input(C,"Do you wish to severely damage an internal organ, as well? If not, click 'cancel'") as null|anything in choices3

	var/eat_limb = input(C,"Do you wish to swallow the organ if you tear if out? If so, select which stomach.") as null|anything in C.vore_organs  //EXTREMELY EFFICIENT

	if(last_special > world.time)
		return

	if(stat || paralysis || stunned || weakened || lying || restrained() || buckled)
		to_chat(C, "You cannot shred in your current state.")
		return

	last_special = world.time + 100 //10 seconds.
	C.visible_message("<font color='red'><b>[C] appears to be preparing to do something to [T]!</b></font>") //Let everyone know that bad times are head

	if(do_after(C, 100, T)) //Ten seconds. You have to be in a neckgrab for this, so you're already in a bad position.
		if(!Adjacent(T)) return
		if(P && P.damage >= 25) //Internal organ and it's been severely damage
			T.apply_damage(15, BRUTE, D) //Damage the external organ they're going through.
			P.removed()
			P.forceMove(T.loc) //Move to where prey is.
			log_and_message_admins("tore out [P] of [T].", C)
			if(eat_limb)
				var/datum/belly/S = C.vore_organs[eat_limb]
				P.forceMove(C) //Move to pred's gut
				S.internal_contents |= P //Add to pred's gut.
				C.visible_message("<font color='red'><b>[C] severely damages [D] of [T]!</b></font>") // Same as below, but (pred) damages the (right hand) of (person)
				to_chat(C, "[P] of [T] moves into your [S]!") //Quietly eat their internal organ! Comes out "The (right hand) of (person) moves into your (stomach)
				playsound(C, S.vore_sound, 70, 1)
				log_and_message_admins("tore out and ate [P] of [T].", C)
			else
				log_and_message_admins("tore out [P] of [T].", C)
				C.visible_message("<font color='red'><b>[C] severely damages [D] of [T], resulting in their [P] coming out!</b></font>")
		else if(!P && (D.damage >= 25 || D.brute_dam >= 25)) //Not targeting an internal organ & external organ has been severely damaged already.
			D.droplimb(1,DROPLIMB_EDGE) //Clean cut so it doesn't kill the prey completely.
			if(D.cannot_amputate) //Is it groin/chest? You can't remove those.
				T.apply_damage(25, BRUTE, D)
				C.visible_message("<font color='red'><b>[C] severely damage [T]'s [D]!</b></font>") //Keep it vague. Let the /me's do the talking.
				log_and_message_admins("shreded [T]'s [D].", C)
				return
			if(eat_limb)
				var/datum/belly/S = C.vore_organs[eat_limb]
				D.forceMove(C) //Move to pred's gut
				S.internal_contents |= D //Add to pred's gut.
				C.visible_message("<span class='warning'>[C] swallows [D] of [T] into their [S]!</span>","You swallow [D] of [T]!")
				playsound(C, S.vore_sound, 70, 1)
				to_chat(C, "Their [D] moves into your [S]!")
				log_and_message_admins("tore off and ate [D] of [T].", C)
			else
				C.visible_message("<span class='warning'>[C] tears off [D] of [T]!</span>","You tear out [D] of [T]!") //Will come out "You tear out (the right foot) of (person)
				log_and_message_admins("tore off [T]'s [D].", C)
		else //Not targeting an internal organ w/ > 25 damage , and the limb doesn't have < 25 damage.
			if(P)
				P.damage = 25 //Internal organs can only take damage, not brute damage.
			T.apply_damage(25, BRUTE, D)
			C.visible_message("<font color='red'><b>[C] severely damages [D] of [T]!</b></font>") //Keep it vague. Let the /me's do the talking.
			log_and_message_admins("shreded [D] of [T].", C)

/mob/living/proc/flying_toggle()
	set name = "Toggle Flight"
	set desc = "While flying over open spaces, you will use up some nutrition. If you run out nutrition, you will fall. Additionally, you can't fly if you are too heavy."
	set category = "Abilities"

	var/mob/living/carbon/human/C = src
	if(!C.wing_style) //The species var isn't taken into account here, as it's only purpose is to give this proc to a person.
		to_chat(src, "You cannot fly without wings!!")
		return
	if(C.incapacitated(INCAPACITATION_ALL))
		to_chat(src, "You cannot fly in this state!")
		return
	if(C.nutrition < 25 && !C.flying) //Don't have any food in you?" You can't fly.
		to_chat(C, "<span class='notice'>You lack the nutrition to fly.</span>")
		return
	if(C.nutrition > 1000 && !C.flying)
		to_chat(C, "<span class='notice'>You have eaten too much to fly! You need to lose some nutrition.</span>")
		return

	C.flying = !C.flying
	update_floating()
	to_chat(C, "<span class='notice'>You have [C.flying?"started":"stopped"] flying.</span>")

//Proc to stop inertial_drift. Exchange nutrition in order to stop gliding around.
/mob/living/proc/start_wings_hovering()
	set name = "Hover"
	set desc = "Allows you to stop gliding and hover. This will take a fair amount of nutrition to perform."
	set category = "Abilities"

	var/mob/living/carbon/human/C = src
	if(!C.wing_style) //The species var isn't taken into account here, as it's only purpose is to give this proc to a person.
		to_chat(src, "You don't have wings!")
		return
	if(!C.flying)
		to_chat(src, "You must be flying to hover!")
		return
	if(C.incapacitated(INCAPACITATION_ALL))
		to_chat(src, "You cannot hover in your current state!")
		return
	if(C.nutrition < 50 && !C.flying) //Don't have any food in you?" You can't hover, since it takes up 25 nutrition. And it's not 25 since we don't want them to immediately fall.
		to_chat(C, "<span class='notice'>You lack the nutrition to fly.</span>")
		return
	if(C.anchored)
		to_chat(C, "<span class='notice'>You are already hovering and/or anchored in place!</span>")
		return

	if(!C.anchored && !C.pulledby) //Not currently anchored, and not pulled by anyone.
		C.anchored = 1 //This is the only way to stop the inertial_drift.
		C.nutrition -= 25
		update_floating()
		to_chat(C, "<span class='notice'>You hover in place.</span>")
		spawn(6) //.6 seconds.
			C.anchored = 0
	else
		return

/mob/living/proc/toggle_pass_table()
	set name = "Toggle Agility" //Dunno a better name for this. You have to be pretty agile to hop over stuff!!!
	set desc = "Allows you to start/stop hopping over things such as hydroponics trays, tables, and railings."
	set category = "IC"
	pass_flags ^= PASSTABLE //I dunno what this fancy ^= is but Aronai gave it to me.
	to_chat(src, "You [pass_flags&PASSTABLE ? "will" : "will NOT"] move over tables/railings/trays!")
