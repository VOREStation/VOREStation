/// Our summonables
#define SOULSTONE /obj/item/soulstone
#define SHELL /obj/structure/constructshell
#define ARTIFACT /obj/machinery/artifact

/// Modified version of the cultblade that xenoarch spawned.
/// This is a usuable version that isn't just a trap if you find it and try to use it on a mob.
/// Has some spooky effects, damages you as you use it (which fuels the sword) and can really hurt if overused.
/// And if you feed it enough, it allows the sword to do some special spawns.
/// Melee has always been a VERY underused thing and guns are EXTREMELY strong comparitively.
/// Thus, this gives the xenoarch a few choices when finding this:
/// Give it to R&D to deconstruct, use it to fight mobs off near artifact sites, give it to people exploring space, or keep it to summon more artifacts.
/// If you DO decide to use it and then give it to R&D...Well...Either you or whoever puts it into the deconstructor is going to have a BAD time.
/obj/item/melee/artifact_blade
	name = "artifact blade"
	desc = "A mysterious blade that emanates terrifying power"
	icon_state = "cultblade"
	origin_tech = list(TECH_COMBAT = 6, TECH_ARCANE = 6, TECH_BIO = 6)
	w_class = ITEMSIZE_LARGE
	force = 30
	throwforce = 10
	toolspeed = 5 //Syncs perfectly with the animation time.
	hitsound = 'sound/weapons/bladeslice.ogg'
	drop_sound = 'sound/items/drop/sword.ogg'
	pickup_sound = 'sound/items/pickup/sword.ogg'
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	edge = TRUE
	sharp = TRUE
	embed_chance = 0
	var/mob/living/carbon/human/last_touched //The last human that touched us
	var/stored_blood = 0 //How much energy we have!
	var/last_special = 0 //How recently our powers were used! Can be admin-set to a high number to keep from having the mode able to be changed.
	var/list/abilities = list("Consecrate", "Summon")
	var/list/summonables = list("Soulstone" = SOULSTONE, "Shell" = SHELL, "Cultic Artifact" = ARTIFACT)
	var/consecrating = FALSE //If we are consecrating or not!
	var/consecration_cost = 10 //Ten stored_blood per use!
	var/empowered = FALSE //If our next atack is empowered (2x damage)

/obj/item/melee/artifact_blade/Initialize(mapload) //We will never spawn without xenoarch or SOMEONE unearthing us.
	. = ..()
	//START_PROCESSING(SSobj, src) //We could start processing here, but let's wait until someone touches us. Uncomment this if more stuff is added and you want it to do spooky passive things.

/obj/item/melee/artifact_blade/examine(mob/user)
	. = ..()
	if(stored_blood && user == last_touched)
		. += span_cult("You can sense the blade has about " + span_bold("[stored_blood]") + " lifeforce contained within it.")

/obj/item/melee/artifact_blade/process()
	if(!last_touched || !stored_blood) //Nobody has touched us yet or we have no energy...For now.
		return
	if(!last_touched || last_touched.stat == DEAD) //If our user doesn't exist or is dead, stop processing until the next unlucky sod touches us.
		STOP_PROCESSING(SSobj, src)
		last_touched = null
		return
	if(loc == last_touched && (last_touched.life_tick % 30 == 0)) //We are currently being wielded by our owner. One proc every minute.
		/// First and foremost, the sword passively takes some blood from you when you hold it.
		/// This doesn't INJURE you like using it but does take blood. And a LOT of it. If you just carry the sword around, it's going to drain you.
		to_chat(last_touched, span_cult("You feel weaker as the sword drains your lifeforce, imbuing itself with power."))
		var/blood_to_remove = rand(10,30)
		if(last_touched.remove_blood(blood_to_remove))
			stored_blood += blood_to_remove*3
			empowered = 1
			return //We are done with our effects.
		else
			return

/obj/item/melee/artifact_blade/Destroy()
	if(stored_blood && last_touched && last_touched.stat != DEAD) //We have been activated (have some energy), an owner and they are alive. They are going to feel pain.
		to_chat(last_touched, span_cult("You feel as though your mind is suddenly being torn apart at the seams as the [src] is destroyed!"))
		last_touched.Paralyse(10)
		last_touched.make_jittery(1000)
		last_touched.eye_blurry += 10
		last_touched.add_modifier(/datum/modifier/agonize, 30 SECONDS)
		blood_splatter(last_touched, last_touched, 1)
		if(last_touched.loc)
			conjure_animation(last_touched.loc)
	visible_message(span_cult("\The [src] screeches as it's destroyed"))
	lightning_strike(last_touched.loc, TRUE)
	playsound(src, 'sound/goonstation/spooky/creepyshriek.ogg', 100, 1, 75) //It plays VERY far.
	last_touched = null //Get rid of the reference to our owner.
	..()


