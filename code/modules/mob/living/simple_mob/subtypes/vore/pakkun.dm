/datum/category_item/catalogue/fauna/pakkun
	name = "Wildlife - Pakkun"
	desc = "Classification: Mordens Lacerta\
	<br><br>\
	Their diet is primarily pescatarian, but they are known to consume other species and even their own - this activity doesn't appear to be malicious \
	or even borne out of hunger, but more of a form of playfighting among packmates. Some colonies are known to keep domesticated specimens as a form of pest control \
	despite the occasional accidents that can occur as a result of staff becoming overly friendly and triggering their playfighting instincts. \
	More mature specimens are identifiable by a greener tint to their skin, and eventually the development of frills \
	around their neck and along the backs of their heads."
	value = CATALOGUER_REWARD_TRIVIAL

/mob/living/simple_mob/vore/pakkun
	name = "pakkun"
	desc = "A small, blue, bipedal reptile. Its head and jaws are rather large in proportion to its body."
	tt_desc = "Mordens Lacerta"
	catalogue_data = list(/datum/category_item/catalogue/fauna/pakkun)
	player_msg = "Pakkuns are bipedal lizardy things. You don't really have much in the way of grasping fingers, but you have an extremely long and powerful tongue and a frankly disproportionate \
	stomach-to-body ratio. Pakkuns will eat just about anything, both for food and out of idle curiosity - if you encounter something you don't understand, put it in your mouth for science."

	icon_dead = "pakkun-dead"
	icon_living = "pakkun"
	icon_state = "pakkun"
	icon_rest = "pakkun-rest"
	icon = 'icons/mob/vore.dmi'

	faction = "pakkun"

	movement_cooldown = 2
	can_be_drop_pred = 1 //They can tongue vore.

	meat_amount = 5
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat

	vore_active = 1
	vore_icons = SA_ICON_LIVING

	harm_intent_damage = 3
	melee_damage_lower = 3
	melee_damage_upper = 5

	response_help = "pets"
	response_disarm = "shoves"
	response_harm = "punches"

	base_attack_cooldown = 5 SECONDS
	projectiletype = /obj/item/projectile/beam/appendage
	projectilesound = 'sound/effects/slime_squish.ogg'

	ai_holder_type = /datum/ai_holder/simple_mob/ranged/pakkun
	vore_default_mode = DM_SELECT

	var/extra_possessive = FALSE					// Enable if you want their tummy hugs to be inescapable
	var/autorest_cooldown = 100

	nom_mob = TRUE

	maxHealth = 100
	health = 100

/mob/living/simple_mob/vore/pakkun/Life()
	. = ..()
	if(client)
		return
	if(!ai_holder)
		return

	if(autorest_cooldown)
		autorest_cooldown --
	else if(prob(5) && (resting || ai_holder.stance == STANCE_IDLE))
		autorest_cooldown = rand(50,200)
		lay_down()

/mob/living/simple_mob/vore/pakkun/lay_down()
	. = ..()
	if(client)
		return
	if(!ai_holder)
		return

	if(resting)
		vore_selected.digest_mode = DM_UNABSORB
		ai_holder.go_sleep()

	else
		vore_selected.digest_mode = vore_default_mode
		ai_holder.go_wake()

