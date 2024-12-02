//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/proc/dopage(src,target)
	var/href_list
	var/href
	href_list = params2list("src=\ref[src]&[target]=1")
	href = "src=\ref[src];[target]=1"
	src:temphtml = null
	src:Topic(href, href_list)
	return null

/proc/is_on_same_plane_or_station(var/z1, var/z2)
	if(z1 == z2)
		return 1
	if((z1 in using_map.station_levels) &&	(z2 in using_map.station_levels))
		return 1
	return 0

/proc/max_default_z_level()
	var/max_z = 0
	for(var/z in using_map.station_levels)
		max_z = max(z, max_z)
	for(var/z in using_map.admin_levels)
		max_z = max(z, max_z)
	for(var/z in using_map.player_levels)
		max_z = max(z, max_z)
	return max_z

/proc/get_area(atom/A)
	RETURN_TYPE(/area)
	if(isarea(A))
		return A
	var/turf/T = get_turf(A)
	return T ? T.loc : null

/proc/get_area_name(atom/X, format_text = FALSE)
	var/area/A = isarea(X) ? X : get_area(X)
	if(!A)
		return null
	return format_text ? format_text(A.name) : A.name

/** Checks if any living humans are in a given area. */
/proc/area_is_occupied(var/area/myarea)
	// Testing suggests looping over human_mob_list is quicker than looping over area contents
	for(var/mob/living/carbon/human/H in human_mob_list)
		if(H.stat >= DEAD) //Conditions for exclusion here, like if disconnected people start blocking it.
			continue
		var/area/A = get_area(H)
		if(A == myarea) //The loc of a turf is the area it is in.
			return 1
	return 0

/proc/in_range(source, user)
	if(get_dist(source, user) <= 1)
		return 1

	return 0 //not in range and not telekinetic

// Like view but bypasses luminosity check

/proc/hear(var/range, var/atom/source)

	var/lum = source.luminosity
	source.luminosity = 6

	var/list/heard = view(range, source)
	source.luminosity = lum

	return heard

/proc/isStationLevel(var/level)
	return level in using_map.station_levels

/proc/isNotStationLevel(var/level)
	return !isStationLevel(level)

/proc/isPlayerLevel(var/level)
	return level in using_map.player_levels

/proc/isAdminLevel(var/level)
	return level in using_map.admin_levels

/proc/isNotAdminLevel(var/level)
	return !isAdminLevel(level)

/proc/circlerange(center=usr,radius=3)

	var/turf/centerturf = get_turf(center)
	var/list/turfs = new/list()
	var/rsq = radius * (radius+0.5)

	for(var/atom/T in range(radius, centerturf))
		var/dx = T.x - centerturf.x
		var/dy = T.y - centerturf.y
		if(dx*dx + dy*dy <= rsq)
			turfs += T

	//turfs += centerturf
	return turfs

/proc/circleview(center=usr,radius=3)

	var/turf/centerturf = get_turf(center)
	var/list/atoms = new/list()
	var/rsq = radius * (radius+0.5)

	for(var/atom/A in view(radius, centerturf))
		var/dx = A.x - centerturf.x
		var/dy = A.y - centerturf.y
		if(dx*dx + dy*dy <= rsq)
			atoms += A

	//turfs += centerturf
	return atoms

/proc/trange(rad = 0, turf/centre = null) //alternative to range (ONLY processes turfs and thus less intensive)
	if(!centre)
		return

	var/turf/x1y1 = locate(((centre.x-rad)<1 ? 1 : centre.x-rad),((centre.y-rad)<1 ? 1 : centre.y-rad),centre.z)
	var/turf/x2y2 = locate(((centre.x+rad)>world.maxx ? world.maxx : centre.x+rad),((centre.y+rad)>world.maxy ? world.maxy : centre.y+rad),centre.z)
	return block(x1y1,x2y2)

/proc/get_dist_euclidian(atom/Loc1 as turf|mob|obj,atom/Loc2 as turf|mob|obj)
	var/dx = Loc1.x - Loc2.x
	var/dy = Loc1.y - Loc2.y

	var/dist = sqrt(dx**2 + dy**2)

	return dist

