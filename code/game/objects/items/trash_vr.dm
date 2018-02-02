// Custom garbage or whatever

/obj/item/trash/rkibble
	name = "bowl of Borg-O's"
	desc = "Contains every type of scrap material your robot puppy needs to grow big and strong."
	icon = 'icons/mob/dogborg_vr.dmi'
	icon_state = "kibble"

/obj/item/trash/attack(mob/living/M as mob, mob/living/user as mob)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.species.trashcan == 1)
			playsound(H.loc,'sound/items/eatfood.ogg', rand(10,50), 1)
			user.drop_item()
			var/belly = H.vore_selected
			var/datum/belly/selected = H.vore_organs[belly]
			forceMove(H)
			selected.internal_contents |= src
			to_chat(H, "<span class='notice'>You can taste the flavor of garbage. Wait what?</span>")
			return

	if(isrobot(M))
		var/mob/living/silicon/robot/R = M
		if(R.module.type == /obj/item/weapon/robot_module/robot/scrubpup) // You can now feed the trash borg yay.
			playsound(R.loc,'sound/items/eatfood.ogg', rand(10,50), 1)
			user.drop_item()
			var/belly = R.vore_selected
			var/datum/belly/selected = R.vore_organs[belly]
			forceMove(R)
			selected.internal_contents |= src // Too many hoops and obstacles to stick it into the sleeper module.
			R.visible_message("<span class='warning'>[user] feeds [R] with [src]!</span>")
			return
	..()

/obj/item/device/flashlight/flare/attack(mob/living/M as mob, mob/living/user as mob)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.species.trashcan == 1)
			playsound(H.loc,'sound/items/eatfood.ogg', rand(10,50), 1)
			user.drop_item()
			var/belly = H.vore_selected
			var/datum/belly/selected = H.vore_organs[belly]
			forceMove(H)
			selected.internal_contents |= src
			to_chat(H, "<span class='notice'>You can taste the flavor of spicy cardboard. Wait what?</span>")
			return
	..()

/obj/item/device/flashlight/glowstick/attack(mob/living/M as mob, mob/living/user as mob)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.species.trashcan == 1)
			playsound(H.loc,'sound/items/eatfood.ogg', rand(10,50), 1)
			user.drop_item()
			var/belly = H.vore_selected
			var/datum/belly/selected = H.vore_organs[belly]
			forceMove(H)
			selected.internal_contents |= src
			to_chat(H, "<span class='notice'>You found out the glowy juice only tastes like regret. Wait what?</span>")
			return
	..()

/obj/item/toy/figure/attack(mob/living/M as mob, mob/living/user as mob)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.species.trashcan == 1)
			playsound(H.loc,'sound/vore/gulp.ogg', rand(10,50), 1)
			user.drop_item()
			var/belly = H.vore_selected
			var/datum/belly/selected = H.vore_organs[belly]
			forceMove(H)
			selected.internal_contents |= src
			visible_message("<span class='warning'>[M] demonstrates their voracious capabilities by swallowing [src] whole!</span>")
			return
	..()

/obj/item/weapon/cigbutt/attack(mob/living/M as mob, mob/living/user as mob)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.species.trashcan == 1)
			playsound(H.loc,'sound/items/eatfood.ogg', rand(10,50), 1)
			user.drop_item()
			var/belly = H.vore_selected
			var/datum/belly/selected = H.vore_organs[belly]
			forceMove(H)
			selected.internal_contents |= src
			to_chat(H, "<span class='notice'>You can taste the flavor of bitter ash. Classy.</span>")
			return
	..()

/obj/item/weapon/bananapeel/attack(mob/living/M as mob, mob/living/user as mob)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.species.trashcan == 1)
			playsound(H.loc,'sound/items/eatfood.ogg', rand(10,50), 1)
			user.drop_item()
			var/belly = H.vore_selected
			var/datum/belly/selected = H.vore_organs[belly]
			forceMove(H)
			selected.internal_contents |= src
			to_chat(H, "<span class='notice'>You can taste the flavor of bitter banana.</span>")
			return
	..()

/obj/item/stack/material/cardboard/attack(mob/living/M as mob, mob/living/user as mob)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.species.trashcan == 1)
			playsound(H.loc,'sound/items/eatfood.ogg', rand(10,50), 1)
			user.drop_item()
			var/belly = H.vore_selected
			var/datum/belly/selected = H.vore_organs[belly]
			forceMove(H)
			selected.internal_contents |= src
			to_chat(H, "<span class='notice'>You can taste the flavor of cardboard. Delicious.</span>")
			return
	..()

