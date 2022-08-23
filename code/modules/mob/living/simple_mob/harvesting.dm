
/mob/living/simple_mob
	// What do you hit the mob with (on help) to get something from it?
	var/obj/harvest_tool
	// How long do we have to wait until it's harvestable again?
	var/harvest_cooldown = 10 MINUTES
	// How long does it take to harvest?
	var/harvest_delay = 30 SECONDS
	// What world.time was the last harvest?
	var/harvest_recent = 0
	// How many times can we roll at max on the chance table?
	var/harvest_per_hit = 1
	// Verb for harvesting. "sheared" "clipped" etc.
	var/harvest_verb = "harvested"
	// Associative list of paths and their chances. path = straws in the lot
	var/list/harvest_results

/mob/living/simple_mob/examine(mob/user)
	. = ..()
<<<<<<< HEAD
	if(stat != DEAD && user && harvest_tool && (get_dist(user, src) <= 3))
		. += "<span class='notice'>\The [src] can be [harvest_verb] with a [initial(harvest_tool.name)] every [round(harvest_cooldown, 0.1)] minutes.</span>"
		var/time_to_harvest = (harvest_recent + harvest_cooldown) - world.time
		if(time_to_harvest > 0)
			. += "<span class='notice'>It can be [harvest_verb] in [time_to_harvest / (1 MINUTE)] second(s).</span>"
		else
			. += "<span class='notice'>It can be [harvest_verb] now.</span>"
=======
	if(user && (isobserver(user) || get_dist(user, src) <= 3))

		var/datum/gender/G = gender_datums[get_visible_gender()]
		if(stat == DEAD)
			. += "<b><span class='cult'>[G.He] [G.is] dead.</span></b>"
			return

		if(harvest_tool)
			. += SPAN_NOTICE("\The [src] can be [harvest_verb] with a [initial(harvest_tool.name)] every [round(harvest_cooldown, 0.1)] minutes.")
			var/time_to_harvest = (harvest_recent + harvest_cooldown) - world.time
			if(time_to_harvest > 0)
				. += SPAN_NOTICE("It can be [harvest_verb] in [time_to_harvest / (1 MINUTE)] second(s).")
			else
				. += SPAN_NOTICE("It can be [harvest_verb] now.")

		var/damage_strings = list()
		var/percent_brute = getBruteLoss() / getMaxHealth()
		if(percent_brute > 0.6)
			damage_strings += SPAN_DANGER("maimed bloody")
		else if(percent_brute > 0.3)
			damage_strings += SPAN_WARNING("cut and bruised")
		else if(percent_brute > 0)
			damage_strings += "lightly bruised"

		var/percent_burn =  getFireLoss() / getMaxHealth()
		if(percent_burn > 0.6)
			damage_strings += SPAN_DANGER("severely burned")
		else if(percent_burn > 0.3)
			damage_strings += SPAN_WARNING("covered in burns")
		else if(percent_burn > 0)
			damage_strings += "mildly burned"

		if(!length(damage_strings))
			var/percent_health = health / getMaxHealth()
			if(percent_health >= 1)
				damage_strings += SPAN_NOTICE("uninjured")
			else if(percent_health >= 0.7)
				damage_strings += "mildly injured"
			else if(percent_health >= 0.4)
				damage_strings += SPAN_WARNING("moderately injured")
			else
				damage_strings += SPAN_DANGER("badly injured")

		. += "[G.He] [G.is] [english_list(damage_strings)]."
>>>>>>> 7c2e983f42d... Merge pull request #8681 from MistakeNot4892/doggo

/mob/living/simple_mob/proc/livestock_harvest(var/obj/item/tool, var/mob/living/user)
	if(!LAZYLEN(harvest_results))	// Might be a unique interaction of an object using the proc to do something weird, or just someone's a donk.
		harvest_recent = world.time
		return

	if(istype(tool, harvest_tool))	// Sanity incase something incorrect is passed in.
		harvest_recent = world.time

		var/max_harvests = rand(1,harvest_per_hit)

		for(var/I = 1 to max_harvests)
			var/new_path = pickweight(harvest_results)
			new new_path(get_turf(user))

	return
