/turf/simulated/shuttle/wall/alien/blue
	name = "hybrid wall"
	desc = "Seems slightly more friendly than if the wall were ominous purple."
	icon = 'icons/turf/shuttle_alien_blue.dmi'
	light_color = "#1fdbf4" // Cyan-ish

/turf/simulated/shuttle/wall/alien/blue/hard_corner
	name = "hybrid wall"
	icon_state = "alien-hc"
	hard_corner = 1

/turf/simulated/shuttle/wall/alien/blue/no_join
	name = "hybrid wall"
	icon_state = "alien-nj"
	join_group = null

/turf/simulated/flesh
	name = "flesh wall"
	desc = "The fleshy surface of this wall squishes nicely under your touch but looks and feels extremly strong"
	icon = 'icons/turf/stomach_vr.dmi'
	icon_state = "flesh"
	opacity = 1
	density = TRUE
	blocks_air = 1

/turf/simulated/flesh/colour
	name = "flesh wall"
	desc = "The fleshy surface of this wall squishes nicely under your touch but looks and feels extremly strong"
	icon = 'icons/turf/stomach_vr.dmi'
	icon_state = "colorable-wall"
	opacity = 1
	density = TRUE
	blocks_air = 1

/turf/simulated/flesh/attackby()
	return

/turf/simulated/flesh/Initialize(mapload)
	. = ..()
	update_icon(1)

var/list/flesh_overlay_cache = list()

/turf/simulated/flesh/update_icon(var/update_neighbors)
	cut_overlays()

	if(density)
		icon = 'icons/turf/stomach_vr.dmi'
		icon_state = "flesh"
		for(var/direction in cardinal)
			var/turf/T = get_step(src,direction)
			if(istype(T) && !T.density)
				var/place_dir = turn(direction, 180)
				if(!flesh_overlay_cache["flesh_side_[place_dir]"])
					flesh_overlay_cache["flesh_side_[place_dir]"] = image('icons/turf/stomach_vr.dmi', "flesh_side", dir = place_dir)
				add_overlay(flesh_overlay_cache["flesh_side_[place_dir]"])

	if(update_neighbors)
		for(var/direction in alldirs)
			if(istype(get_step(src, direction), /turf/simulated/flesh))
				var/turf/simulated/flesh/F = get_step(src, direction)
				F.update_icon()

/turf/simulated/gore
	name = "wall of viscera"
	desc = "Its veins pulse in a sickeningly rapid fashion, while certain spots of the wall rise and fall gently, much like slow, deliberate breathing."
	icon = 'icons/goonstation/turf/meatland.dmi'
	icon_state = "bloodwall_2"
	opacity = 1
	density = TRUE
	blocks_air = 1

/turf/simulated/goreeyes
	name = "wall of viscera"
	desc = "Strangely observant eyes dot the wall. Getting too close has the eyes fixate on you, while their pupils shake violently. Each socket is connected by a series of winding, writhing veins."
	icon = 'icons/goonstation/turf/meatland.dmi'
	icon_state = "bloodwall_4"
	opacity = 1
	density = TRUE
	blocks_air = 1

/turf/simulated/shuttle/wall/flock
	icon = 'icons/goonstation/featherzone.dmi'
	icon_state = "flockwall0"
	base_state = "flockwall"
	hard_corner = 1 //They're all HC
	true_name = "wall"

/turf/simulated/shuttle/wall/flock/Initialize()
	. = ..()
	set_light(3,3,"#26c5a9")

/turf/simulated/wall/rplastitanium
	icon_state = "rwall-plastitanium"
	icon = 'icons/turf/wall_masks_vr.dmi'
/turf/simulated/wall/rplastitanium/Initialize(mapload)
	. = ..(mapload, MAT_PLASTITANIUM,MAT_PLASTITANIUM,MAT_PLASTITANIUM)

/turf/simulated/wall/plastitanium
	icon_state = "wall-plastitanium"
	icon = 'icons/turf/wall_masks_vr.dmi'
/turf/simulated/wall/plastitanium/Initialize(mapload)
	. = ..(mapload, MAT_PLASTITANIUM, null,MAT_PLASTITANIUM)

/turf/simulated/wall/rplastihull
	icon_state = "rhull-plastitanium"
	icon = 'icons/turf/wall_masks_vr.dmi'
/turf/simulated/wall/rplastihull/Initialize(mapload)
	. = ..(mapload, MAT_PLASTITANIUMHULL,MAT_PLASTITANIUMHULL,MAT_PLASTITANIUMHULL)

