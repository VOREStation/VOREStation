/mob/living/simple_mob/animal/passive/mouse
	nutrition = 20	//To prevent draining maint mice for infinite food. Low nutrition has no mechanical effect on simplemobs, so wont hurt mice themselves.

	no_vore = TRUE //Mice can't eat others due to the amount of bugs caused by it.
	vore_taste = "cheese"

	can_pull_size = ITEMSIZE_TINY // Rykka - Uncommented these. Not sure why they were commented out in the original Polaris files, maybe a mob rework mistake?
	can_pull_mobs = MOB_PULL_NONE // Rykka - Uncommented these. Not sure why they were commented out in the original Polaris files, maybe a mob rework mistake?

	desc = "A small rodent, often seen hiding in maintenance areas and making a nuisance of itself. And stealing cheese, or annoying the chef. SQUEAK! <3"

	size_multiplier = 0.25
	movement_cooldown = 1.5 //roughly half the speed of a person
	universal_understand = 1

/mob/living/simple_mob/animal/passive/mouse/attack_hand(mob/living/L)
	if(L.a_intent == I_HELP && !istype(loc, /obj/item/weapon/holder)) //if lime intent and not in a holder already
		if(!src.attempt_to_scoop(L)) //the superior way to handle scooping, checks size
			..() //mouse too big to grab? pet the large mouse instead
	else
		..()

//No longer in use, as mice create a holder/micro object instead
/obj/item/weapon/holder/mouse/attack_self(var/mob/U)
	for(var/mob/living/simple_mob/M in src.contents)
		if((I_HELP) && U.canClick()) //a little snowflakey, but makes it use the same cooldown as interacting with non-inventory objects
			U.setClickCooldown(U.get_attack_speed()) //if there's a cleaner way in baycode, I'll change this
			U.visible_message("<span class='notice'>[U] [M.response_help] \the [M].</span>")


/mob/living/simple_mob/animal/passive/mouse/MouseDrop(var/obj/O) //this proc would be very easy to apply to all mobs, holders generate dynamically
	if(!(usr == src || O))
		return ..()
	if(istype(O, /mob/living) && O.Adjacent(src)) //controls scooping by mobs
		var/mob/living/L = O
		if(!src.attempt_to_scoop(L, (src == usr)))
			return //this way it doesnt default to the generic animal pickup which isnt size restricted
	if(istype(O, /obj/item/weapon/storage) && O.Adjacent(src)) //controls diving into storage
		var/obj/item/weapon/storage/S = O
		var/obj/item/weapon/holder/H = new holder_type(get_turf(src)) //this works weird, but it creates an empty holder, to see if that holder can fit
		if(S.can_be_inserted(H) && (src.size_multiplier <= 0.75))
			H.held_mob = src
			src.forceMove(H)
			visible_message("<span class='notice'>\the [src] squeezes into \the [S].</span>")
			H.forceMove(S)
			H.sync(src)
			return 1
		else
			qdel(H) //this deletes the empty holder if it doesnt work
			to_chat(usr,"<span class='notice'>You can't fit inside \the [S]!</span>")
			return 0
	else
		..()

/mob/living/simple_mob/animal/passive/mouse/resize(var/new_size, var/animate = TRUE)
	size_multiplier = max(size_multiplier + 0.75, 1) //keeps sprite sizes consistent, keeps multiplier values low
	..()
	size_multiplier = max(size_multiplier - 0.75, 0.25) //the limits here ensure no negative values or infinite shrinkage