/proc/circlerangeturfs(center=usr,radius=3)

	var/turf/centerturf = get_turf(center)
	var/list/turfs = new/list()
	var/rsq = radius * (radius+0.5)

	for(var/turf/T in range(radius, centerturf))
		var/dx = T.x - centerturf.x
		var/dy = T.y - centerturf.y
		if(dx*dx + dy*dy <= rsq)
			turfs += T
	return turfs

/proc/circleviewturfs(center=usr,radius=3)		//Is there even a diffrence between this proc and circlerangeturfs()?

	var/turf/centerturf = get_turf(center)
	var/list/turfs = new/list()
	var/rsq = radius * (radius+0.5)

	for(var/turf/T in view(radius, centerturf))
		var/dx = T.x - centerturf.x
		var/dy = T.y - centerturf.y
		if(dx*dx + dy*dy <= rsq)
			turfs += T
	return turfs



//var/debug_mob = 0

// Will recursively loop through an atom's contents and check for mobs, then it will loop through every atom in that atom's contents.
// It will keep doing this until it checks every content possible. This will fix any problems with mobs, that are inside objects,
// being unable to hear people due to being in a box within a bag.

/proc/recursive_content_check(var/atom/O,  var/list/L = list(), var/recursion_limit = 3, var/client_check = 1, var/sight_check = 1, var/include_mobs = 1, var/include_objects = 1, var/ignore_show_messages = 0)

	if(!recursion_limit)
		return L

	for(var/I in O.contents)

		if(ismob(I))
			if(!sight_check || isInSight(I, O))
				L |= recursive_content_check(I, L, recursion_limit - 1, client_check, sight_check, include_mobs, include_objects, ignore_show_messages)
				if(include_mobs)
					if(client_check)
						var/mob/M = I
						if(M.client)
							L |= M
					else
						L |= I

		else if(istype(I,/obj/))
			var/obj/check_obj = I
			if(ignore_show_messages || check_obj.show_messages)
				if(!sight_check || isInSight(I, O))
					L |= recursive_content_check(I, L, recursion_limit - 1, client_check, sight_check, include_mobs, include_objects, ignore_show_messages)
					if(include_objects)
						L |= I

	return L

// Returns a list of mobs and/or objects in range of R from source. Used in radio and say code.

/proc/get_mobs_or_objects_in_view(var/R, var/atom/source, var/include_mobs = 1, var/include_objects = 1)

	var/turf/T = get_turf(source)
	var/list/hear = list()

	if(!T)
		return hear

	var/list/range = hear(R, T)

	for(var/I in range)
		if(ismob(I))
			hear |= recursive_content_check(I, hear, 3, 1, 0, include_mobs, include_objects)
			if(include_mobs)
				var/mob/M = I
				if(M.client)
					hear += M
		else if(istype(I,/obj/))
			hear |= recursive_content_check(I, hear, 3, 1, 0, include_mobs, include_objects)
			var/obj/O = I
			if(O.show_messages && include_objects)
				hear += I

	return hear


/proc/get_mobs_in_radio_ranges(var/list/obj/item/radio/radios)

	set background = 1

	. = list()
	// Returns a list of mobs who can hear any of the radios given in @radios
	var/list/speaker_coverage = list()
	for(var/obj/item/radio/R as anything in radios)
		var/turf/speaker = get_turf(R)
		if(speaker)
			for(var/turf/T in hear(R.canhear_range,speaker))
				speaker_coverage[T] = R


	// Try to find all the players who can hear the message
	for(var/i = 1; i <= player_list.len; i++)
		var/mob/M = player_list[i]
		if(M.can_hear_radio(speaker_coverage))
			. += M
	return .

/mob/proc/can_hear_radio(var/list/hearturfs)
	return FALSE

/mob/living/can_hear_radio(var/list/hearturfs)
	return get_turf(src) in hearturfs

/mob/living/silicon/robot/can_hear_radio(var/list/hearturfs)
	var/turf/T = get_turf(src)
	var/obj/item/radio/borg/R = hearturfs[T] // this should be an assoc list of turf-to-radio

	// We heard it on our own radio? We use power for that.
	if(istype(R) && R.myborg == src)
		var/datum/robot_component/CO = get_component("radio")
		if(!CO || !is_component_functioning("radio") || !cell_use_power(CO.active_usage))
			return FALSE // Sorry, couldn't hear

	return R // radio, true, false, what's the difference

