
/obj/item/stack/hose
	name = "plastic tubing"
	singular_name = "plastic tube"
	desc = "A plastic tube for moving reagents to and fro. Stretching it too far will cause it to disconnect."

	description_info = "This tubing may be used to join two hose sockets, if able.<br>\
	Clicking on an object with a connector, such as a water tank, will display a list of possible sockets.<br>\
	Neutral can link to all socket types, and Input/Output sockets can link to all but their own type.<br><br>\
	" + span_warning("This hose does not stretch. The maximum distance you can move two objects from eachother\
	without disconnecting the tube is determined by distance upon connection.")

	icon = 'icons/obj/machines/reagent.dmi'
	icon_state = "hose"
	origin_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 1)
	amount = 1
	w_class = ITEMSIZE_SMALL
	no_variants = TRUE

	var/datum/component/hose_connector/remembered = null

/obj/item/stack/hose/Destroy()
	remembered = null
	. = ..()

/obj/item/stack/hose/CtrlClick(mob/user)
	if(remembered)
		to_chat(user, span_notice("You wind \the [src] back up."))
		remembered = null
	return

/obj/item/stack/hose/afterattack(var/atom/target, var/mob/living/user, proximity, params)
	if(!proximity)
		return

	var/list/available_sockets = list()
	for(var/datum/component/hose_connector/HC in target.GetComponents(/datum/component/hose_connector))
		if(!HC.get_hose())
			if(remembered)
				if(HC.get_flow_direction() == HOSE_NEUTRAL || HC.get_flow_direction() != remembered.get_flow_direction())
					available_sockets |= HC

			else
				available_sockets |= HC

	if(LAZYLEN(available_sockets))
		if(available_sockets.len == 1)
			var/datum/component/hose_connector/AC = available_sockets[1]
			if(remembered && remembered.get_carrier() == AC.get_carrier())
				to_chat(user, span_notice("Connecting \the [remembered.get_carrier()] to itself seems like a bad idea."))

			else if(remembered && remembered.valid_connection(AC))
				var/distancetonode = get_dist(remembered.get_carrier(),AC.get_carrier())
				if(distancetonode > world.view)
					to_chat(user, span_notice("\The [src] would probably burst if it were this long."))

				else if(distancetonode <= amount)
					to_chat(user, span_notice("You join \the [remembered] to \the [AC]."))
					remembered.setup_hoses(AC,distancetonode)
					use(distancetonode)
					remembered = null
				else
					to_chat(user, span_notice("You do not have enough tubing to connect the sockets."))

			else
				remembered = AC
				to_chat(user, span_notice("You connect one end of tubing to \the [AC]."))

		else
			var/choice = tgui_input_list(user, "Select a target hose connector.", "Socket Selection", available_sockets)

			if(choice)
				var/datum/component/hose_connector/CC = choice
				if(remembered)
					if(remembered.get_carrier() == CC.get_carrier())
						to_chat(user, span_notice("Connecting \the [remembered.get_carrier()] to itself seems like a bad idea."))

					if(remembered.valid_connection(CC))
						var/distancetonode = get_dist(remembered.get_carrier(), CC.get_carrier())
						if(distancetonode > world.view)
							to_chat(user, span_notice("\The [src] would probably burst if it were this long."))

						else if(distancetonode <= amount)
							to_chat(user, span_notice("You join \the [remembered] to \the [CC]"))

							remembered.setup_hoses(CC,distancetonode)
							use(distancetonode)
							remembered = null

						else
							to_chat(user, span_notice("You do not have enough tubing to connect the sockets."))

				else
					remembered = CC
					to_chat(user, span_notice("You connect one end of tubing to \the [CC]."))

		return

	else
		..()
