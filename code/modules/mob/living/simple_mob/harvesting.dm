
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
	if(stat != DEAD && user && harvest_tool && (get_dist(user, src) <= 3))
		. += span_notice("\The [src] can be [harvest_verb] with a [initial(harvest_tool.name)] every [round(harvest_cooldown, 0.1)] minutes.")
		var/time_to_harvest = (harvest_recent + harvest_cooldown) - world.time
		if(time_to_harvest > 0)
			. += span_notice("It can be [harvest_verb] in [time_to_harvest / (1 MINUTE)] second(s).")
		else
			. += span_notice("It can be [harvest_verb] now.")

	. += attempt_vr(src,"examine_reagent_bellies",args)

	. += attempt_vr(src,"examine_bellies",args)
	. += ""

	if(print_flavor_text()) . += "<br>[print_flavor_text()]"

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
