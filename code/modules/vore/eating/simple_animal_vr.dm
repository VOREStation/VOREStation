///////////////////// Simple Animal /////////////////////
/mob/living/simple_mob
	var/swallowTime = (3 SECONDS)		//How long it takes to eat its prey in 1/10 of a second. The default is 3 seconds.
	var/list/prey_excludes = list()		//For excluding people from being eaten.

//
// Simple nom proc for if you get ckey'd into a simple_mob mob! Avoids grabs.
//
/mob/living/simple_mob/proc/animal_nom(var/mob/living/T in living_mobs(1))
	set name = "Animal Nom"
	set category = "IC"
	set desc = "Since you can't grab, you get a verb!"

	if (stat != CONSCIOUS)
		return
	if (istype(src,/mob/living/simple_mob/animal/passive/mouse) && T.ckey == null)
		return
	if (client && IsAdvancedToolUser())
		to_chat(src,"<span class='warning'>Put your hands to good use instead!</span>")
		return
	feed_grabbed_to_self(src,T)
	update_icon()
	return

//
// Simple proc for animals to have their digestion toggled on/off externally
//

/mob/living/simple_mob/verb/toggle_digestion()
	set name = "Toggle Animal's Digestion"
	set desc = "Enables digestion on this mob for 20 minutes."
	set category = "OOC"
	set src in oview(1)

	var/mob/living/carbon/human/user = usr
	if(!istype(user) || user.stat) return

	if(ai_holder.retaliate || (ai_holder.hostile && faction != user.faction))
		user << "<span class='warning'>This predator isn't friendly, and doesn't give a shit about your opinions of it digesting you.</span>"
		return
	if(vore_selected.digest_mode == DM_HOLD)
		var/confirm = alert(user, "Enabling digestion on [name] will cause it to digest all stomach contents. Using this to break OOC prefs is against the rules. Digestion will reset after 20 minutes.", "Enabling [name]'s Digestion", "Enable", "Cancel")
		if(confirm == "Enable")
			vore_selected.digest_mode = DM_DIGEST
			spawn(20 MINUTES)
				if(src)	vore_selected.digest_mode = vore_default_mode
	else
		var/confirm = alert(user, "This mob is currently set to process all stomach contents. Do you want to disable this?", "Disabling [name]'s Digestion", "Disable", "Cancel")
		if(confirm == "Disable")
			vore_selected.digest_mode = DM_HOLD

/mob/living/simple_mob/verb/toggle_fancygurgle()
	set name = "Toggle Animal's Gurgle sounds"
	set desc = "Switches between Fancy and Classic sounds on this mob."
	set category = "OOC"
	set src in oview(1)

	var/mob/living/user = usr	//I mean, At least ghosts won't use it.
	if(!istype(user) || user.stat) return

	vore_selected.fancy_vore = !vore_selected.fancy_vore
	to_chat(user, "[src] is now using [vore_selected.fancy_vore ? "Fancy" : "Classic"] vore sounds.")

/mob/living/simple_mob/attackby(var/obj/item/O, var/mob/user)
	if (istype(O, /obj/item/weapon/newspaper) && !(ckey || (ai_holder.hostile && faction != user.faction)) && isturf(user.loc))
		if (ai_holder.retaliate && prob(vore_pounce_chance/2)) // This is a gamble!
			user.Weaken(5) //They get tackled anyway whether they're edible or not.
			user.visible_message("<span class='danger'>\the [user] swats \the [src] with \the [O] and promptly gets tackled!</span>!")
			if (will_eat(user))
				set_AI_busy(TRUE)
				animal_nom(user)
				update_icon()
				set_AI_busy(FALSE)
			else if (!ai_holder.target) // no using this to clear a retaliate mob's target
				ai_holder.target = user //just because you're not tasty doesn't mean you get off the hook. A swat for a swat.
				//AttackTarget() //VOREStation AI Temporary Removal
				//LoseTarget() // only make one attempt at an attack rather than going into full rage mode
		else
			user.visible_message("<span class='info'>\the [user] swats \the [src] with \the [O]!</span>!")
			release_vore_contents()
			for(var/mob/living/L in living_mobs(0)) //add everyone on the tile to the do-not-eat list for a while
				if(!(L in prey_excludes)) // Unless they're already on it, just to avoid fuckery.
					prey_excludes += L
					spawn(5 MINUTES)
						if(src && L)
							prey_excludes -= L
	else
		..()

