/proc/gibs(atom/location, var/datum/dna/MobDNA, gibber_type = /obj/effect/spawner/gibs/generic, var/fleshcolor, var/bloodcolor)
	new gibber_type(location,MobDNA,fleshcolor,bloodcolor)

/obj/effect/spawner/gibs
	var/sparks = 0 //whether sparks spread on Gib()
	var/list/gibtypes = list()
	var/list/gibamounts = list()
	var/list/gibdirections = list() //of lists
	var/fleshcolor //Used for gibbed humans.
	var/bloodcolor //Used for gibbed humans.

/obj/effect/spawner/gibs/New(location, var/datum/dna/MobDNA, var/fleshcolor, var/bloodcolor)
	..()

	if(fleshcolor) src.fleshcolor = fleshcolor
	if(bloodcolor) src.bloodcolor = bloodcolor

	if(gibtypes.len != gibamounts.len || gibamounts.len != gibdirections.len)
		to_world("<span class='warning'>Gib list length mismatch!</span>")
		return

	var/obj/effect/decal/cleanable/blood/gibs/gib = null

	if(sparks)
		var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread()
		s.set_up(2, 1, get_turf(loc)) // Not sure if it's safe to pass an arbitrary object to set_up, todo
		s.start()

	for(var/i = 1, i<= gibtypes.len, i++)
		if(gibamounts[i])
			for(var/j = 1, j<= gibamounts[i], j++)
				var/gibType = gibtypes[i]
				gib = new gibType(loc)

				// Apply human species colouration to masks.
				if(fleshcolor)
					gib.fleshcolor = fleshcolor
				if(bloodcolor)
					gib.basecolor = bloodcolor

				gib.update_icon()

				gib.blood_DNA = list()
				if(MobDNA)
					gib.blood_DNA[MobDNA.unique_enzymes] = MobDNA.b_type
				else if(istype(src, /obj/effect/spawner/gibs/human)) // Probably a monkey
					gib.blood_DNA["Non-human DNA"] = "A+"
				if(isturf(loc))
					var/list/directions = gibdirections[i]
					if(directions.len)
						gib.streak(directions)

	return INITIALIZE_HINT_QDEL

/obj/effect/spawner/gibs/generic
	gibtypes = list(/obj/effect/decal/cleanable/blood/gibs,/obj/effect/decal/cleanable/blood/gibs,/obj/effect/decal/cleanable/blood/gibs/core)
	gibamounts = list(2,2,1)

/obj/effect/spawner/gibs/generic/New()
	gibdirections = list(list(WEST, NORTHWEST, SOUTHWEST, NORTH),list(EAST, NORTHEAST, SOUTHEAST, SOUTH), list())
	..()

/obj/effect/spawner/gibs/human
	gibtypes = list(/obj/effect/decal/cleanable/blood/gibs,/obj/effect/decal/cleanable/blood/gibs/down,/obj/effect/decal/cleanable/blood/gibs,/obj/effect/decal/cleanable/blood/gibs,/obj/effect/decal/cleanable/blood/gibs,/obj/effect/decal/cleanable/blood/gibs,/obj/effect/decal/cleanable/blood/gibs/core)
	gibamounts = list(1,1,1,1,1,1,1)

/obj/effect/spawner/gibs/human/New()
	gibdirections = list(list(NORTH, NORTHEAST, NORTHWEST),list(SOUTH, SOUTHEAST, SOUTHWEST),list(WEST, NORTHWEST, SOUTHWEST),list(EAST, NORTHEAST, SOUTHEAST), alldirs, alldirs, list())
	gibamounts[6] = pick(0,1,2)
	..()

/obj/effect/spawner/gibs/robot
	sparks = 1
	gibtypes = list(/obj/effect/decal/cleanable/blood/gibs/robot/up,/obj/effect/decal/cleanable/blood/gibs/robot/down,/obj/effect/decal/cleanable/blood/gibs/robot,/obj/effect/decal/cleanable/blood/gibs/robot,/obj/effect/decal/cleanable/blood/gibs/robot,/obj/effect/decal/cleanable/blood/gibs/robot/limb)
	gibamounts = list(1,1,1,1,1,1)

/obj/effect/spawner/gibs/robot/New()
	gibdirections = list(list(NORTH, NORTHEAST, NORTHWEST),list(SOUTH, SOUTHEAST, SOUTHWEST),list(WEST, NORTHWEST, SOUTHWEST),list(EAST, NORTHEAST, SOUTHEAST), alldirs, alldirs)
	gibamounts[6] = pick(0,1,2)
	..()