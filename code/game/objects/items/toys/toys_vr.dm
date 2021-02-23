/obj/item/toy/mistletoe
	name = "mistletoe"
	desc = "You are supposed to kiss someone under these"
	icon = 'icons/obj/toy_vr.dmi'
	icon_state = "mistletoe"

/obj/item/toy/plushie/lizardplushie
	name = "lizard plushie"
	desc = "An adorable stuffed toy that resembles a lizardperson."
	icon = 'icons/obj/toy_vr.dmi'
	icon_state = "plushie_lizard"
	attack_verb = list("clawed", "hissed", "tail slapped")

/obj/item/toy/plushie/lizardplushie/kobold
	name = "kobold plushie"
	desc = "An adorable stuffed toy that resembles a kobold."
	icon = 'icons/obj/toy_vr.dmi'
	icon_state = "kobold"
	pokephrase = "Wehhh!"
	drop_sound = 'sound/voice/weh.ogg'
	attack_verb = list("raided", "kobolded", "weh'd")

/obj/item/toy/plushie/lizardplushie/resh
	name = "security unathi plushie"
	desc = "An adorable stuffed toy that resembles an unathi wearing a head of security uniform. Perfect example of a monitor lizard."
	icon = 'icons/obj/toy_vr.dmi'
	icon_state = "marketable_resh"
	pokephrase = "Halt! Sssecurity!"		//"Butts!" would be too obvious
	attack_verb = list("valided", "justiced", "batoned")

/obj/item/toy/plushie/slimeplushie
	name = "slime plushie"
	desc = "An adorable stuffed toy that resembles a slime. It is practically just a hacky sack."
	icon = 'icons/obj/toy_vr.dmi'
	icon_state = "plushie_slime"
	attack_verb = list("blorbled", "slimed", "absorbed", "glomped")
	gender = FEMALE	//given all the jokes and drawings, I'm not sure the xenobiologists would make a slimeboy

/obj/item/toy/plushie/box
	name = "cardboard plushie"
	desc = "A toy box plushie, it holds cotten. Only a baddie would place a bomb through the postal system..."
	icon = 'icons/obj/toy_vr.dmi'
	icon_state = "box"
	attack_verb = list("open", "closed", "packed", "hidden", "rigged", "bombed", "sent", "gave")

/obj/item/toy/plushie/borgplushie
	name = "robot plushie"
	desc = "An adorable stuffed toy of a robot."
	icon = 'icons/obj/toy_vr.dmi'
	icon_state = "securityk9"
	attack_verb = list("beeped", "booped", "pinged")

/obj/item/toy/plushie/borgplushie/medihound
	icon_state = "medihound"

/obj/item/toy/plushie/borgplushie/scrubpuppy
	icon_state = "scrubpuppy"

/obj/item/toy/plushie/borgplushie/drakiesec
	icon = 'icons/obj/drakietoy_vr.dmi'
	icon_state = "secdrake"

/obj/item/toy/plushie/borgplushie/drakiemed
	icon = 'icons/obj/drakietoy_vr.dmi'
	icon_state = "meddrake"

/obj/item/toy/plushie/foxbear
	name = "toy fox"
	desc = "Issa fox!"
	icon = 'icons/obj/toy_vr.dmi'
	icon_state = "fox"

/obj/item/toy/plushie/nukeplushie
	name = "operative plushie"
	desc = "A stuffed toy that resembles a syndicate nuclear operative. The tag claims operatives to be purely fictitious."
	icon = 'icons/obj/toy_vr.dmi'
	icon_state = "plushie_nuke"
	attack_verb = list("shot", "nuked", "detonated")

/obj/item/toy/plushie/otter
	name = "otter plush"
	desc = "A perfectly sized snuggable river weasel! Keep away from Clams."
	icon = 'icons/obj/toy_vr.dmi'
	icon_state = "plushie_otter"

/obj/item/toy/plushie/vox
	name = "vox plushie"
	desc = "A stitched-together vox, fresh from the skipjack. Press its belly to hear it skree!"
	icon = 'icons/obj/toy_vr.dmi'
	icon_state = "plushie_vox"
	var/cooldown = 0

/obj/item/toy/plushie/vox/attack_self(mob/user as mob)
	if(!cooldown)
		playsound(user, 'sound/voice/shriek1.ogg', 10, 0)
		src.visible_message("<span class='danger'>Skreee!</span>")
		cooldown = 1
		addtimer(CALLBACK(src, .proc/cooldownreset), 50)
	return ..()

//Below are additions made on 02/22/2021

/*
 * Sus Co. Plushies
 */

/obj/item/toy/plushie/det_blu_plush
	name = "Blue Crewmate Plushie"
	desc = "A special edition Sus Co. Crewmate plushie! This one is Detective Blue!"
	icon = 'icons/obj/toy_vr.dmi'
	icon_state = "det_blu_plush"

/obj/item/toy/plushie/whn_whi_plush
	name = "White Crewmate Plushie"
	desc = "A special edition Sus Co. Crewmate plushie! This one is Whiny White!"
	icon = 'icons/obj/toy_vr.dmi'
	icon_state = "whn_whi_plush"