/obj/item/weapon/paper/attack(mob/living/carbon/M as mob, mob/living/user as mob)
	if(icon_state == "scrap")
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(H.species.trashcan == 1)
				playsound(H.loc,'sound/items/eatfood.ogg', rand(10,50), 1)
				user.drop_item()
				var/belly = H.vore_selected
				var/datum/belly/selected = H.vore_organs[belly]
				forceMove(H)
				selected.internal_contents |= src
				to_chat(H, "<span class='notice'>You can taste the dry flavor of bureaucracy.</span>")
				return
	..()

/obj/item/weapon/light/attack(mob/living/M as mob, mob/living/user as mob)
	var/obj/item/weapon/light/L = src
	if(ishuman(M) && L.status > 1)
		var/mob/living/carbon/human/H = M
		if(H.species.trashcan == 1)
			playsound(H.loc,'sound/items/eatfood.ogg', rand(10,50), 1)
			user.drop_item()
			var/belly = H.vore_selected
			var/datum/belly/selected = H.vore_organs[belly]
			forceMove(H)
			selected.internal_contents |= src
			to_chat(H, "<span class='notice'>You can taste the flavor of pain. This can't possibly be healthy for your guts.</span>")
			return
	..()

/obj/item/weapon/broken_bottle/attack(mob/living/M as mob, mob/living/user as mob)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.species.trashcan == 1)
			playsound(H.loc,'sound/items/eatfood.ogg', rand(10,50), 1)
			user.drop_item()
			var/belly = H.vore_selected
			var/datum/belly/selected = H.vore_organs[belly]
			forceMove(H)
			selected.internal_contents |= src
			to_chat(H, "<span class='notice'>You can taste the flavor of pain. This can't possibly be healthy for your guts.</span>")
			return
	..()

/obj/item/weapon/reagent_containers/food/drinks/cans/attack(mob/living/M as mob, mob/living/user as mob)
	if(ishuman(M) && !reagents.total_volume)
		var/mob/living/carbon/human/H = M
		if(H.species.trashcan == 1)
			playsound(H.loc,'sound/items/eatfood.ogg', rand(10,50), 1)
			user.drop_item()
			var/belly = H.vore_selected
			var/datum/belly/selected = H.vore_organs[belly]
			forceMove(H)
			selected.internal_contents |= src
			to_chat(H, "<span class='notice'>You can taste the flavor of garbage. Wait what?</span>")
			return
	..()

/obj/item/weapon/reagent_containers/food/drinks/smallmilk/attack(mob/living/M as mob, mob/living/user as mob)
	if(ishuman(M) && !reagents.total_volume)
		var/mob/living/carbon/human/H = M
		if(H.species.trashcan == 1)
			playsound(H.loc,'sound/items/eatfood.ogg', rand(10,50), 1)
			user.drop_item()
			var/belly = H.vore_selected
			var/datum/belly/selected = H.vore_organs[belly]
			forceMove(H)
			selected.internal_contents |= src
			to_chat(H, "<span class='notice'>You can taste the flavor of creamy garbage. Wait what?</span>")
			return
	..()

/obj/item/weapon/reagent_containers/food/drinks/smallchocmilk/attack(mob/living/M as mob, mob/living/user as mob)
	if(ishuman(M) && !reagents.total_volume)
		var/mob/living/carbon/human/H = M
		if(H.species.trashcan == 1)
			playsound(H.loc,'sound/items/eatfood.ogg', rand(10,50), 1)
			user.drop_item()
			var/belly = H.vore_selected
			var/datum/belly/selected = H.vore_organs[belly]
			forceMove(H)
			selected.internal_contents |= src
			to_chat(H, "<span class='notice'>You can taste the flavor of chocolate and garbage. Wait what?</span>")
			return
	..()

/obj/item/weapon/reagent_containers/food/drinks/coffee/attack(mob/living/M as mob, mob/living/user as mob)
	if(ishuman(M) && !reagents.total_volume)
		var/mob/living/carbon/human/H = M
		if(H.species.trashcan == 1)
			playsound(H.loc,'sound/items/eatfood.ogg', rand(10,50), 1)
			user.drop_item()
			var/belly = H.vore_selected
			var/datum/belly/selected = H.vore_organs[belly]
			forceMove(H)
			selected.internal_contents |= src
			to_chat(H, "<span class='notice'>You can taste the flavor of caffeinated garbage. Wait what?</span>")
			return
	..()

