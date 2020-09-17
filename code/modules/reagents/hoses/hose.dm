
GLOBAL_LIST_EMPTY(hoses)

/obj/effect/ebeam/hose
	plane = OBJ_PLANE
	layer = STAIRS_LAYER

/datum/hose
	var/name = "hose"

	var/obj/item/hose_connector/node1 = null
	var/obj/item/hose_connector/node2 = null

	var/hose_color = "#ffffff"

	var/initial_distance = 7

	var/datum/beam/hose = null

/datum/hose/proc/get_pairing(var/obj/item/hose_connector/target)
	if(target)
		if(target == node1)
			return node2
		else if(target == node2)
			return node1

	return

/datum/hose/proc/disconnect()
	if(node1)
		node1.disconnect()
		node1 = null
	if(node2)
		node2.disconnect()
		node2 = null

/datum/hose/proc/set_hose(var/obj/item/hose_connector/target1, var/obj/item/hose_connector/target2)
	if(target1 && target2)
		node1 = target1
		node2 = target2

	node1.connect(src)
	node2.connect(src)

	name = "[name] ([node1],[node2])"

	initial_distance = get_dist(get_turf(node1), get_turf(node2))

	GLOB.hoses |= src
	START_PROCESSING(SSobj, src)

/datum/hose/process()
	if(node1 && node2)
		if(get_dist(get_turf(node1), get_turf(node2)) > 0)
			hose = node1.loc.Beam(node2.loc, icon_state = "hose", beam_color = hose_color, maxdistance = world.view, beam_type = /obj/effect/ebeam/hose)

			if(!hose || get_dist(get_turf(node1), get_turf(node2)) > initial_distance)	// The hose didn't form. Something's fucky.
				disconnect()
				return

		var/datum/reagents/reagent_node1 = node1.reagents
		var/datum/reagents/reagent_node2 = node2.reagents

		switch(node1.flow_direction)	// Node 1 is the default 'master', interactions are considered in all current possible states in regards to it, however.
			if(HOSE_INPUT)
				if(node2.flow_direction == HOSE_NEUTRAL)	// We're input, they're neutral. Take half of our volume.
					reagent_node2.trans_to_holder(reagent_node1, reagent_node1.maximum_volume / 2)
				else if(node2.flow_direction == HOSE_OUTPUT)	// We're input, they're output. Take all of our volume.
					reagent_node2.trans_to_holder(reagent_node1, reagent_node1.maximum_volume)

			if(HOSE_OUTPUT)	// We're output, give all of their maximum volume.
				reagent_node1.trans_to_holder(reagent_node2, reagent_node2.maximum_volume)

			if(HOSE_NEUTRAL)
				switch(node2.flow_direction)
					if(HOSE_INPUT)	// We're neutral, they're input. Give them half of their volume.
						reagent_node1.trans_to_holder(reagent_node2, reagent_node2.maximum_volume / 2)

					if(HOSE_NEUTRAL)	// We're neutral, they're neutral. Balance our values.
						var/volume_difference_perc = (reagent_node1.total_volume / reagent_node1.maximum_volume) - (reagent_node2.total_volume / reagent_node2.maximum_volume)
						var/volume_difference = 0

						var/pulling = FALSE
						if(volume_difference_perc > 0)	// They are smaller, so they determine the transfer amount. Half of the difference will equalize.
							volume_difference = reagent_node2.maximum_volume * volume_difference_perc / 2

						else if(volume_difference_perc < 0)	// We're smaller, so we determine the transfer amount. Half of the difference will equalize.
							volume_difference_perc *= -1

							pulling = TRUE

							volume_difference = reagent_node1.maximum_volume * volume_difference_perc / 2

						if(volume_difference)
							if(pulling)
								reagent_node2.trans_to_holder(reagent_node1, volume_difference)
							else
								reagent_node1.trans_to_holder(reagent_node2, volume_difference)

					if(HOSE_OUTPUT)
						reagent_node2.trans_to_holder(reagent_node1, reagent_node2.maximum_volume)

	else
		if(node1)
			node1.disconnect()
			node1 = null
		if(node2)
			node2.disconnect()
			node2 = null

		STOP_PROCESSING(SSobj, src)
		GLOB.hoses -= src
		qdel(src)