/mob/observer/dead/can_hear_radio(var/list/hearturfs)
	return client?.prefs?.read_preference(/datum/preference/toggle/ghost_radio)


//Uses dview to quickly return mobs and objects in view,
// then adds additional mobs or objects if they are in range 'smartly',
// based on their presence in lists of players or registered objects
// Type: 1-audio, 2-visual, 0-neither
/proc/get_mobs_and_objs_in_view_fast(var/turf/T, var/range, var/type = 1, var/remote_ghosts = TRUE)
	var/list/mobs = list()
	var/list/objs = list()

	var/list/hear = dview(range,T,INVISIBILITY_MAXIMUM)
	var/list/hearturfs = list()

	// Openspace visibility handling
	// Below turfs we can see
	for(var/turf/simulated/open/O in hear)
		var/turf/U = GetBelow(O)
		while(istype(U))
			hearturfs |= U
			if(isopenspace(U))
				U = GetBelow(U)
			else
				U = null

	// Above us
	var/above_range = range
	var/turf/Ab = GetAbove(T)
	while(isopenspace(Ab) && --above_range > 0)
		hear |= dview(above_range,Ab,INVISIBILITY_MAXIMUM)
		Ab = GetAbove(Ab)

	for(var/thing in hear)
		if(istype(thing, /obj)) //Can't use isobj() because /atom/movable returns true in that
			objs += thing
			hearturfs |= get_turf(thing)
		if(ismob(thing))
			mobs += thing
			hearturfs |= get_turf(thing)

	//A list of every mob with a client
	for(var/mob in player_list)
		if(!ismob(mob))
			player_list -= mob
			continue
		//VOREStation Edit End - Trying to fix some vorestation bug.
		if(get_turf(mob) in hearturfs)
			mobs |= mob
			continue

		var/mob/M = mob
		if(M && M.stat == DEAD && remote_ghosts && !M.forbid_seeing_deadchat)
			switch(type)
				if(1) //Audio messages use ghost_ears
					if(M.client?.prefs?.read_preference(/datum/preference/toggle/ghost_ears))
						mobs |= M
				if(2) //Visual messages use ghost_sight
					if(M.client?.prefs?.read_preference(/datum/preference/toggle/ghost_sight))
						mobs |= M

	//For objects below the top level who still want to hear
	for(var/obj in listening_objects)
		if(get_turf(obj) in hearturfs)
			objs |= obj

	return list("mobs" = mobs, "objs" = objs)

/proc/inLineOfSight(X1,Y1,X2,Y2,Z=1,PX1=16.5,PY1=16.5,PX2=16.5,PY2=16.5)
	var/turf/T
	if(X1==X2)
		if(Y1==Y2)
			return 1 //Light cannot be blocked on same tile
		else
			var/s = SIGN(Y2-Y1)
			Y1+=s
			while(Y1!=Y2)
				T=locate(X1,Y1,Z)
				if(T.opacity)
					return 0
				Y1+=s
	else
		var/m=(32*(Y2-Y1)+(PY2-PY1))/(32*(X2-X1)+(PX2-PX1))
		var/b=(Y1+PY1/32-0.015625)-m*(X1+PX1/32-0.015625) //In tiles
		var/signX = SIGN(X2-X1)
		var/signY = SIGN(Y2-Y1)
		if(X1<X2)
			b+=m
		while(X1!=X2 || Y1!=Y2)
			if(round(m*X1+b-Y1))
				Y1+=signY //Line exits tile vertically
			else
				X1+=signX //Line exits tile horizontally
			T=locate(X1,Y1,Z)
			if(T.opacity)
				return 0
	return 1

/proc/flick_overlay(image/I, list/show_to, duration, gc_after)
	for(var/client/C in show_to)
		C.images += I
	spawn(duration)
		if(gc_after)
			qdel(I)
		for(var/client/C in show_to)
			C.images -= I

/proc/flick_overlay_view(image/I, atom/target, duration, gc_after) //wrapper for the above, flicks to everyone who can see the target atom
	var/list/viewing = list()
	for(var/mob/M as anything in viewers(target))
		if(M.client)
			viewing += M.client
	flick_overlay(I, viewing, duration, gc_after)