/obj/item/melee/artifact_blade/cultify()
	return

/obj/item/melee/artifact_blade/attack(mob/living/M, mob/living/user, var/target_zone)
	if(M == user) //No accidentally hitting yourself and exploding.
		return
	var/zone = (user.hand ? "l_arm":"r_arm") //Which arm we're in!
	var/prior_force = force
	if(empowered)
		force = force*2
		empowered = 0
	/// First, we check a few things.
	/// Check 1: We aren't a cultist and they're a human AND they're not AI controlled
	/// OR
	/// Check 2: (We're a cultist AND they're a cultist) OR (Our factions align)
	/// If these are true, we get hurt.
	if((!iscultist(user) && (ishuman(M) && !istype(M, /mob/living/carbon/human/ai_controlled))  || ((iscultist(user) && iscultist(M)) || M.faction == user.faction)))
		user.visible_message(span_cult("[user]'s arm is engulfed in dark flames!"))
		to_chat(user, span_cult("An inexplicable force rips through your arm as it's engulfed in flames, tearing the sword from your grasp!"))
		user.drop_from_inventory(src, user.loc)
		user.Weaken(5)
		throw_at(get_edge_target_turf(src,pick(alldirs)),rand(1,10),5)
		user.apply_damage(rand(force/2, force), BURN, zone, FALSE)
		return

	..() //We hit them!

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/external/affecting = H.get_organ(zone)

		to_chat(user, span_cult("You feel your [affecting.name] tearing from the inside out as the sword takes its blood price!"))

		var/damage_to_apply = rand(1,3)
		affecting.take_damage(damage_to_apply, sharp = FALSE, edge = FALSE) //Careful...Too much use and you might break your arm! This doesn't make you bleed because the sword is slurping that up.
		if(((affecting.brute_dam + affecting.burn_dam) >= affecting.max_damage) && prob((affecting.brute_dam + affecting.burn_dam))) //Don't just splint  your arm and keep using it, because you'll lose it!
			user.visible_message(span_cult("[H]'s arm is engulfed in dark flames!"))
			affecting.droplimb(TRUE, DROPLIMB_BURN) //And by hacked off, we mean melted into ashes... It's fire, so it's a clean loss.

		var/blood_loss = damage_to_apply*3
		if(H.remove_blood(blood_loss)) //Non insignificant amount if we keep using it. 3 to 15 blood lost per swing. Blood volume base is 560. Anything above 476 is safe. This means we get 28 to 5 swings. Average being 9 swings.
			stored_blood += blood_loss //We add the damage dealt to our owner to our stored blood.

		/// If the thing we're hitting is dead, our faction, friendly, or synthetic, we get no blood.
		if(M.stat < DEAD && M.faction != user.faction && !ispassive(M) && !issilicon(M) && !isbot(M) && !isslime(M))
			stored_blood += force

	//If the user isn't 'worthy' they get a single swing before the sword THROWS itself away from them. Possibly even off-screen!
	else if(istype(user, /mob/living/simple_mob/construct))
		to_chat(user, span_cult("An inexplicable force rips through you, tearing the sword from your grasp!"))
		user.drop_from_inventory(src, user.loc)
		throw_at(get_edge_target_turf(src,pick(alldirs)),rand(1,10),5)

	else
		to_chat(user, span_cult("The blade hisses, forcing itself from your manipulators. \The [src] will only allow mortals to wield it against foes, not kin."))
		user.drop_from_inventory(src, user.loc)
		throw_at(get_edge_target_turf(src,pick(alldirs)),rand(1,10),5)

	if(prob(10)) //During testing, this was set to 100% of the time to make sure it works... It went  from spooky to 'dear god make it stop'
		var/spooky = pick('sound/effects/ghost.ogg', 'sound/effects/ghost2.ogg', 'sound/effects/Heart Beat.ogg', 'sound/effects/screech.ogg',\
		'sound/hallucinations/behind_you1.ogg', 'sound/hallucinations/behind_you2.ogg', 'sound/hallucinations/far_noise.ogg', 'sound/hallucinations/growl1.ogg', 'sound/hallucinations/growl2.ogg',\
		'sound/hallucinations/growl3.ogg', 'sound/hallucinations/im_here1.ogg', 'sound/hallucinations/im_here2.ogg', 'sound/hallucinations/i_see_you1.ogg', 'sound/hallucinations/i_see_you2.ogg',\
		'sound/hallucinations/look_up1.ogg', 'sound/hallucinations/look_up2.ogg', 'sound/hallucinations/over_here1.ogg', 'sound/hallucinations/over_here2.ogg', 'sound/hallucinations/over_here3.ogg',\
		'sound/hallucinations/wail.ogg') //It's just a cursed, talking sword. Nothing to fear!
		playsound(src, spooky, 50, 1)

	force = prior_force //Return our force back.
	return 1

