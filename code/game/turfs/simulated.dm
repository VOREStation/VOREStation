/turf/simulated
	name = "station"
	var/wet = 0
	var/image/wet_overlay = null

	//Mining resources (for the large drills).
	var/turf_resource_types
	var/list/resources

	var/thermite = 0
	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD
	var/to_be_destroyed = 0 //Used for fire, if a melting temperature was reached, it will be destroyed
	var/max_fire_temperature_sustained = 0 //The max temperature of the fire which it was subjected to
	var/can_dirty = TRUE	// If false, tile never gets dirty
	var/can_start_dirty = TRUE	// If false, cannot start dirty roundstart
	var/dirty_prob = 2	// Chance of being dirty roundstart
	var/dirt = 0
	var/special_temperature //Used for turf HE-Pipe interaction
	var/climbable = FALSE //Adds proc to wall if set to TRUE on its initialization, defined here since not all walls are subtypes of wall

	var/icon_edge = 'icons/turf/outdoors_edge.dmi'	//Allows for alternative edge icon files
	var/wet_cleanup_timer

// This is not great.
/turf/simulated/proc/wet_floor(var/wet_val = 1)
	if(wet > 2)	//Can't mop up ice
		return
	wet = wet_val
	if(wet_overlay)
		cut_overlay(wet_overlay)
	wet_overlay = image('icons/effects/water.dmi', icon_state = "wet_floor")
	add_overlay(wet_overlay)
	if(wet_cleanup_timer)
		deltimer(wet_cleanup_timer)
		wet_cleanup_timer = null
	if(wet == 2)
		wet_cleanup_timer = addtimer(CALLBACK(src, PROC_REF(wet_floor_finish)), 160 SECONDS, TIMER_STOPPABLE)
	else
		wet_cleanup_timer = addtimer(CALLBACK(src, PROC_REF(wet_floor_finish)), 40 SECONDS, TIMER_STOPPABLE)

/turf/simulated/proc/wet_floor_finish()
	wet = 0
	if(wet_cleanup_timer)
		deltimer(wet_cleanup_timer)
		wet_cleanup_timer = null
	if(wet_overlay)
		cut_overlay(wet_overlay)
		wet_overlay = null

/turf/simulated/proc/freeze_floor()
	if(!wet) // Water is required for it to freeze.
		return
	wet = 3 // icy
	if(wet_overlay)
		cut_overlay(wet_overlay)
		wet_overlay = null
	wet_overlay = image('icons/turf/overlays.dmi',src,"snowfloor")
	add_overlay(wet_overlay)
	spawn(5 MINUTES)
		wet = 0
		if(wet_overlay)
			cut_overlay(wet_overlay)
			wet_overlay = null

/turf/simulated/clean_blood()
	for(var/obj/effect/decal/cleanable/blood/B in contents)
		B.clean_blood()
	..()

/turf/simulated/Initialize(mapload)
	. = ..()
	if(istype(loc, /area/chapel))
		holy = 1
	levelupdate()
	if(climbable)
		verbs += /turf/simulated/proc/climb_wall
	if(is_outdoors())
		SSplanets.addTurf(src)

/turf/simulated/examine(mob/user)
	. = ..()
	if(climbable)
		. += "This [src] looks climbable."


/turf/simulated/proc/AddTracks(var/typepath,var/bloodDNA,var/comingdir,var/goingdir,var/bloodcolor="#A10808")
	var/obj/effect/decal/cleanable/blood/tracks/tracks = locate(typepath) in src
	if(!tracks)
		tracks = new typepath(src)
	tracks.AddTracks(bloodDNA,comingdir,goingdir,bloodcolor)

/turf/simulated/proc/update_dirt()
	if(can_dirty)
		dirt = min(dirt+1, 101)
		var/obj/effect/decal/cleanable/dirt/dirtoverlay = locate(/obj/effect/decal/cleanable/dirt, src)
		if (dirt > 50)
			if (!dirtoverlay)
				dirtoverlay = new/obj/effect/decal/cleanable/dirt(src)
			dirtoverlay.alpha = min((dirt - 50) * 5, 255)