/proc/isInSight(var/atom/A, var/atom/B)
	var/turf/Aturf = get_turf(A)
	var/turf/Bturf = get_turf(B)

	if(!Aturf || !Bturf)
		return 0

	if(inLineOfSight(Aturf.x,Aturf.y, Bturf.x,Bturf.y,Aturf.z))
		return 1

	else
		return 0

/proc/get_cardinal_step_away(atom/start, atom/finish) //returns the position of a step from start away from finish, in one of the cardinal directions
	//returns only NORTH, SOUTH, EAST, or WEST
	var/dx = finish.x - start.x
	var/dy = finish.y - start.y
	if(abs(dy) > abs (dx)) //slope is above 1:1 (move horizontally in a tie)
		if(dy > 0)
			return get_step(start, SOUTH)
		else
			return get_step(start, NORTH)
	else
		if(dx > 0)
			return get_step(start, WEST)
		else
			return get_step(start, EAST)

/proc/get_mob_by_key(var/key)
	for(var/mob/M in mob_list)
		if(M.ckey == lowertext(key))
			return M
	return null


// Will return a list of active candidates. It increases the buffer 5 times until it finds a candidate which is active within the buffer.
/proc/get_active_candidates(var/buffer = 1)

	var/list/candidates = list() //List of candidate KEYS to assume control of the new larva ~Carn
	var/i = 0
	while(candidates.len <= 0 && i < 5)
		for(var/mob/observer/dead/G in player_list)
			if(((G.client.inactivity/10)/60) <= buffer + i) // the most active players are more likely to become an alien
				if(!(G.mind && G.mind.current && G.mind.current.stat != DEAD))
					candidates += G.key
		i++
	return candidates

// Same as above but for alien candidates.

/proc/get_alien_candidates()

	var/list/candidates = list() //List of candidate KEYS to assume control of the new larva ~Carn
	var/i = 0
	while(candidates.len <= 0 && i < 5)
		for(var/mob/observer/dead/G in player_list)
			if(G.client.prefs.be_special & BE_ALIEN)
				if(((G.client.inactivity/10)/60) <= ALIEN_SELECT_AFK_BUFFER + i) // the most active players are more likely to become an alien
					if(!(G.mind && G.mind.current && G.mind.current.stat != DEAD))
						candidates += G.key
		i++
	return candidates

/proc/ScreenText(obj/O, maptext="", screen_loc="CENTER-7,CENTER-7", maptext_height=480, maptext_width=480)
	if(!isobj(O))	O = new /obj/screen/text()
	O.maptext = maptext
	O.maptext_height = maptext_height
	O.maptext_width = maptext_width
	O.screen_loc = screen_loc
	return O

/proc/Show2Group4Delay(obj/O, list/group, delay=0)
	if(!isobj(O))	return
	if(!group)	group = GLOB.clients
	for(var/client/C in group)
		C.screen += O
	if(delay)
		spawn(delay)
			for(var/client/C in group)
				C.screen -= O

/datum/projectile_data
	var/src_x
	var/src_y
	var/time
	var/distance
	var/power_x
	var/power_y
	var/dest_x
	var/dest_y

/datum/projectile_data/New(var/src_x, var/src_y, var/time, var/distance, \
						   var/power_x, var/power_y, var/dest_x, var/dest_y)
	src.src_x = src_x
	src.src_y = src_y
	src.time = time
	src.distance = distance
	src.power_x = power_x
	src.power_y = power_y
	src.dest_x = dest_x
	src.dest_y = dest_y

/proc/projectile_trajectory(var/src_x, var/src_y, var/rotation, var/angle, var/power)

	// returns the destination (Vx,y) that a projectile shot at [src_x], [src_y], with an angle of [angle],
	// rotated at [rotation] and with the power of [power]
	// Thanks to VistaPOWA for this function

	var/power_x = power * cos(angle)
	var/power_y = power * sin(angle)
	var/time = 2* power_y / 10 //10 = g

	var/distance = time * power_x

	var/dest_x = src_x + distance*sin(rotation);
	var/dest_y = src_y + distance*cos(rotation);

	return new /datum/projectile_data(src_x, src_y, time, distance, power_x, power_y, dest_x, dest_y)

/proc/GetRedPart(const/hexa)
	return hex2num(copytext(hexa,2,4))

