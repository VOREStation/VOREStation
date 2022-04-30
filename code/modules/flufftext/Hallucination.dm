/*
Hallucinations should not be oOoOoOo whacky, that's dumb.
Room for expanding on, but let's not imagine the crew wailing on you for taking some drugs.
*/

<<<<<<< HEAD
/mob/living/carbon/var
	image/halimage
	image/halbody
	obj/halitem
	hal_screwyhud = 0 //1 - critical, 2 - dead, 3 - oxygen indicator, 4 - toxin indicator
	handling_hal = 0
	hal_crit = 0
=======
/mob/living/carbon
	var/image/halimage
	var/halmob_action
>>>>>>> 661b83e61d4... Drug Expansion (#8575)

/mob/living/carbon/proc/handle_hallucinations()
	if(client && hallucination > 20)
		var/list/halpick = list()
		halpick |= list("messages", "sounds")
		if(hallucination > 40)
			halpick |= list("goodvoice", "badvoice")
		if(hallucination > 65)
			halpick |= list("ignoring", "badsounds")
		if(hallucination > 80)
			halpick |= list("dangerimage")
		var/chosenhal = pick(halpick)
		if(prob(25))
			switch(chosenhal)
				if("messages")
					var/list/msg_list = list("Everything around you feels like it's breathing...",
					"There are such strange patterns everywhere... you can't take your eyes off them.",
					"You feel in tune with your surroundings. You're part of them...",
					"What was that noise?",
					"You feel like something is crawling on you...!")
					to_chat(src, "<span class='warning'>[pick(msg_list)]</span>")
				if("sounds") /// Relatively harmless sounds to hear. 
					var/list/soundlist = list('sound/items/bikehorn.ogg', 'sound/items/drink.ogg', 'sound/items/polaroid1.ogg', 'sound/items/lighter_on.ogg',
					'sound/machines/vending/vending_cans.ogg', 'sound/weapons/flash.ogg')
					src << pick(soundlist)
				if("goodvoice")
					if(prob(10))
						halmob_action = "goodvoice"
						mob_hallucinate(src)
				if("badvoice")
					if(prob(10))
						halmob_action = "badvoice"
						mob_hallucinate(src)
				if("ignoring") /// Paranoid isolation
					if(prob(10))
						halmob_action = "ignoring"
						mob_hallucinate(src)
				if("badsounds")
					var/list/soundlist = list('sound/hallucinations/serithi/creepy1.ogg', 'sound/hallucinations/serithi/creepy2.ogg','sound/hallucinations/serithi/creepy3.ogg')
					src << pick(soundlist)
				if("dangerimage") /// Dangers like fire on random tiles.
					var/list/possible_points = list()
					for(var/turf/simulated/floor/F in range(7, src))
						if(can_see(src, F, 7))
							possible_points += F
					if(possible_points.len)
						var/turf/simulated/floor/target = pick(possible_points)
						switch(rand(1,2))
							if(1)
								halimage = image('icons/effects/fire.dmi',target,"1",TURF_LAYER)
							if(2)
								halimage = image('icons/obj/assemblies.dmi',target,"plastic-explosive2",OBJ_LAYER+0.01)
						if(client)
							client.images += halimage
						spawn(rand(10,50)) //Only seen for a brief moment.
							if(client)
								client.images -= halimage
							halimage = null

/obj/effect/mob_hallucination
	icon = null
	icon_state = null
	name = ""
	desc = ""
	density = FALSE
	anchored = TRUE
	opacity = 0
	var/mob/living/carbon/human/my_target = null
	var/image/stand_icon = null
	var/image/currentimage = null
	var/icon/base = null
	var/s_tone
	var/mob/living/clone = null
	var/image/left
	var/image/right
	var/image/up
	var/image/down
	var/halaction

<<<<<<< HEAD
	var/health = 100

/obj/effect/fake_attacker/attackby(var/obj/item/weapon/P as obj, mob/user as mob)
=======
/obj/effect/mob_hallucination/attackby(var/obj/item/P as obj, mob/user as mob)
>>>>>>> 661b83e61d4... Drug Expansion (#8575)
	step_away(src,my_target,2)
	for(var/mob/M in oviewers(world.view,my_target))
		to_chat(M, "<font color='red'><B>[my_target] flails around wildly.</B></font>")
	my_target.show_message("<font color='red'><B>[src] has been attacked by [my_target] </B></font>", 1)

	return

/obj/effect/mob_hallucination/Crossed(var/mob/M, oldloc)
	if(M == my_target)
		step_away(src,my_target,2)
		if(prob(30))
			for(var/mob/O in oviewers(world.view , my_target))
				to_chat(O, "<font color='red'><B>[my_target] stumbles around.</B></font>")

<<<<<<< HEAD
/obj/effect/fake_attacker/New()
	..()
=======
/obj/effect/mob_hallucination/Initialize()
	. = ..()
>>>>>>> 661b83e61d4... Drug Expansion (#8575)
	QDEL_IN(src, 30 SECONDS)
	START_PROCESSING(SSobj, src)

/obj/effect/mob_hallucination/Destroy()
	if(my_target)
		my_target.hallucinations -= src
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/effect/mob_hallucination/proc/updateimage()
	if(src.dir == NORTH)
		qdel(src.currentimage)
		src.currentimage = new /image(up,src)
	else if(src.dir == SOUTH)
		qdel(src.currentimage)
		src.currentimage = new /image(down,src)
	else if(src.dir == EAST)
		qdel(src.currentimage)
		src.currentimage = new /image(right,src)
	else if(src.dir == WEST)
		qdel(src.currentimage)
		src.currentimage = new /image(left,src)
	my_target << currentimage

<<<<<<< HEAD

/obj/effect/fake_attacker/proc/attack_loop()
	while(1)
		sleep(rand(5,10))
		if(src.health < 0)
			collapse()
			continue
		if(get_dist(src,my_target) > 1)
			src.set_dir(get_dir(src,my_target))
			step_towards(src,my_target)
			updateimage()
		else
			if(prob(15))
				if(weapon_name)
					my_target << sound(pick('sound/weapons/genhit1.ogg', 'sound/weapons/genhit2.ogg', 'sound/weapons/genhit3.ogg'))
					my_target.show_message("<font color='red'><B>[my_target] has been attacked with [weapon_name] by [src.name] </B></font>", 1)
					my_target.halloss += 8
					if(prob(20)) my_target.eye_blurry += 3
					if(prob(33))
						if(!locate(/obj/effect/overlay) in my_target.loc)
							fake_blood(my_target)
				else
					my_target << sound(pick('sound/weapons/punch1.ogg','sound/weapons/punch2.ogg','sound/weapons/punch3.ogg','sound/weapons/punch4.ogg'))
					my_target.show_message("<font color='red'><B>[src.name] has punched [my_target]!</B></font>", 1)
					my_target.halloss += 4
					if(prob(33))
						if(!locate(/obj/effect/overlay) in my_target.loc)
							fake_blood(my_target)

		if(prob(15))
			step_away(src,my_target,2)

/obj/effect/fake_attacker/proc/collapse()
	collapse = 1
	updateimage()

/proc/fake_blood(var/mob/target)
	var/obj/effect/overlay/O = new/obj/effect/overlay(target.loc)
	O.name = "blood"
	var/image/I = image('icons/effects/blood.dmi',O,"floor[rand(1,7)]",O.dir,1)
	target << I
	spawn(300)
		qdel(O)
	return

var/list/non_fakeattack_weapons = list(/obj/item/weapon/gun/projectile, /obj/item/ammo_magazine/s357,\
	/obj/item/weapon/gun/energy/crossbow, /obj/item/weapon/melee/energy/sword,\
	/obj/item/weapon/storage/box/syndicate, /obj/item/weapon/storage/box/emps,\
	/obj/item/weapon/cartridge/syndicate, /obj/item/clothing/under/chameleon,\
	/obj/item/clothing/shoes/syndigaloshes, /obj/item/weapon/card/id/syndicate,\
	/obj/item/clothing/mask/gas/voice, /obj/item/clothing/glasses/thermal,\
	/obj/item/device/chameleon, /obj/item/weapon/card/emag,\
	/obj/item/weapon/storage/toolbox/syndicate, /obj/item/weapon/aiModule,\
	/obj/item/device/radio/headset/syndicate,	/obj/item/weapon/plastique,\
	/obj/item/device/powersink, /obj/item/weapon/storage/box/syndie_kit,\
	/obj/item/toy/syndicateballoon, /obj/item/weapon/gun/energy/captain,\
	/obj/item/weapon/hand_tele, /obj/item/weapon/rcd, /obj/item/weapon/tank/jetpack,\
	/obj/item/clothing/under/rank/captain, /obj/item/device/aicard,\
	/obj/item/clothing/shoes/magboots, /obj/item/blueprints, /obj/item/weapon/disk/nuclear,\
	/obj/item/clothing/suit/space/void, /obj/item/weapon/tank)

/proc/fake_attack(var/mob/living/target)
=======
/obj/effect/mob_hallucination/process()
	var/mob/living/carbon/human/H = my_target
	sleep(rand(5,20))
	if(get_dist(src, H) == 0)
		step_away(src, H, 2)
	if(prob(50) && get_dist(src, H) > 1 && halaction != "ignoring")
		src.set_dir(get_dir(src, H))
		step_towards(src, H)
		updateimage()
	else if(prob(5))
		if(halaction == "goodvoice")
			var/list/msg_list = list("We are all one with the cosmos.", "Wow!", "I'm glad you're here.", "We're safe here.",
			"You look amazing!", "I forgive you.", "Everything is taken care of.", "You don't need to worry.", "Follow your bliss.",
			"It's all going to turn out just fine.", "The universe understands you.", "The future is all assured.", "You are healing.",
			"In a gentle way, you can shake the world...", "Endless opportunities flow from you.", "Keep going!")
			if(name != "")
				to_chat(H, "<span class='notice'>[name] says, \"[pick(msg_list)]\"</span>")
			else
				to_chat(H, "<span class='notice'>A hazy figure says, \"[pick(msg_list)]\"</span>")
		if(halaction == "badvoice")
			var/list/msg_list = list("Your friends are lying.", "You shouldn't have done that.", "Haven't you forgotten something?",
			"Mind your own business.", "They were right, you know.", "You aren't supposed to be here.", "We're watching you.", "Don't look at me.",
			"You should be ashamed of yourself.", "Get out of here!", "You disgust me.", "The world is closing in.", "It's all your fault.",
			"They're coming for you.", "It's only a matter of time.", "You ruined it.", "Nothing you do matters.", "You're wasting their time.",
			"It wasn't an accident.")
			if(name != "")
				to_chat(H, "<span class='warning'>[name] says, \"[pick(msg_list)]\"</span>")
			else
				to_chat(H, "<span class='warning'>A hazy figure says, \"[pick(msg_list)]\"</span>")
		if(halaction == "ignoring")
			step_away(src, H, 3)
			if(prob(5))
				to_chat(H, "<span class='warning'>No one seems to know you're there...</span>")

/proc/mob_hallucinate(var/mob/living/carbon/target)
>>>>>>> 661b83e61d4... Drug Expansion (#8575)
	var/list/possible_clones = new/list()
	var/mob/living/carbon/human/clone = null

	for(var/mob/living/carbon/human/H in living_mob_list)
		if(H.stat || H.lying)
			continue
		possible_clones += H
	if(!possible_clones.len)
		return
	clone = pick(possible_clones)
	if(!clone)
		return

	var/obj/effect/mob_hallucination/MH = new/obj/effect/mob_hallucination(target.loc)

	MH.name = clone.name
	MH.my_target = target
	target.hallucinations += MH
	if(target.halmob_action)
		MH.halaction = target.halmob_action
	MH.left = image(clone,dir = WEST)
	MH.right = image(clone,dir = EAST)
	MH.up = image(clone,dir = NORTH)
	MH.down = image(clone,dir = SOUTH)

	MH.updateimage()