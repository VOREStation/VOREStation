///////////////////// Simple Animal /////////////////////
/mob/living/simple_animal
	var/swallowTime = 30 				//How long it takes to eat its prey in 1/10 of a second. The default is 3 seconds.
	var/list/prey_excludes = list()		//For excluding people from being eaten.

//
// Simple nom proc for if you get ckey'd into a simple_animal mob! Avoids grabs.
//
/mob/living/proc/animal_nom(var/mob/living/T in oview(1))
	set name = "Animal Nom"
	set category = "IC"
	set desc = "Since you can't grab, you get a verb!"

	if (stat != CONSCIOUS)
		return
	if (istype(src,/mob/living/simple_animal/mouse) && T.ckey == null)
		return
	return feed_grabbed_to_self(src,T)

//
// Simple proc for animals to have their digestion toggled on/off externally
//
/mob/living/simple_animal/verb/toggle_digestion()
	set name = "Toggle Animal's Digestion"
	set desc = "Enables digestion on this mob for 20 minutes."
	set category = "OOC"
	set src in oview(1)

	var/mob/living/carbon/human/user = usr
	if(!istype(user) || user.stat) return

	var/datum/belly/B = vore_organs[vore_selected]
	if(faction != user.faction)
		user << "<span class='warning'>This predator isn't friendly, and doesn't give a shit about your opinions of it digesting you.</span>"
		return
	if(B.digest_mode == "Hold")
		var/confirm = alert(user, "Enabling digestion on [name] will cause it to digest all stomach contents. Using this to break OOC prefs is against the rules. Digestion will disable itself after 20 minutes.", "Enabling [name]'s Digestion", "Enable", "Cancel")
		if(confirm == "Enable")
			B.digest_mode = "Digest"
			spawn(12000) //12000=20 minutes
				if(src)	B.digest_mode = "Hold"
	else
		var/confirm = alert(user, "This mob is currently set to digest all stomach contents. Do you want to disable this?", "Disabling [name]'s Digestion", "Disable", "Cancel")
		if(confirm == "Disable")
			B.digest_mode = "Hold"

/mob/living/simple_animal/proc/away_from_players()
	//Reduces the amount of logging spam by only allowing procs to continue if they have a player nearby to listen.
	//A return of 0 means that it is not away from players.
	// This is a stripped down version of the proc get_mobs_and_objs_in_view_fast()
	var/turf/T = get_turf(src)
	if(!T) return 1 // If the turf doesn't exist, we don't want the proc running regardless

	// Quickly grabs the mob's hearing range to check from
	var/list/hear = dview(world.view,T,INVISIBILITY_MAXIMUM)
	var/list/hearturfs = list()
	for(var/thing in hear)
		if(istype(thing,/mob))
			hearturfs += get_turf(thing)

	//Check each player to see if they're inside said 'hearing range' turfs
	for(var/mob in player_list)
		if(!istype(mob, /mob))
			crash_with("There is a null or non-mob reference inside player_list.")
			continue
		if(get_turf(mob) in hearturfs)
			return 0
	return 1


mob/living/simple_animal/custom_emote()
	if (away_from_players()) return
	. = ..()

mob/living/simple_animal/say()
	if (away_from_players()) return
	. = ..()

/* Auto transfer in mobs example for use in other applications
		Hello from Citadel!

Citadel's initialize code meant we had to be creative in how we gave bellies to a mob, in this case an Ash Drake from Lavaland.

We needed to connect the bellies, enable auto transfer to work, make sure they were there.
This also applies to player controlled, vore capable mobs as well. They will automatically cycle through the line.

This example of course is just how one could go about it. 

-Pooj

### Only vore attempt once, unless sanity checks to revoke a do_mob/do_after if completed is implimented into the animal nomming. ###
### With duplicates spawned in the menu, autotransfer will have you in multiple places at once. It's weird. ###

/mob/living/simple_animal/hostile/dragon/Initialize()
	// Create and register 'stomachs'
	var/datum/belly/dragon/maw/maw = new(src)
	var/datum/belly/dragon/gullet/gullet = new(src)
	var/datum/belly/dragon/gut/gut = new(src)
	for(var/datum/belly/X in list(maw, gullet, gut))
		vore_organs[X.name] = X
	// Connect 'stomachs' together
	maw.transferlocation = gullet
	gullet.transferlocation = gut
	vore_selected = maw.name  // NPC eats into maw
	return ..()

set up your bellies as so:
/datum/belly/dragon/maw
	name = "maw"
	inside_flavor = "The maw of the dreaded Ash drake closes around you, engulfing you into a swelteringly hot, disgusting enviroment. The acidic saliva tingles over your form while that tongue pushes you further back...towards the dark gullet beyond."
	vore_verb = "scoop"
	vore_sound = <insert custom sound here>
	swallow_time = 20 // Two seconds to eat the person, was a special do_mob flag
	escapechance = 25
	// From above, will transfer into gullet
	transferchance = 25
	autotransferchance = 66 
	autotransferwait = 200

/datum/belly/dragon/gullet
	name = "gullet"
	inside_flavor = "A ripple of muscle and arching of the tongue pushes you down like any other food. No choice in the matter, you're simply consumed. The dark ambiance of the outside world is replaced with working, wet flesh. Your only light being what you brought with you."
	swallow_time = 60  // costs extra time to eat directly to here
	escapechance = 5
	// From above, will transfer into gut
	transferchance = 25
	autotransferchance = 50
	autotransferwait = 200

/datum/belly/dragon/gut
	name = "stomach"
	vore_capacity = 5 //I doubt this many people will actually last in the gut, but...
	inside_flavor = "With a rush of burning ichor greeting you, you're introduced to the Drake's stomach. Wrinkled walls greedily grind against you, acidic slimes working into your body as you become fuel and nutriton for a superior predator. All that's left is your body's willingness to resist your destiny."
	digest_mode = DM_DRAGON // special mode that had additional clauses. 
	digest_burn = 5
	swallow_time = 100  // costs extra time to eat directly to here
	escapechance = 0
	
*/