/proc/GetGreenPart(const/hexa)
	return hex2num(copytext(hexa,4,6))

/proc/GetBluePart(const/hexa)
	return hex2num(copytext(hexa,6,8))

/proc/GetHexColors(const/hexa)
	return list(
			GetRedPart(hexa),
			GetGreenPart(hexa),
			GetBluePart(hexa)
		)

/proc/MixColors(const/list/colors)
	var/list/reds = list()
	var/list/blues = list()
	var/list/greens = list()
	var/list/weights = list()

	for (var/i = 0, ++i <= colors.len)
		reds.Add(GetRedPart(colors[i]))
		blues.Add(GetBluePart(colors[i]))
		greens.Add(GetGreenPart(colors[i]))
		weights.Add(1)

	var/r = mixOneColor(weights, reds)
	var/g = mixOneColor(weights, greens)
	var/b = mixOneColor(weights, blues)
	return rgb(r,g,b)

/proc/mixOneColor(var/list/weight, var/list/color)
	if (!weight || !color || length(weight)!=length(color))
		return 0

	var/contents = length(weight)
	var/i

	//normalize weights
	var/listsum = 0
	for(i=1; i<=contents; i++)
		listsum += weight[i]
	for(i=1; i<=contents; i++)
		weight[i] /= listsum

	//mix them
	var/mixedcolor = 0
	for(i=1; i<=contents; i++)
		mixedcolor += weight[i]*color[i]
	mixedcolor = round(mixedcolor)

	//until someone writes a formal proof for this algorithm, let's keep this in
//	if(mixedcolor<0x00 || mixedcolor>0xFF)
//		return 0
	//that's not the kind of operation we are running here, nerd
	mixedcolor=min(max(mixedcolor,0),255)

	return mixedcolor

/**
* Gets the highest and lowest pressures from the tiles in cardinal directions
* around us, then checks the difference.
*/
/proc/getOPressureDifferential(var/turf/loc)
	var/minp=16777216;
	var/maxp=0;
	for(var/dir in GLOB.cardinal)
		var/turf/simulated/T=get_turf(get_step(loc,dir))
		var/cp=0
		if(T && istype(T) && T.zone)
			var/datum/gas_mixture/environment = T.return_air()
			cp = environment.return_pressure()
		else
			if(istype(T,/turf/simulated))
				continue
		if(cp<minp)minp=cp
		if(cp>maxp)maxp=cp
	return abs(minp-maxp)

/proc/convert_k2c(var/temp)
	return ((temp - T0C))

/proc/convert_c2k(var/temp)
	return ((temp + T0C))

/proc/getCardinalAirInfo(var/turf/loc, var/list/stats=list("temperature"))
	var/list/temps = new/list(4)
	for(var/dir in GLOB.cardinal)
		var/direction
		switch(dir)
			if(NORTH)
				direction = 1
			if(SOUTH)
				direction = 2
			if(EAST)
				direction = 3
			if(WEST)
				direction = 4
		var/turf/simulated/T=get_turf(get_step(loc,dir))
		var/list/rstats = new /list(stats.len)
		if(T && istype(T) && T.zone)
			var/datum/gas_mixture/environment = T.return_air()
			for(var/i=1;i<=stats.len;i++)
				if(stats[i] == "pressure")
					rstats[i] = environment.return_pressure()
				else
					rstats[i] = environment.vars[stats[i]]
		else if(istype(T, /turf/simulated))
			rstats = null // Exclude zone (wall, door, etc).
		else if(istype(T, /turf))
			// Should still work.  (/turf/return_air())
			var/datum/gas_mixture/environment = T.return_air()
			for(var/i=1;i<=stats.len;i++)
				if(stats[i] == "pressure")
					rstats[i] = environment.return_pressure()
				else
					rstats[i] = environment.vars[stats[i]]
		temps[direction] = rstats
	return temps

/proc/MinutesToTicks(var/minutes)
	return SecondsToTicks(60 * minutes)

/proc/SecondsToTicks(var/seconds)
	return seconds * 10

/proc/window_flash(var/client_or_usr)
	if (!client_or_usr)
		return
	winset(client_or_usr, "mainwindow", "flash=5")

