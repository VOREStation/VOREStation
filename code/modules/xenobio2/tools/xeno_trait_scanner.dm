/obj/item/analyzer/xeno_analyzer
	name = "exotic biological analyzer"
	desc = "A device to investigate the genetic data of a biological target."
	var/form_title
	var/last_data

/obj/item/analyzer/xeno_analyzer/proc/print_report_verb()
	set name = "Print Plant Report"
	set category = "Object"
	set src = usr

	if(usr.stat || usr.restrained() || usr.lying)
		return
	print_report(usr)

/obj/item/analyzer/xeno_analyzer/Topic(href, href_list)
	if(..())
		return
	if(href_list["print"])
		print_report(usr)

/obj/item/analyzer/xeno_analyzer/proc/print_report(var/mob/living/user)
	if(!last_data)
		to_chat(user, "There is no scan data to print.")
		return
	var/obj/item/paper/P = new /obj/item/paper(get_turf(src))
	P.name = "paper - [form_title]"
	P.info = "[last_data]"
	if(ishuman(user))
		user.put_in_hands(P)
	user.visible_message("\The [src] spits out a piece of paper.")
	return

/obj/item/analyzer/xeno_analyzer/attack_self(mob/user as mob)
	print_report(user)
	return 0

/obj/item/analyzer/xeno_analyzer/afterattack(var/target, mob/user, flag)
	if(!flag) return

	var/datum/xeno/traits/trait_info
	var/datum/reagents/prod_reagents
	var/targetName
	var/growth_level
	var/growth_max
	if(istype(target,/obj/structure/table))
		return ..()
	else if(istype(target,/mob/living/simple_mob/xeno))

		var/mob/living/simple_mob/xeno/X = target
		if(istype(X, /mob/living/simple_mob/xeno/slime))
			var/mob/living/simple_mob/xeno/slime/S = X
			if(S.is_child)
				growth_level = S.growthcounter
				growth_max = S.growthpoint

		targetName = X.name
		trait_info = X.traitdat

	else if(istype(target,/obj/item/xenoproduct))

		var/obj/item/xenoproduct/P = target
		trait_info = P.traits
		targetName = P.name
		prod_reagents = P.reagents

	if(!trait_info)
		to_chat(user, span_danger("[src] can tell you nothing about \the [target]."))
		return

	form_title = "[targetName]"
	var/dat = "<h3>Biological data for [form_title]</h3>"
	user.visible_message(span_notice("[user] runs the scanner over \the [target]."))

	dat += "<h2>General Data</h2>"


	dat += "<tr><td>" + span_bold("Health:  ") + "</td><td>[trait_info.get_trait(TRAIT_XENO_HEALTH)]</td></tr>"

	if(prod_reagents && prod_reagents.reagent_list && prod_reagents.reagent_list.len)
		dat += "<h2>Reagent Data</h2>"

		dat += "<br>This sample contains: "
		for(var/datum/reagent/R in prod_reagents.reagent_list)
			dat += "<br>- [R.name], [prod_reagents.get_reagent_amount(R.id)] unit(s)"

	dat += "<h2>Other Data</h2>"

	if(trait_info.get_trait(TRAIT_XENO_EATS))
		dat += "This subject requires nutritional intake.<br>"

	if(trait_info.get_trait(TRAIT_XENO_HUNGER))
		if(trait_info.get_trait(TRAIT_XENO_HUNGER) < 7)
			dat += "It appears to have a slower metabolism.<br>"
		else if(trait_info.get_trait(TRAIT_XENO_HUNGER) > 15)
			dat += "It appears to have a greater metabolism.<br>"
		else
			dat += "It appears to have an average metabolism.<br>"

	if(trait_info.get_trait(TRAIT_IMMUTABLE) == -1)
		dat += "This plant is highly mutable.<br>"
	else if(trait_info.get_trait(TRAIT_IMMUTABLE) > 0)
		dat += "This plant does not possess genetics that are alterable.<br>"

	if(trait_info.get_trait(TRAIT_XENO_HEALTH))
		if(trait_info.get_trait(TRAIT_XENO_HEALTH) < 20)
			dat += "It bears characteristics that indicate resilience to damage.<br>"
		else if(trait_info.get_trait(TRAIT_XENO_HEALTH) > 10)
			dat += "It bears characteristics that indicate susceptibility to damage.<br>"
		else
			dat += "It bears no characters indicating resilience to damage.<br>"

	if(growth_max)
		if(growth_level < 35)
			dat += "It appears to be far to growing up.<br>"
		else if(growth_level > 40)
			dat += "It appears to be close to growing up.<br>"
		else
			dat += "It appears to be growing.<br>"
	else
		dat += "It appears to be fully grown.<br>"

	if(trait_info.get_trait(TRAIT_XENO_COLDRES))
		if(trait_info.get_trait(TRAIT_XENO_COLDRES) < 10)
			dat += "It bears characteristics that indicate resilience to colder temperatures.<br>"
		else if(trait_info.get_trait(TRAIT_XENO_COLDRES) > 20)
			dat += "It bears characteristics that indicate susceptibility to colder temperatures.<br>"

	if(trait_info.get_trait(TRAIT_XENO_HEATRES))
		if(trait_info.get_trait(TRAIT_XENO_HEATRES) < 10)
			dat += "It bears characteristics that indicate resilience to warmer temperatures.<br>"
		else if(trait_info.get_trait(TRAIT_XENO_HEATRES) > 20)
			dat += "It bears characteristics that indicate susceptibility to warmer temperatures.<br>"

	if(trait_info.get_trait(TRAIT_XENO_SPEED))
		if(trait_info.get_trait(TRAIT_XENO_SPEED) < 0)
			dat += "It appears to be agile.<br>"
		else if(trait_info.get_trait(TRAIT_XENO_SPEED) > 0)
			dat += "It appears to be slower.<br>"

	if(trait_info.get_trait(TRAIT_XENO_CANSPEAK))
		dat += "<br>The subject appears to be able to articulate."

	if(trait_info.get_trait(TRAIT_XENO_SPEAKCHANCE))
		if(trait_info.get_trait(TRAIT_XENO_SPEAKCHANCE) < 10)
			dat += "The subject appears to articulate infrequently.<br>"
		else if(trait_info.get_trait(TRAIT_XENO_SPEAKCHANCE) > 20)
			dat += "The subject appears to articulate frequently.<br>"

	if(trait_info.get_trait(TRAIT_XENO_CANLEARN))
		dat += "<br>The subject appears to have process verbal information."

	if(trait_info.get_trait(TRAIT_XENO_LEARNCHANCE))
		if(trait_info.get_trait(TRAIT_XENO_LEARNCHANCE) < 50)
			dat += "The subject appears to comprehend verbal information infrequently.<br>"
		else if(trait_info.get_trait(TRAIT_XENO_LEARNCHANCE) > 51)
			dat += "The subject appears to comprehend verbal information frequently.<br>"

	if(trait_info.get_trait(TRAIT_XENO_STRENGTH) < 5)
		dat += "It appears to have lower average physical capacity.<br>"
	else if(trait_info.get_trait(TRAIT_XENO_STRENGTH) > 7)
		dat += "It appears to have greater average physical capacity.<br>"

	if(trait_info.get_trait(TRAIT_XENO_STR_RANGE))
		if(trait_info.get_trait(TRAIT_XENO_STR_RANGE) < 50)
			dat += "The subject appears to have more consistent attacks.<br>"
		else if(trait_info.get_trait(TRAIT_XENO_STR_RANGE) > 51)
			dat += "The subject appears to have more varied attacks.<br>"

	if(trait_info.get_trait(TRAIT_XENO_BIOLUMESCENT))
		dat += "<br>It is [trait_info.get_trait(TRAIT_XENO_BIO_COLOR)  ? "<font color='[trait_info.get_trait(TRAIT_XENO_BIO_COLOR)]'>bio-luminescent</font>" : "bio-luminescent"]."

	if(trait_info.get_trait(TRAIT_XENO_HOSTILE))
		dat += "<br>The subject appears to have hostile tendencies."

	if(trait_info.get_trait(TRAIT_XENO_CHROMATIC))
		dat += "<br>The subject appears to have chromatic particles inside of it."


	if(dat)
		last_data = dat
		dat += "<br><br>\[<a href='byond://?src=\ref[src];print=1'>print report</a>\]"
		user << browse("<html>[dat]</html>","window=xeno_analyzer")

	return