/mob/living/simple_mob/vore/pakkun/attack_hand(mob/user)
	if(stat == DEAD)
		return ..()
	if(user.a_intent != I_HELP)
		return ..()
	if(resting)
		playsound(src, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
		user.visible_message("<span class='notice'>\The [user] shakes \the [src] awake.</span>","<span class='notice'>You shake \the [src] awake!</span>")
		lay_down()
		return
	else
		return ..()

/datum/ai_holder/simple_mob/ranged/pakkun
	pointblank = TRUE
	var/recent_target = null

/datum/ai_holder/simple_mob/ranged/pakkun/list_targets()
	var/list/our_targets = ..()
	for(var/list_target in our_targets)
		if(!isliving(list_target))
			our_targets -= list_target
			continue
		var/mob/living/L = list_target
		if(!(L.can_be_drop_prey && L.throw_vore && L.allowmobvore))
			our_targets -= list_target
			continue
	if(istype(holder, /mob/living/simple_mob))
		var/mob/living/simple_mob/SM = holder
		our_targets -= SM.prey_excludes // Lazylist, but subtracting a null from the list seems fine.
	return our_targets

/datum/ai_holder/simple_mob/ranged/pakkun/can_attack(atom/movable/the_target, var/vision_required = TRUE)
	.=..()
	if(isliving(the_target))
		var/mob/living/L = the_target
		if(!(L.can_be_drop_prey && L.throw_vore && L.allowmobvore))
			return FALSE
		if(istype(holder, /mob/living/simple_mob))
			var/mob/living/simple_mob/SM = holder
			if(LAZYFIND(SM.prey_excludes, L))
				return FALSE
	else
		return FALSE

/mob/living/simple_mob/vore/pakkun/on_throw_vore_special(var/pred, var/mob/living/target)
	if(pred && !extra_possessive && !(LAZYFIND(prey_excludes, target)))
		LAZYSET(prey_excludes, target, world.time)
		addtimer(CALLBACK(src, PROC_REF(removeMobFromPreyExcludes), WEAKREF(target)), 5 MINUTES)
	if(ai_holder)
		ai_holder.remove_target()

/mob/living/simple_mob/vore/pakkun/init_vore()
	..()
	var/obj/belly/B = vore_selected
	B.name = "stomach"
	B.desc = "you land with a soft bump in what can only be described as a big soft slimy sack, the walls effortlessly stretching to match your every move with no sign of reaching any kind of elastic \
	limit - and to add insult to injury, it seems the thing is... pressing on you, kneading over the lump you make in its midsection, as though rubbing in the fact that you've just been caught."
	B.absorbed_desc = "the endless smooshing and kneading has taken its toll, your form softening and sinking into the body of the greedy little reptile. It seems like you might be here for some time - \
	assuming you ever get out at all. For now though, you're stuck as some extra softness padding out a cute little lizard."
	B.belly_fullscreen = "a_tumby"
	B.escapechance = 25
	B.absorbchance = 0
	B.digestchance = 0
	B.digest_mode = DM_SELECT

/mob/living/simple_mob/vore/pakkun/attackby(var/obj/item/O, var/mob/user) //if they're newspapered, they'll spit out any junk they've eaten for whatever reason
    if(istype(O, /obj/item/weapon/newspaper) && !ckey && isturf(user.loc))
        user.visible_message("<span class='info'>[user] swats [src] with [O]!</span>")
        release_vore_contents()
        for(var/mob/living/L in living_mobs(0))
            if(!(LAZYFIND(prey_excludes, L)))
                LAZYSET(prey_excludes, L, world.time)
                addtimer(CALLBACK(src, PROC_REF(removeMobFromPreyExcludes), WEAKREF(L)), 5 MINUTES)
    else
        ..()

//a palette-swapped version that's a bit bossier, in JRPG tradition

/mob/living/simple_mob/vore/pakkun/snapdragon
	name = "snapdragon"
	desc = "A small, green, bipedal reptile. Its head and jaws are rather large in proportion to its body."
	icon_dead = "snapdragon-dead"
	icon_living = "snapdragon"
	icon_state = "snapdragon"
	icon_rest = "snapdragon-rest"

	extra_possessive = TRUE //you're gonna get KEPT, at least the first time you go in

/mob/living/simple_mob/vore/pakkun/snapdragon/on_throw_vore_special(var/pred, var/mob/living/target)
	..()
	extra_possessive = !extra_possessive //toggle their possessiveness on and off every time they eat someone

//an even greedier pallete-swap

/mob/living/simple_mob/vore/pakkun/sand
	name = "Sand pakkun"
	desc = "A small, yellow, bipedal reptile. Its head and jaws are rather large in proportion to its body."
	icon_dead = "pakkunyellow-dead"
	icon_living = "pakkunyellow"
	icon_state = "pakkunyellow"
	icon_rest = "pakkunyellow-rest"

	extra_possessive = TRUE // won't let its prey go if it's awake, luckily, see below.

/mob/living/simple_mob/vore/pakkun/sand/on_throw_vore_special(var/pred, var/mob/living/target)
	..()
	autorest_cooldown = 0 // Sand pakkuns, also known as napdragons, like to curl up for an small sleemp after eating. This is your chance to escape.

//use this one sparingly because it is absolutely turbolethal to anyone who has digestion turned on.

/mob/living/simple_mob/vore/pakkun/fire
	name = "Fire pakkun"
	desc = "A small, red, bipedal reptile. Its head and jaws are rather large in proportion to its body."
	icon_dead = "pakkunred-dead"
	icon_living = "pakkunred"
	icon_state = "pakkunred"
	icon_rest = "pakkunred-rest"

	extra_possessive = TRUE // yeah this one just... doesn't. It doesn't even have any fancy behaviours. Hope it gets tired or you get saved.

// this one's like a standard blue pakkun in terms of eating behaviour, but wanders a lot more quickly

/mob/living/simple_mob/vore/pakkun/purple
	name = "Amethyst pakkun"
	desc = "A small, purple, bipedal reptile. Its head and jaws are rather large in proportion to its body."
	icon_dead = "pakkunpurp-dead"
	icon_living = "pakkunpurp"
	icon_state = "pakkunpurp"
	icon_rest = "pakkunpurp-rest"

	movement_cooldown = -2

// (mostly) friendly pet version

/mob/living/simple_mob/vore/pakkun/snapdragon/snappy
	name = "Snappy"
	desc = "A friendly-looking lizard-thing. This one has a little row of spines running down the back of its head and a crest of frills around its neck."
	icon_dead = "snappy-dead"
	icon_living = "snappy"
	icon_state = "snappy"
	icon_rest = "snappy-rest"
	digestable = 0 // pet mob, do not eat
	devourable = 0

	ai_holder_type = /datum/ai_holder/simple_mob/ranged/pakkun/snappy
	vore_default_mode = DM_HOLD
	var/list/petters = list()

/datum/ai_holder/simple_mob/ranged/pakkun/snappy/list_targets()
	var/mob/living/simple_mob/vore/pakkun/snapdragon/snappy/SM = holder
	if (!LAZYLEN(SM.petters)) //very quick and dirty dropout if there are no valid targets
		return
	var/list/our_targets = ..()
	for(var/list_target in our_targets) //otherwise check the viable targets to see if any of them have petted
		if(!(list_target in SM.petters))
			our_targets -= list_target
	return our_targets

/datum/ai_holder/simple_mob/ranged/pakkun/snappy/can_attack(atom/movable/the_target, var/vision_required = TRUE)
	.=..()
	var/mob/living/simple_mob/vore/pakkun/snapdragon/snappy/SM = holder
	if(!(the_target in SM.petters))
		return FALSE

/mob/living/simple_mob/vore/pakkun/snapdragon/snappy/attack_hand(mob/living/carbon/human/M as mob)
	if(M.a_intent == I_HELP && !(M in petters))
		to_chat(M, "<span class='notice'>\The [src] gets a mischievous glint in her eye!!</span>")
		petters += M //YOU HAVE OFFERED YOURSELF TO THE LIZARD
	return ..()

/mob/living/simple_mob/vore/pakkun/snapdragon/snappy/lay_down()
	if(LAZYLEN(petters) && prob(50) && !resting) //50% chance she'll forgive a random person when she takes a nap
		petters -= pick(petters)
	..()

/mob/living/simple_mob/vore/pakkun/snapdragon/snappy/init_vore()
	..()
	var/obj/belly/B = vore_selected
	B.digest_mode = DM_HOLD
	B.desc = "the lizard gently yet insistently stuffs you down her gullet - evidently enjoying this moment of playtime as you land in a sprawled heap in the stretchy, clinging sack that makes up \
	most of her girth. Your movements are rewarded only with squeezing from outside, the skin of the reptile easily stretching out to match your movements no matter how hard you try to push. If anything, \
	wriggling about just seems to prompt the playful creature to mess with you more, mooshing her paws into the bulges you make, wrapping both arms around you and squeezing you tight, making it absolutely \
	plain that she's more than happy to just keep you in there - and is more than capable of doing so if she so chooses."