/**
 * Get a bounding box of a list of atoms.
 *
 * Arguments:
 * - atoms - List of atoms. Can accept output of view() and range() procs.
 *
 * Returns: list(x1, y1, x2, y2)
 */
/proc/get_bbox_of_atoms(list/atoms)
	var/list/list_x = list()
	var/list/list_y = list()
	for(var/_a in atoms)
		var/atom/a = _a
		list_x += a.x
		list_y += a.y
	return list(
		min(list_x),
		min(list_y),
		max(list_x),
		max(list_y))

// Will recursively loop through an atom's contents and check for mobs, then it will loop through every atom in that atom's contents.
// It will keep doing this until it checks every content possible. This will fix any problems with mobs, that are inside objects,
// being unable to hear people due to being in a box within a bag.

/proc/recursive_mob_check(var/atom/O,  var/list/L = list(), var/recursion_limit = 3, var/client_check = 1, var/sight_check = 1, var/include_radio = 1)

	//GLOB.debug_mob += O.contents.len
	if(!recursion_limit)
		return L
	for(var/atom/A in O.contents)

		if(ismob(A))
			var/mob/M = A
			if(client_check && !M.client)
				L |= recursive_mob_check(A, L, recursion_limit - 1, client_check, sight_check, include_radio)
				continue
			if(sight_check && !isInSight(A, O))
				continue
			L |= M
			//log_world("[recursion_limit] = [M] - [get_turf(M)] - ([M.x], [M.y], [M.z])")

		else if(include_radio && istype(A, /obj/item/radio))
			if(sight_check && !isInSight(A, O))
				continue
			L |= A

		if(isobj(A) || ismob(A))
			L |= recursive_mob_check(A, L, recursion_limit - 1, client_check, sight_check, include_radio)
	return L

// The old system would loop through lists for a total of 5000 per function call, in an empty server.
// This new system will loop at around 1000 in an empty server.

/proc/get_mobs_in_view(var/R, var/atom/source, var/include_clientless = FALSE)
	// Returns a list of mobs in range of R from source. Used in radio and say code.

	var/turf/T = get_turf(source)
	var/list/hear = list()

	if(!T)
		return hear

	var/list/range = hear(R, T)

	for(var/atom/A in range)
		if(ismob(A))
			var/mob/M = A
			if(M.client || include_clientless)
				hear += M
			//log_world("Start = [M] - [get_turf(M)] - ([M.x], [M.y], [M.z])")
		else if(istype(A, /obj/item/radio))
			hear += A

		if(isobj(A) || ismob(A))
			hear |= recursive_mob_check(A, hear, 3, 1, 0, 1)

	return hear

/proc/get_belly(var/atom/A)				// return a belly we're in, one way or another; and if we aren't (or are too deep to comprehend being in belly), returns null
	var/atom/loc_check = A.loc
	var/recursion_level = 0
	while(loc_check && !isbelly(loc_check) && !isturf(loc_check))
		if(recursion_level > 7)		// abstractly picked number, but basically means we tried going 8 levels up. Something is wrong if youre THAT deep anyway
			break
		loc_check = loc_check.loc
		recursion_level++
	if(isbelly(loc_check))
		return loc_check
	return null

/proc/get_all_prey_recursive(var/mob/living/L, var/client_check = 1)			// returns all prey inside the target as well all prey of target's prey, as well as all prey inside target's prey, etc.
	var/list/result = list()

	if(!istype(L) || !(L.vore_organs) || !(L.vore_organs.len))
		return result

	for(var/obj/belly/B in L.vore_organs)
		for(var/mob/living/P in B.contents)
			if(istype(P))
				if(client_check && P.client)
					result |= P
				result |= get_all_prey_recursive(P, client_check)

	return result

/proc/random_color(saturated)	//Returns a random color. If saturated is true, it will avoid pure white or pure black
	var/r = rand(1,255)
	var/g = rand(1,255)
	var/b = rand(1,255)

	if(saturated)	//Let's make sure we don't get too close to pure black or pure white, as they won't look good with grayscale sprites
		if(r + g + b < 50)
			r = r + rand(5,20)
			g = g + rand(5,20)
			b = b + rand(5,20)
		else if (r + g + b > 700)
			r = r - rand(5,50)
			g = g - rand(5,50)
			b = b - rand(5,50)

	var/color = rgb(r, g, b)
	return color
