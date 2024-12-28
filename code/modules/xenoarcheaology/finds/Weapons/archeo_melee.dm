/// Our modes
#define CONSECRATE 1
#define PURGE 2

/// Our summonables
#define SOULSTONE /obj/item/soulstone
#define SHELL /obj/structure/constructshell

/obj/item/melee/artifact_blade
	name = "artifact blade"
	desc = "A mysterious blade that emanates terrifying power"
	icon_state = "cultblade"
	origin_tech = list(TECH_COMBAT = 6, TECH_ARCANE = 6, TECH_BIO = 6)
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
	var/stored_blood = 0 //How much energy we have!
	var/last_special = 0 //How recently our powers were used! Can be admin-set to a high number to keep from having the mode able to be changed.
	var/list/abilities = list("Consecrate", "Summon", "Purge")

	/// This is listed here instead so admins can modify the list to spawn different stuff.
	/// The logic is "What we want the user to read" = "Path of thing we want to spawn"
	/// Admins can VV this to do something like "Paper" = /obj/item/paper
	var/list/summonables = list("Soulstone" = SOULSTONE, "Shell" = SHELL)
	var/mode = 0 //

/obj/item/melee/artifact_blade/Initialize() //We will never spawn without xenoarch or SOMEONE unearthing us.
	. = ..()
	//START_PROCESSING(SSobj, src) //We could start processing here, but let's wait until someone touches us.

/obj/item/melee/artifact_blade/examine(mob/user)
	. = ..()
	if(stored_blood && user == last_touched)
	. += span_cult("You can sense the blade has about <b>[stored_blood]</b> lifeforce contained within it.")

/obj/item/melee/artifact_blade/process()
	if(!last_touched) //Nobody has touched us yet...For now.
		return
	if(loc == last_touched) //We are currently being wielded by our owner
		return //Now, we do a variety of effects. TODO
	if(!last_touched || last_touched.stat == DEAD) //If our user doesn't exist or is dead, stop processing until the next unlucky sod touches us.
		STOP_PROCESSING(SSobj, src)
		last_touched = null
		return

/obj/item/melee/artifact_blade/cultify()
	return

/obj/item/melee/artifact_blade/attack(mob/living/M, mob/living/user, var/target_zone)
	var/zone = (user.hand ? "l_arm":"r_arm") //Which arm we're in!

	/// First, we check a few things.
	/// If we are (NOT a cultist) AND (we are using it on a human OR our faction = their faction), OR we use it against a cultist, we get wrecked.
	/// Fun fact, monkeys count as humans. Yes.
	if(!iscultist(user) && (ishuman(M) || M.faction == user.faction) && !iscultist(M))
		user.visible_message(span_cult("[user]'s arm is engulfed in dark flames!"))
		to_chat(user, span_cult("An inexplicable force rips through your arm as it's engulfed in flames, tearing the sword from your grasp!"))
		//random amount of damage between half of the blade's force and the full force of the blade.
		user.drop_from_inventory(src, src.loc)
		throw_at(get_edge_target_turf(src, pick(alldirs)), rand(1,5), throw_speed)
		user.apply_damage(rand(force/2, force), BURN, zone, FALSE)
		user.Weaken(5)
		return

	..() //We hit them!

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/external/affecting = H.get_organ(zone)

		to_chat(user, span_cult("You feel your [affecting.name] tearing from the inside out as the sword takes its blood price!"))

		var/damage_to_apply = rand(1,5)
		affecting.take_damage(damage_to_apply, sharp = TRUE, edge = TRUE) //Careful...Too much use and you might break your arm!
		if(((affecting.brute_dam + affecting.burn_dam) >= affecting.max_damage/2) && prob((affecting.brute_dam + affecting.burn_dam))) //If our limb has >= half the max health damage, start rolling a probability our limb is hacked off!
			user.visible_message(span_cult("[H]'s arm is engulfed in dark flames!"))
			affecting.droplimb(1, DROPLIMB_BURN) //And by hacked off, we mean melted into ashes... It's fire, so it's a clean loss.

		var/blood_loss = damage_to_apply*3
		if(H.remove_blood(blood_loss)) //Non insignificant amount if we keep using it. 3 to 15 blood lost per swing. Blood volume base is 560. Anything above 476 is safe. This means we get 28 to 5 swings. Average being 9 swings.
			stored_blood += blood_loss //We add the damage dealt to our owner to our stored blood.

		/// If the thing we're hitting is dead, our faction, friendly, or synthetic, we get no blood.
		if(M.stat < DEAD && M.faction != user.faction && !ispassive(M) && !issilicon(M) && !isbot(M) && isslime(M))
			stored_blood += force

	//If the user isn't 'worthy' they get a single swing before the sword THROWS itself away from them. Possibly even off-screen!
	else if(!istype(user, /mob/living/simple_mob/construct))
		to_chat(user, span_cult("An inexplicable force rips through you, tearing the sword from your grasp!"))
		user.drop_from_inventory(src, src.loc)
		throw_at(get_edge_target_turf(src, pick(alldirs)), rand(1,10), throw_speed)

	else
		to_chat(user, span_cult("The blade hisses, forcing itself from your manipulators. \The [src] will only allow mortals to wield it against foes, not kin."))
		user.drop_from_inventory(src, src.loc)
		throw_at(get_edge_target_turf(src, pick(alldirs)), rand(1,10), throw_speed)

	if(prob(10)) //During testing, this was set to 100% of the time to make sure it works... It went  from spooky to 'dear god make it  stop'
		var/spooky = pick('sound/effects/ghost.ogg', 'sound/effects/ghost2.ogg', 'sound/effects/Heart Beat.ogg', 'sound/effects/screech.ogg',\
		'sound/hallucinations/behind_you1.ogg', 'sound/hallucinations/behind_you2.ogg', 'sound/hallucinations/far_noise.ogg', 'sound/hallucinations/growl1.ogg', 'sound/hallucinations/growl2.ogg',\
		'sound/hallucinations/growl3.ogg', 'sound/hallucinations/im_here1.ogg', 'sound/hallucinations/im_here2.ogg', 'sound/hallucinations/i_see_you1.ogg', 'sound/hallucinations/i_see_you2.ogg',\
		'sound/hallucinations/look_up1.ogg', 'sound/hallucinations/look_up2.ogg', 'sound/hallucinations/over_here1.ogg', 'sound/hallucinations/over_here2.ogg', 'sound/hallucinations/over_here3.ogg',\
		'sound/hallucinations/wail.ogg') //It's just a cursed, talking sword. Nothing to fear!
		playsound(src, spooky, 50, 1)

	return 1