/turf/simulated/wall/plastihull
	icon_state = "hull-plastitanium"
	icon = 'icons/turf/wall_masks_vr.dmi'
/turf/simulated/wall/plastihull/Initialize(mapload)
	. = ..(mapload, MAT_PLASTITANIUMHULL, null,MAT_PLASTITANIUMHULL)

/turf/simulated/wall/ghull
	icon_state = "hull-titanium"
/turf/simulated/wall/ghull/Initialize(mapload)
	. = ..(mapload, MAT_GOLDHULL, MAT_DIAMOND, MAT_GOLDHULL)

/turf/simulated/wall/diamond
	icon_state = "diamond"
	icon = 'icons/turf/wall_masks_vr.dmi'

/turf/simulated/wall/dungeon
	icon_state = "dungeon"
	icon = 'icons/turf/wall_masks_vr.dmi'

/turf/simulated/wall/durasteel
	icon_state = "durasteel"
	icon = 'icons/turf/wall_masks_vr.dmi'

/turf/simulated/wall/elevator
	icon_state = "elevator"
	icon = 'icons/turf/wall_masks_vr.dmi'

/turf/simulated/wall/gold
	icon_state = "gold"
	icon = 'icons/turf/wall_masks_vr.dmi'

/turf/simulated/wall/golddiamond
	icon_state = "golddiamond"
	icon = 'icons/turf/wall_masks_vr.dmi'

/turf/simulated/wall/iron
	icon_state = "iron"
	icon = 'icons/turf/wall_masks_vr.dmi'

/turf/simulated/wall/ironphoron
	icon_state = "ironphoron"
	icon = 'icons/turf/wall_masks_vr.dmi'

/turf/simulated/wall/lead
	icon_state = "lead"
	icon = 'icons/turf/wall_masks_vr.dmi'

/turf/simulated/wall/log
	icon_state = "log"
	icon = 'icons/turf/wall_masks_vr.dmi'

/turf/simulated/wall/log_sif
	icon_state = "log_sif"
	icon = 'icons/turf/wall_masks_vr.dmi'

/turf/simulated/wall/phoron
	icon_state = "phoron"
	icon = 'icons/turf/wall_masks_vr.dmi'

/turf/simulated/wall/r_lead
	icon_state = "lead"
	icon = 'icons/turf/wall_masks_vr.dmi'

/turf/simulated/wall/resin
	icon_state = "resin"
	icon = 'icons/turf/wall_masks_vr.dmi'

/turf/simulated/wall/sandstone
	icon_state = "sandstone"
	icon = 'icons/turf/wall_masks_vr.dmi'

/turf/simulated/wall/sandstonediamond
	icon_state = "sandstonediamond"
	icon = 'icons/turf/wall_masks_vr.dmi'

/turf/simulated/wall/sifwood
	icon_state = "sifwood"
	icon = 'icons/turf/wall_masks_vr.dmi'

/turf/simulated/wall/silver
	icon_state = "silver"
	icon = 'icons/turf/wall_masks_vr.dmi'

/turf/simulated/wall/silvergold
	icon_state = "silvergold"
	icon = 'icons/turf/wall_masks_vr.dmi'

/turf/simulated/wall/skipjack
	icon_state = "skipjack"
	icon = 'icons/turf/wall_masks_vr.dmi'

/turf/simulated/wall/snowbrick
	icon_state = "snowbrick"
	icon = 'icons/turf/wall_masks_vr.dmi'

/turf/simulated/wall/solidrock
	icon_state = "solidrock"
	icon = 'icons/turf/wall_masks_vr.dmi'
	climbable = TRUE

/turf/simulated/wall/titanium
	icon_state = "titanium"
	icon = 'icons/turf/wall_masks_vr.dmi'

/turf/simulated/wall/uranium
	icon_state = "uranium"
	icon = 'icons/turf/wall_masks_vr.dmi'

/turf/simulated/wall/virgo2
	icon_state = "virgo2"
	icon = 'icons/turf/wall_masks_vr.dmi'

/turf/simulated/wall/wood
	icon_state = "wood"
	icon = 'icons/turf/wall_masks_vr.dmi'

/turf/simulated/wall/stonebricks
	icon_state = "stonebrick"
	icon = 'icons/turf/wall_masks_vr.dmi'

/turf/simulated/wall/stonebricks/Initialize(mapload)
		. = ..(mapload, "concrete")

/turf/simulated/wall/stonelogs
	icon_state = "stonelogs"
	icon = 'icons/turf/wall_masks_vr.dmi'

/turf/simulated/wall/stonelogs/Initialize(mapload)
			. = ..(mapload, "concrete",MAT_LOG)