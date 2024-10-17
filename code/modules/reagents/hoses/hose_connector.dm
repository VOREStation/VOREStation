
/obj/item/stack/hose
	name = "plastic tubing"
	singular_name = "plastic tube"
	desc = "A non-reusable plastic tube for moving reagents to and fro. It looks flimsy."

	description_info = "This tubing may be used to join two hose sockets, if able.<br>\
	Clicking on an object with a connector, such as a water tank, will display a list of possible sockets.<br>\
	Neutral can link to all socket types, and Input/Output sockets can link to all but their own type.<br><br>\
	" + span_warning("This hose does not stretch. The maximum distance you can move two objects from eachother\
	without snapping the tube is determined by distance upon connection.")

	icon = 'icons/obj/machines/reagent.dmi'
	icon_state = "hose"
	origin_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 1)
	amount = 1
	w_class = ITEMSIZE_SMALL
	no_variants = TRUE

	var/obj/item/hose_connector/remembered = null

/obj/item/stack/hose/Destroy()
	remembered = null
	..()

/obj/item/stack/hose/CtrlClick(mob/user)
	if(remembered)
		to_chat(user, span_notice("You wind \the [src] back up."))
		remembered = null
	return

/obj/item/stack/hose/afterattack(var/atom/target, var/mob/living/user, proximity, params)
	if(!proximity)
		return

	var/list/available_sockets = list()

	for(var/obj/item/hose_connector/HC in target.contents)
		if(!HC.my_hose)
			if(remembered)
				if(HC.flow_direction == HOSE_NEUTRAL || HC.flow_direction != remembered.flow_direction)
					available_sockets |= HC

			else
				available_sockets |= HC

	if(LAZYLEN(available_sockets))
		if(available_sockets.len == 1)
			var/obj/item/hose_connector/AC = available_sockets[1]
			if(remembered && remembered.valid_connection(AC))
				var/distancetonode = get_dist(remembered,AC)
				if(distancetonode > world.view)
					to_chat(user, span_notice("\The [src] would probably burst if it were this long."))
				else if(distancetonode <= amount)
					to_chat(user, span_notice("You join \the [remembered] to \the [AC]"))
					remembered.setup_hoses(AC)
					use(distancetonode)
					remembered = null
				else
					to_chat(user, span_notice("You do not have enough tubing to connect the sockets."))

			else
				remembered = AC
				to_chat(user, span_notice("You connect one end of tubing to \the [AC]."))

		else
			var/choice = tgui_input_list(usr, "Select a target hose connector.", "Socket Selection", available_sockets)

			if(choice)
				var/obj/item/hose_connector/CC = choice
				if(remembered)
					if(remembered.valid_connection(CC))
						var/distancetonode = get_dist(remembered, CC)
						if(distancetonode > world.view)
							to_chat(user, span_notice("\The [src] would probably burst if it were this long."))
						else if(distancetonode <= amount)
							to_chat(user, span_notice("You join \the [remembered] to \the [CC]"))

							remembered.setup_hoses(CC)
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
