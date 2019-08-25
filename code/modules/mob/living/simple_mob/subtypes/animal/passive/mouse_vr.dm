/mob/living/simple_mob/animal/passive/mouse
	no_vore = 1 //Mice can't eat others due to the amount of bugs caused by it.
	vore_taste = "cheese"

/mob/living/simple_mob/animal/passive/mouse/attack_hand(mob/living/hander)
	if(hander.a_intent == I_HELP) //if lime intent
		get_scooped(hander) //get scooped

/obj/item/weapon/holder/mouse/attack_self(var/mob/U)
	for(var/mob/living/simple_mob/M in src.contents)
		if((I_HELP) && U.canClick()) //a little snowflakey, but makes it use the same cooldown as interacting with non-inventory objects
			U.setClickCooldown(U.get_attack_speed()) //if there's a cleaner way in baycode, I'll change this
			U.visible_message("<span class='notice'>[U] [M.response_help] \the [M].</span>")