
/obj/structure/geyser
	name = "geothermal vent"
	desc = "A geothermal vent."
	description_info = "A geothermal vent capable of being \"mined\" for a reagent via a Reagent Pump.\
	The reagent is often randomized, but can be guessed via the color of the reagent, or a reagent scanner."

	icon = 'icons/obj/machines/reagent.dmi'
	icon_state = "geyser"

	density = FALSE

	var/list/reagent_set	// The associative list of what reagents this geyser produces. [ID = Amount]

	var/max_reagent_picks = 3

	var/list/allowed_reagents	// The associated list of what reagents are allowed to be picked by RNG. [ID = [Min AMT, Max AMT]]

	var/display_reagents = TRUE
	var/reagent_overlay_state

	var/icon/reagent_overlay_icon

	var/datum/effect_system/smoke_spread/chem/Smoke

/obj/structure/geyser/Initialize()
	. = ..()

	create_reagents(100)
	Smoke = new(src)
	Smoke.show_log = FALSE

	if(display_reagents == TRUE)
		if(!reagent_overlay_state)
			reagent_overlay_state = "[icon_state]-reag"

		reagent_overlay_icon = new/icon(icon, reagent_overlay_state)

	var/list/from_reag = get_allowed_reagents()

	if(!LAZYLEN(reagent_set) && LAZYLEN(from_reag))
		LAZYINITLIST(reagent_set)
		var/reag_count = rand(1, max_reagent_picks)
		for(var/count = 1, count <= reag_count, count++)
			var/targ_reagent = pick(from_reag)

			if(targ_reagent in SSchemistry.chemical_reagents)
				var/reag_bounds = from_reag[targ_reagent]
				reagent_set[targ_reagent] = rand(reag_bounds[1],reag_bounds[2])

	if(LAZYLEN(reagent_set))
		START_PROCESSING(SSobj, src)

/obj/structure/geyser/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/structure/geyser/update_icon()
	cut_overlays()
	if(reagent_overlay_icon && reagents.total_volume)
		var/list/hextorgb = hex2rgb(reagents.get_color())
		reagent_overlay_icon.GrayScale()

		reagent_overlay_icon.Blend(rgb(hextorgb[1],hextorgb[2],hextorgb[3]),ICON_MULTIPLY)

		add_overlay(reagent_overlay_icon)

/obj/structure/geyser/process()
	var/obj/machinery/pump/Pump = locate() in get_turf(src)

	for(var/reag_id in reagent_set)
		reagents.add_reagent(reag_id, reagent_set[reag_id])

	if(Pump && Pump.anchored)
		return

	if(reagents.total_volume > 20 && prob(round(reagents.total_volume / 10)))
		Smoke.set_up(reagents, rand(3,10), 0, get_turf(src))
		Smoke.start()

	update_icon()

/obj/structure/geyser/proc/get_allowed_reagents()
	return allowed_reagents

/obj/structure/geyser/planetary
	desc = "A rocky outcropping."

	allowed_reagents = list(
		"carbon" = list(1,10),
		"gold" = list(1,3),
		"silver" = list(1,5),
		"hydrogen" = list(3,10),
		"nitrogen" = list(10,30),
		"oxygen" = list(5,15),
		"sacid" = list(1,5),
		"sulfur" = list(2,10),
		"phoron" = list(1,1),
		"fuel" = list(10,30),
		"mineralizedfluid" = list(1,20)
	)

/obj/structure/geyser/planetary/phorogenic
	desc = "An ominous outcropping."

	allowed_reagents = list(
		"energetic_phoron" = list(5,10)
	)

/obj/structure/geyser/truerandom
	name = "strange vent"

/obj/structure/geyser/truerandom/get_allowed_reagents()
	var/list/allowed_reagents = list()
	for(var/I = 1, I <= max_reagent_picks, I++)
		allowed_reagents[pick(SSchemistry.chemical_reagents)] = list(rand(1,5), rand(5,10))
	return ..()