/obj/item/weapon/reagent_containers/food/drinks/tea/attack(mob/living/M as mob, mob/living/user as mob)
	if(ishuman(M) && !reagents.total_volume)
		var/mob/living/carbon/human/H = M
		if(H.species.trashcan == 1)
			playsound(H.loc,'sound/items/eatfood.ogg', rand(10,50), 1)
			user.drop_item()
			var/belly = H.vore_selected
			var/datum/belly/selected = H.vore_organs[belly]
			forceMove(H)
			selected.internal_contents |= src
			to_chat(H, "<span class='notice'>You can taste the flavor of garbage. Wait what?</span>")
			return
	..()

/obj/item/weapon/reagent_containers/food/drinks/h_chocolate/attack(mob/living/M as mob, mob/living/user as mob)
	if(ishuman(M) && !reagents.total_volume)
		var/mob/living/carbon/human/H = M
		if(H.species.trashcan == 1)
			playsound(H.loc,'sound/items/eatfood.ogg', rand(10,50), 1)
			user.drop_item()
			var/belly = H.vore_selected
			var/datum/belly/selected = H.vore_organs[belly]
			forceMove(H)
			selected.internal_contents |= src
			to_chat(H, "<span class='notice'>You can taste the flavor of chocolate and garbage. Wait what?</span>")
			return
	..()

/obj/item/weapon/reagent_containers/food/drinks/ice/attack(mob/living/M as mob, mob/living/user as mob)
	if(ishuman(M) && !reagents.total_volume)
		var/mob/living/carbon/human/H = M
		if(H.species.trashcan == 1)
			playsound(H.loc,'sound/items/eatfood.ogg', rand(10,50), 1)
			user.drop_item()
			var/belly = H.vore_selected
			var/datum/belly/selected = H.vore_organs[belly]
			forceMove(H)
			selected.internal_contents |= src
			to_chat(H, "<span class='notice'>You can taste the flavor of cold wet garbage. Wait what?</span>")
			return
	..()

/obj/item/weapon/reagent_containers/food/drinks/dry_ramen/attack(mob/living/M as mob, mob/living/user as mob)
	if(ishuman(M) && !reagents.total_volume)
		var/mob/living/carbon/human/H = M
		if(H.species.trashcan == 1)
			playsound(H.loc,'sound/items/eatfood.ogg', rand(10,50), 1)
			user.drop_item()
			var/belly = H.vore_selected
			var/datum/belly/selected = H.vore_organs[belly]
			forceMove(H)
			selected.internal_contents |= src
			to_chat(H, "<span class='notice'>You can taste the flavor of garbage. Wait what?</span>")
			return
	..()

/obj/item/weapon/reagent_containers/food/drinks/sillycup/attack(mob/living/M as mob, mob/living/user as mob)
	if(ishuman(M) && !reagents.total_volume)
		var/mob/living/carbon/human/H = M
		if(H.species.trashcan == 1)
			playsound(H.loc,'sound/items/eatfood.ogg', rand(10,50), 1)
			user.drop_item()
			var/belly = H.vore_selected
			var/datum/belly/selected = H.vore_organs[belly]
			forceMove(H)
			selected.internal_contents |= src
			to_chat(H, "<span class='notice'>You can taste the flavor of garbage. Wait what?</span>")
			return
	..()

/obj/item/inflatable/torn/attack(mob/living/M as mob, mob/living/user as mob)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.species.trashcan == 1)
			playsound(H.loc,'sound/items/eatfood.ogg', rand(10,50), 1)
			user.drop_item()
			var/belly = H.vore_selected
			var/datum/belly/selected = H.vore_organs[belly]
			forceMove(H)
			selected.internal_contents |= src
			to_chat(H, "<span class='notice'>You can taste the flavor of garbage. Wait what?</span>")
			return
	..()

/obj/item/weapon/reagent_containers/food/snacks/badrecipe/attack(mob/living/M as mob, mob/living/user as mob)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.species.trashcan == 1)
			playsound(H.loc,'sound/items/eatfood.ogg', rand(10,50), 1)
			user.drop_item()
			var/belly = H.vore_selected
			var/datum/belly/selected = H.vore_organs[belly]
			forceMove(H)
			selected.internal_contents |= src
			to_chat(H, "<span class='notice'>You can taste the flavor of someone's horrible cooking skills.</span>")
			return
	..()