/obj/item/melee/artifact_blade/pickup(mob/living/user as mob)
	// We check to see if the person picking us up isn't our owner, not a cultist, not a construst, and they're human.
	// Yes. This means you can hand off the sword to someone else to make them the newfound owner of the cursed sword.
	if((user != last_touched) && !iscultist(user) && !istype(user, /mob/living/simple_mob/construct) && ishuman(user))
		to_chat(user, span_cult("An overwhelming feeling of dread comes over you as you pick up the sword. You feel as though it has become attached to you."))
		last_touched = user
		START_PROCESSING(SSobj, src)

/obj/item/melee/artifact_blade/attack_self(mob/user as mob)
	if(last_special > world.time - 120)
		to_chat(user, span_cult("The blade does not respond to your attempts, having recently performed an action!"))
		return
	last_special = world.time
	if(stored_blood < 20)
		to_chat(user, span_cult("The blade does not respond to your attempts, seeming to have not enough blood to perform any actions!"))
		return
	if(stored_blood > 100)
		var/choice = tgui_input_list(user, "What action do you wish to have the blade p", "Download", abilities)
		if(choice && loc == user.loc)
			switch(choice)
				if("Consecrate")
					mode = 1

				if("Summon")
					var/summon_item = tgui_input_list(user, "What do you wish to summon?", "Summon", summonables)
					if(summon_item)
						switch(summon_item)
							if("Soulstone")
								var/obj/item/soulstone/our_stone = new SOULSTONE(user.loc)
								our_stone.desc = "A glowing stone made of what appears to be a pure chunk of redspace. It seems to have the power to transfer the consciousness of dead or nearly-dead humanoids into it."
								our_stone.name  = "Redspace Gem"
								return
							if("Shell")
								return //TODO

							if(summon_item && (summon_item in summonables)) //If admins modify the list, let's spawn it!
								new summon_item(src.loc)
								return
							else // You're trying to href hack it! (Or an admin put in the wrong thing). I'm going to assume if you know how to href hack, you're looking at this beforehand. (Hi!)
								message_admins("[key_name_admin(user)] attempted to spawn an object not in the artifact blade's spawnlist! This is either a HREF hack, the list was improperly VV'd by an admin, or something went wrong!")
								log_game("[key_name_admin(user)] attempted to spawn an object not in the artifact blade's spawnlist!")
								return
				if("Purge")
					return //TODO

#undef CONSECRATE
#undef PURGE
