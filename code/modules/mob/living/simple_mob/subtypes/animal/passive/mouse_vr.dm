/mob/living/simple_mob/animal/passive/mouse
	nutrition = 20	//To prevent draining maint mice for infinite food. Low nutrition has no mechanical effect on simplemobs, so wont hurt mice themselves.

	no_vore = 1 //Mice can't eat others due to the amount of bugs caused by it.
	vore_taste = "cheese"

	can_pull_size = ITEMSIZE_TINY // Rykka - Uncommented these. Not sure why they were commented out in the original Polaris files, maybe a mob rework mistake?
	can_pull_mobs = MOB_PULL_NONE // Rykka - Uncommented these. Not sure why they were commented out in the original Polaris files, maybe a mob rework mistake?

	desc = "A small rodent, often seen hiding in maintenance areas and making a nuisance of itself. And stealing cheese, or annoying the chef. SQUEAK! <3"

/mob/living/simple_mob/animal/passive/mouse/attack_hand(mob/living/hander)
	if(hander.a_intent == I_HELP) //if lime intent
		get_scooped(hander) //get scooped
	else
		..()

/obj/item/weapon/holder/mouse/attack_self(var/mob/U)
	for(var/mob/living/simple_mob/M in src.contents)
		if((I_HELP) && U.canClick()) //a little snowflakey, but makes it use the same cooldown as interacting with non-inventory objects
			U.setClickCooldown(U.get_attack_speed()) //if there's a cleaner way in baycode, I'll change this
			U.visible_message("<span class='notice'>[U] [M.response_help] \the [M].</span>")
