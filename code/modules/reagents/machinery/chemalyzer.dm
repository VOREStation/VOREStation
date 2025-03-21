// Detects reagents inside most containers, and acts as an infinite identification system for reagent-based unidentified objects.

/obj/machinery/chemical_analyzer
	name = "chem analyzer PRO"
	desc = "New and improved! Used to precisely scan chemicals and other liquids inside various containers. \
	It can also identify the liquid contents of unknown objects and their chemical breakdowns."
	description_info = "This machine will try to tell you what reagents are inside of something capable of holding reagents. \
	It is also used to 'identify' specific reagent-based objects with their properties obscured from inspection by normal means."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "chem_analyzer"
	density = TRUE
	anchored = TRUE
	use_power = TRUE
	idle_power_usage = 20
	clicksound = "button"
	var/analyzing = FALSE

/obj/machinery/chemical_analyzer/update_icon()
	icon_state = "chem_analyzer[analyzing ? "-working":""]"

/obj/machinery/chemical_analyzer/attackby(obj/item/I, mob/living/user)
	if(!istype(I))
		return ..()

	if(default_deconstruction_screwdriver(user, I))
		return
	if(default_deconstruction_crowbar(user, I))
		return

	if(istype(I,/obj/item/reagent_containers))
		analyzing = TRUE
		update_icon()
		to_chat(user, span_notice("Analyzing \the [I], please stand by..."))

		if(!do_after(user, 2 SECONDS, src))
			to_chat(user, span_warning("Sample moved outside of scan range, please try again and remain still."))
			analyzing = FALSE
			update_icon()
			return

		// First, identify it if it isn't already.
		if(!I.is_identified(IDENTITY_FULL))
			var/datum/identification/ID = I.identity
			if(ID.identification_type == IDENTITY_TYPE_CHEMICAL) // This only solves chemical-based mysteries.
				I.identify(IDENTITY_FULL, user)

		// Now tell us everything that is inside.
		var/final_message = ""
		if(I.reagents && I.reagents.reagent_list.len)
			final_message += "<br>" // To add padding between regular chat and the output.
			for(var/datum/reagent/R in I.reagents.reagent_list)
				if(!R.name)
					continue
				final_message += span_notice("*=*=*=*= Contains " + span_info("[R.volume]u") + " of " + span_bold(span_underline("[R.name]")) + " =*=*=*=*<br>[R.description][R.from_belly ? " Something seems strange about it...? (OOC: It's from a belly!)" : ""]<br><br>")
				/* Downstream addiction code
				if(R.id in addictives)
					final_message += span_boldnotice(span_red("DANGER") + ", [(R.id in fast_addictives) ? "highly " : ""]addictive.)") + "<br>"
				*/
				var/list/products = SSchemistry.chemical_reactions_by_product[R.id]
				if(products != null && products.len > 0)
					var/segment = 1
					var/list/display_reactions = list()
					for(var/decl/chemical_reaction/CR in products)
						// if(!CR.spoiler) - Downstream self documenting wiki code
						display_reactions.Add(CR)
					for(var/decl/chemical_reaction/CR in display_reactions)
						if(display_reactions.len == 1)
							final_message += span_underline("Potential Chemical breakdown: <br>")
						else
							final_message += span_underline("Potential Chemical breakdown [segment]: <br>")
						segment += 1

						if(istype(CR,/decl/chemical_reaction/instant/slime))
							// Handle slimes
							var/decl/chemical_reaction/instant/slime/SR = CR
							if(SR.required)
								var/slime_path = SR.required
								final_message += " -core [span_info(initial(slime_path:name))]<br>"
								for(var/RQ in CR.required_reagents)
									var/decl/chemical_reaction/r_RQ = SSchemistry.chemical_reagents[RQ]
									if(!r_RQ)
										continue
									final_message += " -inducer [span_info(r_RQ.name)]<br>"
						else
							// Standard
							for(var/RQ in CR.required_reagents)
								var/decl/chemical_reaction/r_RQ = SSchemistry.chemical_reagents[RQ]
								if(!r_RQ)
									continue
								final_message += " -parts [span_info(r_RQ.name)]<br>"
							for(var/IH in CR.inhibitors)
								var/decl/chemical_reaction/r_IH = SSchemistry.chemical_reagents[IH]
								if(!r_IH)
									continue
								final_message += " -inhbi [span_info(r_IH.name)]<br>"
							for(var/CL in CR.catalysts)
								var/decl/chemical_reaction/r_CL = SSchemistry.chemical_reagents[CL]
								if(!r_CL)
									continue
								final_message += " -catyl [span_info(r_CL.name)]<br>"
						final_message += "<br>"
				else
					final_message += span_underline("Potential Chemical breakdown:") + "<br>" + span_red("UNKNOWN OR BASE-REAGENT") + "<br><br>"
				var/list/distilled_products = SSchemistry.distilled_reactions_by_product[R.id]
				if(distilled_products != null && distilled_products.len > 0)
					var/segment = 1

					var/list/display_reactions = list()
					for(var/decl/chemical_reaction/distilling/CR in distilled_products)
						// if(!CR.spoiler) - Downstream self documenting wiki code
						display_reactions.Add(CR)

					for(var/decl/chemical_reaction/distilling/CR in display_reactions)
						if(display_reactions.len == 1)
							final_message += span_underline("Potential Chemical Distillation: <br>")
						else
							final_message += span_underline("Potential Chemical Distillation [segment]: <br>")
						segment += 1

						final_message += " -temps " + span_info("[CR.temp_range[1]]k") + " - " + span_info("[CR.temp_range[2]]k") + "<br>"

						for(var/RQ in CR.required_reagents)
							var/decl/chemical_reaction/r_RQ = SSchemistry.chemical_reagents[RQ]
							if(!r_RQ)
								continue
							final_message += " -parts [span_info(r_RQ.name)]<br>"
						for(var/IH in CR.inhibitors)
							var/decl/chemical_reaction/r_IH = SSchemistry.chemical_reagents[IH]
							if(!r_IH)
								continue
							final_message += " -inhbi [span_info(r_IH.name)]<br>"
						for(var/CL in CR.catalysts)
							var/decl/chemical_reaction/r_CL = SSchemistry.chemical_reagents[CL]
							if(!r_CL)
								continue
							final_message += " -catyl [span_info(r_CL.name)]<br>"
					final_message += "<br>"

				// We can get some reagents by grinding sheets and ores!
				var/grind_results = ""
				for(var/source in global.sheet_reagents)
					if(R.id in global.sheet_reagents[source])
						var/nm = initial(source:name)
						grind_results += " -grind [span_info(nm)]<br>"
				if(grind_results != "")
					final_message += span_underline("Material Sources: <br>")
					final_message += grind_results
					final_message += "<br>"

				grind_results = ""
				for(var/source in global.ore_reagents)
					if(R.id in global.ore_reagents[source])
						var/nm = initial(source:name)
						grind_results += " -grind [span_info(nm)]<br>"
				if(grind_results != "")
					final_message += span_underline("Ore Sources: <br>")
					final_message += grind_results
					final_message += "<br>"

				// The long forgotten fluid pumps!
				// TODO : Update turfs to provide what their fluidpump outputs are too
				var/pump_results = ""
				for(var/O in GLOB.ore_data)
					var/ore/OR = GLOB.ore_data[O]
					if(OR.reagent == R.id)
						pump_results += " -erosion [span_info(OR.display_name)]<br>"
				if(pump_results != "")
					final_message += span_underline("Fluid Pump Filtrate: <br>")
					final_message += pump_results
					final_message += "<br>"

				var/makes_result = ""
				var/list/instant_by_reagent = SSchemistry.instant_reactions_by_reagent["[R.id]"]
				if(instant_by_reagent && instant_by_reagent.len)
					for(var/i = 1, i <= instant_by_reagent.len, i++)
						var/decl/chemical_reaction/OR = instant_by_reagent[i]
						if(istype(OR,/decl/chemical_reaction/instant/slime)) // very bloated and meant to be a mystery
							continue
						makes_result += " -[span_info(OR.name)]<br>"

				var/list/distilled_by_reagent = SSchemistry.distilled_reactions_by_reagent["[R.id]"]
				if(distilled_by_reagent && distilled_by_reagent.len)
					for(var/i = 1, i <= distilled_by_reagent.len, i++)
						var/decl/chemical_reaction/OR = distilled_by_reagent[i]
						makes_result += " -[span_info(OR.name)]<br>"

				if(makes_result != "")
					final_message += span_underline("Can Be Used To Produce: <br>")
					final_message += makes_result
					final_message += "<br>"

		final_message += "Scanning of \the [I] complete."

		to_chat(user, span_notice(final_message))
		analyzing = FALSE
		update_icon()
		return