/obj/item/toy/plushie/sus_red_plush
	name = "Red Crewmate Plushie"
	desc = "A special edition Sus Co. Crewmate plushie! This one is Supicious Red!"
	icon = 'icons/obj/toy_vr.dmi'
	icon_state = "sus_red_plush"
	var/cooldown = 0

/obj/item/toy/plushie/sus_red_plush/attack_self(mob/user as mob)
	if(!cooldown)
		playsound(user, 'sound/weapons/bladeslice.ogg', 10, 0)
		src.visible_message("<span class='danger'>Stab.</span>")
		cooldown = 1
		addtimer(CALLBACK(src, .proc/cooldownreset), 50)
	return ..()

/obj/item/toy/plushie/sus_red_plush/proc/cooldownreset()
	cooldown = 0

/*
 * Toy Big Iron
 */

/obj/item/toy/big_iron_toy
	name = "Toy Big Iron"
	desc = "The weapon favored by the ranger and his hip. Ages 8 and up."
	icon = 'icons/obj/toy_vr.dmi'
	icon_state = "big_iron_toy"
	item_icons = list(
		icon_l_hand = 'icons/mob/items/lefthand_guns.dmi',
		icon_r_hand = 'icons/mob/items/righthand_guns.dmi',
		)
	slot_flags = SLOT_HOLSTER
	w_class = ITEMSIZE_SMALL
	attack_verb = list("attacked", "struck", "hit")
	var/bullets = 6
	drop_sound = 'sound/items/drop/gun.ogg'

	examine(mob/user)
		. = ..()
		if(bullets && get_dist(user, src) <= 2)
			. += "<span class='notice'>It is loaded with [bullets] foam darts!</span>"

	attackby(obj/item/I as obj, mob/user as mob)
		if(istype(I, /obj/item/toy/ammo/big_iron_toy))
			if(bullets <= 6)
				user.drop_item()
				qdel(I)
				bullets++
				to_chat(user, "<span class='notice'>You load the foam dart into the crossbow.</span>")
			else
				to_chat(usr, "<span class='warning'>It's already fully loaded.</span>")


	afterattack(atom/target as mob|obj|turf|area, mob/user as mob, flag)
		if(!isturf(target.loc) || target == user) return
		if(flag) return

		if (locate (/obj/structure/table, src.loc))
			return
		else if (bullets)
			var/turf/trg = get_turf(target)
			var/obj/effect/foam_dart_dummy/D = new/obj/effect/foam_dart_dummy(get_turf(src))
			bullets--
			D.icon_state = "foamdart"
			D.name = "foam dart"
			playsound(src, 'sound/items/syringeproj.ogg', 50, 1)

			for(var/i=0, i<6, i++)
				if (D)
					if(D.loc == trg) break
					step_towards(D,trg)

					for(var/mob/living/M in D.loc)
						if(!istype(M,/mob/living)) continue
						if(M == user) continue
						for(var/mob/O in viewers(world.view, D))
							O.show_message(text("<span class='warning'>\The [] was hit by the foam dart!</span>", M), 1)
						new /obj/item/toy/ammo/big_iron_toy(M.loc)
						qdel(D)
						return

					for(var/atom/A in D.loc)
						if(A == user) continue
						if(A.density)
							new /obj/item/toy/ammo/big_iron_toy(A.loc)
							qdel(D)

				sleep(1)

			spawn(10)
				if(D)
					new /obj/item/toy/ammo/big_iron_toy(D.loc)
					qdel(D)

			return
		else if (bullets == 0)
			user.Weaken(2)
			for(var/mob/O in viewers(world.view, user))
				O.show_message(text("<span class='warning'>\The [] realized they were out of ammo and starting scrounging for some!</span>", user), 1)


	attack(mob/M as mob, mob/user as mob)
		src.add_fingerprint(user)

// ******* Check

		if (src.bullets > 0 && M.lying)

			for(var/mob/O in viewers(M, null))
				if(O.client)
					O.show_message(text("<span class='danger'>\The [] casually lines up a shot with []'s head and pulls the trigger!</span>", user, M), 1, "<span class='warning'>You hear the sound of foam against skull</span>", 2)
					O.show_message(text("<span class='warning'>\The [] was hit in the head by the foam dart!</span>", M), 1)

			playsound(src, 'sound/items/syringeproj.ogg', 50, 1)
			new /obj/item/toy/ammo/crossbow(M.loc)
			src.bullets--
		else if (M.lying && src.bullets == 0)
			for(var/mob/O in viewers(M, null))
				if (O.client)	O.show_message(text("<span class='danger'>\The [] casually lines up a shot with []'s head, pulls the trigger, then realizes they are out of ammo and drops to the floor in search of some!</span>", user, M), 1, "<span class='warning'>You hear someone fall</span>", 2)
			user.Weaken(2)
		return

/obj/item/toy/ammo/big_iron_toy
	name = "foam dart"
	desc = "It's nerf or nothing! Ages 8 and up."
	icon = 'icons/obj/toy.dmi'
	icon_state = "foamdart"
	w_class = ITEMSIZE_TINY
	slot_flags = SLOT_EARS
	drop_sound = 'sound/items/drop/food.ogg'

/obj/effect/foam_dart_dummy
	name = ""
	desc = ""
	icon = 'icons/obj/toy.dmi'
	icon_state = "null"
	anchored = 1
	density = 0