/obj/item/melee/artifact_blade/pickup(mob/living/user as mob)
	// We check to see if the person picking us up isn't our owner, not a cultist, and they're human.
	// Yes. This means you can hand off the sword to someone else to make them the newfound owner of the cursed sword.
	if((user != last_touched) && !iscultist(user) && ishuman(user))
		to_chat(user, span_cult("An overwhelming feeling of dread comes over you as you pick up the sword. You feel as though it has become attached to you."))
		last_touched = user
		START_PROCESSING(SSobj, src)

/obj/item/melee/artifact_blade/attack_self(mob/user as mob)
	if(last_special > world.time - 120)
		to_chat(user, span_cult("The blade does not respond to your attempts, having recently performed an action!"))
		return
	last_special = world.time
	if(stored_blood < 10)
		to_chat(user, span_cult("The blade does not respond to your attempts, seeming to have not enough blood to perform any actions!"))
		return
	if(stored_blood >= 10)
		var/choice = tgui_input_list(user, "What action do you wish to have the blade perform?", "Download", abilities)
		if(choice && loc == user)
			switch(choice)
				if("Consecrate")
					var/decision2 = tgui_alert(user, "Do you wish to toggle the sword's 'consecrate' mode? If enabled, this will allow the sword to turn floors and walls into a more cult-like appearance! It requires [consecration_cost] per use!", "Consecrate!", list("Toggle on", "Toggle off"))
					consecrate_toggle(user, decision2)
					return
				/// Spawning logic. Checks the 'summonables' list.
				if("Summon")
					var/summoned_item = tgui_input_list(user, "What do you wish to summon?", "Summon", summonables)
					summon_item(user, summoned_item)
					return

/obj/item/melee/artifact_blade/proc/consecrate_toggle(mob/user as mob, var/toggle)
	switch(toggle)
		if("Toggle on")
			consecrating = TRUE
			to_chat(user, span_cult("The blade will now transform walls and tiles!"))
			return
		if("Toggle off")
			consecrating = FALSE
			to_chat(user, span_cult("The blade will " + span_bold("NOT") +" transform walls and tiles!"))
			return
		else
			return