/turf/simulated/Entered(atom/A, atom/OL)
	if (isliving(A))
		var/dirtslip = FALSE
		var/mob/living/M = A
		if(M.lying || M.flying || M.is_incorporeal())
			return ..()

		if(M.dirties_floor())
			// Dirt overlays.
			update_dirt()

		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			dirtslip = H.species.dirtslip
			if(H.species.mudking)
				dirt = min(dirt+2, 101)
				update_dirt()
			// Tracking blood
			var/list/bloodDNA = null
			var/bloodcolor=""
			if(H.shoes)
				var/obj/item/clothing/shoes/S = H.shoes
				if(istype(S))
					S.handle_movement(src,(H.m_intent == I_RUN ? 1 : 0), H) // handle_movement now needs to know who is moving, for inshoe steppies
					if(S.track_blood && S.blood_DNA)
						bloodDNA = S.blood_DNA
						bloodcolor=S.blood_color
						S.track_blood--
			else
				if(H.track_blood && H.feet_blood_DNA)
					bloodDNA = H.feet_blood_DNA
					bloodcolor = H.feet_blood_color
					H.track_blood--

			if (bloodDNA)
				src.AddTracks(H.species.get_move_trail(H),bloodDNA,H.dir,0,bloodcolor) // Coming
				var/turf/simulated/from = get_step(H,reverse_direction(H.dir))
				if(istype(from) && from)
					from.AddTracks(H.species.get_move_trail(H),bloodDNA,0,H.dir,bloodcolor) // Going

				bloodDNA = null

		if(src.wet || (dirtslip && (dirt > 50 || outdoors == 1)))
			if(M.buckled || (src.wet == 1 && M.m_intent == I_WALK))
				return

			var/slip_dist = 1
			var/slip_stun = 6
			var/floor_type = "wet"
			if(dirtslip)
				slip_stun = 10
				if(dirt > 50)
					floor_type = "dirty"
				else if(outdoors)
					floor_type = "uneven"
				if(src.wet == 0 && M.m_intent == I_WALK)
					return
			switch(src.wet)
				if(2) // Lube
					floor_type = "slippery"
					slip_dist = 4
					slip_stun = 10
				if(3) // Ice
					floor_type = "icy"
					slip_stun = 4
					slip_dist = rand(1,3)

			if(M.slip("the [floor_type] floor", slip_stun))
				addtimer(CALLBACK(src, PROC_REF(handle_slipping), M, slip_dist, dirtslip), 0)
			else
				M.inertia_dir = 0
		else
			M.inertia_dir = 0

	..()
/turf/simulated/proc/handle_slipping(var/mob/living/M, var/slip_dist, var/dirtslip)
	PRIVATE_PROC(TRUE)
	if(!M || !slip_dist)
		return
	if(isbelly(M.loc))	// Stop the slip if we're in a belly.
		return
	if(!step(M, M.dir) && !dirtslip)
		return // done sliding, failed to move
	// check tile for next slip
	if(!dirtslip)
		var/turf/simulated/ground = get_turf(M)
		if(!istype(ground,/turf/simulated))
			return // stop sliding as it is impossible to be on wet terrain?
		if(ground.wet != 2)
			return // done sliding, not lubed
	addtimer(CALLBACK(src, PROC_REF(handle_slipping), M, --slip_dist, dirtslip), 1)

//returns 1 if made bloody, returns 0 otherwise
/turf/simulated/add_blood(mob/living/carbon/human/M as mob)
	if (!..())
		return 0

	if(istype(M))
		for(var/obj/effect/decal/cleanable/blood/B in contents)
			if(!B.blood_DNA)
				B.blood_DNA = list()
			if(!B.blood_DNA[M.dna.unique_enzymes])
				B.blood_DNA[M.dna.unique_enzymes] = M.dna.b_type
				if(M.viruses)
					B.viruses = M.viruses.Copy()
			return 1 //we bloodied the floor
		blood_splatter(src,M.get_blood(M.vessel),1)
		return 1 //we bloodied the floor
	return 0

// Only adds blood on the floor -- Skie
/turf/simulated/proc/add_blood_floor(mob/living/carbon/M as mob)
	if( istype(M, /mob/living/carbon/alien ))
		var/obj/effect/decal/cleanable/blood/xeno/this = new /obj/effect/decal/cleanable/blood/xeno(src)
		this.blood_DNA["UNKNOWN BLOOD"] = "X*"
	else if( istype(M, /mob/living/silicon/robot ))
		new /obj/effect/decal/cleanable/blood/oil(src)
	else if(ishuman(M))
		add_blood(M)
