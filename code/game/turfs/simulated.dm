/turf/simulated
	name = "station"

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


/turf/simulated/proc/AddTracks(typepath,bloodDNA,comingdir,goingdir,bloodcolor="#A10808")
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
	var/dirtslip = FALSE
	if (isliving(A))
		var/mob/living/M = A
		if(M.lying || M.flying || M.is_incorporeal() || !(M.flags & ATOM_INITIALIZED)) // Also ignore newly spawning mobs
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
					if(S.track_blood)
						bloodDNA = S.forensic_data?.get_blooddna()
						bloodcolor = S.blood_color
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
			if(dirtslip && (dirt > 50 || is_outdoors() == OUTDOORS_YES))
				H.slip(8, src, NO_SLIP_WHEN_WALKING | SLIDE, 1) //Call slip directly, since it'd be wasteful to make a component for every dirt in existance, and then only use it situationally for a specific trait.
	..()

//returns 1 if made bloody, returns 0 otherwise
/turf/simulated/add_blood(mob/living/carbon/human/M as mob)
	if (!..())
		return FALSE

	if(istype(M))
		for(var/obj/effect/decal/cleanable/blood/B in contents)
			var/fresh = B.init_forensic_data().add_blooddna(M.dna,M)
			if(fresh && M.IsInfected())
				B.viruses = M.GetViruses()
			return TRUE //we bloodied the floor
		blood_splatter(src,M.get_blood(M.vessel),1)
		return TRUE //we bloodied the floor
	return FALSE

// Only adds blood on the floor -- Skie
/turf/simulated/proc/add_blood_floor(mob/living/carbon/M as mob)
	if( istype(M, /mob/living/carbon/alien ))
		var/obj/effect/decal/cleanable/blood/xeno/this = new /obj/effect/decal/cleanable/blood/xeno(src)
		this.init_forensic_data().add_blooddna(M.dna,M)
	else if( istype(M, /mob/living/silicon/robot ))
		new /obj/effect/decal/cleanable/blood/oil(src)
	else if(ishuman(M))
		add_blood(M)
