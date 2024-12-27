/obj/item/melee/artifact_blade //This is MOSTlY the cult blade, but with special stuff going on
	name = "cult blade"
	desc = "A mysterious blade that emanates terrifying power"
	icon_state = "cultblade"
	origin_tech = list(TECH_COMBAT = 5, TECH_ARCANE = 5)
	w_class = ITEMSIZE_LARGE
	force = 30
	throwforce = 10
	hitsound = 'sound/weapons/bladeslice.ogg'
	drop_sound = 'sound/items/drop/sword.ogg'
	pickup_sound = 'sound/items/pickup/sword.ogg'
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	edge = TRUE
	sharp = TRUE
	var/mob/living/carbon/human/last_touched //The last human that touched us
	var/stored_blood = 0

/obj/item/melee/artifact_blade/Initialize() //We will never spawn without xenoarch or SOMEONE unearthing us.
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/melee/artifact_blade/process()
	if(!last_touched) //Nobody has touched us yet...For now.
		return
	if(loc == last_touched) //We are currently being wielded by our owner
		return //Now, we do a variety of effects. TODO

/obj/item/melee/artifact_blade/cultify()
	return

/obj/item/melee/artifact_blade/attack(mob/living/M, mob/living/user, var/target_zone)
	..()

	var/zone = (user.hand ? "l_arm":"r_arm")
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/external/affecting = H.get_organ(zone)
		to_chat(user, span_cult("You feel your [affecting.name] tearing from the inside out as the sword takes its blood price!"))
		var/damage_to_apply = rand(1,5)
		affecting.take_damage(damage_to_apply, sharp = TRUE, edge = TRUE) //Careful...Too much use and  you might lose your limb!
		stored_blood += damage_to_apply //We add the damage dealt to our owner to our stored blood.

	else if(!istype(user, /mob/living/simple_mob/construct))
		to_chat(user, span_cult("An inexplicable force rips through you, tearing the sword from your grasp!")) //One swing and it tugs away from you
		user.drop_from_inventory(src, src.loc)
		throw_at(get_edge_target_turf(src, pick(alldirs)), rand(1,3), throw_speed)
	else
		to_chat(user, span_cult("The blade hisses, forcing itself from your manipulators. \The [src] will only allow mortals to wield it against foes, not kin."))
		user.drop_from_inventory(src, src.loc)
		throw_at(get_edge_target_turf(src, pick(alldirs)), rand(1,3), throw_speed)

	if(prob(10)) //During testing, this was set to 100% of the time to make sure it works... It went  from spooky to 'dear god make it  stop'
		var/spooky = pick('sound/effects/ghost.ogg', 'sound/effects/ghost2.ogg', 'sound/effects/Heart Beat.ogg', 'sound/effects/screech.ogg',\
		'sound/hallucinations/behind_you1.ogg', 'sound/hallucinations/behind_you2.ogg', 'sound/hallucinations/far_noise.ogg', 'sound/hallucinations/growl1.ogg', 'sound/hallucinations/growl2.ogg',\
		'sound/hallucinations/growl3.ogg', 'sound/hallucinations/im_here1.ogg', 'sound/hallucinations/im_here2.ogg', 'sound/hallucinations/i_see_you1.ogg', 'sound/hallucinations/i_see_you2.ogg',\
		'sound/hallucinations/look_up1.ogg', 'sound/hallucinations/look_up2.ogg', 'sound/hallucinations/over_here1.ogg', 'sound/hallucinations/over_here2.ogg', 'sound/hallucinations/over_here3.ogg',\
		'sound/hallucinations/turn_around1.ogg', 'sound/hallucinations/turn_around2.ogg', 'sound/hallucinations/veryfar_noise.ogg', 'sound/hallucinations/wail.ogg') //It's just a cursed, talking sword. Nothing to fear!
		playsound(src, spooky, 50, 1)

	return 1

/obj/item/melee/artifact_blade/pickup(mob/living/user as mob)
	//We check to see if the person picking us up isn't our owner, not a cultist, not a construst, and they're human.
	if((user != last_touched) && !iscultist(user) && !istype(user, /mob/living/simple_mob/construct) && ishuman(user))
		to_chat(user, span_warning("An overwhelming feeling of dread comes over you as you pick up the sword. You feel as though it has become attached to you."))
		last_touched = user