/// It lets them select it, gives them a small blurb on it (w/ cost), then checks to see if they have enough blood.
/// The summonables list can be VV'd by admins to allow for adminbus.
/// To add to the list: Add-Item, Multi-line text (Front-facing name), Associated value = yes, Atom Typepath = whatever you want.
/// This should appear something like " Paper = /obj/item/paper " if you did it right, and will let them summon paper!
/obj/item/melee/artifact_blade/proc/summon_item(mob/user as mob, var/selected_item)
	if(selected_item)
		if(selected_item == "Soulstone")
			var/decision2 = tgui_alert(user, "Do you wish to create a redspace gem? This will take 200 lifeforce from the sword.", "Generate Gem", list("YES", "NO"))
			if(stored_blood < 200)
				to_chat(user, span_cult("The blade does not have enough lifeforce!"))
				return
			if(decision2 == "YES")
				var/obj/item/soulstone/our_stone = new SOULSTONE(user.loc)
				our_stone.desc = "A glowing stone made of what appears to be a pure chunk of redspace. It seems to have the power to transfer the consciousness of dead or nearly-dead humanoids into it."
				our_stone.name  = "Redspace Gem"
				stored_blood -= 200
				to_chat(user, span_cult("You have summoned a redspace gem!"))
				return
			else
				return
		if(selected_item == "Shell")
			var/decision2 = tgui_alert(user, "Do you wish to create a shell? This will take 500 lifeforce from the sword.", "Generate Shell", list("YES", "NO"))
			if(stored_blood < 500)
				to_chat(user, span_cult("The blade does not have enough lifeforce!"))
				return
			if(decision2 == "YES")
				var/obj/structure/constructshell/shell = new SHELL(user.loc)
				shell.desc = "A strange collection of stone carved out in a vague, humanoid shape. Red, pulsing lines travel down its entirety."
				stored_blood -= 500 //This is VERY costly.
				return

		/// This is one of the ways for xenoarch to obtain more artifacts in case you have depleted all the large artifacts in the available world.
		/// While the artifact cap is relatively high, the more Z-levels that spawn any mineral turf, the less artifacts xenoarch can reliably find.
		/// In some cases, if a xenoarch was REALLY unlucky, they could only find 3-4 large artifacts in the (readily) available Z levels without scouring the entire universe.
		/// So this acts as a "You sacrifice a LOT to get a random artifact"
		if(selected_item == "Cultic Artifact")
			var/decision2 = tgui_alert(user, "Do you wish to create an artifact? This will take 1000 lifeforce from the sword.", "Generate Artifact", list("YES", "NO"))
			if(stored_blood < 1000)
				to_chat(user, span_cult("The blade does not have enough lifeforce!"))
				return
			if(decision2 == "YES")
				var/obj/machinery/artifact/artifact = new ARTIFACT(user.loc)
				artifact.desc = "A strange artifact. Red, pulsing lines travel down its entirety. It appears as though it has been brought into this reality through abnormal means."
				stored_blood -= 500 //This is VERY costly.
				return
			else
				return

		if(selected_item in summonables) //If admins modify the list, let's spawn it!
			//This one doesn't have a blood requirement, barring the 100 required to GET to this menu. If an admin VV'd the list, there's a reason!
			var/thing_to_spawn = summonables[selected_item]
			new thing_to_spawn(user.loc)
			stored_blood = max(0,stored_blood-250) //Subtract 250 stored blood, down to a minimum of 0. No negative numbers here!
			return
		else // You're trying to href hack it! (Or an admin put in the wrong thing). I'm going to assume if you know how to href hack, you're looking at this beforehand.
			message_admins("[key_name_admin(user)] attempted to spawn an object not in the artifact blade's spawnlist! This is either a HREF hack, the list was improperly VV'd by an admin, or something went wrong!")
			log_game("[key_name_admin(user)] attempted to spawn an object not in the artifact blade's spawnlist!")
			return
	else
		return


/// While this COULD just use the cultify() proc ultimately, I decided against that as this isn't meant to be
/// Some sort of weapon of mass destruction. It's supposed to be a funny, spooky artifact that you find.
/// Thus, it uses the 'occult_act' proc, which does a HEAVILY watered down version of the cultify() proc.
/// Only affects simulated turf, simulated walls, and girders. Nothing else. This shouldn't be desturctive, simply gimmicky.
/obj/item/melee/artifact_blade/afterattack(atom/A, mob/living/user, proximity)
	if(consecrating && proximity && !ismob(A))
		convert_turf(A, user)
	else
		..()


/// The fancy animation it plays when you hit something to convert it!
/obj/item/melee/artifact_blade/proc/conjure_animation(var/turf/target) //Taken from occult wizard code.
	var/atom/movable/overlay/animation = new /atom/movable/overlay(target)
	animation.name = "conjure"
	animation.icon = 'icons/effects/effects.dmi'
	animation.plane = OBJ_PLANE
	animation.layer = ABOVE_JUNK_LAYER
	animation.icon_state = "cultwall"
	flick("cultwall",animation)
	spawn(10)
		qdel(animation)

/// When it actually, properly converts the turf.
/obj/item/melee/artifact_blade/proc/convert_turf(atom/A, mob/living/user) //Shamelessly taken from RCD code.
	if(stored_blood < consecration_cost)
		to_chat(user, span_cult("\The [src] lacks enough lifeforce to convert."))
		return FALSE
	conjure_animation(A, toolspeed)
	if(do_after(user, toolspeed, target = A))
		if(stored_blood < consecration_cost)
			to_chat(user, span_cult("\The [src] lacks enough lifeforce to convert."))
			return FALSE
		if(A.occult_act(user))
			stored_blood -= consecration_cost
			return TRUE

	//Moving = stop
	return FALSE
#undef SOULSTONE
#undef SHELL
#undef ARTIFACT
